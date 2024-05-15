#!/usr/bin/env bash
set -e

which awk > /dev/null

getsum() {
    awk 'BEGIN{s=0}{s+=$1}END{printf "%u\n", s}' "$@"
}

gettmuxval() {
    local value=$(tmux show -gqv "$1")
    if [[ -z "$value" ]]; then
        echo "$2"
    else
        echo $value
    fi
}

divsuf() {
    local res=$((($2-$1)*8/$3))
    local Gb=$((1024*1024*1024)) Mb=$((1024*1024)) Kb=1024
    if (( res >= Gb )); then
        echo "$((res/Gb))Gib"
    elif (( res >= Mb )); then
        echo "$((res/Mb))Mib"
    elif (( res >= Kb )); then
        echo "$((res/Kb))Kib"
    else
        echo "${res}b"
    fi
}

DOWNLOAD=$(getsum /sys/class/net/*/statistics/rx_bytes)
UPLOAD=$(getsum /sys/class/net/*/statistics/tx_bytes)
TIMEDELTA=$(tmux show -gv status-interval)
PREVDOWNLOAD=$(gettmuxval @net_download $DOWNLOAD)
PREVUPLOAD=$(gettmuxval @net_upload $UPLOAD)

tmux set -g @net_download $DOWNLOAD
tmux set -g @net_upload $UPLOAD

DOWNSPEED=$(divsuf $PREVDOWNLOAD $DOWNLOAD $TIMEDELTA)
UPSPEED=$(divsuf $PREVUPLOAD $UPLOAD $TIMEDELTA)
printf "▼ %-7s▲ %-7s\n" $DOWNSPEED $UPSPEED
