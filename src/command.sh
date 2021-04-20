command_mode(){
        local cleanup=1 enter=0 input input_autocomplete="ucollage" input_left
        local input_prompt=":" input_right mode="command"
        [[ -n "$prefix" ]] && input_left="($prefix) "
        while [[ -n "$1" ]]
        do
            case "$1" in
                -l|--left)
                    while [[ ! "$2" =~ ^(-r|--right|-e|--enter)$ ]] && [[ -n "$2" ]]
                    do
                        input_left+="$2 "
                        shift
                    done
                    input_left=${input_left%% }
                    ;;
                -r|--right)
                    while [[ ! "$2" =~ ^(-l|--left|-e|--enter)$ ]] && [[ -n "$2" ]]
                    do
                        input_right+="$2 "
                        shift
                    done
                    input_right=${input_right%% }
                    ;;
                -e|--enter)
                    enter=1
                    ;;
            esac
            shift
        done
        [[ "$enter" -eq 1 ]] && input="${input_left}${input_right}"
        if [[ -n "$input" ]] || get_input
        then
            save_input=
            prefix=${input#*\(}
            prefix=${prefix%%)*}
            trim_spaces prefix
            [[ "$prefix" == "$input" ]] && prefix=
            [[ -n "$prefix" ]] && save_input+="($prefix) "
            full_cmd=${input#*)}
            trim_spaces full_cmd
            save_input+="$full_cmd"
            if [[ -n "$full_cmd" ]]
            then
                echo "$save_input" >> "$cache_dir/cmd_history"
                read -r cmd _ <<< "$full_cmd" # we take only the first word
                if [[ -n ${colon_cmd[$cmd]} ]]
                then
                    eval_cmd="${full_cmd//$cmd/${colon_cmd[$cmd]}}"
                    eval "$eval_cmd"
                    cleanup=0 # cleanup is being done by the executed function
                    # The setting of repeat_command has to happen after the eval
                    # because we want it to override the repeat_command with the
                    # exact parameters that we gave.
                    repeat_command="command_mode --left \"$full_cmd\""
                else
                    error="Command not found: $cmd"
                fi
            fi
        fi
        if [[ "$cleanup" -eq 1 ]]
        then
            clear_sequence
        fi
        mode=
}
