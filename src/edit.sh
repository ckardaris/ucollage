_write() {
    local cmd cmd_prompt hash ind local_changes=0 no_pending=0 saved=0
    local tmpfile
    if get_image_index
    then
        for ind in "${image_index[@]}"
        do
            tmpfile=${images[$ind]}
            case $tmpfile in
                (*.*) extension=${tmpfile##*.};;
                (*)   extension="";;
            esac
            hash=${tmpfile%.*([[:digit:]]).${extension}}
            hash=${hash#${tmp_dir}/}
            [[ -z ${edits[$ind]} ]] && ((no_pending += 1)) && continue
            cmd="cp -f \"${tmpfile}\" \"${image_names[$ind]}\""
            set_show_index
            cmd_prompt="Save edits${show_index}"
            if eval_cmd
            then
                ((saved += 1))
                images[$ind]="${image_names[$ind]}"
                rm "${tmp_dir}/$hash".* # delete all history
                unset edits["$ind"]
                read -rd ' ' new_hash < \
                    <(head -c 100000 "${image_names[$ind]}" 2>/dev/null | "$hashfunc")
                filehash[$ind]="$new_hash"
                if is_image
                then
                    mv "${cache_dir}/hash/images/$hash" "${cache_dir}/hash/images/$new_hash"
                elif is_video
                then
                    mv "${cache_dir}/hash/videos/$hash" "${cache_dir}/hash/videos/$new_hash"
                fi
                is_index_local "$ind" && local_changes=1
            fi
        done

        if [[ "$no_pending" -eq "${#image_index[@]}" ]]
        then
            warning="Nothing to save"
        else
            if [[ "$saved" -eq 0 ]]
            then
                warning="No images saved"
            elif [[ "$saved" -lt "${#image_index[@]}" ]]
            then
                warning="Saved: $saved of ${#image_index[@]}"
                [[ "$local_changes" -eq 1 ]] && update_fileinfo
            else
                success="Done"
                [[ "$local_changes" -eq 1 ]] && update_fileinfo
            fi
        fi
    fi
    clear_sequence --repeat
}

_history() {
    local file hash ind level old_exec_prompt="${optcurrent[execprompt]}"
    local redo_i redone=0 tmpfile undo_i undone=0
    optcurrent[execprompt]="noexecprompt"
    if [[ "$1" == "--undo" ]]
    then
        if get_image_index
        then
            for ind in "${image_index[@]}"
            do
                level=${edits[$ind]:-0}
                [[ "$level" -eq 0 ]] && continue
                file="${image_names[$ind]}"
                case $file in
                    (*.*) extension=${file##*.};;
                    (*)   extension="";;
                esac
                hash="${filehash[$ind]}"
                if [[ "$level" -eq 1 ]]
                then
                    tmpfile="$file"
                else
                    tmpfile="${tmp_dir}/${hash}.$((level - 1)).${extension}"
                fi
                ((undone += 1))
                ((edits[ind] -= 1))
                #unset if at start of history
                ((edits[ind] == 0)) && unset edits["$ind"]
                images[$ind]="$tmpfile"
                redraw
            done
            if [[ "$undone" -eq 0 ]]
            then
                message="Already at oldest change"
            elif [[ "$undone" -lt "${#image_index[@]}" ]]
            then
                warning="Undone: $undone of ${#image_index[@]}"
            else
                success="Success"
            fi
        fi
    elif [[ "$1" == "--redo" ]]
    then
        if get_image_index
        then
            for ind in "${image_index[@]}"
            do
                level=${edits[$ind]:-0}
                file="${image_names[$ind]}"
                case $file in
                    (*.*) extension=${file##*.};;
                    (*)   extension="";;
                esac
                hash="${filehash[$ind]}"
                tmpfile="${tmp_dir}/${hash}.$((level + 1)).${extension}"
                [[ ! -f "$tmpfile" ]] && continue
                ((redone += 1))
                ((edits[ind] += 1))
                images[$ind]="$tmpfile"
                redraw
            done
            if [[ "$redone" -eq 0 ]]
            then
                message="Already at newest change"
            elif [[ "$redone" -lt "${#image_index[@]}" ]]
            then
                warning="Redone: $redone of ${#image_index[@]}"
            else
                success="Success"
            fi
        fi
    fi
    optcurrent[execprompt]="$old_exec_prompt"
    clear_sequence --repeat
}

_edit() {
    local script="$*"
    local cmd edited=0 file hash ind level non_image=0
    local old_exec_prompt="${optcurrent[execprompt]}" tmpfile
    optcurrent[execprompt]="noexecprompt"
    if get_image_index
    then
        for ind in "${image_index[@]}"
        do
            level=${edits[$ind]}
            file="${image_names[$ind]}"
            case $file in
                (*.*) extension=${file##*.};;
                (*)   extension="";;
            esac
            hash="${filehash[$ind]}"
            ! is_image && ((non_image += 1)) && continue
            tmpfile="${tmp_dir}/${hash}.$((level + 1)).${extension}"
            cmd=${script//%s/\"${images[$ind]}\"}
            cmd=${cmd//%d/\"${tmpfile}\"}
            if eval_cmd
            then
                ((edited += 1))
                ((edits[ind] += 1))
                images[$ind]="$tmpfile"
                # now delete the other branch of the history if it exists
                ((level += 2))
                while [[ -f "${tmp_dir}/${hash}.$((level)).${extension}" ]]
                do
                    rm "${tmp_dir}/${hash}.$((level)).${extension}"
                    ((level += 1))
                done
                redraw
            fi
        done
        if [[ "$non_image" -eq "${#image_index[@]}" ]]
        then
            error="Editing supported only for images"
        else
            if [[ "$edited" -eq 0 ]]
            then
                warning="No images edited"
            elif [[ "$edited" -lt "${#image_index[@]}" ]]
            then
                warning="Edited: $edited of ${#image_index[@]}"
            else
                success="Success"
            fi
        fi
    fi
    optcurrent[execprompt]="$old_exec_prompt"
    clear_sequence --repeat
}
