#!/bin/sh

export ZDOTDIR=$HOME/.config/zsh
HISTFILE=~/.zsh/.zsh_history

setopt appendhistory autocd extendedglob nomatch menucomplete interactive_comments
stty stop undef
zle_highlight=('paste:none')

unsetopt BEEP

autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist

_comp_options+=(globdots)

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

autoload -Uz colors && colors

source "$ZDOTDIR/zsh-functions"

zsh_add_file "zsh-exports"
zsh_add_file "zsh-vim-mode"
zsh_add_file "zsh-aliases"
zsh_add_file "zsh-prompt"

zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"
zsh_add_completion "esc/conda-zsh-completion" false

bindkey '^[[P' delete-char
bindkey "^p" up-line-or-beginning-search
bindkey "^n" down-line-or-beginning-search
bindkey "^k" up-line-or-beginning-search
bindkey "^j" down-line-or-beginning-search
bindkey -r "^u" up-line-or-beginning-search
bindkey -r "^d" down-line-or-beginning-search
bindkey '^e' edit-command-line


[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f $ZDOTDIR/completion/_fnm ] && fpath+="$ZDOTDIR/completion/"
compinit


export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="firefox"

export QT_QPA_PLATFORMTHEME=qt5ct

# Need to use node version manager
source /usr/share/nvm/init-nvm.sh

# SSH
eval `keychain --quiet --agents ssh --eval id_rsa`

neofetch
