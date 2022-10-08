local fn = vim.fn

local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

local function load_plugins()
  local use = require('packer').use
  require('packer').startup(function()
    use 'wbthomason/packer.nvim' -- Package manager
    use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use 'nvim-treesitter/playground'
    use 'folke/which-key.nvim'
    use 'folke/lua-dev.nvim'
    use 'folke/tokyonight.nvim' -- Theme
    use { 'folke/trouble.nvim', requires = 'kyazdani42/nvim-web-devicons' }
    use { 'justinhj/battery.nvim', requires = {{'kyazdani42/nvim-web-devicons'}, {'nvim-lua/plenary.nvim'}}}
    use { 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } } }
    use 'nvim-telescope/telescope-dap.nvim'
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use { 'softinio/scaladex.nvim' }
    use 'windwp/nvim-autopairs' -- Autopairs
    use 'kyazdani42/nvim-tree.lua' -- File explorer
    use {
      'glepnir/galaxyline.nvim',
      config = function()
        require 'salargalaxyline'
      end,
      requires = 'kyazdani42/nvim-web-devicons',
    }
    use 'lukas-reineke/indent-blankline.nvim'
    use { 'lewis6991/gitsigns.nvim', requires = 'nvim-lua/plenary.nvim' }
    use { 'TimUntersberger/neogit', requires = { { 'nvim-lua/plenary.nvim' }, { 'sindrets/diffview.nvim' } } }
    use {
      'hrsh7th/nvim-cmp',
      requires = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-nvim-lsp-signature-help',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
      }
    }
    use {'tzachar/cmp-tabnine', run='./install.sh', requires = 'hrsh7th/nvim-cmp'}
    use 'kevinhwang91/nvim-bqf'
    use 'mfussenegger/nvim-dap'
    use 'mfussenegger/nvim-dap-python'
    use 'jbyuki/one-small-step-for-vimkind'
    use {'theHamsta/nvim-dap-virtual-text'}
    use 'sheerun/vim-polyglot'
    use 'scalameta/nvim-metals'
    use 'b3nj5m1n/kommentary'
    use 'ckipp01/stylua-nvim'
    use 'gennaro-tedesco/nvim-jqx'
    use 'p00f/nvim-ts-rainbow'
    use 'christoomey/vim-tmux-navigator'
    use 'lervag/vimtex'
    use {
      'f3fora/nvim-texlabconfig',
      run = 'go build'
    }
    use {
    'phaazon/mind.nvim',
    branch = 'v2.2',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require'mind'.setup()
    end
  }
  end)
end

