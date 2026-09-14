# harness-personalization

Personal skills and commands for opencode, sourced from this repo. `make` links them
into `~/.config/opencode` — one copy on disk, the repo is the truth.

## Layout

| Repo | Linked as |
|---|---|
| `skills/concise/` | `~/.config/opencode/skills/concise` |
| `skills/peers/` | `~/.config/opencode/skills/peers` |
| `skills/grimoire-note-taking/` | `~/.config/opencode/skills/grimoire-note-taking` |
| `command/start.md` | `~/.config/opencode/command` (whole dir, or copied `start.md`) |

`command/start.md` is the `/start` command: reads the workspace `AGENTS.md`, then
applies the three skills for the session. It references the skills at their installed
location, `~/.config/opencode/skills/`, so it works on any host — including when
`start.md` itself was copied rather than linked.

## Install

```sh
make install    # bare `make` works too
make remove     # uninstall
```

Windows uses NTFS junctions (`install.ps1`); macOS/Linux uses symlinks
(`install.sh`). `make` picks per OS. Requires GNU make.

`make remove` deletes the skill links, the command link, and a copied `start.md`.
It removes an empty command folder left behind, keeps one that holds other
commands, and refuses to touch any link that does not point into this repo.

Restart opencode afterwards — skills and commands load at startup.

The `peers` skill documents opencode-plugin-peers; the plugin itself is installed
separately in `opencode.jsonc`.

## Notes

- Moving or renaming the repo dangles every link. Remove the links
  (`rm <link>` / `Remove-Item <link>` removes the link, not the target), then
  re-run `make` from the new location.
- `make` copies `start.md` instead of linking when `~/.config/opencode/command`
  already holds other commands. A copy does not track repo edits — re-run after
  changing the command.
- A skill path that exists and is not a link makes the installer abort; move it
  aside and re-run.
