_write() {
    local cmd cmd_prompt hash ind local_changes=0 no_pending=0 saved=0
    local se_i tmpfile
    if get_image_index
    then
        for (( se_i = 0; se_i < index_count; se_i++))
        do
            ind=${image_index[$se_i]}
            tmpfile=${images[$ind]}
            case $tmpfile in
                (*.*) extension=${tmpfile##*.};;
                (*)   extension="";;
            esac
            hash=${tmpfile%.*([[:digit:]]).${extension}}
            hash=${hash#${tmp_dir}/}
            [[ -z ${edits[$ind]} ]] && ((no_pending += 1)) && continue
            cmd="cp -f \"${tmpfile}\" \"${image_names[$ind]}\""
            cmd_prompt="Save edits for ${image_names[$ind]}"
            if eval_cmd
            then
                ((saved += 1))
                images[$ind]="${image_names[$ind]}"
                rm "${tmp_dir}/$hash".* # delete all history
                unset edits["$ind"]
                read -rd ' ' hash < \
                    <(head -c 100000 "${image_names[$ind]}" 2>/dev/null | xxh128sum)
                filehash[$ind]="$hash"
                is_index_local "$ind" && local_changes=1
            fi
        done

        if [[ "$no_pending" -eq "$index_count" ]]
        then
            warning="Nothing to save"
        else
            if [[ "$saved" -eq 0 ]]
            then
                warning="No images saved"
            elif [[ "$saved" -lt "$index_count" ]]
            then
                warning="Saved: $saved of $index_count"
                [[ "$local_changes" -eq 1 ]] && update_fileinfo
            else
                success="Done"
                [[ "$local_changes" -eq 1 ]] && update_fileinfo
            fi
        fi
    fi
    clear_sequence --repeat
}

edit_history() {
    local file hash ind level old_exec_prompt="${optcurrent[execprompt]}"
    local redo_i redone=0 tmpfile undo_i undone=0
    optcurrent[execprompt]="noexecprompt"
    if [[ "$1" == "--undo" ]]
    then
        if get_image_index
        then
            for (( undo_i = 0; undo_i < index_count; undo_i++))
            do
                ind=${image_index[$undo_i]}
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
            elif [[ "$undone" -lt "$index_count" ]]
            then
                warning="Undone: $undone of $index_count"
            else
                success="Success"
            fi
        fi
    elif [[ "$1" == "--redo" ]]
    then
        if get_image_index
        then
            for (( redo_i = 0; redo_i < index_count; redo_i++))
            do
                ind=${image_index[$redo_i]}
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
            elif [[ "$redone" -lt "$index_count" ]]
            then
                warning="Redone: $redone of $index_count"
            else
                success="Success"
            fi
        fi
    fi
    optcurrent[execprompt]="$old_exec_prompt"
    clear_sequence --repeat
}