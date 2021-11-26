#!/bin/bash
result="1"
while [[ $result != "0" ]]; do
  result=$(ping -c 1 -W 1 1.1.1.1 > /dev/null; echo $?)
  if [[ $result != "0" ]]; then
    echo "down..."
  fi
  sleep 1s
done

notify-send --category "Network" "... is back up" --appId "utils"
