---------- HELPER FUNCTIONS ----------
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt

-- Helper function for setting mappings
local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

---------- KEY MAPPINGS ----------

-- Merge 0 and ^
map('n', '0', "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'", {silent = true, expr = true})

-- Toggle paste mode
opt.pastetoggle = '<F3>'

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
map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', {silent=true})
map('n', '<leader>l', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', {silent=true})
map('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', {silent=true})
map('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', {silent=true})
-- Java specific
map('n', '<leader>ca', '<cmd>lua require"jdtls".code_action()<CR>', {silent=true})

---------- GENERAL OPTIONS ----------

-- Enable mouse
opt.mouse = 'a'

-- Show line numbers
opt.number = true
opt.relativenumber = true

-- Highlight cursor line
opt.cursorline = true

-- Character limit indicator
opt.colorcolumn = '79'

-- Make tabs and trailing spaces visible
opt.list = true
opt.listchars = {tab = '!·', trail = '·'}

-- This setting makes search case-insensitive when all characters in the string
-- being searched are lowercase. However, the search becomes case-sensitive if
-- it contains any capital letters. This makes searching more convenient.
opt.ignorecase = true
opt.smartcase = true

-- Enable searching and replacing as we type
opt.incsearch = true
opt.inccommand = 'nosplit'

-- Open new splits to the right and bottom
opt.splitright = true
opt.splitbelow = true

-- Needed for fast refresh in GitGutter?
opt.updatetime = 300

-- Make command autocompletion similar to the shell
opt.wildmode = 'longest:full,full'

-- Disable auto comment insertion
-- cmd 'autocmd BufNewFile,BufRead,FileType,OptionSet * setlocal formatoptions-=cro'

-- Remember cursor position when opening a file next time
cmd [[ au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]]

-- Highlight on yank
cmd 'au TextYankPost * lua vim.highlight.on_yank {on_visual = false}'

---------- PLUGINS ----------

-- Auto install paq-nvim
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path})
end

cmd 'packadd paq-nvim'               -- load the package manager
local paq = require('paq-nvim').paq  -- a convenient alias
paq {'savq/paq-nvim', opt = true}    -- paq-nvim manages itself
-- Fast & accurate syntax highlighting
paq {'nvim-treesitter/nvim-treesitter'}
paq {'nvim-treesitter/playground'}
-- Freeze context
-- paq {'romgrk/nvim-treesitter-context'}
-- LSP servers
paq {'neovim/nvim-lspconfig'}
-- Eclipse Java LSP
paq {'mfussenegger/nvim-jdtls'}
-- Java w/ Eclipse
paq {'starcraftman/vim-eclim'}

-- Better LSP for Scala
-- TODO: enable this when you start learning Scala again
-- paq {'scalameta/nvim-metals'}
-- Easily install LSPs
paq {'kabouzeid/nvim-lspinstall'}
-- Auto completion
paq {'hrsh7th/nvim-compe'}
-- Fuzzy finder
-- paq {'junegunn/fzf', run = fn['fzf#install']}
-- paq {'junegunn/fzf.vim'}
-- paq {'ojroques/nvim-lspfuzzy'} -- Display results from LSP client using fzf
paq {'nvim-lua/popup.nvim'}
paq {'nvim-lua/plenary.nvim'}
paq {'nvim-telescope/telescope.nvim'}
-- Code commenting
paq {'tpope/vim-commentary'}
-- Remove highlighting right when searching is done
paq {'romainl/vim-cool'}
-- Auto close pairs
-- paq {'tpope/vim-endwise'}  -- DOES NOT WORK PROPERLY
paq {'minhduc0711/vim-closer'}
-- paq {'windwp/nvim-autopairs'}
-- Manipulate surrounding pairs
paq {'tpope/vim-surround'}
-- Auto detect indent
-- TODO: maybe this is unnecessary since there is treesitter? EDIT: perhaps not
paq {'tpope/vim-sleuth'}
-- Indent lines
-- TODO: this is messing with the display of tabs and trailings
-- paq {'lukas-reineke/indent-blankline.nvim', branch='lua'}
-- vim.g.indentLine_char = '▏'
-- Git commands
paq {'tpope/vim-fugitive'}
-- Display Git signs
paq {'nvim-lua/plenary.nvim'}
paq {'lewis6991/gitsigns.nvim'}
-- tmux + vim navigation
paq {'christoomey/vim-tmux-navigator'}
-- Live REPL
paq {'jpalardy/vim-slime'}
-- Open buffers from quickfix lists
paq {'yssl/QFEnter'}
-- Colorscheme
paq {'morhetz/gruvbox'}
-- Create missing highlight groups for LSP diagnostics
-- More details: https://github.com/neovim/neovim/issues/12579
paq {'folke/lsp-colors.nvim'}
-- Pretty statusline
paq {'hoob3rt/lualine.nvim'}

