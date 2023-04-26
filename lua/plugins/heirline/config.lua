local config = {}

config.utils = require("heirline.utils")
config.conditions = require("heirline.conditions")

config.colors = require("ui.colors")
config.set_statusline = require("plugins.heirline.statusline")
config.set_tabline = require("plugins.heirline.bufferline")
config.set_statuscoloumn = require("plugins.heirline.statuscoloumn")
config.set_winbar = require("plugins.heirline.winbar")

config.buftype = { "lazy", "nofile", "prompt", "help", "quickfix" }
config.filetype = {
	"^git.*",
	"lazy",
	"fugitive",
	"Trouble",
	"dashboard",
	"^git.*",
	"^neo--tree$",
	"^neotest--summary$",
	"^neo--tree--popup$",
	"^toggleterm$",
	"^TelescopePrompt$",
	"^aerial$",
	"^alpha$",
	"^DressingInput$",
	"^netrw$",
}

config.colorscheme = function()
	require("heirline").load_colors(config.colors)
	local aug = vim.api.nvim_create_augroup("Heirline", { clear = true })
	vim.api.nvim_create_autocmd("ColorScheme", {
		desc = "Update Heirline colors",
		group = aug,
		callback = function()
			config.utils.on_colorscheme(config.colors)
		end,
	})
end

config.align = { provider = "%=" }
config.spacer = { provider = " ", fg = "yellow" }

config.statusline = config.utils.insert(
	{
		static = config.set_statusline.stl_static,
		hl = { bg = "bg" },
	},
	config.set_statusline.vimMode,
	config.set_statusline.git,
	config.set_statusline.macroRecording,
	require("plugins.heirline.component").left_components,
	{ provider = "%=" },
	require("plugins.heirline.component").right_components,
	config.set_statusline.fileType,
	config.set_statusline.lazy,
	config.set_statusline.lspstatus,
	config.set_statusline.ruler,
	config.set_statusline.fileLastModified
)

config.statuscoloumn = {
	condition = function()
		return not config.conditions.buffer_matches({
			buftype = config.buftype,
			filetype = config.filetype,
		})
	end,
	static = config.set_statuscoloumn.static,
	init = config.set_statuscoloumn.init,
	config.set_statuscoloumn.signs,
	config.spacer,
	config.align,
	config.set_statuscoloumn.line_numbers,
	config.spacer,
	config.set_statuscoloumn.git_signs,
	config.spacer,
	config.set_statuscoloumn.folds,
	config.spacer,
}

config.tabline = {
	condition = function()
		return not config.conditions.buffer_matches({
			buftype = config.buftype,
			filetype = config.filetype,
		})
	end,
	config.set_tabline,
}

config.winbar = {
	{
		condition = function()
			return config.conditions.buffer_matches({
				buftype = config.buftype,
				filetype = config.filetype,
			})
		end,
		init = function()
			vim.opt_local.winbar = nil
		end,
	},
	config.set_winbar.navic,
	require("plugins.heirline.component").left_components,
	{ provider = "%=" },
	require("plugins.heirline.component").right_components,
	config.set_winbar.lspDiagnostics,
}

config.opts = {
	colors = config.colors,
	disable_winbar_cb = function(args)
		if vim.bo[args.buf].filetype == "neo-tree" then
			return
		end
		return config.conditions.buffer_matches({
			buftype = config.buftype,
			filetype = config.filetype,
		}, args.buf)
	end,
}
return config
