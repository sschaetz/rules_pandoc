load("@rules_pandoc//pandoc:pandoc.bzl", "pandoc")
load(":stamp.bzl", "git_stamp")

# Generates a Markdown footer carrying the stamped git SHA. Tagged "manual" so
# the cross-platform CI `bazel build //...` skips it (stamping uses a bash
# workspace-status script). Build explicitly with --stamp; see stamp.bzl.
git_stamp(
    name = "commit_md",
    tags = ["manual"],
)

# The generated snippet is concatenated after the document body, so the SHA
# requires no rule support beyond passing generated srcs (which already works).
pandoc(
    name = "ex005_html",
    srcs = [
        "ex005.md",
        ":commit_md",
    ],
    format = "html",
    pandoc_args = ["--standalone"],
    tags = ["manual"],
)
