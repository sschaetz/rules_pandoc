"""Public entry point for the pandoc_pdf rule."""

load(
    "//pandoc/private:pandoc.bzl",
    _pandoc_pdf = "pandoc_pdf",
)

pandoc_pdf = _pandoc_pdf
