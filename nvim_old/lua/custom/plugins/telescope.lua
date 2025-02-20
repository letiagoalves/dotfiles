return {
    { "cljoly/telescope-repo.nvim" },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.2", -- or branch = '0.1.x',
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build =
            'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
        },
        {
            "nvim-telescope/telescope-file-browser.nvim",
            dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
        },
        {
            "aaronhallaert/advanced-git-search.nvim",
            dependencies = { "nvim-telescope/telescope.nvim", -- to show diff splits and open commits in browser
                "tpope/vim-fugitive" }
        },
        { "smartpde/telescope-recent-files" },
        {
            "olimorris/persisted.nvim",
            config = function()
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

                local telescope = require("telescope")

                telescope.setup({
                    defaults = {
                        path_display = { "smart" },
                        mappings = {},
                    },
                    extensions = {
                        recent_files = {
                            only_cwd = true,
                        },
                        repo = {
                            list = {
                                search_dirs = {
                                    "~/workspace",
                                },
                            },
                        },
                        fzf = {
                            fuzzy = true,                   -- false will only do exact matching
                            override_generic_sorter = true, -- override the generic sorter
                            override_file_sorter = true,    -- override the file sorter
                            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                            -- the default case_mode is "smart_case"
                        },
                        advanced_git_search = {
                            -- Fugitive or diffview
                            diff_plugin = "fugitive",
                            -- Customize git in previewer
                            -- e.g. flags such as { "--no-pager" }, or { "-c", "delta.side-by-side=false" }
                            git_flags = {},
                            -- Customize git diff in previewer
                            -- e.g. flags such as { "--raw" }
                            git_diff_flags = {},
                            -- Show builtin git pickers when executing "show_custom_functions" or :AdvancedGitSearch
                            show_builtin_git_pickers = false,
                        },
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
                    },
                })

                telescope.load_extension("recent_files")
                telescope.load_extension("persisted")
                telescope.load_extension("repo")
                -- telescope.load_extension("fzf") // TODO:
                telescope.load_extension("file_browser")
                telescope.load_extension("advanced_git_search")

                vim.api.nvim_set_keymap(
                    "n",
                    "<Leader><Leader>",
                    [[<cmd>lua require('telescope').extensions.recent_files.pick()<CR>]],
                    { noremap = true, silent = true }
                )


                require("persisted").setup()
            end
        }
    }
}
