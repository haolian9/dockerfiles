#!/usr/bin/env bash

assert() {
    local assertion="${*:?requires assertion}"

    local exit_code=0
    if [ $VERBOSE -eq 1 ]; then
        eval $assertion
        exit_code=$?
    else
        {
            eval $assertion
            exit_code=$?
        } &>/dev/null
    fi


    if [ $exit_code -eq 0 ]; then
        >&2 echo "##### [o]: $assertion"
    else
        >&2 echo "##### [x]: $assertion"
        exit 1
    fi
}

test_up() {
    assert "$COMPOSE_BIN up -d"
    assert "$COMPOSE_BIN ps | grep -e sun -e Up"
    assert "$COMPOSE_BIN top sun | grep -F 'tail -f /dev/null' "
}

_cleanup() {
    {
        $COMPOSE_BIN down --rmi local -v --remove-orphans
    } &>/dev/null
}

trap "_cleanup" EXIT

ROOT=$(dirname $(realpath $0))
COMPOSE_BIN=$(realpath $ROOT/../docker-compose.sh)
VERBOSE=${VERBOSE:-1}

cd $ROOT && test_up
