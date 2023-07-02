vim.o.termguicolors = true
vim.cmd.colorscheme 'kanagawa-lotus'
vim.o.syntax = 'on'
vim.o.errorbells = false
vim.o.smartcase = true
vim.o.showmode = false
vim.bo.swapfile = false
vim.o.backup = false
vim.o.undodir = vim.fn.stdpath('config') .. '/undodir'
vim.o.undofile = true
vim.o.incsearch = true
vim.o.hidden = true
vim.o.completeopt='menuone,noinsert,noselect'
vim.bo.autoindent = true
vim.bo.smartindent = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.wo.number = true
vim.wo.signcolumn = 'yes'
vim.wo.wrap = false
vim.api.nvim_set_option("clipboard","unnamed")

local vim = vim
local execute = vim.api.nvim_command
local fn = vim.fn
-- ensure that packer is installed
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
    execute 'packadd packer.nvim'
end
vim.cmd('packadd packer.nvim')
local packer = require'packer'
local util = require'packer.util'
packer.init({
  package_root = util.join_paths(vim.fn.stdpath('data'), 'site', 'pack')
})
--- startup and add configure plugins
packer.startup(function()
  local use = use
  	use 'nvim-tree/nvim-tree.lua'
	use "savq/melange-nvim"
  use "rebelot/kanagawa.nvim"
  use "neanias/everforest-nvim"

	use {
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v1.x',
	  requires = {
		  -- LSP Support
		  {'neovim/nvim-lspconfig'},
		  {'williamboman/mason.nvim'},
		  {'williamboman/mason-lspconfig.nvim'},

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},
		  {'hrsh7th/cmp-buffer'},
		  {'hrsh7th/cmp-path'},
		  {'saadparwaiz1/cmp_luasnip'},
		  {'hrsh7th/cmp-nvim-lsp'},
		  {'hrsh7th/cmp-nvim-lua'},

		  -- Snippets
		  {'L3MON4D3/LuaSnip'},
		  {'rafamadriz/friendly-snippets'},
	  }
  }

  use({
    'jose-elias-alvarez/null-ls.nvim',
    event = 'BufRead',
    requires = {
      {"nvim-lua/plenary.nvim"},
    },
    config = function()
      local nls = require('null-ls')

      local fmt = nls.builtins.formatting
      local dgn = nls.builtins.diagnostics

      -- Configuring null-ls
      nls.setup({
          sources = {
              -- # FORMATTING #
              fmt.trim_whitespace.with({
                  filetypes = { 'text', 'sh', 'zsh', 'toml', 'make', 'conf', 'tmux' },
              }),
              -- NOTE:
              -- 1. both needs to be enabled to so prettier can apply eslint fixes
              -- 2. prettierd should come first to prevent occassional race condition
              fmt.prettierd,
              fmt.eslint_d,
              -- fmt.prettier.with({
              --     extra_args = {
              --         '--tab-width=4',
              --         '--trailing-comma=es5',
              --         '--end-of-line=lf',
              --         '--arrow-parens=always',
              --     },
              -- }),
              fmt.rustfmt,
              fmt.stylua,
              fmt.gofmt,
              fmt.shfmt.with({
                  extra_args = { '-i', 4, '-ci', '-sr' },
              }),
              -- # DIAGNOSTICS #
              dgn.eslint_d,
              dgn.shellcheck,
              dgn.luacheck.with({
                  extra_args = { '--globals', 'vim', '--std', 'luajit' },
              }),
          },
          on_attach = function(client, bufnr)
              fmt_on_save(client, bufnr)
          end,
      })
    end,
  })

  end
)

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  on_attach = nvim_tree_on_attac,
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
    icons = {
      show = {
        file = false,
        folder = false,
      },
    },
  },
  filters = {
    dotfiles = true,
  },
})

-- Open nvim tree on start
local api = require "nvim-tree.api"
api.tree.open()

function fmt_on_save(client, buf)
    if client.supports_method('textDocument/formatting') then
        vim.api.nvim_create_autocmd('BufWritePre', {
            group = fmt_group,
            buffer = buf,
            callback = function()
                vim.lsp.buf.format({
                    timeout_ms = 3000,
                    buffer = buf,
                })
            end,
        })
    end
end
