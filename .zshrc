# Antigen: https://github.com/zsh-users/antigen
ANTIGEN="$HOME/.local/bin/antigen.zsh"

# Install antigen.zsh if not exist
if [ ! -f "$ANTIGEN" ]; then
	echo "Installing antigen ..."
	[ ! -d "$HOME/.local" ] && mkdir -p "$HOME/.local" 2> /dev/null
	[ ! -d "$HOME/.local/bin" ] && mkdir -p "$HOME/.local/bin" 2> /dev/null
	# [ ! -f "$HOME/.z" ] && touch "$HOME/.z"
	URL="http://git.io/antigen"
	TMPFILE="/tmp/antigen.zsh"
	if [ -x "$(which curl)" ]; then
		curl -L "$URL" -o "$TMPFILE" 
	elif [ -x "$(which wget)" ]; then
		wget "$URL" -O "$TMPFILE" 
	else
		echo "ERROR: please install curl or wget before installation !!"
		exit
	fi
	if [ ! $? -eq 0 ]; then
		echo ""
		echo "ERROR: downloading antigen.zsh ($URL) failed !!"
		exit
	fi;
	echo "move $TMPFILE to $ANTIGEN"
	mv "$TMPFILE" "$ANTIGEN"
fi

source ~/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# default bundles
antigen bundle rupa/z z.sh
antigen bundle Vifon/deer
antigen bundle zdharma/fast-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

antigen bundle willghatch/zsh-cdr
# antigen bundle zsh-users/zaw

# check login shell
if [[ -o login ]]; then
	[ -f "$HOME/.local/etc/login.sh" ] && source "$HOME/.local/etc/login.sh"
	[ -f "$HOME/.local/etc/login.zsh" ] && source "$HOME/.local/etc/login.zsh"
fi

# syntax color definition
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

typeset -A ZSH_HIGHLIGHT_STYLES

# ZSH_HIGHLIGHT_STYLES[command]=fg=white,bold
# ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'

# load local config
[ -f "$HOME/.local/etc/config.zsh" ] && source "$HOME/.local/etc/config.zsh" 
[ -f "$HOME/.local/etc/local.zsh" ] && source "$HOME/.local/etc/local.zsh"

# Load the theme.
antigen theme awesomepanda af-magic cloud fishy agnoster rkj-repos steeef ys candy robbyrussell

# WSL (aka Bash for Windows) doesn't work well with BG_NICE
[ -d "/mnt/c" ] && [[ "$(uname -a)" == *Microsoft* ]] && unsetopt BG_NICE

# Enable 256 color to make auto-suggestions look nice
export TERM="xterm-256color"

ZSH_AUTOSUGGEST_USE_ASYNC=1

# Tell Antigen that you're done.
antigen apply

# options
unsetopt correct_all
unsetopt share_history
setopt prompt_subst

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
# setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY # Don't execute immediately upon history expansion.

# setup for deer
autoload -U deer
zle -N deer

# source function.sh if it exists
[ -f "$HOME/.local/etc/function.sh" ] && . "$HOME/.local/etc/function.sh"

# Disable correction
unsetopt correct_all
unsetopt correct
DISABLE_CORRECTION="true" 

# completion detail
zstyle ':completion:*:complete:-command-:*:*' ignored-patterns '*.pdf|*.exe|*.dll'
zstyle ':completion:*:*sh:*:' tag-order files

export GOPATH=$HOME/go
export PATH=$PATH:$HOME/go/bin
export TERM=xterm-256color
#export TERM=screen-256color

#autoload edit-command-line; zle -N edit-command-line
#bindkey '^v' edit-command-line

#alias av='source venv/bin/activate.fish'
alias c='clear'
alias cdiff='colordiff'
alias cs='cowsay'
#alias dv='deactivate'
alias gc='git config credential.helper store'
alias ipy='ipython'
alias l='ls -la'
alias lg='lazygit'
alias ms='mailsync'
alias mt='neomutt'
alias nv='nvim'
alias r='echo $RANGER_LEVEL'
alias ra='ranger'
# ra() {
	#if [ -z "$RANGER_LEVEL" ]
	#then
		#ranger
	#else
		#exit
	#fi
#}
alias s='neofetch'
alias sra='sudo -E ranger'
alias sudo='sudo -E'
alias vim='nvim'
alias gs='git config credential.helper store'
alias bat='sudo tlp bat'
alias ac='sudo tlp ac'

#function zle-line-init zle-keymap-select {
	#RPS1="${${KEYMAP/vicmd/-- NOR --}/(main|viins)/-- INS --}"
	#RPS2=$RPS1
	#zle reset-prompt
#}

function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'

  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

# Use beam shape cursor on startup.
echo -ne '\e[5 q'

# Use beam shape cursor for each new prompt.
preexec() {
   echo -ne '\e[5 q'
}

_fix_cursor() {
   echo -ne '\e[5 q'
}
precmd_functions+=(_fix_cursor)


zle -N zle-line-init
zle -N zle-keymap-select

KEYTIMEOUT=1

eval $(thefuck --alias)

export LC_CTYPE=zh_CN.UTF-8
export LANG="en_US.UTF-8" 
export LC_ALL="zh_CN.UTF-8" 

#export DISPLAY=`cat /etc/resolv.conf | grep nameserver | awk '{print $2}'`:0
#export PULSE_SERVER=`cat /etc/resolv.conf | grep nameserver | awk '{print $2}'`

GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS="@im=fcitx"

export EDITOR=nvim

[[ -z $DISPLAY && $XDG_VTNR -eq 1  ]] && exec startx

#export DOTNET_ROOT="/opt/dotnet"

#genie -s

clear
