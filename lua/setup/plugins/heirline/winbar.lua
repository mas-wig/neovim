local conditions = require("heirline.conditions")
local align = { provider = "%=" }
local spacer = { provider = " " }

local filetype = {
	"^git.*",
	"fugitive",
	"dbout",
	"^aerial$",
	"^alpha$",
	"^neo--tree$",
	"^neotest--summary$",
	"^neo--tree--popup$",
	"^NvimTree$",
	"^toggleterm$",
	"^netrw$",
	"^TelescopePrompt$",
	"^DressingInput$",
	"^lazy$",
}

local buftype = {
	"nofile",
	"prompt",
	"help",
	"terminal",
	"quickfix",
}

return {
	winbar = {
		{
			condition = function()
				return conditions.buffer_matches({
					buftype = buftype,
					filetype = filetype,
				})
			end,
			init = function()
				vim.opt_local.winbar = nil
			end,
		},
		----------------------------------------------------------
		-- Navic
		----------------------------------------------------------
		{
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
		},
		align,
		----------------------------------------------------------
		-- diagnostics
		----------------------------------------------------------
		{
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
					if vim.bo.filetype ~= "lazy" then
						return self.info > 0
					end
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
		},
		spacer,
		----------------------------------------------------------
		-- File location
		----------------------------------------------------------
		{
			provider = function()
				return "[   " .. string.gsub(vim.fn.expand("%:p:."), "/", " / ") .. " ]"
			end,
			hl = { fg = "yellow3", bold = true },
		},
		spacer,
	},
	disable_winbar_cb = function(args)
		return conditions.buffer_matches({
			buftype = buftype,
			filetype = filetype,
		}, args.buf)
	end,
}
