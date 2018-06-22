#!/usr/bin/env bash

init() {
    readonly IMAGE="${image:-haoliang/qutebrowser}"
    readonly ROOT=$(dirname $(realpath $0))
    readonly CONTAINER="${container:-qutebrowser}"
    readonly MEMORY_LIMIT=${memory:-$(available_memory 0.5)}
}

main() {
    case "$1" in
        stop)
            echo "stopping qutebrowser daemon"
            stop_daemon
            ;;
        ""|start)
            echo "starting qutebrowser daemon"
            start_daemon
            ;;
        *)
            >&2 echo "unsupported operation"
            return 1
            ;;
    esac
}

start_daemon() {

    if container_running "$CONTAINER"; then
        echo "$CONTAINER already started"
        return
    fi

    stop_daemon

    xhost_available || {
        >&2 echo "can not connect to host xserver within container"
        return 1
    }

    declare -a run=(
    "-d --name $CONTAINER"
    # resource limit
    "-m $MEMORY_LIMIT"
    # xserver relevant
    "-e DISPLAY"
    "-v /tmp/.X11-unix:/tmp/.X11-unix"
    "-e XDG_RUNTIME_DIR"
    "-v $XDG_RUNTIME_DIR"
    "--device /dev/dri"
    "--user=1000"
    # volume
    "-v $ROOT/var/home:/home"
    "$IMAGE"
    "tail -f /dev/null"
    )

    eval docker run "${run[@]}"
}

stop_daemon() {
    if container_running "$CONTAINER"; then
        docker stop $CONTAINER || {
            >&2 echo "could not stop $CONTAINER"
            return 1
        }
    fi

    docker rm $CONTAINER || {
        >&2 echo "could not rm $CONTAINER"
        return 1
    }
}

xhost_available() {
    xhost | grep -F "access control disabled, clients can connect from any host" &>/dev/null
}

container_running() {
    [ $# -gt 0 ] && [ $( docker ps --filter="name=$*" | wc -l ) -gt 1 ]
}

available_memory() {
    local percent=${1:?requires percent arg}

    local total=$(lsmem -b -o SIZE | grep -i 'total online memory:' | grep '[0-9]\+' --only-matching)

    [ -z "$total" ] && {
        >&2 echo "invalid total memory, '$total'"
        return 1
    }

    printf "%.2fG" $(echo "$total / 1024/1024/1024 * $percent" | bc -l)
}

init && main "$@"
