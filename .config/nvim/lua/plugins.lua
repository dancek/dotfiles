-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
  -- essentials
  "tpope/vim-sensible",
  "tpope/vim-repeat",
  "tpope/vim-sleuth",
  "tpope/vim-surround",
  "tpope/vim-commentary",

  {
    "junegunn/vim-easy-align",
    config = function()
      local util = require("util")
      util.nmap("ga", "<Plug>(LiveEasyAlign)")
      util.vmap("ga", "<Plug>(LiveEasyAlign)")
    end,
  },

  {
    "johmsalas/text-case.nvim",
    config = function()
      require("textcase").setup({})
    end,
  },

  -- autosave
  {
    "Pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup({})
    end,
  },

  -- UI enhancements
  "morhetz/gruvbox",
  {
    "vim-airline/vim-airline",
    config = function()
      vim.g["airline_powerline_fonts"] = 1
      vim.g["airline_section_x"] = vim.call("airline#section#create_right", { "tagbar", "filetype" })
    end,
  },
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({})
    end,
  },
  "mg979/vim-visual-multi",
  "ntpeters/vim-better-whitespace",

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
  },

  -- git
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = function()
      require("git-conflict").setup()
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local util = require("util")
      util.nmap("<C-p>", "<cmd>Telescope find_files<CR>")
      util.nmap("<C-M-p>", "<cmd>Telescope find_files hidden=true no_ignore=false<CR>")
      util.nmap("<C-\\>", "<cmd>Telescope oldfiles<CR>")
      util.nmap("<C-f>", "<cmd>Telescope live_grep<CR>")
      util.nmap("<C-g>", "<cmd>Telescope grep_string<CR>")
      util.vmap("<C-g>", "<cmd>Telescope grep_string<CR>")
      util.nmap("<C-h>", "<cmd>Telescope help_tags<CR>")
      util.nmap("<C-b>", "<cmd>Telescope buffers<CR>")
      util.nmap("<C-]>", "<cmd>Telescope resume<CR>")
      util.nmap("gR", "<cmd>Telescope lsp_references<CR>")

      require("telescope").setup({
        defaults = {
          path_display = {
            "truncate",
          },
        },
        pickers = {
          buffers = {
            mappings = {
              i = {
                ["<C-d>"] = "delete_buffer",
              },
            },
          },
        },
      })
    end,
  },

  -- BQN
  {
    "mlochbaum/BQN",
    rtp = "editors/vim/",
  },
  {
    "https://git.sr.ht/~detegr/nvim-bqn",
    config = function()
      local util = require("util")
      -- util.nmap('<C-Space>', '<cmd>BQNEvalFile<CR>')
      -- util.nmap('<Space>', '<cmd>BQNClearFile<CR>')
    end,
  },

  -- completion
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")
      cmp.setup({
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
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<Tab>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
        }),
        sources = cmp.config.sources({
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "vsnip" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },

  "hrsh7th/cmp-vsnip",
  "hrsh7th/vim-vsnip",

  -- language support
  {
    "Olical/conjure",
    branch = "main",
  },
  {
    "eraserhd/parinfer-rust",
    build = "cargo build --release",
  },

  "slim-template/vim-slim",

  -- Formatting
  {
    "nvimdev/guard.nvim",
    dependencies = { "nvimdev/guard-collection" },
    config = function()
      local ft = require("guard.filetype")

      -- Define all formatters in a table
      local formatters = {
        { exe = "prettier", filetypes = "typescript,javascript,typescriptreact" },
        { exe = "ruff", filetypes = "python" },
        { exe = "sqlfluff", filetypes = "sql" },
        { exe = "rustfmt", filetypes = "rust" },
        { exe = "clang-format", filetypes = "c,cpp" },
        { exe = "gofmt", filetypes = "go" },
      }

      -- Loop through the formatters and only register the ones that are installed.
      for _, formatter in ipairs(formatters) do
        if vim.fn.executable(formatter.exe) == 1 then
          ft(formatter.filetypes):fmt(formatter.exe)
        end
      end

      vim.g.guard_config = {
        fmt_on_save = false,
        lsp_as_default_formatter = true,
      }

      local util = require("util")
      util.nmap("<space>f", "<cmd>Guard fmt<CR>")
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
          disable = {},
        },
        indent = {
          enable = true,
        },
      })
      require("nvim-treesitter").install({
        "asm",
        "awk",
        "bash",
        "c",
        "c_sharp",
        "caddy",
        "clojure",
        "cmake",
        "comment",
        "cpp",
        "css",
        "csv",
        "desktop",
        "devicetree",
        "diff",
        "dockerfile",
        "dot",
        "editorconfig",
        "elixir",
        "fennel",
        "fish",
        "forth",
        "fsharp",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "glsl",
        "go",
        "haskell",
        "html",
        "http",
        "ini",
        "java",
        "javadoc",
        "javascript",
        "jinja",
        "jinja_inline",
        "jjdescription",
        "jq",
        "jsdoc",
        "json",
        "json5",
        "kitty",
        "latex",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "mermaid",
        "meson",
        "nasm",
        "nginx",
        "nix",
        "objc",
        "ocaml",
        "passwd",
        "perl",
        "php",
        "powershell",
        "printf",
        "properties",
        "proto",
        "python",
        "qmljs",
        "query",
        "r",
        "racket",
        "readline",
        "regex",
        "requirements",
        "robots_txt",
        "rst",
        "ruby",
        "rust",
        "scala",
        "scheme",
        "scss",
        "smali",
        "sql",
        "ssh_config",
        "strace",
        "svelte",
        "sway",
        "terraform",
        "toml",
        "tsv",
        "tsx",
        "typescript",
        "udev",
        "vala",
        "vhdl",
        "vim",
        "vimdoc",
        "xml",
        "xresources",
        "yaml",
        "zig",
        "zsh",
      })
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      local on_attach = function(client, bufnr)
        local function bnmap(lhs, rhs)
          vim.api.nvim_buf_set_keymap(bufnr, "n", lhs, rhs, { noremap = true, silent = true })
        end

        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        bnmap("gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
        bnmap("gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
        bnmap("K", "<cmd>lua vim.lsp.buf.hover()<CR>")
        bnmap("gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
        bnmap("<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
        bnmap("<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
        bnmap("<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
        bnmap("<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")
        bnmap("<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
        bnmap("<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
        bnmap("<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
        bnmap("gr", "<cmd>lua vim.lsp.buf.references()<CR>")
        bnmap("<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>")
        bnmap("[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
        bnmap("]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")
        bnmap("<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>")
        bnmap("<space>h", "<cmd>ClangdSwitchSourceHeader<CR>")
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      local servers = { "clangd", "rust_analyzer", "bashls", "clojure_lsp", "ts_ls", "svelte", "gopls" }
      for _, lsp in ipairs(servers) do
        vim.lsp.enable(lsp)
        vim.lsp.config(lsp, {
          on_attach = on_attach,
          flags = {
            debounce_text_changes = 150,
          },
          capabilities = capabilities,
        })
      end

      -- Python needs extra support for virtual envs
      vim.lsp.config("pyright", {
        capabilities = capabilities,
        on_attach = on_attach,
        on_new_config = function(config, root_dir)
          local env = vim.trim(vim.fn.system('cd "' .. root_dir .. '"; poetry env info -p 2>/dev/null'))
          if string.len(env) > 0 then
            config.settings.python.pythonPath = env .. "/bin/python"
          end
        end
      })
    end,
  },

  -- Debugging
  "mfussenegger/nvim-dap",
  "mfussenegger/nvim-dap-python",

  -- Coverage
  {
    "andythigpen/nvim-coverage",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("coverage").setup({ commands = true })
    end,
  },
})
