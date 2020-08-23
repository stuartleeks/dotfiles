
if [[ $(type -t _get_comp_words_by_ref) != "function" ]]; then
  if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
      source /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
      echo "completion file at /etc/bash_completion"
      source /etc/bash_completion
    else
      echo "bash-completion not found. Installing..."
      source /usr/share/bash-completion/bash_completion
    fi
  fi
fi