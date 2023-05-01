local wb = {}
local conditions = require("heirline.conditions")

wb.lspstatus = {
	condition = require("heirline.conditions").lsp_attached,
	update = {
		"LspDetach",
		"LspAttach",
		callback = vim.schedule_wrap(function()
			vim.cmd("redrawstatus")
		end),
	},
	provider = function()
		local names = {}
		for _, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
			if server.name ~= 0 and server.name ~= "null-ls" then
				table.insert(names, "  ")
			end
		end
		return table.concat(names, " ")
	end,
	hl = { fg = "pink" },
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
			return "  " .. string.gsub(vim.fn.expand("%"), "/", "   ")
		end,
		hl = { fg = "yellow3", bold = true },
	},
	wb.lspstatus,
	{
		provider = function()
			return "] "
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
		hl = { fg = "red3", bold = true },
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
		hl = { fg = "yellow", bold = true },
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
		hl = { fg = "blue", bold = true },
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
		hl = { fg = "green", bold = true },
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
