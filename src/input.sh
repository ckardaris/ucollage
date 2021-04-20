######################################################################
# Escapes special characters in filenames in order to not have a problem
# with command execution
######################################################################
escape_name() {
    local -n name="$1"
    name="${name// /\\ }"
    name="${name//\(/\\\(}"
    name="${name//\)/\\\)}"
    name="${name//\{/\\\{}"
    name="${name//\}/\\\}}"
}

######################################################################
# Gets input from the user
######################################################################
get_input() {
    local available char cmd_history_index columns input_history key lines
    local move="" stop string suggestion suggestion_count suggestion_index
    local -a cmd_history=()
    read -r lines columns < <(stty size)
    available="$columns"
    clearline
    printf "\e[?25h%s\e7" "$input_prompt"
    ((available -= ${#input_prompt} + 1))
    while [[ "$exit_flag" -eq 0 ]]
    do
        printf "\e8\e[K"
        input_right="${input_right%%*( )}"
        [[ -n "$input_right" ]] && move="\e[${#input_right}D" || move=
        if [[ -n "$suggestion" ]]
        then
            string="$suggestion$input_right"
            [[ "${#string}" -gt "$available" ]] && string=${string: -${available}}
            printf "%s$move" "$string"
        elif [[ -n "$input_history" ]]
        then
            [[ "${#input_history}" -gt "$available" ]] && \
                input_history=${input_history: -${available}}
            printf "%s" "$input_history"
        else
            string="$input_left$input_right"
            [[ "${#string}" -gt "$available" ]] && string=${string: -${available}}
            printf "%s$move" "$string"
        fi
        key=
        char=
        while read -rsN1 -t 0.01 char &>/dev/null
        do
            key+="$char"
        done
        [[ -z "$key" ]] && continue
        case "$key" in
            $'\e[A') #up arrow press
                if [[ "$mode" == "command" ]]
                then
                    if [[ "${#cmd_history[@]}" -eq 0 ]]
                    then
                        mapfile -t cmd_history < \
                            <(grep "^${input_left}${input_right}" \
                            "$cache_dir/cmd_history" | uniq)
                        cmd_history_index=${#cmd_history[@]}
                    fi
                    ((cmd_history_index -= 1))
                    [[ "$cmd_history_index" -lt 0 ]] && cmd_history_index=0
                    input_history=${cmd_history[$cmd_history_index]}
                fi
                ;;
            $'\e[B') #down arrow press
                if [[ "$mode" == "command" ]]
                then
                    [[ "${#cmd_history[@]}" -eq 0 ]] && continue
                    ((cmd_history_index += 1))
                    [[ "$cmd_history_index" -gt ${#cmd_history[@]} ]] && \
                        cmd_history_index=${#cmd_history[@]}
                    input_history=${cmd_history[$cmd_history_index]}
                fi
                ;;
            $'\e[C') #right arrow press
                clear_suggestions
                clear_history
                if [[ -n "$input_right" ]]
                then
                    input_left="$input_left${input_right:0:1}"
                    input_right="${input_right:1}"
                fi
                ;;
            $'\e[D') #left arrow press
                clear_suggestions
                clear_history
                if [[ -n "$input_left" ]]
                then
                    input_right="${input_left: -1}$input_right"
                    input_left="${input_left:0:-1}"
                fi
                ;;
            $'\e[1;5C') #Ctrl + right arrow press
                # we have to stop at next non-alnum character
                clear_suggestions
                clear_history
                stop=${input_right##*([^[:alnum:]])*([[:alnum:]])}
                if [[ -z "$stop" ]]
                then
                    input_left+="$input_right"
                    input_right=
                else
                    input_left+="${input_right:0: -${#stop}}"
                    input_right=${input_right: -${#stop}}
                fi
                ;;
            $'\e[1;5D') #Ctrl + left arrow press
                # we have at the first alnum of the last alnum sequence
                clear_suggestions
                clear_history
                stop=${input_left%%*([[:alnum:]])*([^[:alnum:]])}
                input_right="${input_left:${#stop}}${input_right}"
                input_left="${stop}"
                ;;
            $'\e[H'|$'\e[1~') #Home
                clear_suggestions
                clear_history
                input_right="${input_left}${input_right}"
                input_left=""
                ;;
            $'\e[F'|$'\e[4~') #End
                clear_suggestions
                clear_history
                input_left+="${input_right}"
                input_right=""
                ;;
            $'\e[3~'|$'\e[P')
                clear_suggestions
                clear_history --force
                [[ -n "$input_right" ]] && input_right="${input_right:1}"
                ;;
            $'\e[2~')
                clear_suggestions
                clear_history --force
                input_left+="$(xclip -selection primary -o)"
                ;;
            $'')
                clear_suggestions
                clear_history --force
                input_left+="$(xclip -selection clipboard -o)"
                ;;
            $'\e')
                clear_suggestions
                clear_history --force
                input=
                break
                ;;
            $'\b'|$'\x7F'|$'')
                clear_suggestions
                clear_history --force
                [[ -n "$input_left" ]] && input_left="${input_left:0:-1}"
                ;;
            $'\n')
                clear_suggestions
                clear_history --force
                input="${input_left}${input_right}"
                break
                ;;
            [[:print:]])
                clear_suggestions
                clear_history --force
                input_left+="$key"
                ;;
            $'')
                clear_suggestions
                clear_history
                input_left=
                ;;
            $'')
                clear_suggestions
                clear_history
                stop=${input_left%%?(*([[:alnum:]])*([[:space:]])|*([^[:alnum:]]))}
                input_left="${stop}"
                ;;
            $'\t')
                clear_history
                [[ -z "$input_autocomplete" ]] && continue
                [[ ${#autocomplete[@]} -gt 0 ]] && set_suggestion next && continue
                ! create_suggestions && continue || set_suggestion next
                ;;
            $'\e[Z')
                clear_history
                [[ -z "$input_autocomplete" ]] && continue
                [[ ${#autocomplete[@]} -gt 0 ]] && set_suggestion prev && continue
                ! create_suggestions && continue || set_suggestion prev
                ;;
            *)
                ;;
        esac
    done
    input_left=
    input_right=
    input_autocomplete=
    trim_spaces input
    clearline
    [[ -z "$input" ]] && return 1 || return 0
}

######################################################################
# Calculates the next suggestion from the autocomplete array
######################################################################
set_suggestion() {
    # if suggestion count is 2 then that means that there is only one suggestion
    # that along with the input makes the count 2. In that case the suggestion
    # should be selected.
    [[ "$suggestion_count" -eq 2 ]] && suggestion="${autocomplete[1]}" && \
        clear_suggestions && return
    if [[ "$1" == "next" ]]
    then
        (( suggestion_index = (suggestion_index + 1) % suggestion_count ))
    elif [[ "$1" == "prev" ]]
    then
        (( suggestion_index = (suggestion_index - 1) % suggestion_count ))
    fi
    suggestion="${autocomplete[$suggestion_index]}"
}

######################################################################
# Saves the suggestion as input and clears everything related to autocomplete
######################################################################
clear_suggestions() {
    [[ -z "$suggestion" ]] && return
    input_left="$suggestion"
    suggestion=""
    suggestion_count=0
    unset autocomplete
}

clear_history() {
    if [[ -n "$input_history" ]]
    then
        input_left="$input_history"
        input_right=
        unset input_history
    fi
    [[ "$1" == "--force" ]] && cmd_history=()
}

######################################################################
# Creates the automplete array based on the autocomplete type we want
######################################################################
create_suggestions() {
    local current_complete files=0 i last_word="" len merge=0 passed
    local subinput_autocomplete wordlist
    local -a autocomplete_level=() split_left=()
    autocomplete_level[0]="$input_autocomplete"
    if [[ "$input_autocomplete" == "ucollage" ]]
    then
            # this trick also determines the way i handle the prefix in
            # command mode i add a space after the parenthesis so that
            # the command is its own word
        input_left=${input_left/)*( )/) }
    fi
    IFS=" " read -r -a split_left <<< "$input_left"
    # we do that so that a space confirms a suggestion
    [[ "${input_left: -1}" == " " ]] && split_left+=("")
    [[ "${#split_left[@]}" -gt 0 ]] && last_word=${split_left[-1]}
    # The below 'for' loop creates the autocomplete level hierarchy
    # If the previous word cannot produce autocomplete we move one
    # back.
    for compword in ${split_left[*]}
    do
        [[ -z "${spacelist[$compword]}" ]] && \
            [[ -z "${sticklist[$compword]}" ]] && \
            continue
        current_complete="${autocomplete_level[-1]}"
        # a system command ends the level hierarchy with only the
        # addition of the 'file' autcomplete in the next 'for' loop
        [[ "$current_complete" =~ "!" ]] && break
        [[ "${spacelist[$current_complete]}" =~ $compword ]] || \
            [[ "${sticklist[$current_complete]}" =~ $compword ]] && \
            autocomplete_level+=("$compword")
    done

    for stick in "${!sticklist[@]}"
    do
        #The stick autocompletes are only for the ':set' command
        if [[ "$last_word" =~ ^$stick ]] && \
            [[ "${autocomplete_level[-1]}" == "set" ]]
        then
            split_left[-1]="$stick"
            split_left+=("${last_word#$stick}")
            autocomplete_level+=("$stick")
            last_word="${split_left[-1]}"
            merge=1
        fi
    done
    subinput_autocomplete="${autocomplete_level[-1]}"

    if [[ "$subinput_autocomplete" =~ ^(!|!%)$ ]]
    then
        passed=0 # this checks that I have already written a command
        for ((i = 0; i < ${#split_left[@]} - 1; i++))
        do
            command -v ${split_left[$i]} &>/dev/null && \
                [[ ${split_left[$i]} != "!" ]] && passed=1
        done
        [[ "$passed" -eq 1 ]] && subinput_autocomplete="file"
    fi

    case "$subinput_autocomplete" in
        "file")
            mapfile -t autocomplete < <(compgen -f "$last_word" | sort)
            files=1
            ;;
        *)
            wordlist="${spacelist[$subinput_autocomplete]}"
            wordlist+="${sticklist[$subinput_autocomplete]}"
            mapfile -t autocomplete < \
                <(IFS=" " compgen -W "$wordlist" "$last_word" | sort)
            ;;
    esac

    autocomplete=("$input_left" "${autocomplete[@]}")
    [[ "${#split_left[@]}" -gt 0 ]] && unset "split_left[-1]"
    i=1
    while [[ "$i" -lt ${#autocomplete[@]} ]]
    do
        if [[ "$files" -eq 1 ]] #only escape filenames
        then
            escape_name autocomplete[$i]
        fi

        len="${#split_left[@]}"
        if [[ "$len" -gt 0 ]]
        then
            if [[ "$merge" -eq 1 ]]
            then
                autocomplete[$i]="${split_left[*]}${autocomplete[$i]}"
            else
                autocomplete[$i]="${split_left[*]} ${autocomplete[$i]}"
            fi
        fi
        (( i += 1 ))
    done
    suggestion_index=0
    suggestion_count=${#autocomplete[@]}
    return 0
}
