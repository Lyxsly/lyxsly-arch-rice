#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
python_version=3.12.14
venv_dir="${XDG_STATE_HOME:-$HOME/.local/state}/quickshell/.venv"
export UV_PYTHON_PREFERENCE=only-system
export UV_PYTHON_DOWNLOADS=never

command -v pyenv >/dev/null
command -v uv >/dev/null
pyenv install -s "$python_version"
python_bin="$(pyenv root)/versions/$python_version/bin/python"

if [[ ! -e "$venv_dir" ]]; then
    uv venv --python "$python_bin" "$venv_dir"
fi
"$venv_dir/bin/python" -c 'import sys; assert sys.version_info[:3] == (3, 12, 14), sys.version'
uv pip sync --python "$venv_dir/bin/python" \
    "$repo_root/rice/illogical-impulse/requirements.txt"
uv pip check --python "$venv_dir/bin/python"
"$venv_dir/bin/python" -c 'import sys; print(sys.executable); print(sys.version)'
