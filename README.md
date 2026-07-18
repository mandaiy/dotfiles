## Setup

### Install [homebrew][brew]

### Install fish and other dependencies via homebrew


| Dependency        | Note |
|-------------------|------|
| bat               |      |
| fd                | Better find |
| fish              |      |
| [fisher][fisher]  | Plugin manager for fish |
| fzf               | Fuzzy search |
| neovim            |      |
| ripgrep           |      |
| tree-sitter-cli   | Required by `nvim-treesitter` main branch |
| herdr             |      |
| [macOS Input Source Manager][macism] | |


```
$ /opt/homebrew/bin/brew install bat fd fish fzf neovim ripgrep tree-sitter-cli herdr  # macOS
```

If you use the `nvim-treesitter` `main` branch, install `tree-sitter-cli` as well.

### Change login shell

a) On macOS, change login shell to fish in Settings. On Ubuntu, use chsh.

b) exec fish shel in the default shell. See below.

#### fish in remote hosts
It is safe to not change the login shell to `fish` in remote hosts (machines to be SSH'ed)
because sometimes SSH does not work well when connecting to `fish`-`chsh`ed machines.

To use `fish` as if it were a login shell, write the following line at the top of `.bashrc`:
```
case $- in
  *i*) exec $PATH_TO_FISH_SHELL;;
esac
```

### Execute `init` script

```
> ./init
```

### Install [fisher][fisher]

```
> curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
```

[brew]:https://brew.sh/index
[fisher]:https://github.com/jorgebucaran/fisher
[macism]:https://github.com/laishulu/macism

### Setup Neovim

Create a dedicated Python virtual environment for Neovim and install the Python
provider package after running `./init`:

```sh
NVIM_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
python3 -m venv "$NVIM_CONFIG_HOME/venv"
"$NVIM_CONFIG_HOME/venv/bin/python" -m pip install --upgrade pip pynvim
```

With this repository Neovim automatically uses `$XDG_CONFIG_HOME/nvim/venv/bin/python` when the
virtual environment exists. To use a Python interpreter in another location,
set `NVIM_PYTHON_PATH` to its executable path instead. In that case, make sure
`pynvim` is installed for that interpreter.

Run `:checkhealth provider` in Neovim to verify the setup.

#### Restore Neovim plugins

The `./init` script links the version-controlled `nvim/lazy-lock.json` to
`$XDG_CONFIG_HOME/nvim/lazy-lock.json`. After setting up a new machine, start
Neovim and restore the plugin revisions recorded in the lockfile:

```vim
:Lazy restore
```

If `$XDG_CONFIG_HOME/nvim/lazy-lock.json` already exists as a regular file,
move or remove it before running `./init` so that the script can create the
symlink.

To update plugins intentionally, run `:Lazy update`, review the resulting
`nvim/lazy-lock.json` changes, and commit the lockfile together with any related
plugin configuration changes.

### Environment Variables

| Variable | Description |
|----------|-------------|
| `NVIM_PYTHON_PATH` | Path to Python interpreter to be used in neovim |

### fonts

This repository uses HackGen35 Console font.
Download it via homebrew:
```
$ brew install font-hackgen font-hackgen-nerd
```
