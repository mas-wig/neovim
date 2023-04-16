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

	CmpItemKindConstant = { fg = cl.base09 },
	CmpItemKindFunction = { fg = cl.base0D },
	CmpItemKindIdentifier = { fg = cl.base08 },
	CmpItemKindField = { fg = cl.base08 },
	CmpItemKindVariable = { fg = cl.base0E },
	CmpItemKindSnippet = { fg = cl.red },
	CmpItemKindText = { fg = cl.base0B },
	CmpItemKindStructure = { fg = cl.base0E },
	CmpItemKindType = { fg = cl.base0A },
	CmpItemKindKeyword = { fg = cl.base07 },
	CmpItemKindMethod = { fg = cl.base0D },
	CmpItemKindConstructor = { fg = cl.blue },
	CmpItemKindFolder = { fg = cl.base07 },
	CmpItemKindModule = { fg = cl.base0A },
	CmpItemKindProperty = { fg = cl.base08 },
	CmpItemKindEnum = { fg = cl.blue },
	CmpItemKindUnit = { fg = cl.base0E },
	CmpItemKindClass = { fg = cl.teal },
	CmpItemKindFile = { fg = cl.base07 },
	CmpItemKindInterface = { fg = cl.green },
	CmpItemKindColor = { fg = cl.white },
	CmpItemKindReference = { fg = cl.base05 },
	CmpItemKindEnumMember = { fg = cl.purple },
	CmpItemKindStruct = { fg = cl.base0E },
	CmpItemKindValue = { fg = cl.cyan },
	CmpItemKindEvent = { fg = cl.yellow },
	CmpItemKindOperator = { fg = cl.base05 },
	CmpItemKindTypeParameter = { fg = cl.base08 },
	CmpItemKindCopilot = { fg = cl.green },
}
