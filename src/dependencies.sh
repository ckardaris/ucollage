check_dependencies() {
    local dependency errors=0
    local -A dep
    dep[ueberzug]="ueberzug"
    dep[file]="file"
    dep[md5sum]="coreutils"
    dep[bc]="bc"
    dep[sed]="sed"
    for dependency in "${!dep[@]}"
    do
        if ! command -v "$dependency" &>/dev/null
        then
            echo "Required dependency not installed: ${dep[$dependency]}" && exit
        fi
    done
    dep=()
    dep[convert]="imagemagick"
    dep[ffmpeg]="ffmpeg"
    dep[xclip]="xclip"
    for dependency in "${!dep[@]}"
    do
        if ! command -v "$dependency" &>/dev/null
        then
            errors=1
            echo "Optional dependency not installed: ${dep[$dependency]}"
        fi
    done
    [[ "$errors" -eq 1 ]] && read -rsN1
}
