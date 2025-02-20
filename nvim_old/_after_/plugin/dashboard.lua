-- require("dashboard").setup({
--   theme = "hyper",
--   config = {
--     week_header = {
--       enable = true,
--     },
--     shortcut = {
--       { desc = " Update", group = "@property", action = "Lazy update", key = "u" },
--       {
--         icon = " ",
--         icon_hl = "@variable",
--         desc = "Files",
--         group = "Label",
--         action = "Telescope find_files",
--         key = "f",
--       },
--       {
--         desc = " Apps",
--         group = "DiagnosticHint",
--         action = "Telescope app",
--         key = "a",
--       },
--       {
--         desc = " dotfiles",
--         group = "Number",
--         action = "Telescope dotfiles",
--         key = "d",
--       },
--     },
--   },
-- })

-- open dashboard on start up
local function open_dashboard(data)
  -- buffer is a [No Name]
  local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not no_name and not directory then
    return
  end

  -- change to the directory
  if directory then
    vim.cmd.cd(data.file)
  end

  -- open the tree
  --  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_dashboard })
