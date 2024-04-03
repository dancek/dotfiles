-- Hannu Hartikainen's Neovim config
-- rewritten in lua in 2021

require('plugins')

local util = require('util')

-- options

vim.opt.softtabstop   = 4
vim.opt.shiftwidth    = 4
vim.opt.expandtab     = true
vim.opt.autoindent    = true

vim.opt.number        = true

vim.opt.mouse         = 'a'

vim.opt.timeoutlen    = 500

vim.opt.termguicolors = true
vim.opt.inccommand    = 'nosplit'

vim.opt.writebackup   = false

vim.opt.helpheight    = 30

vim.opt.pumheight     = 10

---- KEYMAP
-- buffers
util.nmap('<Tab>',   '<cmd>bnext<CR>')
util.nmap('<S-Tab>', '<cmd>bprevious<CR>')
util.nmap('Q',       '<cmd>bdelete<CR>')

-- clipboard
util.map('<C-c>',    '"+y')

-- terminal
-- util.map('~',        '<cmd>:call jobstart(["i3-msg", "exec", "i3-sensible-terminal", getcwd()])<CR>')
util.map('~',        '<cmd>:call jobstart(["swaymsg", "exec", "kitty --single-instance", expand("%:p:h")])<CR>')

----
vim.cmd([[
  colorscheme gruvbox

  runtime _secrets.vim
]])

-- Ensure conjure logs don't get clojure-lsp
vim.api.nvim_create_autocmd("BufNewFile", {
  group = vim.api.nvim_create_augroup("conjure_log_disable_lsp", { clear = true }),
  pattern = { "conjure-log-*" },
  callback = function() vim.diagnostic.disable(0) end,
  desc = "Conjure Log disable LSP diagnostics",
})


-- Set filetype mappings I'm having trouble with
vim.filetype.add({
  extension = {
    bqn = "bqn",
    phtml = "slim",
  }
})
