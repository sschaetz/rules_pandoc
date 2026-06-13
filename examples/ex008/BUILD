load("@rules_pandoc//pandoc:pandoc_pdf.bzl", "pandoc_pdf")

pandoc_pdf(
    name = "spec",
    srcs = ["spec.md"],
    template = "template.typ",
    data=["assets/logo.svg"],
)
