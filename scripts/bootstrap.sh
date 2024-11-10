#!/bin/bash

# Install Homebrew if not already installed
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Set up Homebrew from Brewfile
echo "Installing Homebrew packages from Brewfile..."
brew bundle --file="${HOME}/.dotfiles/Brewfile"

# Install chezmoi and initialize dotfiles
if ! command -v chezmoi &>/dev/null; then
  echo "Installing chezmoi..."
  brew install chezmoi
fi

# Apply chezmoi to set up dotfiles
echo "Applying chezmoi configuration..."
chezmoi init https://github.com/username/dotfiles.git
chezmoi apply -v
