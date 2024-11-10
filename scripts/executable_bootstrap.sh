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

# Set default shell to zsh if it isn't already
if [ "$SHELL" != "/bin/zsh" ]; then
  echo "Changing default shell to zsh..."
  chsh -s /bin/zsh
  echo "Default shell set to zsh. You may need to log out and log back in for the change to take effect."
fi
