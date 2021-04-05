translate_map() {
    local -n str="$1"
    str=${str//<Leader>/$leader}
    str=${str//<Ctrl-A>/$'\x1'}
    str=${str//<Ctrl-B>/$'\x2'}
    str=${str//<Ctrl-C>/$'\x3'}
    str=${str//<Ctrl-D>/$'\x4'}
    str=${str//<Ctrl-E>/$'\x5'}
    str=${str//<Ctrl-F>/$'\x6'}
    str=${str//<Ctrl-G>/$'\x7'}
    str=${str//<Ctrl-H>/$'\x8'}
    str=${str//<Backspace>/$'\x8'}
    str=${str//<Ctrl-I>/$'\x9'}
    str=${str//<Tab>/$'\x9'}
    str=${str//<Shift-Tab>/$'\x1B'$'\x5B'$'\x5A'}
    str=${str//<Ctrl-J>/$'\xA'}
    str=${str//<Ctrl-K>/$'\xB'}
    str=${str//<Ctrl-L>/$'\xC'}
    str=${str//<Ctrl-M>/$'\xD'}
    str=${str//<Return>/$'\xD'}
    str=${str//<Enter>/$'\xD'}
    str=${str//<Ctrl-N>/$'\xE'}
    str=${str//<Ctrl-O>/$'\xF'}
    str=${str//<Ctrl-P>/$'\x10'}
    str=${str//<Ctrl-Q>/$'\x11'}
    str=${str//<Ctrl-R>/$'\x12'}
    str=${str//<Ctrl-S>/$'\x13'}
    str=${str//<Ctrl-T>/$'\x14'}
    str=${str//<Ctrl-U>/$'\x15'}
    str=${str//<Ctrl-V>/$'\x16'}
    str=${str//<Ctrl-W>/$'\x17'}
    str=${str//<Ctrl-X>/$'\x18'}
    str=${str//<Ctrl-Y>/$'\x19'}
    str=${str//<Ctrl-Z>/$'\x1A'}
    str=${str//<Insert>/$'\x1B'$'\x5B'$'\x32'$'\x7e'}
    str=${str//<Ctrl-Insert>/$'\x1B'$'\x5B'$'\x32'$'\x3B'$'\x35'$'\x7e'}
    str=${str//<Shift-Insert>/$'\x1B'$'\x5B'$'\x32'$'\x3B'$'\x32'$'\x7e'}
    str=${str//<Delete>/$'\x1B'$'\x5B'$'\x33'$'\x7e'}
    str=${str//<Ctrl-Delete>/$'\x1B'$'\x5B'$'\x33'$'\x3B'$'\x35'$'\x7e'}
    str=${str//<Shift-Delete>/$'\x1B'$'\x5B'$'\x33'$'\x3B'$'\x32'$'\x7e'}
    str=${str//<Ctrl-Shift-Delete>/$'\x1B'$'\x5B'$'\x33'$'\x3b'$'\x36'$'\x7e'}
    str=${str//<Home>/$'\x1B'$'\x5B'$'\x48'}
    str=${str//<Ctrl-Home>/$'\x1B'$'\x5B'$'\x31'$'\x3B'$'\x35'$'\x48'}
    str=${str//<Shift-Home>/$'\x1B'$'\x5B'$'\x31'$'\x3B'$'\x32'$'\x48'}
    str=${str//<Ctrl-Shift-Home>/$'\x1B'$'\x5B'$'\x31'$'\x3B'$'\x36'$'\x48'}
    str=${str//<End>/$'\x1B'$'\x5B'$'\x46'}
    str=${str//<Ctrl-End>/$'\x1B'$'\x5B'$'\x31'$'\x3B'$'\x35'$'\x46'}
    str=${str//<Shift-End>/$'\x1B'$'\x5B'$'\x31'$'\x3B'$'\x32'$'\x46'}
    str=${str//<Ctrl-Shift-End>/$'\x1B'$'\x5B'$'\x31'$'\x3B'$'\x36'$'\x46'}
    str=${str//<PageUp>/$'\x1B'$'\x5B'$'\x35'$'\x7e'}
    str=${str//<Ctrl-PageUp>/$'\x1B'$'\x5B'$'\x35'$'\x3B'$'\x35'$'\x7e'}
    str=${str//<PageDown>/$'\x1B'$'\x5B'$'\x36'$'\x7e'}
    str=${str//<Ctrl-PageDown>/$'\x1B'$'\x5B'$'\x36'$'\x3B'$'\x35'$'\x7e'}
    str=${str//<F1>/$'\x1B'$'\x4F'$'\x50'}
    str=${str//<F2>/$'\x1B'$'\x4F'$'\x51'}
    str=${str//<F3>/$'\x1B'$'\x4F'$'\x52'}
    str=${str//<F4>/$'\x1B'$'\x4F'$'\x53'}
    str=${str//<F5>/$'\x1B'$'\x5B'$'\x31'$'\x35'$'\x7e'}
    str=${str//<F6>/$'\x1B'$'\x5B'$'\x31'$'\x37'$'\x7e'}
    str=${str//<F7>/$'\x1B'$'\x5B'$'\x31'$'\x38'$'\x7e'}
    str=${str//<F8>/$'\x1B'$'\x5B'$'\x31'$'\x39'$'\x7e'}
    str=${str//<F9>/$'\x1B'$'\x5B'$'\x32'$'\x30'$'\x7e'}
    str=${str//<F10>/$'\x1B'$'\x5B'$'\x32'$'\x31'$'\x7e'}
    str=${str//<F11>/$'\x1B'$'\x5B'$'\x32'$'\x33'$'\x7e'}
    str=${str//<F12>/$'\x1B'$'\x5B'$'\x32'$'\x34'$'\x7e'}
    str=${str//<Up>/$'\x1B'$'\x5B'$'\x41'}
    str=${str//<Down>/$'\x1B'$'\x5B'$'\x42'}
    str=${str//<Right>/$'\x1B'$'\x5B'$'\x43'}
    str=${str//<Left>/$'\x1B'$'\x5B'$'\x44'}
    str=${str//<Ctrl-Up>/$'\x1B'$'\x5B'$'\x31'$'\x3B'$'\x35'$'\x41'}
    str=${str//<Ctrl-Down>/$'\x1B'$'\x5B'$'\x31'$'\x3B'$'\x35'$'\x42'}
    str=${str//<Ctrl-Right>/$'\x1B'$'\x5B'$'\x31'$'\x3B'$'\x35'$'\x43'}
    str=${str//<Ctrl-Left>/$'\x1B'$'\x5B'$'\x31'$'\x3B'$'\x35'$'\x44'}
    str=${str//<Shift-Up>/$'\x1B'$'\x5B'$'\x31'$'\x3B'$'\x32'$'\x41'}
    str=${str//<Shift-Down>/$'\x1B'$'\x5B'$'\x31'$'\x3B'$'\x32'$'\x42'}
    str=${str//<Shift-Right>/$'\x1B'$'\x5B'$'\x31'$'\x3B'$'\x32'$'\x43'}
    str=${str//<Shift-Left>/$'\x1B'$'\x5B'$'\x31'$'\x3B'$'\x32'$'\x44'}
    str=${str//<Ctrl-Shift-Up>/$'\x1B'$'\x5B'$'\x31'$'\x3B'$'\x36'$'\x41'}
    str=${str//<Ctrl-Shift-Down>/$'\x1B'$'\x5B'$'\x31'$'\x3B'$'\x36'$'\x42'}
    str=${str//<Ctrl-Shift-Right>/$'\x1B'$'\x5B'$'\x31'$'\x3B'$'\x36'$'\x43'}
    str=${str//<Ctrl-Shift-Left>/$'\x1B'$'\x5B'$'\x31'$'\x3B'$'\x36'$'\x44'}
}

trim_spaces() {
    local -n str="$1"
    local char
    str="${str##*([[:space:]])}"
    str="${str%%*([[:space:]])}"
    str="${str//+([[:space:]])/ }"
    for delim in $2
    do
        str="${str//*([[:space:]])${delim}*([[:space:]])/${delim}}"
    done
}

######################################################################
# 2J                Clear entire screen
# ?25l              Hide cursor
# H                 Move cursor to upper left corner
######################################################################
clear_screen() {
    printf "\e[2J\e[?25l\e[H"
}

######################################################################
# ?25l              Hide cursor
# H                 Move cursor to upper left corner
# 2B                Move cursor down 2 lines
# 2K                Clear entire line
# 1J                Clear screen from cursor up
######################################################################
clearline() {
    printf "\e[?25l\e[H\e[B\e[2K\e[2;1H"
    status=
}

######################################################################
# ?25l              Hide cursor
# H                 Move cursor to upper left corner
# 3B                Move cursor down 3 lines
# 2K                Clear entire line
# 0J                Clear screen from cursor down
######################################################################
clear_fileinfo() {
    # clear from 4th line and down
    printf "\e[?25l\e[H\e[3B\e[2K\e[0J\e[H"
}

show_cursor() {
    printf "\e[?25h"
}

is_natural() {
    [[ "$1" =~ ^([1-9][0-9]*|0+[1-9][0-9]*)$ ]]
}

set_stars() {
    local -n str="$1"
    local hash="${filehash[$index]}" index="$2" k rating=""
    str=
    if is_image
    then
        eval "$(cat "${cache_dir}/hash/images/$hash")"
    elif is_video
    then
        eval "$(cat "${cache_dir}/hash/videos/$hash")"
    fi
    if [[ -n "$rating" ]]
    then
        for ((k = 0; k < rating; k++))
        do
            str+="★"
        done
        for ((k = rating; k < 5; k++))
        do
            str+="☆"
        done
    fi
}

is_image() {
    [[ -f "${cache_dir}/hash/images/${hash}" ]] && return 0
    if [[ $(file --mime-type -b "$file") =~ ^image/.*$ ]]
    then
        touch "${cache_dir}/hash/images/${hash}"
        return 0
    fi
    return 1
}

is_video() {
    [[ -f "${cache_dir}/hash/videos/${hash}" ]] && return 0
    if [[ $(file --mime-type -b "$file") =~ ^video/.*$ ]]
    then
        touch "${cache_dir}/hash/videos/${hash}"
        return 0
    fi
    return 1
}
