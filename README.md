
# MY SETUP 2 DEV

### What you need:
To apply my configuration, follow the steps below and make sure you have the right environment set up with the necessary tools.

1. **Essential installations:**
   - **LazyVim** (a configuration manager for Neovim)
   - **Tmux** (a terminal multiplexer) and **tpm** (Tmux Plugin Manager)
   - **Neovim** (my main editor, minimum recommended version: 0.9.5)
   - **Luarocks** (for Neovim plugin dependencies)

2. **Recommended tools:**
   To enhance your terminal experience, I recommend installing the following tools:
   - `bat` (a stylish alternative to `cat`)
   - `eza` (an improved `ls` replacement)
   - `procs`, `dust`, `tokei`, `ytop`, `tealdeer`, `grex`, `rmesg`, `zoxide`, `delta`

   **Note:** Only **bat**, **eza**, and **zoxide** are required to apply my `.zshrc` configuration.

   **Note:** To install these tools using `cargo`, simply run:
   ```bash
   cargo install bat exa procs dust tokei ytop tealdeer grex rmesg zoxide delta
   ```

---

### Step-by-Step Configuration:

1. **Install Essential Packages**:
   Start by installing the required packages via `pacman`:
   ```bash
   sudo pacman -S neovim tmux luarocks git ripgrep fzf thefuck
   ```

   Install optional dependencies (using `cargo` where applicable):
   ```bash
   cargo install bat eza procs dust tokei ytop tealdeer grex rmesg zoxide delta
   ```

2. **Clone the Official LazyVim Repository**:
   Get started with LazyVim by cloning its repository:
   ```bash
   git clone https://github.com/LazyVim/starter ~/.config/nvim
   cd ~/.config/nvim
   ```

3. **Overwrite Configuration Files**:
   After cloning the LazyVim repository, replace the existing configuration files with yours to use your personalized setup. For example:

   ```bash
   # Replace the Neovim configuration files:
   cp -r /path/to/my/config/. ~/.config/nvim/

   # Replace the Tmux configuration:
   cp -r /path/to/my/tmux/. ~/.tmux/
   ```

4. **Install Tmux Plugins**:
   Initialize **tpm** (Tmux Plugin Manager) to load plugins specified in `.tmux.conf`:
   ```bash
   # Open a new Tmux session, then press:
   Ctrl + B and then I (capital i)

   # This installs all plugins in your .tmux.conf
   ```
   > **Note**: If you copied my Tmux configuration, the prefix key is `S`, so you should use `Ctrl + S` and then `I`.

5. **Source the .zshrc configuration**:
   After setting up Tmux, ensure your shell configurations are loaded properly. Either restart your terminal or run:

   ```bash
   source ~/.zshrc
   ```

6. **Verify the Setup**:
   Open a new Neovim session and a Tmux session to verify that the configurations loaded correctly. You should see LazyVim's interface in Neovim and the custom Tmux setup.

---


### Optional Enhancements

For an improved experience, add these tools and integrations:

- **FZF**: A command-line fuzzy finder for searching files, git commits, etc.
- **Ripgrep**: A fast alternative to `grep`, integrated with Neovim for searching through files.
- **TheFuck**: A tool to correct errors in previous console commands.

To install these tools:

```bash
sudo pacman -S fzf ripgrep thefuck
```

### TabNine Setup

To complete your setup and enable AI-powered autocompletions with TabNine, follow these additional steps.

1. **Download and Install TabNine Binaries**:
   - You can find the instructions here: [Tabnine NVIM](https://github.com/codota/tabnine-nvim)
   - TabNine requires specific binaries to function. To download them, run the following command:
     ```bash
     cd /home/<YourUser>/.local/share/nvim/lazy/tabnine-nvim && ./dl_binaries.sh
     ```
   - Replace `<YourUser>` with your actual username. This will download and unpack the necessary binaries for TabNine.

2. **Authenticate TabNine with Your Token**:
   - After the binaries are installed, open Neovim and start a coding session. TabNine should prompt you to log in with a token if needed.
   - You can retrieve or manage your TabNine token by logging into your [TabNine account](https://www.tabnine.com/) online.

3. **Restart Neovim**:
   - After logging in, restart Neovim to ensure TabNine recognizes your account and settings.

Once completed, TabNine should be fully functional and providing AI-based code suggestions within Neovim.

---

> I was too lazy to finish teaching you everything, but with these steps, you're already on the right track to set everything up properly!
