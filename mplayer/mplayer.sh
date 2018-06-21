#!/usr/bin/env bash

source $(dirname $(realpath $0))/escape.sh

readonly IMAGE=${image:-haoliang/mplayer}

main() {

    local rawfile="$1"
    local filename=""
    local filemount=""
    local subtitle=""
    local subtmount=""

    if [ -z "$rawfile" ]; then
        >&2 echo "requires filename as first param"
        return 1
    fi

    if [ ! -f "$rawfile" ]; then
        >&2 echo "'$rawfile' is not a regular file"
        return 1
    fi

    filename="$(realpath "$rawfile" | read_escape)"
    filemount="/media/$(basename "$filename" | read_escape)"

    if [ -f "$(build_subtitle $(realpath "$rawfile"))" ]; then
        subtitle="$(build_subtitle $filename)"
        subtmount="$(build_subtitle $filemount)"
    fi

    declare -a run=(
    # resource limit: cpu, memory
    # mount file
    "-v $filename:$filemount"
    # xserver relevant
    "-e DISPLAY"
    "-v /tmp/.X11-unix:/tmp/.X11-unix"
    # audio
    "--device /dev/snd"

    # subtitle mount
    "$(if [ -z "$subtitle" ]; then
        echo ""
    else
        echo "-v $subtitle:$subtmount"
    fi)"

    # see https://github.com/osrf/docker_images/issues/21
    # https://docs.docker.com/engine/reference/run/#ipc-settings---ipc
    "--ipc host"

    # image
    "$IMAGE"

    # mplayer
    "mplayer"
    "$filemount"

    # subtitle flag
    "$(if [ -z "$subtitle" ]; then
        echo ""
    else
        echo "-sub $subtmount"
    fi)"

    )

    eval docker run --rm "${run[@]}"
}

build_subtitle() {

    local mediafile=""
    local ext=""

    mediafile="${*:?requires media file path}"

    ext="$(echo $mediafile | grep '\.[^.]\+$' --only-matching)"

    echo "${mediafile%$ext}.srt"
}

main "$@"
