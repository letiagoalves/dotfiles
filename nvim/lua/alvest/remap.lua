vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- vim.keymap.set("n", "<Up>", function() print("Use k") end)
-- vim.keymap.set("n", "<Down>", function() print("Use j") end)
-- vim.keymap.set("n", "<Left>", function() print("Use h") end)
-- vim.keymap.set("n", "<Right>", function() print("Use l") end)

vim.keymap.set("i", "<Leader>jk", "<ESC>")

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x')

-- increment/decrement numbers
vim.keymap.set("n", "<leader>+", "<C-a>") -- increment
vim.keymap.set("n", "<leader>-", "<C-x>") -- decrement

-- window management
vim.keymap.set("n", "<leader>sv", "<C-w>v")        -- split window vertically
vim.keymap.set("n", "<leader>sh", "<C-w>s")        -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=")        -- make split windows equal width & height
vim.keymap.set("n", "<leader>sx", ":close<CR>")    -- close current split window

vim.keymap.set("n", "<leader>to", ":tabnew<CR>")   -- open new tab
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
vim.keymap.set("n", "<leader>tn", ":tabn<CR>")     --  go to next tab
vim.keymap.set("n", "<leader>tp", ":tabp<CR>")     --  go to previous tab

-- nvim-tree
local tree_api = require("nvim-tree.api")

vim.keymap.set("n", "<leader>b", function()
  tree_api.tree.toggle({
    find_file = true,
  })
  -- print(tree)
end)

-- recent files
-- This may bind to old telescope function depending on your load order:
-- vim.keymap.set('n', '<leader>f', require'telescope'.builtins.find_files)
-- So: better wrap it in a function:
vim.keymap.set("n", "<leader>f", function()
  require("telescope").builtins.find_files()
end)
-- vim.api.nvim_set_keymap(
--   "n",
--   "<leader><leader>",
--   "<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>",
--   { noremap = true, silent = true }
-- )
