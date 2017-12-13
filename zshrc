#------------------------------------------------------------------#
# File:     .zshrc   ZSH resource file                             #
#------------------------------------------------------------------#

ZDOTDIR=$HOME/.zsh
fpath=($ZDOTDIR/functions $ZDOTDIR/completion $fpath)
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
export EDITOR="nvim"
path=( "$HOME/.cargo/bin" "$HOME/.yarn/bin" "/usr/local/opt/python/libexec/bin" "/usr/local/opt/coreutils/libexec/gnubin" $path )

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:/usr/local/share/man:/usr/share/man"

#-----------------------------
# Dircolors
#-----------------------------
LS_COLORS='rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:';
export LS_COLORS

#------------------------------
# Keybindings
#------------------------------
# Updates editor information when the keymap changes.
function zle-line-init zle-keymap-select() {
  zle reset-prompt
  zle -R
}
zle -N zle-line-init
zle -N zle-keymap-select

zle -N edit-command-line
setopt vi
zle-keymap-select () {
  if [ $KEYMAP = vicmd ]; then
    # the command mode for vi
    echo -ne "\e[2 q"
  else
    # the insert mode for vi
    echo -ne "\e[4 q"
  fi
}

# allow v to edit the command line (standard behaviour)
autoload -Uz edit-command-line
bindkey -M vicmd 'v' edit-command-line
# allow ctrl-h, ctrl-w, ctrl-? for char and word deletion (standard behaviour)
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word

bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history
bindkey "^K" history-beginning-search-backward

bindkey -M viins 'jj' vi-cmd-mode # escape insert mode with jj
KEYTIMEOUT=30
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
# Prompt
#------------------------------
autoload -U colors && colors
autoload -U promptinit; promptinit
prompt pure
PURE_GIT_PULL=0

#------------------------------
# Features
#------------------------------
setopt AUTO_CD
setopt NONOMATCH

#------------------------------
# zsh-autoenv
#------------------------------
source ~/.zsh/lib/zsh-autoenv/autoenv.zsh

#------------------------------
# Syntax highlighting
#------------------------------
if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  . /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
if [[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  . /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Autocompleteion for git-remove-merged and git-secret
# http://stackoverflow.com/a/38850556/1053532
zstyle ':completion:*:*:git:*' user-commands ${${(M)${(k)commands}:#git-*}/git-/}

#------------------------------
# FZF config
#------------------------------
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 30% --reverse -e'
# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*" --glob "!.idea/*" --glob "!node_modules/*"'
