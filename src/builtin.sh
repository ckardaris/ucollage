######################################################################
# Checks whether the provided index is local to the current view
######################################################################
is_index_local() {
    local end
    (( end = start + show ))
    [[ "$1" -ge "$start" ]] && [[ "$1" -lt "$end" ]] && return 0 || return 1
}

_rate() {
    local file hash ind input_autocomplete input_prompt rating
    local rating_arr update=0
    if get_image_index
    then
        if [[ -n "$*" ]]
        then
            IFS=" " read -r -a rating_arr <<< "$*"
            for ((i = ${#rating_arr[@]}; i < ${#image_index[@]}; i++))
            do
                rating_arr[$i]=${rating_arr[-1]}
            done
        fi

        for ind in "${image_index[@]}"
        do
            if [[ -n "${rating_arr[$mi]}" ]]
            then
                input="${rating_arr[$mi]}"
            else
                input_prompt="Rating for [$((ind % batch + 1))]: "
                input_autocomplete="rating"
                ! get_input && continue
                trim_spaces input --force
            fi
            if [[ "$input" =~ ^(0|1|2|3|4|5)$ ]]
            then
                hash="${filehash[$ind]}"
                rating=
                file=
                if is_image
                then
                    file="${cache_dir}/hash/images/$hash"
                elif is_video
                then
                    file="${cache_dir}/hash/videos/$hash"
                fi
                eval "$(cat "$file")"
                if [[ -n "$rating" ]]
                then
                    sed -i "s/rating=./rating=${input}/" \
                        "${cache_dir}/hash/images/$hash"
                else
                    echo "rating=$input" >> "${cache_dir}/hash/images/$hash"
                fi
                is_index_local "$ind" && update=1
            else
                error="Rating has to be in [0-5]"
            fi
        done
        [[ "$update" -eq 1 ]] && [[ "${optcurrent[fileinfo]}" == "ratings" ]] && \
            update_fileinfo
    fi
    clear_sequence --repeat
}

_execute() {
    local args="" base cmd cmd_prompt edit_args="" executed=0 input
    local input_autocomplete input_prompt nice ind nicer_args=""
    if [[ "$1" == "image" ]] # each image on its own
    then
        if get_image_index
        then
            for ind in "${image_index[@]}"
            do
                input_prompt="Command for [$((ind % batch + 1))]: "
                input_autocomplete="!"
                ! get_input && continue
                cmd=${input//%s/\"${image_names[$ind]}\"}
                base=$(basename "${image_names[$ind]}")
                nice=${input//%s/\"$base\"}
                cmd=${cmd//%e/\"${images[$ind]}\"}
                nice=${nice//%e/<edited_file>}
                cmd_prompt="$ ${nice}"
                eval_cmd && ((executed += 1))
            done
        fi
    elif [[ "$1" == "same" ]]
    then
        # shift in order to take the rest of the arguments as the command
        # to be executed
        shift
        execute_cmd="$*"
        if get_image_index
        then
            if [[ -n "$execute_cmd" ]]
            then
                input="$execute_cmd"
            else
                input_prompt="Command: "
                input_autocomplete="!"
                get_input
            fi
            if [[ -n "$input" ]]
            then
                for ind in "${image_index[@]}"
                do
                    cmd=${input//%s/\"${image_names[$ind]}\"}
                    base=$(basename "${image_names[$ind]}")
                    nice=${input//%s/\"$base\"}
                    cmd=${cmd//%e/\"${images[$ind]}\"}
                    nice=${nice//%e/<edited_file>}
                    cmd_prompt="$ ${nice}"
                    eval_cmd && ((executed += 1))
                done
            fi
        fi
    else # bundle images
        if get_image_index
        then
            for ind in "${image_index[@]}"
            do
                args+="\"${image_names[$ind]}\" "
                edit_args+="\"${images[$ind]}\" "
                nicer_args+="\"$(basename "${image_names[$ind]}")\" "
            done
            shift
            execute_cmd="$*"
            if [[ -n "$execute_cmd" ]]
            then
                input="$execute_cmd"
            else
                input_prompt="Command: "
                input_autocomplete="!"
                get_input
            fi
            if [[ -n "$input" ]]
            then
                cmd=${input//%S/$args}
                nice=${input//%S/$nicer_args}
                cmd=${cmd//%E/$edit_args}
                nice=${nice//%E/<edited files>}
                cmd_prompt="$ ${nice}"
                eval_cmd && ((executed += ${#image_index[@]}))
            fi
        fi
    fi
    if [[ "$executed" -eq 0 ]]
    then
        error="No executions"
    elif [[ "$executed" -lt "${#image_index[@]}" ]]
    then
        warning="Executed: $executed of ${#image_index[@]}"
    else
        success="Success"
    fi
    clear_sequence --repeat
    execute_cmd=
}

######################################################################
# Checks whether the provided index corresponds to an image and not
# another filetype, thus image_names and images need to be updated
# together
######################################################################
parallel_update() {
    [[ "${image_names[$1]}" == "${images[$1]}" ]] && return 0 || return 1
}

_rename() {
    local update=0 mv_i ind input input_prompt input_autocomplete pathto
    local cmd cmd_prompt
    if get_image_index
    then
        local renamed=0
        for ind in "${image_index[@]}"
        do
            input=
            input_prompt="New name for [$((ind % batch + 1))]: "
            input_left="$(basename "${image_names[$ind]}")"
            pathto="$(dirname "${image_names[$ind]}")"
            [[ "${#image_index[@]}" -eq 1 ]] && input="$1"
            if [[ -z "$input" ]]
            then
                ! get_input && continue
            fi
            cmd="mv \"${image_names[$ind]}\" \"$pathto/$input\""
            cmd_prompt="Rename [$((ind % batch + 1))] to: ${input}"
            if eval_cmd
            then
                ((renamed += 1))
                # in case of video or edited images we only update the name
                parallel_update "$ind" && images[$ind]="$input"
                image_names[$ind]="$input"
                is_index_local "$ind" && update=1
            fi
        done
        if [[ "$renamed" -eq 0 ]]
        then
            warning="No renames"
        elif [[ "$renamed" -lt "${#image_index[@]}" ]]
        then
            warning="Renamed: $renamed of ${#image_index[@]}"
        else
            success="Success"
        fi
        [[ "$update" -eq 1 ]] && [[ "${optcurrent[fileinfo]}" == "names" ]] && \
            update_fileinfo
    fi
    clear_sequence --repeat
}

_goto() {
    [[ "$prefix" =~ ^(;|\*+)$ ]] && prefix=
    if get_image_index
    then
        if [[ "$batch" -gt 1 ]]
        then
            wide_vertical=${optcurrent[gridlines]}
            wide_horizontal=${optcurrent[gridcolumns]}
        fi
        start="$image_index"
        optcurrent[gridlines]=1
        optcurrent[gridcolumns]=1
        redraw
    fi
    clear_sequence
}

_delete() {
    local cmd cmd_prompt del_i deleted=0 ind update=0
    if get_image_index
    then
        for ind in "${image_index[@]}"
        do
            ((ind -= deleted))
            cmd="mv \"${image_names[$ind]}\" \"$trash_dir\""
            cmd_prompt="Delete: $(basename "${image_names[$ind]}")"
            if eval_cmd
            then
                unset image_names["${image_index[$updated]}"]
                unset images["${image_index[$updated]}"]
                is_index_local "$ind" && update=1
                (( deleted += 1 ))
            fi
        done
        if [[ "$deleted" -eq 0 ]]
        then
            warning="No deletions"
        elif [[ "$deleted" -lt "${#image_index[@]}" ]]
        then
            warning="Deleted: $deleted of ${#image_index[@]}"
            image_names=("${image_names[@]}")
            images=("${images[@]}")
        else
            success="Success"
            image_names=("${image_names[@]}")
            images=("${images[@]}")
        fi
        [[ "$update" -eq 1 ]] && redraw
    fi
    clear_sequence --repeat
}

_tag() {
    local i update=0
    case $1 in
        tag)
            if get_image_index
            then
                for ind in "${image_index[@]}"
                do
                    [[ -z "${tags[$ind]}" ]] && \
                        tags[$ind]=1 && \
                        is_index_local "$ind" && update=1
                done
            fi
            ;;
        untag)
            if get_image_index
            then
                for ind in "${image_index[@]}"
                do
                    [[ -n "${tags[$ind]}" ]] && \
                        unset tags[$ind] && \
                        is_index_local "$ind" && update=1
                done
            fi
            ;;
    esac
    [[ "$update" -eq 1 ]] && update_fileinfo
    clear_sequence --repeat
}

_select() {
    [[ "$prefix" =~ ^(;|\*+)$ ]] && prefix=
    [[ -z "$prefix" ]] && prefix="1"
    local limit prefix_args
    IFS=" " read -r -a prefix_args <<< "$prefix"
    case "$1" in
        left)
            ((limit = (current / optcurrent[gridcolumns])))
            ((limit *= optcurrent[gridcolumns]))
            ((current -= prefix_args[0]))
            if [[ "$2" == "--nowrap" ]]
            then
                ((current < limit )) && ((current = limit))
            else
                ((current < 0)) && current=0
            fi
            ;;
        down)
            ((current += prefix_args[0] * optcurrent[gridcolumns]))
            while ((current >= show))
            do
                ((current -= optcurrent[gridcolumns]))
            done
            ;;
        up)
            ((current -= prefix_args[0] * optcurrent[gridcolumns]))
            while ((current < 0))
            do
                ((current += optcurrent[gridcolumns]))
            done
            ;;
        right)
            ((limit = (current / optcurrent[gridcolumns]) * optcurrent[gridcolumns]))
            ((limit += optcurrent[gridcolumns] - 1))
            ((current += prefix_args[0]))
            if [[ "$2" == "--nowrap" ]]
            then
                ((current > limit )) && ((current = limit))
            else
                ((current >= show)) && ((current = show - 1))
            fi
            ;;
        "")
            get_image_index && ((current = image_index[0]))
            ;;
    esac
    update_fileinfo
    clear_sequence
}

_rotate() {
    local counter=0 degrees
    while [[ -n "$1" ]]
    do
        case "$1" in
            "--degrees")
                degrees="$2"
                shift
                ;;
            "--counter")
                counter=1
        esac
        shift
    done
    [[ -z "$degrees" ]] && degrees=90
    [[ "$counter" -eq 1 ]] && ((degrees = -degrees))
    run_edit_script "convert -rotate $degrees %in% %out%"
}

