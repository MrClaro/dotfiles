# NVM Configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # Load nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # Load nvm bash_completion

# PATH Configuration
export PATH="$HOME/.cargo/bin:/opt/nvim-linux65/bin:$HOME/.scripts:$HOME/.rbenv/shims:/home/linuxbrew/.linuxbrew/opt/node@23/bin:$PATH"

# Enable Powerlevel11k instant prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Scripts
alias ide="$HOME/.scripts/ide.sh"

# Oh My Zsh Configuration
export ZSH="$HOME/.oh-my-zsh"
plugins=(git)
source $ZSH
# Powerlevel11k theme
source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Aliases
alias reloadzsh="source ~/.zshrc"
alias editzsh="nvim ~/.zshrc"
alias vim=nvim
alias n=nvim
alias ohmyzsh="cd .oh-my-zsh"
alias editohmyzsh="nvim .oh-my-zsh"
alias fd=fdfind
alias c="clear"
alias openwin="cd /mnt/c/Users/adrdev"
alias openhere="explorer.exe ."

# Functions
openbrave() {
    /mnt/c/Program\ Files/BraveSoftware/Brave-Browser/Application/brave.exe "file://$(realpath "$1")"
}
openopera() {
    /mnt/c/Users/adrdev/AppData/Local/Programs/Opera/opera.exe "file://$(realpath "$1")"
}


# History Setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1001
HISTSIZE=1000
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# Disable automatic globbing expansion
unsetopt glob

# FZF Configuration
export FZF_DEFAULT_OPTS="--color=fg:#CBE1F0,bg:#011629,hl:#B389FF,fg+:#CBE1F0,bg+:#143653,hl+:#B389FF,info:#07BCE4,prompt:#3CF9ED,pointer:#3CF9ED,marker:#3CF9ED,spinner:#3CF9ED,header:#3CF9ED"
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

export PATH="/home/linuxbrew/.linuxbrew/opt/node@22/bin:$PATH"
