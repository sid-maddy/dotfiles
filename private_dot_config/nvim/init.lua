local option = vim.opt

vim.keymap.set('n', '<Space>', '<Nop>', { remap = false, silent = true })
vim.g.mapleader = ' '
require('plugins')

local vimp = require('vimp')

-- TODO: Split these into annotated groups.
option.backup = false
option.clipboard = option.clipboard + 'unnamedplus'
option.cmdheight = 1
option.confirm = true
option.cursorline = true
option.expandtab = true
option.fillchars = option.fillchars + { eob = ' ' }
option.ignorecase = true
option.laststatus = 3
option.mouse = 'a'
option.swapfile = false
option.number = true
option.relativenumber = true
option.signcolumn = 'number'
option.shiftwidth = 4
option.shortmess = option.shortmess + 'c'
option.splitbelow = true
option.splitright = true
option.tabstop = 4
option.termguicolors = true
option.timeoutlen = 300
option.updatetime = 300
option.winminheight = 0
option.wrap = false
option.writebackup = false

-- Easy writing
vimp.noremap('<Leader>w', ':w<CR>')

-- Easy closing
vimp.noremap('<Leader>x', ':bd<CR>')

-- Easy clearing of search highlights
vimp.noremap('<Leader><CR>', function() option.hlsearch = false end)

-- Easy escaping the terminal
vimp.tnoremap('<Esc>', '<C-\\><C-n>')

-- Easy navigation in any mode
-- TODO: Use vimp.bind
-- TODO: Add source
vimp.tnoremap('<A-h>', '<C-\\><C-N><C-w>h')
vimp.tnoremap('<A-j>', '<C-\\><C-N><C-w>j')
vimp.tnoremap('<A-k>', '<C-\\><C-N><C-w>k')
vimp.tnoremap('<A-l>', '<C-\\><C-N><C-w>l')
vimp.inoremap('<A-h>', '<C-\\><C-N><C-w>h')
vimp.inoremap('<A-j>', '<C-\\><C-N><C-w>j')
vimp.inoremap('<A-k>', '<C-\\><C-N><C-w>k')
vimp.inoremap('<A-l>', '<C-\\><C-N><C-w>l')
vimp.nnoremap('<A-h>', '<C-w>h')
vimp.nnoremap('<A-j>', '<C-w>j')
vimp.nnoremap('<A-k>', '<C-w>k')
vimp.nnoremap('<A-l>', '<C-w>l')
