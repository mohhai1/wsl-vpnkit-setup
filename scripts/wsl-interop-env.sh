#!/bin/sh
export WSL_INTEROP=
for socket in $(ls /run/WSL | sort -n); do
    if ss -elx | grep "$socket"; then
        export WSL_INTEROP=/run/WSL/$socket
    else
        rm $socket
    fi
done