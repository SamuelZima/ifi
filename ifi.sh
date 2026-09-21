#!/usr/bin/env bash

usage() {
    echo "Usage: ./ifi.sh [-j|--json] [-h|--help] <path_to_file>"
    echo ""
    echo "Options:"
    echo "  -j, --json    Output file info as JSON"
    echo "  -h, --help    Show this help message"
    exit 0
}

error() {
    echo "$1" >&2
    exit 1
}

OS=$(uname -s)

# Arg handling (options and positional arguments)
pos_args=()
json=0
help=0
while [[ $# -gt 0 ]]; do
    case "$1" in
        -j|--json)
            json=1
            shift
            ;;
        -h|--help)
            help=1
            shift
            ;;
        -*)
            error "Unknown option: $1"
            ;;
        *)
            pos_args+=("$1")
            shift
            ;;
    esac
done

# Restore positional args into $1, $2, ...
set -- "${pos_args[@]}"

# Show usage if help option was set
[[ $help -eq 1 ]] && usage

# No positional argument means no file was specified
[[ ${#pos_args[@]} -eq 0 ]] && error "No file specified."

# File/symlink exists or error. -e follows symlinks and fails on a broken link -> check -L too.
[[ -e "$1" || -L "$1" ]] || error "'${1}' file doesn't exist."

# Get file type (Unix has 7 file types)
file_type=""
if [[ -L "$1" ]]; then file_type="Symlink"
elif [[ -f "$1" ]]; then file_type="File"
elif [[ -d "$1" ]]; then file_type="Dir"
elif [[ -p "$1" ]]; then file_type="FIFO special"
elif [[ -S "$1" ]]; then file_type="Socket"
elif [[ -b "$1" ]]; then file_type="Block special"
elif [[ -c "$1" ]]; then file_type="Character special"
else file_type="unknown"
fi

# Get size on disk
if [[ "$file_type" == "Symlink" && ! -e "$1" ]]; then
    # Skip du on a broken symlink -> nothing to measure.
    disk_size="-"
else
    # Only human-reaable size without filename with trimmed whitespaces
    disk_size=$(du -sh "$1" | cut -f 1 | xargs)
fi

# Get actual file content type
content_type=$(file -b "$1")

# Get Set-user-id for file
[[ -u "$1" ]] && suid="True" || suid="False"

# Get Group-use-id for file
[[ -g "$1" ]] && guid="True" || guid="False"

# Get sticky bit for file
[[ -k "$1" ]] && sticky="True" || sticky="False"

# Get other important file info using stat
case "$OS" in
    Darwin|FreeBSD|OpenBSD|NetBSD)
        IFS='|' read -r f_user f_uid f_group f_gid f_size f_mtime f_atime f_ctime f_str_perms f_oct_perms f_link_count f_inode \
            < <(stat -f '%Su|%u|%Sg|%g|%z|%Sm|%Sa|%Sc|%Sp|%Lp|%l|%i' "$1")
        ;;
    Linux)
        IFS='|' read -r f_user f_uid f_group f_gid f_size f_mtime f_atime f_ctime f_str_perms f_oct_perms f_link_count f_inode \
            < <(stat -c '%U|%u|%G|%g|%s|%y|%x|%z|%A|%a|%h|%i' "$1")
        ;;
    *)
        error "'${OS}' is not supported."
        ;;
esac

# Build the final info fields array (JSON key | Human label | value)
fields=(
    "type|Type|${file_type}"
    "content_type|Content type|${content_type}"
    "file_size|File size|${f_size}B"
    "disk_size|Disk size|${disk_size}"
    "permissions_string|String permissions|${f_str_perms}"
    "permissions_octal|Octal permissions|${f_oct_perms}"
    "owner_name|Owner name|${f_user}"
    "owner_id|Owner ID|${f_uid}"
    "group|Group|${f_group}"
    "group_id|Group ID|${f_gid}"
    "accessed_at|Accessed at|${f_atime}"
    "modified_at|Modified at|${f_mtime}"
    "changed_at|Changed at|${f_ctime}"
    "link_count|Link count|${f_link_count}"
    "inode|Inode|${f_inode}"
    "setuid|Set User ID|${suid}"
    "setgid|Set Group ID|${guid}"
    "sticky|Sticky Bit|${sticky}"
)

if [[ $json -eq 1 ]]; then
    printf '%s\n' "${fields[@]}" | perl -MJSON::PP -F'\|' -ane '
        chomp $F[2];
        $h{$F[0]} = $F[2];
        END { print JSON::PP->new->pretty->canonical->encode(\%h) }
    '
else
    printf '%s\n' "${fields[@]}" | cut -d'|' -f2- | column -t -s '|'
fi
