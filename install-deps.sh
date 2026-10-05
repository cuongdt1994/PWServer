#!/usr/bin/env bash
set -euo pipefail

if [[ "$(id -u)" -eq 0 ]]; then
    SUDO=()
else
    SUDO=(sudo)
fi

"${SUDO[@]}" dpkg --add-architecture i386
"${SUDO[@]}" apt-get update
"${SUDO[@]}" apt-get install -y \
    build-essential \
    gcc g++ gcc-multilib g++-multilib \
    make perl git ca-certificates file tar gzip \
    libxml-dom-perl \
    libxml2-dev:i386 \
    libssl-dev:i386 \
    libpcre3-dev:i386 \
    libdb-dev:i386

echo "Dependencies installed."
