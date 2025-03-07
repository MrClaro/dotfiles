oh-my-posh init fish --config $HOME/.poshthemes/catppuccin_macchiato.omp.json | source
# PATH Configuration
set -gx PATH "$HOME/.cargo/bin" /opt/nvim-linux65/bin "$HOME/.scripts" "$HOME/.rbenv/shims" "/home/linuxbrew/.linuxbrew/opt/node@23/bin" $PATH

# Aliases
alias reloadfish="source ~/.config/fish/config.fish"
alias editfish="nvim ~/.config/fish/config.fish"
alias vim="nvim"
alias n="nvim"
alias fd="fdfind"
alias c="clear"
alias openwin="cd /mnt/c/Users/adrdev"
alias openhere="explorer.exe ."

# FZF Configuration
set -gx FZF_DEFAULT_OPTS "--color=fg:#CBE1F0,bg:#011629,hl:#B389FF,fg+:#CBE1F0,bg+:#143653,hl+:#B389FF,info:#07BCE4,prompt:#3CF9ED,pointer:#3CF9ED,marker:#3CF9ED,spinner:#3CF9ED,header:#3CF9ED"
set -gx FZF_DEFAULT_COMMAND "fdfind --hidden --strip-cwd-prefix --exclude .git"
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_ALT_C_COMMAND "fdfind --type=d --hidden --exclude .git"

# Bat (better cat)
set -gx BAT_THEME tokyonight_night

# Eza (better ls)
alias ls="eza --icons=always"

# Zoxide (better cd)
zoxide init fish | source
alias cd="z"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
