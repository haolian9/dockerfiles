#!/usr/bin/env bash

# see https://github.com/moby/moby/issues/2259
sudo chown 1000:1000 $XDG_RUNTIME_DIR

exec "$@"
