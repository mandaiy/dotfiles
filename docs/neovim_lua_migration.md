##

```
set foo
set bar=1

vim.opt.foo = true
vim.opt.bar = 1
```


To create autocmd, use `vim.api.nvim_create_autocmd`.
It is not needed to surround this by `augroup` because in neovim the `autocmd!` statement is not needed by default.
https://www.reddit.com/r/neovim/comments/vty0ov/neovim_how_to_rexecute_vimfnexpand_every_time_a/

https://www.reddit.com/r/neovim/comments/uuh8xw/noob_vimkeymapset_vs_vimapinvim_set_keymap_key/


https://vi.stackexchange.com/questions/38722/are-vim-cmd-and-vim-api-nvim-command-the-same-if-not-what-are-the-differen
vim.cmd
