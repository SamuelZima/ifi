# ifi - Inspect File Info

ifi is a single bash script that replaces the usual `stat`, `file`, and `du` shuffle. Point it at one or more files and get a complete report: 
type, content type, size (apparent and on disk), permissions (symbolic and octal), ownership, timestamps, inode, link count, and the setuid/setgid/sticky bits.

Output is a readable table by default, or valid JSON with `-j` or `--json` option for piping into scripts and tools like `jq`. Works on Linux, macOS, and BSD.

## Requirements

- bash
- Standard Unix tools: `stat`, `file`, `du`, `awk`, `column`
- `perl` with `JSON::PP` (only needed for `--json` output) (preinstalled on nearly all Linux distros and macOS; may need to be installed on BSDs)

Supported platforms: Linux, macOS (Darwin), FreeBSD, OpenBSD, NetBSD.

## Install

**Option 1: install script**

```bash
curl -fsSL https://github.com/SamuelZima/ifi/releases/latest/download/install.sh | bash
```

Installs to `/usr/local/bin/ifi` (uses `sudo` if that isn't writable). Always installs the latest released version.

**Option 2: manual curl**

```bash
sudo curl -fsSL https://github.com/SamuelZima/ifi/releases/latest/download/ifi.sh -o /usr/local/bin/ifi
sudo chmod +x /usr/local/bin/ifi
```

**Option 3: clone the repo and create symlink**

```bash
git clone https://github.com/SamuelZima/ifi.git
chmod +x ifi/ifi.sh
sudo ln -s "$(pwd)/ifi/ifi.sh" /usr/local/bin/ifi
```

## Uninstall

```bash
sudo rm /usr/local/bin/ifi
```

## Usage

```
ifi [-j|--json] [-h|--help] [-v|--version] <path_to_file> [path_to_file ...]
```

## Options

| Option           | Description             |
|------------------|--------------------------|
| `-j`, `--json`   | Output file info as JSON |
| `-h`, `--help`   | Show the help message    |
| `-v`, `--version`| Show version    |

## Examples

Inspect a single file:

```
ifi /etc/hosts
```

Inspect multiple files:

```
ifi file1.txt file2.txt
```

Get JSON output:

```
ifi --json file1.txt

ifi file1.txt file2.txt -j
```

## Output fields

- Filename
- Type (File, Dir, Symlink, FIFO special, Socket, Block special, Character special)
- Content type
- File size
- Disk size
- String permissions
- Octal permissions
- Owner name / ID
- Group / Group ID
- Accessed / Modified / Changed timestamps
- Link count
- Inode
- Set User ID, Set Group ID, Sticky Bit

## License

GPLv3. See [LICENSE](LICENSE).
