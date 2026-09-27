#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<'EOF'
Usage: scripts/install_packages.sh [--with dev] [--with apps]
                                   [--profile thinkbook|latitude] [--list]
       scripts/install_packages.sh --check

Install common and desktop packages by default. The review and remove groups
are recorded but are never installed by this script. --check reports explicitly
installed packages that are missing from every package list.
EOF
}

die() {
    printf 'Error: %s\n' "$*" >&2
    exit 1
}

with_dev=false
with_apps=false
profile=''
list_only=false
check_only=false

while (($#)); do
    case "$1" in
        --with)
            (($# >= 2)) || die '--with requires dev or apps'
            case "$2" in
                dev) with_dev=true ;;
                apps) with_apps=true ;;
                *) die "unknown optional group: $2" ;;
            esac
            shift 2
            ;;
        --profile)
            (($# >= 2)) || die '--profile requires thinkbook or latitude'
            case "$2" in
                thinkbook|latitude) profile=$2 ;;
                *) die "unknown profile: $2" ;;
            esac
            shift 2
            ;;
        --list)
            list_only=true
            shift
            ;;
        --check)
            check_only=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *) die "unknown argument: $1" ;;
    esac
done

if [[ $check_only == true && ( $list_only == true || $with_dev == true || $with_apps == true || -n $profile ) ]]; then
    die '--check cannot be combined with installation options or --list'
fi

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
packages_dir="$repo_root/packages"

declare -a repo_packages=() foreign_packages=()
declare -A seen=()

for group in common desktop dev apps thinkbook latitude review remove; do
    if [[ $group == thinkbook || $group == latitude ]]; then
        manifest="$packages_dir/profiles/$group.tsv"
    else
        manifest="$packages_dir/$group.tsv"
    fi
    [[ -r $manifest ]] || die "cannot read $manifest"
    case "$group" in
        common|desktop) selected=true ;;
        dev) selected=$with_dev ;;
        apps) selected=$with_apps ;;
        thinkbook|latitude)
            selected=false
            [[ $group == "$profile" ]] && selected=true
            ;;
        review|remove) selected=false ;;
    esac

    while IFS=$'\t' read -r source package extra || [[ -n ${source:-} ]]; do
        [[ -z $source || $source == \#* ]] && continue
        [[ -z ${extra:-} ]] || die "extra field in $manifest: $package"
        [[ $package =~ ^[a-z0-9][a-z0-9@._+-]*$ ]] || die "invalid package name in $manifest: $package"
        [[ -z ${seen[$package]+x} ]] || die "duplicate package: $package"
        seen[$package]=1

        case "$source" in
            repo|foreign) ;;
            *) die "unknown source in $manifest: $source" ;;
        esac

        [[ $selected == true ]] || continue
        if [[ $source == repo ]]; then
            repo_packages+=("$package")
        else
            foreign_packages+=("$package")
        fi
    done < "$manifest"
done

if [[ $check_only == true ]]; then
    command -v pacman >/dev/null 2>&1 || die 'pacman is required'
    installed=$(pacman -Qqe) || die 'could not query installed packages'
    missing=0
    while IFS= read -r package; do
        [[ -n $package ]] || continue
        if [[ -z ${seen[$package]+x} ]]; then
            printf 'Not listed: %s\n' "$package"
            ((++missing))
        fi
    done <<< "$installed"
    if ((missing)); then
        printf '%d explicitly installed package(s) are not listed.\n' "$missing"
        exit 1
    fi
    printf 'All explicitly installed packages are listed.\n'
    exit 0
fi

printf 'pacman (%d packages):\n' "${#repo_packages[@]}"
printf '  %s\n' "${repo_packages[@]}"
printf 'yay (%d packages):\n' "${#foreign_packages[@]}"
printf '  %s\n' "${foreign_packages[@]}"

[[ $list_only == true ]] && exit 0

command -v pacman >/dev/null 2>&1 || die 'pacman is required'
if ((${#foreign_packages[@]})); then
    command -v yay >/dev/null 2>&1 || die 'yay is required; install it first as described in README.md'
fi

if ((${#repo_packages[@]})); then
    sudo pacman -Syu --needed -- "${repo_packages[@]}"
fi
if ((${#foreign_packages[@]})); then
    yay -S --needed -- "${foreign_packages[@]}"
fi
