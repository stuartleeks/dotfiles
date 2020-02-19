
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    echo "completion file at /usr/share/bash-completion/bash_completion"
  elif [ -f /etc/bash_completion ]; then
    echo "completion file at /etc/bash_completion"
  else
    echo "bash-completion not found. Installing..."
    apt-get update
    apt-get install bash-completion
  fi
fi