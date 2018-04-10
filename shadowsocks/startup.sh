#!/usr/bin/env bash

readonly MY_DIR=$(realpath $(dirname $0))
readonly IMAGE_NAME="ssserver"
readonly CONTAINER_NAME="ssserver"

# change it as your desire
readonly SS_PASSWORD="${password:-weiyoujingtingshan}"
readonly SS_ENCRYPT_METHOD="${encrypt:-aes-256-cfb}"
readonly SS_PORT="${port:-6443}"

logger() {
    >&2 printf "[%s] -- %s\n" "$(date '+%Y%m%d-%H%M%S')" "$*"
}

cd $MY_DIR || exit 1

if [ $(docker images -q "$IMAGE_NAME:latest" | wc -l) -eq 0 ]; then
    logger "not found $IMAGE_NAME:latest, trying to build..."
    docker build -t $IMAGE_NAME . || {
        logger "### build ssserver image failed"
        exit 1
    }
fi

{
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
} &>/dev/null

docker run \
    -d --restart="always" \
    --name $CONTAINER_NAME \
    -p $SS_PORT:$SS_PORT \
    $IMAGE_NAME \
    -core $(nproc) \
    -k $SS_PASSWORD \
    -m $SS_ENCRYPT_METHOD \
    -p $SS_PORT

if [ $? -eq 0 ]; then
    cat <<EOF
#############################################################################
# running ssserver with config:
#############################################################################
* server:         $(dig +short myip.opendns.com @resolver1.opendns.com)
* port:           $SS_PORT
* password:       $SS_PASSWORD
* encrypt-method: $SS_ENCRYPT_METHOD
EOF
else
    logger "failed to start ssserver"
    exit 1
fi
