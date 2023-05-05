return {
	{
		"lewis6991/gitsigns.nvim",
		cmd = "Gitsigns",
		config = function()
			require("setup.plugins.gitsigns")
		end,
	},
	{
		"pwntester/octo.nvim",
		cmd = "Octo",
		config = function ()
		  require("setup.plugins.octo")
		end,
	},
}
