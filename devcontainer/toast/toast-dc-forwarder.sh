#!/bin/bash

# This script runs in the dev container. It is aliased as toast and notify-send, and captures
# the args passed to it. These are separated by newlines and then forwarded to WSL over TCP
# so that the WSL listener can invoke the windows notification.

data="$0\n"

for i in "$@"; do
  data+=$i"\n"
done

echo -e $data | socat - tcp:host.docker.internal:8122
