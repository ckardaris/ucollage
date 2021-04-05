######################################################################
# Draws filenames under the images on the screen
######################################################################
print_fileinfo() {
    local columns i lines
    read -r lines columns < <(stty size)
    for ((i = 4; i <= lines; i++))
    do
        printf "\e[B\e[%s;1H" "$i"
        # not using %s because I want to parse the escape characters
        printf "${line_names[$((i - 4))]}"
    done
}

######################################################################
# Update the fileinfo to account for batch changes, file renaming or rating
######################################################################
update_fileinfo() {
    [[ "${optcurrent[showfileinfo]}" == "noshowfileinfo" ]] || \
        [[ "$batch" -eq 1 ]] && \
        clear_fileinfo && return
    local cnt columns current_in_line current_name i j linelength lines
    local namelength row stars total_lines
    local -a line_names=()
    read -r lines columns < <(stty size)

    (( total_lines = (show - 1) / optcurrent[gridcolumns] + 1))
    line_names[0]="┌"
    line_names[$((total_lines * photo_lines))]="└"
    for ((j = 1; j < columns - 1; j++))
    do
        line_names[0]+="─"
        line_names[$((total_lines * photo_lines))]+="─"
    done
    line_names[0]+="┐"
    line_names[$((total_lines * photo_lines))]+="┘"

    cnt=0
    for ((i = 1; i < total_lines * photo_lines; i++))
    do
        current_in_line=0
        if ((i % photo_lines == 0))
        then
            line_names[$i]="├"
            for ((j = 1; j < columns - 1; j++))
            do
                line_names[$i]+="─"
            done
            line_names[$i]+="┤"
        elif ((i % photo_lines ==  photo_lines - 1))
        then
            line_names[$i]="│"
            ((row = (i - 1) / photo_lines))
            for ((j = 0; j < optcurrent[gridcolumns]; j++, cnt++))
            do
                (( index = start + row * optcurrent[gridcolumns] + j))
                if [[ "$cnt" -lt "$show" ]]
                then
                    current_name="$((index + 1 - start)): "
                    case "${optcurrent[fileinfo]}" in
                        "ratings")
                            set_stars stars "$index"
                            current_name+="$stars"
                            ;;
                        "names")
                            current_name+="$(basename "${image_names[$index]}")"
                            [[ -n ${edits[$index]} ]] && \
                                current_name="~ ${current_name}"
                            [[ -n ${tags[$index]} ]] && \
                                current_name="* ${current_name}"
                            ;;
                    esac
                    (( max_length = photo_columns - 2 ))
                    current_name=${current_name:0:$max_length}
                    namelength="${#current_name}"
                    if (( index - start == current))
                    then
                        current_name="\e[7m$current_name\e[m"
                        current_in_line=1
                    fi
                    pad_sides $((photo_columns - namelength))
                    line_names[$i]+="$current_name"
                fi
            done
            linelength=${#line_names[$i]}
            # substract the inversion escape chars
            [[ "$current_in_line" -eq 1 ]] && ((linelength -= 9))
            for ((j = linelength; j < columns - 1; j++))
            do
                line_names[$i]+=" "
            done
            line_names[$i]+="│"
        else
            line_names[$i]="│"
            for ((j = 1; j < columns - 1; j++))
            do
                line_names[$i]+=" "
            done
            line_names[$i]+="│"

        fi
    done

    for ((i = total_lines * photo_lines + 1; i < lines - 3; i++))
    do
        line_names[$i]=
        for ((j = 0; j < columns; j++))
        do
            line_names[$i]+=" "
        done
    done
    print_fileinfo
}
