return {
	-- {
	-- 	name = "ConcealAttributes",
	-- 	{
	-- 		{ "BufEnter", "BufWritePost", "TextChanged", "InsertLeave" },
	-- 		function()
	-- 			local bufnr = vim.api.nvim_get_current_buf()
	-- 			require("setup.utils.functions").ConcealHTML(bufnr)
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
	-- Code Folding and cursor
	{
		name = "CodeFolding",
		{
			"BufWinLeave",
			function()
				local ignoredFts = {
					"TelescopePrompt",
					"DressingSelect",
					"DressingInput",
					"toggleterm",
					"gitcommit",
					"replacer",
					"harpoon",
					"help",
					"qf",
				}
				if vim.tbl_contains(ignoredFts, vim.bo.filetype) or vim.bo.buftype ~= "" or not vim.bo.modifiable then
					return
				end

				return vim.cmd.mkview(1)
			end,
			opts = { pattern = "?*" },
		},
		{
			"BufWinEnter",
			function()
				local ignoredFts = {
					"TelescopePrompt",
					"DressingSelect",
					"DressingInput",
					"toggleterm",
					"gitcommit",
					"replacer",
					"harpoon",
					"help",
					"qf",
				}
				if vim.tbl_contains(ignoredFts, vim.bo.filetype) or vim.bo.buftype ~= "" or not vim.bo.modifiable then
					return
				end

				pcall(function()
					vim.cmd.loadview(1)
				end)
			end,
			opts = { pattern = "?*" },
		},
	},

	{
		name = "ShowTabLine",
		{
			{ "BufWinEnter" },
			function()
				if vim.bo.filetype ~= "alpha" then
					vim.opt.showtabline = 2
				end
			end,
			pattern = { opts = { "*" } },
		},
	},

	-- Save File
	{
		name = "SaveFile",
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
		name = "GoFormat",
		{
			{ "BufWritePre" },
			opts = { pattern = "*.go" },
			function()
				require("go.format").goimport()
			end,
		},
	},

	{
		name = "LspProgressRefresh",
		{
			{ "User" },
			opts = { pattern = "LspProgressStatusUpdated" },
			function()
				vim.cmd("redrawstatus")
			end,
		},
	},
}
