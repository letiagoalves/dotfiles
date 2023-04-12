-- Only required if you have packer configured as `opt`
-- vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
  -- Packer can manage itself
  use("wbthomason/packer.nvim")

  use("cljoly/telescope-repo.nvim")
  use({
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    -- or                            , branch = '0.1.x',
    requires = { { "nvim-lua/plenary.nvim" } },
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }),
  })

  use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
  -- Auto pairs
  use({
    "windwp/nvim-autopairs",
    wants = "nvim-treesitter",
    module = { "nvim-autopairs.completion.cmp", "nvim-autopairs" },
  })
  use({
    "utilyre/sentiment.nvim",
    tag = "*",
    config = function()
      require("sentiment").setup({
        -- config
      })
    end,
  })
  use("fedepujol/move.nvim")
  use({
    "windwp/nvim-ts-autotag",
    wants = "nvim-treesitter",
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup({ enable = true })
    end,
  })

  use("tpope/vim-fugitive")
  use("lewis6991/gitsigns.nvim")
  use({
    "tummetott/unimpaired.nvim",
    config = function()
      require("unimpaired").setup({
        -- add any options here or leave empty
      })
    end,
  })
  -- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
  use({
    "VonHeikemen/lsp-zero.nvim",
    branch = "v1.x",
    requires = {
      -- LSP Support
      { "neovim/nvim-lspconfig" },          -- Required
      { "williamboman/mason.nvim" },        -- Optional
      { "williamboman/mason-lspconfig.nvim" }, -- Optional

      -- Autocompletion
      { "hrsh7th/nvim-cmp" },      -- Required
      { "hrsh7th/cmp-nvim-lsp" },  -- Required
      { "hrsh7th/cmp-buffer" },    -- Optional
      { "hrsh7th/cmp-path" },      -- Optional
      { "saadparwaiz1/cmp_luasnip" }, -- Optional
      { "hrsh7th/cmp-nvim-lua" },  -- Optional

      -- Snippets
      { "L3MON4D3/LuaSnip" },          -- Required
      { "rafamadriz/friendly-snippets" }, -- Optional
      { "hrsh7th/vim-vsnip" },
      { "hrsh7th/vim-vsnip-integ" },

      -- Formatting
      { "neovim/nvim-lspconfig" },
      { "jose-elias-alvarez/null-ls.nvim" },
    },
  })

  use({
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end,
  })

  use({
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()
    end,
  })

  -- use({
  --   "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  --   config = function()
  --     require("lsp_lines").setup()
  --   end,
  -- })

  use({ "akinsho/flutter-tools.nvim", requires = "nvim-lua/plenary.nvim" })
  -- Lua
  use({
    "folke/trouble.nvim",
    requires = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup()
      -- require("trouble").setup({
      -- icons = false,
      --   fold_open = "v", -- icon used for open folds
      --   fold_closed = ">", -- icon used for closed folds
      --   indent_lines = true, -- add an indent guide below the fold icons
      --   mode = "workspace_diagnostics",
      -- signs = {
      --   -- icons / text used for a diagnostic
      --   error = "A",
      --   warning = "warn",
      --   hint = "hint",
      --   information = "info",
      -- },
      -- use_diagnostic_signs = true, -- enabling this will use the signs defined in your lsp client
      -- sadsad
      --   -- your configuration comes here
      --   -- or leave it empty to use the default settings
      --   -- refer to the configuration section below
      -- })
      --
      -- local signs = {
      --   Error = " ",
      --   Warn = " ",
      --   Hint = " ",
      --   Info = " ",
      -- }
      --
      -- for type, icon in pairs(signs) do
      --   local hl = "DiagnosticSign" .. type
      --   vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      -- end
    end,
  })

  -- sadasd

  use("christoomey/vim-tmux-navigator")
  use("numToStr/Comment.nvim")
  use("nvim-tree/nvim-tree.lua")
  use({
    "ggandor/leap.nvim",
    config = function()
      require("leap").set_default_keymaps()
    end,
  })

  use({ "catppuccin/nvim", tag = "v1.1.0", as = "catppuccin" })
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
  })
  use("rafamadriz/friendly-snippets")

  use("nvim-tree/nvim-web-devicons")
  use({
    "utilyre/barbecue.nvim",
    tag = "fix/E36",
    requires = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    after = "nvim-web-devicons",  -- keep this if you're using NvChad
    config = function()
      require("barbecue").setup()
    end,
  })
  -- use("kkharji/sqlite.lua")
  use({ "smartpde/telescope-recent-files" })

  use({
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    tag = "v1.2.1",
    -- install jsregexp (optional!:).
    run = "make install_jsregexp",
  })

  use({
    "glepnir/dashboard-nvim",
    event = "VimEnter",
    config = function()
      require("dashboard").setup({
        theme = "hyper",
      })
    end,
    requires = { "nvim-tree/nvim-web-devicons" },
  })

  use({
    "olimorris/persisted.nvim",
    config = function()
      require("persisted").setup()
    end,
  })
  use("simrat39/symbols-outline.nvim")
  use({
    "kosayoda/nvim-lightbulb",
    requires = "antoinemadec/FixCursorHold.nvim",
  })
  use("tenxsoydev/karen-yank.nvim")
  use({
    "SmiteshP/nvim-navbuddy",
    requires = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
    },
  })

  -- Legendary
  use({ "stevearc/dressing.nvim" })
  use({
    "mrjones2014/legendary.nvim",
    tag = "v2.9.1",
    requires = { "stevearc/dressing.nvim" },
    config = function()
      require("legendary").setup(require("alvest.legendary-after"))
    end,
  })
end)
