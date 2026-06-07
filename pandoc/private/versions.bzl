"""Pandoc versions.

A mapping of version -> platform -> archive metadata used by the module
extension to fetch pandoc binaries.

Fill in entries with the download URL, the Bazel `integrity` value
(sha256-<base64>), and the `strip_prefix` to apply to the archive so that the
pandoc binary ends up at `bin/pandoc` (Unix) or `pandoc.exe` (Windows).

Recognized platform keys (see _CONSTRAINTS in extensions.bzl):
    linux-x86_64, linux-aarch64, macos-x86_64, macos-aarch64, windows-x86_64
"""

PANDOC_VERSIONS = {
    "3.10": {
        "macos-aarch64": {
            "urls": ["https://github.com/jgm/pandoc/releases/download/3.10/pandoc-3.10-arm64-macOS.zip"],
            "integrity": "sha256-2crQHZaud0oNyMjEW7GtPkxf8swuJPRZWPX5t5dK7jQ=",
            "strip_prefix": "pandoc-3.10-arm64",
        },
    },
}
