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
  -- 'Vimjas/vim-python-pep8-indent',

  -- Debug with breakpoints
  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'mfussenegger/nvim-dap',
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

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  -- Eclipse Java LSP
  'mfussenegger/nvim-jdtls',

  -- Better LSP for Scala
  {
    'scalameta/nvim-metals',
    dependencies = {
      'nvim-lua/plenary.nvim',
    }
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/vim-vsnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',

      -- Add icons next to completion options in dropdown
      'onsails/lspkind-nvim',
    },
  },

  -- Fuzzy finder
  'junegunn/fzf',
  'junegunn/fzf.vim',

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

  -- Code commenting
  'tpope/vim-commentary',

  -- Remove highlighting right when searching is done
  'romainl/vim-cool',

  -- Auto close pairs
  'minhduc0711/vim-closer',
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

  -- Pretty statusline
  'nvim-lualine/lualine.nvim',

  -- Display colors in CSS
  'ap/vim-css-color',

  -- Partial diff
  'rickhowe/spotdiff.vim',

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
}, {})

---------- KEY MAPPINGS ----------

-- Combine 0 and ^
map('n', '0', "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'", { silent = true, expr = true })

-- Toggle paste mode
opt.pastetoggle = '<F3>'

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
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
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

  local format = function(_)
    vim.lsp.buf.format()
  end
  nmap('<leader>f', format, '[F]ormat')
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', format, { desc = 'Format current buffer with LSP' })
end

-- Searching
-- fzf is still better than telescope for fuzzy search
map('n', '<C-p>', ':Files<CR>', { silent = true })
map('n', '<C-f>', ':Rg<CR>', { silent = true })

local ts_builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-b>', ts_builtin.buffers, {})
vim.keymap.set('n', '<C-g>', ts_builtin.git_files, { silent = true })
-- map('n', '<C-p>', ':Telescope find_files<CR>', {silent = true})
-- map('n', '<C-f>', ':Telescope grep_string search=<CR>' , {silent = true})
vim.keymap.set('n', '<leader>sd',
  function() require('telescope.builtin').diagnostics({ bufnr = 0 }) end,
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

-- Highlight cursor line
opt.cursorline = true

-- Character limit indicator
opt.colorcolumn = '120'

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
g.python3_host_prog = "/usr/bin/python3"
local venv_path = os.getenv("CONDA_PREFIX")
local python_path = nil
-- decide which python executable to use for mypy
if venv_path ~= nil then
  python_path = venv_path .. "/bin/python3"
else
  python_path = vim.g.python3_host_prog
end


-- Disable indent after opening a pair in Python parens
g.pyindent_disable_parentheses_indenting = 1

-- Treesitter
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'python', 'java', 'scala', 'lua', 'bash', 'latex' },
    sync_install = false,
    ignore_install = {},
    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,
    highlight = { enable = true },
    indent = {
      enable = true,
      -- not working properly for Python https://github.com/nvim-treesitter/nvim-treesitter/issues/1136
      -- disable = { "python" }
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
require('mason-lspconfig').setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  clangd = {},
  texlab = {},
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
  pylsp = {
    pylsp = {
      plugins = {
        ruff = {
          enabled = true,
          lineLength = 88,
          select = { "E4", "E7", "E9", "F", "FIX002" },
          extendSelect = { "I" },
        },
        black = {
          line_length = 88
        },
        pylsp_mypy = {
          enabled = true,
          overrides = { "--python-executable", python_path, true }
        }
      }
    }
  }
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}

-- -- Custom vim commands for jdtls
-- require'jdtls.setup'.add_commands()

-- Always detect *.sc as Scala source files
-- local filetype_detect_group = vim.api.nvim_create_augroup('filetypedetect', { clear = true })
-- vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
--   group = filetype_detect_group,
--   pattern = { "*.sc", "*.scala" },
--   command = [[setfiletype scala]]
-- })

-- -- Enable metals for Scala files
-- local metals_config = require("metals").bare_config()
-- metals_config.init_options.statusBarProvider = "on"
-- metals_config.capabilities = capabilities
-- metals_config.settings = {
--   fallbackScalaVersion = '3.1.0'
-- }
-- local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "scala", "sbt" },
--   callback = function()
--     require("metals").initialize_or_attach(metals_config)
--   end,
--   group = nvim_metals_group,
-- })

-- -- Enable help messages for nvim-metals
-- vim.opt_global.shortmess:remove("F")

