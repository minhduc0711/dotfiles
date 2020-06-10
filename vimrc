" Install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" File explorer  
Plug 'preservim/nerdtree' 
Plug 'Xuyuanp/nerdtree-git-plugin'

" Git commands
Plug 'tpope/vim-fugitive'
" Git diff lines
Plug 'airblade/vim-gitgutter'
" pretty status bar (including Git)
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Auto insert closing brackets
" WARNING: disabled cuz it bugged when using ibus-bamboo
" Plugin 'jiangmiao/auto-pairs'

" autocompletion
Plug 'ycm-core/YouCompleteMe'

" Support (syntax, indent...) for many languages
Plug 'sheerun/vim-polyglot'

" Code formatting
" Add maktaba and codefmt to the runtimepath.
" (The latter must be installed before it can be used.)
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
" Also add Glaive, which is used to configure codefmt's maktaba flags. See
" `:help :Glaive` for usage.
Plug 'google/vim-glaive'

" Linting
Plug 'dense-analysis/ale'

" fzf fuzzy search
set rtp+=~/.fzf
Plug 'junegunn/fzf.vim'

" theme
Plug 'kaicataldo/material.vim'

" All of your Plugins must be added before the following line
call plug#end()            " required
" the glaive#Install() should go after the "call vundle#end()"
call glaive#Install()
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
set number
set list
set listchars=tab:>-

set tabstop=4 shiftwidth=4 expandtab

" syntax highlighting
syntax on

" Theme
set t_Co=256
syntax enable
if (has("termguicolors"))
  set termguicolors
endif
colorscheme material
let g:material_terminal_italics = 1
let g:material_theme_style = 'ocean'
hi Normal guibg=NONE ctermbg=NONE

" toggle ibus-bamboo
" WARNING: cause delays when switching modes, makes bracket expanding very slow
function! IBusOff()
  " Lưu engine hiện tại
  let g:ibus_prev_engine = system('ibus engine')
  " Chuyển sang engine tiếng Anh
  execute 'silent !ibus engine xkb:us::eng'
endfunction
function! IBusOn()
  let l:current_engine = system('ibus engine')
  " nếu engine được set trong normal mode thì
  " lúc vào insert mode duùn luôn engine đó
  if l:current_engine !~? 'xkb:us::eng'
    let g:ibus_prev_engine = l:current_engine
  endif
  " Khôi phục lại engine
  execute 'silent !' . 'ibus engine ' . g:ibus_prev_engine
endfunction
augroup IBusHandler
    autocmd CmdLineEnter [/?] call IBusOn()
    autocmd CmdLineLeave [/?] call IBusOff()
    autocmd InsertEnter * call IBusOn()
    autocmd InsertLeave * call IBusOff()
augroup END
call IBusOff()

" Bracket expanding: auto close {
"function! s:CloseBracket()
"    let line = getline('.')
"    if line =~# '^\s*\(struct\|class\|enum\) '
"        return "{\<Enter>};\<Esc>O"
"    elseif searchpair('(', '', ')', 'bmn', '', line('.'))
"        " Probably inside a function call. Close it off.
"        return "{\<Enter>});\<Esc>O"
"    else
"        return "{\<Enter>}\<Esc>O"
"    endif
"endfunction
"inoremap <expr> {<Enter> <SID>CloseBracket()

" disable word wrap by default 
" set nowrap

" tweak command autocompletion behavior (similar to terminal)
set wildmode=longest:full,full

" change the swap directory
set directory=~/.vim/swapfiles/

" remember last position in a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Open NERDtree when open
" autocmd vimenter * NERDTree
" Go to previous (last accessed) window.
autocmd VimEnter * wincmd p
" Key to toggle nerdtree
nmap <F4> :NERDTreeToggle<CR>

" split navigations using ctrl+h, ctrl+j,...
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" YCM stuffs
let g:ycm_autoclose_preview_window_after_completion=1
"map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

" Git Gutter"
set updatetime=250
let g:gitgutter_max_signs = 500
" No mapping
let g:gitgutter_map_keys = 0
" Colors
let g:gitgutter_override_sign_column_highlight = 0
highlight clear SignColumn
highlight GitGutterAdd ctermfg=2
highlight GitGutterChange ctermfg=3
highlight GitGutterDelete ctermfg=1
highlight GitGutterChangeDelete ctermfg=4

" Disable ale gutters (sign column)
let g:ale_set_signs = 0

" remove delay when switching to normal mode
set timeoutlen=1000 ttimeoutlen=0

" integrate powerline font into status bar
" 1. Font installation: https://powerline.readthedocs.io/en/master/installation/linux.html#patched-font-installation 
" 2. Link to patched font: https://github.com/powerline/fonts/raw/master/NotoMono/Noto%20Mono%20for%20Powerline.ttf
let g:airline_powerline_fonts = 1
set encoding=utf-8
" status bar theme
let g:airline_theme='material'

" disable text concealing in Markdown 
set conceallevel=0
