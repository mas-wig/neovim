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
			null_ls.builtins.formatting.prettierd,
			null_ls.builtins.formatting.autopep8,
			null_ls.builtins.formatting.clang_format,
			-- null_ls.builtins.diagnostics.staticcheck,
			null_ls.builtins.code_actions.refactoring,
		},
	})
end
