# 🧰 My Setup2Dev

Welcome to my personal development environment setup!  
This repository contains my configuration files and preferred tools to create a productive and minimal terminal-based workflow.

---

## ⚙️ Environment Requirements

### ✅ Essential Installations

Ensure you have the following tools installed:

- **Neovim** (main editor – minimum version: `0.9.5`)
- **LazyVim** (Neovim configuration framework)
- **Tmux** (terminal multiplexer)
- **TPM** (Tmux Plugin Manager)
- **Luarocks** (Lua package manager for Neovim plugins)
- **Tmuxinator** (for managing Tmux sessions via YAML)

Install them with:

```bash
sudo pacman -S neovim tmux luarocks git ripgrep fzf thefuck ruby
gem install tmuxinator
```

---

### 🐟 I Use Fish Shell

I use **Fish** as my default shell due to its user-friendly syntax and interactive capabilities.

To use Fish:

```bash
sudo pacman -S fish
chsh -s $(which fish)
```

#### 🎨 Add Styling with Oh My Posh

```bash
curl -s https://ohmyposh.dev/install.sh | bash -s
```

Then follow instructions at [ohmyposh.dev](https://ohmyposh.dev) to configure your prompt.

---

## 💻 Recommended Terminal Tools

For an improved terminal experience, install:

- `bat` – colourful alternative to `cat`
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

Install via Cargo:

```bash
cargo install bat eza zoxide procs dust tokei ytop tealdeer grex rmesg delta
```

> **Note:** `bat`, `eza`, and `zoxide` are essential for my Fish shell setup.

---

## 📂 Tmuxinator Projects

I manage all Tmux sessions with **Tmuxinator**, allowing quick launch of custom dev environments using YAML files.

Create a project:

```bash
tmuxinator new my-project
```

Start it:

```bash
tmuxinator start my-project
```



---

## 🙏 Credits

This setup was heavily inspired by the amazing work of:

- [craftzdog](https://github.com/craftzdog) – for the foundational LazyVim configuration.
- [exosyphon](https://github.com/exosyphon) – for the LSP configuration structure.
- [nikolovlazar](https://github.com/nikolovlazar) – for the file organization idea and programming language configurations.


Big thanks to these developers — their configs helped shape this environment.

Make sure to check out their repositories for more awesome setups and ideas!

---

Enjoy the setup! Feel free to fork or customise it for your own workflow.
