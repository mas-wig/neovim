return {
	setup = function()
		require("jfind").setup({
			exclude = {
				".git",
				".idea",
				".vscode",
				".sass-cache",
				".class",
				"__pycache__",
				"node_modules",
				"target",
				"build",
				"tmp",
				"assets",
				"dist",
				-- "public",
				"*.iml",
				"*.meta",
			},
			border = "rounded",
			max_width = 120,
			maxHeight = 20,
			tmux = true,
			formatPaths = true,
			key = "<leader>fF",
		})
	end,
	keys = {
		{
			"<leader>fF",
			function()
				local jfind = require("jfind")
				jfind.findFile({
					formatPaths = true,
					callback = {
						[key.DEFAULT] = vim.cmd.edit,
						[key.CTRL_S] = vim.cmd.split,
						[key.CTRL_V] = vim.cmd.vsplit,
					},
				})
			end,
			desc = "Find File [<C-s> split] [<C-v> vert]",
		},
	},
}
