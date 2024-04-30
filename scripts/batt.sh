#!/usr/bin/env bash
set -e

which awk > /dev/null
SYSFSBAT=/sys/class/power_supply/BAT0
[[ -d  $SYSFSBAT ]]

LEVEL=$(cat $SYSFSBAT/capacity)
SIGN=$(awk '{if ($0 ~ /[Dd]ischarg/) {print "↓"} else {print "↑"}}' $SYSFSBAT/status)

if (( LEVEL < 5 )); then
    echo -n "#[fg=red]"
elif (( LEVEL < 10 )); then
    echo -n "#[fg=brightred]"
elif (( LEVEL < 25 )); then
    echo -n "#[fg=yellow]"
elif (( LEVEL < 50 )); then
    echo -n "#[fg=brightyellow]"
elif (( LEVEL < 80 )); then
    echo -n "#[fg=brightgreen]"
elif (( LEVEL < 90 )); then
    echo -n "#[fg=green]"
else
    echo -n "#[fg=blue]"
fi

printf "%s%02d%%#[default]\n" $SIGN $LEVEL
