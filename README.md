# harness-personalization

Personal skills and commands, sourced from this repo. `make` links them into the
harnesses — one copy on disk, the repo is the truth.

## Layout

| Repo | Linked as |
|---|---|
| `skills/concise/SKILL.md` | `~/.claude/skills/concise` |
| `skills/peers/SKILL.md` | `~/.claude/skills/peers` |
| `skills/grimoire-note-taking/SKILL.md` | `~/.claude/skills/grimoire-note-taking` |
| `command/start.md` | `~/.config/opencode/command` (whole dir) |

`command/start.md` is the `/start` command: reads the workspace `AGENTS.md`, then
applies the three skills for the session.

## Install

```sh
make            # both
make claude
make opencode
```

- `make claude` — skill links + the `@concise/SKILL.md` import line in `~/.claude/CLAUDE.md`
- `make opencode` — the `/start` command link

Windows uses NTFS junctions (`install.ps1`); macOS/Linux uses symlinks
(`install.sh`). `make` picks per OS. Requires GNU make.

Restart the harness afterwards — skills and commands load at startup.

opencode finds the skills through its `~/.claude/skills` scan, so `make claude`
is a prerequisite for them. The `peers` skill documents opencode-plugin-peers;
the plugin itself is installed separately in `opencode.jsonc`.

## Notes

- Moving or renaming the repo dangles every link. Remove the links
  (`rm <link>` / `Remove-Item <link>` removes the link, not the target), then
  re-run `make` from the new location.
- `make opencode` copies `start.md` instead of linking when
  `~/.config/opencode/command` already holds other commands. A copy does not
  track repo edits — re-run after changing the command.
