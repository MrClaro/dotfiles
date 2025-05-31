# 🧰 My Dev Environment Setup

Welcome to my personal development environment!  
This repository contains all my configuration files and preferred tools for a productive, minimal, and highly customizable terminal-based workflow.

---

## ⚙️ Environment Requirements

### ✅ Essential Installations

Make sure to have the following tools installed:

- **Neovim** (main editor – minimum version: `0.9.5`)
- **LazyVim** (Neovim config framework)
- **Tmux** (terminal multiplexer)
- **TPM** (Tmux Plugin Manager)
- **Luarocks** (Lua package manager for Neovim plugins)
- **Tmuxinator** (manage Tmux sessions with YAML)

You can install most of them with:

```bash
sudo pacman -S neovim tmux luarocks git ripgrep fzf thefuck ruby
gem install tmuxinator
```

---

### 🐟 Using the Fish Shell

I use **Fish** as my default shell for its user-friendly syntax and interactive features.

To install and set Fish as your default shell:

```bash
sudo pacman -S fish
chsh -s $(which fish)
```

#### 🎨 Enhance Your Prompt with Oh My Posh

Add beautiful styling to your terminal prompt:

```bash
curl -s https://ohmyposh.dev/install.sh | bash -s
```

Follow their guide at [ohmyposh.dev](https://ohmyposh.dev) for further configuration.

---

## 💻 Recommended Terminal Tools

For an improved terminal experience, I recommend installing:

- `bat` – colorful alternative to `cat`
- `eza` – modern replacement for `ls`
- `zoxide` – smarter `cd`
- `procs` – modern replacement for `ps`
- `dust` – better `du`
- `tokei` – code statistics
- `ytop` – terminal system monitor
- `tealdeer` – fast `tldr` client
- `grex` – regex generator
- `rmesg` – readable `dmesg`
- `delta` – improved `git diff`

Install them via Cargo:

```bash
cargo install bat eza zoxide procs dust tokei ytop tealdeer grex rmesg delta
```

> **Tip:** `bat`, `eza`, and `zoxide` are essential for my Fish shell setup.

---

## 📂 Managing Projects with Tmuxinator

All my Tmux sessions are managed with **Tmuxinator**, enabling quick launch of custom development environments described in YAML files.

Create a project:

```bash
tmuxinator new my-project
```

Start a project:

```bash
tmuxinator start my-project
```

---

## 📁 Repository Structure

- `.config/nvim/` — Neovim configuration (based on LazyVim)
- `.config/fish/` — Fish shell configuration and functions
- `.tmux.conf` — Tmux main configuration
- `.tmuxinator/` — Tmuxinator project files
- ...and more!

---

## 🙏 Credits

This configuration was inspired by the awesome work of:

- [craftzdog](https://github.com/craftzdog) – foundational LazyVim config
- [exosyphon](https://github.com/exosyphon) – LSP config structure
- [nikolovlazar](https://github.com/nikolovlazar) – file organization and language config ideas

Big thanks to these developers—their setups helped shape this environment.  
Check out their repositories for more inspiration!

---

## 🚀 Getting Started

1. Clone this repository:
   ```bash
   git clone https://github.com/MrClaro/dotfiles.git
   ```
2. Copy/symlink the configs to your `$HOME` directory or use a tool like [GNU Stow](https://www.gnu.org/software/stow/).
3. Install all required dependencies (see above).
4. Launch your terminal and enjoy your new workflow!

---

Enjoy the setup!  
Feel free to fork, adapt, or contribute to improve your own environment.

---
