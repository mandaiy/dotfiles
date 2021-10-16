set encoding=utf-8
scriptencoding utf8

if &compatible
  set compatible
endif

filetype on
syntax on

set nocompatible
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
set writebackup
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

if exists('$SHELL')
    set shell=$SHELL
else
    set shell=/bin/sh
endif

"" Copy/Paste/Cut
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif


source $VIMRUNTIME/macros/matchit.vim
runtime nvimrc.d/dein.vim

" colorscheme setting
colorscheme molokai

highlight MatchParen ctermfg=white ctermbg=red
highlight SpellBad cterm=bold,italic
highlight Normal ctermbg=NONE
highlight NonText ctermbg=NONE
highlight TablineSel ctermbg=NONE
highlight LineNr ctermbg=NONE
highlight CursorLineNr ctermbg=NONE

""*****************************************************************************
"" Functions
"*****************************************************************************
function! s:cpp()
    setlocal path+=/usr/include,/usr/local/include

    if has("mac")
        setlocal path+=/Library/Developer/CommandLineTools/usr/include/c++/v1
    endif
endfunction

function! s:ruby()
    " ruby
    let g:rubycomplete_buffer_loading = 1
    let g:rubycomplete_classes_in_global = 1
    let g:rubycomplete_rails = 1

    " For ruby refactory
    if has('nvim')
      runtime! macros/matchit.vim
    else
      packadd! matchit
    endif
endfunction

function! s:tex()
    setlocal concealcursor=nv
    setlocal conceallevel=2
    let g:tex_flavor = 'latex'
endfunction

function! s:imeoff()
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

"*****************************************************************************
"" Autocmd Rules
"*****************************************************************************
augroup vimrc-init
    autocmd!
    autocmd GUIEnter * set visualbell t_vb=
    autocmd BufRead, BufNewFile *.md set filetype=markdown " set filetype markdown when the file extension is .md
    autocmd BufRead, BufNewFile Vagrantfile set filetype=ruby

    autocmd FileType cpp call s:cpp()
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

augroup vimrc-python
  autocmd!
  autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8 colorcolumn=79
      \ formatoptions+=croq softtabstop=4
      \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
augroup END

augroup vimrc-ruby
  autocmd!
  autocmd BufNewFile,BufRead *.rb,*.rbw,*.gemspec setlocal filetype=ruby
  autocmd FileType ruby set tabstop=2|set shiftwidth=2|set expandtab softtabstop=2
augroup END


"*****************************************************************************
"" Map Leader
"*****************************************************************************
let mapleader = "\<Space>"

noremap <leader>p "+gP<CR>

tnoremap <silent> <leader>\ <C-\><C-n>
nnoremap <silent> <leader>sh :terminal<CR>
nnoremap <leader>. :lcd %:p:h<CR> " Set working directory

"" Buffer nav
noremap <leader>z :bp<CR>
noremap <leader>q :bp<CR>
noremap <leader>x :bn<CR>
noremap <leader>w :bn<CR>

"" Close buffer
noremap <leader>c :bd<CR>

"" Opens an edit command with the path of the currently edited file filled in
noremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

"" Opens a tab edit command with the path of the currently edited file filled
noremap <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

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

"" Tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap <silent> <S-t> :tabnew<CR>

"" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

"" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

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

""*****************************************************************************
""" Abbreviations
""*****************************************************************************
"" no one is really happy until you have this shortcuts
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

if filereadable(expand('$HOME/.nvimrc.local'))
    source $HOME/.nvimrc.local
endif

