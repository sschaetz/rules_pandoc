"""rules_pandoc bzlmod extensions."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("//pandoc/private:versions.bzl", "PANDOC_VERSIONS")

_CONSTRAINTS = {
    "linux-aarch64": [
        "@platforms//os:linux",
        "@platforms//cpu:aarch64",
    ],
    "linux-x86_64": [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    "macos-aarch64": [
        "@platforms//os:macos",
        "@platforms//cpu:aarch64",
    ],
    "macos-x86_64": [
        "@platforms//os:macos",
        "@platforms//cpu:x86_64",
    ],
    "windows-x86_64": [
        "@platforms//os:windows",
        "@platforms//cpu:x86_64",
    ],
}

_TOOLCHAIN_ENTRY = """\
toolchain(
    name = "pandoc_toolchain_{version}_{platform}",
    toolchain_type = "@rules_pandoc//pandoc:toolchain_type",
    toolchain = "{toolchain}",
    exec_compatible_with = {constraints},
    target_settings = ["@rules_pandoc//pandoc/settings:version_{version}"],
    visibility = ["//visibility:public"],
)
"""

def _pandoc_toolchains_hub_impl(repository_ctx):
    toolchains = []
    for toolchain, version_platform in repository_ctx.attr.toolchains.items():
        version, _, platform = version_platform.partition(":")
        toolchains.append(_TOOLCHAIN_ENTRY.format(
            constraints = repr(_CONSTRAINTS[platform]),
            platform = platform,
            toolchain = str(toolchain),
            version = version,
        ))

    repository_ctx.file("BUILD.bazel", "\n".join(toolchains))
    repository_ctx.file("WORKSPACE.bazel", """workspace(name = "{}")""".format(
        repository_ctx.name,
    ))

pandoc_toolchains_hub = repository_rule(
    doc = "Defines pandoc toolchains for each fetched (version, platform).",
    implementation = _pandoc_toolchains_hub_impl,
    attrs = {
        "toolchains": attr.label_keyed_string_dict(
            doc = "A mapping of toolchain labels to 'version:platform'.",
            mandatory = True,
        ),
    },
)

_UNIX_BUILD_CONTENT = """\
load("@rules_pandoc//pandoc:pandoc_toolchain.bzl", "pandoc_toolchain")

package(default_visibility = ["//visibility:public"])

exports_files(["bin/pandoc"])

pandoc_toolchain(
    name = "toolchain",
    compiler = "bin/pandoc",
    path_list_separator = ":",
)
"""

_WINDOWS_BUILD_CONTENT = """\
load("@rules_pandoc//pandoc:pandoc_toolchain.bzl", "pandoc_toolchain")

package(default_visibility = ["//visibility:public"])

exports_files(["pandoc.exe"])

pandoc_toolchain(
    name = "toolchain",
    compiler = "pandoc.exe",
    path_list_separator = ";",
)
"""

def _pandoc_impl(module_ctx):
    toolchains = {}

    for version, platforms in PANDOC_VERSIONS.items():
        for platform, data in platforms.items():
            name = "pandoc_{}_{}".format(version, platform)

            build_file_content = _UNIX_BUILD_CONTENT
            if "windows" in platform:
                build_file_content = _WINDOWS_BUILD_CONTENT

            maybe(
                http_archive,
                name = name,
                strip_prefix = data.get("strip_prefix", ""),
                build_file_content = build_file_content,
                integrity = data["integrity"],
                urls = data["urls"],
            )

            toolchains["@{}//:toolchain".format(name)] = "{}:{}".format(version, platform)

    maybe(
        pandoc_toolchains_hub,
        name = "pandoc_toolchains",
        toolchains = toolchains,
    )

    return module_ctx.extension_metadata(
        reproducible = True,
    )

pandoc = module_extension(
    implementation = _pandoc_impl,
)
