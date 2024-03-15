local legendary_opts = {
  include_builtin = true,
  auto_register_which_key = true,
  keymaps = {
    {
      "<leader>b",
      "<Cmd>Neotree toggle right reveal<CR>",
      description = "Toggle Neotree",
    },
    {
      "<leader>fb",
      function()
        require("telescope").extensions.file_browser.file_browser()
      end,
      description = "Open Telescope file browser",
    },
    {
      "<leader>fc",
      function()
        require("telescope").extensions.file_browser.file_browser({ path = "%:p:h", select_buffer = true })
      end,
      description = "Reveal current file",
    },
    {
      "<Up>",
      ":MoveLine -1<CR>",
      description = "Line: move up (move.nvim)",
      opts = { noremap = true },
    },
    {
      "<Down>",
      ":MoveLine 1<CR>",
      description = "Line: move down (move.nvim)",
      opts = { noremap = true },
    },
    {
      "<C-h>",
      { i = "<C-o>_" },
      description = "Line: go to beggining of line",
      opts = { noremap = true },
    },
    {
      "<C-l>",
      { i = "<C-o>$" },
      description = "Line: go to end of line",
      opts = { noremap = true },
    },
    -- map keys to a command
    -- { "<leader>ff", ":Telescope find_files", description = "Find files" },
    -- map keys to a function
    {
      "<A-m>",
      function()
        print("hello world!")
      end,
      description = "Say hello",
    },
    -- Set options used during keymap creation
    { "<leader>s", ":SomeCommand<CR>", description = "Non-silent keymap", opts = { silent = true } },
    -- create keymaps with different implementations per-mode
    {
      "<leader>c",
      { n = ":LinewiseCommentToggle<CR>", x = ":'<,'>BlockwiseCommentToggle<CR>" },
      description = "Toggle comment",
    },
    -- create item groups to create sub-menus in the finder
    -- note that only keymaps, commands, and functions
    -- can be added to item groups
    {
      -- groups with same itemgroup will be merged
      itemgroup = "short ID",
      description = "A submenu of items...",
      icon = "",
      keymaps = {
        -- more keymaps here
      },
    },
    -- in-place filters, see :h legendary-tables or ./doc/table_structures/README.md
    { "<leader>m", description = "Preview markdown", filters = { ft = "markdown" } },
    { "<leader>pb", description = "Open bookmarks", { n = require("telescope").extensions.bookmarks.list } },
  },
  commands = {
    -- easily create user commands
    {
      ":GoAway",
      function()
        require("noice").cmd("dismiss")
        vim.cmd(":noh")
      end,
      description = "Go away",
    },
    {
      ":SaveWithoutFormatting",
      ":noa w",
      description = "Save without formatting",
    },
    {
      ":RFinder",
      function()
        local path = vim.api.nvim_buf_get_name(0)
        os.execute("open -R " .. path)
      end,
      description = "Reveal in Finder",
    },
    {
      ":MyRepos",
      function()
        require("telescope").extensions.repo.list({})
      end,
      description = "View repos with Telescope",
    },
    {
      -- groups with same itemgroup will be merged
      itemgroup = "short ID",
      -- don't need to copy the other group data because
      -- it will be merged with the one from the keymaps table
      commands = {
        -- more commands here
      },
    },
    -- in-place filters, see :h legendary-tables or ./doc/table_structures/README.md
    { ":Glow", description = "Preview markdown", filters = { ft = "markdown" } },
  },
  funcs = {
    -- Make arbitrary Lua functions that can be executed via the item finder
    {
      function()
        doSomeStuff()
      end,
      description = "Do some stuff with a Lua function!",
    },
    {
      -- groups with same itemgroup will be merged
      itemgroup = "short ID",
      -- don't need to copy the other group data because
      -- it will be merged with the one from the keymaps table
      funcs = {
        -- more funcs here
      },
    },
  },
  extensions = {
    -- load keymaps and commands from nvim-tree.lua
    nvim_tree = true,
    -- load commands from smart-splits.nvim
    -- and create keymaps, see :h legendary-extensions-smart-splits.nvim
    smart_splits = {
      directions = { "h", "j", "k", "l" },
      mods = {
        move = "<C>",
        resize = "<M>",
      },
    },
    -- load commands from op.nvim
    op_nvim = true,
    -- load keymaps from diffview.nvim
    diffview = true,
  },
}

