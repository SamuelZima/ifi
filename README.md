# ifi - Inspect File Info

A simple tool that prints detailed information about one or more files as either a valid JSON format or human readable format.
The file information include: type, size, content type, permissions, ownership, timestamps, inode,
link count, and the setuid/setgid/sticky bits.

## Requirements

- bash
- Standard Unix tools: `stat`, `file`, `du`, `awk`, `column`
- `perl` with `JSON::PP` (only needed for `--json` output) (preinstalled on nearly all Linux distros and macOS; may need to be installed on BSDs)

Supported platforms: Linux, macOS (Darwin), FreeBSD, OpenBSD, NetBSD.

## Usage

```
./ifi.sh [-j|--json] [-h|--help] <path_to_file> [path_to_file ...]
```

## Options

| Option           | Description             |
|------------------|--------------------------|
| `-j`, `--json`   | Output file info as JSON |
| `-h`, `--help`   | Show the help message    |

## Examples

Inspect a single file:

```
./ifi.sh /etc/hosts
```

Inspect multiple files:

```
./ifi.sh file1.txt file2.txt
```

Get JSON output:

```
./ifi.sh --json file1.txt

./ifi.sh file1.txt file2.txt -j
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
