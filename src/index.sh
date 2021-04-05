######################################################################
# Checks if all indices given as input are valid
######################################################################
valid_indices() {
    local i
    for (( i = 0; i < index_count; i++ ))
    do
        if ! is_natural ${image_index[i]}
        then
            error="NaN: ${image_index[$i]}" && return 1
        elif (( image_index[i] <= 0 || image_index[i] > show ))
        then
            error="Index out of bounds: ${image_index[$i]}" && return 1

        fi
    done
    return 0
}

######################################################################
# Selects all indices given the scope
######################################################################
all_indices() {
    image_index=()
    local i
    if [[ "$1" == "--global" ]]
    then
        for ((i = 1; i <= total; i++ ))
        do
            image_index+=("$i")
        done
    else
        for ((i = 1; i <= show; i++ ))
        do
            image_index+=("$i")
        done
    fi
}

######################################################################
# Set the image_index to operate on (array of indices)
######################################################################
get_image_index() {
    unset image_index
    local i star=0
    [[ "$prefix" == "#" ]] && prefix="$repeat_prefix"
    if [[ "$prefix" == ";" ]]
    then
        for (( i = 1; i <= total; i++ ))
        do
            # indices start from 0 in tag array
            [[ -n ${tags[$((i - 1))]} ]] && image_index+=("$i")
        done
        [[ "${#image_index[@]}" -eq 0 ]] && \
            warning="No tagged images" && return 1
    elif [[ "$prefix" =~ ^\*\* ]]
    then
        all_indices --global
        star=2
    elif [[ "$prefix" =~ ^\* ]]
    then
        all_indices --local
        star=1
    elif [[ -n "$prefix" ]]
    then
        IFS=" " read -r -a image_index <<< "$prefix"
        index_count=${#image_index[@]}
        ! valid_indices && return 1
    # no prefix given
    elif [[ "$batch" -eq 1 ]] # no-prefix, just the key pressed
    then
        image_index[0]=1
    else
        image_index[0]="$((current + 1))"
    fi

    index_count=${#image_index[@]}
    [[ "$index_count" -eq 0 ]] && return 1

    for (( i = 0; i < index_count; i++ ))
    do
        (( image_index[i] -= 1 )) #adjust index for arrays
    done
    if [[ "$star" -lt 2 ]] ## if ** is used then the indices are correct
    then
        for (( i = 0; i < index_count; i++ ))
        do
            (( image_index[i] += start))
        done
    fi
    return 0
}
