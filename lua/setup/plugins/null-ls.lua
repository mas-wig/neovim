return function()
	local null_ls = require("null-ls")
	null_ls.setup({
		root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
		sources = {
			null_ls.builtins.formatting.stylua.with({
				extra_args = {
					"--indent-type",
					"Tabs",
					"--indent-width",
					"4",
				},
			}),
			null_ls.builtins.formatting.prettier.with({
				extra_args = {
					"--use-tabs",
					"true",
					"--tab-width",
					"4",
				},
			}),
		},
	})
end
