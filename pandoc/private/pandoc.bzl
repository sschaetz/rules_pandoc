"""The pandoc rule."""

load(":toolchain.bzl", "TOOLCHAIN_TYPE")

def _resource_dir(f):
    """The exec-tree directory matching the root of f's package.

    Document references are written relative to the package (e.g.
    "assets/img.svg"), so joining this directory with such a reference yields
    f's actual location -- whether f is a source or generated file, flat or
    nested. f.root.path is "" for sources and "bazel-out/<cfg>/bin" for
    generated files; f.owner.package is the package path.
    """
    parts = [p for p in [f.root.path, f.owner.package] if p]
    return "/".join(parts) if parts else "."

# Maps the `format` attribute to (pandoc writer for --to, output file extension).
_FORMATS = {
    "docx": ("docx", "docx"),
    "epub": ("epub", "epub"),
    "gfm": ("gfm", "md"),
    "html": ("html5", "html"),
    "latex": ("latex", "tex"),
    "odt": ("odt", "odt"),
    "typst": ("typst", "typ"),
}

def _add_metadata_and_variables(args, ctx):
    """Append --metadata/--variable key=value pairs from the dict attrs.

    metadata (-M) sets semantic document data (title, author, lang, ...) that
    flows into output properties and is visible to templates and filters.
    variables (-V) sets template-only knobs that fill $var$ placeholders.
    """
    for key, value in ctx.attr.metadata.items():
        args.add("--metadata", "{}={}".format(key, value))
    for key, value in ctx.attr.variables.items():
        args.add("--variable", "{}={}".format(key, value))

# Attributes shared by the pandoc and pandoc_pdf rules.
_COMMON_ATTRS = {
    "metadata": attr.string_dict(
        doc = "Document metadata passed as --metadata key=value (e.g. title, " +
              "author, lang). Affects output properties; visible to templates " +
              "and filters.",
    ),
    "variables": attr.string_dict(
        doc = "Template variables passed as --variable key=value. Fill $var$ " +
              "placeholders in templates only.",
    ),
}

def _pandoc_impl(ctx):
    pandoc_info = ctx.toolchains[TOOLCHAIN_TYPE].pandoc_info
    compiler = pandoc_info.compiler
    all_files = pandoc_info.all_files

    writer, ext = _FORMATS[ctx.attr.format]
    out = ctx.outputs.out
    if not out:
        out = ctx.actions.declare_file("{}.{}".format(ctx.label.name, ext))

    args = ctx.actions.args()
    args.add("--to", writer)
    if ctx.attr.from_format:
        args.add("--from", ctx.attr.from_format)
    args.add("--output", out)

    # Resolve images/templates/includes via a search path anchored at each
    # input's package root, so references written relative to the document
    # resolve regardless of source/generated or flat/nested layout. (Bazel's
    # action sandbox already limits IO to declared inputs, so pandoc's own
    # --sandbox is redundant here; it is also omitted because it blocks reading
    # resource-path files in pandoc >= 3.x.)
    resource_dirs = depset([_resource_dir(f) for f in ctx.files.srcs + ctx.files.data])
    args.add_joined("--resource-path", resource_dirs, join_with = pandoc_info.path_list_separator)

    _add_metadata_and_variables(args, ctx)

    # Escape hatch for arbitrary flags, then the positional inputs last.
    args.add_all(ctx.attr.pandoc_args)
    args.add_all(ctx.files.srcs)

    ctx.actions.run(
        mnemonic = "Pandoc",
        executable = compiler,
        arguments = [args],
        inputs = depset(ctx.files.srcs + ctx.files.data),
        outputs = [out],
        tools = all_files,
        env = {"SOURCE_DATE_EPOCH": "0"},
    )

    return [DefaultInfo(files = depset([out]))]

