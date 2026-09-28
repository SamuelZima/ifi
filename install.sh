#!/usr/bin/env bash
set -euo pipefail

repo_raw="https://github.com/SamuelZima/ifi/releases/latest/download/ifi.sh"

if [[ -w /usr/local/bin ]]; then
    dest="/usr/local/bin/ifi"
elif [[ -w "$HOME/.local/bin" ]] || mkdir -p "$HOME/.local/bin" 2>/dev/null; then
    dest="$HOME/.local/bin/ifi"
else
    echo "No writable install directory found (tried /usr/local/bin and ~/.local/bin)." >&2
    exit 1
fi

curl -fsSL "$repo_raw" -o "$dest"
chmod +x "$dest"

echo "Installed ifi to $dest"

case ":$PATH:" in
    *":$(dirname "$dest"):"*) ;;
    *) echo "Note: $(dirname "$dest") is not in your \$PATH. Add it to use 'ifi' directly." ;;
esac
