#!/usr/bin/env bash
set -e

which awk > /dev/null
[[ -r /proc/meminfo ]]

colorize() {
    local val=$(($1 * 4))
    if (( $val > 3 * $2 )); then
        echo -n "#[fg=red]"
    elif (( $val > 2 * $2 )); then
        echo -n "#[fg=yellow]"
    elif (( $val > $2 )); then
        echo -n "#[fg=green]"
    else
        echo -n "#[default]"
    fi
}

declare -A MEM
while IFS='=' read key val; do
    MEM[$key]=$val
done < <(awk '/MemTotal/{printf "TOTAL=%d\n", $2}
     /MemFree/{printf "FREE=%d\n", $2}
     /Buffers/{printf "BUFFERS=%d\n", $2}
     /^Cached/{printf "CACHED=%d\n", $2}
     /SReclaimable/{printf "RECLAIMABLE=%d\n", $2}
     /SwapTotal/{printf "SWAPTOTAL=%d\n", $2}
     /SwapFree/{printf "SWAPFREE=%d\n", $2}' /proc/meminfo)

MEM[USED]=$((MEM[TOTAL]-MEM[FREE]-MEM[BUFFERS]-MEM[CACHED]-MEM[RECLAIMABLE]))
MEM[SWAPUSED]=$((MEM[SWAPTOTAL]-MEM[SWAPFREE]))
TOGB=$((1024*1024))

colorize ${MEM[USED]} ${MEM[TOTAL]}
awk -vF=${MEM[USED]} -vT=${MEM[TOTAL]} -vM=$TOGB 'BEGIN{printf "%.1fG/%.1fG#[default]", F/M, T/M}'

colorize ${MEM[SWAPUSED]} ${MEM[SWAPTOTAL]}
awk -vS=${MEM[SWAPUSED]} -vM=$TOGB 'BEGIN{printf "[%.1fG]#[default]\n", S/M}'
