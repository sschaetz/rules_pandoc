"""The pandoc rule."""

load(":toolchain.bzl", "TOOLCHAIN_TYPE")

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

    # Restrict pandoc's file IO to inputs we declare; keeps the action hermetic.
    args.add("--sandbox")

    # Resolve images/templates/includes via a search path built from the
    # directories of every data file. This handles source vs. generated inputs
    # (which live in different trees) without staging files into a temp root.
    resource_dirs = depset([f.dirname for f in ctx.files.data])
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
