local wb = {}
local conditions = require("heirline.conditions")

wb.fileFlag = {
	{
		{
			provider = function()
				local filetype_icon, filetype_hl = require("nvim-web-devicons").get_icon_by_filetype(vim.bo.filetype)
				return (filetype_icon and "%#" .. filetype_hl .. "#" .. " " .. filetype_icon) or ""
			end,
		},
	},
	{
		condition = function()
			return vim.bo.modified
		end,
		provider = " ",
		hl = { fg = "red" },
	},
}

wb.fileLocation = {
	{
		provider = function()
			return "[ "
		end,
		hl = { fg = "white", bold = true },
	},
	{
		provider = function()
			return "  " .. vim.fn.expand("%")
		end,
		hl = { fg = "blue", bold = true },
	},
	wb.fileFlag,
	{
		provider = function()
			return " ] "
		end,
		hl = { fg = "white", bold = true },
	},
}

wb.lspDiagnostics = {
	condition = conditions.has_diagnostics,
	init = function(self)
		self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
		self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
		self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
		self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
	end,
	on_click = {
		callback = function()
			vim.cmd("normal gf")
		end,
		name = "heirline_diagnostics",
	},
	update = { "DiagnosticChanged", "BufEnter" },
	{
		condition = function(self)
			return self.errors > 0
		end,
		hl = { fg = "red3" },
		{
			provider = function(self)
				return vim.fn.sign_getdefined("DiagnosticSignError")[1].text .. self.errors .. " "
			end,
		},
	},
	-- Warnings
	{
		condition = function(self)
			return self.warnings > 0
		end,
		hl = { fg = "yellow" },
		{
			{
				provider = function(self)
					return vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text .. self.warnings .. " "
				end,
			},
		},
	},
	-- Hints
	{
		condition = function(self)
			return self.hints > 0
		end,
		hl = { fg = "blue" },
		{
			{
				provider = function(self)
					return " " .. vim.fn.sign_getdefined("DiagnosticSignHint")[1].text .. self.hints .. " "
				end,
			},
		},
	},
	{
		condition = function(self)
			return self.info > 0
		end,
		hl = { fg = "green" },
		{
			{
				provider = function(self)
					return " " .. vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text .. self.info .. " "
				end,
			},
		},
	},
}

wb.navic = {
	condition = function()
		return require("nvim-navic").is_available()
	end,
	init = function(self)
		self.navic = require("nvim-navic").get_location()
	end,
	update = "CursorMoved",
	{
		condition = function(self)
			if #self.navic > 0 then
				return true
			else
				return false
			end
		end,
		{
			flexible = 3,
			{
				provider = function(self)
					return "  " .. self.navic
				end,
			},
			{
				provider = "",
			},
		},
		hl = { fg = "red", italic = true },
	},
}

return wb
