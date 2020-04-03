set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" File explorer  
Plugin 'preservim/nerdtree' 
Plugin 'Xuyuanp/nerdtree-git-plugin'

" Git commands
Plugin 'tpope/vim-fugitive'
" Git diff lines
Plugin 'airblade/vim-gitgutter'
" status bar (including Git)
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Auto insert closing brackets
Plugin 'jiangmiao/auto-pairs'

" Python autocompletion
Plugin 'ycm-core/YouCompleteMe'

" Support (syntax, indent...) for many languages
Plugin 'sheerun/vim-polyglot'

" Show indent lines
Plugin 'Yggdroot/indentLine'

" Code formatting
" Add maktaba and codefmt to the runtimepath.
" (The latter must be installed before it can be used.)
Plugin 'google/vim-maktaba'
Plugin 'google/vim-codefmt'
" Also add Glaive, which is used to configure codefmt's maktaba flags. See
" `:help :Glaive` for usage.
Plugin 'google/vim-glaive'

" Linting
Plugin 'dense-analysis/ale'

" fzf fuzzy search
" If installed using git
set rtp+=~/.fzf
Plugin 'junegunn/fzf.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
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

" toggle ibus-bamboo
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

" disable word wrap by default 
set nowrap 

" tweak command autocompletion behavior (similar to terminal)
set wildmode=longest:full,full

" change the swap directory
set directory=~/.vim/swapfiles//

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
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

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

" indent character
let g:indentLine_char = '▏'

" remove delay when switching to normal mode
set timeoutlen=1000 ttimeoutlen=0

" integrate powerline font into status bar
" 1. Font installation: https://powerline.readthedocs.io/en/master/installation/linux.html#patched-font-installation 
" 2. Link to patched font: https://github.com/powerline/fonts/raw/master/NotoMono/Noto%20Mono%20for%20Powerline.ttf
let g:airline_powerline_fonts = 1
" status bar theme
" let g:airline_theme='wombat'

" disable vim-markdown concealing
set conceallevel=0
let g:indentLine_conceallevel = 0
