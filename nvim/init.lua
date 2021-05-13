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

-- This setting makes search case-insensitive when all characters in the string
-- being searched are lowercase. However, the search becomes case-sensitive if
-- it contains any capital letters. This makes searching more convenient.
opt('o', 'ignorecase', true)
opt('o', 'smartcase', true)

-- Enable searching and replacing as we type
opt('o', 'incsearch', true)
opt('o', 'inccommand', 'nosplit')

-- Needed for fast refresh in GitGutter?
opt('o', 'updatetime', 300)

-- Disable auto comment insertion
cmd 'autocmd BufNewFile,BufRead,FileType,OptionSet * setlocal formatoptions-=cro'

-- Remember cursor position when opening a file next time
cmd [[ au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]]

-- Make command autocompletion similar to the shell
opt('o', 'wildmode', 'longest:full,full')

---------- KEY MAPPINGS
-- Toggle paste mode
opt('o', 'pastetoggle', '<F3>')

-- Unbind some useless/annoying default key bindings.
-- 'Q' in normal mode enters Ex mode. You almost never want this.
map('n', 'Q', '<NOP>')

-- Navigate between tabs
map('n', 'H', 'gT')
map('n', 'I', 'gt')

---------- PLUGINS AND THEIR CONFIGS
-- Auto install paq-nvim
install_path = vim.fn.stdpath("data") .. "/site/pack/paqs/opt/paq-nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  cmd("!git clone https://github.com/savq/paq-nvim.git " .. install_path)
end

cmd 'packadd paq-nvim'               -- load the package manager
local paq = require('paq-nvim').paq  -- a convenient alias
paq {'savq/paq-nvim', opt = true}    -- paq-nvim manages itself

-- Syntax highlighting
paq {'nvim-treesitter/nvim-treesitter'}
local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}

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
  };
}

-- Navigate auto completion menu with <TAB>
cmd [[inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"]]
cmd [[inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"]]

-- LSP servers
paq {'neovim/nvim-lspconfig'}

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
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

-- Fuzzy finder
-- paq {'nvim-lua/popup.nvim'}
-- paq {'nvim-telescope/telescope.nvim'}
-- map('n', '<C-p>',[[<cmd>lua require('telescope.builtin').find_files()<CR>]], {silent = true})
-- map('n', '<C-f>',[[<cmd>lua require('telescope.builtin').live_grep()<CR>]], {silent = true})
paq {'junegunn/fzf', run = fn['fzf#install']}
paq {'junegunn/fzf.vim'}
paq {'ojroques/nvim-lspfuzzy'}
local lspfuzzy = require 'lspfuzzy'
lspfuzzy.setup {}
map('n', '<C-p>', ':Files<CR>', {silent = true})
map('n', '<C-f>', ':Rg<CR>' , {silent = true})

-- Code commenting
paq {'tpope/vim-commentary'}

-- tmux + vim navigation
paq {'christoomey/vim-tmux-navigator'}
vim.g.tmux_navigator_no_mappings = 1
map('n', '<M-h>', ':TmuxNavigateLeft<cr>', {silent = true})
map('n', '<M-n>', ':TmuxNavigateDown<cr>', {silent = true})
map('n', '<M-e>', ':TmuxNavigateUp<cr>', {silent = true})
map('n', '<M-i>', ':TmuxNavigateRight<cr>', {silent = true})

-- Colorscheme
opt('o', 'termguicolors', true)
opt('o', 'background', 'light')
paq {'morhetz/gruvbox'}
vim.g.gruvbox_contrast_light = 'hard'
vim.g.gruvbox_italic = 1
vim.g.gruvbox_underline = 1
cmd 'colorscheme gruvbox'

-- Pretty status bar
paq {'vim-airline/vim-airline'}
paq {'vim-airline/vim-airline-themes'}
vim.g.airline_powerline_fonts = 1
vim.g.airline_theme = 'gruvbox'

-- Display git signs
paq {'airblade/vim-gitgutter'}
cmd 'highlight clear SignColumn'
cmd 'highlight GitGutterAdd          guibg=NONE'
cmd 'highlight GitGutterChange       guibg=NONE'
cmd 'highlight GitGutterDelete       guibg=NONE'
cmd 'highlight GitGutterChangeDelete guibg=NONE'
