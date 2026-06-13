# rules_pandoc

Work in progress. Bazel rules for [pandoc](https://pandoc.org/), inspired by [rules_typst](https://github.com/periareon/rules_typst).

Full attribute reference: [docs/api.md](docs/api.md).

## Examples

### Markdown → PDF

The simplest case — bundled [typst](https://typst.app/), no LaTeX install required.

```bazel
load("@rules_pandoc//pandoc:pandoc_pdf.bzl", "pandoc_pdf")

pandoc_pdf(
    name = "report_pdf",
    srcs = ["report.md"],
    metadata = {
        "title": "Engineering Requirements Specification",
        "author": "Geordi La Forge",
    },
)
```

### Markdown → a styled PDF document (typst template)

A Markdown source rendered into a branded PDF via a [typst](https://typst.app/)
template ([full setup in `examples/ex008/`](examples/ex008/)):

```bazel
pandoc_pdf(
    name = "spec",
    srcs = ["spec.md"],
    template = "template.typ",
    data = ["assets/logo.svg"],
)
```



### Markdown → standalone HTML with a table of contents

```bazel
load("@rules_pandoc//pandoc:pandoc.bzl", "pandoc")

pandoc(
    name = "report_html",
    srcs = ["report.md"],
    format = "html",
    metadata = {"title": "Engineering Requirements Specification"},
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
    reference_doc = "corporate-id.docx",
)
```

See [`examples/`](examples/) for runnable versions of these and more (images, generated inputs, templates, git-sha stamping).
