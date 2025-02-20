return require("packer").startup(function(use)
	local isVsCode = vim.g.vscode

	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	-- telescope
	-- use("cljoly/telescope-repo.nvim")
	-- use({
	-- 	"nvim-telescope/telescope.nvim",
	-- 	tag = "0.1.2", -- or branch = '0.1.x',
	-- 	requires = { { "nvim-lua/plenary.nvim" } },
	-- 	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }),
	-- })
	-- use({
	-- 	"nvim-telescope/telescope-file-browser.nvim",
	-- 	requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	-- })
	-- use({
	-- 	"aaronhallaert/advanced-git-search.nvim",
	-- 	requires = {
	-- 		"nvim-telescope/telescope.nvim",
	-- 		-- to show diff splits and open commits in browser
	-- 		"tpope/vim-fugitive",
	-- 	},
	-- })
	-- use({ "smartpde/telescope-recent-files" })

	-- use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
	use("lukas-reineke/indent-blankline.nvim")
	use("fedepujol/move.nvim")
	use({
		"windwp/nvim-ts-autotag",
		wants = "nvim-treesitter",
		event = "InsertEnter",
		config = function()
			require("nvim-ts-autotag").setup({ enable = true })
		end,
	})

	use({ "mg979/vim-visual-multi" })

	use({
		"pmizio/typescript-tools.nvim",
		requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		config = function()
			require("typescript-tools").setup({})
		end,
	})

	use("christoomey/vim-tmux-navigator")
	use("nvim-tree/nvim-tree.lua")
	
	use("rafamadriz/friendly-snippets")

	-- Legendary
end)
