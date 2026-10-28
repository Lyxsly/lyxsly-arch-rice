#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
apply=false
list_only=false
package_args=()
while (($#)); do
    case "$1" in
        --apply) apply=true; shift ;;
        --list) list_only=true; shift ;;
        --with|--profile)
            (($# >= 2)) || { echo "$1 requires a value" >&2; exit 1; }
            package_args+=("$1" "$2"); shift 2 ;;
        -h|--help)
            echo 'Usage: bash scripts/restore.sh [--list|--apply] [--with dev] [--with apps] [--profile thinkbook|latitude]'
            echo 'Without --apply, only show the plan. Run as your normal user.'
            exit 0 ;;
        *) echo "Unknown argument: $1" >&2; exit 1 ;;
    esac
done
if [[ $apply == true && $list_only == true ]]; then
    echo '--list cannot be combined with --apply.' >&2
    exit 1
fi

# Validate the manifest and all package options before any mutation.
bash "$repo_root/scripts/install_packages.sh" --list "${package_args[@]}"
printf '\nSettings to restore:\n'
bash "$repo_root/scripts/setup_desktop.sh" --dry-run
printf '\nNext: build UI Python environment; enable NetworkManager, bluetooth,\nhypridle and ydotool; add the current user to input; set the Qt widget style.\n'
[[ $apply == true ]] || exit 0

((EUID != 0)) || { echo 'Run as a normal user, not root.' >&2; exit 1; }
# Existing Hyprland commands and Matugen templates expect ~/dotfiles and
# the standard XDG paths. Reject other layouts before installing packages.
[[ $HOME/dotfiles -ef $repo_root ]] || {
    echo 'Clone this repository into ~/dotfiles first.' >&2; exit 1;
}
for pair in "CONFIG:$HOME/.config" "STATE:$HOME/.local/state" "CACHE:$HOME/.cache"; do
    key="XDG_${pair%%:*}_HOME"
    [[ ${!key:-${pair#*:}} == "${pair#*:}" ]] || {
        echo "Custom $key is not supported by this restore procedure." >&2; exit 1;
    }
done
restore_user=$(id -un)
sudo -v
bash "$repo_root/scripts/install_packages.sh" "${package_args[@]}"
bash "$repo_root/scripts/setup_desktop.sh"
bash "$repo_root/scripts/setup_ii_python.sh"
kwriteconfig6 --file "$HOME/.config/kdeglobals" --group KDE --key widgetStyle Darkly
sudo systemctl enable NetworkManager.service bluetooth.service
sudo usermod -aG input "$restore_user"
systemctl --user daemon-reload
systemctl --user enable hypridle.service ydotool.service
printf '\nRestore steps completed. Reboot to refresh groups and start services.\nSee README.md for display settings, wallpaper generation and checks.\n'
