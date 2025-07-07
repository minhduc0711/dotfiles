---------- HELPER FUNCTIONS ----------
local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn   -- to call Vim functions e.g. fn.bufnr()
local g = vim.g     -- a table to access global variables
local opt = vim.opt

-- Helper function for setting mappings
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

---------- PLUGINS ----------
-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },
  'nvim-treesitter/playground',

  -- Better indent module for python than the built-in one in treesitter
  'Vimjas/vim-python-pep8-indent',

  -- Debug with breakpoints
  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-neotest/nvim-nio',
    }
  },
  'mfussenegger/nvim-dap-python',

  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = { notification = { window = { winblend = 0 } } } },
    },
  },

  -- Better LSP for Scala
  {
    'scalameta/nvim-metals',
    dependencies = {
      'nvim-lua/plenary.nvim',
    }
  },

  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    opts = {
      keymap = {
        preset = "enter",
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
      },
      completion = {
        list = {
          selection = { auto_insert = true, preselect = false },
        },
        documentation = { auto_show = true }
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
  },

  -- Fuzzy finder
  'junegunn/fzf',
  'junegunn/fzf.vim',

  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  {
    'nvim-telescope/telescope.nvim',
    branch = 'master',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  -- Generate docstrings
  'danymat/neogen',

  -- Remove highlighting right when searching is done
  'romainl/vim-cool',

  -- Auto close pairs
  'windwp/nvim-ts-autotag',

  -- Manipulate surrounding pairs
  'tpope/vim-surround',

  -- Convert between camel case and underscore
  'tpope/vim-abolish',

  {
    -- Extend % key to work w/ words
    'andymass/vim-matchup',
    init = function()
      -- may set any options here
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
      vim.g.matchup_delim_noskips = 1
      -- improve responsiveness when opening large files
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_timeout = 100
      vim.g.matchup_matchparen_insert_timeout = 60
    end
  },


  -- Auto detect indent
  'Darazaki/indent-o-matic',

  -- Indent lines
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
  },

  -- Git commands
  'tpope/vim-fugitive',

  -- Display Git signs
  {
    'lewis6991/gitsigns.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    }
  },

  -- Single tabpage interface for easily cycling through diffs for all modified files for any git rev.
  'sindrets/diffview.nvim',

  -- tmux + vim navigation
  'christoomey/vim-tmux-navigator',

  -- Live REPL
  'jpalardy/vim-slime',

  -- Open buffers from quickfix lists
  'yssl/QFEnter',

  -- Colorscheme
  "ellisonleao/gruvbox.nvim",
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      vim.opt.termguicolors = true
      vim.opt.background = 'light'
      vim.g.gruvbox_material_enable_italic = true
      vim.g.gruvbox_material_enable_bold = true
      vim.g.gruvbox_material_background = 'hard'
      vim.g.gruvbox_material_ui_contrast = 'high'
      vim.g.gruvbox_material_diagnostic_virtual_text = 'colored'
      vim.cmd.colorscheme('gruvbox-material')
    end
  },

  -- Pretty statusline
  'nvim-lualine/lualine.nvim',

  -- Display colors in CSS
  'ap/vim-css-color',

  -- Partial diff
  'andrewradev/linediff.vim',

  -- Colorful pairs
  'hiphish/rainbow-delimiters.nvim',

  -- Display CSV columns in different colors
  'mechatroner/rainbow_csv',

  -- Auto switch ibus input methods between vim's cmd and insert mode
  'rlue/vim-barbaric',

  -- Fun
  'eandrju/cellular-automaton.nvim',

  -- Show context breadcrumbs on winbar
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      -- configurations go here
    },
  },

  -- Highlight git conflicts
  {
    'akinsho/git-conflict.nvim',
    version = "v1.2.2",
  }
}, {})

---------- KEY MAPPINGS ----------

-- Combine 0 and ^
map('n', '0', "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'", { silent = true, expr = true })

-- Unbind some useless/annoying default key bindings.
-- 'Q' in normal mode enters Ex mode. You almost never want this.
map('n', 'Q', '<NOP>')
vim.keymap.set({ 'n', 'v' }, '<Space>', '<NOP>', { silent = true })

-- Navigate between tabs
map('n', 'H', 'gT')
map('n', 'I', 'gt')

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- LSP
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function (event)
    local nmap = function(keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    nmap('<leader>f', vim.lsp.buf.format, '[F]ormat current buffer with LSP')
  end
})

-- Searching
local ts_builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', function() ts_builtin.find_files({ no_ignore = true }) end, {})
-- vim.keymap.set('n', '<C-f>', function() ts_builtin.grep_string({ search = "", only_sort_text = true }) end, {})
vim.keymap.set('n', '<C-f>', function() ts_builtin.live_grep() end, {})
vim.keymap.set('n', '<C-b>', ts_builtin.buffers, {})
vim.keymap.set('n', '<C-g>', ts_builtin.git_files, {})
vim.keymap.set('n', '<leader>sd',
  function() ts_builtin.diagnostics({ bufnr = 0 }) end,
  { desc = '[S]earch [D]iagnostics' }
)

