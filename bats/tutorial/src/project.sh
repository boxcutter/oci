#!/usr/bin/env bash

FIRST_RUN_FILE=/tmp/bats-tutorial-project-ran

if [[ ! -e "$FIRST_RUN_FILE" ]]; then
    echo "Welcome to our project!"
    touch "$FIRST_RUN_FILE"
fi

case $1 in
    start-echo-server)
        echo "Starting echo server"
        PORT=2000
        ncat -l $PORT -k -c 'xargs -n1 echo' 2>/dev/null & # don't keep open this script's stderr
        echo $! > /tmp/project-echo-server.pid
        echo "$PORT" >&2
    ;;
    *)
        echo "NOT IMPLEMENTED!" >&2
        exit 1
    ;;
esac
