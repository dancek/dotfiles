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

-- neovide GUI config
vim.opt.guifont                         = "Cascadia Code NF:h10"
vim.g.neovide_position_animation_length = 0.07
vim.g.neovide_scroll_animation_length   = 0.10
vim.g.neovide_hide_mouse_when_typing = true

vim.opt.winblend = 20
vim.opt.pumblend = 20

vim.g.neovide_scale_factor = 1.0
local change_scale_factor = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end
vim.keymap.set("n", "<C-=>", function()
  change_scale_factor(1.05)
end)
vim.keymap.set("n", "<C-->", function()
  change_scale_factor(1/1.05)
end)
vim.keymap.set("n", "<C-0>", function()
  vim.g.neovide_scale_factor = 1.0
end)


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
  callback = function() vim.diagnostic.enable(false) end,
  desc = "Conjure Log disable LSP diagnostics",
})


-- Set filetype mappings I'm having trouble with
vim.filetype.add({
  extension = {
    bqn = "bqn",
    phtml = "slim",
    mdx = "jsx",
  }
})
