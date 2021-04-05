run_use_script() {
    local script="$1" cmd_prompt_base="$2"
    local cmd cmd_prompt executed=0 ind sc_i
    if get_image_index
    then
        for (( sc_i = 0; sc_i < index_count; sc_i++))
        do
            ind=${image_index[$sc_i]}
            cmd="${script//%in%/\"${image_names[$ind]}\"}"
            cmd_prompt="${cmd_prompt_base}: "
            cmd_prompt+="\"$(basename -a "${image_names[$ind]}" | \
                tr '\n' ' ' | head -c-1)\""
            eval_cmd && ((executed += 1))
        done
        if [[ "$executed" -eq 0 ]]
        then
            warning="No executions"
        elif [[ "$executed" -lt "$index_count" ]]
        then
            warning="Executed: $executed of $index_count"
        else
            success="Success"
        fi
    fi
    clear_sequence --repeat
}

run_edit_script() {
    local script="$1"
    local cmd edited=0 file hash ind level non_image=0
    local old_exec_prompt="${optcurrent[execprompt]}" sc_i tmpfile
    optcurrent[execprompt]="noexecprompt"
    if get_image_index
    then
        for (( sc_i = 0; sc_i < index_count; sc_i++))
        do
            ind=${image_index[$sc_i]}
            level=${edits[$ind]}
            file="${image_names[$ind]}"
            case $file in
                (*.*) extension=${file##*.};;
                (*)   extension="";;
            esac
            hash="${filehash[$ind]}"
            ! is_image && ((non_image += 1)) && continue
            tmpfile="${tmp_dir}/${hash}.$((level + 1)).${extension}"
            cmd=${script//%in%/\"${images[$ind]}\"}
            cmd=${cmd//%out%/\"${tmpfile}\"}
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
        if [[ "$non_image" -eq "$index_count" ]]
        then
            error="Editing supported only for images"
        else
            if [[ "$edited" -eq 0 ]]
            then
                warning="No images edited"
            elif [[ "$edited" -lt "$index_count" ]]
            then
                warning="Edited: $edited of $index_count"
            else
                success="Success"
            fi
        fi
    fi
    optcurrent[execprompt]="$old_exec_prompt"
    clear_sequence --repeat
}
