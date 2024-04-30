#!/usr/bin/env bash
set -e

which awk nproc > /dev/null
[[ -r /proc/loadavg ]]

VALUE=$(awk '{print $1}' /proc/loadavg)
NPROC=$(nproc)
VAL10=$(awk -vA=$VALUE 'BEGIN{printf "%.0f", A*10}')

if (( VAL10 > NPROC * 8 )); then
    echo "#[fg=red]$VALUE#[default]"
elif (( VAL10 > NPROC * 3 )); then
    echo "#[fg=yellow]$VALUE#[default]"
else
    echo "#[fg=green]$VALUE#[default]"
fi
