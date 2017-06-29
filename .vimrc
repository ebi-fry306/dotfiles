set number
set title
set ruler
set nobackup
set tabstop=2
set smartindent
set expandtab
set shiftwidth=2
set encoding=utf-8
set fileencodings=ucs_bom,utf8,ucs-2le,ucs-2
set fileformats=unix,dos,mac
set mouse=a
set backspace=indent,eol,start
if &encoding !=# 'utf-8'
	set encoding=japan
	set fileencoding=japan
endif
inoremap { {}<Left>
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap ( ()<ESC>i
inoremap (<Enter> ()<Left><CR><ESC><S-o>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
inoremap [ []<Left>


hi LineNr ctermbg=0 ctermfg=0
hi CursorLineNr ctermbg=4 ctermfg=0
set cursorline
hi clear CursorLine

set background=dark
colorscheme hybrid

set completeopt=menuone

if &compatible
	set nocompatible
endif
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

call dein#begin(expand('~/.vim/dein'))

call dein#add('Shougo/dein.vim')
call dein#add('Shougo/vimproc.vim', {'build': 'make'})

call dein#add('Shougo/neocomplete.vim')
call dein#add('Shougo/neomru.vim')
call dein#add('Shougo/neosnippet')

call dein#add('vim-ruby/vim-ruby')
call dein#add('Rsence/neocomplete')
call dein#add('Rubocop/syntastic')
call dein#add('vim-endwise')
call dein#add('mattin/emmet-vim')
call dein#add('hail2u/vim-css3-syntax')
call dein#add('taichouchou2/html5.vim')
call dein#add('taichouchou2/vim-javascript')
call dein#add('itchyny/vim-haskell-indent')
call dein#add('kana/vim-filetype-haskell')
call dein#add('pbrisbin/vim-syntax-shakespeare')
call dein#add('eagletmt/neco-ghc')
call dein#add('dag/vim2hs')
call dein#add('b4b4r07/vim-shellutils')

call dein#end()

syntax on
filetype on
filetype indent on
filetype plugin on
