
# Check if the current shell is a login shell
set -o vi

# Check if the current shell is a login shell
if [[ $- != *i* ]]; then
   return
fi

# Customize the prompt to show the user, hostname, and current directory
PS1='\u@\h:\w\$ '

# Alias definitions
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'

# Set a default editor
export EDITOR=vim

# Colorize the output for `ls` and other commands
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add custom paths if needed
# export PATH=$PATH:/your/custom/path

# Enable command auto-completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi
