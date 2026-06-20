load("@bazel_skylib//rules:expand_template.bzl", "expand_template")
load("@rules_pandoc//pandoc:pandoc.bzl", "pandoc")

# Assemble markdown from a template + per-document values using bazel_skylib --
# no external template engine, no Python. expand_template does literal {{KEY}}
# substitution; the result is a generated .md that pandoc consumes as a src.
expand_template(
    name = "doc_md",
    out = "doc.md",
    substitutions = {
        "{{TITLE}}": "Example 009",
        "{{PROJECT}}": "starlane",
        "{{REVISION}}": "B",
    },
    template = "doc.md.tmpl",
)

pandoc(
    name = "ex009_html",
    srcs = [":doc_md"],
    format = "html",
    pandoc_args = ["--standalone"],
)
