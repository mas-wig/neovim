return {
	{
		"ray-x/go.nvim",
		branch = "master",
		ft = { "go", "gomod" },
		build = ":GoInstallBinaries",
		config = function()
			require("setup.plugins.go").init()
			require("setup.plugins.go").setup()
		end,
	},
}
