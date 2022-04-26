######################################################################
# Loop waiting for user input to execute actions
######################################################################
loop() {
    local char key
    while true
    do
        [[ "$break_flag" -eq 1 ]] && break_flag=0 && break
        [[ "${#images[@]}" -eq 0 ]] && exit_flag=1
        [[ "$exit_flag" -eq 1 ]] && break
        key=
        char=
        while read -rsN1 -t 0.01 char &>/dev/null
        do
            key+="$char"
        done
        read -r dirty_flag < "${tmp_dir}/dirty"
        [[ -z "$key" ]] && [[ "$dirty_flag" -eq 0 ]] && continue
        # This is hack because $'\n' is not mapped correctly in map_cmd
        [[ "$key" == $'\n' ]] && key=$'\xD'
        case $key in
            $'\e')
                clear_sequence
                ;;
            [0-9])
                if [[ -z "$mapping" ]] && [[ ! "$prefix" =~ ^(\*+|;|#)$ ]]
                then
                    prefix+="$key"
                else
                    mapping+="$key"
                fi
                ;;
            " ")
                if [[ -z "$prefix" ]]
                then
                    mapping+="$key"
                elif [[ ! "$prefix" =~ ^(\*+|;|#)$ ]]
                then
                    prefix+="$key"
                fi
                ;;
            "*")
                if [[ -n "$mapping" ]]
                then
                    mapping+="$key"
                elif [[ "$prefix" =~ ^\*+$ ]]
                then
                    prefix="**"
                else
                    prefix="*"
                fi
                ;;
            ";"|"#")
                [[ -z "$mapping" ]] && prefix="$key" || mapping+="$key"
                ;;
            ":")
                command_mode
                ;;
            $'\b'|$'\x7F'|$'\x08')
                if [[ -n "$mapping" ]]
                then
                    mapping=${mapping:0:-1}
                elif [[ -n "$prefix" ]]
                then
                    prefix=${prefix:0:-1}
                elif [[ "$batch" -eq 1 ]]
                then
                    optcurrent[gridlines]="$wide_vertical"
                    optcurrent[gridcolumns]="$wide_horizontal"
                    ((current = (start % (wide_horizontal * wide_vertical))))
                    ((start = start - current))
                    redraw
                    clear_sequence
                elif [[ -z "$prefix" ]]
                then
                    mapping=$'\x8'
                fi
                ;;
            ".")
                eval "$repeat_command"
                ;;
            *)
                mapping+="$key"
                ;;
        esac
        # This is coded in order to not follow mappings that do not lead to
        # any action. It also prevents the program from hanging in case of
        # pressing a not printable character (e.g Home, End) that does not
        # map to any command
        if [[ -n "$mapping" ]]
        then
            if [[ -n "${map_cmd[$mapping]}" ]]
            then
                eval "${map_cmd[$mapping]}"
            else
                good=0
                for m in "${!map_cmd[@]}"
                do
                    if [[ "$mapping" == "${m:0:${#mapping}}" ]]
                    then
                        good=1
                        lastvalidmapping="$mapping"
                        break
                    fi
                done
                [[ "$good" -eq 0 ]] && mapping="$lastvalidmapping"
            fi
        else
            lastvalidmapping=""
        fi
        [[ "$exit_flag" -eq 1 ]] && continue
        if [[ "$dirty_flag" -eq 1 ]]
        then
            populate_arrays
        fi
        update_status
    done
}
