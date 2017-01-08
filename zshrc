#------------------------------------------------------------------#
# File:     .zshrc   ZSH resource file                             #
#------------------------------------------------------------------#

ZDOTDIR=$HOME/.zsh
fpath=($fpath $ZDOTDIR/functions)
#-----------------------------
# Source some stuff
#-----------------------------

#------------------------------
# History stuff
#------------------------------
HISTFILE=$ZDOTDIR/hist
HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
#setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
#setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.

#------------------------------
# Variables
#------------------------------
source $ZDOTDIR/aliases
source $ZDOTDIR/git-aliases

#------------------------------
# Variables
#------------------------------
export EDITOR="vim"
export PATH=''
path='/usr/local/opt/coreutils/libexec/gnubin'
for dir in \
  /usr/local/bin \
  /usr/bin \
  /bin \
  /usr/sbin \
  /sbin \
  $HOME/.yarn/bin \
; do
  if [[ -d $dir ]]; then path+=$dir; fi
done

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:/usr/local/share/man:/usr/share/man"

source ~/.zsh_aliases

#-----------------------------
# Dircolors
#-----------------------------
LS_COLORS='rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:';
export LS_COLORS

#------------------------------
# Keybindings
#------------------------------
bindkey -v
bindkey -M viins 'jj' vi-cmd-mode # escape insert mode with jj
#typeset -g -A key
#bindkey '\e[3~' delete-char
#bindkey '\e[1~' beginning-of-line
#bindkey '\e[4~' end-of-line
#bindkey '\e[2~' overwrite-mode
#bindkey '^?' backward-delete-char
#bindkey '^[[1~' beginning-of-line
#bindkey '^[[3~' delete-char
#bindkey '^[[4~' end-of-line
#bindkey '^[[A' up-line-or-search
#bindkey '^[[D' backward-char
#bindkey '^[[B' down-line-or-search
#bindkey '^[[C' forward-char 

bindkey "^R" history-incremental-pattern-search-backward
bindkey "^S" history-incremental-pattern-search-forward
bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history
bindkey "^K" history-beginning-search-backward

#------------------------------
# Alias stuff
#------------------------------
alias ls="ls --color"
alias ll="ls --color -lh"

#------------------------------
# ShellFuncs
#------------------------------
# -- coloured manuals
man() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@"
}

#------------------------------
# Comp stuff
#------------------------------
zmodload zsh/complist 
autoload -Uz compinit
compinit
zstyle :compinstall filename '${HOME}/.zshrc'

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*'   force-list always

#------------------------------
# Window title
#------------------------------
case $TERM in
  termite|*xterm*|rxvt|rxvt-unicode|rxvt-256color|rxvt-unicode-256color|(dt|k|E)term)
    precmd () {
      vcs_info
      print -Pn "\e]0;[%n@%M][%~]%#\a"
    } 
    preexec () { print -Pn "\e]0;[%n@%M][%~]%# ($1)\a" }
    ;;
  screen|screen-256color)
    precmd () { 
      vcs_info
      print -Pn "\e]83;title \"$1\"\a" 
      print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~]\a" 
    }
    preexec () { 
      print -Pn "\e]83;title \"$1\"\a" 
      print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~] ($1)\a" 
    }
    ;; 
esac

#------------------------------
# Prompt
#------------------------------
autoload -U colors && colors
autoload -U promptinit; promptinit
prompt pure
PURE_GIT_PULL=0

#------------------------------
# Features
#------------------------------
# extended globbing, awesome!
setopt extendedGlob

setopt auto_cd

# zmv -  a command for renaming files by means of shell patterns.
autoload -U zmv

#------------------------------
# Syntax highlighting
#------------------------------
if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  . /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
if [[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  . /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
