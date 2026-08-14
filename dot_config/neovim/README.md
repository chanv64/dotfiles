# Neovim Config

Custom Neovim configuration using [lazy.nvim](https://github.com/folke/lazy.nvim)
as the plugin manager, with [mason.nvim](https://github.com/williamboman/mason.nvim)
for LSP/linter/formatter tooling.

## Contents

- `init.lua` — entrypoint; loads core options/keymaps and bootstraps lazy.nvim
- `lua/core/` — options, keymaps, snippets
- `lua/plugins/` — one file per plugin group
- `lazy-lock.json` — pinned plugin versions

## Installation

### Automated (recommended)

Run the setup script from this repo's `bin/` folder. It detects your OS and
installs the required packages (`git`, `neovim`, `npm`, `yarn`), clones the
dotfiles repo, symlinks the config into `~/.config/nvim`, and pre-installs the
plugins:

```sh
git clone https://github.com/chanv64/dotfiles.git
bash dotfiles/bin/executable_nvim_setup.sh
```

Or, if you use chezmoi: `chezmoi apply`, then run `~/bin/nvim_setup.sh`.

Supported package managers: `pacman` (Arch/CachyOS/Manjaro/EndeavourOS),
`apt` (Debian/Ubuntu), `dnf` (Fedora), `zypper` (openSUSE), `brew` (macOS).

### Manual

1. Install `neovim`, `npm`, `yarn` using your system package manager.
2. Symlink the config:

   ```sh
   ln -sfn "$PWD/dot_config/neovim" ~/.config/nvim
   ```

3. Open `nvim` — lazy.nvim installs itself and all plugins on first run.

## Notes

- The `avante` plugin expects `OPENAI_API_KEY` (or the provider's key) to be
  set as an environment variable; see `lua/plugins/avante.lua`.
- A Nerd Font is recommended for proper icon rendering.
