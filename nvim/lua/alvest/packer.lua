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
  use({
    "nvim-telescope/telescope-file-browser.nvim",
    requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  })

  use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
  use({
    "windwp/nvim-autopairs",
    wants = "nvim-treesitter",
    module = { "nvim-autopairs.completion.cmp", "nvim-autopairs" },
  })
  use("lukas-reineke/indent-blankline.nvim")
  use("fedepujol/move.nvim")
  use({
    "windwp/nvim-ts-autotag",
    wants = "nvim-treesitter",
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup({ enable = true })
    end,
  })

  use({ "mg979/vim-visual-multi" })

  use({
    "folke/noice.nvim",
    config = function()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true,    -- use a classic bottom cmdline for search
          command_palette = true,  -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false,      -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false,  -- add a border to hover docs and signature help
        },
      })
    end,
    requires = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  })

  use("tpope/vim-fugitive")
  use("lewis6991/gitsigns.nvim")
  -- use({
  --   "tummetott/unimpaired.nvim",
  --   config = function()
  --     require("unimpaired").setup({
  --       -- add any options here or leave empty
  --     })
  --   end,
  -- })
  -- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
  use({
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    requires = {
      -- LSP Support
      { "neovim/nvim-lspconfig" }, -- Required
      { "onsails/lspkind.nvim" },
      {
        -- Optional
        "williamboman/mason.nvim",
        run = function()
          pcall(vim.cmd, "MasonUpdate")
        end,
      },
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

  use("christoomey/vim-tmux-navigator")
  use("numToStr/Comment.nvim")
  use("nvim-tree/nvim-tree.lua")
  use({
    "ggandor/leap.nvim",
    config = function()
      for _, _4_ in ipairs({
        { "n", "s", "<Plug>(leap-forward)" },
        { "n", "S", "<Plug>(leap-backward)" },
        { "x", "s", "<Plug>(leap-forward)" },
        { "x", "S", "<Plug>(leap-backward)" },
        { "o", "z", "<Plug>(leap-forward)" },
        { "o", "Z", "<Plug>(leap-backward)" },
        { "o", "x", "<Plug>(leap-forward-x)" },
        { "o", "X", "<Plug>(leap-backward-x)" },
        -- { "n", "gs", "<Plug>(leap-cross-window)" },
        -- { "x", "gs", "<Plug>(leap-cross-window)" },
        -- { "o", "gs", "<Plug>(leap-cross-window)" },
      }) do
        local _each_5_ = _4_
        local mode = _each_5_[1]
        local lhs = _each_5_[2]
        local rhs = _each_5_[3]
        if force_3f or ((vim.fn.mapcheck(lhs, mode) == "") and (vim.fn.hasmapto(rhs, mode) == 0)) then
          vim.keymap.set(mode, lhs, rhs, { silent = true })
        else
        end
      end
      -- require("leap").set_default_keymaps()
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
    requires = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    after = "nvim-web-devicons",  -- keep this if you're using NvChad
    config = function()
      require("barbecue").setup()
    end,
  })
  use({ "smartpde/telescope-recent-files" })

  use({
    "L3MON4D3/LuaSnip",
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

  use({
    "uga-rosa/ccc.nvim",
    config = function()
      require("ccc").setup({
        highlighter = {
          auto_enable = true,
          lsp = true,
        },
      })
    end,
  })

  use({
    "echasnovski/mini.nvim",
    branch = "stable",
    config = function()
      require("mini.surround").setup({
        mappings = {
          add = "gsa",  -- Add surrounding in Normal and Visual modes
          delete = "gsd", -- Delete surrounding
          find = "gsf", -- Find surrounding (to the right)
          find_left = "gsF", -- Find surrounding (to the left)
          highlight = "gsh", -- Highlight surrounding
          replace = "gsr", -- Replace surrounding
          -- update_n_lines = "sn", -- Update `n_lines`
          -- suffix_last = "l", -- Suffix to search with "prev" method
          -- suffix_next = "n", -- Suffix to search with "next" method
        },
      })
    end,
  })

  use({
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end,
  })

  use("nanozuki/tabby.nvim")
  use("kdheepak/lazygit.nvim")
  use("dmmulroy/tsc.nvim")
end)
