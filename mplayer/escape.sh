#!/usr/bin/env bash

# todo
# follow convention
# * echo -n | awk '{ print $0 }'
# * echo | awk '{ print $0 }'

read_escape() {
    while read -r filename; do
        escape $filename
    done
}

escape() {
    local raw="${*:?requires string which needs to be escaped}"

    local blacklist=(
    # -option; mv
    '^-'
    # php.quotemeta()
    '\.' '+' '\\' '*' '?' '\[' '\]' '\^' '(' ')' '\$'
    # filename
    ' '
    )

    local pattern="${blacklist[0]}"
    for (( i=1; i < ${#blacklist[@]}; i ++ )) {
        pattern="$pattern\\|${blacklist[$i]}"
    }

    echo $raw | sed "s#\($pattern\)#\\\&#g"
}

test_escape() {
    local input='-a-b.a\c+d*e?f[g]h^i(j)k$l m'
    local expect='\-a-b\.a\\c\+d\*e\?f\[g\]h\^i\(j\)k\$l\ m'

    [ "$(escape $input)" != "$expect" ] && {
        >&2 echo "[x] escape did not work as expected."
        return 1
    }

    echo "everything is fine."
}
