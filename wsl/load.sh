dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# wcode - open code as if from Windows via \\wsl$ path
wcode() { cmd.exe /C code ''$(wslpath -w $1)''; }
wcode-insiders() { cmd.exe /C code-insiders ''$(wslpath -w $1)''; }

# Create function to launch Windows Terminal (cmd version is faster but doesn't support UNC paths (including \\wsl$ paths)
#wt(){ cmd.exe /C "wt.exe $@" ; }
wt(){ powershell.exe -Command "wt.exe $@" ; }

alias gitk=gitk.exe
alias explorer=explorer.exe
alias clip=clip.exe

## add clip folder to path to override xsel/xclip with WSL versions!
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export PATH=$DIR/clip:$PATH

if [[ $(command -v npiperelay.exe > /dev/null; echo $?) == 0 ]]; then
    if [[ $(command -v setsid > /dev/null; echo $?) == 0 ]]; then
        if [[ $(command -v socat > /dev/null; echo $?) == 0 ]]; then

            stop-ssh-relay() { kill $(ps -auxww | grep "[n]piperelay.exe -ei -s //./pipe/openssh-ssh-agent" | awk '{ print $2 }'); }
            #
            # Set up ssh agent forwarding to host
            #

            # Include this in .bashrc
                # Ensure that the ssh-agent service is running on windows
            # build https://github.com/jstarks/npiperelay and ensure it is in your PATH (or modify the script to specify the qualified path)


            # Configure ssh forwarding
            export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
            # need `ps -ww` to get non-truncated command for matching
            # use square brackets to generate a regex match for the process we want but that doesn't match the grep command running it!
            ALREADY_RUNNING=$(ps -auxww | grep -q "[n]piperelay.exe -ei -s //./pipe/openssh-ssh-agent"; echo $?)
            if [[ $ALREADY_RUNNING != "0" ]]; then
                if [[ -S $SSH_AUTH_SOCK ]]; then
                    # not expecting the socket to exist as the forwarding command isn't running (http://www.tldp.org/LDP/abs/html/fto.html)
                    echo -n "Removing previous SSH_AUTH_SOCK ..."
                    rm $SSH_AUTH_SOCK
                    echo " done"
                fi
                echo -n "Starting SSH-Agent relay..."
                # setsid to force new session to keep running
                # set socat to listen on $SSH_AUTH_SOCK and forward to npiperelay which then forwards to openssh-ssh-agent on windows
                (setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) > /dev/null  2>&1 
                echo " done"
            else
                echo "SSH key forwarding already running"
            fi

        fi
    fi
fi

if [[ $(command -v socat > /dev/null; echo $?) == 0 ]]; then
    # Start up the socat forwarder to clip.exe
    # see aliases/load.sh for adding clip.sh to path (as xclip/xsel) to forward clipboard access to this listener
    ALREADY_RUNNING=$(ps -auxww | grep -q "[l]isten:8121"; echo $?)
    if [[ $ALREADY_RUNNING != "0" ]]; then
        echo -n "Starting clipboard relay..."
        (setsid socat tcp-listen:8121,fork,bind=0.0.0.0 EXEC:'clip.exe' &) > /dev/null 2>&1 
        echo " done"
    else
        echo "Clipboard relay already running"
    fi

    # Start up socat forwarder for toast/wsl-notify-send
    ALREADY_RUNNING=$(ps -auxww | grep -q "[l]isten:8122"; echo $?)
    if [[ $ALREADY_RUNNING != "0" ]]; then
        echo -n "Starting toast relay..."
        (setsid socat tcp-listen:8122,fork,bind=0.0.0.0 EXEC:"$dir/toast/toast-wsl-forwarder.sh" &) > /dev/null 2>&1 
        echo " done"
    else
        echo "Toast relay already running"
    fi
fi

free-mem() { sudo "$DOTFILES_FOLDER/wsl/free-mem.sh"; }


if [[ -z $DEV_CONTAINER ]]; then
    # if not in a dev container then set aliases for toast/notify-send
    alias toast=toast.exe
    if [[ $(command -v wsl-notify-send.exe > /dev/null; echo $?) == 0 ]]; then 
        notify-send() { /mnt/c/tools/wsl-notify-send.exe --category "$WSL_DISTRO_NAME" "$@"; }
    fi
fi
