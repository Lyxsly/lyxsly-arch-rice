#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
target_home="${HOME:?HOME is required}"
if [[ $# -eq 2 && "$1" == --home ]]; then
  target_home="$2"
elif [[ $# -ne 0 ]]; then
  echo "Usage: bash scripts/setup_codex.sh [--home DIRECTORY]" >&2
  exit 1
fi
if [[ "$target_home" != /* ]]; then
  echo "Home directory must be an absolute path." >&2
  exit 1
fi

paths=(.codex/config.toml .codex/AGENTS.md .codex/skills .agents/skills)
for path in "${paths[@]}"; do
  if [[ ! -e "$repo_dir/$path" ]]; then
    echo "Missing source: $repo_dir/$path" >&2
    exit 1
  fi
done

for path in "${paths[@]}"; do
  source_path="$repo_dir/$path"
  target_path="$target_home/$path"
  if [[ -L "$target_path" && "$target_path" -ef "$source_path" ]]; then
    echo "Already linked: $target_path"
    continue
  fi
  mkdir -p -- "$(dirname -- "$target_path")"
  if [[ -e "$target_path" || -L "$target_path" ]]; then
    backup_dir="$(mktemp -d "${target_path}.backup.XXXXXX")"
    mv -- "$target_path" "$backup_dir/original"
    echo "Backup: $backup_dir/original"
  fi
  ln -s -- "$source_path" "$target_path"
  echo "Linked: $target_path -> $source_path"
done
