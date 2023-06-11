return {
	{
		name = "ReturnToLastEditingPosition",
		{
			"BufReadPost",
			function()
				if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
					vim.fn.setpos(".", vim.fn.getpos("'\""))
					vim.api.nvim_feedkeys("zz", "n", true)
					vim.cmd("silent! foldopen")
				end
			end,
		},
	},
	{
		name = "FiletypeOptions",
		{
			"FileType",
			":setlocal shiftwidth=2 tabstop=2",
			opts = {
				pattern = { "html" },
			},
		},
		{
			"FileType",
			function()
				vim.opt_local.wrap = false
				vim.opt_local.textwidth = 0
				vim.opt_local.wrapmargin = 0
			end,
			opts = { pattern = "*.md" },
		},
	},
	{
		name = "QuickfixFormatting",
		{
			{ "BufEnter", "WinEnter" },
			":if &buftype == 'quickfix' | setlocal nocursorline | setlocal number | endif",
			opts = {
				pattern = { "*" },
			},
		},
	},
	{
		name = "RemoveWhitespaceOnSave",
		{
			{ "BufWritePre" },
			[[%s/\s\+$//e]],
			opts = {
				pattern = { "*" },
			},
		},
	},
	-- Highlight text when yanked
	{
		name = "HighlightYankedText",
		{
			"TextYankPost",
			function()
				vim.highlight.on_yank()
			end,
			opts = { pattern = "*" },
		},
	},
	{
		name = "Telescope",
		{
			"User",
			":setlocal wrap",
			opts = { pattern = "TelescopePreviewerLoaded" },
		},
	},
	-- Code Folding and cursor
	{
		name = "auto_views",
		clear = true,
		{
			{ "BufWinLeave", "BufWritePost", "WinLeave" },
			function(event)
				if vim.b[event.buf].view_activated then
					vim.cmd.mkview({ mods = { emsg_silent = true } })
				end
			end,
		},
		{
			{ "BufWinEnter" },
			function(event)
				if not vim.b[event.buf].view_activated then
					local filetype = vim.api.nvim_get_option_value("filetype", { buf = event.buf })
					local buftype = vim.api.nvim_get_option_value("buftype", { buf = event.buf })
					local ignore_filetypes = { "gitcommit", "gitrebase", "svg", "hgcommit" }
					if
						buftype == ""
						and filetype
						and filetype ~= ""
						and not vim.tbl_contains(ignore_filetypes, filetype)
					then
						vim.b[event.buf].view_activated = true
						vim.cmd.loadview({ mods = { emsg_silent = true } })
					end
				end
			end,
		},
	},

	-- Save File
	{
		name = "SaveFile",
		clear = true,
		{
			{ "BufWinLeave", "BufLeave", "QuitPre", "FocusLost", "InsertLeave" },
			opts = { pattern = "?*" },
			function()
				local filepath = vim.fn.expand("%:p")
				if
					vim.fn.filereadable(filepath) == 1
					and not vim.bo.readonly
					and vim.fn.expand("%") ~= ""
					and (vim.bo.buftype == "" or vim.bo.buftype == "acwrite")
					and vim.bo.filetype ~= "gitcommit"
				then
					vim.cmd.update(filepath)
				end
			end,
		},
	},
	{
		name = "FormatterGroup",
		clear = true,
		{
			{ "BufWritePost" },
			opts = { pattern = "*" },
			function()
				vim.cmd("FormatWrite")
			end,
		},
	},
}
