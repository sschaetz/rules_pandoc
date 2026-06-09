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

- [x] CI
- [x] support Windows (CI green across the full matrix incl. windows-2022; PDF image embedding pending artifact verification — see below)
- [x] add more platforms
- [ ] add more versions
- [ ] consider dropping dependency on rules_typst
- [ ] more examples, cleaner structure
- [ ] add a `template` example: an `article.typ` with a custom layout, wired through `pandoc_pdf(template = ...)`.
- [ ] switch ex002's docx target to PDF-via-typst so SVGs render without `rsvg-convert`.
- [ ] release to bazel registry
