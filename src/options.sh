set_scaling() {
    if [[ "${optcurrent[scalingx]}" -lt 0 ]]
    then
        optcurrent[scalingx]=0
    elif [[ "${optcurrent[scalingx]}" -gt 100 ]]
    then
        optcurrent[scalingx]=100
    fi
    if [[ "${optcurrent[scalingy]}" -lt 0 ]]
    then
        optcurrent[scalingy]=0
    elif [[ "${optcurrent[scalingy]}" -gt 100 ]]
    then
        optcurrent[scalingy]=100
    fi
    read -r realscalingx < <(bc -l <<< "scale=2; ${optcurrent[scalingx]} / 100")
    read -r realscalingy < <(bc -l <<< "scale=2; ${optcurrent[scalingy]} / 100")
}

declare -A optiontype=(\
    [execprompt]="boolean"
    [showfileinfo]="boolean"
    [reverse]="boolean"
    [scaler]="enum"
    [sort]="enum"
    [fileinfo]="enum"
    [gridcolumns]="number"
    [gridlines]="number"
    [maxload]="number"
    [scalingx]="number"
    [scalingy]="number"
)

declare -A enumoptvalue=(\
    [scaler]="crop distort fit_contain contain forced_cover cover"
    [sort]="name time size extension"
    [fileinfo]="names ratings categories"
)


declare -A optdefault
declare -A optcurrent
declare -A optupdate=(\
    [execprompt]="message+=\${optcurrent[execprompt]}"
    [showfileinfo]="redraw"
    [reverse]="update_reverse"
    [scaler]="show_batch"
    [sort]="break_flag=1"
    [fileinfo]="update_fileinfo"
    [gridcolumns]="redraw"
    [gridlines]="redraw"
    [maxload]=""
    [scalingx]="set_scaling; show_batch"
    [scalingy]="set_scaling; show_batch"
)

set_default() {
    optdefault[gridlines]=${UCOLLAGE_LINES:-3}
    optdefault[gridcolumns]=${UCOLLAGE_COLUMNS:-3}
    optdefault[execprompt]=${UCOLLAGE_EXEC_PROMPT:-execprompt}
    optdefault[showfileinfo]=${UCOLLAGE_SHOW_FILEINFO:-showfileinfo}
    optdefault[fileinfo]=${UCOLLAGE_FILEINFO:-names}
    optdefault[sort]=${UCOLLAGE_SORT:-time}
    optdefault[reverse]=${UCOLLAGE_SORT_REVERSE:-noreverse}
    optdefault[scaler]=${UCOLLAGE_SCALER:-contain}
    optdefault[scalingx]=${UCOLLAGE_SCALINGX:-50}
    optdefault[scalingy]=${UCOLLAGE_SCALINGY:-50}
    optdefault[maxload]=${UCOLLAGE_MAX_LOAD:-1000}
    wide_vertical="${optdefault[gridlines]}"
    wide_horizontal="${optdefault[gridcolumns]}"
    tmp_dir=${UCOLLAGE_TMP_DIR:-/tmp/ucollage}
    cache_dir=${UCOLLAGE_CACHE_DIR:-~/.local/share/ucollage}
    trash_dir=${UCOLLAGE_TRASH_DIR:-~/.local/share/Trash/ucollage}
    expand_dirs=${UCOLLAGE_EXPAND_DIRS:-ask}
    video_thumbnails=${UCOLLAGE_VIDEO_THUMBNAILS:-1}
    cache_thumbnails=${UCOLLAGE_CACHE_THUMBNAILS:-1}
    thumbnail_width=${UCOLLAGE_THUMBNAIL_WIDTH:-500}
    leader=${UCOLLAGE_LEADER:-\\}
    hashfunc=${UCOLLAGE_HASHFUNC:-md5sum}
    error=""
    warning=""
    success=""
    message=""
    prefix=""
    exit_clear=1
    previous_batch=0
}

set_current() {
    for key in "${!optdefault[@]}"
    do
        optcurrent[$key]="${optdefault[$key]}"
    done
    set_scaling
}

set_options() {
    set_default
    set_current
}

