#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(
  cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
  pwd
)"

VERSION="$(<"$SCRIPT_DIR/VERSION")"
PATCHED_VERSION="${VERSION#v}-local1"

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

echo "==> Building mouseless $VERSION with local patches"

git clone \
  --depth 1 \
  --branch "$VERSION" \
  https://github.com/jbensmann/mouseless.git \
  "$WORKDIR/mouseless"

cd "$WORKDIR/mouseless"

echo "==> Checking patch"
git apply --check "$SCRIPT_DIR/normalize-diagonal.patch"

echo "==> Applying patch"
git apply "$SCRIPT_DIR/normalize-diagonal.patch"

echo "==> Building"
go build -trimpath -ldflags "-X main.version=$PATCHED_VERSION" -o mouseless .

echo "==> Installing"
sudo install -Dm755 mouseless /usr/local/bin/mouseless

echo "==> Installed patched mouseless $PATCHED_VERSION"
