
" generic configuration {{{
syntax enable             " Enables syntax highlighing
set hidden                " Required to keep multiple buffers open
set encoding=utf-8        " The encoding displayed
set pumheight=10          " Makes popup menu smaller
set fileencoding=utf-8    " The encoding written to file
set ruler              		" Show the cursor position all the time
"set cmdheight=2           " More space for displaying messages
set iskeyword+=-          " treat dash separated words as a word text object"
" Disable mouse input (bc it's annoying as hell with a touch pad)
set mouse=
set splitbelow            " Horizontal splits will automatically be below
set splitright            " Vertical splits will automatically be to the right
set t_Co=256              " Support 256 colors
set conceallevel=0        " So that I can see `` in markdown files
set tabstop=4             " Insert 2 spaces for a tab
set shiftwidth=4          " Number of space characters inserted for indentation
set smarttab              " Makes tabbing smarter will realize you have 2 vs 4
set expandtab             " Converts tabs to spaces
set smartindent           " Makes indenting smart
set autoindent            " Good auto indent
"set cursorline            " Enable highlighting of the current line
set background=dark       " tell vim what the background color looks like
set showtabline=2         " Always show tabs
set updatetime=300        " Faster completion
set timeoutlen=500        " By default timeoutlen is 1000 ms
set formatoptions-=cro    " Stop newline continution of comments
set nohlsearch            " Don't highlight search results
set linebreak             " Wrap at word boundaries, instead of anywhere

" }}}

" plugins {{{
call plug#begin('~/.vim/plugged')

" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'

" Autocompletion framework
Plug 'hrsh7th/nvim-cmp'
" cmp LSP completion
Plug 'hrsh7th/cmp-nvim-lsp'
" cmp Snippet completion
Plug 'hrsh7th/cmp-vsnip'
" cmp Path completion
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
" See hrsh7th other plugins for more great completion sources!

" Adds extra functionality over rust analyzer
Plug 'simrat39/rust-tools.nvim'

" Snippet engine
Plug 'hrsh7th/vim-vsnip'

" Optional
" Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Some color scheme other then default
"Plug 'arcticicestudio/nord-vim'
Plug 'ful1e5/onedark.nvim'

"HTML snippets
Plug 'mattn/emmet-vim'

"Fancy tables
Plug 'dhruvasagar/vim-table-mode'

"Java LSP, because it's *special*
Plug 'mfussenegger/nvim-jdtls'

call plug#end()
" }}}

" theme {{{
" can only be set after plugins are loaded
colorscheme onedark
" }}}

" generic bindings {{{
let mapleader=" "

" edit vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

" source vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>

" }}}

" abbreviations {{{
iabbrev improt import
iabbrev teh the
" }}}

" filetype specific settings {{{
augroup filetype_specific
  autocmd!
  " vim {{{
  autocmd FileType vim :setlocal foldmethod=marker
  " }}}
  " rust {{{
  autocmd FileType rust :setlocal foldmethod=syntax
  " }}}
augroup END
" }}}

" autocompletion & lsp {{{

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

" Configure LSP through rust-tools.nvim plugin.
" rust-tools will configure and enable certain LSP features for us.
" See https://github.com/simrat39/rust-tools.nvim#configuration

lua <<EOF

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
nvim_lsp.bashls.setup{}
nvim_lsp.gopls.setup{}
nvim_lsp.texlab.setup{}
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
  }
}
-- nvim_lsp.jdtls.setup{}

-- Java (jdtls)
-- local config = {
    -- cmd = {'/usr/bin/jdtls'},
    -- root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
-- }
-- require('jdtls').start_or_attach(config)

EOF


" Code navigation shortcuts
" as found in :help lsp
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gR    <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>

" Quick-fix
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>


" Setup Completion
" See https://github.com/hrsh7th/nvim-cmp#basic-configuration
lua <<EOF
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
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
})
EOF

" have a fixed column for the diagnostics to appear in
" this removes the jitter when warnings/errors flow in
set signcolumn=yes

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hover
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })

" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.diagnostic.goto_next()<CR>

" }}}

" telescope {{{
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
" }}}