cmd 'PaqInstall'

---------- MORE SPECIFIC CONFIGURATIONS ----------

-- Python executable's path for pynvim
g.python3_host_prog = "/sbin/python3"

-- Disable indent after opening a pair in Python files
g.pyindent_disable_parentheses_indenting = 1

-- GAML syntax highlighting
cmd 'au BufRead,BufNewFile *.gaml setlocal filetype=gaml'

-- -- nvim-autopairs
-- local npairs=require('nvim-autopairs')
-- npairs.setup()
-- -- skip it, if you use another global object
-- _G.MUtils= {}
-- vim.g.completion_confirm_key = ""
-- MUtils.completion_confirm=function()
--   return npairs.autopairs_cr()
-- end
-- map('i' , '<CR>','v:lua.MUtils.completion_confirm()', {expr = true})
-- npairs.clear_rules()
-- local endwise = require('nvim-autopairs.ts-rule').endwise
-- npairs.add_rules({
-- -- then$ is a lua regex
-- -- end is a match pair
-- -- lua is a filetype
-- -- if_statement is a treesitter name. set it = nil to skip check with treesitter
--   endwise('{$', '}', 'python', nil)
-- })


-- Built-in LSP diagnostics
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = true,
    signs = true,
    update_in_insert = false,
  }
)
-- Custom gutter signs
cmd 'sign define LspDiagnosticsSignError text=x texthl=CocErrorSign numhl=CocErrorSign'
cmd 'sign define LspDiagnosticsSignWarning text=! texthl=CocWarningSign numhl=CocWarningSign'
cmd 'sign define LspDiagnosticsSignInformation text=I texthl=CocInfoSign numhl=CocInfoSign'
cmd 'sign define LspDiagnosticsSignHint text=H texthl=CocHintSign numhl=CocHintSign'

