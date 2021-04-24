set_scripts(){
    local -a file_data
    local ci command errors=0 i info line map mi umi script type unmap
    # First we map the builtin commands and then the user defined. The order is
    # that way so that the user can override the defaults.
    if [[ -f "$CONFIG_DEFAULT" ]] && [[ -f "$CONFIG_SCRIPTS_FILE" ]]
    then
        mapfile -t file_data < <(cat "$CONFIG_DEFAULT" "$CONFIG_SCRIPTS_FILE")
    elif [[ ! -f "$CONFIG_DEFAULT" ]]
    then
        echo "Error: Default mappings and commands not found"
        echo "Location: $CONFIG_DEFAULT"
        echo "--------------------"
        read -rsN1
        mapfile -t file_data < "$CONFIG_SCRIPTS_FILE"
    else
        mapfile -t file_data < "$CONFIG_DEFAULT"
    fi
    for line in "${file_data[@]}"
    do
        if [[ ! "$line" =~ ^# ]]
        then
            type="" map="" script="" command="" unmap=""
            ! eval "$line" && continue
            trim_spaces type
            trim_spaces map
            trim_spaces unmap
            translate_map map
            trim_spaces script
            trim_spaces command

            for umi in $unmap
            do
                unset map_cmd[$umi]
            done
            for mi in $map
            do
                # <Space> has to be substituted here or else it is split
                # by the 'for' expansion
                mi=${mi//<Space>/ }
                map_cmd[$mi]="_wrapper ${script}"
            done
            for ci in $command
            do
                colon_cmd[$ci]="_wrapper ${script}"
            done
        fi
    done
    [[ "$errors" -eq 1 ]] && read -rsN1
    spacelist[ucollage]="${!colon_cmd[*]}"
}

check_config_variable() {
    [[ -z "${!variable_name}" ]] && return
    eval "[[ \"${!variable_name}\" =~ $accept_regexp ]]" && return
    if [[ "$errors" -eq 0 ]]
    then
        echo "Error: configuration"
        echo "--------------------"
    fi
    echo "[$variable_name]"
    echo "Value: ${!variable_name}"
    echo "Valid: $valid_values"
    echo "--------------------"
    eval "${variable_name}=" #unset the variable
    errors=1
}

parse_config() {
    local accept_regexp errors=0 valid_values variable_name

    variable_name="UCOLLAGE_LINES"
    accept_regexp="^([1-9][0-9]*|0+[1-9][0-9]*)$" # is natural
    valid_values="natural numbers"
    check_config_variable

    variable_name="UCOLLAGE_COLUMNS"
    accept_regexp="^([1-9][0-9]*|0+[1-9][0-9]*)$"
    valid_values="natural numbers"
    check_config_variable

    variable_name="UCOLLAGE_EXEC_PROMPT"
    accept_regexp="^(no|)execprompt$"
    valid_values="noexecprompt, execprompt"
    check_config_variable

    variable_name="UCOLLAGE_SHOW_FILEINFO"
    accept_regexp="^(no|)showfileinfo$"
    valid_values="noshowfileinfo, showfileinfo"
    check_config_variable

    variable_name="UCOLLAGE_FILEINFO"
    accept_regexp="^(names|ratings|categories)$"
    valid_values="names, ratings, categories"
    check_config_variable

    variable_name="UCOLLAGE_EXPAND_DIRS"
    accept_regexp="^(0|1|ask)$"
    valid_values="0, 1, ask"
    check_config_variable

    variable_name="UCOLLAGE_SORT"
    accept_regexp="^(name|time|size|extension)$"
    valid_values="name, time, size, extension"
    check_config_variable

    variable_name="UCOLLAGE_SORT_REVERSE"
    accept_regexp="^(no|)reverse$"
    valid_values="noreverse, reverse"
    check_config_variable

    variable_name="UCOLLAGE_SCALER"
    accept_regexp="^(crop|distort|fit_contain|contain|forced_cover|cover)$"
    valid_values="crop, distort, fit_contain, contain, forced_cover, cover"
    check_config_variable

    variable_name="UCOLLAGE_VIDEO_THUMBNAILS"
    accept_regexp="^(0|1)$"
    valid_values="0, 1"
    check_config_variable

    variable_name="UCOLLAGE_CACHE_THUMBNAILS"
    accept_regexp="^(0|1)$"
    valid_values="0, 1"
    check_config_variable

    variable_name="UCOLLAGE_THUMBNAIL_WIDTH"
    accept_regexp="^([1-9][0-9]*|0+[1-9][0-9]*)$" # is natural
    valid_values="natural numbers"
    check_config_variable

    variable_name="UCOLLAGE_MAX_LOAD"
    accept_regexp="^([1-9][0-9]*|0+[1-9][0-9]*)$" # is natural
    valid_values="natural numbers"
    check_config_variable

    variable_name="UCOLLAGE_HASHFUNC"
    if ! command -v "$UCOLLAGE_HASHFUNC" &>/dev/null
    then
        if [[ "$errors" -eq 0 ]]
        then
            echo "Error: configuration"
            echo "--------------------"
        fi
        echo "[$variable_name]"
        echo "Value: ${!variable_name}"
        echo "Valid: a  valid hash function program (e.g. md5sum)"
        echo "--------------------"
        eval "${variable_name}=" #unset the variable
        errors=1
    fi

    [[ "$errors" -eq 1 ]] && read -rsN1 -p "Using default variables..." && echo
}

config() {
    parse_config
    set_scripts
}
