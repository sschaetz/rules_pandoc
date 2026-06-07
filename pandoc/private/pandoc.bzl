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
    "gfm": ("gfm", "md"),
    "html": ("html5", "html"),
    "latex": ("latex", "tex"),
    "typst": ("typst", "typ"),
}

def _pandoc_impl(ctx):
    compiler = ctx.toolchains[TOOLCHAIN_TYPE].pandoc_info.compiler
    all_files = ctx.toolchains[TOOLCHAIN_TYPE].pandoc_info.all_files

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
    args.add_joined("--resource-path", resource_dirs, join_with = ":")

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
    attrs = {
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
    },
    toolchains = [TOOLCHAIN_TYPE],
)
