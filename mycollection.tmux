#!/usr/bin/env bash

SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

declare -A CMDS=(\
    ["#{net}"]="#($SCRIPT_DIR/scripts/net.sh)" \
    ["#{load}"]="#($SCRIPT_DIR/scripts/load.sh)" \
    ["#{mem}"]="#($SCRIPT_DIR/scripts/mem.sh)" \
    ["#{batt}"]="#($SCRIPT_DIR/scripts/batt.sh)" \
)

if ! "$SCRIPT_DIR/scripts/batt.sh" > /dev/null; then
    # there is no battery
    CMDS["#{batt}"]=""
fi

substitute() {
    local statusline="$1"
    for pattern in ${!CMDS[@]}; do
        statusline=${statusline//$pattern/${CMDS[$pattern]}}
    done

    echo "$statusline"
}

update() {
    local value=$(tmux show -gqv "$1")
    if [[ -z "$value" ]]; then
        return
    fi

    value=$(substitute "$value")
    tmux set -gq "$1" "$value"
}

update status-left
update status-right
