load("@rules_pandoc//pandoc:pandoc.bzl", "pandoc")

# Shared semantic metadata (-M): title/author/date flow into the output.
_META = {
    "title": "Example 004",
    "author": "rules_pandoc",
    "date": "2026-06-09",
}

# metadata (-M) vs variables (-V): the title block comes from metadata; the
# subtitle is a template-only variable.
pandoc(
    name = "ex004_html",
    srcs = ["ex004.md"],
    format = "html",
    metadata = _META,
    pandoc_args = ["--standalone"],
    variables = {"subtitle": "metadata vs variables"},
)

# Exercises the epub output (epub requires a title, supplied via metadata).
pandoc(
    name = "ex004_epub",
    srcs = ["ex004.md"],
    format = "epub",
    metadata = _META,
)

# Exercises the odt output.
pandoc(
    name = "ex004_odt",
    srcs = ["ex004.md"],
    format = "odt",
    metadata = _META,
)
