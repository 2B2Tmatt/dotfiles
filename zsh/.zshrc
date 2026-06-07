# Enable Powerlevel10k instant prompt. Keep this at the absolute top!
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Environment & Paths ---
export PATH="/home/matt/.local/bin:$PATH"
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

# --- Zsh Options ---
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# --- Keybindings (Emacs mode + history search) ---
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# --- Completion Styles (Must be defined BEFORE completion engine runs) ---
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
[[ -n "$LS_COLORS" ]] && zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

alias ls='ls --color'
alias ll="exa -l"
alias zed='zeditor'

# --- Zinit Bootstrap ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# --- 1. Immediate UI Load ---
zinit ice depth=1; zinit light romkatv/powerlevel10k

# --- 2. Synchronous Plugin Loading ---
# We removed wait'0' and lucid so everything evaluates deterministically in order.

# A. Extend completion definitions
zinit ice blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

autoload -Uz compinit
compinit -C

zinit light Aloxaf/fzf-tab

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions

zinit snippet OMZP::git

if [[ ! -f ~/.cache/zoxide.zsh ]]; then
    zoxide init --cmd cd zsh > ~/.cache/zoxide.zsh
fi
source ~/.cache/zoxide.zsh

if [[ ! -f ~/.cache/fzf-init.zsh ]]; then
    fzf --zsh > ~/.cache/fzf-init.zsh
fi
source ~/.cache/fzf-init.zsh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
