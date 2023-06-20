return function()
	local resession = require("resession")
	local visible_buffers = {}
	resession.setup({
		autosave = {
			enabled = true,
			notify = false,
		},
		tab_buf_filter = function(tabpage, bufnr)
			local dir = vim.fn.getcwd(-1, vim.api.nvim_tabpage_get_number(tabpage))
			return vim.startswith(vim.api.nvim_buf_get_name(bufnr), dir)
		end,
		buf_filter = function(bufnr)
			if not resession.default_buf_filter(bufnr) then
				return false
			end
			return visible_buffers[bufnr]
		end,
	})

	resession.add_hook("pre_save", function()
		visible_buffers = {}
		for _, winid in ipairs(vim.api.nvim_list_wins()) do
			if vim.api.nvim_win_is_valid(winid) then
				visible_buffers[vim.api.nvim_win_get_buf(winid)] = winid
			end
		end
	end)
end
