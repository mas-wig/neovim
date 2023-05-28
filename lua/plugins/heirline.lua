return {
	"rebelot/heirline.nvim",
	event = { "UiEnter" },
	dependencies = { "tiagovla/scope.nvim", config = true },
	config = function()
		require("heirline").setup({
			statusline = require("setup.plugins.heirline.statusline"),
			statuscolumn = require("setup.plugins.heirline.statuscolumn"),
			winbar = require("setup.plugins.heirline.winbar").winbar,
			opts = {
				colors = require("setup.ui.colors"),
				disable_winbar_cb = require("setup.plugins.heirline.winbar").disable_winbar_cb,
			},
		})
	end,
}
