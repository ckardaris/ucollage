######################################################################
# Starts the ueberzugpp daemon
######################################################################
start_daemon() {
    UB_PID_FILE="${tmp_dir}/pid_file"
    ueberzugpp layer --no-stdin --silent --use-escape-codes --pid-file "$UB_PID_FILE"
    UB_PID=$(cat "$UB_PID_FILE")
    SOCKET=/tmp/ueberzugpp-"$UB_PID".socket
}

stop_daemon() {
    ueberzugpp cmd -s "$SOCKET" -a exit
    [[ "$exit_clear" == 1 ]] && clear_screen
    kill "$background_pid" &>/dev/null
    rm -rf "$tmp_dir"
    rm -rf "$SOCKET"
    printf "\e[?25h"
    stty echo
}
