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

---------- PLUGINS ----------
-- Auto install packer.nvim
local ensure_packer = function()
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    cmd [[packadd packer.nvim]]
    return true
  end
  return false
end
local packer_bootstrap = ensure_packer()
local packer = require('packer')
-- packer.init { compile_path = fn.stdpath('data') .. '/plugin/packer_compiled.lua' }
packer.startup(function(use)
  -- Packer can manage itself
  use {'wbthomason/packer.nvim'}

  -- Fast & accurate syntax highlighting
  use {'nvim-treesitter/nvim-treesitter'}
  use {'nvim-treesitter/playground'}
  -- Better indent module than the built-in one in treesitter
  -- use({ "yioneko/nvim-yati", tag = "*", requires = "nvim-treesitter/nvim-treesitter" })
  use {'Vimjas/vim-python-pep8-indent'}

  -- Debug with breakpoints
  use 'mfussenegger/nvim-dap'

  -- LSP servers
  use {'neovim/nvim-lspconfig'}
  -- Eclipse Java LSP
  use {'mfussenegger/nvim-jdtls'}

  -- Better LSP for Scala
  use {
    'scalameta/nvim-metals',
    requires= {'nvim-lua/plenary.nvim'}
  }

  -- Turn nvim into RStudio
  use {'jalvesaq/Nvim-R', branch = 'stable'}

  -- Auto completion
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "onsails/lspkind-nvim",
      "hrsh7th/vim-vsnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
    }
  }

  -- Fuzzy finder
  use {'junegunn/fzf'}
  use {'junegunn/fzf.vim'}

  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  -- Code commenting
  use {'tpope/vim-commentary'}

  -- Remove highlighting right when searching is done
  use {'romainl/vim-cool'}

  -- Auto close pairs
  use {'minhduc0711/vim-closer'}
  use {'windwp/nvim-ts-autotag'}

  -- Manipulate surrounding pairs
  use {'tpope/vim-surround'}

  -- Extend % key to work w/ words
  use {
    'andymass/vim-matchup',
    setup = function()
      -- may set any options here
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
      vim.g.matchup_delim_noskips = 2
    end
  }

  -- Auto detect indent
  use {'nmac427/guess-indent.nvim'}
  use {'Darazaki/indent-o-matic'}

  -- Indent lines
  use {'lukas-reineke/indent-blankline.nvim'}

  -- Git commands
  use {'tpope/vim-fugitive'}

  -- Display Git signs
  use {
    'lewis6991/gitsigns.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- tmux + vim navigation
  use {'christoomey/vim-tmux-navigator'}

  -- Live REPL
  use {'jpalardy/vim-slime'}

  -- Open buffers from quickfix lists
  use {'yssl/QFEnter'}

  -- Colorscheme
  use {'minhduc0711/gruvbox'}

  -- Pretty statusline
  use {'nvim-lualine/lualine.nvim'}

  -- Display colors in CSS
  use {'ap/vim-css-color'}

  -- Partial diff
  use {'rickhowe/spotdiff.vim'}

  -- Display CSV columns in different colors
  use {'mechatroner/rainbow_csv'}

  -- Auto switch ibus input methods between vim's cmd and insert mode
  use {'rlue/vim-barbaric'}

  -- Fun
  use {'eandrju/cellular-automaton.nvim'}

  -- Show context breadcrumbs on winbar
  use({
    "utilyre/barbecue.nvim",
    tag = "*",
    requires = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    config = function()
      require("barbecue").setup()
    end,
  })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

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

-- LSP
local ts_builtin = require('telescope.builtin')
local on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua require"telescope.builtin".lsp_definitions{}<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua require"telescope.builtin".lsp_references{}<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  -- Java specific
  -- map('n', '<leader>ca', '<cmd>lua require"jdtls".code_action()<CR>', {silent=true})
end

-- Searching
-- fzf is still better for fuzzy search
map('n', '<C-p>', ':Files<CR>', {silent = true})
map('n', '<C-f>', ':Rg<CR>' , {silent = true})
vim.keymap.set('n', '<C-g>', ts_builtin.git_files, {silent = true})
-- map('n', '<C-p>', ':Telescope find_files<CR>', {silent = true})
-- map('n', '<C-f>', ':Telescope grep_string search=<CR>' , {silent = true})
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- Seamless navigation between tmux & vim
g.tmux_navigator_no_mappings = 1
map('n', '<M-h>', ':TmuxNavigateLeft<cr>', {silent = true})
map('n', '<M-n>', ':TmuxNavigateDown<cr>', {silent = true})
map('n', '<M-e>', ':TmuxNavigateUp<cr>', {silent = true})
map('n', '<M-i>', ':TmuxNavigateRight<cr>', {silent = true})

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
opt.listchars = {tab='<->', trail='·', extends='>', precedes='<'}

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

-- Some custom aliases
cmd [[ command ClearTrailing %s/\s\+$//e ]]

---------- MORE SPECIFIC CONFIGURATIONS ----------

-- Python executable's path for pynvim
g.python3_host_prog = "/sbin/python3"

-- Disable indent after opening a pair in Python files
g.pyindent_disable_parentheses_indenting = 1

-- GAML syntax highlighting
cmd 'au BufRead,BufNewFile *.gaml setlocal filetype=gaml'

-- LSP settings
local lspconfig = require 'lspconfig'

-- nvim-cmp supports additional completion capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Enable the following language servers
local servers = { 'clangd', 'pyright', 'texlab', 'r_language_server', 'jsonls'}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities
  }
end
-- Customize lua LSP a bit
require'lspconfig'.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

-- -- Custom vim commands for jdtls
-- require'jdtls.setup'.add_commands()

-- Always detect *.sc as Scala source files
local filetype_detect_group = vim.api.nvim_create_augroup('filetypedetect', {clear = true})
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  group = filetype_detect_group,
  pattern = {"*.sc", "*.scala"},
  command = [[setfiletype scala]]
})
 
