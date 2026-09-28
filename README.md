# ifi - Inspect File Info

A simple tool that prints detailed information about one or more files as either a valid JSON format or human readable format.
The file information include: type, size, content type, permissions, ownership, timestamps, inode,
link count, and the setuid/setgid/sticky bits.

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

Picks `/usr/local/bin` or falls back to `~/.local/bin` if that isn't writable. Installs latest released version.

**Option 2: manual curl**

```bash
curl -fsSL https://github.com/SamuelZima/ifi/releases/latest/download/ifi.sh -o /usr/local/bin/ifi
chmod +x /usr/local/bin/ifi
```

**Option 3: clone the repo and create symlink**

```bash
git clone https://github.com/SamuelZima/ifi.git
chmod +x ifi/ifi.sh
ln -s "$(pwd)/ifi/ifi.sh" /usr/local/bin/ifi
```

## Usage

```
ifi [-j|--json] [-h|--help] <path_to_file> [path_to_file ...]
```

## Options

| Option           | Description             |
|------------------|--------------------------|
| `-j`, `--json`   | Output file info as JSON |
| `-h`, `--help`   | Show the help message    |

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
