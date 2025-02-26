local M = {
  include_builtin = true,
  auto_register_which_key = true,
  keymaps = {
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
    { "<leader>s", ":SomeCommand<CR>",               description = "Non-silent keymap", opts = { silent = true } },
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

return M
