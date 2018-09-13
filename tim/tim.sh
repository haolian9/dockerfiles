#!/usr/bin/env bash

CONTAINER=test_tim
IMAGE=haoliang/tim

declare -a run=(
"--name $CONTAINER"
# xserver relevant
"-e DISPLAY"
"-v /tmp/.X11-unix:/tmp/.X11-unix"
"-e XDG_RUNTIME_DIR"
"-v $XDG_RUNTIME_DIR"
"--device /dev/dri"
"$IMAGE"
"tail -f /dev/null"
)

cleanup() {
    docker stop $CONTAINER
    docker rm $CONTAINER
    return 0
}


cleanup && eval docker run "${run[@]}"
