#!/usr/bin/env bash

main() {

    local run=(

    "--rm"
    "-it"

    # communication with host docker daemon
    "--volume=$DOCKER_SOCK:$DOCKER_SOCK:ro"

    # mount
    "--volume=$CURRENT_DIR:$CURRENT_DIR"
    "--workdir=$CURRENT_DIR"

    "$IMAGE"
    )

    if [ "$1" = "shell" ]; then
        shift
		exec docker run --entrypoint sh "${run[@]}" "$@"
    else
        exec docker run "${run[@]}" "$@"
    fi

}

IMAGE=docker/compose:1.22.0
CURRENT_DIR=$(pwd)
DOCKER_SOCK=/var/run/docker.sock

main "$@"
