return require("noice").setup({
	cmdline = {
		enabled = true,
		view = "cmdline",
	},
	notify = {
		enabled = true,
		view = "notify",
	},
	popupmenu = {
		enabled = true,
		backend = "nui",
	},
	lsp = {
		progress = {
			enabled = false,
		},
		hover = {
			enabled = true,
		},
		signature = {
			enabled = true,
		},
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
	},
	presets = {
		bottom_search = false,
		command_palette = false,
		long_message_to_split = true,
		inc_rename = false,
		lsp_doc_border = true,
	},
	markdown = {
		hover = {
			["|(%S-)|"] = vim.cmd.help, -- vim help links
			["%[.-%]%((%S-)%)"] = require("noice.util").open, -- markdown links
		},
		highlights = {
			["|%S-|"] = "@text.reference",
			["@%S+"] = "@parameter",
			["^%s*(Parameters:)"] = "@text.title",
			["^%s*(Return:)"] = "@text.title",
			["^%s*(See also:)"] = "@text.title",
			["{%S-}"] = "@parameter",
		},
	},
	smart_move = {
		enabled = true,
		excluded_filetypes = { "sql", "cmp_menu", "cmp_docs", "notify" },
	},
})
