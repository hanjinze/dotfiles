set expandtab
execute pathogen#infect()
syntax enable
filetype plugin indent on
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
set encoding=utf-8
let g:Powerline_symbols = 'fancy'

set background=dark
let g:darkrobot_termcolors=256
colorscheme darkrobot

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

set guifont=Consolas\ 9
