# wcode - open code as if from Windows via \\wsl$ path
wcode() { cmd.exe /C code ''$(wslpath -w $1)''; }
wcode-insiders() { cmd.exe /C code-insiders ''$(wslpath -w $1)''; }


alias gitk=gitk.exe


if [[ $(command -v npiperelay.exe > /dev/null; echo $?) == 0 ]]; then
    if [[ $(command -v setsid > /dev/null; echo $?) == 0 ]]; then
        if [[ $(command -v socat > /dev/null; echo $?) == 0 ]]; then
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
                    echo "removing previous socket..."
                    rm $SSH_AUTH_SOCK
                fi
                echo "Starting SSH-Agent relay..."
                # setsid to force new session to keep running
                # set socat to listen on $SSH_AUTH_SOCK and forward to npiperelay which then forwards to openssh-ssh-agent on windows
                (setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) 2>&1 > /dev/null
            else
                echo "SSH key forwarding already running"
            fi

        fi
    fi
fi