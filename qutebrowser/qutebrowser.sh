#!/usr/bin/env bash

readonly CONTAINER="${container:-qutebrowser}"

container_running() {
    [ $# -gt 0 ] && [ $( docker ps --filter="name=$*" | wc -l ) -gt 1 ]
}

if ! container_running "$CONTAINER"; then
    echo "please start $CONTAINER"
    exit 1
fi

if [ $# -eq 0 ]; then
    set -- qutebrowser
fi

if [ "$1" != "qutebrowser" ]; then
    set -- qutebrowser "$@"
fi

exec docker exec $CONTAINER "$@"
