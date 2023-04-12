local config = require("tokyonight.config")
local colors = require("tokyonight.colors")
local options = config.options
local theme = {
	config = options,
	colors = colors.setup(),
}

local c = theme.colors

local cl = require("ui.colors")

return {
	DiagnosticVirtualTextError = { bg = "none", fg = c.error },
	DiagnosticVirtualTextWarn = { bg = "none", fg = c.warning },
	DiagnosticVirtualTextInfo = { bg = "none", fg = c.info },
	DiagnosticVirtualTextHint = { bg = "none", fg = c.hint },

	NeoTreeIndentMarker = { bg = "none", fg = cl.cyan },
	NeoTreeWinSeparator = { bg = "none", fg = cl.yellow },
	PmenuSel = { bg = cl.violet2 },
	GitSignsAdd = { fg = cl.green2 },
	GitSignsChange = { fg = cl.yellow3 },
	GitSignsDelete = { fg = cl.red },
	LineNr = { fg = cl.yellow2 },
	-- FoldColumn = { bg = options.transparent and c.none or c.bg, fg = cl.cyan },
	CursorLineNr = { fg = cl.magenta2 },
	TelescopePromptTitle = { fg = cl.black, bg = cl.red2 },
	TelescopePreviewTitle = { fg = cl.black, bg = cl.cyan },
	TelescopeResultsTitle = { fg = cl.black, bg = cl.yellow2 },
	FloatBorder = { fg = c.border_highlight, bg = c.bg_float },
	WinSeparator = { fg = cl.magenta, bold = false },
	NeoTreeDirectoryIcon = { fg = cl.yellow3, bg = "none" },
	NavicText = { fg = cl.cyan, bg = c.none },
	NavicSeparator = { fg = cl.yellow2, bg = c.none },
}
