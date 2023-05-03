vim.filetype.add({
	extension = {
		tmk = "tcl",
		conf = "toml",
	},
	filename = {
		["gerrit_hooks"] = "toml",
		["setup.cfg"] = "toml",
		["lit.cfg"] = "python",
		["lit.local.cfg"] = "python",
		["dotshrc"] = "sh",
		["dotsh"] = "sh",
		["dotcshrc"] = "csh",
		["gitconfig"] = "gitconfig",
	},
	pattern = {
		[".*%.conf"] = "conf",
		[".*%.theme"] = "conf",
		[".*%.gradle"] = "groovy",
		[".*%.env%..*"] = "env",
	},
})
