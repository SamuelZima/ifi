#!/usr/bin/env bash
set -euo pipefail

repo_raw="https://github.com/SamuelZima/ifi/releases/latest/download/ifi.sh"
dest="/usr/local/bin/ifi"

if [[ -w /usr/local/bin ]]; then
    curl -fsSL "$repo_raw" -o "$dest"
    chmod +x "$dest"
else
    sudo curl -fsSL "$repo_raw" -o "$dest"
    sudo chmod +x "$dest"
fi

echo "Installed ifi to $dest"
