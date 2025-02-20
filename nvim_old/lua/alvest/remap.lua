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

vim.keymap.set("n", "<leader>rn", function()
  return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true })

vim.api.nvim_set_keymap("n", "<leader>ta", ":$tabnew<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tc", ":tabclose<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>to", ":tabonly<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tn", ":tabn<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tp", ":tabp<CR>", { noremap = true })
-- move current tab to previous position
vim.api.nvim_set_keymap("n", "<leader>tmp", ":-tabmove<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tmn", ":+tabmove<CR>", { noremap = true })
-- move current tab to next position