-- Seamless navigation between tmux & vim
g.tmux_navigator_no_mappings = 1
map('n', '<M-h>', ':TmuxNavigateLeft<cr>', { silent = true })
map('n', '<M-n>', ':TmuxNavigateDown<cr>', { silent = true })
map('n', '<M-e>', ':TmuxNavigateUp<cr>', { silent = true })
map('n', '<M-i>', ':TmuxNavigateRight<cr>', { silent = true })

-- setup nvim-dap
vim.keymap.set("n", "<F5>", ":lua require'dap'.continue()<CR>")
vim.keymap.set("n", "<F10>", ":lua require'dap'.step_over()<CR>")
vim.keymap.set("n", "<F11>", ":lua require'dap'.step_into()<CR>")
vim.keymap.set("n", "<F12>", ":lua require'dap'.step_out()<CR>")
vim.keymap.set("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
vim.keymap.set("n", "<leader>db", ":lua require'dapui'.toggle()<CR>")

---------- GENERAL OPTIONS ----------

-- Enable mouse
opt.mouse = 'a'

-- Show line numbers
opt.number = true
opt.relativenumber = true

-- Don't show the mode, since it's already in the status line
opt.showmode = false

-- Highlight cursor line
opt.cursorline = true

-- Character limit indicator
opt.colorcolumn = '88'

-- Make tabs and trailing spaces visible
opt.list = true
opt.listchars = { tab = '<->', trail = '·', extends = '>', precedes = '<' }

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

-- Make command autocompletion similar to the shell
opt.wildmode = 'longest:full,full'

-- Disable auto comment insertion
-- cmd 'autocmd BufNewFile,BufRead,FileType,OptionSet * setlocal formatoptions-=cro'

-- Remember cursor position when opening a file next time
cmd [[ au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]]

-- Highlight on yank
-- cmd 'au TextYankPost * lua vim.highlight.on_yank {on_visual = false}'
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Some custom aliases
cmd [[ command ClearTrailing %s/\s\+$//e ]]

---------- MORE SPECIFIC CONFIGURATIONS ----------
-- Python executable's path for pynvim
g.python3_host_prog = "usr/bin/python3"

-- Disable indent after opening a pair in Python parens
g.pyindent_disable_parentheses_indenting = 1

-- Treesitter
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    -- ensure_installed = { 'python', 'java', 'scala', 'lua', 'bash', 'latex' },
    sync_install = false,
    ignore_install = {},
    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = true,
    highlight = { enable = true },
    indent = {
      enable = true,
      -- not working properly for Python https://github.com/nvim-treesitter/nvim-treesitter/issues/1136
      disable = { "python" }
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
    autotag = {
      enable = true,
      filetypes = {
        'html',
        'markdown'
      }
    },
    matchup = {
      enable = true, -- mandatory, false will disable the whole extension
      -- disable = { "json" },  -- optional, list of language that will be disabled
      -- [options]
    },
  }
end, 0)

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
local mason_lspconfig = require 'mason-lspconfig'

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
-- define the property 'filetypes' to the map in question.
local servers = {
  clangd = {},
  jsonls = {},
  html = {
    filetypes = { 'html', 'twig', 'hbs' }
  },
  yamlls = {
    yaml = {
      keyOrdering = false
    },
  },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  basedpyright = {},
  ruff = {},
}

-- Ensure the servers above are installed
require('mason-lspconfig').setup {
  ensure_installed = vim.tbl_keys(servers),
  handlers = {
    function(server_name)
      local server = servers[server_name] or {}

      server.capabilities = require('blink.cmp').get_lsp_capabilities(server.capabilities)
      require('lspconfig')[server_name].setup(server)
    end,
  }
}

-- Enable metals for Scala files
local metals_config = require("metals").bare_config()
metals_config.init_options.statusBarProvider = "on"
metals_config.settings = {
  showImplicitArguments = true
}
-- metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()
metals_config.on_attach = on_attach
local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})

-- LSP diagnostics
vim.diagnostic.config({
  underline = true,
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  severity_sort = true
})

-- Docstring generation
require('neogen').setup {
  enabled = true,             --if you want to disable Neogen
  input_after_comment = true, -- (default: true) automatic jump (with insert mode) on inserted annotation
  languages = {
    python = {
      template = {
        annotation_convention = "google_docstrings",
      }
    }
  }
}

-- Telescope
local actions = require 'telescope.actions'
require('telescope').setup {
  defaults = {
    layout_strategy = "horizontal",
    layout_config = {
      width = 0.95,
      height = 0.95
    },
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_tab_drop,
      },
    },
    extensions = {
      fzf = {
        fuzzy = true,                   -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true,    -- override the file sorter
        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
      }
    },
    -- path_display = { "shorten" },
    dynamic_preview_title = false
  },
}

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')

