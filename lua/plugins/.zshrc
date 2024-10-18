export PATH="$PATH:/opt/nvim-linux64/bin"
export PATH="$HOME/.cargo/bin:$PATH"

# Enable Powerlevel10k instant prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# scripts
export PATH="$HOME/.scripts:$PATH"
alias ide="$HOME/.scripts/ide.sh"

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Plugins and source for Oh My Zsh
plugins=(git)
source $ZSH

# Powerlevel10k theme
source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias reloadzsh="source ~/.zshrc"
alias editzsh="nvim ~/.zshrc"
alias vim=nvim
alias ohmyzsh="cd .oh-my-zsh"
alias editohmyzsh="nvim .oh-my-zsh"
alias fd=fdfind
alias c="clear"

# History setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history 
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# Disable automatic globbing expansion
unsetopt glob

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# RBENV configuration
export PATH="$HOME/.rbenv/shims:$PATH"

# ---- FZF -----

# Set custom FZF options
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

export FZF_DEFAULT_COMMAND="fdfind --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fdfind --type=d --hidden --exclude .git"

# Bat (better cat)
export BAT_THEME=tokyonight_night

# Eza (better ls)
alias ls="eza --icons=always"

# Zoxide (better cd)
eval "$(zoxide init zsh)"

alias cd="z"
