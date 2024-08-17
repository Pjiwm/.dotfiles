#!/bin/bash

# Check if running on macOS or Linux
OS="$(uname -s)"
case "$OS" in
  Darwin) OS="macOS" ;;
  Linux) OS="linux" ;;
  *) echo "Unsupported OS: $OS" && exit 1 ;;
esac

# Function to install Starship
install_starship() {
  echo "Installing Starship..."
  curl -sS https://starship.rs/install.sh | sh
}

# Function to install Neovim
install_neovim() {
  echo "Installing Neovim..."

  if [[ "$OS" == "macOS" ]]; then
    brew install neovim
  elif [[ "$OS" == "linux" ]]; then
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    sudo mv nvim.appimage /usr/local/bin/nvim
  fi
}

# Function to install Tmux
install_tmux() {
  echo "Installing Tmux..."

  if [[ "$OS" == "macOS" ]]; then
    brew install tmux
  elif [[ "$OS" == "linux" ]]; then
    curl -LO https://github.com/tmux/tmux/releases/download/3.3a/tmux-3.3a.tar.gz
    tar -xvzf tmux-3.3a.tar.gz
    cd tmux-3.3a
    ./configure && make
    sudo make install
    cd ..
    rm -rf tmux-3.3a tmux-3.3a.tar.gz
  fi
}

# Execute installation functions
install_starship
install_neovim
install_tmux

echo "Installation completed!"
