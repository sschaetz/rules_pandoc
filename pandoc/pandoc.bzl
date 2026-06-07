"""Public entry point for the pandoc rule."""

load(
    "//pandoc/private:pandoc.bzl",
    _pandoc = "pandoc",
)

pandoc = _pandoc
