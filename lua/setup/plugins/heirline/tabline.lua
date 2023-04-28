local utils = require("heirline.utils")

local Tabpage = {
	provider = function(self)
		return "%" .. self.tabnr .. "T " .. self.tabnr .. " %T"
	end,
	hl = function(self)
		if not self.is_active then
			return "TabLine"
		else
			return "TabLineSel"
		end
	end,
	update = { "TabNew", "TabClosed", "TabEnter", "TabLeave", "WinNew", "WinClosed" },
}

local TabPages = {
	-- only show this component if there's 2 or more tabpages
	condition = function()
		return #vim.api.nvim_list_tabpages() >= 2
	end,
	{ provider = "%=" },
	utils.make_tablist(Tabpage),
}

return TabPages