pandoc = rule(
    doc = "Convert one or more documents with pandoc.",
    implementation = _pandoc_impl,
    attrs = dict(_COMMON_ATTRS, **{
        "data": attr.label_list(
            doc = "Images, templates, includes, etc. Their directories are " +
                  "added to --resource-path.",
            allow_files = True,
        ),
        "format": attr.string(
            doc = "Output format.",
            values = _FORMATS.keys(),
            mandatory = True,
        ),
        "from_format": attr.string(
            doc = "Input format passed to --from. If unset, pandoc infers it " +
                  "from the source extension.",
        ),
        "out": attr.output(
            doc = "Output file. Defaults to <name>.<ext> for the chosen format.",
        ),
        "pandoc_args": attr.string_list(
            doc = "Additional arguments passed verbatim to pandoc.",
        ),
        "srcs": attr.label_list(
            doc = "Input documents, concatenated in the order listed.",
            allow_files = True,
            mandatory = True,
        ),
    }),
    toolchains = [TOOLCHAIN_TYPE],
)

# Provided by rules_typst; supplies the typst binary used as pandoc's PDF engine.
TYPST_TOOLCHAIN_TYPE = "@rules_typst//typst:toolchain_type"

def _pandoc_pdf_impl(ctx):
    pandoc_info = ctx.toolchains[TOOLCHAIN_TYPE].pandoc_info
    typst = ctx.toolchains[TYPST_TOOLCHAIN_TYPE].typstc_info.compiler

    out = ctx.outputs.out
    if not out:
        out = ctx.actions.declare_file("{}.pdf".format(ctx.label.name))

    args = ctx.actions.args()
    # Output extension drives PDF; the engine is the toolchain-provided typst
    # binary, passed by path so nothing needs to be on PATH.
    args.add("--output", out)
    args.add("--pdf-engine", typst)

    # pandoc writes ABSOLUTE media paths into the intermediate .typ (under a temp
    # dir). typst resolves absolute paths relative to --root, so point root at /
    # to make them resolve. Inside Bazel's action sandbox the filesystem is
    # already the security boundary, so this does not widen access.
    args.add("--pdf-engine-opt=--root=/")

    resource_dirs = depset([_resource_dir(f) for f in ctx.files.srcs + ctx.files.data])
    args.add_joined("--resource-path", resource_dirs, join_with = pandoc_info.path_list_separator)

    _add_metadata_and_variables(args, ctx)

    inputs = ctx.files.srcs + ctx.files.data
    if ctx.file.template:
        args.add("--variable", "template=%s" % ctx.file.template.path)
        inputs.append(ctx.file.template)

    args.add_all(ctx.attr.pandoc_args)
    args.add_all(ctx.files.srcs)

    ctx.actions.run(
        mnemonic = "PandocPdf",
        executable = pandoc_info.compiler,
        arguments = [args],
        inputs = depset(inputs),
        outputs = [out],
        # Only the typst binary itself -- not rules_typst's process_wrapper --
        # so we don't pull in a Rust toolchain we never use.
        tools = depset([typst], transitive = [pandoc_info.all_files]),
        env = {"SOURCE_DATE_EPOCH": "0"},
    )

    return [DefaultInfo(files = depset([out]))]

pandoc_pdf = rule(
    doc = "Convert documents to PDF with pandoc, using typst as the PDF engine.",
    implementation = _pandoc_pdf_impl,
    attrs = dict(_COMMON_ATTRS, **{
        "data": attr.label_list(
            doc = "Images, templates, includes, etc. Their directories are " +
                  "added to --resource-path.",
            allow_files = True,
        ),
        "out": attr.output(
            doc = "Output PDF. Defaults to <name>.pdf.",
        ),
        "pandoc_args": attr.string_list(
            doc = "Additional arguments passed verbatim to pandoc.",
        ),
        "srcs": attr.label_list(
            doc = "Input documents, concatenated in the order listed.",
            allow_files = True,
            mandatory = True,
        ),
        "template": attr.label(
            doc = "Optional typst template, passed as -V template=<path>.",
            allow_single_file = [".typ"],
        ),
    }),
    toolchains = [TOOLCHAIN_TYPE, TYPST_TOOLCHAIN_TYPE],
)
