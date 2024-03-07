return {
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
  "tenxsoydev/karen-yank.nvim",
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup({
        toggler = {
          line = "<leader>cl",
          block = "<leader>cb",
        },
        opleader = {
          ---Line-comment keymap
          line = "cl",
          ---Block-comment keymap
          block = "cb",
        },
      })
    end,
  },
}
