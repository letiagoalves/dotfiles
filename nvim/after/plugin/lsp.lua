-- Setup language servers.
local lspconfig = require("lspconfig")

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<space>ff", function()
      vim.lsp.buf.format({ async = false })
    end, opts)
  end,
})

local lsp = require("lsp-zero").preset({})

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

local dart_lsp = lsp.build_options("dartls", {})
require("flutter-tools").setup({ lsp = dart_lsp })

-- TODO:
-- cmp_mappings["<Tab>"] = nil
-- cmp_mappings["<S-Tab>"] = nil
-- cmp_mappings["<C-e>"] = nil

local null_ls = require("null-ls")

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local on_attach = function(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({
          bufnr = bufnr,
          -- filter = function(client)
          -- 	return client.name == "null-ls"
          -- end,
        })
      end,
    })
  end
end

null_ls.setup({
  -- debug = true,
  -- default_timeout = 3000,
  sources = {
    null_ls.builtins.formatting.stylua,
    -- null_ls.builtins.formatting.prettier_eslint,
    null_ls.builtins.formatting.dart_format,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.diagnostics.tsc,
    null_ls.builtins.code_actions.xo,
    null_ls.builtins.code_actions.gitsigns,
  },
  on_attach = on_attach,
})

lspconfig.tsserver.setup({
  on_attach = on_attach,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  cmd = { "typescript-language-server", "--stdio" },
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

lsp.setup()

local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()

cmp.setup({
  sources = {
    { name = "path" },
    { name = "nvim_lsp" },
    { name = "buffer",  keyword_length = 3 },
    { name = "luasnip", keyword_length = 2 },
  },
  formatting = {
    fields = { "abbr", "kind", "menu" },
    format = require("lspkind").cmp_format({
      mode = "symbol",    -- show only symbol annotations
      maxwidth = 50,      -- prevent the popup from showing more than provided characters
      ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
    }),
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = {
    -- `Enter` key to confirm completion
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
    -- Ctrl+Space to trigger completion menu
        ["<C-Space>"] = cmp.mapping.complete(),
    -- Navigate between snippet placeholder
        ["<C-f>"] = cmp_action.luasnip_jump_forward(),
        ["<C-b>"] = cmp_action.luasnip_jump_backward(),
  },
})
