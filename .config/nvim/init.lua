-- Hannu Hartikainen's Neovim config
-- rewritten in lua in 2021

require('plugins')

local util = require('util')

-- options

vim.opt.softtabstop   = 4
vim.opt.shiftwidth    = 4
vim.opt.expandtab     = true
vim.opt.autoindent    = true

vim.opt.mouse         = 'a'

vim.opt.timeoutlen    = 500

vim.opt.termguicolors = true
vim.opt.inccommand    = 'nosplit'

vim.opt.writebackup   = false

---- KEYMAP
-- buffers
util.nmap('<Tab>',   '<cmd>bnext<CR>')
util.nmap('<S-Tab>', '<cmd>bprevious<CR>')
util.nmap('Q',       '<cmd>bdelete<CR>')

-- clipboard
util.map('<C-c>',    '"+y')

vim.cmd([[
  colorscheme gruvbox

  runtime _secrets.vim
]])

