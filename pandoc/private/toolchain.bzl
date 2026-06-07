"""Pandoc toolchain."""

TOOLCHAIN_TYPE = str(Label("//pandoc:toolchain_type"))

PandocToolchainInfo = provider(
    doc = "Information about how to invoke the pandoc compiler.",
    fields = {
        "all_files": "depset[File]: All files needed by pandoc actions.",
        "compiler": "File: The pandoc executable.",
    },
)

def _pandoc_toolchain_impl(ctx):
    all_files = []
    if DefaultInfo in ctx.attr.compiler:
        all_files.extend([
            ctx.attr.compiler[DefaultInfo].files,
            ctx.attr.compiler[DefaultInfo].default_runfiles.files,
        ])

    toolchain_info = platform_common.ToolchainInfo(
        pandoc_info = PandocToolchainInfo(
            compiler = ctx.file.compiler,
            all_files = depset(transitive = all_files),
        ),
    )
    return [toolchain_info]

pandoc_toolchain = rule(
    doc = "Declares a pandoc toolchain from a pandoc executable.",
    implementation = _pandoc_toolchain_impl,
    attrs = {
        "compiler": attr.label(
            doc = "The pandoc executable.",
            allow_single_file = True,
            executable = True,
            mandatory = True,
            cfg = "exec",
        ),
    },
)
