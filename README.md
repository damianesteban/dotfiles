# Dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/). macOS (Apple Silicon).

## What's Included

| File/Directory | Description |
|---|---|
| `Brewfile` | Homebrew packages, casks, fonts, VS Code extensions |
| `dot_zshrc` | Zsh configuration (starship, zplug, aliases, PATH) |
| `dot_zshenv` | Zsh environment (Cargo) |
| `dot_gitconfig` | Git configuration (diff-so-fancy, auto push remote) |
| `dot_config/starship.toml` | Starship prompt theme (Gruvbox Dark) |
| `dot_config/nvim/` | Neovim configuration (Lazy.nvim) |
| `dot_config/gh/` | GitHub CLI configuration |
| `dot_config/raycast/` | Raycast extensions and settings |
| `damianesteban.code-profile` | VS Code Insiders profile (export) |
| `cursor/` | Cursor editor settings and extensions |
| `scripts/executable_bootstrap.sh` | New machine bootstrap script |

## Bootstrap a New Machine

```bash
# 1. Clone the dotfiles repo
git clone https://github.com/damianesteban/dotfiles.git ~/.dotfiles

# 2. Run the bootstrap script
~/.dotfiles/scripts/executable_bootstrap.sh
```

The bootstrap script will:

1. Install Xcode Command Line Tools
2. Install Homebrew
3. Install all packages from the Brewfile
4. Set up chezmoi and apply dotfiles
5. Set zsh as default shell
6. Install zplug, Rust, and atuin
7. Install Cursor extensions
8. Install oh-my-tmux

After bootstrap, open a new terminal and run `zplug install`.

## Keeping It Up to Date

### Update the Brewfile

```bash
# Dump current Homebrew state to the dotfiles Brewfile
brew bundle dump --file=~/.dotfiles/Brewfile --force
```

### Update shell configs

```bash
# Copy live configs into dotfiles (chezmoi source names)
cp ~/.zshrc ~/.dotfiles/dot_zshrc
cp ~/.zshenv ~/.dotfiles/dot_zshenv
cp ~/.gitconfig ~/.dotfiles/dot_gitconfig
```

### Update Cursor settings

```bash
# Copy Cursor profile settings
cp ~/Library/Application\ Support/Cursor/User/profiles/-4259e43e/settings.json \
   ~/.dotfiles/cursor/profile-settings.json

# Export Cursor extensions list
jq -r '.[].identifier.id' \
  ~/Library/Application\ Support/Cursor/User/profiles/-4259e43e/extensions.json \
  | sort > ~/.dotfiles/cursor/profile-extensions.txt

# Copy Cursor default settings (non-profile)
cp ~/Library/Application\ Support/Cursor/User/settings.json \
   ~/.dotfiles/cursor/default-settings.json
```

### Update VS Code Insiders profile

Export from VS Code: **Profiles > Export Profile** and save to `~/.dotfiles/damianesteban.code-profile`.

### Update starship / nvim / other configs

```bash
cp ~/.config/starship.toml ~/.dotfiles/dot_config/starship.toml
# nvim is a git submodule -- update in place or copy
```

### Apply dotfiles with chezmoi

```bash
# Preview what chezmoi would change
chezmoi diff

# Apply changes from dotfiles to home directory
chezmoi apply -v

# Or go the other direction -- pull live changes into source
chezmoi re-add
```

### Commit and push

```bash
cd ~/.dotfiles
git add -A
git commit -m "update dotfiles"
git push
```

### Quick one-liner to sync everything

```bash
cd ~/.dotfiles && \
  brew bundle dump --file=Brewfile --force && \
  cp ~/.zshrc dot_zshrc && \
  cp ~/.zshenv dot_zshenv && \
  cp ~/.gitconfig dot_gitconfig && \
  cp ~/.config/starship.toml dot_config/starship.toml && \
  cp ~/Library/Application\ Support/Cursor/User/profiles/-4259e43e/settings.json cursor/profile-settings.json && \
  jq -r '.[].identifier.id' ~/Library/Application\ Support/Cursor/User/profiles/-4259e43e/extensions.json | sort > cursor/profile-extensions.txt && \
  cp ~/Library/Application\ Support/Cursor/User/settings.json cursor/default-settings.json && \
  git add -A && git commit -m "sync dotfiles $(date +%Y-%m-%d)" && git push
```

## Tools & Stack

- **Shell**: zsh + starship + zplug + atuin (shell history sync)
- **Editor**: Cursor (primary), VS Code Insiders, Neovim, Zed
- **Terminal**: Warp + tmux (oh-my-tmux)
- **Git**: diff-so-fancy, GitLens, gh CLI
- **Languages**: TypeScript/Node (pnpm, bun, deno), Rust, Go, Python (pyenv, pipx), Ruby (rbenv), Haskell (ghcup)
- **Databases**: PostgreSQL 16/17, Redis, Supabase, DuckDB, SQLite, Turso
- **Containers**: OrbStack (Docker), Skaffold
- **AI**: Ollama, OpenAI Whisper, OpenCode, Claude Code
- **macOS**: Raycast, Keyboard Maestro, Bartender, Setapp, Karabiner-Elements