_G.load_config = function()
  require('gitsigns').setup()
  require('kommentary.config').use_extended_mappings()
  require 'salargalaxyline'
  require('trouble').setup()
  require('which-key').setup()
  require('indent_blankline').setup({
    indent_blankline_use_treesitter = true
  })

  -- nvim-autopairs
  require('nvim-autopairs').setup()

  -- battery.nvim
  local battery = require("battery")
  battery.setup({
    update_rate_seconds = 30, -- Number of seconds between checking battery status
    show_status_when_no_battery = true, -- Don't show any icon or text when no battery found (desktop for example)
    show_plugged_icon = true, -- If true show a cable icon alongside the battery icon when plugged in
    show_unplugged_icon = true, -- When true show a diconnected cable icon when not plugged in
    show_percent = true, -- Whether or not to show the percent charge remaining in digits
    vertical_icons = true, -- When true icons are vertical, otherwise shows horizontal battery icon
  })

  -- nvim-dap
  local dap = require('dap')
  dap.configurations.lua = {
    {
      type = 'nlua',
      request = 'attach',
      name = "Attach to running Neovim instance",
      host = function()
        local value = vim.fn.input('Host [127.0.0.1]: ')
        if value ~= "" then
          return value
        end
        return '127.0.0.1'
      end,
      port = function()
        local val = tonumber(vim.fn.input('Port: '))
        assert(val, "Please provide a port number")
        return val
      end,
    }
  }

  dap.adapters.nlua = function(callback, config)
    callback({ type = 'server', host = config.host, port = config.port or 8088 })
  end

  dap.configurations.scala = {
    {
      type = "scala",
      request = "launch",
      name = "Run",
      metals = {
        runType = "run",
        args = { "firstArg", "secondArg", "thirdArg" },
      },
    },
    {
      type = "scala",
      request = "launch",
      name = "Test File",
      metals = {
        runType = "testFile",
      },
    },
    {
      type = "scala",
      request = "launch",
      name = "Test Target",
      metals = {
        runType = "testTarget",
      },
    },
  }


  vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
  vim.fn.sign_define('DapStopped', {text='⭐️', texthl='', linehl='', numhl=''})

  require('dap-python').test_runner = 'pytest'

  -- vimtex
  vim.g.vimtex_view_method = 'skim'
  vim.g.vimtex_compiler_method = 'tectonic'

  -- nvim-texlabconfig
  local tex_preview_executable = '/Applications/Skim.app/Contents/SharedSupport/displayline'
  local tex_preview_args = {"%l", "%p", "%f"}
  local texlab_build_executable = 'tectonic'
  local texlab_build_args = {
    '-X',
    'compile',
    '%f',
    '--synctex',
    '--keep-logs',
    '--keep-intermediates'
  }
  require('texlabconfig').setup {
    cache_activate = true,
    cache_filetypes = { 'tex', 'bib' },
    reverse_search_edit_cmd = 'split',
    settings = {
      texlab = {
        build = {
          executable = texlab_build_executable,
          args = texlab_build_args
        },
        forwardSearch = {
          executable = tex_preview_executable,
          args = tex_preview_args
        }
      }
    }
  }

  -- nvim-tree
  require('nvim-tree').setup()

  -- Treesitter
  require('nvim-treesitter.configs').setup {
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = { 'BufWrite', 'CursorHold' },
    },
    -- ensure_installed = 'maintained',
    highlight = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = 'gnn',
        node_incremental = 'grn',
        scope_incremental = 'grc',
        node_decremental = 'grm',
      },
    },
    indent = {
      enable = true,
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
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
    },
    playground = {
      enable = true,
      disable = {},
      updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = false, -- Whether the query persists across vim sessions
      keybindings = {
        toggle_query_editor = 'o',
        toggle_hl_groups = 'i',
        toggle_injected_languages = 't',
        toggle_anonymous_nodes = 'a',
        toggle_language_display = 'I',
        focus_language = 'f',
        unfocus_language = 'F',
        update = 'R',
        goto_node = '<cr>',
        show_help = '?',
      },
    },
    rainbow = {
      enable = true,
      extended_mode = true,
      max_file_lines = 1000,
    },
  }
  -- vim.opt.foldmethod     = 'expr'
  -- vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
  ---WORKAROUND
  vim.api.nvim_create_autocmd({'BufEnter','BufAdd','BufNew','BufNewFile','BufWinEnter'}, {
    group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
    callback = function()
      vim.opt.foldmethod     = 'expr'
      vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
    end
  })
  ---ENDWORKAROUND

  -- neogit
  require('neogit').setup {
    integrations = {
      diffview = true,
    },
  }

  --Incremental live completion
  vim.o.inccommand = 'nosplit'

  --Set highlight on search
  vim.o.hlsearch = false
  vim.o.incsearch = true

  --Make line numbers default
  vim.wo.number = true

  --Do not save when switching buffers
  vim.o.hidden = true

  --Enable mouse mode
  vim.o.mouse = 'a'

  -- clipboard
  vim.o.clipboard = 'unnamedplus'

  --Enable break indent
  vim.o.breakindent = true

  --Save undo history
  vim.cmd [[set undofile]]

  --Case insensitive searching UNLESS /C or capital in search
  vim.o.ignorecase = true
  vim.o.smartcase = true

  --Decrease update time
  vim.o.updatetime = 250
  vim.wo.signcolumn = 'yes'

  --Set colorscheme (order is important here)
  vim.g.tokyonight_style = 'night'
  vim.g.tokyonight_italic_functions = true
  vim.o.termguicolors = true
  vim.cmd [[colorscheme tokyonight]]

  --Remap space as leader key
  vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  --Remap for dealing with word wrap
  vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
  vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

  --Remap escape to leave terminal mode
  vim.api.nvim_set_keymap('t', '<Esc>', [[<c-\><c-n>]], { noremap = true })

  --Add map to enter paste mode
  vim.o.pastetoggle = '<F3>'

  --Map blankline
  vim.g.indent_blankline_char = '┊'
  vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
  vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
  vim.g.indent_blankline_char_highlight = 'LineNr'

  -- Toggle to disable mouse mode and indentlines for easier paste
  ToggleMouse = function()
    if vim.o.mouse == 'a' then
      vim.cmd [[IndentBlanklineDisable]]
      vim.wo.signcolumn = 'no'
      vim.o.mouse = 'v'
      vim.wo.number = false
      print 'Mouse disabled'
    else
      vim.cmd [[IndentBlanklineEnable]]
      vim.wo.signcolumn = 'yes'
      vim.o.mouse = 'a'
      vim.wo.number = true
      print 'Mouse enabled'
    end
  end

  vim.api.nvim_set_keymap('n', '<F10>', '<cmd>lua ToggleMouse()<cr>', { noremap = true })

  -- Telescope
  require('telescope').setup {
    defaults = {
      mappings = {
        i = {
          ['<C-u>'] = false,
          ['<C-d>'] = false,
        },
      },
      file_ignore_patterns = { "node_modules", "target"},
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case"
          }
        }
    },
  }
  require('telescope').load_extension('dap')
  require('telescope').load_extension('fzf')
  require('telescope').load_extension('scaladex')

  --Add leader shortcuts
  vim.api.nvim_set_keymap('n', '<leader>f', [[<cmd>lua require('telescope.builtin').find_files()<cr>]], { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader><space>', [[<cmd>lua require('telescope.builtin').buffers()<cr>]], { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>l', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>]], { noremap = true, silent = true })
  -- vim.api.nvim_set_keymap('n', '<leader>t', [[<cmd>lua require('telescope.builtin').tags()<cr>]], { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<cr>]], { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>sd', [[<cmd>lua require('telescope.builtin').grep_string()<cr>]], { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>sp', [[<cmd>lua require('telescope.builtin').live_grep()<cr>]], { noremap = true, silent = true })
  -- vim.api.nvim_set_keymap('n', '<leader>o', [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<cr>]], { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>gco', [[<cmd>lua require('telescope.builtin').git_commits()<cr>]], { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>gb', [[<cmd>lua require('telescope.builtin').git_branches()<cr>]], { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>gs', [[<cmd>lua require('telescope.builtin').git_status()<cr>]], { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>gp', [[<cmd>lua require('telescope.builtin').git_bcommits()<cr>]], { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>m', [[<cmd>lua require('nvim-tree').toggle()<cr>]], { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>ng', [[<cmd>lua require('neogit').open({ kind = "split" })<cr>]], { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>nm', [[<cmd>lua require("telescope").extensions.metals.commands()<cr>]], { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>tt', [[<cmd>lua require("metals.tvp").toggle_tree_view()<cr>]], { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>tr', [[<cmd>lua require("metals.tvp").reveal_in_tree()<cr>]], { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>ws', [[<cmd>lua require"metals".worksheet_hover()<cr>]], { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>a', [[<cmd>lua RELOAD("metals").open_all_diagnostics()<cr>]], { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>nu', ':PackerUpdate<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>si', [[<cmd>lua require('telescope').extensions.scaladex.scaladex.search()<cr>]], { noremap = true, silent = true })

  -- Change preview window location
  vim.g.splitbelow = true

  -- Highlight on yank
  vim.api.nvim_exec(
    [[
    augroup YankHighlight
      autocmd!
      autocmd TextYankPost * silent! lua vim.highlight.on_yank()
    augroup end
  ]],
    false
  )

  -- Y yank until the end of line
  vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true })
  --
  -- LSP settings
  local nvim_lsp = require 'lspconfig'
  local on_attach = function(_client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gm', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'dr', [[<cmd>lua require('dap').repl.toggle()<cr>]], { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'ds', [[<cmd>lua require('dap').ui.variables.scopes()<cr>]], { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'dk', [[<cmd>lua require('dap').ui.widgets.hover()<cr>]], { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'dl', [[<cmd>lua require('dap').run_last()<cr>]], { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'dz', [[<cmd>lua require('dap').toggle_breakpoint()<cr>]], { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'dc', [[<cmd>lua require('dap').continue()<cr>]], { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<F7>', [[<cmd>lua require('dap').step_over()<cr>]], { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<F6>', [[<cmd>lua require('dap').step_out()<cr>]], { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<F5>', [[<cmd>lua require('dap').step_into()<cr>]], { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'B', [[<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>]], { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'lp', [[<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>]], { noremap = true, silent = true })
  end

  -- Enable the following language servers
  local servers = { 'hls', 'html', 'jdtls', 'jsonls', 'pyright', 'rnix', 'rust_analyzer','sourcekit', 'tsserver', 'yamlls' }
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup { on_attach = on_attach }
  end

  -- lua language server
  local sumneko_binary = vim.fn.getenv 'HOME' .. '/.nix-profile/bin/lua-language-server'
  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')

  local luadev = require('lua-dev').setup{
    lspconfig = {
      cmd = { sumneko_binary },
      commands = {
        Format = {
          function()
            require('stylua-nvim').format_file()
          end,
        },
      },
      on_attach = on_attach,
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
            -- Setup your lua path
            path = runtime_path,
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { 'vim' },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = {
              vim.api.nvim_get_runtime_file('', true),
            },
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      },
    },
  }
  nvim_lsp.sumneko_lua.setup(luadev)

  -- metals
  vim.g.metals_server_version = '0.11.9'
  local metals_config = require('metals').bare_config()
  metals_config.settings = {
    showImplicitArguments = true,
    showInferredType = true,
    bloopSbtAlreadyInstalled = false,
    excludedPackages = {
      "akka.actor.typed.javadsl",
      "com.github.swagger.akka.javadsl",
      "akka.stream.javadsl",
    },
    fallbackScalaVersion = "2.13.8",
    superMethodLensesEnabled = true,
    javaHome = "/Users/salar/.nix-profile"
  }
  metals_config.init_options.statusBarProvider = 'on'
  metals_config.on_attach = function(client, bufnr)
   vim.cmd([[autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()]])
   vim.cmd([[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]])
   vim.cmd([[autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()]])

   require("metals").setup_dap()
  end
  metals_config.init_options.statusBarProvider = "on"
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  metals_config.capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
  local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "scala", "sbt" },
    callback = function()
      require("metals").initialize_or_attach(metals_config)
    end,
    group = nvim_metals_group,
  })

  -- Map :Format to vim.lsp.buf.formatting()
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]

  -- Set completeopt to have a better completion experience
  vim.o.completeopt = 'menuone,noinsert'

  -- nvim-cmp
  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  local cmp = require("cmp")
  cmp.setup {
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    sources = {
      { name = "nvim_lsp", priority = 10 },
      { name = "buffer" },
      { name = "luasnip" },
      { name = "cmp_tabnine" },
      { name = "path" },
      { name = 'nvim_lua' },
      { name = 'nvim_lsp_signature_help' }
    },
    mapping = cmp.mapping.preset.insert({
      -- None of this made sense to me when first looking into this since there
      -- is no vim docs, but you can't have select = true here _unless_ you are
      -- also using the snippet stuff. So keep in mind that if you remove
      -- snippets you need to remove this select
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      -- I use tabs... some say you should stick to ins-completion but this is just here as an example
      ["<Tab>"] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end,
      ["<S-Tab>"] = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end,
    }),
  }
  cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
  )
--

  local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end

  local check_back_space = function()
    local col = vim.fn.col '.' - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match '%s' then
      return true
    else
      return false
    end
  end

  -- Use (s-)tab to:
  --- move to prev/next item in completion menuone
  --- jump to prev/next snippet's placeholder
  _G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
      return t '<C-n>'
    elseif check_back_space() then
      return t '<Tab>'
    else
      return vim.fn['cmp#complete']()
    end
  end
  _G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
      return t '<C-p>'
    else
      return t '<S-Tab>'
    end
  end

  vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.tab_complete()', { expr = true })
  vim.api.nvim_set_keymap('s', '<Tab>', 'v:lua.tab_complete()', { expr = true })
  vim.api.nvim_set_keymap('i', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true })
  vim.api.nvim_set_keymap('s', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true })
end

if fn.isdirectory(install_path) == 0 then
  fn.system { 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path }
  load_plugins()
  require('packer').sync()
  vim.cmd 'autocmd User PackerComplete ++once lua load_config()'
else
  load_plugins()
  _G.load_config()
end
