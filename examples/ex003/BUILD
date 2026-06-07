load("@rules_pandoc//pandoc:pandoc_pdf.bzl", "pandoc_pdf")

pandoc_pdf(
    name = "ex003_pdf",
    srcs = ["ex003.md"],
    pandoc_args = ["--wrap=none"],
)

pandoc_pdf(
    name = "ex003_img_pdf",
    srcs = ["ex003_img.md"],
    data = ["img.svg"],
    pandoc_args = ["--wrap=none"],
)
