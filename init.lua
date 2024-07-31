local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

require("lazy").setup({
  {'nvim-telescope/telescope.nvim',
   tag = '0.1.5',
   dependencies = { 'nvim-lua/plenary.nvim' },
   lazy = false},
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      color_overrides = {
        mocha = {
          base = "#000000",
          mantle = "#000000",
          crust = "#000000"
        }
      }
    }
  },
  {"nvim-treesitter/nvim-treesitter",
   build = ":TSUpdate",
   config = function ()
     local configs = require("nvim-treesitter.configs")
     configs.setup({
       ensure_installed = { "c", "lua", "vim", "vimdoc", "python", "verilog", "mlir" },
       sync_install = false,
       auto_install = true,
       highlight = { enable = true },
       indent = { enable = true }
     })
   end},
  {"hrsh7th/nvim-cmp",
   event = "InsertEnter",
   dependencies = {
     "hrsh7th/cmp-cmdline",
     "hrsh7th/cmp-path",
     "hrsh7th/cmp-buffer",
     "hrsh7th/cmp-nvim-lsp",
     "hrsh7th/nvim-lspconfig",
     "L3MON4D3/LuaSnip",
     "saadparwaiz1/cmp_luasnip"
   },
   config = function ()
     local cmp = require("cmp")
     cmp.setup({
       snippet = {
         expand = function(args)
           require('luasnip').lsp_expand(args.body)
         end,
       },
       mapping = cmp.mapping.preset.insert({
         ['<C-b>'] = cmp.mapping.scroll_docs(-4),
         ['<C-f>'] = cmp.mapping.scroll_docs(4),
         ['<C-Space>'] = cmp.mapping.complete(),
         ['<C-e>'] = cmp.mapping.abort(),

         --['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
       }),
       sources = cmp.config.sources({
         { name = 'nvim_lsp' },

         -- { name = 'vsnip' }, -- For vsnip users.
         { name = 'luasnip' }, -- For luasnip users.
         -- { name = 'ultisnips' }, -- For ultisnips users.
         -- { name = 'snippy' }, -- For snippy users.
       }, {

         { name = 'buffer' },
       })
     })

     -- Set configuration for specific filetype.
     cmp.setup.filetype('gitcommit', {
       sources = cmp.config.sources({
         { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
       }, {

         { name = 'buffer' },
       })
     })

     -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
     cmp.setup.cmdline({ '/', '?' }, {

       mapping = cmp.mapping.preset.cmdline(),

       sources = {
         { name = 'buffer' }
       }
     })

     -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
     cmp.setup.cmdline(':', {
       mapping = cmp.mapping.preset.cmdline(),
       sources = cmp.config.sources({
         { name = 'path' }
       }, {
         { name = 'cmdline' }
       })
     })

     -- Set up lspconfig.
     local capabilities = require('cmp_nvim_lsp').default_capabilities()
   end
  },
  -- {"cappyzawa/trim.nvim", opts = {ft_blocklist = {"markdown"}}},
  {"numToStr/Comment.nvim", lazy = false},
  {
    'stevearc/overseer.nvim',
    opts = {},
  },
  {"m4xshen/autoclose.nvim"},
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
  	-- install jsregexp (optional!).
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
  },
  {'shaunsingh/nord.nvim'},
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
  },
  {
    "willothy/flatten.nvim",
    config = true,
    -- Ensure that it runs first to minimize delay when opening file from terminal
    lazy = false,
    priority = 1001,
  },
  {
  "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = true
  },
  {
    "lewis6991/gitsigns.nvim"
  }
})

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.api.nvim_create_autocmd(
  'Filetype', {
    pattern = { 'python' },
    command = 'setlocal tabstop=4 softtabstop=4 shiftwidth=4'
  }
)
vim.opt.smarttab = true
vim.opt.expandtab = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.cmd.colorscheme "catppuccin-mocha"
require('lualine').setup()

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.git_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

vim.env.GIT_EDITOR = 'nvr -cc split --remote-wait'

vim.api.nvim_create_autocmd(
  'FileType',
  {pattern={'gitcommit', 'gitrebase', 'gitconfig'},
   command=[[set bufhidden=delete]]}
)

-- Global mapping
-- See `:help vim.diagnostic.*` for documentation on any of the below functions

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)


require('lspconfig')['pylsp'].setup {
  settings = {
    pylsp = {
      plugins = {
        ruff = {
          enabled = true,
          formatEnabled = true,
        }
      }
    }
  }
}
require('lspconfig')['texlab'].setup {}
require('lspconfig')['clangd'].setup {}

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()

      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

require('Comment').setup()

-- Use system clipboard / WSL fix
if vim.fn.has('wsl') == 1 then
    vim.g.clipboard = {
        name = 'WslClipboard',
        copy = {
            ['+'] = 'clip.exe',
            ['*'] = 'clip.exe',
        },
        paste = {
            ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        },
        cache_enabled = 0,
    }
end

require('overseer').setup()
require('autoclose').setup()

ls = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, {silent = true})

require('gitsigns').setup{
  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({']c', bang = true})
      else
        gitsigns.nav_hunk('next')
      end
    end)

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({'[c', bang = true})
      else
        gitsigns.nav_hunk('prev')
      end
    end)

    -- Actions
    map('n', '<leader>hs', gitsigns.stage_hunk)
    map('n', '<leader>hr', gitsigns.reset_hunk)
    map('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('n', '<leader>hS', gitsigns.stage_buffer)
    map('n', '<leader>hu', gitsigns.undo_stage_hunk)
    map('n', '<leader>hR', gitsigns.reset_buffer)
    map('n', '<leader>hp', gitsigns.preview_hunk)
    map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end)
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
    map('n', '<leader>hd', gitsigns.diffthis)
    map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
    map('n', '<leader>td', gitsigns.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
