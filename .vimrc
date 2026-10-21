let $MYVIMRC = expand('~/.vimrc')
if !has('nvim')
  unlet! skip_defaults_vim
  source $VIMRUNTIME/defaults.vim
endif

" Appearance
set termguicolors background=dark
if !has('nvim')
  colorscheme habamax
endif
set number signcolumn=yes laststatus=2
set statusline=%{fnamemodify(expand('%:p'),':~:.')}\ %h%w%m%r%=%-14.(%l,%c%V%)\ %P
set mouse= scrolloff=4 splitright splitbelow
set jumpoptions+=stack

" Editing
set clipboard=unnamedplus
set expandtab shiftwidth=4 tabstop=4
set completeopt=menuone,noselect,popup
set undofile
if !has('nvim')
  set undodir=~/.vim/undo directory=~/.vim/swap//
  call mkdir(expand('~/.vim/undo'), 'p', 0700)
  call mkdir(expand('~/.vim/swap'), 'p', 0700)
endif

" Search
set ignorecase smartcase hlsearch
set wildoptions=pum,fuzzy

" Maps
let mapleader = ' '
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR>    complete_info(['selected']).selected != -1 ? "\<C-y>" : "\<CR>"

if !has('nvim')
  finish
endif

lua << EOF
-- Plugins
vim.pack.add({
  'https://github.com/navarasu/onedark.nvim',
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/nvim-treesitter/nvim-treesitter',
}, { confirm = false })

-- Colorscheme
require('onedark').setup({
  style = 'dark',
  colors = {
    fg = '#ffffff',
    bg0 = '#21252b',
    red = '#e06c75',
  },
  highlights = {
    Visual = { bg = '#323844' },
    Cursor = { fg = '#000000', bg = '#abb2bf' },
    Comment = { fg = '#9aa3b0' },
    SpecialComment = { fg = '#9aa3b0' },
    ['@comment'] = { fg = '#9aa3b0' },
    ['@comment.documentation'] = { fg = '#9aa3b0' },
  },
})
vim.cmd.colorscheme('onedark')
require('lualine').setup({
  options = { theme = 'onedark' },
  sections = {
    lualine_b = {
      {
        'branch',
        fmt = function(name)
          if #name > 10 then
            return name:sub(-10)
          end
          return string.rep(' ', 10 - #name) .. name
        end,
      },
      'diff',
      'diagnostics',
    },
    lualine_c = { { 'filename', path = 1 } },
  },
})

-- Fuzzy search
vim.keymap.set('n', '<leader>f', '<cmd>FzfLua files<CR>')
vim.keymap.set('n', '<leader>/', '<cmd>FzfLua live_grep<CR>')

-- Treesitter
require('nvim-treesitter').install({ 'go', 'python', 'rust' })
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go', 'python', 'rust' },
  callback = function()
    vim.treesitter.start()
  end,
})

EOF
