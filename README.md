# rules_pandoc

Work on progress. Bazel wrapper for [pandoc](https://pandoc.org/). Inspired by [rules_typst](https://github.com/periareon/rules_typst).

pandoc non-PDF use:

```bazel
load("@rules_pandoc//pandoc:pandoc.bzl", "pandoc")

pandoc(
    name = "mydoc",
    srcs = ["mydoc.md"],
    format = "docx",
)
```

pandoc PDF use, uses [typst](https://typst.app/) as PDF engine

```bazel
load("@rules_pandoc//pandoc:pandoc_pdf.bzl", "pandoc_pdf")

pandoc_pdf(
    name = "ex003_pdf",
    srcs = ["ex003.md"],
    pandoc_args = ["--wrap=none"],
)
```

## TODO

- [ ] CI
- [ ] release to bazel registry
- [ ] support Windows
- [ ] consider dropping dependency on rules_typst
- [ ] more examples, cleaner structure
- [ ] add more versions and more platforms
- [ ] Add a `template` example: an `article.typ` with a custom layout, wired through `pandoc_pdf(template = ...)`.
- [ ] Switch ex002's docx target to PDF-via-typst so SVGs render without `rsvg-convert`.
- [ ] PDF on Windows: `--root=/` is Unix-only; derive typst `--root` from the `$TMP` drive at action time (needs a wrapper).
