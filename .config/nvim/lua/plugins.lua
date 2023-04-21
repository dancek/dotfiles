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
  use 'tpope/vim-commentary'

  use {
    'junegunn/vim-easy-align',
    config = function()
      local util = require('util')
      util.nmap('ga', '<Plug>(LiveEasyAlign)')
      util.vmap('ga', '<Plug>(LiveEasyAlign)')
    end
  }

  -- autosave
  use {
    'Pocco81/auto-save.nvim',
    config = function()
      require('auto-save').setup {
      }
    end
  }

  -- UI enhancements
  use 'morhetz/gruvbox'
  use {
    'vim-airline/vim-airline',
    config = function()
      vim.g['airline_powerline_fonts'] = 1
      vim.g['airline_section_x'] = vim.call('airline#section#create_right',
        {'tagbar', 'filetype'})
    end
  }
  use {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup {}
    end
  }
  use 'mg979/vim-visual-multi'

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

      require("telescope").setup {
        pickers = {
          buffers = {
            mappings = {
              i = {
                ["<C-d>"] = "delete_buffer",
              }
            }
          }
        }
      }
    end
  }

  -- C::S
  -- use 'https://gitlab.com/code-stats/code-stats-vim.git'

  -- BQN
  use {
    'mlochbaum/BQN',
    rtp = 'editors/vim/',
    -- config = function()
    --   vim.cmd([[autocmd BufRead,BufNewFile *.bqn setf bqn]])
    -- end
  }
  use {
    'https://git.sr.ht/~detegr/nvim-bqn',
    config = function()
      local util = require('util')
      -- util.nmap('<C-Space>', '<cmd>BQNEvalFile<CR>')
      util.nmap('<Space>', '<cmd>BQNClearFile<CR>')
    end
  }

  -- completion
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require('cmp')
      cmp.setup {
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<Tab>'] = cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
            }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          }),
        sources = cmp.config.sources({
            { name = 'copilot' },
            { name = 'nvim_lsp' },
            { name = 'vsnip' }, -- For vsnip users.
          }, {
            { name = 'buffer' },
          })
        }
    end
  }

  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'  

  -- language support
  -- use 'sheerun/vim-polyglot'

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          "bash",
          "c",
          "clojure",
          "cmake",
          "comment",
          "cpp",
          "css",
          "devicetree",
          "dockerfile",
          "dot",
          "fennel",
          "haskell",
          "html",
          "http",
          "java",
          "javascript",
          "jsdoc",
          "json",
          "json5",
          "jsonc",
          "latex",
          "lua",
          "make",
          "markdown",
          "proto",
          "python",
          "regex",
          "rst",
          "ruby",
          "rust",
          "scss",
          "toml",
          "vala",
          "vim",
          "yaml",
          "zig",
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
          disable = {},
        },
      }
    end
  }

  use {
    'neovim/nvim-lspconfig',
    config = function()
      local nvim_lsp = require('lspconfig')

      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      local on_attach = function(client, bufnr)
        local function bnmap(lhs, rhs)
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
        bnmap('<space>e',  '<cmd>lua vim.diagnostic.open_float()<CR>')
        bnmap('[d',        '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
        bnmap(']d',        '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
        bnmap('<space>q',  '<cmd>lua vim.diagnostic.setloclist()<CR>')
        bnmap('<space>f',  '<cmd>lua vim.lsp.buf.format({async = true})<CR>')
        bnmap('<space>h',  '<cmd>ClangdSwitchSourceHeader<CR>')

        -- Use automatic formatting on save
        -- if client.resolved_capabilities.document_formatting then
        --   vim.api.nvim_create_augroup("Format", {})
        --   vim.api.nvim_create_autocmd({"BufWritePre"}, {
        --     group = "Format",
        --     callback = vim.lsp.buf.formatting_sync,
        --   })
        -- end
      end

      local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()) --nvim-cmp
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- Use a loop to conveniently call 'setup' on multiple servers and
      -- map buffer local keybindings when the language server attaches
      local servers = { 'clangd', 'rust_analyzer', 'bashls', 'bqnlsp' }
      for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
          on_attach = on_attach,
          flags = {
            debounce_text_changes = 150,
          },
          capabilities = capabilities
        }
      end

    end
  }

  -- Github Copilot
  -- use {
  --   'github/copilot.vim',
  --   config = function()
  --     local util = require('util')
  --     vim.g.copilot_no_tab_map = true
  --     util.imap("<S-Tab>", [[<Cmd>call copilot#Accept("")<CR>]])
  --   end
  -- }
  use {
    "zbirenbaum/copilot.lua",
    config = function ()
      require("copilot").setup()
    end
  }
  use {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function ()
      require("copilot_cmp").setup()
    end
  }

  -- vim.cmd([[autocmd BufWritePost plugins.lua source <afile> | PackerCompile]])
end)
