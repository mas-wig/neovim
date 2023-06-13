return {
	"rebelot/heirline.nvim",
	event = { "UiEnter" },
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
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				require("heirline.utils").on_colorscheme(require("setup.ui.colors"))
			end,
			group = vim.api.nvim_create_augroup("Heirline", { clear = true }),
		})
	end,
}
