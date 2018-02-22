#!/usr/bin/env bash

readonly MY_DIR=$(realpath $(dirname $0))
readonly IMAGE_NAME="ssserver"
readonly CONTAINER_NAME="ssserver"

# change it as your desire
readonly SS_PASSWORD="123abc"
readonly SS_ENCRYPT_METHOD="aes-256-cfb"
readonly SS_PORT=5443

cd $MY_DIR || exit 1

docker build -t $IMAGE_NAME .

docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME

docker run \
    -d --restart="always" \
    --name $CONTAINER_NAME \
    -p $SS_PORT:$SS_PORT \
    $IMAGE_NAME \
    -core $(nproc) -k $SS_PASSWORD -m $SS_ENCRYPT_METHOD
