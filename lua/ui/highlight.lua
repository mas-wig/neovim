local config = require("tokyonight.config")
local util = require("tokyonight.util")
local colors = require("tokyonight.colors")
local options = config.options
local theme = {
	config = options,
	colors = colors.setup(),
}

local c = theme.colors
return {
	DiagnosticVirtualTextError = { bg = "none", fg = c.error }, -- Used for "Error" diagnostic virtual text
	DiagnosticVirtualTextWarn = { bg = "none", fg = c.warning }, -- Used for "Warning" diagnostic virtual text
	DiagnosticVirtualTextInfo = { bg = "none", fg = c.info }, -- Used for "Information" diagnostic virtual text
	DiagnosticVirtualTextHint = { bg = "none", fg = c.hint }, -- Used for "Hint" diagnostic virtual text
}
