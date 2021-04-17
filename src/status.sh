######################################################################
# Set information relating to the current view
######################################################################
set_info() {
    local begin lines columns photo_name stars finish tlen elen sel_info=
    local length padding
    read -r lines columns < <(stty size)
    read -r read_iter < "${tmp_dir}/read_iter"
    ((begin = start + 1))
    info=" ${optcurrent[gridlines]} x ${optcurrent[gridcolumns]}"
    info_total="${#images}"
    ((read_iter < argc)) && info_total+=" ($((argc - read_iter)) unloaded)"
    if [[ "$batch" -eq 1 ]]
    then
        photo_name=$(basename "${image_names[$start]}")
        [[ -n ${edits[$start]} ]] && photo_name="~ ${photo_name}"
        [[ -n ${tags[$start]} ]] && photo_name="* ${photo_name}"
        info+=" │ $begin/$info_total │ ${photo_name}"
        set_stars stars "$start"
        [[ -n "$stars" ]] && info+=" | $stars"
    else
        ((finish = begin + show - 1))
        info+=" │ [$begin-$finish]/$info_total"
    fi
    tlen=${#tags[@]}
    elen=${#edits[@]}
    [[ "$tlen" -gt 0 ]] && info+=" │ * ${tlen}"
    [[ "$elen" -gt 0 ]] && info+=" │ ~ ${elen}"
    [[ "${optcurrent[showfileinfo]}" == "noshowfileinfo" ]] && \
        [[ "$batch" -gt 1 ]] && sel_info=" | ∙ $((current + 1)) "
    length=${#info}
    ((length += ${#sel_info}))
    (( padding = columns - length))
    for ((i = 0; i < padding; i++))
    do
        info+=" "
    done
    info+="$sel_info"
}

######################################################################
# Update the status line
######################################################################
update_status() {
    local columns length lines new_status prefix_status
    local -a line=()
    printf "\e[?25l"
    read -r lines columns < <(stty size)
    set_info
    info=${info:0:$columns}
    line[0]="\e[H\e[107;30m${info}\e[m\n"

    if [[ -n "$success" ]]
    then
        length="${#success}"
        line[1]="\e[32m${success:0:$((columns - 25))}\e[m"
    elif [[ -n "$error" ]]
    then
        line[1]="\e[1;7m\e[31m${error:0:$((columns - 25))}\e[m"
        length="${#error}"
    elif [[ -n "$warning" ]]
    then
        line[1]="\e[33m${warning:0:$((columns - 25))}\e[m"
        length="${#warning}"
    elif [[ -n "$message" ]]
    then
        line[1]="${message:0:$((columns - 25))}"
        length="${#message}"
    fi
    for ((i = length; i < columns-20; i++))
    do
        line[1]+=" "
    done

    if [[ -n "$prefix" ]] && [[ -n "$mapping" ]]
    then
        prefix_status="($prefix)$mapping"
    elif [[ -n "$mapping" ]]
    then
        prefix_status="$mapping"
    elif [[ -n "$prefix" ]]
    then
        prefix_status="($prefix)"
    else
        prefix_status=
    fi
    [[ ${#prefix_status} -gt 15 ]] && prefix_status=${prefix_status: -15}

    for ((i = ${#prefix_status}; i < 20; i++))
    do
        prefix_status+=" "
    done
    line[1]+="\e[2;1H\e[$((columns - 20))C${prefix_status}"

    new_status="${line[0]}${line[1]}"
    if [[ "$new_status" != "$status" ]]
    then
        printf "\e[H$new_status"
        success=
        error=
        warning=
        message=
    fi
}

