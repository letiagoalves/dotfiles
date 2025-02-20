return { "tenxsoydev/karen-yank.nvim",
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup(require("alvest.setup.comment-setup"))
		end
	} }
