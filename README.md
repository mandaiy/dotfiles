## How to install
Run ``./init`` and the dotfiles in this directory are symlinked to the home directory.

### nvim
Install via ``appimage`` if your system package repository does not have nvim.

It requires ``python`` > 3.6.
Use ``pyenv`` if the system has an older version.

### tmux
``tpm`` (tmux plugin manager) will be installed into ``$HOME/.tmux/plugins`` at the time that ``./init`` is executed.
Then reload ``.tmux.conf`` (``bind + shift + I`` in tmux) and the plugins specified in ``.tmux.conf`` will be installed.

#### copy in tmux
By dragging with pressing ``shift`` (Ubuntu) or ``option`` (macOS), you can select texts in your system (not in tmux).

## Dependency

| Dependency        | macOS | Ubuntu 18.04                                                                       | Note |
|-------------------|-------|------------------------------------------------------------------------------------|------|
| fish              | brew  | ppa:fish-shell/release-3                                                           |      |
| [fisher](fisher)  | --->  | curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish | Plugin manager for fish |
| neovim            | brew  |                                                                                    |      |
| fzf               | brew  | https://github.com/junegunn/fzf/releases                                           | Fuzzy search |
| fd                | brew  | https://github.com/sharkdp/fd/releases                                             | Better find |
| bat               | brew  | https://github.com/sharkdp/bat/releases                                            |      |
| ripgrep           | brew  | https://github.com/BurntSushi/ripgrep/releases                                     |      |

[fisher]:https://github.com/jorgebucaran/fisher
