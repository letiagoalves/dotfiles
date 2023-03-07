-- import comment plugin safely
local setup, comment = pcall(require, "Comment")
if not setup then
  return
end

-- enable comment
comment.setup({
    toggler = {
        line = "<leader>cl",
        block = "<leader>cb",
    },
    opleader = {
        ---Line-comment keymap
        line = "cl",
        ---Block-comment keymap
        block = 'cb',
    }
})