-- LSP diagnostics
vim.diagnostic.config({
  underline = true,
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  severity_sort = true
})

-- Autocompletion with nvim-cmp
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end
local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end
local cmp = require 'cmp'
cmp.setup {
  preselect = cmp.PreselectMode.None,
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'path' },
  },
  mapping = {
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
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
    format = require("lspkind").cmp_format({
      with_text = true,
      menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
      })
    }),
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
}

-- Telescope
local finders = require 'telescope.finders'
local sorters = require 'telescope.sorters'
local actions = require 'telescope.actions'
local pickers = require 'telescope.pickers'
require('telescope').setup {
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
  },
  -- jump to an existing file in already opened tab or window from all file pickers
  -- NOTE: actions.select_tab_drop is not merged into 0.1.x yet
  pickers = {
    buffers = {
      mappings = {
        i = { ["<CR>"] = actions.select_tab_drop }
      }
    },
    find_files = {
      mappings = {
        i = { ["<CR>"] = actions.select_tab_drop }
      }
    },
    git_files = {
      mappings = {
        i = { ["<CR>"] = actions.select_tab_drop }
      }
    },
    old_files = {
      mappings = {
        i = { ["<CR>"] = actions.select_tab_drop }
      }
    }
  }
}

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')

-- Use Telescope for Java code actions
require('jdtls.ui').pick_one_async = function(items, prompt, label_fn, cb)
  local opts = {}
  pickers.new(opts, {
    prompt_title    = prompt,
    finder          = finders.new_table {
      results = items,
      entry_maker = function(entry)
        return {
          value = entry,
          display = label_fn(entry),
          ordinal = label_fn(entry),
        }
      end,
    },
    sorter          = sorters.get_generic_fuzzy_sorter(),
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
local function format_status(status)
  local added, changed, removed = status.added, status.changed, status.removed
  local status_txt = {}
  table.insert(status_txt, '+' .. (added == nil and 0 or added))
  table.insert(status_txt, '~' .. (changed == nil and 0 or changed))
  table.insert(status_txt, '-' .. (removed == nil and 0 or removed))
  return table.concat(status_txt, ' ')
end
require('gitsigns').setup {
  numhl = true,
  status_formatter = format_status,
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

-- Colorscheme
require("gruvbox").setup({
  contrast = "hard",
  transparent_mode = true,
})
-- not sure if this option fixes anything
-- opt.termguicolors = true
opt.background = 'light'
cmd 'colorscheme gruvbox'
vim.env.BAT_THEME = 'gruvbox-light' -- for fzf preview
require("nvim-web-devicons").refresh()

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
  vim.api.nvim_set_hl(0, "RainbowRed", { link = "TSRainbowRed" })
  vim.api.nvim_set_hl(0, "RainbowYellow", { link = "TSRainbowYellow" })
  vim.api.nvim_set_hl(0, "RainbowBlue", { link = "TSRainbowBlue" })
  vim.api.nvim_set_hl(0, "RainbowOrange", { link = "TSRainbowOrange" })
  vim.api.nvim_set_hl(0, "RainbowGreen", { link = "TSRainbowGreen" })
  vim.api.nvim_set_hl(0, "RainbowViolet", { link = "TSRainbowViolet" })
  vim.api.nvim_set_hl(0, "RainbowCyan", { link = "TSRainbowCyan" })
end)

local rainbow_delimiters = require 'rainbow-delimiters'
vim.g.rainbow_delimiters = {
  strategy = {
    [''] = rainbow_delimiters.strategy['global'],
    vim = rainbow_delimiters.strategy['local'],
  },
  query = {
    [''] = 'rainbow-delimiters',
    lua = 'rainbow-blocks',
  },
  highlight = highlight,
}

require("ibl").setup {
  indent = {
    highlight = highlight,
    char = '▏',
    -- tab_char = ''
  },
  scope = { enabled = false }
}

require('dapui').setup()
require('dap-python').setup('/data/mdm/apps/mambaforge/bin/python')
table.insert(require 'dap'.configurations.python, {
  type = 'python',
  request = 'launch',
  name = 'FastAPI module',
  module = 'uvicorn',
  args = {
    'src.main:app',
    -- '--reload', -- doesn't work
    '--use-colors',
    '--port', '8025',
  },
  pythonPath = 'python',
  console = 'integratedTerminal',
})