-- Treesitter
local ts = require 'nvim-treesitter.configs'
-- NOTE: input lag with commment (https://github.com/nvim-treesitter/nvim-treesitter/issues/1267)
ts.setup {
  ensure_installed = {'python', 'java', 'scala', 'lua', 'bash', 'latex'},
  highlight = { enable = true },
  indent = { enable = false }  -- not working properly for Python
}

-- Autocompletion with nvim-compe
opt.completeopt = "menuone,noselect"
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'disable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;
  source = {
    path = true;
    buffer = false;  -- slow on big files
    calc = false;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = false;
    ultisnips = false;
    omni = false;
  };
}
-- Navigate auto completion menu with <TAB>
cmd [[inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"]]
cmd [[inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"]]
-- Confirm completion
map('i', '<C-t>', 'compe#confirm("<C-t>")', {expr = true})

-- LSPinstall
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

require'jdtls.setup'.add_commands()

-- Telescope
require('telescope').setup{
  defaults = {
    path_display = {
      'shorten',
      'absolute',
    },
  }
}
map('n', '<C-p>', ':Telescope find_files<CR>', {silent = true})
map('n', '<C-f>', ':Telescope live_grep<CR>' , {silent = true})
map('n', '<C-e>', ':Telescope lsp_document_diagnostics<CR>' , {silent = true})
-- Use Telescope for Java code actions
local finders = require'telescope.finders'
local sorters = require'telescope.sorters'
local actions = require'telescope.actions'
local pickers = require'telescope.pickers'
require('jdtls.ui').pick_one_async = function(items, prompt, label_fn, cb)
  local opts = {}
  pickers.new(opts, {
    prompt_title = prompt,
    finder    = finders.new_table {
      results = items,
      entry_maker = function(entry)
        return {
          value = entry,
          display = label_fn(entry),
          ordinal = label_fn(entry),
        }
      end,
    },
    sorter = sorters.get_generic_fuzzy_sorter(),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = actions.get_selected_entry(prompt_bufnr)
        actions.close(prompt_bufnr)

        cb(selection.value)
      end)

      return true
    end,
  }):find()
end

-- -- fuzzy search with fzf
-- map('n', '<C-p>', ':Files<CR>', {silent = true})
-- map('n', '<C-f>', ':Rg<CR>' , {silent = true})
-- -- Make fzf (Rg) ignore file names when searching in files' content
-- cmd [[command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)]]
-- -- Integrate fzf with LSP
-- local lspfuzzy = require 'lspfuzzy'
-- lspfuzzy.setup {}

-- Indent defaults (does not override vim-sleuth's indent detection)
if g._has_set_default_indent_settings == nil then
  -- Set the indent level to 2 spaces for the following file types.
  cmd 'autocmd FileType lua,typescript,javascript,jsx,tsx,css,html,ruby,elixir,kotlin,vim,plantuml setlocal expandtab tabstop=2 shiftwidth=2'
  -- Defaults to 4 spaces for the rest
  opt.expandtab = true
  opt.tabstop = 4
  opt.shiftwidth = 4
  g._has_set_default_indent_settings = 1
end

-- Gitsigns
local function format_status(status)
  local added, changed, removed = status.added, status.changed, status.removed
  local status_txt = {}
  table.insert(status_txt, '+'..(added == nil and 0 or added))
  table.insert(status_txt, '~'..(changed == nil and 0 or changed))
  table.insert(status_txt, '-'..(removed == nil and 0 or removed))
  return table.concat(status_txt, ' ')
end
require('gitsigns').setup {
  signs = {
    add          = {hl = 'GitGutterAdd',          text = '+',  numhl='GitGutterAdd'},
    change       = {hl = 'GitGutterChange',       text = '~',  numhl='GitGutterChange'},
    delete       = {hl = 'GitGutterDelete',       text = '_',  numhl='GitGutterDelete'},
    topdelete    = {hl = 'GitGutterDelete',       text = '‾',  numhl='GitGutterDelete'},
    changedelete = {hl = 'GitGutterChangeDelete', text = '~_', numhl='GitGutterChangeDelete'},
  },
  numhl = true,
  status_formatter=format_status
}

-- tmux + vim navigation
g.tmux_navigator_no_mappings = 1
map('n', '<M-h>', ':TmuxNavigateLeft<cr>', {silent = true})
map('n', '<M-n>', ':TmuxNavigateDown<cr>', {silent = true})
map('n', '<M-e>', ':TmuxNavigateUp<cr>', {silent = true})
map('n', '<M-i>', ':TmuxNavigateRight<cr>', {silent = true})

-- Live REPL with vim-slime
g.slime_target = "tmux"
g.slime_paste_file = fn.tempname()
g.slime_default_config = {
  socket_name = "default",
  target_pane = "{last}"
}

-- Open buffers from quickfix lists
g.qfenter_keymap = {
  open = {'<CR>', '<2-LeftMouse>'},
  vopen = {'<C-v>'},
  hopen = {'<C-x>'},
  topen = {'<C-t>'}
}

-- Colorscheme
opt.termguicolors = true
opt.background = 'light'
g.gruvbox_contrast_light = 'hard'
g.gruvbox_italic = 1
g.gruvbox_underline = 1
g.gruvbox_sign_column = 'bg0'
g.gruvbox_invert_selection = 0
vim.env.BAT_THEME='gruvbox-light' -- for fzf preview
cmd 'colorscheme gruvbox'

-- Lualine
local lualine_sections = {
  lualine_a = {'mode'},
  lualine_b = {'branch', 'b:gitsigns_status'},
  lualine_c = {
    'filename',
    {'diagnostics',
      sources = {'nvim_lsp'},
      symbols = {error = 'E:', warn = 'W:', info = 'I:', hint = 'H:'}
    }
  },
  lualine_x = {'filetype'},
  lualine_y = {{'fileformat', icons_enabled = false}, 'encoding'},
  lualine_z = {'progress', 'location'},
}
require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox_light',
    component_separators = '|',
    section_separators = '',
    disabled_filetypes = {}
  },
  sections = lualine_sections,
  inactive_sections = vim.deepcopy(lualine_sections),
  tabline = {},
  extensions = {}
}
