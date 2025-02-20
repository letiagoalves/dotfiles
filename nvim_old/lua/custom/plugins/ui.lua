return { {
    "nvim-tree/nvim-web-devicons",
    "folke/which-key.nvim",
    config = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 1500
        require("which-key").setup({
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        })
    end
}, {
    "uga-rosa/ccc.nvim",
    config = function()
        require("ccc").setup({
            highlighter = {
                auto_enable = true,
                lsp = true
            }
        })
    end
}, {
    "mrjones2014/legendary.nvim",
    tag = "v2.9.1",
    dependencies = { "stevearc/dressing.nvim" },
    config = function()
        require("legendary").setup(require("alvest.setup.legendary-setup"))
    end
}, {
    "glepnir/dashboard-nvim",
    lazy = false,
    priority = 1000,
    event = "VimEnter",
    config = function()
        require("dashboard").setup({
            theme = "hyper"
        })
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" }
}, {
    "utilyre/barbecue.nvim",
    dependencies = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" -- optional dependency
    },
    after = "nvim-web-devicons",                                          -- keep this if you're using NvChad
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
    end
}, {
    "j-hui/fidget.nvim",
    config = function()
        require("fidget").setup()
    end
}, {
    "smjonas/inc-rename.nvim",
    config = function()
        require("inc_rename").setup()
    end
}, { {
    "SmiteshP/nvim-navbuddy",
    dependencies = { "neovim/nvim-lspconfig", "SmiteshP/nvim-navic", "MunifTanjim/nui.nvim" }
} }, {
    "folke/noice.nvim",
    config = function()
        require("noice").setup({
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true
                }
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = true,         -- use a classic bottom cmdline for search
                command_palette = true,       -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false,           -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = false        -- add a border to hover docs and signature help
            }
        })

        require("notify").setup({
            render = "compact",
            timeout = 500
        })
    end,
    dependencies = {            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim", -- OPTIONAL:
        --   `nvim-notify` is only needed, if you want to use the notification view.
        --   If not available, we use `mini` as the fallback
        "rcarriga/nvim-notify" },
    { "simrat39/symbols-outline.nvim" },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    { "arkav/lualine-lsp-progress" }
} }
