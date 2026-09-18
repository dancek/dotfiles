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
  "tpope/vim-repeat",
  "tpope/vim-sleuth",
  "tpope/vim-surround",

  {
    "junegunn/vim-easy-align",
    config = function()
      vim.keymap.set("n", "ga", "<Plug>(LiveEasyAlign)", { remap = true, desc = "Live EasyAlign" })
      vim.keymap.set("x", "ga", "<Plug>(LiveEasyAlign)", { remap = true, desc = "Live EasyAlign" })
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
      vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
      vim.keymap.set("n", "<C-M-p>", "<cmd>Telescope find_files hidden=true no_ignore=false<CR>", { desc = "Find all files" })
      vim.keymap.set("n", "<C-\\>", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
      vim.keymap.set("n", "<C-f>", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
      vim.keymap.set("n", "<C-g>", "<cmd>Telescope grep_string<CR>", { desc = "Grep string under cursor" })
      vim.keymap.set("v", "<C-g>", "<cmd>Telescope grep_string<CR>", { desc = "Grep selection" })
      vim.keymap.set("n", "<C-h>", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
      vim.keymap.set("n", "<C-b>", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
      vim.keymap.set("n", "<C-]>", "<cmd>Telescope resume<CR>", { desc = "Resume telescope" })
      vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", { desc = "LSP references" })

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
          { name = "nvim_lsp" },
          { name = "vsnip" },
          { name = "path" },
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

      vim.keymap.set("n", "<space>f", "<cmd>Guard fmt<CR>", { desc = "Format buffer" })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({})
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
      -- Use LspAttach autocommand to map keys when a language server attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(ev)
          local bufnr = ev.buf
          local client = vim.lsp.get_client_by_id(ev.data.client_id)

          -- Enable completion triggered by <c-x><c-o>
          vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

          local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
          end

          map("gD", vim.lsp.buf.declaration, "LSP declaration")
          map("gd", vim.lsp.buf.definition, "LSP definition")
          map("K", vim.lsp.buf.hover, "LSP hover")
          map("gi", vim.lsp.buf.implementation, "LSP implementation")
          map("<C-k>", vim.lsp.buf.signature_help, "LSP signature help")
          map("<space>wa", vim.lsp.buf.add_workspace_folder, "LSP add workspace folder")
          map("<space>wr", vim.lsp.buf.remove_workspace_folder, "LSP remove workspace folder")
          map("<space>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, "LSP list workspace folders")
          map("<space>D", vim.lsp.buf.type_definition, "LSP type definition")
          map("<space>rn", vim.lsp.buf.rename, "LSP rename")
          map("<space>ca", vim.lsp.buf.code_action, "LSP code action")
          map("gr", vim.lsp.buf.references, "LSP references")
          map("<space>e", vim.diagnostic.open_float, "LSP diagnostic float")
          map("[d", vim.diagnostic.goto_prev, "LSP previous diagnostic")
          map("]d", vim.diagnostic.goto_next, "LSP next diagnostic")
          map("<space>q", vim.diagnostic.setloclist, "LSP setloclist")

          if client and client.name == "clangd" then
            map("<space>h", "<cmd>ClangdSwitchSourceHeader<CR>", "Clangd switch source/header")
          end
        end,
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- Set default capabilities for all servers
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      local servers = { "clangd", "rust_analyzer", "bashls", "clojure_lsp", "ts_ls", "svelte", "gopls" }
      for _, lsp in ipairs(servers) do
        vim.lsp.config(lsp, {
          flags = {
            debounce_text_changes = 150,
          },
        })
        vim.lsp.enable(lsp)
      end

      -- Python needs extra support for virtual envs
      vim.lsp.config("pyright", {
        before_init = function(params, config)
          local root_dir = config.root_dir or (params and params.rootPath)
          if root_dir then
            local env = vim.trim(vim.fn.system('cd "' .. root_dir .. '"; poetry env info -p 2>/dev/null'))
            if #env > 0 then
              config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
                python = {
                  pythonPath = env .. "/bin/python",
                },
              })
            end
          end
        end,
      })
      vim.lsp.enable("pyright")
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
