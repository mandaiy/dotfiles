scriptencoding utf8

set number
set nowrap
set cursorline
set splitbelow
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
set fileformats=unix,dos,mac
set spelllang=en,cjk
set autoread " enable vim to reload a file when the file is modified
set hidden
set expandtab
set tabstop=4 softtabstop=4 shiftwidth=4
set autoindent
set smartindent
set colorcolumn=121
set showtabline=2
set showcmd
set laststatus=2
set noshowmode
set list
set listchars=tab:=-
set mouse=a
set textwidth=0
set formatoptions=q
set hlsearch
set swapfile
set directory=~/.vim/.vimswap
set clipboard=unnamed
set nobackup
set nowritebackup
set backupcopy=no
set backupdir=~/.vim/.vimbackup
set undodir=~/.vim/.vimundo
set backspace=start,eol,indent " enable to erase/concat lines/delete with backspace key
set wildmenu wildmode=list:full " command completion
set matchpairs+=<:>
set updatetime=200
set ignorecase
set smartcase
set wrapscan
set incsearch
set inccommand=split
set ttimeoutlen=1  " timeout msec for ESC key
set noerrorbells visualbell t_vb=  " Disable visualbell
set conceallevel=0 " Disable concealment
set cmdheight=2 " Give more space for displaying messages.
set shortmess+=c  " Don't pass messages to |ins-completion-menu|.
set signcolumn=yes  " Always show the signcolumn.

