#!/bin/sh
set -eu

target="${1:-all}"
repo=$(cd "$(dirname "$0")" && pwd)

link() {
    path="$1"
    dest="$2"
    mkdir -p "$(dirname "$path")"
    if [ -L "$path" ]; then
        current=$(readlink "$path")
        if [ "$current" = "$dest" ]; then
            echo "ok      $path"
            return
        fi
        echo "error: $path is a symlink to $current, expected $dest" >&2
        exit 1
    fi
    if [ -e "$path" ]; then
        echo "error: $path exists and is not a symlink; move it aside and re-run" >&2
        exit 1
    fi
    ln -s "$dest" "$path"
    echo "linked  $path -> $dest"
}

install_claude() {
    for s in concise peers grimoire-note-taking; do
        link "$HOME/.claude/skills/$s" "$repo/skills/$s"
    done

    claudemd="$HOME/.claude/CLAUDE.md"
    import="@$repo/skills/concise/SKILL.md"
    rule='In every repo, read its `AGENTS.md` (when present) and follow it.'
    header="# Standing skill directives"

    mkdir -p "$HOME/.claude"
    if [ -f "$claudemd" ] && grep -qxF "$import" "$claudemd"; then
        echo "ok      $claudemd"
        return
    fi
    if [ -f "$claudemd" ] && grep -q '^@.*concise' "$claudemd"; then
        tmp=$(mktemp)
        awk -v repl="$import" '!done && /^@.*concise/ { print repl; done=1; next } { print }' "$claudemd" > "$tmp"
        mv "$tmp" "$claudemd"
        grep -qxF "$rule" "$claudemd" || printf '\n%s\n' "$rule" >> "$claudemd"
        echo "updated $claudemd"
        return
    fi
    if [ -f "$claudemd" ]; then
        printf '\n%s\n\n%s\n\n%s\n' "$header" "$import" "$rule" >> "$claudemd"
        echo "updated $claudemd"
        return
    fi
    printf '%s\n\n%s\n\n%s\n' "$header" "$import" "$rule" > "$claudemd"
    echo "wrote   $claudemd"
}

install_opencode() {
    cmddir="$HOME/.config/opencode/command"
    src="$repo/command"
    mkdir -p "$(dirname "$cmddir")"
    if [ -L "$cmddir" ]; then
        current=$(readlink "$cmddir")
        if [ "$current" = "$src" ]; then
            echo "ok      $cmddir"
            return
        fi
        echo "error: $cmddir is a symlink to $current, expected $src" >&2
        exit 1
    fi
    if [ -d "$cmddir" ]; then
        others=$(ls -A "$cmddir" | grep -vx 'start.md' || true)
        if [ -n "$others" ]; then
            cp "$src/start.md" "$cmddir/"
            echo "copied  start.md into $cmddir (dir holds other commands; not linked)"
            return
        fi
        rm -f "$cmddir/start.md"
        rmdir "$cmddir"
    fi
    ln -s "$src" "$cmddir"
    echo "linked  $cmddir -> $src"
}

case "$target" in
    claude) install_claude ;;
    opencode) install_opencode ;;
    all) install_claude; install_opencode ;;
    *) echo "usage: install.sh [claude|opencode|all]" >&2; exit 2 ;;
esac
