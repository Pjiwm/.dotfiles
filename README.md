My dotfiles for Unix like machines. (Mac/linux)
Has been used on Pop!_OS 22.04 and macOS Sequoia.

# Installation

Clone the repository
```bash
git clone git@github.com:Pjiwm/.dotfiles.git
cd .dotfiles
```

# Setup

## Universal installations

Submodules
```bash
git submodule update --init --recursive
```

Install cargo
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Install Starship
```bash
curl -sS https://starship.rs/install.sh | sh
```

or using cargo
```bash
cargo install starship --locked
```

## POP_OS! with i3

### Dependencies

required packages
```bash
sudo apt install stow picom polybar rofi tmux i3 build-essentials ripgrep
```

Install Alacritty using cargo
```bash
cargo install alacritty
```

Install neovim
```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage && chmod u+x nvim.appimage && sudo mv nvim.appimage /usr/local/bin/nvim
```

### Stow (zsh)
```bash
stow alacritty backgrounds gitconfig gtk2 gtk3 gtk4 i3wm nvim picom polybar rofi starship themes tmux zshrc
```

### Stow (bash)
```bash
stow alacritty backgrounds bashrc gitconfig gtk2 gtk3 gtk4 i3wm nvim picom polybar rofi starship themes tmux 
```

## macOS

### Dependencies

required packages
```bash
brew install tmux neovim ripgrep
```

Install Alacritty cask
```bash
brew install --cask alacritty
```

### Stow 
```bash
stow nvim tmux starship zshrc alacritty
```

# Font
Nerd font used is [JetBrains Mono](https://www.jetbrains.com/lp/mono/)

