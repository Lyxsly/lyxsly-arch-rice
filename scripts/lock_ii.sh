#!/usr/bin/env bash
set -euo pipefail

if qs -c ii ipc call lock activate; then
    exit 0
fi

# Keep a separate locker available when the graphical shell is not running.
exec hyprlock -c "${XDG_CONFIG_HOME:-$HOME/.config}/hypr/hyprlock-fallback.conf"
