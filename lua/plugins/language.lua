return {
	{
		"ray-x/go.nvim",
		ft = { "go", "gomod" },
		build = ":GoInstallBinaries",
		-- dependencies = { "ray-x/guihua.lua", build = "cd lua/fzy && make" },
		config = function()
			require("setup.plugins.go")()
		end,
	},
}
