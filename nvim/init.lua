vim.scriptencoding = "utf-8"

-- https://stackoverflow.com/a/73370407
vim.cmd([[highlight MatchParen ctermfg=white ctermbg=red]])
vim.cmd([[highlight SpellBad cterm=bold,italic]])
vim.cmd([[highlight Normal ctermbg=NONE]])
vim.cmd([[highlight NonText ctermbg=NONE]])
vim.cmd([[highlight TablineSel ctermbg=NONE]])
vim.cmd([[highlight LineNr ctermbg=NONE]])
vim.cmd([[highlight CursorLineNr ctermbg=NONE]])

-- Syntax highlight syncing from start unless 200 lines.
vim.api.nvim_create_autocmd("BufEnter", {
   pattern = { "*" },
   command = ":syntax sync maxlines=200",
})
-- Don't auto commenting new lines
vim.api.nvim_create_autocmd("BufEnter", {
   pattern = "*",
   command = "set fo-=c fo-=r fo-=o",
})
-- Remembers the cursor's position.
vim.api.nvim_create_autocmd("BufReadPost", {
   pattern = { "*" },
   callback = function()
      if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
         vim.cmd([[normal! g`"]])
      end
   end,
})

-- filetype settings for specific files
vim.api.nvim_create_autocmd("BufNewFile,BufRead", {
   pattern = { "CMakeLists.txt" },
   command = [[setlocal filetype=cmake]],
})
vim.api.nvim_create_autocmd("BufNewFile,BufRead", {
   pattern = { "*.rb,*.rbw,*.gemspec,Vagrantfile" },
   command = [[setlocal filetype=ruby]],
})

-- FileType specific settings
vim.api.nvim_create_autocmd("FileType", {
   pattern = { "go" },
   command = [[setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4]],
})
vim.api.nvim_create_autocmd("FileType", {
   pattern = { "lua" },
   command = [[setlocal expandtab shiftwidth=3 tabstop=3 softtabstop=3]],
})
vim.api.nvim_create_autocmd("FileType", {
   pattern = { "python" },
   command = [[
        setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4 colorcolumn=79
        setlocal formatoptions+=croq
        setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class,with
    ]],
})
vim.api.nvim_create_autocmd("FileType", {
   pattern = { "ruby" },
   callback = function()
      vim.cmd([[setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2]])
      vim.g.rubycomplete_buffer_loading = 1
      vim.g.rubycomplete_classes_in_global = 1
      vim.g.rubycomplete_rails = 1
   end,
})
vim.api.nvim_create_autocmd("FileType", {
   pattern = { "sh,zsh" },
   command = [[setlocal noexpandtab]],
})
vim.api.nvim_create_autocmd("FileType", {
   pattern = { "tex" },
   callback = function()
      vim.g.tex_flavor = "latex"
   end,
})
vim.api.nvim_create_autocmd("FileType", {
   pattern = { "yaml" },
   command = [[setlocal shiftwidth=2 tabstop=2 softtabstop=2]],
})

vim.opt.autoindent = true
vim.opt.autoread = true -- Enable vim to reload a file when the file is modified.
vim.opt.backspace = "start,eol,indent" -- Enable to erase/concat lines/delete with backspace key.
vim.opt.backup = false
vim.opt.backupcopy = "no"
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 2 -- Give more space for displaying messages.
vim.opt.colorcolumn = "121"
vim.opt.cursorline = true
vim.opt.errorbells = false
vim.opt.expandtab = true
vim.opt.fileencodings = "utf-8,iso-2022-jp,euc-jp,sjis"
vim.opt.fileformats = "unix,dos,mac"
vim.opt.hidden = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.inccommand = "split"
vim.opt.incsearch = true
vim.opt.laststatus = 2
vim.opt.list = true
vim.opt.matchpairs:append("<:>") -- Don't pass messages to |ins-completion-menu|.
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.shiftwidth = 4
vim.opt.shortmess:append("c") -- Don't pass messages to |ins-completion-menu|.
vim.opt.showcmd = true
vim.opt.showmode = false
vim.opt.showtabline = 2
vim.opt.signcolumn = "yes" -- Always show the signcolumn.
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.spelllang = "en,cjk"
vim.opt.splitbelow = true -- Open a window below the current one.
vim.opt.swapfile = true
vim.opt.tabstop = 4
vim.opt.termguicolors = true -- Truecolor
vim.opt.ttimeoutlen = 1 -- Timeout msec for key code sequences.
vim.opt.updatetime = 200
vim.opt.wildmenu = true
vim.opt.wildmode = "list:full" -- Command completion
vim.opt.wrap = false
vim.opt.writebackup = false

-- %<: truncation position
-- %n: buffer number, %m: modified?
-- %r: RO?, %h: help buffer?
-- %w: preview window?
-- Show fenc and ff.
-- Show the full path or file name.
-- %y: file type
-- Separator of left-side and right-side.
vim.opt.statusline = "%<[%n]%m%r%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'} %F %y%=%1l %L,%c%V %P"

-- Abbreviations for common misspelling commands.
vim.cmd([[cnoreabbrev W! w!]])
vim.cmd([[cnoreabbrev Q! q!]])
vim.cmd([[cnoreabbrev Qall! qall!]])
vim.cmd([[cnoreabbrev Wq wq]])
vim.cmd([[cnoreabbrev Wa wa]])
vim.cmd([[cnoreabbrev wQ wq]])
vim.cmd([[cnoreabbrev WQ wq]])
vim.cmd([[cnoreabbrev W w]])
vim.cmd([[cnoreabbrev Q q]])
vim.cmd([[cnoreabbrev Qall qall]])

vim.g.mapleader = " "

-- Leave Terminal-insert mode.
vim.keymap.set("t", "<Leader>\\", "<C-\\><C-n>", { silent = true })
-- Open terminal
vim.keymap.set("n", "<Leader>sh", ":tabnew +terminal<CR>", { silent = true })
-- Change the working directory to current file's directory.
vim.keymap.set("n", "<Leader>cd", ":lcd %:p:h<CR>", { silent = true })
--" Prev buffer
vim.keymap.set("n", "<Leader>bp", ":bp<cr>", { silent = true })
--" Next buffer
vim.keymap.set("n", "<Leader>bn", ":bn<cr>", { silent = true })
--" Close buffer
vim.keymap.set("n", "<Leader>bd", ":bd<CR>", { silent = true })

---- move by displaylines
vim.keymap.set("n", "j", "gj", { silent = true })
vim.keymap.set("n", "k", "gk", { silent = true })

-- Search mappings:
-- These enable VIM to display the one in a search at the center of the screen.
vim.keymap.set("n", "n", "nzzzv", { silent = true })
vim.keymap.set("n", "N", "Nzzzv", { silent = true })

vim.keymap.set("", "Q", "<Nop>", { silent = true })
vim.keymap.set("", "ZZ", "<Nop>", { silent = true })
vim.keymap.set("", "ZQ", "<Nop>", { silent = true })

-- Clear highlights
vim.keymap.set("n", "<C-l>", ":nohlsearch<CR>", { silent = true })

-- Tabs
vim.keymap.set("n", "<Tab>", "gt", { silent = true })
vim.keymap.set("n", "<S-Tab>", "gT", { silent = true })
vim.keymap.set("n", "<S-t>", ":tabnew<CR>", { silent = true })

---- Vmap for maintain Visual Mode after shifting > and <
vim.keymap.set("v", "<", "<gv", { silent = true })
vim.keymap.set("v", ">", ">gv", { silent = true })

---- Move visual block
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

---- Emacs like cursor move in insert mode
vim.keymap.set("i", "<C-p>", "<Up>", { silent = true })
vim.keymap.set("i", "<C-n>", "<Down>", { silent = true })
vim.keymap.set("i", "<C-b>", "<Left>", { silent = true })
vim.keymap.set("i", "<C-f>", "<Right>", { silent = true })
vim.keymap.set("i", "<C-a>", "<Home>", { silent = true })
vim.keymap.set("i", "<C-e>", "<End>", { silent = true })
vim.keymap.set("i", "<C-d>", "<Del>", { silent = true })
vim.keymap.set("i", "<C-h>", "<BS>", { silent = true })

----" Opens an edit command with the path of the currently edited file filled in
vim.keymap.set("n", "<Leader>e", function()
   return ":e " .. vim.fn.expand("%:p:h") .. "/"
end, { expr = true })

----" Opens a tab edit command with the path of the currently edited file filled
vim.keymap.set("n", "<Leader>tab", function()
   return ":tabedit " .. vim.fn.expand("%:p:h") .. "/"
end, { expr = true })

----" Opens a split command with the path of the currently edited file filled
vim.keymap.set("n", "<Leader>sp", function()
   return ":split " .. vim.fn.expand("%:p:h") .. "/"
end, { expr = true })

----" Opens a vsplit command with the path of the currently edited file filled
vim.keymap.set("n", "<Leader>vs", function()
   return ":vsplit " .. vim.fn.expand("%:p:h") .. "/"
end, { expr = true })

-- Disable python2 support.
vim.g.loaded_python_provider = 0

if vim.fn.isdirectory(vim.env.XDG_CONFIG_HOME .. "/nvim/venv/") then
   vim.g.python3_host_prog = vim.env.XDG_CONFIG_HOME .. "/nvim/venv/bin/python"
   vim.g.black_virtualenv = vim.env.XDG_CONFIG_HOME .. "/nvim/venv"
end

require("plugins")
vim.keymap.set("n", "<Leader>ps", ":PackerSync<CR>", { silent = true })
vim.keymap.set("n", "<Leader>pS", ":PackerStatus<CR>", { silent = true })
