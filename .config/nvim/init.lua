-- Hannu Hartikainen's Neovim config
--
-- written in ancient times
-- edited slowly over time
-- added to version control in 2010
-- adapted for Neovim in 2017
-- rewritten in lua in 2021
-- modernized in 2026

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require('plugins')

-- options

vim.opt.softtabstop   = 4
vim.opt.shiftwidth    = 4
vim.opt.expandtab     = true

vim.opt.number        = true

vim.opt.timeoutlen    = 500

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
vim.keymap.set("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "Q", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- clipboard
vim.keymap.set({ "n", "v" }, "<C-c>", '"+y', { desc = "Copy to system clipboard" })

-- terminal
vim.keymap.set("n", "~", function()
  vim.fn.jobstart({ "swaymsg", "exec", "kitty --single-instance", vim.fn.expand("%:p:h") }, { detach = true })
end, { desc = "Open kitty terminal in buffer directory" })

----
vim.cmd([[
  colorscheme gruvbox

  runtime _secrets.vim
]])

-- Ensure conjure logs don't get clojure-lsp
vim.api.nvim_create_autocmd("BufNewFile", {
  group = vim.api.nvim_create_augroup("conjure_log_disable_lsp", { clear = true }),
  pattern = { "conjure-log-*" },
  callback = function(args)
    vim.diagnostic.enable(false, { bufnr = args.buf })
  end,
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


-- Neovide copy+paste
if vim.g.neovide then
  local copy_key
  local paste_key

  if (vim.uv or vim.loop).os_uname().sysname == "Darwin" then
    copy_key = "<D-c>"
    paste_key = "<D-v>"
  else
    copy_key = "<C-S-c>"
    paste_key = "<C-S-v>"
  end

  vim.keymap.set("v", copy_key, '"+y', { desc = "Copy to system clipboard" })
  vim.keymap.set({ "n", "v" }, paste_key, '"+P', { desc = "Paste from system clipboard" })
  vim.keymap.set({ "i", "c" }, paste_key, "<C-R>+", { desc = "Paste from system clipboard" })
end


-- read local config if exists
local local_config_path = vim.fn.expand('~/.nvim.local.lua')

if vim.fn.filereadable(local_config_path) == 1 then
  dofile(local_config_path)
end
