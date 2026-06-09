load("@rules_pandoc//pandoc:pandoc.bzl", "pandoc")

# Custom pandoc --template via the typed `template` attribute, which both passes
# the flag and declares the template file as an input (no separate `data` entry
# needed, no silent resolution failure if you forget it).
pandoc(
    name = "ex006_html",
    srcs = ["ex006.md"],
    format = "html",
    template = "template.html",
    metadata = {
        "title": "Example 006",
        "lang": "en",
    },
)
