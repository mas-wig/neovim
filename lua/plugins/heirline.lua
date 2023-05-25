return {
	"rebelot/heirline.nvim",
	event = { "UiEnter" },
	init = function()
		vim.api.nvim_create_autocmd("BufWinEnter", {
			pattern = "*",
			callback = function()
				if vim.bo.filetype ~= "alpha" then
					vim.opt.showtabline = 2
				end
			end,
		})
	end,
	keys = {
		{
			"<leader>p",
			function()
				local tabline = require("heirline").tabline
				local buflist = tabline._buflist[1]
				buflist._picker_labels = {}
				buflist._show_picker = true
				vim.cmd.redrawtabline()
				local char = vim.fn.getcharstr()
				local bufnr = buflist._picker_labels[char]
				if bufnr then
					vim.api.nvim_win_set_buf(0, bufnr)
				end
				buflist._show_picker = false
				vim.cmd.redrawtabline()
			end,
			desc = "Tabline Picker",
		},
	},
	dependencies = { "tiagovla/scope.nvim", config = true },
	config = function()
		require("heirline").setup({
			tabline = require("setup.plugins.heirline.tabline"),
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