_set() {
    split() {
        local -n arr="$1"
        IFS=$'\n' read -rd "" -ra arr <<< "${2/$3/$'\n'}"
    }
    local args oldvalue option prefix_args prefix_count=0 settings="$*"
    local type value
    # Giving prefixes overrides command line numbers
    split prefix_args "$prefix" " "
    if [[ "$settings" =~ all@ ]]
    then
        settings="${!optdefault[*]}@"
        settings=${settings// /@ }
    fi
    eval_cmd=
    message=
    for setting in $settings
    do
        case $setting in
            *"+="*)
                split args "$setting" "+="
                option="${args[0]}"
                type="+="
                value="${args[1]}"
                if [[ -n "${prefix_args[$prefix_count]}" ]]
                then
                    value="${prefix_args[$prefix_count]}"
                    ((prefix_count < ${#prefix_args[@]} - 1)) && \
                        ((prefix_count += 1))
                fi
                ;;
            *"-="*)
                split args "$setting" "-="
                option="${args[0]}"
                type="-="
                value="${args[1]}"
                if [[ -n "${prefix_args[$prefix_count]}" ]]
                then
                    value="${prefix_args[$prefix_count]}"
                    ((prefix_count < ${#prefix_args[@]} - 1)) && \
                        ((prefix_count += 1))
                fi
                ;;
            *"^="*)
                split args "$setting" "^="
                option="${args[0]}"
                type="^="
                value="${args[1]}"
                if [[ -n "${prefix_args[$prefix_count]}" ]]
                then
                    value="${prefix_args[$prefix_count]}"
                    ((prefix_count < ${#prefix_args[@]} - 1)) && \
                        ((prefix_count += 1))
                fi
                ;;
            *"="*)
                split args "$setting" "="
                option="${args[0]}"
                type="="
                value="${args[1]}"
                if [[ -n "${prefix_args[$prefix_count]}" ]]
                then
                    value="${prefix_args[$prefix_count]}"
                    ((prefix_count < ${#prefix_args[@]} - 1)) && \
                        ((prefix_count += 1))
                fi
                ;;
            *":"*)
                split args "$setting" ":"
                option="${args[0]}"
                type="="
                value="${args[1]}"
                if [[ -n "${prefix_args[$prefix_count]}" ]]
                then
                    value="${prefix_args[$prefix_count]}"
                    ((prefix_count < ${#prefix_args[@]} - 1)) && \
                        ((prefix_count += 1))
                fi
                ;;
            *"?")
                option="${setting%?}"
                type="ask"
                value=
                ;;
            "no"*)
                option="${setting#no}"
                type="off"
                value=
                ;;
            "inv"*)
                option="${setting#inv}"
                type="inv"
                value=
                ;;
            *"!")
                option="${setting%!}"
                type="inv"
                value=
                ;;
            *"@")
                option="${setting%@}"
                type="def"
                value=
                ;;
            *)
                option="$setting"
                type="on"
                value=
                ;;
        esac
        oldvalue="${optcurrent[$option]}"
        case "$type" in
            "+=")
                [[ -z "$value" ]] && continue
                case ${optiontype[$option]} in
                    "number")
                        if is_natural "$value" || [[ "$value" -eq 0 ]]
                        then
                            ((optcurrent[$option] += value))
                        else
                            error="Number required after =: $setting"
                        fi
                        ;;
                    "string")
                        optcurrent[$option]+="$value"
                        ;;
                    "enum"|"boolean")
                        error="Invalid argument: $setting"
                        ;;
                    *)
                        error="Unknown option: $setting"
                        ;;
                esac
                ;;
            "-=")
                [[ -z "$value" ]] && continue
                case ${optiontype[$option]} in
                    "number")
                        if is_natural "$value" || [[ "$value" -eq 0 ]]
                        then
                            ((optcurrent[$option] -= value))
                        else
                            error="Number required after =: $setting"
                        fi
                        ;;
                    "string")
                        optcurrent[$option]=${optcurrent[$option]//"$value"}
                        ;;
                    "enum"|"boolean")
                        error="Unknown option: $setting"
                        ;;
                    *)
                        error="Unknown option: $setting"
                        ;;
                esac
                ;;
            "^=")
                [[ -z "$value" ]] && continue
                case ${optiontype[$option]} in
                    "number")
                        if is_natural "$value" || [[ "$value" -eq 0 ]]
                        then
                            ((optcurrent[$option] *= value))
                        else
                            error="Number required after =: $setting"
                        fi
                        ;;
                    "string")
                        optcurrent[$option]="${value}${optcurrent[$option]}"
                        ;;
                    "enum"|"boolean")
                        error="Invalid argument: $setting"
                        ;;
                    *)
                        error="Unknown option: $setting"
                        ;;
                esac
                ;;
            "=")
                [[ -z "$value" ]] && continue
                case ${optiontype[$option]} in
                    "number")
                        if is_natural "$value" || [[ "$value" -eq 0 ]]
                        then
                            ((optcurrent[$option] = value))
                        else
                            error="Number required after =: $setting"
                        fi
                        ;;
                    "string")
                        optcurrent[$option]="${value}"
                        ;;
                    "enum")
                        if [[ "$value" =~ ^(${enumoptvalue[$option]// /|})$ ]]
                        then
                            optcurrent[$option]="${value}"
                        else
                            error="Invalid argument: $setting"
                        fi
                        ;;
                    "boolean")
                        error="Invalid argument: $setting"
                        ;;
                    *)
                        error="Unknown option: $setting"
                        ;;
                esac
                ;;
            "ask")
                if [[ -n "${optcurrent[$option]}" ]]
                then
                    case ${optiontype[$option]} in
                        "number"|"string"|"enum")
                            message+="${option}=${optcurrent[$option]} "
                            ;;
                        "boolean")
                            message+="${optcurrent[$option]} "
                            ;;
                    esac
                else
                    error="Unknown option: $setting"
                fi
                ;;
            "off")
                case ${optiontype[$option]} in
                    "number"|"string"|"enum")
                        error="Invalid argument: $setting"
                        ;;
                    "boolean")
                        optcurrent[$option]="$setting"
                        ;;
                    *)
                        error="Unknown option: $setting"
                        ;;
                esac
                ;;
            "inv")
                case ${optiontype[$option]} in
                    "number"|"string"|"enum")
                        error="Invalid argument: $setting"
                        ;;
                    "boolean")
                        if [[ "${optcurrent[$option]}" == "no$option" ]]
                        then
                            optcurrent[$option]="$option"
                        else
                            optcurrent[$option]="no$option"
                        fi
                        ;;
                    *)
                        error="Unknown option: $setting"
                        ;;
                esac
                ;;
            "def")
                if [[ -n "${optdefault[$option]}" ]]
                then
                    optcurrent[$option]="${optdefault[$option]}"
                else
                    error="Unknown option: $setting"
                fi
                ;;
            "on")
                case ${optiontype[$option]} in
                    "number"|"string"|"enum")
                        message+="${option}=${optcurrent[$option]} "
                        ;;
                    "boolean")
                        optcurrent[$option]="$setting"
                        ;;
                    *)
                        error="Unknown option: $setting"
                        ;;
                esac
                ;;
        esac
        [[ -n "$error" ]] && break
        if [[ "${optcurrent[$option]}" != "$oldvalue" ]]
        then
            eval "${optupdate[$option]}"
        fi
    done
    clear_sequence
}
