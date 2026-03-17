#!/bin/bash
set -e

DOTFILES_DIR="${HOME}/.dotfiles"
DOTFILES_REPO="https://github.com/damianesteban/dotfiles.git"

echo "==> Bootstrapping macOS development environment..."

# Install Xcode Command Line Tools if not already installed
if ! xcode-select -p &>/dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "Press any key after Xcode CLT installation completes..."
  read -n 1
fi

# Install Homebrew if not already installed
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install chezmoi first (needed for dotfile management)
if ! command -v chezmoi &>/dev/null; then
  echo "Installing chezmoi..."
  brew install chezmoi
fi

# Set up Homebrew from Brewfile
echo "Installing Homebrew packages from Brewfile..."
brew bundle --file="${DOTFILES_DIR}/Brewfile" --no-lock

# Apply chezmoi to set up dotfiles
echo "Applying chezmoi configuration..."
chezmoi init "$DOTFILES_REPO"
chezmoi apply -v

# Set default shell to zsh if it isn't already
if [ "$SHELL" != "/bin/zsh" ]; then
  echo "Changing default shell to zsh..."
  chsh -s /bin/zsh
  echo "Default shell set to zsh. Log out and back in for the change to take effect."
fi

# Install zplug if not present
if [ ! -d "${HOME}/.zplug" ]; then
  echo "Installing zplug..."
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

# Install Rust/Cargo if not present
if [ ! -f "${HOME}/.cargo/env" ]; then
  echo "Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# Install atuin if not present
if ! command -v atuin &>/dev/null; then
  echo "Installing atuin..."
  bash <(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh)
fi

# Set up Cursor profile extensions
echo "Installing Cursor profile extensions..."
if command -v cursor &>/dev/null; then
  if [ -f "${DOTFILES_DIR}/cursor/profile-extensions.txt" ]; then
    while IFS= read -r ext; do
      [ -z "$ext" ] && continue
      cursor --install-extension "$ext" 2>/dev/null || true
    done < "${DOTFILES_DIR}/cursor/profile-extensions.txt"
  fi
  # Copy default settings
  CURSOR_SETTINGS_DIR="${HOME}/Library/Application Support/Cursor/User"
  if [ -d "$CURSOR_SETTINGS_DIR" ] && [ -f "${DOTFILES_DIR}/cursor/default-settings.json" ]; then
    cp "${DOTFILES_DIR}/cursor/default-settings.json" "${CURSOR_SETTINGS_DIR}/settings.json"
    echo "Cursor default settings applied."
  fi
fi

# Set up VS Code Insiders profile
echo "Setting up VS Code Insiders..."
if command -v code-insiders &>/dev/null; then
  if [ -f "${DOTFILES_DIR}/damianesteban.code-profile" ]; then
    echo "Import VS Code profile manually: code-insiders > Profiles > Import Profile > select damianesteban.code-profile"
  fi
fi

# Install oh-my-tmux
if [ ! -f "${HOME}/.tmux.conf" ]; then
  echo "Installing oh-my-tmux..."
  git clone https://github.com/gpakosz/.tmux.git "${HOME}/.tmux"
  ln -s -f "${HOME}/.tmux/.tmux.conf" "${HOME}/.tmux.conf"
  cp "${HOME}/.tmux/.tmux.conf.local" "${HOME}/.tmux.conf.local"
fi

echo ""
echo "==> Bootstrap complete!"
echo ""
echo "Next steps:"
echo "  1. Open a new terminal to load zsh config"
echo "  2. Run 'zplug install' to install zsh plugins"
echo "  3. Import VS Code profile: Profiles > Import Profile > damianesteban.code-profile"
echo "  4. Cursor extensions were installed automatically"
echo "  5. Run 'atuin login' and 'atuin sync' to restore shell history"
echo "  6. Set up SSH keys and GPG keys"
