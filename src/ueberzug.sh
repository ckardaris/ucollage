######################################################################
# Starts the ueberzug daemon
######################################################################
start_daemon() {
    fifo="${tmp_dir}/fifo"
    rm -f "$fifo"
    mkfifo "$fifo"
    ueberzug layer --parse bash --silent < "$fifo" &
    exec {ueberzug}> "$fifo"
}

stop_daemon() {
    exec {ueberzug}>&-
    [[ "$exit_clear" == 1 ]] && clear_screen
    kill "$background_pid" &>/dev/null
    rm -rf "$tmp_dir"
    printf "\e[?25h"
    stty echo
}
