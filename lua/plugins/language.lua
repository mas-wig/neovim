return {
	{
		"ray-x/go.nvim",
		branch = "master",
		ft = { "go", "gomod" },
		build = ":GoInstallBinaries",
		dependencies = {
			"ray-x/guihua.lua",
			branch = "master",
			build = "cd lua/fzy && make",
			lazy = true,
		},
		config = function()
			require("setup.plugins.go").init()
			require("setup.plugins.go").setup()
		end,
	},
}
