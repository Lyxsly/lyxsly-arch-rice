#!/usr/bin/env bash
set -euo pipefail

export ILLOGICAL_IMPULSE_VIRTUAL_ENV="${XDG_STATE_HOME:-$HOME/.local/state}/quickshell/.venv"
if [[ ! -x "$ILLOGICAL_IMPULSE_VIRTUAL_ENV/bin/python" ]]; then
    printf 'Run bash ~/dotfiles/scripts/setup_ii_python.sh first.\n' >&2
    exit 1
fi

# Activate only in this process and its children, never in the interactive shell.
unset PYTHONHOME PYTHONPATH
export PYTHONNOUSERSITE=1
export UV_PYTHON_PREFERENCE=only-system
export UV_PYTHON_DOWNLOADS=never
source "$ILLOGICAL_IMPULSE_VIRTUAL_ENV/bin/activate"
export qsConfig=ii
export QT_QPA_PLATFORMTHEME=kde
export YDOTOOL_SOCKET="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/.ydotool_socket"

if [[ "${1:-}" == --wallpaper ]]; then
    shift
    exec "${XDG_CONFIG_HOME:-$HOME/.config}/quickshell/ii/scripts/colors/switchwall.sh" "$@"
fi

if [[ "${1:-}" == --restart ]]; then
    shift
    qs -c ii kill 2>/dev/null || true
    for attempt in {1..50}; do
        if ! qs -c ii list 2>/dev/null | rg -q '^Instance '; then
            break
        fi
        sleep 0.1
    done
    if qs -c ii list 2>/dev/null | rg -q '^Instance '; then
        printf 'The previous ii instance has not stopped.\n' >&2
        exit 1
    fi
fi

if [[ "${1:-}" == --settings ]]; then
    shift
    exec qs -n -p "${XDG_CONFIG_HOME:-$HOME/.config}/quickshell/ii/settings.qml" "$@"
fi

restore_video="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/custom/scripts/__restore_video_wallpaper.sh"
if [[ -f "$restore_video" ]] && ! qs -c ii list 2>/dev/null | rg -q '^Instance '; then
    bash "$restore_video" &
fi
exec qs -n -c ii "$@"
