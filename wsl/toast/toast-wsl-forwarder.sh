#!/bin/bash

# This script is used on the WSL instance to forward toast data to Windows
# It requires toast.exe and wsl-notify-send.exe to be in the Windows PATH
# See https://github.com/stuartleeks/wsl-notify-send and https://github.com/go-toast/toast

command=""
while read line; 
do 
    if [[ -z $command ]]; then
        # Determine which command to run
        if [[ $line == "notify-send" ]]; then
            command="wsl-notify-send.exe"
        else
           command="toast.exe"
        fi
        command+=" "
    else
        # Add to the command args
        command+='"'$line'" '
    fi
done  <&0 # read stdin

# Now run the command!
bash -c "$command"
