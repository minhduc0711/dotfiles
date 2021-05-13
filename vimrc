let g:polyglot_disabled = ['markdown', 'python', 'sensible']
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

" Syntax highlighting
" Plug 'sheerun/vim-polyglot'
" Plug 'tpope/vim-markdown'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'} " python

" fzf fuzzy search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" color themes
Plug 'kaicataldo/material.vim', { 'branch': 'main' }
Plug 'morhetz/gruvbox'

" auto detect indent
Plug 'tpope/vim-sleuth'
" indent guides
Plug 'Yggdroot/indentLine'

" tmux + vim navigation
Plug 'christoomey/vim-tmux-navigator'
" colemak remap
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <M-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <M-n> :TmuxNavigateDown<cr>
nnoremap <silent> <M-e> :TmuxNavigateUp<cr>
nnoremap <silent> <M-i> :TmuxNavigateRight<cr>

" auto expand pairs on <CR>
Plug 'tpope/vim-endwise'
Plug 'minhduc0711/vim-closer'

" manipulate surrounding quotes, brackets,...
Plug 'tpope/vim-surround'

" jumping around with two characters
" Plug 'justinmk/vim-sneak'

" live REPL in Vim
Plug 'jpalardy/vim-slime'

" better search highlighting
Plug 'romainl/vim-cool'

" stuffs for eclim code completion
" Plug 'ervandew/supertab'
" let g:SuperTabDefaultCompletionType = 'context'
Plug 'Shougo/neocomplcache.vim'

" Open windows from quickfix list
Plug 'yssl/QFEnter'
let g:qfenter_keymap = {}
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-x>']
let g:qfenter_keymap.topen = ['<C-t>']

" java syntax highlighting
Plug 'uiiaoo/java-syntax.vim'

" Initialize plugin system
call plug#end()            " required

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

" Python executable's path for pynvim
let g:python3_host_prog = "/sbin/python3"

" show line numbers
set number
set relativenumber

" make tabs visible
set list
set listchars=tab:!·,trail:·
set tabstop=4

" Indenting defaults (does not override vim-sleuth's indenting detection)
" Defaults to 4 spaces for most filetypes
if get(g:, '_has_set_default_indent_settings', 0) == 0
  " Set the indenting level to 2 spaces for the following file types.
  autocmd FileType typescript,javascript,jsx,tsx,css,html,ruby,elixir,kotlin,vim,plantuml
        \ setlocal expandtab tabstop=2 shiftwidth=2
  set expandtab
  set tabstop=4
  set shiftwidth=4
  let g:_has_set_default_indent_settings = 1
endif

" disable text concealing in Markdown
set conceallevel=1

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase

" Enable searching as you type, rather than waiting till you press enter.
set incsearch
" Similarly for replace
set inccommand=nosplit

" CUSTOM KEY MAPPINGS

" fzf key binds
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <C-f> :Rg<CR>

" Toggle paste mode
set pastetoggle=<F3>

" Unbind some useless/annoying default key bindings.
" 'Q' in normal mode enters Ex mode. You almost never want this.
nmap Q <NOP>

" colemak hjkl remap
nnoremap s <NOP>
nnoremap sh h
nnoremap sn j
nnoremap se k
nnoremap si l
vnoremap sh h
vnoremap sn j
vnoremap se k
vnoremap si l

" switch between tabs
nnoremap H gT
nnoremap I gt

" transparent background
" fix for gruvbox from from https://github.com/morhetz/gruvbox/issues/108#issuecomment-215993544
au VimEnter * hi Normal ctermbg=NONE guibg=NONE

function GruvboxSemshiHighlights()
  " Use Gruvbox colors for python semshi semantic highlighter
  hi semshiLocal           ctermfg=209 guifg=#ff875f
  hi semshiGlobal          ctermfg=167 guifg=#cc241d
  hi semshiImported        ctermfg=214 guifg=#d79921 cterm=bold gui=bold
  hi semshiParameter       ctermfg=142 guifg=#458588
  hi semshiParameterUnused ctermfg=106 guifg=#665c54 cterm=underline gui=underline
  hi semshiFree            ctermfg=218 guifg=#ffafd7
  hi semshiBuiltin         ctermfg=208 guifg=#b16286
  hi semshiAttribute       ctermfg=108 guifg=#689d6a
  hi semshiSelf            ctermfg=109 guifg=#85a598
  hi semshiUnresolved      ctermfg=226 guifg=#d79921 cterm=underline gui=underline
  hi semshiSelected        ctermfg=231 guifg=#EBDBB2 ctermbg=161 guibg=#8B3D60

  hi semshiErrorSign       ctermfg=231 guifg=#EBDBB2 ctermbg=160 guibg=#CC241D
  hi semshiErrorChar       ctermfg=231 guifg=#EBDBB2 ctermbg=160 guibg=#CC241D
endfunction

autocmd ColorScheme * call GruvboxSemshiHighlights()

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
set background=light

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

let g:coc_global_extensions = ['coc-pyright', 'coc-tsserver', 'coc-json', 'coc-clangd']
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

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction


" Remap <C-g> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-g> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-g> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-g> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" disable warning for old vim versions
let g:coc_disable_startup_warning = 1

" ====== coc.nvim config ends ======

" Git Gutter
let g:gitgutter_max_signs = 500 " surpress signs threshold to avoid slowing down UI
let g:gitgutter_sign_priority = 1
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
set timeoutlen=1000 ttimeoutlen=5

set encoding=utf-8

" fzf (Rg): ignore file names when searching in files' content
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

" slime configs
let g:slime_target = "tmux"
let g:slime_paste_file = tempname()
let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}

" indentLine
let g:indentLine_setConceal = 0
let g:indentLine_char = '▏'
