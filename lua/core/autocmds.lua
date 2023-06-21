local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight URL
autocmd({ "VimEnter", "FileType", "BufEnter", "WinEnter" }, {
	desc = "URL Highlighting",
	group = augroup("highlighturl", { clear = true }),
	callback = function()
		require("setup.utils.functions").set_url_match()
	end,
})

-- Return last editing position
autocmd("BufReadPost", {
	group = augroup("ReturnToLastEditingPosition", {}),
	callback = function()
		if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
			vim.fn.setpos(".", vim.fn.getpos("'\""))
			vim.api.nvim_feedkeys("zz", "n", true)
			vim.cmd("silent! foldopen")
		end
	end,
})

local fileOptions = augroup("FileOptions", { clear = true })
autocmd("FileType", {
	pattern = "html",
	group = fileOptions,
	callback = function()
		vim.cmd("setlocal shiftwidth=2 tabstop=2")
	end,
})

autocmd("FileType", {
	pattern = "markdown",
	group = fileOptions,
	callback = function()
		vim.opt_local.textwidth = 0
		vim.opt_local.wrapmargin = 0
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
	end,
})

autocmd({ "BufEnter", "WinEnter" }, {
	pattern = "*",
	group = augroup("QuickfixFormatting", { clear = true }),
	callback = function()
		vim.cmd(":if &buftype == 'quickfix' | setlocal nocursorline | setlocal number | endif")
	end,
})

autocmd("BufWritePre", {
	group = augroup("RemoveWhitespaceOnSave", { clear = true }),
	pattern = "*",
	callback = function()
		vim.cmd([[%s/\s\+$//e]])
	end,
})

autocmd("TextYankPost", {
	group = augroup("HighlightYankedText", { clear = true }),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank()
	end,
})

local setview = augroup("AutoViews", { clear = true })
autocmd({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
	group = setview,
	callback = function(event)
		if vim.b[event.buf].view_activated then
			vim.cmd.mkview({ mods = { emsg_silent = true } })
		end
	end,
})

autocmd("BufWinEnter", {
	group = setview,
	callback = function(event)
		if not vim.b[event.buf].view_activated then
			local filetype = vim.api.nvim_get_option_value("filetype", { buf = event.buf })
			local buftype = vim.api.nvim_get_option_value("buftype", { buf = event.buf })
			local ignore_filetypes = { "gitcommit", "gitrebase", "svg", "hgcommit" }
			if buftype == "" and filetype and filetype ~= "" and not vim.tbl_contains(ignore_filetypes, filetype) then
				vim.b[event.buf].view_activated = true
				vim.cmd.loadview({ mods = { emsg_silent = true } })
			end
		end
	end,
})

autocmd({ "BufWinLeave", "BufLeave", "QuitPre", "FocusLost", "InsertLeave" }, {
	group = augroup("SaveFile", { clear = true }),
	pattern = "*",
	callback = function()
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
})

autocmd("BufWritePost", {
	pattern = "*",
	group = augroup("FormatterGroup", { clear = true }),
	callback = function()
		vim.cmd("FormatWrite")
	end,
})

autocmd("VimLeavePre", {
	group = augroup("CfgResession", {}),
	pattern = "*",
	callback = function()
		require("resession").save("Last Session")
	end,
})
