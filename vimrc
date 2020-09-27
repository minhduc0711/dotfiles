set nocompatible              " be iMproved, required

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

" Git commands
Plug 'tpope/vim-fugitive'
" Git diff lines
Plug 'airblade/vim-gitgutter'

" pretty status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" autocompletion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" commenting code
Plug 'tpope/vim-commentary'

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

" fzf fuzzy search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" color themes
Plug 'kaicataldo/material.vim', { 'branch': 'main' }
Plug 'morhetz/gruvbox'

" auto detect indent
Plug 'tpope/vim-sleuth'

" tmux + vim navigation
Plug 'christoomey/vim-tmux-navigator'

" rainbow-colored bracket pairs
Plug 'luochen1990/rainbow'

" multi-line bracket autoexpansion
Plug 'rstacruz/vim-closer'

" manipulate surrounding quotes, brackets,...
Plug 'tpope/vim-surround'

" Initialize plugin system
call plug#end()            " required
" the glaive#Install() should go after the "call plug#end()"
call glaive#Install()

" show line numbers
set number
set relativenumber

" make tabs visible
set list
set listchars=tab:>-

" default indent settings
set expandtab
set shiftwidth=4
set softtabstop=4

" disable text concealing in Markdown 
set conceallevel=0

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase

" Enable searching as you type, rather than waiting till you press enter.
set incsearch

" CUSTOM KEY MAPPINGS

" fzf key binds
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <C-f> :Rg<CR>

" Toggle paste mode
set pastetoggle=<F3>

" Unbind some useless/annoying default key bindings.
" 'Q' in normal mode enters Ex mode. You almost never want this.
nmap Q <NOP> 

" breaking bad habits (hjkl spam)
noremap h <NOP>
noremap l <NOP>
" noremap j <NOP>
" noremap k <NOP>

" transparent background
" fix for gruvbox from from https://github.com/morhetz/gruvbox/issues/108#issuecomment-215993544
au VimEnter * hi Normal ctermbg=NONE guibg=NONE

" material
" colorscheme material
" set background=dark
" let g:airline_theme='material'

" gruvbox
let g:gruvbox_contrast_light = 'hard'
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_italic = 1
let g:gruvbox_underline = 1
colorscheme gruvbox
set background=dark

" visual mode highlight color (currently gruvbox)
hi Visual guifg=#282828 guibg=#ebdbb2 gui=NONE

" highlight current line of cursor
set cursorline
" set line limit indicator
set colorcolumn=79

let g:airline_powerline_fonts = 1

" enable true color
if (has("termguicolors"))
    " fix for tmux
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

    set termguicolors
endif

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
function IBusSwitchEnable()
  if executable("ibus") == 1
    augroup IBusHandler
        " Khôi phục ibus engine khi tìm kiếm
        autocmd CmdLineEnter [/?] silent call IBusOn()
        autocmd CmdLineLeave [/?] silent call IBusOff()
        autocmd CmdLineEnter \? silent call IBusOn()
        autocmd CmdLineLeave \? silent call IBusOff()
        " Khôi phục ibus engine khi vào insert mode
        autocmd InsertEnter * silent call IBusOn()
        " Tắt ibus engine khi vào normal mode
        autocmd InsertLeave * silent call IBusOff()
    augroup END
    silent call IBusOff()
  endif
endfunction
" Only turn on ibus switch when editing markdown
" autocmd FileType md, MD call IBusSwitchEnable()
autocmd BufNewFile,BufRead *.md,*.MD call IBusSwitchEnable()

" enable mouse
set mouse=a

" disable auto comment insertion
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" tweak command autocompletion behavior (similar to terminal)
set wildmode=longest:full,full

" change the swap directory
set directory=~/.vim/swapfiles/

" remember last position in a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" ====== coc.nvim config starts ======

let g:coc_global_extensions = ['coc-python', 'coc-tsserver', 'coc-json']
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" disable warning for old vim versions
let g:coc_disable_startup_warning = 1

" ====== coc.nvim config ends ======

" Git Gutter
let g:gitgutter_max_signs = 500 " surpress signs threshold to avoid slowing down UI
" No key mapping
"let g:gitgutter_map_keys = 0
" Colors
let g:gitgutter_override_sign_column_highlight = 0
highlight clear SignColumn
highlight GitGutterAdd          guibg=NONE
highlight GitGutterChange       guibg=NONE
highlight GitGutterDelete       guibg=NONE
highlight GitGutterChangeDelete guibg=NONE

" remove delay when switching to normal mode
if ! has('gui_running')
  set ttimeoutlen=10
  augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
  augroup END
endif

set encoding=utf-8

" ignore file names when finding in files using fzf (Rg)
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
