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

unlink() {
    path="$1"
    dest="$2"
    if [ -L "$path" ]; then
        current=$(readlink "$path")
        if [ "$current" != "$dest" ]; then
            echo "error: $path is a symlink to $current, not this repo; remove it manually" >&2
            exit 1
        fi
        rm "$path"
        echo "removed $path"
        return
    fi
    if [ -e "$path" ]; then
        echo "error: $path exists and is not a symlink; remove it manually" >&2
        exit 1
    fi
    echo "absent  $path"
}

install_opencode() {
    for s in concise peers grimoire-note-taking; do
        link "$HOME/.config/opencode/skills/$s" "$repo/skills/$s"
    done

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

remove_opencode() {
    for s in concise peers grimoire-note-taking; do
        unlink "$HOME/.config/opencode/skills/$s" "$repo/skills/$s"
    done

    cmddir="$HOME/.config/opencode/command"
    if [ -L "$cmddir" ]; then
        unlink "$cmddir" "$repo/command"
    elif [ -d "$cmddir" ]; then
        if [ -e "$cmddir/start.md" ]; then
            rm -f "$cmddir/start.md"
            echo "removed $cmddir/start.md"
        else
            echo "absent  $cmddir/start.md"
        fi
        others=$(ls -A "$cmddir" | grep -vx 'start.md' || true)
        if [ -z "$others" ]; then
            rmdir "$cmddir" 2>/dev/null || true
        fi
    else
        echo "absent  $cmddir"
    fi
}

case "$target" in
    opencode|all) install_opencode ;;
    remove) remove_opencode ;;
    *) echo "usage: install.sh [opencode|all|remove]" >&2; exit 2 ;;
esac
