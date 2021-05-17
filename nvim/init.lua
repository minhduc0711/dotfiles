---------- HELPER FUNCTIONS
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables

-- Setting options
-- Simpler interface (WIP): https://github.com/neovim/neovim/pull/13479
local scopes = {o = vim.o, b = vim.bo, w = vim.wo}
local function opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

-- Helper function for setting mappings
local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

---------- VARIOUS OPTIONS
-- Enable mouse
opt('o', 'mouse', 'a')

-- Show line numbers
opt('w', 'number', true)
opt('w', 'relativenumber', true)

-- Highlight cursor line
opt('w', 'cursorline', true)

-- Character limit indicator
opt('w', 'colorcolumn', '79')

-- Make tabs and trailing spaces visible
opt('w', 'list', true)
opt('w', 'listchars', 'tab:!·,trail:·')
-- Tab length
opt('b', 'tabstop', 4)

-- This setting makes search case-insensitive when all characters in the string
-- being searched are lowercase. However, the search becomes case-sensitive if
-- it contains any capital letters. This makes searching more convenient.
opt('o', 'ignorecase', true)
opt('o', 'smartcase', true)

-- Enable searching and replacing as we type
opt('o', 'incsearch', true)
opt('o', 'inccommand', 'nosplit')

-- Open new splits to the right and bottom
opt('o', 'splitright', true)
opt('o', 'splitbelow', true)

-- Needed for fast refresh in GitGutter?
opt('o', 'updatetime', 300)

-- Make command autocompletion similar to the shell
opt('o', 'wildmode', 'longest:full,full')

-- Python executable's path for pynvim
g.python3_host_prog = "/sbin/python3"

-- Disable auto comment insertion
cmd 'autocmd BufNewFile,BufRead,FileType,OptionSet * setlocal formatoptions-=cro'

-- Remember cursor position when opening a file next time
cmd [[ au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]]

-- Highlight on yank
cmd 'au TextYankPost * lua vim.highlight.on_yank {on_visual = false}'

---------- KEY MAPPINGS
-- Toggle paste mode
opt('o', 'pastetoggle', '<F3>')

-- Unbind some useless/annoying default key bindings.
-- 'Q' in normal mode enters Ex mode. You almost never want this.
map('n', 'Q', '<NOP>')

-- Navigate between tabs
map('n', 'H', 'gT')
map('n', 'I', 'gt')

-- LSP commands
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {silent=true})
map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', {silent=true})
map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', {silent=true})
map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', {silent=true})
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {silent=true})
map('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', {silent=true})
-- map('n', '<C-n>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', {silent=true})
-- map('n', '<C-p>', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', {silent=true})

---------- PLUGINS AND THEIR CONFIGS
-- Auto install paq-nvim
local install_path = vim.fn.stdpath("data") .. "/site/pack/paqs/opt/paq-nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  cmd("!git clone https://github.com/savq/paq-nvim.git " .. install_path)
end

cmd 'packadd paq-nvim'               -- load the package manager
local paq = require('paq-nvim').paq  -- a convenient alias
paq {'savq/paq-nvim', opt = true}    -- paq-nvim manages itself

-- Built-in LSP diagnostic
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = true,
    signs = true,
    update_in_insert = false,
  }
)
-- Workaround for https://github.com/neovim/neovim/issues/12579
-- cmd 'autocmd ColorScheme * call v:lua.vim.lsp.diagnostic._define_default_signs_and_highlights()'
-- Make LSP diagnostic colors consistent with color scheme
cmd 'au ColorScheme * hi link LspDiagnosticsDefaultError CocDiagnosticsError'
cmd 'au ColorScheme * hi link LspDiagnosticsDefaultWarning CocDiagnosticsWarning'
cmd 'au ColorScheme * hi link LspDiagnosticsDefaultInformation CocDiagnosticsInfo'
cmd 'au ColorScheme * hi link LspDiagnosticsDefaultHint CocDiagnosticsHint'
-- For underlines as well
cmd 'au ColorScheme * hi link LspDiagnosticsUnderlineError CocErrorHighlight'
cmd 'au ColorScheme * hi link LspDiagnosticsUnderlineWarning CocWarningHighlight'
cmd 'au ColorScheme * hi link LspDiagnosticsUnderlineInformation CocInfoHighlight'
cmd 'au ColorScheme * hi link LspDiagnosticsUnderlineHint CocHintHighlight'
-- Custom gutter signs
cmd 'sign define LspDiagnosticsSignError text=? texthl=CocErrorSign numhl=CocErrorSign'
cmd 'sign define LspDiagnosticsSignWarning text=! texthl=CocWarningSign numhl=CocWarningSign'
cmd 'sign define LspDiagnosticsSignInformation text=> texthl=CocInfoSign numhl=CocInfoSign'
cmd 'sign define LspDiagnosticsSignHint text=> texthl=CocHintSign numhl=CocHintSign'

-- Syntax highlighting
paq {'nvim-treesitter/nvim-treesitter'}
local ts = require 'nvim-treesitter.configs'
ts.setup {
  ensure_installed = {'python', 'java', 'scala', 'lua', 'bash', 'comment'},
  highlight = { enable = true },
  indent = { enable = false }  -- not working properly for now
}

