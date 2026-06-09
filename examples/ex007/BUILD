load("@rules_pandoc//pandoc:pandoc.bzl", "pandoc")

# Custom docx styling via the typed `reference_doc` attribute. In practice you
# would restyle reference.docx in Word/LibreOffice; here it is pandoc's own
# default reference doc, which is enough to exercise the wiring.
pandoc(
    name = "ex007_docx",
    srcs = ["ex007.md"],
    format = "docx",
    reference_doc = "sub_dir/reference.docx",
)