" %<: truncation position,
" %n: buffer number, %m: modified?, %r: RO?, %h: help buffer?,
" %w: preview window?,
set statusline=%<[%n]%m%r%w
" Show fenc and ff.
set statusline+=%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}
" Show the full path or file name.
if winwidth(0) >= 130 | set statusline+=\ %F | else | set statusline+=%t | endif
" %y: file type
set statusline+=\ %y\ %{fugitive#statusline()}
" Separator of left-side and right-side.
set statusline+=%=
" %1l: cursor line, %L: total line, %c: cursor column,
" %P: percent of current position
set statusline+=%1l\ %L,%c%V\ %P

if exists('$SHELL')
    set shell=$SHELL
else
    set shell=/bin/sh
endif

if has('unnamedplus')
  set clipboard=unnamed,unnamedplus " Copy/Paste/Cut
endif

source $VIMRUNTIME/macros/matchit.vim

highlight MatchParen ctermfg=white ctermbg=red
highlight SpellBad cterm=bold,italic
highlight Normal ctermbg=NONE
highlight NonText ctermbg=NONE
highlight TablineSel ctermbg=NONE
highlight LineNr ctermbg=NONE
highlight CursorLineNr ctermbg=NONE


function! s:ruby()
  " Ruby specific settings. Called by `augroup vimrc-ruby`.
  let g:rubycomplete_buffer_loading = 1
  let g:rubycomplete_classes_in_global = 1
  let g:rubycomplete_rails = 1

  " For ruby refactory
  runtime! macros/matchit.vim
endfunction

function! s:tex()
  " TeX specific settings. Called by `augroup vimrc-init`.
  let g:tex_flavor = 'latex'
endfunction

function! s:imeoff()
  " Turns IME off. Called by `augroup vimrc-init`.
  if has('mac')
    call system('osascript -e "tell application \"System Events\" to key code 102"')
  endif
  if executable('gsettings') " gnome desktop
    call system('gsettings set org.gnome.desktop.input-sources current "uint32 0"')
  endif
endfunction

if !exists('*s:setupWrapping')
  function s:setupWrapping()
    set wrap
    set wm=2
    set textwidth=79
  endfunction
endif


augroup vimrc-init
  autocmd!
  autocmd GUIEnter * set visualbell t_vb=
  autocmd BufRead, BufNewFile *.md set filetype=markdown " set filetype markdown when the file extension is .md
  autocmd BufRead, BufNewFile Vagrantfile set filetype=ruby
  autocmd BufWrite * StripWhitespace

  autocmd FileType tex call s:tex()
  autocmd FileType ruby setlocal shiftwidth=2 tabstop=2 softtabstop=2
  autocmd FileType yaml setlocal shiftwidth=2 tabstop=2 softtabstop=2
  autocmd FileType sh,zsh setlocal noexpandtab
  autocmd FileType sh,zsh setlocal nolist
  autocmd FileType rst,markdown,gitrebase,gitcommit,vcs-commit,hybrid,text,help,tex set spell
  autocmd InsertLeave * call s:imeoff()
augroup END

augroup vimrc-sync-fromstart
  "" Syntax highlight syncing from start unless 200 lines
  autocmd!
  autocmd BufEnter * :syntax sync maxlines=200
augroup END

augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

augroup vimrc-wrapping
  autocmd!
  autocmd BufRead,BufNewFile *.txt call s:setupWrapping()
augroup END

augroup vimrc-make-cmake
  autocmd!
  autocmd FileType make setlocal noexpandtab
  autocmd BufNewFile,BufRead CMakeLists.txt setlocal filetype=cmake
augroup END

augroup vimrc-golang
  autocmd!
  autocmd FileType go setlocal noexpandtab shiftwidth=4 tabstop=4 sts=4
augroup END

augroup vimrc-python
  autocmd!
  autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=4 colorcolumn=79
      \ formatoptions+=croq softtabstop=4
      \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
augroup END

augroup vimrc-ruby
  autocmd!
  autocmd BufNewFile,BufRead *.rb,*.rbw,*.gemspec setlocal filetype=ruby
  autocmd FileType ruby set tabstop=2|set shiftwidth=2|set expandtab softtabstop=2
augroup END


let mapleader = "\<Space>"

" Leave Terminal-insert mode.
tnoremap <silent> <Leader>\ <C-\><C-n>
" Open terminal
nnoremap <silent> <Leader>sh :tabnew +terminal<CR>

" Change the working directory to current file's directory.
nnoremap <Leader>. :lcd %:p:h<CR>

"" Prev buffer
noremap <Leader>bp :bp<cr>
"" Next buffer
noremap <Leader>bn :bn<cr>
"" Close buffer
noremap <Leader>bd :bd<CR>

"" Opens an edit command with the path of the currently edited file filled in
noremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
"" Opens a tab edit command with the path of the currently edited file filled
noremap <Leader>tab :tabedit <C-R>=expand("%:p:h") . "/" <CR>
"" Opens a split command with the path of the currently edited file filled
noremap <Leader>sp :split <C-R>=expand("%:p:h") . "/" <CR>
"" Opens a vsplit command with the path of the currently edited file filled
noremap <Leader>vs :vsplit <C-R>=expand("%:p:h") . "/" <CR>

" move by displaylines
noremap <silent> j gj
noremap <silent> k gk

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

noremap Q  <Nop>
noremap ZZ <Nop>
noremap ZQ <Nop>

" Clear highlights
nnoremap  <silent> <C-l> :nohlsearch<CR>

" Tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap <silent> <S-t> :tabnew<CR>

" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Emacs like cursor move in insert mode
inoremap <C-p> <Up>
inoremap <C-n> <Down>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-d> <Del>
inoremap <C-h> <BS>

if has('macunix')
  " pbcopy for OSX copy/paste
  vmap <C-x> :!pbcopy<CR>
  vmap <C-c> :w !pbcopy<CR><CR>
endif

cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

" Load plugins with dein.vim.
runtime nvimrc.d/dein.vim

filetype on
syntax on

lua <<EOF

-- setup outline viewer
local aerial = require('aerial')

on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  -- Mappings
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', '<Leader>gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', '<Leader>gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<Leader>gh', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<Leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<Leader>gH', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<Leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<Leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<Leader>gR', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '[d',         '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d',         '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<Leader>ge', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<Leader>gq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Calls aerial's on_attach.
  aerial.on_attach(client)
end

-- load the extra nvim config set by direnv config
for rc in string.gmatch(vim.env.EXTRA_NVIMRC or '', '[^:]+') do
    vim.cmd('exec "source' .. rc .. '"')
end

-- coq completion
vim.g.coq_settings = {
  ["auto_start"] = true,
  ["keymap.manual_complete"] = "<Leader>.",
}

local coq = require('coq')

-- setup local servers
local lsp_installer = require("nvim-lsp-installer")

lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
  }

  server:setup(coq.lsp_ensure_capabilities(opts))
end)

EOF

" Disable python2 support.
let g:loaded_python_provider = 0

" Set python virtual env if exists in XDG_CONFIG_HOME.
if isdirectory(expand('$XDG_CONFIG_HOME/nvim/venv'))
  let g:python3_host_prog = expand('$XDG_CONFIG_HOME/nvim/venv/bin/python')
  let g:black_virtualenv = expand('$XDG_CONFIG_HOME/nvim/venv')
endif

" Load local config file if exists.
if filereadable(expand('$XDG_CONFIG_HOME/nvim/init.local.vim'))
    source $XDG_CONFIG_HOME/nvim/init.local.vim
endif

