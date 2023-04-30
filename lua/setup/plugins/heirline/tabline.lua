local utils = require("heirline.utils")

local M = {}

M.tabpage = {
	provider = function(self)
		return "%" .. self.tabnr .. "T " .. self.tabnr .. " %T"
	end,
	hl = function(self)
		if not self.is_active then
			return { fg = "pink" }
		else
			return { fg = "black", bg = "blue", bold = true }
		end
	end,
	update = { "TabNew", "TabClosed", "TabEnter", "TabLeave", "WinNew", "WinClosed" },
}


M.tabPages = {
	condition = function()
		return #vim.api.nvim_list_tabpages() >= 2
	end,
	{ provider = "%=" },
	utils.make_tablist(M.tabpage),
}

return M
