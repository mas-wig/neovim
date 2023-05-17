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
		name = "SaveSession",
		clear = true,
		{
			{ "VimLeavePre" },
			function(event)
				local filetype = vim.api.nvim_get_option_value("filetype", { buf = event.buf })
				if not vim.tbl_contains({ "gitcommit", "gitrebase" }, filetype) then
					local save = require("resession").save
					save("Last Session")
					save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
				end
			end,
		},
	},

	{
		name = "AlphaSetup",
		clear = true,
		desc = "Disable status and tablines for alpha",
		{
			{ "User", "BufEnter" },
			function(event)
				if
					(
						(event.event == "User" and event.file == "AlphaReady")
						or (
							event.event == "BufEnter"
							and vim.api.nvim_get_option_value("filetype", { buf = event.buf }) == "alpha"
						)
					) and not vim.g.before_alpha
				then
					vim.g.before_alpha =
						{ showtabline = vim.opt.showtabline:get(), laststatus = vim.opt.laststatus:get() }
					vim.opt.showtabline, vim.opt.laststatus = 0, 0
				elseif
					vim.g.before_alpha
					and event.event == "BufEnter"
					and vim.api.nvim_get_option_value("buftype", { buf = event.buf }) ~= "nofile"
				then
					vim.opt.laststatus, vim.opt.showtabline =
						vim.g.before_alpha.laststatus, vim.g.before_alpha.showtabline
					vim.g.before_alpha = nil
				end
			end,
		},
		{
			{ "VimEnter" },
			function()
				local should_skip = false
				if vim.fn.argc() > 0 or vim.fn.line2byte(vim.fn.line("$")) ~= -1 or not vim.o.modifiable then
					should_skip = true
				else
					for _, arg in pairs(vim.v.argv) do
						if arg == "-b" or arg == "-c" or vim.startswith(arg, "+") or arg == "-S" then
							should_skip = true
							break
						end
					end
				end
				if not should_skip then
					require("alpha").start(true, require("alpha").default_config)
				end
			end,
		},
	},
}
