#!/usr/bin/env bash

SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

commands=(\
    "#($SCRIPT_DIR/scripts/net.sh)" \
    "#($SCRIPT_DIR/scripts/load.sh)" \
    "#($SCRIPT_DIR/scripts/mem.sh)" \
)

patterns=(\
    "\#{net}" \
    "\#{load}" \
    "\#{mem}" \
)

substitute() {
    local statusline="$1"
    for ((i = 0; i < ${#commands[@]}; i++)); do
        statusline=${statusline//${patterns[$i]}/${commands[$i]}}
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
