#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

if ! command -v make >/dev/null 2>&1 || ! command -v g++ >/dev/null 2>&1; then
    echo "Build tools are missing. Run: bash ./install-deps.sh" >&2
    exit 1
fi

make configure
make package

echo
echo "Package created:"
find dist -maxdepth 1 -type f -name 'PWServer-*.tar.gz' -printf '%p\n' | sort | tail -n 1
