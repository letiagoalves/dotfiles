return {
    "nvim-tree/nvim-tree.lua",
    {
        "stevearc/oil.nvim",
        config = function()
            require("oil").setup()
            vim.keymap.set("n", "-", require("oil").open, {
                desc = "Open parent directory"
            })
        end
    }
}
