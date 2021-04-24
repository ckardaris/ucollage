_wrapper() {
    local script="$*"
    if [[ "$script" =~ %s ]] && [[ "$script" =~ %d ]]
    then
        eval "_edit $script"
    elif
        [[ "$script" =~ (%s|%S|%e|%E) ]]
    then
        eval "_execute $script"
    else
        eval "$script"
    fi
}
