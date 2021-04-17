set_scripts(){
    local -a file_data
    local ci command errors=0 i info line map mi script type
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
    for ((i = 0; i < ${#file_data[@]}; i++))
    do
        line=${file_data[$i]}
        trim_spaces line "[ ]"
        if [[ "$line" =~ ^\[.*\]$ ]]
        then
            info=${line#[}
            info=${info%]}

            type=${file_data[$((i + 1))]##type}
            trim_spaces type

            map=${file_data[$((i + 2))]##map}
            trim_spaces map
            translate_map map

            script=${file_data[$((i + 3))]##script}
            trim_spaces script

            command=${file_data[$((i + 4))]##command}
            trim_spaces command

            if [[ "$type" == "edit" ]]
            then
                if [[ ! "$script" =~ %s ]]
                then
                    echo "Error: configuration"
                    echo "--------------------"
                    echo "Value: $script"
                    echo "Valid: %s placeholder missing"
                    echo "--------------------"
                    errors=1
                elif [[ ! "$script" =~ %d ]]
                then
                    echo "Error: configuration"
                    echo "--------------------"
                    echo "Value: $script"
                    echo "Valid: %d placeholder missing"
                    echo "--------------------"
                    errors=1
                else
                    for mi in $map
                    do
                        # <Space> has to be substituted here or else it is split
                        # by the 'for' expansion
                        mi=${mi//<Space>/ }
                        map_cmd[$mi]="_edit ${script}"
                    done
                    for ci in $command
                    do
                        colon_cmd[$ci]="_edit ${script}"
                    done
                fi
            elif [[ "$type" == "use" ]]
            then
                for mi in $map
                do
                    # <Space> has to be substituted here or else it is split
                    # by the 'for' expansion
                    mi=${mi//<Space>/ }
                    map_cmd[$mi]="_execute ${script}"
                done
                for ci in $command
                do
                    colon_cmd[$ci]="_execute ${script}"
                done
            elif [[ "$type" == "builtin" ]]
            then
                for mi in $map
                do
                    # <Space> has to be substituted here or else it is split
                    # by the 'for' expansion
                    mi=${mi//<Space>/ }
                    map_cmd[$mi]="${script}"
                done
                for ci in $command
                do
                    colon_cmd[$ci]="${script}"
                done
            fi
            ((i += 4))
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
    accept_regexp="^(names|ratings)$"
    valid_values="names, ratings"
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

    [[ "$errors" -eq 1 ]] && read -rsN1 -p "Using default variables..." && echo
}