-- fzf configs
g.fzf_layout = { window = { width = 0.9, height = 0.9 } }
-- Show tails of file paths
cmd [[command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--keep-right']}), <bang>0)]]
-- Make fzf (Rg) ignore file names when searching in files' content
cmd [[command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)]]

-- Defaults (does not override w/ guess-indent I think)
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

require('indent-o-matic').setup {
  -- Number of lines without indentation before giving up (use -1 for infinite)
  max_lines = 2048,
  -- Space indentations that should be detected
  standard_widths = { 2, 4, 8 },
  -- Skip multi-line comments and strings (more accurate detection but less performant)
  skip_multiline = true,
}

-- Gitsigns
require('gitsigns').setup {
  signs = {
    add          = { text = '+' },
    change       = { text = '~' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~_' },
    untracked    = { text = '┆' },
  },
  numhl = true,
  on_attach = function(bufnr)
    local function gs_map(mode, lhs, rhs, opts)
      opts = vim.tbl_extend('force', { noremap = true, silent = true }, opts or {})
      vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    end

    -- Navigation
    gs_map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
    gs_map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

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
  end,
  signs_staged_enable = false
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
  open = { '<CR>', '<2-LeftMouse>' },
  vopen = { '<C-v>' },
  hopen = { '<C-x>' },
  topen = { '<C-t>' }
}
g.qfenter_enable_autoquickfix = 0

-- default vim-matchup colors make visual selections hard to see
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  group = vim.api.nvim_create_augroup('matchup_matchparen_highlight', { clear = true }),
  pattern = { "*" },
  callback = function() vim.api.nvim_set_hl(0, 'MatchWord', { bg = vim.g.terminal_color_7, fg = vim.g.terminal_color_0 }) end
})

-- Lualine
local lualine_sections = {
  lualine_a = { 'mode' },
  lualine_b = { 'branch', 'b:gitsigns_status' },
  lualine_c = {
    'filename',
    {
      'diagnostics',
      sources = { 'nvim_diagnostic' },
      symbols = { error = 'E:', warn = 'W:', info = 'I:', hint = 'H:' }
    },
    'g:metals_status'
  },
  lualine_x = { 'filetype' },
  lualine_y = { { 'fileformat', icons_enabled = false }, 'encoding' },
  lualine_z = { 'progress', 'location' },
}
require 'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox-material',
    component_separators = '|',
    section_separators = '',
    disabled_filetypes = {}
  },
  sections = lualine_sections,
  inactive_sections = vim.deepcopy(lualine_sections),
  tabline = {},
  extensions = {}
}

-- Indent blanklines
local highlight = {
  "RainbowRed",
  "RainbowYellow",
  "RainbowBlue",
  "RainbowOrange",
  "RainbowGreen",
  "RainbowViolet",
  "RainbowCyan",
}

local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "RainbowRed", { link = "RainbowDelimiterRed" })
  vim.api.nvim_set_hl(0, "RainbowYellow", { link = "RainbowDelimiterYellow" })
  vim.api.nvim_set_hl(0, "RainbowBlue", { link = "RainbowDelimiterBlue" })
  vim.api.nvim_set_hl(0, "RainbowOrange", { link = "RainbowDelimiterOrange" })
  vim.api.nvim_set_hl(0, "RainbowGreen", { link = "RainbowDelimiterGreen" })
  vim.api.nvim_set_hl(0, "RainbowViolet", { link = "RainbowDelimiterViolet" })
  vim.api.nvim_set_hl(0, "RainbowCyan", { link = "RainbowDelimiterCyan" })
end)
require("ibl").setup {
  indent = {
    highlight = highlight,
    char = '▏',
  },
  scope = { enabled = false }
}

require('dapui').setup()
require("dap-python").setup("uv")
require('dap-python').test_runner = 'pytest'
vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'Red' })
table.insert(require 'dap'.configurations.python, {
  justMyCode = false,
  type = 'python',
  request = 'launch',
  name = 'FastAPI module',
  module = 'uvicorn',
  args = {
    'src.main:app',
    -- '--reload', -- doesn't work
    '--use-colors',
    '--port', '8083',
  },
  pythonPath = 'python',
  console = 'integratedTerminal',
})
table.insert(require 'dap'.configurations.python, {
  type = 'python',
  request = 'launch',
  name = 'Launch file (justMyCode=false)',
  program = '${file}',
  console = 'integratedTerminal',
  pythonPath = 'python',
  justMyCode = false,
})
table.insert(require 'dap'.configurations.python, {
  justMyCode = false,
  type = 'python',
  request = 'launch',
  name = 'Pytest',
  module = 'pytest',
  args = {
    'tests/collection/test_collection_ops.py',
  },
  pythonPath = 'python',
  console = 'integratedTerminal',
})
require("diffview").setup({
  view = {
    default = {
      winbar_info = true,
    },
    file_history = {
      winbar_info = true,
    },
  },
})

require('git-conflict').setup({
  highlights = {
    incoming = 'DiffAdd',
    current = 'DiffDelete',
  }
})
