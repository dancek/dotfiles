-- Hannu Hartikainen's Neovim config
-- rewritten in lua in 2021

local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end

vim.opt.softtabstop   = 4
vim.opt.shiftwidth    = 4
vim.opt.expandtab     = true
vim.opt.autoindent    = true

vim.opt.mouse         = 'a'

vim.opt.timeoutlen    = 500

vim.opt.termguicolors = true
vim.opt.inccommand    = 'nosplit'

require('plugins')

vim.cmd([[
  colorscheme gruvbox

  runtime _secrets.vim

  nmap <Tab> :bnext<CR>
  nmap <S-Tab> :bprevious<CR>
  nmap Q :bdelete<CR>

  " Ctrl-c for system clipboard
  map <C-c> "+y

  """ vim-airline
  let g:airline_powerline_fonts = 1
  let g:airline_section_x = airline#section#create_right(['tagbar', 'filetype', '%{CodeStatsXp()}'])

  """ fzf.vim
  nmap <c-p> :Files<CR>
  nmap <c-h> :Helptags<CR>
  nmap <c-f> :Lines<CR>
  nmap <c-b> :Buffers<CR>

  """ vim-easy-align
  " Start interactive EasyAlign in visual mode (e.g. vipga)
  xmap ga <Plug>(EasyAlign)

  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap ga <Plug>(EasyAlign)
]])

