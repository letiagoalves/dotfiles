local lsp = require("lsp-zero").preset("recommended")

lsp.ensure_installed({
  "tsserver",
  "rust_analyzer",
  "lua_ls",
})

-- Fix Undefined global 'vim'
lsp.configure("lua-language-server", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
      ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
      ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
      ["<C-y>"] = cmp.mapping.confirm({ select = true }),
      ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings["<Tab>"] = nil
cmp_mappings["<S-Tab>"] = nil

lsp.setup_nvim_cmp({
  mapping = cmp_mappings,
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
})

lsp.set_preferences({
  suggest_lsp_servers = false,
  -- sign_icons = {
  --   error = "E",
  --   warn = "W",
  --   hint = "H",
  --   info = "I",
  -- },
})

lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "gd", function()
    vim.lsp.buf.definition()
  end, opts)
  vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover()
  end, opts)
  vim.keymap.set("n", "<leader>vws", function()
    vim.lsp.buf.workspace_symbol()
  end, opts)
  vim.keymap.set("n", "<leader>vd", function()
    vim.diagnostic.open_float()
  end, opts)
  vim.keymap.set("n", "[d", function()
    vim.diagnostic.goto_next()
  end, opts)
  vim.keymap.set("n", "]d", function()
    vim.diagnostic.goto_prev()
  end, opts)
  -- vim.keymap.set("n", "<leader>vca", function()
  --   -- vim.lsp.buf.code_action()
  -- end, opts)
  vim.keymap.set("n", "<leader>vrr", function()
    vim.lsp.buf.references()
  end, opts)
  vim.keymap.set("n", "<leader>vrn", function()
    vim.lsp.buf.rename()
  end, opts)
  vim.keymap.set("i", "<C-h>", function()
    vim.lsp.buf.signature_help()
  end, opts)
end)

-- https://git.sr.ht/~whynothugo/dotfiles/tree/main/item/home/.config/nvim/lua/lsp.lua
-- lsp.setup({
--     tsserver = {
--     cmd = "tsserver",
--     on_attach = function(client, _)
--       -- Disable `tsservers`'s formatting capability so that null-ls
--       -- is registered as the only compatible formatter.
--       client.server_capabilities.documentFormattingProvider = false
--     end,
--   },
-- })

local dart_lsp = lsp.build_options("dartls", {})
require("flutter-tools").setup({ lsp = dart_lsp })

local null_ls = require("null-ls")

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
  default_timeout = 3000,
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettier_eslint,
    -- null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.diagnostics.tsc,
    null_ls.builtins.code_actions.gitsigns,
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.keymap.set("n", "<Leader>f", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf(), timeout_ms = 4000 })
      end, { buffer = bufnr, desc = "[lsp] format" })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 4000 })
          -- vim.lsp.buf.formatting_sync()
        end,
      })
    end
  end,
  -- on_attach = function(client, bufnr)
  --   if client.supports_method("textDocument/formatting") then
  --     vim.keymap.set("n", "<Leader>f", function()
  --       vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
  --     end, { buffer = bufnr, desc = "[lsp] format" })
  --
  --     -- format on save
  --     vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
  --     vim.api.nvim_create_autocmd(event, {
  --       buffer = bufnr,
  --       group = group,
  --       callback = function()
  --         vim.lsp.buf.format({ bufnr = bufnr, async = async })
  --       end,
  --       desc = "[lsp] format on save",
  --     })
  --   end
  --
})

lsp.setup({
  tsserver = {
    cmd = "tsserver",
    on_attach = function(client, _)
      -- Disable `tsservers`'s formatting capability so that null-ls
      -- is registered as the only compatible formatter.
      client.server_capabilities.documentFormattingProvider = false
    end,
  },
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

-- https://github.com/VonHeikemen/lsp-zero.nvim/issues/65
vim.diagnostic.config({
  virtual_text = {
    prefix = "⋇", -- Could be '●', '▎', 'x', ■
    spacing = 4,
    severity = {
      min = vim.diagnostic.severity.ERROR,
    },
  },
  -- underline = {
  --   prefix = "H",
  --   severity = {
  --     min = vim.diagnostic.severity.ERROR,
  --   },
  -- },
  underline = false,
})
