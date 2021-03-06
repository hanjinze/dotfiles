set expandtab
execute pathogen#infect()

syntax enable
filetype plugin indent on
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
set encoding=utf-8

"let g:nerdtree_tabs_open_on_console_startup=1

let g:Powerlinelight = 'fancy'
set background=dark
"let g:solarized_termcolors=256
colorscheme solarized

set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent

set nocompatible        " Use Vim defaults (much better!)
set bs=2                " Allow backspacing over everything in insert mode
set ai                  " Always set auto-indenting on
set history=150         " keep 50 lines of command history
set ruler               " Show the cursor position all the time
set showtabline=2
set laststatus=2
set number

set guifont=PragmataPro\ 9

nmap \e :NERDTreeToggle<CR>
nmap j gj
nmap k gk

au BufRead,BufNewFile *.pde set filetype=arduino
au BufRead,BufNewFile *.ino set filetype=arduino

