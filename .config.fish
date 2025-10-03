# --- PATH Configuration ---
# Adds important directories to the PATH.
set -gx PATH /usr/bin /bin "$HOME/.cargo/bin" /opt/nvim-linux65/bin "$HOME/.scripts" "$HOME/.rbenv/shims" "/home/linuxbrew/.linuxbrew/opt/node@23/bin" "$HOME/.local/bin" "$HOME/.local/share/gem/ruby/3.4.0/bin" $PATH
set -gx PATH $JAVA_HOME/bin /usr/bin /bin $PATH
set -gt JAVA_HOME=/usr/lib/jvm/java-21-openjdk
# Homebrew configuration.
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# --- Pyenv Configuration ---
set PYENV_ROOT $HOME/.pyenv
set -x PATH $PYENV_ROOT/shims $PYENV_ROOT/bin $PATH
pyenv rehash

# --- Oh My Posh Configuration ---
# Loads Oh My Posh with the catppuccin_macchiato theme.
# The $HOME variable already points to the user's home directory.
oh-my-posh init fish --config $HOME/.cache/oh-my-posh/themes/catppuccin_macchiato.omp.json | source

# --- Aliases ---
# Groups aliases for better readability.

# Editing and Reloading Aliases
alias reloadfish="source ~/.config/fish/config.fish"
alias editfish="nvim ~/.config/fish/config.fish"

# Navigation and System Aliases
alias ls="eza --icons=always" # Eza (ls alternative)
#alias cd="z $argv; ls" # Zoxide for better cd functionality and listing contents
#alias cd="z"
function cd
    z $argv
    ls
end
alias c="clear"
alias bye="tmux kill-server"

# Tooling Aliases
alias vim="nvim"
alias n="nvim"
alias fd="fdfind"
alias bk="cd .."
#alias dr="docker run -p 3306:3306 --name <container_name> -e MYSQL_ROOT_PASSWORD=<your_password> -d mysql:lts" # Remember to replace <container_name> and <your_password>
alias ide="$HOME/.scripts/ide.sh"
alias kulala="cd /home/adrdev/Documents/kulala && n ."
alias tx="tmux"
alias gotelegram="cd /home/adrdev/.var/app/org.telegram.desktop/data/TelegramDesktop/tdata/temp_data
"

# --- FZF Configuration ---
# FZF configurations for colors and default commands.
set -gx FZF_DEFAULT_OPTS "--color=fg:#CBE1F0,bg:#011629,hl:#B389FF,fg+:#CBE1F0,bg+:#143653,hl+:#B389FF,info:#07BCE4,prompt:#3CF9ED,pointer:#3CF9ED,marker:#3CF9ED,spinner:#3CF9ED,header:#3CF9ED"
set -gx FZF_DEFAULT_COMMAND "fdfind --hidden --strip-cwd-prefix --exclude .git"
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_ALT_C_COMMAND "fdfind --type=d --hidden --exclude .git"

# --- Bat (better cat) Configuration ---
# Sets the theme for Bat.
set -gx BAT_THEME tokyonight_night

# --- Zoxide (better cd) Configuration ---
# Initializes Zoxide.
zoxide init fish | source

# -- Start SSH ----
function start-ssh
    eval (ssh-agent -c)
    ssh-add ~/.ssh/github
end
funcsave start-ssh

# SSH Agent - inicia apenas uma vez por sessão
if not set -q SSH_AGENT_PID; and not pgrep -u $USER ssh-agent >/dev/null
    eval (ssh-agent -c) >/dev/null 2>&1
    ssh-add ~/.ssh/github >/dev/null 2>&1
end

function prismlauncher-nvidia
    flatpak run --env=DRI_PRIME=1 --env=__NV_PRIME_RENDER_OFFLOAD=1 --env=__GLX_VENDOR_LIBRARY_NAME=nvidia org.prismlauncher.PrismLauncher $argv
end
funcsave prismlauncher-nvidia
c
set -gx GTK_IM_MODULE xim
set -gx XMODIFIERS "@im=none"
set -U fish_user_paths $HOME/bin $fish_user_paths
