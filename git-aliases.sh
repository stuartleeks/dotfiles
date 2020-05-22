if [[ $(which git > /dev/null; echo $?) == "0" ]]; then
    echo "Found git, setting up aliases"
    git config --global --replace-all alias.amendcommit '!git commit --amend --reuse-message "$(git rev-parse --abbrev-ref HEAD)"'
    git config --global --replace-all alias.branches 'branch -a --color -v'
    git config --global --replace-all alias.wip '!git add -A && git commit -qm WIP'
    git config --global --replace-all alias.sv 'status -vv'
    git config --global --replace-all alias.undo 'reset HEAD~1 --mixed'
    git config --global --replace-all alias.pr '! f() { git fetch upstream pull/$1/head:pr-$1; git checkout pr-$1; }; f'
    git config --global --replace-all alias.ls 'log --pretty=format:%C(yellow)%h%Cred%d\ %Creset%s%Cblue\ [%cn] --decorate'
    git config --global --replace-all alias.fl 'log -u'
    git config --global --replace-all alias.logtree 'log --graph --oneline --decorate --all'
    git config --global --replace-all alias.wipe "!git add -A && git commit -qm 'WIPE SAVEPOINT' && git reset HEAD~1 --hard"
else
    echo "git not found - skipping aliases"
fi
