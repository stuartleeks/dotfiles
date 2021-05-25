#!/bin/bash

# This script is used on the WSL instance to forward toast data to Windows
# It requires toast.exe and wsl-notify-send.exe to be in the Windows PATH
# See https://github.com/stuartleeks/wsl-notify-send and https://github.com/go-toast/toast

command=""
echo "Start:" > /home/stuart/toast-debug
while read line; 
do 
    echo "$line" >> /home/stuart/toast-debug
    if [[ -z $command ]]; then
        # Determine which command to run
        if [[ $line =~ notify-send$ ]]; then
            # first arg/line ends with notify-send (e.g. /home/vscode/dotfiles/devcontainer/toast/notify-send)
            command="wsl-notify-send.exe"
        else
            command="toast.exe"
        fi
        command+=" "
    else
        if [[ -n $line ]]; then
            # Add to the command args
            command+='"'$line'" '
        fi
    fi
done  <&0 # read stdin

# Now run the command!
bash -c "$command"
