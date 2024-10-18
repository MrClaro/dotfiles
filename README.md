
# MY SETUP 2 DEV

### What you need:
To apply my configuration, follow the steps below and make sure you have the right environment set up with the necessary tools.

1. **Essential installations:**
   - **LazyVim** (a configuration manager for Neovim)
   - **Tmux** (a terminal multiplexer) and **tpm** (Tmux Plugin Manager)
   - **Neovim** (my main editor, minimum recommended version: 0.9.5)
   - **LazyVim** (to start with an efficient Neovim configuration)

2. **Recommended tools:**
   To enhance your terminal experience, I recommend installing the following tools:
   - `bat` (a stylish alternative to `cat`)
   - `exa` (an improved `ls` replacement)
   - `procs`, `dust`, `tokei`, `ytop`, `tealdeer`, `grex`, `rmesg`, `zoxide`, `delta`

   **Note:** Only **bat**, **exa**, and **zoxide** are required to apply my `.zshrc` configuration.
     
   **Note:** Also to install I recommend that you use the cargo, just copy and paste:
   ```
   cargo install bat exa procs dust tokei ytop tealdeer grex rmesg zoxide delta
   ```
---

### Step-by-step configuration:

1. **Clone the official LazyVim repository**:
   This is the first step to get started with my personalized configuration:

   ```bash
   git clone https://github.com/LazyVim/starter ~/.config/nvim
   cd ~/.config/nvim
   ```

2. **Overwrite configuration files**:
   Once you have cloned the LazyVim repository, you need to overwrite the existing configuration files with mine. This will ensure that you're using my customized setup.

   Assuming you have a folder containing my configurations, execute the following commands:

   ```bash
   # Replace the Neovim configuration files:
   cp -r /path/to/my/config/. ~/.config/nvim/

   # Replace the Tmux configuration:
   cp -r /path/to/my/tmux/. ~/.tmux/
   ```

3. **Install Tmux Plugins**:
   After copying the Tmux configuration, you’ll need to initialize **tpm** (Tmux Plugin Manager) to load the plugins specified in the `.tmux.conf`. Do this by opening a new Tmux session and running:

   ```bash
   # Inside the tmux session, press:
   Ctrl + B and then I (capital i)

   # This will install all the plugins defined in your .tmux.conf
   ```
   If you copied my tmux configuration, your leading key is S, so you should use Ctrl + S and then I


4. **Source the .zshrc configuration**:
   After setting up Tmux, you’ll also need to make sure your shell configurations are loaded properly. You can either restart your terminal or run:

   ```bash
   source ~/.zshrc
   ```

5. **Verify the setup**:
   Once everything is set up, open a new Neovim session and a Tmux session to ensure that the configurations are loaded correctly. You should see LazyVim's interface in Neovim and the custom Tmux setup working as expected.

---

### Optional enhancements:

If you want to improve your overall experience, you can customize your terminal even further by adding additional tools and integrations. Here are some that I highly recommend:

- **FZF**: A general-purpose command-line fuzzy finder for searching files, git commits, etc.
- **Ripgrep**: A super-fast alternative to `grep`, integrated with Neovim for searching through files.
- **TheFuck**: A command-line tool that corrects errors in previous console commands.

To install these tools:

```bash
# Example:
sudo apt install fzf ripgrep thefuck
```

---

> I was too lazy to finish teaching you everything, but with these steps, you're already on the right track to set everything up properly!
