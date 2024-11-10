######################################################################
# Draws the current batch of images on the screen
######################################################################
show_batch() {
    local counter draw_lines i index j posx posy
    [[ "$show" -lt 1 ]] && return
    if [[ "${optcurrent[showfileinfo]}" == "showfileinfo" ]] && [[ "$show" -gt 1 ]]
    then
        # Substracting 3 lines is a hack. The names can be printed in
        # two lines, but ueberzug is not exact in its drawing on the
        # terminal lines for different window sizes.
        # So I give it some more room for error.
        (( draw_lines = photo_lines - 3 ))
    else
        draw_lines="$photo_lines"
    fi

    for ((i = optcurrent[gridlines] * optcurrent[gridcolumns]; \
        i < previous_batch; i++))
    do
        ueberzugpp cmd -s $SOCKET -a remove -i "ucollage$counter"
    done
    for ((i = 0; i < optcurrent[gridlines]; i++ ))

    do
        for ((j = 0; j < optcurrent[gridcolumns]; j++))
        do
            ((counter = i * optcurrent[gridcolumns] + j))
            ((index = start + counter))
            if [[ "${optcurrent[showfileinfo]}" == "showfileinfo" ]] && \
                [[ "$batch" -gt 1 ]]
            then
                (( posx = 1 + j * photo_columns))
                (( posy = 4 + i * photo_lines))
            else
                (( posx = j * photo_columns))
                (( posy = 3 + i * photo_lines))
            fi
            ueberzugpp cmd -s $SOCKET -a add -i "ucollage$counter" -x "$posx" -y "$posy" -f "${images[$index]}" --max-width "$photo_columns" --max-height "$draw_lines"
        done
    done
    (( previous_batch = optcurrent[gridlines] * optcurrent[gridcolumns]))
}

