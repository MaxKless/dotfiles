# dotfiles

Personal macOS shell setup.

## Install

```sh
git clone https://github.com/MaxKless/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` symlinks the tracked dotfiles into `$HOME` (backing up any
existing files) and seeds `~/.npmrc` from the template.

Then see [SETUP.md](SETUP.md) for one-time YubiKey commit-signing setup.

### Prerequisites

- [oh-my-zsh](https://ohmyz.sh) — `.zshrc` sources it
- [mise](https://mise.jdx.dev) — single version manager for node, java, go,
  rust, dotnet, maven, etc.
- [Homebrew](https://brew.sh) — `.zprofile` runs `brew shellenv`

## What's here

| File | Purpose |
|------|---------|
| `.zshrc` | oh-my-zsh + `mise activate` + PATH |
| `.zprofile` | Homebrew env |
| `.zshenv` / `.profile` | source `~/.cargo/env` if present |
| `.gitconfig` | user, SSH commit signing (YubiKey — see [SETUP.md](SETUP.md)), github HTTPS rewrite |
| `.yarnrc.yml` | yarn registry config |
| `.npmrc.template` | npm config — copy to `~/.npmrc`, supply `NPM_TOKEN` via env |
| `oh-my-zsh/aliases-*.zsh` | git / nx / branchlister / misc aliases (auto-loaded via `ZSH_CUSTOM`) |
| `branchlister/` | branch list/pick helper scripts |

## Notes

- **mise replaces nvm.** The old `.zshrc` hand-rolled an nvm bootstrap plus
  machine-specific PATH lines (gcloud SDK, Windsurf, Antigravity, opencode,
  Superset). Those were dropped — modern installers re-add their own PATH
  entries, and mise covers the runtimes.
- `~/.npmrc` is **not** symlinked because it holds secrets. Keep the token in
  your environment (`NPM_TOKEN`); npm expands `${NPM_TOKEN}` at read time.
