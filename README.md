# 💤 LazyVim Config

My personal configuration built on the [LazyVim Starter Template](https://github.com/LazyVim/LazyVim). This repository tracks my custom plugins, keymaps, and modifications.

## Requirements

This configuration requires **Neovim >= 0.11.2**.
Default package managers (like `apt`) often install outdated versions (e.g., 0.9.x), which will cause errors.

### Install Latest Neovim 

The reliable way to get the latest stable release is using the AppImage:

```bash
# 1. Remove old version if installed via apt
sudo apt remove neovim -y

# 2. Download the latest AppImage
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage

# 3. Make it executable
chmod u+x nvim-linux-x86_64.appimage

# 4. Move it to a global path (renaming to 'nvim')
sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim

# 5. Verify version
nvim --version
```

## Credits
Core structure powered by [LazyVim](https://github.com/LazyVim/LazyVim). Refer to the official [documentation](https://lazyvim.github.io/installation) for upstream details.
