return {
	{
		name = "FormatOpt",
		{
			{ "BufEnter" },
			function()
				vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
			end,
			opts = { pattern = { "*" } },
		},
	},

	{
		name = "GoFormat",
		{
			{ "BufWritePre" },
			function()
				require("go.format").goimport()
			end,
			opts = { pattern = { "*.go" } },
		},
	},

	-- {
	-- 	name = "ConcealAttributes",
	-- 	{
	-- 		{ "BufEnter", "BufWritePost", "TextChanged", "InsertLeave" },
	-- 		function()
	-- 			local bufnr = vim.api.nvim_get_current_buf()
	-- 			require("setup.functions").ConcealHTML(bufnr)
	-- 		end,
	-- 		opts = {
	-- 			pattern = { "*.html" },
	-- 		},
	-- 	},
	-- },

	{
		name = "PersistedHooks",
		{
			"User",
			function(session)
				require("persisted").save()

				-- Delete all of the open buffers
				vim.api.nvim_input("<ESC>:%bd!<CR>")

				-- Don't start saving the session yet
				require("persisted").stop()
			end,
			opts = { pattern = "PersistedTelescopeLoadPre" },
		},
	},

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
			":setlocal shiftwidth=4 tabstop=4",
			opts = {
				pattern = { "ledger" },
			},
		},
		{
			"FileType",
			":setlocal wrap linebreak",
			opts = { pattern = "markdown" },
		},
		{
			"FileType",
			":setlocal showtabline=0",
			opts = { pattern = "alpha" },
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
		name = "ChangeMappingsInTerminal",
		{
			"TermOpen",
			function()
				if vim.bo.filetype == "" or vim.bo.filetype == "toggleterm" then
					local opts = { silent = false, buffer = 0 }
					vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
					vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
				end
			end,
			opts = {
				pattern = "term://*",
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
	{
		name = "SaveFold",
		{
			"BufWinLeave",
			":mkview",
			opts = { pattern = "*.*" },
		},
		{
			"BufWinEnter",
			":silent! loadview",
			opts = { pattern = "*.*" },
		},
	},

	{
		name = "LuaLineRerfesh",
		{
			"User",
			function()
				require("lualine").refresh()
			end,
			opts = {
				pattern = "LspProgressStatusUpdated",
			},
		},
	},

	{
		name = "FormatAutogroup",
		{
			"BufWritePost",
			":FormatWrite",
			opts = { pattern = "*" },
		},
	},
}
