#!/usr/bin/env bash

usage() {
    echo "Usage: ./finfo.sh <path_to_file>"
    exit 1
}

OS=$(uname -s)

# Arg handling - if arguments != 1, print usage and error
[[ $# -ne 1 ]] && usage

# File exists or error
[[ -e $1 ]] || { echo "'${1}' file doesn't exist."; exit 1; }

# Get file type (Unix has 7 file types)
file_type=""
if [[ -f $1 ]]; then file_type="File"
elif [[ -d $1 ]]; then file_type="Dir"
elif [[ -L $1 ]]; then file_type="Symlink"
elif [[ -p $1 ]]; then file_type="FIFO special"
elif [[ -S $1 ]]; then file_type="Socket"
elif [[ -b $1 ]]; then file_type="Block special"
elif [[ -c $1 ]]; then file_type="Character special"
else file_type="unknown"
fi

# Get size on disk (only human-reaable size without filename with trimmed whitespaces)
disk_size=$(du -sh "$1" | cut -f 1 | xargs)

# Get actual file content type
content_type=$(file -b "$1")

# Get Set-user-id for file
[[ -u $1 ]] && suid="Set (1)" || suid="Unset (0)"

# Get Group-use-id for file
[[ -g $1 ]] && guid="Set (1)" || guid="Unset (0)"

# Get sticky bit for file
[[ -k $1 ]] && sticky="Set (1)" || sticky="Unset (0)"

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
        echo "${OS} is not supported."
        exit 2
        ;;
esac

{
    echo "Type|${file_type}"
    echo "Content|${content_type}"
    echo "File size|${f_size} B"
    echo "Disk size|${disk_size}"
    echo "Permissions|${f_str_perms} (${f_oct_perms})"
    echo "Owner|${f_user} (${f_uid})"
    echo "Group|${f_group} (${f_gid})"
    echo "Last accessed|${f_atime}"
    echo "Last modified|${f_mtime}"
    echo "Last changed|${f_ctime}"
    echo "Hard link count|${f_link_count}"
    echo "Inode|${f_inode}"
    echo "Set User ID|${suid}"
    echo "Set Group ID|${guid}"
    echo "Sticky bit|${sticky}"
} | column -t -s '|'
