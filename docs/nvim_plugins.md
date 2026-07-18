# Neovim Plugins

This document lists the plugins configured in `nvim/lua/plugins.lua`.

## Appearance and UI

| Plugin | Purpose | Loading condition and key bindings |
| --- | --- | --- |
| [`folke/tokyonight.nvim`](https://github.com/folke/tokyonight.nvim) | Color scheme | Loaded at startup with the highest priority |
| [`nvim-tree/nvim-web-devicons`](https://github.com/nvim-tree/nvim-web-devicons) | Displays icons for file types and other items | Loaded normally |
| [`RRethy/vim-illuminate`](https://github.com/RRethy/vim-illuminate) | Highlights the word under the cursor and its references | Loaded normally |
| [`nvim-mini/mini.indentscope`](https://github.com/nvim-mini/mini.indentscope) | Displays the current indent scope | Loaded normally |
| [`folke/noice.nvim`](https://github.com/folke/noice.nvim) | Enhances messages, the command line, and the LSP UI | Loaded on the `VeryLazy` event |

## Editing and Productivity

| Plugin | Purpose | Loading condition and key bindings |
| --- | --- | --- |
| [`keaising/im-select.nvim`](https://github.com/keaising/im-select.nvim) | Disables the IME when leaving Insert mode | Loaded normally |
| [`jpalardy/vim-slime`](https://github.com/jpalardy/vim-slime) | Sends buffer content to a REPL running in tmux | `<Leader>ip` sends the current IPython cell |
| [`editorconfig/editorconfig-vim`](https://github.com/editorconfig/editorconfig-vim) | Applies EditorConfig settings | Loaded normally |
| [`tpope/vim-commentary`](https://github.com/tpope/vim-commentary) | Comments and uncomments code | Loaded normally |
| [`ntpeters/vim-better-whitespace`](https://github.com/ntpeters/vim-better-whitespace) | Detects and removes unwanted whitespace | Removes trailing whitespace when saving |
| [`nvim-mini/mini.surround`](https://github.com/nvim-mini/mini.surround) | Adds operations for surrounding text with brackets, quotes, and similar characters | Loaded normally |
| [`kamykn/spelunker.vim`](https://github.com/kamykn/spelunker.vim) | Provides real-time spell checking | Loaded normally |

## Navigation and Search

| Plugin | Purpose | Loading condition and key bindings |
| --- | --- | --- |
| [`nvim-mini/mini.files`](https://github.com/nvim-mini/mini.files) | File explorer | `<Leader>b` opens the current file's directory |
| [`stevearc/aerial.nvim`](https://github.com/stevearc/aerial.nvim) | Displays a code symbol outline | `<Leader>go` toggles the outline on the left |
| [`nvim-telescope/telescope.nvim`](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder for files, text, and other items | Loaded by `<Leader>ff`, `<Leader>fr`, `<Leader>fb`, and related mappings |
| [`nvim-telescope/telescope-file-browser.nvim`](https://github.com/nvim-telescope/telescope-file-browser.nvim) | Adds a file browser to Telescope | Loaded by `<Leader>fe` |

## Git

| Plugin | Purpose | Loading condition and key bindings |
| --- | --- | --- |
| [`nvim-mini/mini.diff`](https://github.com/nvim-mini/mini.diff) | Displays differences in the buffer | The diff source is disabled by default |
| [`sindrets/diffview.nvim`](https://github.com/sindrets/diffview.nvim) | Displays Git diffs and file history | Loaded by `DiffviewOpen` or `DiffviewFileHistory` |
| [`lewis6991/gitsigns.nvim`](https://github.com/lewis6991/gitsigns.nvim) | Displays Git changes, hunks, and blame information in buffers | Loaded when opening a buffer; operated with `<Leader>d` mappings |
| [`almo7aya/openingh.nvim`](https://github.com/almo7aya/openingh.nvim) | Opens GitHub repositories and files in a browser | Loaded by commands such as `OpenInGHFile` |

## Completion and LSP

| Plugin | Purpose | Loading condition and key bindings |
| --- | --- | --- |
| [`hrsh7th/nvim-cmp`](https://github.com/hrsh7th/nvim-cmp) | Provides completion from LSP, buffers, paths, and other sources | Loaded on the `InsertEnter` event |
| [`neovim/nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig) | Configures language servers | Loaded when opening a buffer and enables available language servers |
| [`aznhe21/actions-preview.nvim`](https://github.com/aznhe21/actions-preview.nvim) | Previews LSP code actions | Loaded by `<Leader>gf` |
| [`kosayoda/nvim-lightbulb`](https://github.com/kosayoda/nvim-lightbulb) | Indicates when code actions are available | Loaded on the `LspAttach` event |

## AI Assistance

| Plugin | Purpose | Loading condition and key bindings |
| --- | --- | --- |
| [`coder/claudecode.nvim`](https://github.com/coder/claudecode.nvim) | Controls Claude Code from Neovim | Operated with `<Leader>a` mappings |

## Language and Syntax Support

| Plugin | Purpose | Loading condition and key bindings |
| --- | --- | --- |
| [`gbakes/dbt-forge.nvim`](https://github.com/gbakes/dbt-forge.nvim) | Supports working with dbt projects | Loaded for SQL files |
| [`nvim-treesitter/nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter) | Provides syntax parsing and highlighting | Loaded at startup; runs `TSUpdate` when updated |
| [`windwp/nvim-ts-autotag`](https://github.com/windwp/nvim-ts-autotag) | Automatically adds and updates closing tags in HTML, JSX, and similar formats | Loaded on `InsertEnter` for supported file types |

## Utilities

| Plugin | Purpose | Loading condition and key bindings |
| --- | --- | --- |
| [`nvim-lua/plenary.nvim`](https://github.com/nvim-lua/plenary.nvim) | Lua utilities for Neovim plugins | Loaded normally |
