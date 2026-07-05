#!/bin/bash

# --- Helper Function: Run only if command exists ---
run_if_exists() {
    if command -v "$1" >/dev/null 2>&1; then
        "$@"
    else
        echo "Skip: Command $1 not found."
    fi
}

# --- Helper Function: Kill only if process is running ---
safe_kill() {
    if pgrep -x "$1" >/dev/null; then
        killall "$1"
    else
        echo "Skip: $1 is not running."
    fi
}

# Variables
SELECTED_WALLPAPER=$1
RELOAD_APPS=$2
WALLPAPER_DIR="$HOME/wallpapers"
WP_PATH="$WALLPAPER_DIR/$SELECTED_WALLPAPER.jpg"

if [ ! -f "$WP_PATH" ]; then
    echo "Error: Wallpaper not found: $SELECTED_WALLPAPER"
    exit 1
fi

run_if_exists matugen --source-color-index 0 -m dark image "$WP_PATH"

if [[ "$RELOAD_APPS" == "--generate-only" || "$RELOAD_APPS" == "-g" ]]; then
    echo "Generate only. Skipping app reload."
    exit 0
fi

if command -v hyprpaper >/dev/null 2>&1; then
    safe_kill hyprpaper
    hyprpaper -c "$HOME/.config/hypr/service/hyprpaper.conf" &
fi

if pgrep -x "eww" >/dev/null; then
    killall eww
    sleep 1
    eww open-many bar notifications
else
    eww open-many bar notifications
fi

# Keep kitty and nvim themes fixed. Matugen output is intentionally limited to
# UI surfaces such as eww/rofi because wallpaper-derived text colors can hurt
# readability in terminal/editor sessions.
