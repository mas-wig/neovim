return {
	{
		"ray-x/go.nvim",
		ft = { "go", "gomod" },
		build = ":GoInstallBinaries",
		config = function()
			require("setup.plugins.go")()
		end,
	},
}
