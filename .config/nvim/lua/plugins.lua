local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end


return require('packer').startup(function()
  -- packer itself
  use 'wbthomason/packer.nvim'
  
  -- essentials
  use 'tpope/vim-sensible'
  use 'tpope/vim-repeat'
  use 'tpope/vim-sleuth'
  use 'tpope/vim-surround'

  use {
    'junegunn/vim-easy-align',
    config = function()
      local util = require('util')
      util.nmap('ga', '<Plug>(LiveEasyAlign)')
      util.vmap('ga', '<Plug>(LiveEasyAlign)')
    end
  }
  
  -- UI enhancements
  use 'morhetz/gruvbox'
  use {
    'vim-airline/vim-airline',
    config = function()
      vim.g['airline_powerline_fonts'] = 1
      vim.g['airline_section_x'] = vim.call('airline#section#create_right',
        {'tagbar', 'filetype', '%{CodeStatsXp()}'})
    end
  }
  use {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup {}
    end
  }

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function()
      local util = require('util')
      util.nmap('<C-p>', '<cmd>Telescope find_files<CR>')
      util.nmap('<C-f>', '<cmd>Telescope live_grep<CR>')
      util.nmap('<C-h>', '<cmd>Telescope help_tags<CR>')
      util.nmap('<C-b>', '<cmd>Telescope buffers<CR>')
    end
  }

  -- C::S
  use 'https://gitlab.com/code-stats/code-stats-vim.git'

  -- language support
  use 'sheerun/vim-polyglot'

  use {
    'neovim/nvim-lspconfig',
    config = function()
      local nvim_lsp = require('lspconfig')

      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      local on_attach = function(client, bufnr)
        local function buf_set_keymap(lhs, rhs)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', lhs, rhs, { noremap = true, silent = true})
        end

        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        bnmap('gD',        '<cmd>lua vim.lsp.buf.declaration()<CR>')
        bnmap('gd',        '<cmd>lua vim.lsp.buf.definition()<CR>')
        bnmap('K',         '<cmd>lua vim.lsp.buf.hover()<CR>')
        bnmap('gi',        '<cmd>lua vim.lsp.buf.implementation()<CR>')
        bnmap('<C-k>',     '<cmd>lua vim.lsp.buf.signature_help()<CR>')
        bnmap('<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
        bnmap('<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
        bnmap('<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
        bnmap('<space>D',  '<cmd>lua vim.lsp.buf.type_definition()<CR>')
        bnmap('<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
        bnmap('<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
        bnmap('gr',        '<cmd>lua vim.lsp.buf.references()<CR>')
        bnmap('<space>e',  '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
        bnmap('[d',        '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
        bnmap(']d',        '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
        bnmap('<space>q',  '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
        bnmap('<space>f',  '<cmd>lua vim.lsp.buf.formatting()<CR>')
      end

      -- Use a loop to conveniently call 'setup' on multiple servers and
      -- map buffer local keybindings when the language server attaches
      local servers = { 'clangd', 'rust_analyzer' }
      for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
          on_attach = on_attach,
          flags = {
            debounce_text_changes = 150,
          }
        }
      end

    end
  }

  vim.cmd([[autocmd BufWritePost plugins.lua source <afile> | PackerCompile]])
end)
