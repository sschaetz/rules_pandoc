"""Public entry point for the pandoc_toolchain rule."""

load(
    "//pandoc/private:toolchain.bzl",
    _pandoc_toolchain = "pandoc_toolchain",
)

pandoc_toolchain = _pandoc_toolchain
