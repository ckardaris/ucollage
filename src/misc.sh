redraw() {
    calculate_dimensions
    show_batch
    update_fileinfo
}

update_reverse(){
    if [[ "$dirty_flag" -eq 0 ]]
    then
        reverse_images
        start=0
        redraw
    else # we have not read all images so we need to go from the start
        break_flag=1
    fi
}

clear_sequence() {
    if [[ "$1" = "--repeat" ]]
    then
        repeat_prefix="$prefix"
        [[ -n "$mapping" ]] && repeat_command="${map_cmd[$mapping]}"
    fi
    lastvalidmapping=
    prefix=
    mapping=
}

