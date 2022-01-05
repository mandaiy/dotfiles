## Dependency

| Dependency        | macOS | Ubuntu 18.04                                                                       | Note |
|-------------------|-------|------------------------------------------------------------------------------------|------|
| [brew](brew)      | brew  | -                                                                                  |      |
| fish              | brew  | ppa:fish-shell/release-3                                                           |      |
| [fisher](fisher)  | --->  | curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish | Plugin manager for fish |
| neovim            | brew  | https://github.com/neovim/neovim/releases                                          |      |
| fzf               | brew  | https://github.com/junegunn/fzf/releases                                           | Fuzzy search |
| fd                | brew  | https://github.com/sharkdp/fd/releases                                             | Better find |
| bat               | brew  | https://github.com/sharkdp/bat/releases                                            |      |
| ripgrep           | brew  | https://github.com/BurntSushi/ripgrep/releases                                     |      |
| tmux              | brew  | apt                                                                                |      |

[brew]:https://brew.sh/index
[fisher]:https://github.com/jorgebucaran/fisher

For macOS,
```sh
> brew install fish fzf fd bat ripgrep neovim tmux
> curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
```

### tmux
``init`` script installs ``tpm`` (tmux plugin manager) into ``tmux/plugins``.
Then reload ``.tmux.conf`` (``bind + shift + I`` in tmux) and the plugins specified in ``.tmux.conf`` will be installed.

