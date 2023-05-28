return {
	{
		"lewis6991/gitsigns.nvim",
		cmd = "Gitsigns",
		config = function()
			require("setup.plugins.gitsigns")
		end,
	},
	{
		"kdheepak/lazygit.nvim",
		cmd = { "LazyGit", "LazyGitCurrentFile", "LazyGitConfig", "LazyGitFilter", "LazyGitFilterCurrentFile" },
		keys = {
			{ "<leader>gG", "<cmd>LazyGit<cr>", desc = "Open LayzGit (Root)" },
			{ "<leader>gg", "<cmd>:LazyGitCurrentFile<cr>", desc = "Open LayzGit (Root)" },
		},
	},
}
