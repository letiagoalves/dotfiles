local navbuddy = require("nvim-navbuddy")
local actions = require("nvim-navbuddy.actions")

navbuddy.setup({
  window = {
    border = "single", -- "rounded", "double", "solid", "none"
  },
  lsp = {
    auto_attach = true, -- If set to true, you don't need to manually use attach function
    preference = nil, -- list of lsp server names in order of preference
  },
})
