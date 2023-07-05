# Migration from VimL to Lua

This document describes how to migrate from VimL (i.e., `init.vim`) to Lua (i.e., `init.lua`).


## VimL to Lua

### Options

Basically this can be done in a mechanical way.

```
" VimL
set foo
set bar=1
set nobaz

-- Lua
vim.opt.foo = true
vim.opt.bar = 1
vim.opt.baz = false
```

### autocmd, augroup

To create autocmd, use `vim.api.nvim_create_autocmd`.
It is not needed to surround this by `augroup` because in neovim the `autocmd!` statement is enabled by default (i.e., idempotent).

### Keymaps

Use `vim.keymap.set`.
`vim.api.nvim_set_keymap` and `vim.api.nvim_buf_set_keymap` don't have to be used (they are API and `keymap.set` is a wrapper for them).

* https://www.reddit.com/r/neovim/comments/uuh8xw/noob_vimkeymapset_vs_vimapinvim_set_keymap_key/


For keymaps with complicated commands, use an anonymous function with `{ expr = true }` option.

* https://www.reddit.com/r/neovim/comments/vty0ov/neovim_how_to_rexecute_vimfnexpand_every_time_a/

### vim.cmd

Some features which can be used in VimL are still missing in neovim Lua API.
In such cases, you can execute any VimL based commands with `vim.cmd`.
There is also `vim.api.nvim_command` with which you can do the same, however, you don't have to use this API.
Use `vim.cmd` wrapper.

* https://vi.stackexchange.com/questions/38722/are-vim-cmd-and-vim-api-nvim-command-the-same-if-not-what-are-the-differen

## Plugin manager

I also have migrated from `dein.vim` to `packer.nvim`.
Honestly I don't have any preference at all for plugin managers, but since I've decided to fully rewrite VimL based settings to Lua based settings,
I also wanted to migrate from `dein.vim`, which is VimL based I think, to `packer.nvim` which is Lua based and the most-starred package manager (citation-needed).
