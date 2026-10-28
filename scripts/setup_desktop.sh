#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
target_home=${HOME:?HOME is required}
dry_run=false
while (($#)); do
    case "$1" in
        --home)
            (($# >= 2)) || { echo '--home requires a directory' >&2; exit 1; }
            target_home=$2; shift 2 ;;
        --dry-run) dry_run=true; shift ;;
        -h|--help)
            echo 'Usage: bash scripts/setup_desktop.sh [--home ABSOLUTE_DIRECTORY] [--dry-run]'
            exit 0 ;;
        *) echo "Unknown argument: $1" >&2; exit 1 ;;
    esac
done
[[ $target_home == /* && $target_home != / ]] || {
    echo 'Home must be an absolute directory other than /.' >&2; exit 1;
}

# Link individual configs, never replace the entire ~/.config or systemd tree.
paths=(
    .config/colors .config/darklyrc .config/fcitx5 .config/hypr
    .config/kde-material-you-colors .config/kitty .config/matugen
    .config/mouseless .config/nvim .config/quickshell .config/rofi
    .config/starship .config/swaync .config/waybar .config/yazi
    .config/systemd/user/ydotool.service.d/override.conf
)
for path in "${paths[@]}" home/zsh/.zshrc; do
    [[ -e $repo_root/$path ]] || { echo "Missing source: $path" >&2; exit 1; }
done

link_config() {
    local source_path=$1 target_path=$2 backup_dir
    if [[ -L $target_path && $target_path -ef $source_path ]]; then
        printf 'Already linked: %s\n' "$target_path"
        return
    fi
    printf 'Link: %s -> %s\n' "$target_path" "$source_path"
    [[ $dry_run == false ]] || return 0
    mkdir -p -- "$(dirname -- "$target_path")"
    if [[ -e $target_path || -L $target_path ]]; then
        backup_dir=$(mktemp -d "${target_path}.backup.XXXXXX")
        mv -- "$target_path" "$backup_dir/original"
        printf 'Backup: %s/original\n' "$backup_dir"
    fi
    ln -s -- "$source_path" "$target_path"
}
for path in "${paths[@]}"; do
    link_config "$repo_root/$path" "$target_home/$path"
done
link_config "$repo_root/home/zsh/.zshrc" "$target_home/.zshrc"

# Mutable GUI settings stay outside Git; seed only a fresh installation.
ui_config="$target_home/.config/illogical-impulse/config.json"
if [[ ! -e $ui_config && ! -L $ui_config ]]; then
    printf 'Create initial UI settings: %s\n' "$ui_config"
    if [[ $dry_run == false ]]; then
        mkdir -p -- "$(dirname -- "$ui_config")"
        cat > "$ui_config" <<'EOF'
{
  "appearance": {
    "fonts": {
      "main": "Readex Pro",
      "numbers": "Readex Pro",
      "title": "Readex Pro"
    },
    "wallpaperTheming": { "enableTerminal": false }
  },
  "light": { "night": { "automatic": false } }
}
EOF
    fi
fi