-- Auto completion
paq {'hrsh7th/nvim-compe'}
vim.o.completeopt = "menuone,noselect"
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;
  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
    omni = false;
  };
}
-- Navigate auto completion menu with <TAB>
cmd [[inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"]]
cmd [[inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"]]

-- LSP servers
paq {'neovim/nvim-lspconfig'}
-- Eclipse Java LSP
paq {'mfussenegger/nvim-jdtls'}
-- Better LSP for Scala
-- TODO: enable this when you start learning Scala again
-- paq {'scalameta/nvim-metals'}

-- Easily install LSPs
paq {'kabouzeid/nvim-lspinstall'}
require'lspinstall'.setup() -- important

local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
  require'lspconfig'[server].setup{}
end

local function setup_servers()
  require'lspinstall'.setup()
  local servers = require'lspinstall'.installed_servers()
  for _, server in pairs(servers) do
    require'lspconfig'[server].setup{}
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

-- Fuzzy finder
paq {'junegunn/fzf', run = fn['fzf#install']}
paq {'junegunn/fzf.vim'}
map('n', '<C-p>', ':Files<CR>', {silent = true})
map('n', '<C-f>', ':Rg<CR>' , {silent = true})
-- Make fzf (Rg) ignore file names when searching in files' content
cmd [[command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)]]

-- Display results from LSP client using fzf
paq {'ojroques/nvim-lspfuzzy'}
local lspfuzzy = require 'lspfuzzy'
lspfuzzy.setup {}

-- Code commenting
paq {'tpope/vim-commentary'}

-- Better search highlighting
paq {'romainl/vim-cool'}

-- Auto close pairs
-- paq {'tpope/vim-endwise'}  -- DOES NOT WORK PROPERLY
paq {'minhduc0711/vim-closer'}

-- Manipulate surrounding pairs
paq {'tpope/vim-surround'}

-- TODO: maybe this is unnecessary since there is treesitter? EDIT: perhaps not
-- Auto detect indent
paq {'tpope/vim-sleuth'}
-- Indenting defaults (does not override vim-sleuth's indenting detection)
-- Set the indenting level to 2 spaces for the following file types.
if g._has_set_default_indent_settings == nil then
  cmd 'autocmd FileType typescript,javascript,jsx,tsx,css,html,ruby,elixir,kotlin,vim,plantuml setlocal expandtab tabstop=2 shiftwidth=2'
  -- Defaults to 4 spaces for most filetypes
  opt('b', 'expandtab', true)
  opt('b', 'tabstop', 4)
  opt('b', 'shiftwidth', 4)
  g._has_set_default_indent_settings = 1
end

-- Indent lines
-- TODO: this is messing with the display of tabs and trailings
-- paq {'lukas-reineke/indent-blankline.nvim', branch='lua'}
-- vim.g.indentLine_char = '▏'

-- tmux + vim navigation
paq {'christoomey/vim-tmux-navigator'}
g.tmux_navigator_no_mappings = 1
map('n', '<M-h>', ':TmuxNavigateLeft<cr>', {silent = true})
map('n', '<M-n>', ':TmuxNavigateDown<cr>', {silent = true})
map('n', '<M-e>', ':TmuxNavigateUp<cr>', {silent = true})
map('n', '<M-i>', ':TmuxNavigateRight<cr>', {silent = true})

-- Colorscheme
opt('o', 'termguicolors', true)
opt('o', 'background', 'light')
paq {'morhetz/gruvbox'}
g.gruvbox_contrast_light = 'hard'
g.gruvbox_italic = 1
g.gruvbox_underline = 1
g.gruvbox_sign_column = 'bg0'
g.gruvbox_invert_selection = 0
cmd 'colorscheme gruvbox'

-- Pretty status bar
paq {'vim-airline/vim-airline'}
paq {'vim-airline/vim-airline-themes'}
g.airline_powerline_fonts = 1
g.airline_theme = 'gruvbox'

-- Git commands
paq {'tpope/vim-fugitive'}
-- Display Git signs
paq {'nvim-lua/plenary.nvim'}
paq {'lewis6991/gitsigns.nvim'}
require('gitsigns').setup {
  signs = {
    add          = {hl = 'GitGutterAdd',          text = '+',  numhl='GitGutterAdd'},
    change       = {hl = 'GitGutterChange',       text = '~',  numhl='GitGutterChange'},
    delete       = {hl = 'GitGutterDelete',       text = '_',  numhl='GitGutterDelete'},
    topdelete    = {hl = 'GitGutterDelete',       text = '‾',  numhl='GitGutterDelete'},
    changedelete = {hl = 'GitGutterChangeDelete', text = '~_', numhl='GitGutterChangeDelete'},
  },
  numhl = true
}

-- Live REPL
paq {'jpalardy/vim-slime'}
g.slime_target = "tmux"
g.slime_paste_file = vim.fn.tempname()
g.slime_default_config = {
  socket_name = "default",
  target_pane = "{last}"
}

-- Open buffers from quickfix lists
paq {'yssl/QFEnter'}
g.qfenter_keymap = {
  open = {'<CR>', '<2-LeftMouse>'},
  vopen = {'<C-v>'},
  hopen = {'<C-x>'},
  topen = {'<C-t>'}
}
