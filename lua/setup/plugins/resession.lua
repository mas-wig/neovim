local M = {}

M.init = function()
	require("legendary").commands({
		itemgroup = "Resession",
		desc = "Remember me daddy......",
		commands = {
			{
				":ResessionList",
				function()
					require("resession").list()
				end,
				desc = "List Session",
			},
			{
				":ResessionDelete",
				function()
					require("resession").delete()
				end,
				desc = "Delete Session",
			},
			{
				":ResessionLoad",
				function()
					require("resession").load()
				end,
				desc = "Load Session",
			},
			{
				":ResessionSave",
				function()
					require("resession").save()
				end,
				desc = "Save Session",
			},
		},
	})
end

M.setup = function()
	local resession = require("resession")
	resession.setup({
		buf_filter = function(bufnr)
			if not bufnr or bufnr < 1 then
				return false
			end
			return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
		end,
		tab_buf_filter = function(tabpage, bufnr)
			return vim.tbl_contains(vim.t[tabpage].bufs, bufnr)
		end,
		extensions = { config_local = { enable_in_tab = true } },
	})
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			if vim.fn.argc(-1) == 0 then
				resession.load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
			end
		end,
	})
	vim.api.nvim_create_autocmd("VimLeavePre", {
		callback = function()
			resession.save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
		end,
	})
end
return M