return {
  {
    "catppuccin/nvim",
    lazy = false,
    tag = "v1.6.0",
    name = "catppuccin",
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = {
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false,
        show_end_of_buffer = false, -- show the '~' characters after the end of buffers
        term_colors = true,
        dim_inactive = {
          enabled = true,
          shade = "dark",
          percentage = 0.1,
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        color_overrides = {
          -- all = {
          --   text = "#ff0000",
          -- },
          -- mocha = {
          --   base = "#222222",
          --   mantle = "#191919",
          --   crust = "#474747",
          -- },
          -- mocha = {
          --   base = "#161622",
          --   mantle = "#000000",
          --   crust = "#CFFDE1",
          -- },
        },
        custom_highlights = {},
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          telescope = true,
          notify = false,
          mini = false,
          leap = true,
          -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "uga-rosa/ccc.nvim",
    config = function()
      require("ccc").setup({
        highlighter = {
          auto_enable = true,
          lsp = true,
        },
      })
    end,
  },
  {
    "mrjones2014/legendary.nvim",
    tag = "v2.13.7",
    dependencies = { "stevearc/dressing.nvim", "fedepujol/move.nvim" },
    config = function()
      require("legendary").setup(legendary_opts)
    end,
  },
  {
    "utilyre/barbecue.nvim",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    after = "nvim-web-devicons", -- keep this if you're using NvChad
    config = function()
      require("barbecue").setup({
        kinds = {
          File = "",
          Module = "",
          Namespace = "",
          Package = "",
          Class = "",
          Method = "",
          Property = "",
          Field = "",
          Constructor = "",
          Enum = "",
          Interface = "",
          Function = "",
          Variable = "",
          Constant = "",
          String = "",
          Number = "",
          Boolean = "",
          Array = "",
          Object = "",
          Key = "",
          Null = "",
          EnumMember = "",
          Struct = "",
          Event = "",
          Operator = "",
          TypeParameter = "",
        },
      })
    end,
  },
  {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()
    end,
  },
  {
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
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      })

      require("notify").setup({
        render = "compact",
        timeout = 500,
      })
    end,
    dependencies = { -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim", -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    { "simrat39/symbols-outline.nvim" },
    {
      "nvim-lualine/lualine.nvim",
      lazy = false,
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("lualine").setup()
      end,
    },
    { "arkav/lualine-lsp-progress" },
    { -- Adds git related signs to the gutter, as well as utilities for managing changes
      "lewis6991/gitsigns.nvim",
      opts = {
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
      },
    },
    { -- Useful plugin to show you pending keybinds.
      "folke/which-key.nvim",
      event = "VimEnter", -- Sets the loading event to 'VimEnter'
      config = function() -- This is the function that runs, AFTER loading
        require("which-key").setup()

        -- Document existing key chains
        require("which-key").register({
          ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
          ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
          ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
          ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
          ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
        })
      end,
    },
  },
  -- Highlight todo, notes, etc in comments
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
  {
    "nanozuki/tabby.nvim",
    config = function()
      local mocha = require("catppuccin.palettes").get_palette("frappe")
      local tabby = require("tabby.tabline")

      require("tabby.tabline").use_preset("tab_only", {
        theme = {
          --   fill = "TabLineFill",     -- tabline background
          --   head = "TabLine",         -- head element highlight
          current_tab = { fg = mocha.yellow, bg = mocha.base, style = "bold" },
          --   tab = "TabLine",          -- other tab label highlight
          --   win = "TabLine",          -- window highlight
          --   tail = "TabLine",         -- tail element highlight
        },
        -- nerdfont = true,            -- whether use nerdfont
        -- tab_name = {
        --   name_fallback = "function({tabid}), return a string",
        -- },
        -- buf_name = {
        --   mode = "'unique'|'relative'|'tail'|'shorten'",
        -- },
      })
    end,
  },
  {
    "SmiteshP/nvim-navbuddy",
    dependencies = { "neovim/nvim-lspconfig", "SmiteshP/nvim-navic", "MunifTanjim/nui.nvim" },
    config = function()
      local navbuddy = require("nvim-navbuddy")
      -- local actions = require("nvim-navbuddy.actions")

      navbuddy.setup({
        window = {
          border = "single", -- "rounded", "double", "solid", "none"
        },
        lsp = {
          auto_attach = true, -- If set to true, you don't need to manually use attach function
          preference = nil, -- list of lsp server names in order of preference
        },
      })
    end,
  },
}
