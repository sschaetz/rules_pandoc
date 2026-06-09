"""Example-local rule: stamp the git commit SHA into a Markdown snippet.

Demonstrates Bazel workspace-status stamping. `ctx.info_file` is
stable-status.txt, which is populated by --workspace_status_command when --stamp
is passed. We read STABLE_GIT_SHA from it and emit a small Markdown fragment that
the pandoc target concatenates into its sources.

This lives in the example (not in the pandoc rules) because stamping is
environment-specific. Build it with:

    bazel build //ex005:ex005_html \\
        --stamp \\
        --workspace_status_command="$PWD/tools/workspace_status.sh"
"""

def _git_stamp_impl(ctx):
    out = ctx.actions.declare_file(ctx.label.name + ".md")
    command = (
        "sha=$(sed -n 's/^STABLE_GIT_SHA //p' " + ctx.info_file.path + " | head -n1); " +
        "printf '\\n---\\n\\n*Generated from commit `%s`.*\\n' \"${sha:-unknown}\" > " + out.path
    )
    ctx.actions.run_shell(
        inputs = [ctx.info_file],
        outputs = [out],
        command = command,
        mnemonic = "GitStamp",
    )
    return [DefaultInfo(files = depset([out]))]

git_stamp = rule(
    doc = "Writes a Markdown snippet containing the stamped git commit SHA.",
    implementation = _git_stamp_impl,
)
