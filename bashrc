#!/bin/bash
# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

export GITUSER="$USER"
export GHREPOS="$HOME/Repos/github.com/$GITUSER"
export DOTFILES="$GHREPOS/dot"
export CDPATH=".:$GHREPOS:$HOME"
export PAGER='less'

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

HISTSIZE=5000
HISTFILESIZE=15000

set -o vi

shopt -s histappend
shopt -s checkwinsize

PATH="$HOME/Scripts:$HOME/.local/bin:$HOME/bin:$PATH"

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi


# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes


ps1() {
	gb=$(git branch --show-current "$PWD" 2>/dev/null)

	if [[ -n $gb ]]; then
		PS1="\[\033[30m\]╔[\[\033[0;33m\]\u\[\033[0;30m\]@\[\033[0;34m\]\h\[\033[0;30m\]:\[\033[0;35m\]\W\[\033[30m\](\[\033[31m\]$gb\033[30m\])]\n╚\[\033[0;33m\]\$ \[\033[00m\]"
	elif [[ -z $gb ]]; then
		PS1="\[\033[30m\]╔[\[\033[0;33m\]\u\[\033[0;30m\]@\[\033[0;34m\]\h\[\033[0;30m\]:\[\033[0;35m\]\W\[\033[30m\]]\n╚\[\033[0;33m\]\$ \[\033[00m\]"
	fi
}

PROMPT_COMMAND="ps1"

# if [ "$color_prompt" = yes ]; then
#[[ $PWD = $gb ]] && $gb=.
#[[ -n  ]]
#	PS1='${debian_chroot:+($debian_chroot)}\[\033[30m\]╔[\[\033[0;33m\]\u\[\033[0;30m\]@\[\033[0;34m\]\h\[\033[0;30m\]:\[\033[0;35m\]\W\[\033[30m\](\[\033[31m\]$gb\033[30m\])]\n╚\[\033[0;33m\]\$ \[\033[00m\]'
#else
#	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#fi
#unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm* | rxvt*)
#	PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#	;;
#*) ;;
#esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	if [[ -r ~/.dircolors ]]; then 
	eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	fi
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias more='less'
alias clear='printf "\033[H\033[2J"'
alias c='printf "\033[H\033[2J"'
alias dot='cd $DOTFILES'
