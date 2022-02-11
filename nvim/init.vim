scriptencoding utf8

set autoindent
set autoread  " Enable vim to reload a file when the file is modified.
set backspace=start,eol,indent  " Enable to erase/concat lines/delete with backspace key
set backupcopy=no
set clipboard=unnamed
set cmdheight=2  " Give more space for displaying messages.
set colorcolumn=121
set cursorline
set expandtab
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
set fileformats=unix,dos,mac
set hidden
set hlsearch
set ignorecase
set inccommand=split
set incsearch
set laststatus=2
set list
set matchpairs+=<:>
set mouse=a
set nobackup
set noerrorbells
set noshowmode
set nowrap
set nowritebackup
set number
set shiftwidth=4
set shortmess+=c  " Don't pass messages to |ins-completion-menu|.
set showcmd
set showtabline=2
set signcolumn=yes  " Always show the signcolumn.
set smartcase
set smartindent
set softtabstop=4
set spelllang=en,cjk
set splitbelow " Open a window below the current one.
set swapfile
set tabstop=4
set termguicolors  " Truecolor
set ttimeoutlen=1  " Timeout msec for key code sequences.
set updatetime=200
set wildmenu
set wildmode=list:full " command completion

" %<: truncation position,
" %n: buffer number, %m: modified?, %r: RO?, %h: help buffer?,
" %w: preview window?,
set statusline=%<[%n]%m%r%w
" Show fenc and ff.
set statusline+=%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}
" Show the full path or file name.
if winwidth(0) >= 130 | set statusline+=\ %F | else | set statusline+=%t | endif
" %y: file type
set statusline+=\ %y
" If fugitive#statusline is available, show git-branch
if exists("fugitive#statusline")
  set statusline+=\ %{fugitive#statusline()}
endif

" Separator of left-side and right-side.
set statusline+=%=
" %1l: cursor line, %L: total line, %c: cursor column,
" %P: percent of current position
set statusline+=%1l\ %L,%c%V\ %P

if has('unnamedplus')
  set clipboard=unnamed,unnamedplus " Copy/Paste/Cut
endif

highlight MatchParen ctermfg=white ctermbg=red
highlight SpellBad cterm=bold,italic
highlight Normal ctermbg=NONE
highlight NonText ctermbg=NONE
highlight TablineSel ctermbg=NONE
highlight LineNr ctermbg=NONE
highlight CursorLineNr ctermbg=NONE


function! s:ruby()
  " Ruby specific settings.
  let g:rubycomplete_buffer_loading = 1
  let g:rubycomplete_classes_in_global = 1
  let g:rubycomplete_rails = 1
endfunction

function! s:tex()
  " TeX specific settings.
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


augroup vimrc-init
  autocmd!
  " Remove trailing spaces on save.
  autocmd BufWrite * StripWhitespace
  " Syntax highlight syncing from start unless 200 lines
  autocmd BufEnter * :syntax sync maxlines=200
  " Remembers the cursor's position.
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
  " Turn IME off when leaveing insert mode.
  autocmd InsertLeave * call s:imeoff()

  " CMake
  autocmd BufNewFile,BufRead CMakeLists.txt setlocal filetype=cmake
  autocmd FileType make setlocal noexpandtab

  " Golang
  autocmd FileType go setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4

  " Python
  autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
      \ colorcolumn=79 formatoptions+=croq
      \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with

  " Ruby
  autocmd BufNewFile,BufRead *.rb,*.rbw,*.gemspec,Vagrantfile setlocal filetype=ruby
  autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2 | call s:ruby()

  " Shell
  autocmd FileType sh,zsh setlocal noexpandtab

  " TeX
  autocmd FileType tex call s:tex()

  " Yaml
  autocmd FileType yaml setlocal shiftwidth=2 tabstop=2 softtabstop=2
augroup END


let mapleader = "\<Space>"

" Leave Terminal-insert mode.
tnoremap <silent> <Leader>\ <C-\><C-n>
" Open terminal
nnoremap <silent> <Leader>sh :tabnew +terminal<CR>

" Change the working directory to current file's directory.
nnoremap <Leader>cd :lcd %:p:h<CR>

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
function setup_lsp(servers, opts)
  local ok, lspconfig = pcall(require, 'lspconfig')
  if not ok then
    print("LspSetup: lspconfig not found")
    return
  end

  local ok, aerial = pcall(require, 'aerial')
  if ok then
    aerial.setup({
        backends = {"lsp"},
    })
  end

  -- coq settings. This has to precede require('coq').
  vim.g.coq_settings = {
    ["auto_start"] = true,
    ["keymap.manual_complete"] = "<Leader>.",
  }

  local ok, coq = pcall(require, 'coq')
  if not ok then
    print("LspSetup: coq not found")
  else
    print("LspSetup: coq found. use its functionality")
    opts = coq.lsp_ensure_capabilities(opts)
  end

  for server, config in pairs(servers) do
    if vim.fn.executable(config.executable) ~= 0 then
      print("LspSetup: setting up for", server)
      lspconfig[server].setup(opts)
    else
      print("LspSetup: executable '", config.executable, "' not found")
    end
  end
end

on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', '<Leader>gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', '<Leader>gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<Leader>gh', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<Leader>gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<Leader>gH', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<Leader>gt', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<Leader>gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<Leader>gR', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '[d',         '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d',         '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<Leader>ge', '<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<Leader>gq', '<Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Calls aerial's on_attach.
  local ok, aerial = pcall(require, 'aerial')
  if ok then
    aerial.on_attach(client, bufnr)
    buf_set_keymap('n', '<Leader>go', ':AerialToggle<CR>', opts)
  end
end

-- load the extra nvim config set by direnv config
for rc in string.gmatch(vim.env.EXTRA_NVIMRC or '', '[^:]+') do
    vim.cmd('exec "source' .. rc .. '"')
end

local servers = {
  terraformls = {
    executable = 'terraform-ls'
  }
}
local opts = {
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
}

setup_lsp(servers, opts)
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

