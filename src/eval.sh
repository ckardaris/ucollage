######################################################################
# Evaluate a command
######################################################################
eval_cmd() {
    local ans="" columns lines error
    read -r lines columns < <(stty size)
    if [[ "${optcurrent[execprompt]}" == "execprompt" ]]
    then
        clearline
        cmd_prompt+="? (Press y/Y/Enter to confirm)"
        cmd_prompt=${cmd_prompt:0:$columns}
        printf "%s" "$cmd_prompt"
        while [[ -z "$ans" ]] && [[ "$exit_flag" -eq 0 ]]
        do
            read -rsN1 -t 0.01 ans &>/dev/null
        done
        clearline
        [[ ! "$ans" =~ ^(y|Y|$'\n')$ ]] && return 1
    fi
    error=$(eval "$cmd" 2>&1 >/dev/null)
    [[ -z "$error" ]] && return 0 || return 1
}

