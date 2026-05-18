# ~/.zshrc — managed in github.com/MaxKless/dotfiles

# --- oh-my-zsh -------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
# Custom aliases/functions live in this repo (aliases-*.zsh auto-loaded by OMZ).
ZSH_CUSTOM="$HOME/dotfiles/oh-my-zsh"
plugins=(git)
source "$ZSH/oh-my-zsh.sh"

# --- PATH ------------------------------------------------------------------
# ~/.local/bin holds mise + pipx-installed tools. Other tools (homebrew, etc.)
# add themselves to PATH via .zprofile or their own installers.
export PATH="$HOME/.local/bin:$PATH"

# --- aliases ---------------------------------------------------------------
alias poly=polygraph

# --- mise ------------------------------------------------------------------
# Single version manager for node, java, go, rust, dotnet, maven, etc.
# Replaces the old hand-rolled nvm setup.
eval "$(mise activate zsh)"
