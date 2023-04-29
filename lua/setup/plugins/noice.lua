return require("noice").setup({
	cmdline = {
		enabled = true,
		view = "cmdline",
	},
	notify = {
		enabled = true,
		view = "notify",
	},
	lsp = {
		progress = {
			enabled = false,
		},
		hover = {
			enabled = false,
		},
		signature = {
			enabled = false,
		},
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
		smart_move = {
			enabled = true,
			excluded_filetypes = { "sql", "cmp_menu", "cmp_docs", "notify" },
		},
	},
	presets = {
		bottom_search = false,
		command_palette = false,
		long_message_to_split = true,
		inc_rename = false,
		lsp_doc_border = true,
	},
})
