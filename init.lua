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

require("lazy").setup(
    {
	"nvim-telescope/telescope.nvim",
        {
            'nvim-orgmode/orgmode',
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
                org_agenda_files = '~/Documents/orgfiles/**/*',
                org_default_notes_file = '~/Documents/orgfiles/refile.org',
              })
            end,
        }
    }
)


local o = vim.o
vim.g.mapleader = " "

local map = vim.api.nvim_set_keymap
options = { noremap = true }
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', options)
