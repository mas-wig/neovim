return {
	{
		"ray-x/go.nvim",
		branch = "master",
		ft = { "go", "gomod" },
		build = ":GoInstallBinaries",
		keys = require("setup.plugins.go").keys,
		config = function()
			require("setup.plugins.go").setup()
		end,
	},
}
