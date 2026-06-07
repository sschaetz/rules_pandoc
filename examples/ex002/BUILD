load("@rules_pandoc//pandoc:pandoc.bzl", "pandoc")

# Two separate SVG images, in different directories, embedded into a single
# standalone HTML file. The image directories are surfaced to pandoc via
# --resource-path, which the rule builds from the `data` files' directories.
pandoc(
    name = "ex002_docs",
    srcs = ["ex002.md"],
    data = [
        "img-ex01.svg",
        "assets/img-ex02.svg",
    ],
    format = "docx",
    pandoc_args = [
        "--standalone",
        "--embed-resources",
    ],
)

# Same idea, but the two images are GENERATED (they live under bazel-out, not in
# the source tree). Exercises resource resolution for dependent/generated inputs,
# both flat and nested in a sub-dir.
genrule(
    name = "gen_flat",
    outs = ["gen_flat.svg"],
    cmd = "printf '<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"20\" height=\"20\"><rect width=\"20\" height=\"20\" fill=\"green\"/></svg>' > $@",
)

genrule(
    name = "gen_nested",
    outs = ["sub/gen_nested.svg"],
    cmd = "printf '<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"20\" height=\"20\"><circle cx=\"10\" cy=\"10\" r=\"9\" fill=\"purple\"/></svg>' > $@",
)

pandoc(
    name = "ex002_gen_html",
    srcs = ["ex002_gen.md"],
    data = [
        ":gen_flat",
        ":gen_nested",
    ],
    format = "html",
    pandoc_args = [
        "--standalone",
        "--embed-resources",
    ],
)

# Edge case: the ONLY resource is nested in a sub-dir, with nothing at the
# document's own level. This failed with the per-file-dirname approach; it must
# resolve with the package-root anchor.
pandoc(
    name = "ex002_nested_only_html",
    srcs = ["ex002_nested_only.md"],
    data = [":gen_nested"],
    format = "html",
    pandoc_args = ["--standalone", "--embed-resources"],
)
