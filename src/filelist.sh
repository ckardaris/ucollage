reverse_images(){
    local max min=0 temp
    (( max = ${#images[@]} -1 ))
    while [[ min -lt max ]]
    do
        temp="${image_names[$min]}"
        image_names[$min]="${image_names[$max]}"
        image_names[$max]="$temp"

        temp="${images[$min]}"
        images[$min]="${images[$max]}"
        images[$max]="$temp"

        (( min += 1 ))
        (( max -= 1 ))
    done
}

######################################################################
# Create filelist
######################################################################
read_filenames() {
    local char item ls_args="-d"
    [[ "${optcurrent[reverse]}" == "reverse" ]] && ls_args+=" -r"
    case "${optcurrent[sort]}" in
        "time")
            ls_args+=" -t"
            ;;
        "size")
            ls_args+=" -S"
            ;;
        "extension")
            ls_args+=" -X"
            ;;
    esac
    if [[ "$#" -gt 0 ]]
    then
        mapfile -t filelist < <(ls $ls_args "$@" &>/dev/null)
    else
        mapfile -t filelist < <(ls $ls_args -- *)
    fi
    if [[ "$expand_dirs" -eq 1 ]]
    then
        for item in "${filelist[@]}"
        do
            [[ -d "$item" ]] && filelist+=("$item"/*)
        done
    elif [[ "$expand_dirs" == "ask" ]]
    then
        for item in "${filelist[@]}"
        do
            [[ -d "$item" ]] \
                && read -p "Expand $item? (n, Esc: no, N: no to all)" -rsN1 char \
                && echo
            [[ "$char" == "N" ]] && break
            [[ ! "$char" =~ ^(n|$'\e')$ ]] && filelist+=("$item"/*)
        done
    fi
    argc="${#filelist[@]}"
    image_names=()
    images=()
    filehash=()
    rm -f "${tmp_dir}/image_names.txt*"
    rm -f "${tmp_dir}/images.txt*"
    rm -f "${tmp_dir}/hash.txt*"
}

######################################################################
# Search for thumbnail of file in cache directory
######################################################################
find_thumbnail() {
    cache_name="${cache_dir}/thumbnails/${hash}.jpg"
    [[ -f "$cache_name" ]] && thumbnail_file="$cache_name" && return 0
    return 1
}

######################################################################
# Create thumbnail for file
######################################################################
create_thumbnail() {
    local format_duration time_point
    thumbnail_file="${tmp_dir}/${hash}.jpg"
    eval "$(ffprobe -i "$file" -show_entries format=duration \
        -v quiet -of flat="s=_")"
    format_duration=${format_duration/.*/}
    (( time_point = format_duration / 2 ))
    ffmpeg -ss "$time_point" -i "$file" -loglevel quiet -frames:v 1 \
        -filter:v scale="$thumbnail_width":-1 -y "$thumbnail_file"
    montage -label "thumbnail" "$thumbnail_file" -geometry +0+0 \
        -background Gold "$thumbnail_file"
}

######################################################################
# Parses filelist and filters supported filetypes
######################################################################
read_images() {
    echo 1 > "${tmp_dir}/read_lock"
    local file loadc=0 readc=0 thumbnail_file
    while (( readc < read_target )) && (( read_iter < argc )) && \
        ((loadc < optcurrent[maxload]))
    do
        file=${filelist[$read_iter]}
        read -rd ' ' hash < <(head -c 100000 "$file" 2>/dev/null | xxh128sum)
        if is_image "$file"
        then
            echo "$file" >> "${tmp_dir}/image_names.txt"
            echo "$file" >> "${tmp_dir}/images.txt"
            echo "$hash" >> "${tmp_dir}/hash.txt"
            echo 1 > "${tmp_dir}/dirty"
            (( readc += 1 ))
        elif is_video "$file" \
            && [[ "$video_thumbnails" -eq 1 ]] \
            && command -v ffmpeg &> /dev/null
        then
            ! find_thumbnail && create_thumbnail
            echo "$file" >> "${tmp_dir}/image_names.txt"
            echo "$thumbnail_file" >> "${tmp_dir}/images.txt"
            echo "$hash" >> "${tmp_dir}/hash.txt"
            echo 1 > "${tmp_dir}/dirty"
            if [[ "$cache_thumbnails" -eq 1 ]] && \
                [[ ! "$thumbnail_file" == "$cache_name" ]]
            then
                cp -f "$thumbnail_file" "$cache_name"
            fi
            (( readc += 1 ))
        else
            touch "${cache_dir}/hash/other/${hash}"
        fi
        (( read_iter += 1 ))
        (( loadc += 1 ))
        echo "$read_iter" > "${tmp_dir}/read_iter"
    done
    echo 0 > "${tmp_dir}/read_lock"
}

######################################################################
# Populate the image_names, images and filehash arrays by reading the
# files written by the background process
######################################################################
populate_arrays() {
    echo 0 > "${tmp_dir}/dirty"
    # This is to read only new files in each iteration. Should scale well
    [[ ! -f "${tmp_dir}/image_names.txt" ]] || [[ ! -f "${tmp_dir}/images.txt" ]] ||\
        [[ ! -f "${tmp_dir}/hash.txt" ]] && return
    mv "${tmp_dir}/image_names.txt" "${tmp_dir}/image_names.txt.old"
    mv "${tmp_dir}/images.txt" "${tmp_dir}/images.txt.old"
    mv "${tmp_dir}/hash.txt" "${tmp_dir}/hash.txt.old"
    mapfile -t temp_names < "${tmp_dir}/image_names.txt.old"
    mapfile -t temp < "${tmp_dir}/images.txt.old"
    mapfile -t temp_hash < "${tmp_dir}/hash.txt.old"
    image_names+=("${temp_names[@]}")
    images+=("${temp[@]}")
    filehash+=("${temp_hash[@]}")
}

load_files() {
    local read_iter read_lock
    read -r read_lock < "${tmp_dir}/read_lock"
    # Simple lock mechanism. If read_images is running then quit.
    if [[ "$read_lock" -eq 0 ]]
    then
        read -r read_iter < "${tmp_dir}/read_iter"
        if ((read_iter < argc))
        then
            # read the max possible
            read_target="${optcurrent[maxload]}" && read_images &
        else
            warning="All files are loaded"
        fi
    fi
    clear_sequence
}

