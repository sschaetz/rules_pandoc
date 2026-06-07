load("@rules_pandoc//pandoc:pandoc.bzl", "pandoc")

# Two separate SVG images, in different directories, embedded into a single
# standalone HTML file.
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

# Same as above but images are generated
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

# The only resource is nested in a sub-dir, with nothing at the
# document's own level.
pandoc(
    name = "ex002_nested_only_html",
    srcs = ["ex002_nested_only.md"],
    data = [":gen_nested"],
    format = "html",
    pandoc_args = ["--standalone", "--embed-resources"],
)
