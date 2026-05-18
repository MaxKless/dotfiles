#!/usr/bin/env bash
# Symlink dotfiles into $HOME. Re-runnable; backs up any existing real files.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILES=(.zshrc .zprofile .zshenv .profile .gitconfig .yarnrc.yml)
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d%H%M%S)"

# .zshrc points ZSH_CUSTOM at $HOME/dotfiles — warn if the repo lives elsewhere.
if [ "$DOTFILES_DIR" != "$HOME/dotfiles" ]; then
  echo "warning: repo is at $DOTFILES_DIR but .zshrc expects $HOME/dotfiles"
  echo "         clone/move it to ~/dotfiles or edit ZSH_CUSTOM in .zshrc"
fi

for f in "${FILES[@]}"; do
  src="$DOTFILES_DIR/$f"
  target="$HOME/$f"
  if [ -L "$target" ]; then
    rm "$target"
  elif [ -e "$target" ]; then
    mkdir -p "$BACKUP_DIR"
    mv "$target" "$BACKUP_DIR/"
    echo "backed up existing $f -> $BACKUP_DIR/"
  fi
  ln -s "$src" "$target"
  echo "linked  $f"
done

# .npmrc holds secrets, so it is not symlinked — copy the template once.
if [ ! -e "$HOME/.npmrc" ]; then
  cp "$DOTFILES_DIR/.npmrc.template" "$HOME/.npmrc"
  echo "created ~/.npmrc from template — set NPM_TOKEN in your env"
fi

echo
echo "done. next steps:"
echo "  - install oh-my-zsh if missing: https://ohmyz.sh"
echo "  - install mise:                 https://mise.jdx.dev"
echo "  - restart your shell"
echo "  - YubiKey commit signing:       see SETUP.md"
