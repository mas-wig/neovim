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
		"public",
		"*.iml",
		"*.meta",
	},
	border = "rounded",
	max_width = 120,
	maxHeight = 20,
	tmux = true,
	formatPaths = true,
	key = "<c-p>",
})
