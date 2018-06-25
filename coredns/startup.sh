#!/usr/bin/env bash

IMAGE_NAME="coredns/coredns"
CONTAINER_NAME="coredns"

cd $(dirname $(realpath $0)) || exit 1

{
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
} &>/dev/null

docker run -d --restart="always" --name $CONTAINER_NAME \
    -p "53:53/udp" \
    -v $(pwd)/Corefile:/Corefile \
    $IMAGE_NAME \
    --conf /Corefile