-- Enable metals for Scala files
local metals_config = require("metals").bare_config()
metals_config.init_options.statusBarProvider = "on"
metals_config.capabilities = capabilities
metals_config.on_attach = on_attach
metals_config.settings = {
  fallbackScalaVersion = '3.1.0'
}
local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})

-- Enable help messages for nvim-metals
vim.opt_global.shortmess:remove("F")

-- Show LSP diagnostics
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = true,
    signs = true,
    update_in_insert = false,
  }
)

-- Treesitter
local ts = require 'nvim-treesitter.configs'
-- NOTE: input lag with commment (https://github.com/nvim-treesitter/nvim-treesitter/issues/1267)
ts.setup {
  ensure_installed = {'python', 'java', 'scala', 'lua', 'bash', 'latex'},
  highlight = { enable = true },
  indent = {
    enable = true,
    -- not working properly for Python https://github.com/nvim-treesitter/nvim-treesitter/issues/1136
    disable = { "python" }
  },
  -- yati = {  -- workaround for Python
  --   enable = true,
  --   -- Disable by languages, see `Supported languages`
  --   disable = { "lua", "c" },
  --   -- Whether to enable lazy mode (recommend to enable this if bad indent happens frequently)
  --   default_lazy = true,
  --   -- Determine the fallback method used when we cannot calculate indent by tree-sitter
  --   --   "auto": fallback to vim auto indent
  --   --   "asis": use current indent as-is
  --   --   "cindent": see `:h cindent()`
  --   -- Or a custom function return the final indent result.
  --   default_fallback = "auto"
  -- },
  autotag = {
    enable = true,
    filetypes = {
      'html',
      'markdown'
    }
  },
  matchup = {
    enable = true,              -- mandatory, false will disable the whole extension
    -- disable = { "json" },  -- optional, list of language that will be disabled
    -- [options]
  },
}

-- Autocompletion with nvim-cmp
opt.completeopt = "menuone,noselect"
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end
local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end
local cmp = require'cmp'
cmp.setup {
  preselect = cmp.PreselectMode.None,
  sources = {
    { name = 'nvim_lsp'},
    { name = 'nvim_lua'},
    { name = 'path'},
  },
  mapping = {
    ['<C-t>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true
    },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"]() == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
  },
  formatting = {
    format = require("lspkind").cmp_format({with_text = true, menu = ({
      buffer = "[Buffer]",
      nvim_lsp = "[LSP]",
      luasnip = "[LuaSnip]",
      nvim_lua = "[Lua]",
    })}),
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
}

-- Telescope
require('telescope').setup{
  defaults = {
    layout_strategy = "horizontal",
    layout_config = {
      width = 0.95,
      height = 0.95
    },
    mappings = {
      i = {
        ["<esc>"] = require('telescope.actions').close
      },
    },
    extensions = {
      fzf = {
        fuzzy = true,                    -- false will only do exact matching
        override_generic_sorter = false, -- override the generic sorter
        override_file_sorter = true,     -- override the file sorter
        case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                         -- the default case_mode is "smart_case"
      }
    },
    -- path_display = { "shorten" },
    dynamic_preview_title = false
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')
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

-- fzf configs
g.fzf_layout = { window = { width= 0.9, height= 0.9 } }
-- Show tails of file paths
cmd [[command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--keep-right']}), <bang>0)]]
-- Make fzf (Rg) ignore file names when searching in files' content
cmd [[command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)]]

-- Auto detect indent settings
-- require('guess-indent').setup {}
-- Defaults (does not override w/ guess-indent I think)
-- opt.tabstop = 4
-- opt.shiftwidth = 4

require('indent-o-matic').setup {
  -- Number of lines without indentation before giving up (use -1 for infinite)
  max_lines = 2048,
  -- Space indentations that should be detected
  standard_widths = { 2, 4, 8 },
  -- Skip multi-line comments and strings (more accurate detection but less performant)
  skip_multiline = true,
}

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
  status_formatter=format_status,
  on_attach = function(bufnr)
    local function gs_map(mode, lhs, rhs, opts)
        opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
        vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    end

    -- Navigation
    gs_map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
    gs_map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

    -- Actions
    gs_map('n', '<leader>hs', ':Gitsigns stage_hunk<CR>')
    gs_map('v', '<leader>hs', ':Gitsigns stage_hunk<CR>')
    gs_map('n', '<leader>hr', ':Gitsigns reset_hunk<CR>')
    gs_map('v', '<leader>hr', ':Gitsigns reset_hunk<CR>')
    gs_map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>')
    gs_map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
    gs_map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>')
    gs_map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
    gs_map('n', '<leader>hb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
    gs_map('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>')
    gs_map('n', '<leader>hd', '<cmd>Gitsigns diffthis<CR>')
    gs_map('n', '<leader>hD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')
    gs_map('n', '<leader>td', '<cmd>Gitsigns toggle_deleted<CR>')

    -- Text object
    gs_map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    gs_map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}

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
g.qfenter_enable_autoquickfix = 0

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
      sources = {'nvim_diagnostic'},
      symbols = {error = 'E:', warn = 'W:', info = 'I:', hint = 'H:'}
    },
    'g:metals_status'
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

-- Indent lines
vim.g.indentLine_char = '▏'

-- nvim-R options
vim.g.rout_follow_colorscheme = 1
vim.g.R_assign = 0
vim.g.R_auto_start = 2
