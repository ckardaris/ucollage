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
                trim_spaces input
            fi
            if [[ "$input" =~ ^(0|1|2|3|4|5)$ ]]
            then
                hash="${filehash[$ind]}"
                rating=
                file=
                getfile
                eval "$(grep -h rating "$file" 2>/dev/null)"
                if [[ -n "$rating" ]]
                then
                    sed -i "s/rating=./rating=${input}/" "$file"
                else
                    echo "rating=$input" >> "$file"
                fi
                is_index_local "$ind" && update=1
            else
                error="Rating has to be in [0-5]"
            fi
        done
        [[ "$update" -eq 1 ]] && optcurrent[fileinfo]="ratings" && \
            update_fileinfo
    fi
    clear_sequence --repeat
}

_categorize() {
    declare -A catarr
    if get_image_index
    then
        for ind in "${image_index[@]}"
        do
            if [[ -n "$*" ]]
            then
                input="$*"
            else
                input_prompt="Categories for [$((ind % batch + 1))]: "
                input_autocomplete="rating"
                ! get_input && continue
            fi
            hash="${filehash[$ind]}"
            categories=
            file=
            getfile
            eval "$(grep -h categories "$file" 2>/dev/null)"
            categories=${categories//,/ }
            trim_spaces categories

            for cat in $categories
            do
                catarr[$cat]=""
            done
            for cat in $input
            do
                case "$cat" in
                    +*)
                        new="${cat:1}"
                        [[ -n "$new" ]] && catarr[$new]=""
                        is_index_local "$ind" && update=1
                        ;;
                    -*)
                        new="${cat:1}"
                        [[ -n "$new" ]] && unset catarr[$new]
                        is_index_local "$ind" && update=1
                        ;;
                    =*)
                        new="${cat:1}"
                        unset catarr
                        declare -A catarr
                        [[ -n "$new" ]] && catarr[$new]=""
                        is_index_local "$ind" && update=1
                        ;;
                esac
            done
            new_categories="${!catarr[@]}"
            new_categories="${new_categories// /,},"
            if [[ -n "$categories" ]]
            then
                sed -i "s/categories.*/categories=${new_categories}/" "$file"
            else
                echo "categories=$new_categories" >> "$file"
            fi
        done
        [[ "$update" -eq 1 ]] && optcurrent[fileinfo]="categories" && \
            update_fileinfo
    fi
    clear_sequence --repeat
}

_execute() {
    local args="" base cmd cmd_prompt edit_args="" executed=0 input
    local input_autocomplete input_prompt nice ind
    input="$*"
    if [[ -n "$input" ]]
    then
        if [[ "$input" =~ %(s|e) ]]
        then
            execute_cmd="$input"
            if get_image_index
            then
                for ind in "${image_index[@]}"
                do
                    cmd=${input//%s/\"${image_names[$ind]}\"}
                    base=$(basename "${image_names[$ind]}")
                    nice=${input//%s/[$((ind - start + 1))]}
                    cmd=${cmd//%e/\"${images[$ind]}\"}
                    nice=${nice//%e/[$((ind - start + 1)) - edited]}
                    cmd_prompt="$ ${nice}"
                    eval_cmd && ((executed += 1))
                done
            fi
        else # bundle images
            if get_image_index
            then
                for ind in "${image_index[@]}"
                do
                    args+="\"${image_names[$ind]}\" "
                    edit_args+="\"${images[$ind]}\" "
                done
                select="${select%%*( )}"
                execute_cmd="$input"
                cmd=${input//%S/$args}
                nice=${input//%S/[${prefix:-$((current + 1))}]}
                cmd=${cmd//%E/$edit_args}
                nice=${nice//%E/[${prefix:-$((current + 1))} - edited]}
                cmd_prompt="$ ${nice}"
                eval_cmd && ((executed += ${#image_index[@]}))
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
        [[ "$update" -eq 1 ]] && optcurrent[fileinfo]="names" && \
            update_fileinfo
    fi
    clear_sequence --repeat
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
    local i update=0 filter="" strict=0 type ct rating categories hash
    while [[ -n "$1" ]]
    do
        case "$1" in
            eq)
                filter+="((rating == $2)) && [[ -n \${rating} ]] "
                optcurrent[fileinfo]="ratings"
                shift
                ;;
            ne)
                filter+="((rating != $2)) && [[ -n \${rating} ]] "
                optcurrent[fileinfo]="ratings"
                shift
                ;;
            gt)
                filter+="((rating > $2)) && [[ -n \${rating} ]] "
                optcurrent[fileinfo]="ratings"
                shift
                ;;
            lt)
                filter+="((rating < $2)) && [[ -n \${rating} ]] "
                optcurrent[fileinfo]="ratings"
                shift
                ;;
            ge)
                filter+="((rating >= $2)) && [[ -n \${rating} ]] "
                optcurrent[fileinfo]="ratings"
                shift
                ;;
            le)
                filter+="((rating <= $2)) && [[ -n \${rating} ]] "
                optcurrent[fileinfo]="ratings"
                shift
                ;;
            and)
                filter+="&& "
                ;;
            or)
                filter+="|| "
                ;;
            +*)
                filter+="[[ -n "\${catarr[${1:1}]}" ]] "
                optcurrent[fileinfo]="categories"
                ;;
            -*)
                filter+="[[ -z "\${catarr[${1:1}]}" ]] "
                optcurrent[fileinfo]="categories"
                ;;
            "{")
                filter+=" { "
                ;;
            "}")
                filter+=" ; } "
                ;;
            tag)
                type="tag"
                ;;
            untag)
                type="untag"
                ;;
            strict)
                strict=1
                ;;
        esac
        shift
    done
    case $type in
        tag)
            if get_image_index
            then
                for ind in "${image_index[@]}"
                do
                    if [[ -n "$filter" ]]
                    then
                        hash="${filehash[$ind]}"
                        getfile
                        rating=
                        categories=
                        unset catarr
                        local -A catarr
                        eval $(grep -h rating "$file" 2>/dev/null)
                        eval $(grep -h categories "$file" 2>/dev/null)
                        categories=${categories//,/ }
                        for ct in $categories
                        do
                            catarr[$ct]="1"
                        done
                    fi
                    if eval "$filter" && [[ -z "${tags[$ind]}" ]]
                    then
                        tags[$ind]=1
                        is_index_local "$ind" && update=1
                    elif [[ "$strict" -eq 1 ]] && \
                        ! eval "$filter" &>/dev/null && \
                        [[ -n "${tags[$ind]}" ]]
                    then
                        unset tags[$ind]
                        is_index_local "$ind" && update=1
                    fi
                done
            fi
            ;;
        untag)
            if get_image_index
            then
                for ind in "${image_index[@]}"
                do
                    if [[ -n "$filter" ]]
                    then
                        hash="${filehash[$ind]}"
                        getfile
                        rating=
                        categories=
                        unset catarr
                        local -A catarr
                        eval $(grep -h rating "$file" 2>/dev/null)
                        eval $(grep -h categories "$file" 2>/dev/null)
                        categories=${categories//,/ }
                        for ct in $categories
                        do
                            catarr[$ct]="1"
                        done
                    fi
                    ! eval "$filter" &>/dev/null && continue
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
