# rules_pandoc

Work in progress. Bazel rules for [pandoc](https://pandoc.org/), inspired by [rules_typst](https://github.com/periareon/rules_typst).

Full attribute reference: [docs/api.md](docs/api.md).

## Examples

The three most common pandoc workflows (based on a survey of real-world usage):

### Markdown → PDF

Uses [typst](https://typst.app/) as the PDF engine, fetched by Bazel — no LaTeX install required.

```bazel
load("@rules_pandoc//pandoc:pandoc_pdf.bzl", "pandoc_pdf")

pandoc_pdf(
    name = "report_pdf",
    srcs = ["report.md"],
    metadata = {"title": "Quarterly Report", "author": "Stefan"},
)
```

### Markdown → standalone HTML with a table of contents

```bazel
load("@rules_pandoc//pandoc:pandoc.bzl", "pandoc")

pandoc(
    name = "report_html",
    srcs = ["report.md"],
    format = "html",
    metadata = {"title": "Quarterly Report"},
    pandoc_args = ["--standalone", "--toc"],
)
```

### Markdown → Word (docx) with custom styles

```bazel
load("@rules_pandoc//pandoc:pandoc.bzl", "pandoc")

pandoc(
    name = "report_docx",
    srcs = ["report.md"],
    format = "docx",
    reference_doc = "corporate-style.docx",
)
```

See [`examples/`](examples/) for runnable versions of these and more (images, generated inputs, templates, git-sha stamping).

## TODO

- [x] CI
- [x] support Windows (CI green across the full matrix incl. windows-2022; PDF image embedding pending artifact verification — see below)
- [x] add more platforms
- [x] add more versions
- [x] consider dropping dependency on rules_typst
- [x] more examples, cleaner structure
- [x] add a `template` example: an `article.typ` with a custom layout, wired through `pandoc_pdf(template = ...)`.
- [x] add buildify pre commit and CI step
- [x] switch ex002's docx target to PDF-via-typst so SVGs render without `rsvg-convert`.
- [ ] release to bazel registry
