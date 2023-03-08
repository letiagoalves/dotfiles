local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
vim.keymap.set("n", "<leader>gr", builtin.lsp_references, {})
vim.keymap.set("n", "<leader>pp", builtin.git_files, {})
vim.keymap.set("n", "<leader>pb", function()
  builtin.buffers({ sort_lastused = true, ignore_current_buffer = true })
end)
vim.keymap.set("n", "<leader>ps", function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")

local telescope = require("telescope")
telescope.load_extension("recent_files")

telescope.setup({
  defaults = {
    path_display = { "smart" },
    mappings = {
      i = { ["<c-t>"] = trouble.open_with_trouble },
      n = { ["<c-t>"] = trouble.open_with_trouble },
    },
  },
  -- extensions = {
  --   frecency = {
  --     db_root = "/Users/alvest/workspace/.telescopedb",
  --     show_scores = true,
  --     -- show_unindexed = true,
  --     -- ignore_patterns = { "*.git/*", "*/tmp/*" },
  --     -- disable_devicons = false,
  --     -- workspaces = {
  --     --       ["conf"] = "/home/my_username/.config",
  --     --       ["data"] = "/home/my_username/.local/share",
  --     --       ["project"] = "/home/my_username/projects",
  --     --       ["wiki"] = "/home/my_username/wiki",
  --     -- },
  --   },
  -- },
})

vim.api.nvim_set_keymap(
  "n",
  "<Leader><Leader>",
  [[<cmd>lua require('telescope').extensions.recent_files.pick()<CR>]],
  { noremap = true, silent = true }
)
