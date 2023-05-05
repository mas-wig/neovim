return require("noice").setup({
	cmdline = {
		enabled = true,
		view = "cmdline",
		format = {
			cmdline = { pattern = "^:", icon = " CMD :", lang = "vim" },
			search_down = { kind = "search", pattern = "^/", icon = " SEARCH UP :", lang = "regex" },
			search_up = { kind = "search", pattern = "^%?", icon = " SEARCH DOWN :", lang = "regex" },
			filter = { pattern = "^:%s*!", icon = " SHELL CMD :", lang = "bash" },
			lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "  ", lang = "lua" },
			help = { pattern = "^:%s*he?l?p?%s+", icon = " Help :" },
		},
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
			enabled = true,
		},
		hover = {
			enabled = true,
		},
		signature = {
			enabled = true,
			auto_open = { enabled = false },
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
