######################################################################
# Calculates the parameters for the current view
######################################################################
calculate_dimensions() {
    local columns lines
    read -r lines columns < <(stty size)
    (( batch = optcurrent[gridcolumns] * optcurrent[gridlines] ))
    if [[ "${optcurrent[showfileinfo]}" == "showfileinfo" ]] && [[ "$batch" -gt 1 ]]
    then
        (( photo_columns = (columns - 2) / optcurrent[gridcolumns] ))
        (( photo_lines = (lines - 4) / optcurrent[gridlines] ))
    else
        (( photo_columns = columns / optcurrent[gridcolumns] ))
        (( photo_lines = (lines - 3) / optcurrent[gridlines] ))
    fi
    (( show = ${#images} - start ))
    [[ "$show" -gt "$batch" ]] && show="$batch"
    [[ "$current" -ge "$show" ]] && ((current = show - 1))
}

######################################################################
# Modifies the parameters needed to show another batch
######################################################################
_batch() {
    local input="$1" read_iter
    if [[ -z "$input" ]]
    then
        input_autocomplete="batch"
        input_prompt="Batch # "
        get_input
    fi
    read -r read_iter < "${tmp_dir}/read_iter"
    case $input in
        next)
            # There exists an edge case here when $show is less that
            # $batch, but we are not in the last batch of images
            # This can happen when we are loading the images in the background
            # and the user has changes the batch size with the 's' option
            # right after starting up.
            if ((show < batch)) && ((start + show < ${#images}))
            then
                : # start stays the same and we just load the rest of the images
            elif (( start + show < ${#images} ))
            then
                (( start += show ))
            else
                warning="End of files"
                [[ "$read_iter" -lt "$argc" ]] && warning="End of loaded files"
            fi
            ;;
        last)
            (( new_start = ${#images} - ((${#images} - 1) % batch + 1) ))
            if [[ "$new_start" -le "$start" ]]
            then
                warning="End of files"
                [[ "$read_iter" -lt "$argc" ]] && warning="End of loaded files"
            else
                start="$new_start"
            fi
            ;;
        previous)
            if [[ "$start" -eq 0 ]]
            then
                warning="Start of files"
            else
                (( start -= batch))
                # The below is useful in case of resizing
                # If I am in the second of batches of 10 and the
                # new window fits 20 then I don't want negative numbers
                [[ "$start" -lt 0 ]] && start=0
            fi
            ;;
        first)
            if [[ "$start" -eq 0 ]]
            then
                warning="Start of files"
            else
                start=0
            fi
            ;;
        *)
            [[ -n "$input" ]] && error="Unknown option: $input"
            ;;
    esac
    [[ -z "$warning" ]] && [[ -z "$error" ]] && redraw
    clear_sequence
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
