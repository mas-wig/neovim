local cl = require("setup.ui.colors")

return {
	-- Diagnostic
	DiagnosticVirtualTextError = { bg = cl.none, fg = cl.red },
	DiagnosticVirtualTextWarn = { bg = cl.none, fg = cl.yellow },
	DiagnosticVirtualTextInfo = { bg = cl.none, fg = cl.green },
	DiagnosticVirtualTextHint = { bg = cl.none, fg = cl.blue },

	-- Neotree
	NeoTreeIndentMarker = { fg = cl.cyan },
	NeoTreeWinSeparator = { fg = cl.line },
	NeoTreeDirectoryIcon = { fg = cl.yellow },
	NeoTreeFloatTitle = { fg = cl.black, bg = cl.green },
	NeoTreeFloatBorder = { fg = cl.red, bg = cl.none },
	NeoTreeRootName = { fg = cl.orange },
	-- General
	LineNr = { fg = cl.blue },
	CursorLineNr = { fg = cl.red, bold = true },
	NvimInternalError = { fg = cl.red },
	WinSeparator = { fg = cl.line },
	Pmenu = { bg = cl.one_bg },
	PmenuSbar = { bg = cl.one_bg },
	PmenuSel = { bg = cl.dark_purple, fg = cl.black },
	PmenuThumb = { bg = cl.grey },
	MatchParen = { link = "MatchWord" },
	Comment = { fg = cl.grey_fg },
	FloatBorder = { fg = cl.line },
	NormalFloat = { bg = cl.none },

	-- Navic
	NavicText = { fg = cl.cyan, bg = cl.none },
	NavicSeparator = { fg = cl.yellow, bg = cl.none },

	-- CMP
	CmpItemAbbr = { fg = cl.white },
	CmpItemAbbrMatch = { fg = cl.blue, bold = true },
	CmpDoc = { bg = cl.darker_black },
	CmpDocBorder = { fg = cl.darker_black, bg = cl.darker_black },
	CmpPmenu = { bg = cl.black },
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

	TreesitterContext = { bg = cl.none },

	-- Dev Icon Highlight
	DevIconDefault = { fg = cl.red },
	DevIconc = { fg = cl.blue },
	DevIconcss = { fg = cl.blue },
	DevIcondeb = { fg = cl.cyan },
	DevIconDockerfile = { fg = cl.cyan },
	DevIconhtml = { fg = cl.baby_pink },
	DevIconjpeg = { fg = cl.dark_purple },
	DevIconjpg = { fg = cl.dark_purple },
	DevIconjs = { fg = cl.sun },
	DevIconkt = { fg = cl.orange },
	DevIconlock = { fg = cl.red },
	DevIconlua = { fg = cl.blue },
	DevIconmp3 = { fg = cl.white },
	DevIconmp4 = { fg = cl.white },
	DevIconout = { fg = cl.white },
	DevIconpng = { fg = cl.dark_purple },
	DevIconpy = { fg = cl.cyan },
	DevIcontoml = { fg = cl.blue },
	DevIconts = { fg = cl.teal },
	DevIconttf = { fg = cl.white },
	DevIconrb = { fg = cl.pink },
	DevIconrpm = { fg = cl.orange },
	DevIconvue = { fg = cl.vibrant_green },
	DevIconwoff = { fg = cl.white },
	DevIconwoff2 = { fg = cl.white },
	DevIconxz = { fg = cl.sun },
	DevIconzip = { fg = cl.sun },
	DevIconZig = { fg = cl.orange },
	DevIconMd = { fg = cl.blue },
	DevIconTSX = { fg = cl.blue },
	DevIconJSX = { fg = cl.blue },
	DevIconSvelte = { fg = cl.red },
	DevIconJava = { fg = cl.orange },

	-- Mason
	MasonHeader = { bg = cl.red, fg = cl.black },
	MasonHighlight = { fg = cl.blue },
	MasonHighlightBlock = { fg = cl.black, bg = cl.green },
	MasonHighlightBlockBold = { link = "MasonHighlightBlock" },
	MasonHeaderSecondary = { link = "MasonHighlightBlock" },
	MasonMuted = { fg = cl.light_grey },
	MasonMutedBlock = { fg = cl.light_grey, bg = cl.one_bg },

	-- Telescope
	TelescopePromptTitle = { fg = cl.black, bg = cl.red },
	TelescopeSelection = { bg = cl.black2, fg = cl.white },
	TelescopeResultsDiffAdd = { fg = cl.green },
	TelescopeResultsDiffChange = { fg = cl.yellow },
	TelescopeResultsDiffDelete = { fg = cl.red },
	TelescopeBorder = { fg = cl.one_bg3 },
	TelescopePromptBorder = { fg = cl.one_bg3 },
	TelescopeResultsTitle = { fg = cl.black, bg = cl.green },
	TelescopePreviewTitle = { fg = cl.black, bg = cl.blue },
	TelescopePromptPrefix = { fg = cl.red, bg = cl.none },
	TelescopeNormal = { bg = cl.none },
	TelescopePromptNormal = { bg = cl.none },

	-- Which-key
	WhichKey = { fg = cl.blue },
	WhichKeySeparator = { fg = cl.light_grey },
	WhichKeyDesc = { fg = cl.red },
	WhichKeyGroup = { fg = cl.green },
	WhichKeyValue = { fg = cl.green },

	-- Notify
	NotifyERRORBorder = { fg = cl.red },
	NotifyERRORIcon = { fg = cl.red },
	NotifyERRORTitle = { fg = cl.red },
	NotifyWARNBorder = { fg = cl.orange },
	NotifyWARNIcon = { fg = cl.orange },
	NotifyWARNTitle = { fg = cl.orange },
	NotifyINFOBorder = { fg = cl.green },
	NotifyINFOIcon = { fg = cl.green },
	NotifyINFOTitle = { fg = cl.green },
	NotifyDEBUGBorder = { fg = cl.grey },
	NotifyDEBUGIcon = { fg = cl.grey },
	NotifyDEBUGTitle = { fg = cl.grey },
	NotifyTRACEBorder = { fg = cl.purple },
	NotifyTRACEIcon = { fg = cl.purple },
	NotifyTRACETitle = { fg = cl.purple },

	GitSignsAdd = { fg = cl.green },
	GitSignsChange = { fg = cl.yellow },
	GitSignsDelete = { fg = cl.red },
}
