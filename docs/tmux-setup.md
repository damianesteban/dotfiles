# tmux on macOS — Install & Setup

## 1. Install tmux

```bash
brew install tmux reattach-to-user-namespace
```

`reattach-to-user-namespace` enables clipboard integration between tmux and macOS.

## 2. Install Oh My Tmux

```bash
git clone https://github.com/gpakosz/.tmux.git ~/.local/share/tmux/oh-my-tmux
```

## 3. Link the configs

```bash
mkdir -p ~/.config/tmux
ln -sf ~/.local/share/tmux/oh-my-tmux/.tmux.conf ~/.config/tmux/tmux.conf
```

## 4. Clone the dotfiles and apply the local overrides

```bash
git clone https://github.com/damianesteban/dotfiles.git ~/.dotfiles
cp ~/.dotfiles/dot_config/tmux/tmux.conf.local ~/.config/tmux/tmux.conf.local
```

## 5. Launch

```bash
tmux new -s main
```

You should see the Oh My Tmux status bar with a dark theme, session name, uptime, battery, time, and user@host.

## One-liner

```bash
brew install tmux reattach-to-user-namespace && \
  git clone https://github.com/gpakosz/.tmux.git ~/.local/share/tmux/oh-my-tmux && \
  git clone https://github.com/damianesteban/dotfiles.git ~/.dotfiles && \
  mkdir -p ~/.config/tmux && \
  ln -sf ~/.local/share/tmux/oh-my-tmux/.tmux.conf ~/.config/tmux/tmux.conf && \
  cp ~/.dotfiles/dot_config/tmux/tmux.conf.local ~/.config/tmux/tmux.conf.local
```

## Key bindings

| Binding        | Action              |
| -------------- | ------------------- |
| `Ctrl-b`       | Prefix key          |
| `<prefix> + m` | Toggle mouse on/off |
| `<prefix> + "` | Split horizontal    |
| `<prefix> + %` | Split vertical      |
| `<prefix> + c` | New window          |
| `<prefix> + d` | Detach session      |
| `<prefix> + t` | Show clock (24h)    |
