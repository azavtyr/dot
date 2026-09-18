#!/bin/bash
# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

export GITUSER="$USER"
export REPOS="${REPOS:-$HOME/Repos}"
export GHREPOS="$REPOS/github.com/$GITUSER"
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

pathprepend() {
	local directory
	for directory in "$@"; do
		[[ -d $directory ]] || continue
		PATH=${PATH//":$directory:"/:}
		PATH=${PATH/#"$directory:"/}
		PATH=${PATH/%":$directory"/}
		PATH="$directory${PATH:+":$PATH"}"
	done
	export PATH
}

# The last entry becomes the first one in PATH.
pathprepend \
	"$HOME/bin" \
	"$HOME/.local/bin" \
	"$HOME/Scripts" \
	/opt/homebrew/sbin \
	/opt/homebrew/bin \
	/opt/homebrew/opt/curl/bin

set-editor() {
	export EDITOR="$1"
	export VISUAL="$1"
	export GH_EDITOR="$1"
	export GIT_EDITOR="$1"
	alias vi="\$EDITOR"
}

command -v vim >/dev/null 2>&1 && set-editor vi
command -v nvim >/dev/null 2>&1 && set-editor nvim

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi


ps1() {
	local branch
	local reset='\[\e[0m\]'
	local gray='\[\e[0;30m\]'
	local yellow='\[\e[0;33m\]'
	local blue='\[\e[0;34m\]'
	local purple='\[\e[0;35m\]'
	local red='\[\e[0;31m\]'

	branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null \
		|| git rev-parse --short HEAD 2>/dev/null)

	PS1="${gray}╔[${yellow}\u${gray}@${blue}\h${gray}:${purple}\W"
	if [[ -n $branch ]]; then
		PS1+="${gray}(${red}${branch}${gray})"
	fi
	PS1+="${gray}]\n${gray}╚${yellow}\$${reset} "
}

PROMPT_COMMAND="ps1"

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
alias '?'=duck

p() {
	local dir
	dir=$(find "$GHREPOS" -mindepth 1 -maxdepth 1 -type d | fzf) || return
	[[ -n $dir ]] || return
	cd "$dir" || return
}

clone() {
	if (($# != 1)); then
		printf '%s\n' 'Usage: clone <repo|owner/repo|GitHub URL>' >&2
		return 2
	fi

	local repo=$1 user name user_dir path
	repo=${repo#https://github.com/}
	repo=${repo#http://github.com/}
	repo=${repo#git@github.com:}
	repo=${repo%/}
	repo=${repo%.git}

	if [[ $repo == */* ]]; then
		user=${repo%%/*}
		name=${repo#*/}
	else
		user=$GITUSER
		name=$repo
	fi

	if [[ ! $user =~ ^[A-Za-z0-9][A-Za-z0-9-]*$ ||
		! $name =~ ^[A-Za-z0-9._-]+$ || $name == '.' || $name == '..' ]]; then
		printf 'Invalid GitHub repository: %s\n' "$1" >&2
		return 2
	fi

	user_dir="$REPOS/github.com/$user"
	path="$user_dir/$name"

	if [[ -d $path ]]; then
		cd "$path" || return
		return
	fi

	if [[ -e $path ]]; then
		printf 'Path exists and is not a directory: %s\n' "$path" >&2
		return 1
	fi

	if ! command -v gh >/dev/null 2>&1; then
		printf '%s\n' 'gh command not found.' >&2
		return 1
	fi

	mkdir -p "$user_dir" || return
	printf 'Cloning %s/%s into %s\n' "$user" "$name" "$path"
	gh repo clone "$user/$name" "$path" -- --recurse-submodules || return
	cd "$path" || return
}

# Load command completions installed by Homebrew or the system package.
if command -v brew >/dev/null 2>&1; then
	brew_prefix=$(brew --prefix)
	if [[ -r $brew_prefix/etc/profile.d/bash_completion.sh ]]; then
		# shellcheck source=/dev/null
		source "$brew_prefix/etc/profile.d/bash_completion.sh"
	fi
	unset brew_prefix
fi

if [[ -z ${BASH_COMPLETION:-} ]]; then
	if [[ -r /usr/share/bash-completion/bash_completion ]]; then
		# shellcheck source=/dev/null
		source /usr/share/bash-completion/bash_completion
	elif [[ -r /etc/bash_completion ]]; then
		# shellcheck source=/dev/null
		source /etc/bash_completion
	fi
fi

if command -v gh >/dev/null 2>&1; then
	# shellcheck disable=SC1090
	source <(gh completion -s bash)
fi
