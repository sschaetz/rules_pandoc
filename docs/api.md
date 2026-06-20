<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Public entry point for the pandoc rule.

<a id="pandoc"></a>

## pandoc

<pre>
load("@rules_pandoc//pandoc:pandoc.bzl", "pandoc")

pandoc(<a href="#pandoc-name">name</a>, <a href="#pandoc-srcs">srcs</a>, <a href="#pandoc-data">data</a>, <a href="#pandoc-out">out</a>, <a href="#pandoc-format">format</a>, <a href="#pandoc-from_format">from_format</a>, <a href="#pandoc-metadata">metadata</a>, <a href="#pandoc-pandoc_args">pandoc_args</a>, <a href="#pandoc-reference_doc">reference_doc</a>, <a href="#pandoc-template">template</a>,
       <a href="#pandoc-variables">variables</a>)
</pre>

Convert one or more documents with pandoc.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="pandoc-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="pandoc-srcs"></a>srcs |  Input documents, concatenated in the order listed.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | required |  |
| <a id="pandoc-data"></a>data |  Images, templates, includes, etc. Their directories are added to --resource-path.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="pandoc-out"></a>out |  Output file. Defaults to <name>.<ext> for the chosen format.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="pandoc-format"></a>format |  Output format.   | String | required |  |
| <a id="pandoc-from_format"></a>from_format |  Input format passed to --from. If unset, pandoc infers it from the source extension.   | String | optional |  `""`  |
| <a id="pandoc-metadata"></a>metadata |  Document metadata passed as --metadata key=value (e.g. title, author, lang). Affects output properties; visible to templates and filters.   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  `{}`  |
| <a id="pandoc-pandoc_args"></a>pandoc_args |  Additional arguments passed verbatim to pandoc.   | List of strings | optional |  `[]`  |
| <a id="pandoc-reference_doc"></a>reference_doc |  Style-reference document for docx/odt/pptx output, passed as --reference-doc. pandoc copies its styles into the output. Declared as an input automatically.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="pandoc-template"></a>template |  Custom pandoc template with $placeholder$ slots, passed as --template (for text formats like html/latex). Declared as an input automatically.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="pandoc-variables"></a>variables |  Template variables passed as --variable key=value. Fill $var$ placeholders in templates only.   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  `{}`  |


<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Public entry point for the pandoc_pdf rule.

<a id="pandoc_pdf"></a>

## pandoc_pdf

<pre>
load("@rules_pandoc//pandoc:pandoc_pdf.bzl", "pandoc_pdf")

pandoc_pdf(<a href="#pandoc_pdf-name">name</a>, <a href="#pandoc_pdf-srcs">srcs</a>, <a href="#pandoc_pdf-data">data</a>, <a href="#pandoc_pdf-out">out</a>, <a href="#pandoc_pdf-metadata">metadata</a>, <a href="#pandoc_pdf-pandoc_args">pandoc_args</a>, <a href="#pandoc_pdf-template">template</a>, <a href="#pandoc_pdf-variables">variables</a>)
</pre>

Convert documents to PDF with pandoc, using typst as the PDF engine.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="pandoc_pdf-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="pandoc_pdf-srcs"></a>srcs |  Input documents, concatenated in the order listed.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | required |  |
| <a id="pandoc_pdf-data"></a>data |  Images, templates, includes, etc. Their directories are added to --resource-path.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="pandoc_pdf-out"></a>out |  Output PDF. Defaults to <name>.pdf.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="pandoc_pdf-metadata"></a>metadata |  Document metadata passed as --metadata key=value (e.g. title, author, lang). Affects output properties; visible to templates and filters.   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  `{}`  |
| <a id="pandoc_pdf-pandoc_args"></a>pandoc_args |  Additional arguments passed verbatim to pandoc.   | List of strings | optional |  `[]`  |
| <a id="pandoc_pdf-template"></a>template |  Custom typst template, passed as --template. Uses pandoc $placeholder$ syntax (e.g. $title$, $body$) -- pandoc fills it and typst compiles the result. Declared as an input automatically.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="pandoc_pdf-variables"></a>variables |  Template variables passed as --variable key=value. Fill $var$ placeholders in templates only.   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  `{}`  |


