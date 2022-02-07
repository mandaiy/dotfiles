## Dependency

Prerequisites: [brew](brew) for both macOS and Linux

| Dependency        | Note |
|-------------------|------|
| bat               |      |
| fd                | Better find |
| fish              |      |
| [fisher](fisher)  | Plugin manager for fish |
| fzf               | Fuzzy search |
| neovim            |      |
| ripgrep           |      |
| tmux              |      |

[brew]:https://brew.sh/index
[fisher]:https://github.com/jorgebucaran/fisher

```sh
> brew install bat fd fish fzf neovim ripgrep tmux
> curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
```

### fish in remote hosts
It is safe to not change the login shell to `fish` in remote hosts (machines to be SSH'ed)
because sometimes SSH does not work well when connecting to `fish`-`chsh`ed machines.

To use `fish` as if it were a login shell, write the following line at the top of `.bashrc`:
```
case $- in
  *i*) exec $PATH_TO_FISH_SHELL;;
esac
```

### tmux
``init`` script installs ``tpm`` (tmux plugin manager) into ``tmux/plugins``.
Then reload ``.tmux.conf`` (``bind + shift + I`` in tmux) and the plugins specified in ``.tmux.conf`` will be installed.

