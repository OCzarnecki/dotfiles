-- Lazy loader {{{
-- Installation {{{
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
-- }}}

-- Plugins {{{
require("lazy").setup({
	"nvim-telescope/telescope.nvim",
        {
            'nvim-orgmode/orgmode', -- {{{
            dependencies = {
              { 'nvim-treesitter/nvim-treesitter', lazy = true },
            },
            event = 'VeryLazy',
            config = function()
              -- Load treesitter grammar for org
              require('orgmode').setup_ts_grammar()

              -- Setup treesitter
              require('nvim-treesitter.configs').setup({
                highlight = {
                  enable = true,
                  additional_vim_regex_highlighting = { 'org' },
                },
                ensure_installed = { 'org' },
              })

              -- Setup orgmode
              require('orgmode').setup({
                org_agenda_files = '~/Sync/orgfiles/**/*',
                org_default_notes_file = '~/Sync/orgfiles/refile.org',
                org_todo_keywords = {
                    "TODO(t)", "WAITING(w!)", "|", "WONTDO(x!)", "DONE(d!)"
                },
                org_log_done = 'note',
                org_log_into_drawer = 'LOGBOOK',
              })
            end, -- }}}
        },
	"nvim-lua/plenary.nvim",
	"neovim/nvim-lspconfig",
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-buffer",
	"hrsh7th/vim-vsnip",
    "simrat39/rust-tools.nvim",
})
-- }}}
-- }}}

-- Basic options {{{
local o = vim.o
o.hlsearch = false
o.expandtab = true
o.tabstop = 4
o.shiftwidth = 4
o.autoindent = true
o.smartindent = true
o.signcolumn = 'yes'  -- You can take the config file out of the vim script...

vim.g.mapleader = " "

-- }}}

-- Filetype specific settings {{{
local autocmd = vim.api.nvim_create_autocmd
autocmd('FileType lua', {
    once = true,
    callback = function(args)
        vim.api.nvim_set_option_value('foldmethod', 'marker', { scope = 'local'})
    end,
})
autocmd('FileType vim', {
    once = true,
    callback = function(args)
        vim.api.nvim_set_option_value('foldmethod', 'marker', { scope = 'local'})
    end,
})
-- }}}

-- cmp setup {{{
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  -- Installed sources
  sources = {
    { name = 'vsnip' },
    { name = 'path' },
    {
        name = 'buffer',
        option = { keyword_pattern = [[\k\+]] },
    },
    { name = 'nvim_lsp' },
  },
})

local cmp_capatilities = require('cmp_nvim_lsp').default_capabilities()

-- }}}

-- LSP config {{{
-- nvim_lsp object
local nvim_lsp = require'lspconfig'

local rust_opts = {
    tools = {
        autoSetHints = true,
        -- deprecated
        -- hover_with_actions = true,
        runnables = {
            use_telescope = true
        },
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        -- on_attach = on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
}

require('rust-tools').setup(rust_opts)
nvim_lsp.bashls.setup{ capabilities = cmp_capatilities }
nvim_lsp.gopls.setup{ capabilities = cmp_capatilities }
nvim_lsp.texlab.setup{ capabilities = cmp_capatilities }
nvim_lsp.pylsp.setup{
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {
            'W503', -- Line break before binary operator
            'W391', -- Blank line at the end of file
            'E265', -- Block comment must start with '# '
            'E501', -- Line too long
            'E701', -- Multiple statements on one line
            'E731', -- Cannot assign λ to variable
            'E741', -- Variables can't be named l or I
          },
        }
      }
    }
  },
  capabilities = cmp_capatilities 
}
-- nvim_lsp.jdtls.setup{}

-- Java (jdtls)
-- local config = {
    -- cmd = {'/usr/bin/jdtls'},
    -- root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
-- }
-- require('jdtls').start_or_attach(config)
-- }}}


-- Mappings {{{
--
local map = vim.api.nvim_set_keymap
options = { noremap = true, silent = true }

-- Generic {{{
map('n', '<leader>ev', '<cmd>vsplit $MYVIMRC<cr>', options)
map('n', '<leader>sv', '<cmd>source $MYVIMRC<cr>', options)
map('i', 'jk', '<Esc>', options)
map('i', 'kj', '<Esc>', options)
-- }}}

-- Telescope {{{
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', options)
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', options)
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>', options)
map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', options)
-- }}}

--  LSP {{{
map('n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', options)
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', options)
map('n', 'gD', '<cmd>lua vim.lsp.buf.implementation()<CR>', options)
map('n', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', options)
map('n', '1gD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', options)
map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', options)
map('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<CR>', options)
map('n', 'g0', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', options)
map('n', 'gW', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', options)
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', options)
map('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', options)
--  }}}

-- Org mode {{{
map('n', '<leader>oW', '<cmd>tabnew $HOME/Sync/orgfiles/main.org<cr>', options)
map('n', '<leader>oR', '<cmd>tabnew $HOME/Sync/orgfiles/refile.org<cr>', options)
-- }}}
-- }}}
