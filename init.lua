local ok, secrets = pcall(require, "config.secrets")
if not ok then secrets = {} end

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
    "dhruvasagar/vim-table-mode",
	"nvim-telescope/telescope.nvim",
	"nvim-orgmode/telescope-orgmode.nvim",
    {
        'nvim-orgmode/orgmode', -- {{{
        event = 'VeryLazy',
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
          -- Setup orgmode
          require('orgmode').setup({
            org_agenda_files = '~/Sync/orgfiles/**/*',
            org_capture_templates = {
                t = {
                    description = 'Task',
                    template = '* TODO %?\n %u',
                },
                f = {
                    description = 'Forecast',
                    template = '\n  :FORECAST:\n  :TITLE: %^{Question|Question}\n  :CHOICES:  %^{Choices|binary}\n  :PREDICTION: %U %?\n  :END:',
                    target = '~/Sync/orgfiles/forecasts.org',
                    headline = "Forecasts to Refile"
                },
            },
            org_default_notes_file = '~/Sync/orgfiles/refile.org',
            org_todo_keywords = {
                "TODO(t)", "WAITING(w!)", "|", "WONTDO(x!)", "DONE(d!)"
            },
            org_log_done = 'note',
            -- org_log_into_drawer = 'LOGBOOK',
          })
        end, -- }}}
    },
	"nvim-lua/plenary.nvim",
	"neovim/nvim-lspconfig",
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-emoji",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-buffer",
	"hrsh7th/vim-vsnip",
    -- "simrat39/rust-tools.nvim",
    "pasky/claude.vim",
    "windwp/nvim-autopairs",
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
o.shortmess = o.shortmess .. "I"

vim.g.mapleader = " "

-- }}}

-- Filetype specific settings {{{
local autocmd = vim.api.nvim_create_autocmd
autocmd('FileType', {
    pattern = 'lua',
    once = true,
    callback = function(args)
        vim.api.nvim_set_option_value('foldmethod', 'marker', { scope = 'local'})
    end,
})
autocmd('FileType', {
    pattern = 'vim',
    once = true,
    callback = function(args)
        vim.api.nvim_set_option_value('foldmethod', 'marker', { scope = 'local'})
    end,
})
autocmd('FileType', {
    pattern = 'org',
    once = true,
    callback = function(args)
        vim.api.nvim_set_option_value('foldtext', "v:folddashes.substitute(getline(v:foldstart),'^*\\+','','g')", { scope = 'local'})
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
    { name = 'orgmode' },
    { name = 'emoji' },
  },
})

local cmp_capatilities = require('cmp_nvim_lsp').default_capabilities()

-- }}}

-- LSP config {{{
-- vim.lsp.config (nvim 0.11+)
vim.lsp.config('*', { capabilities = cmp_capatilities })

vim.lsp.config('rust_analyzer', {
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = {
                command = "clippy"
            },
        }
    }
})

vim.lsp.config('pylsp', {
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
                        'E704', -- Multiple statements on one line
                        'E731', -- Cannot assign λ to variable
                        'E741', -- Variables can't be named l or I
                    },
                }
            }
        }
    },
})

vim.lsp.enable({
    'bashls', 'gopls', 'texlab', 'ts_ls', 'astro',
    'rust_analyzer', 'pylsp', 'kotlin_language_server',
})

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
map('n', '<leader>ev', '<cmd>tabnew $MYVIMRC<cr>', options)
map('n', '<leader>sv', '<cmd>source $MYVIMRC<cr>', options)
map('v', '<C-c>', '"+y', options)
map('i', 'jk', '<Esc>', options)
map('i', 'kj', '<Esc>', options)

vim.keymap.set("n", "<leader>gb", function()
  local file = vim.fn.expand("%")
  if file == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end
  vim.cmd("tabnew")
  vim.cmd("read !git blame " .. vim.fn.shellescape(file))
  vim.bo.buftype = "nofile"
  vim.bo.modifiable = false
  vim.bo.filetype = "fugitiveblame"
end, { desc = "Git blame in new tab" })
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

vim.keymap.set('i', '<C-Return>', '<cmd>lua require("orgmode").action("org_mappings.meta_return")<CR>')

local ts = require('telescope')
ts.setup()
ts.load_extension('orgmode')
vim.keymap.set('n', '<leader>r', ts.extensions.orgmode.refile_heading)
vim.keymap.set('n', '<leader>fo', ts.extensions.orgmode.search_headings)
vim.keymap.set('n', '<leader>li', ts.extensions.orgmode.insert_link)

-- }}}

-- Claude Code {{{
local function spawn_claude()
  local selection = nil
  if vim.fn.mode():match("[vV\22]") then
    local start_pos = vim.fn.getpos("v")
    local end_pos = vim.fn.getpos(".")
    local lines = vim.fn.getregion(start_pos, end_pos, { type = vim.fn.mode() })
    selection = table.concat(lines, "\n")
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
  end

  vim.ui.input({ prompt = "Claude prompt: " }, function(input)
    if not input or input == "" then return end

    local prompt = input
    local filepath = vim.api.nvim_buf_get_name(0)
    if filepath ~= "" then
      prompt = prompt .. "\n\nThe user had the following file open: " .. vim.fn.fnamemodify(filepath, ":p")
        .. "\nNote that the user's query could be general and not related to the current file."
    end
    if selection then
      prompt = prompt .. "\n\nThe user had the following text selected:\n```\n" .. selection .. "\n```"
    end

    vim.fn.jobstart({ "/Users/olaf/dev/scripts/spawn-claude", prompt }, { detach = true })
  end)
end

vim.keymap.set({"n", "v"}, "<leader>gc", spawn_claude, { desc = "Spawn Claude with prompt" })
-- }}}
-- }}}


-- Claude {{{
-- vim.g.claude_api_key = secrets.claude_api_key
-- }}}

-- Autopairs {{{
require("nvim-autopairs").setup {}
-- }}}
