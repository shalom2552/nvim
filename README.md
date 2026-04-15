# 💤 LazyVim Config

My personal configuration built on the [LazyVim Starter Template](https://github.com/LazyVim/LazyVim). This repository tracks my custom plugins, keymaps, and modifications.

## Custom Plugins

- **Code Runner** — Execute C, C++, Python and other files directly from the editor. Automatically detects and uses Makefiles when present.
- **Transparent** — Toggle transparency for all UI elements with visual notification on change.
- **IDE Toggle** — Strip down the editor to a minimal state by disabling all IDE features — useful for algorithm practice.
- **Dashboard** — Custom start screen with HJKL navigation and an integrated directory picker powered by fzf.
- **Tmux Navigator** — Seamless pane navigation between Neovim and tmux using `Ctrl+hjkl`.

## Requirements

This configuration requires **Neovim >= 0.11.2**.
Default package managers (like `apt`) often install outdated versions (e.g., 0.9.x), which will cause errors.

## Install Latest Neovim

The reliable way to get the latest stable release is using the prebuilt tarball (works on bare metal, WSL, and Docker):

```bash
# 1. Remove old version if installed via apt
sudo apt remove neovim -y

# 2. Download and extract the tarball
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo tar xzf nvim-linux-x86_64.tar.gz -C /usr/local --strip-components=1
rm nvim-linux-x86_64.tar.gz

# 3. Verify version
nvim --version
```

## Credits
Core structure powered by [LazyVim](https://github.com/LazyVim/LazyVim). Refer to the official [documentation](https://lazyvim.github.io/installation) for upstream details.
