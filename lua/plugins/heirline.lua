return {
	"rebelot/heirline.nvim",
	event = { "UiEnter" },
	-- keys = {
	-- 	{
	-- 		"<leader>p",
	-- 		function()
	-- 			local tabline = require("heirline").tabline
	-- 			local buflist = tabline._buflist[1]
	-- 			buflist._picker_labels = {}
	-- 			buflist._show_picker = true
	-- 			vim.cmd.redrawtabline()
	-- 			local char = vim.fn.getcharstr()
	-- 			local bufnr = buflist._picker_labels[char]
	-- 			if bufnr then
	-- 				vim.api.nvim_win_set_buf(0, bufnr)
	-- 			end
	-- 			buflist._show_picker = false
	-- 			vim.cmd.redrawtabline()
	-- 		end,
	-- 		desc = "Tabline Picker",
	-- 	},
	-- },
	dependencies = { "tiagovla/scope.nvim", config = true },
	config = function()
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

		require("heirline").setup({
			-- tabline = require("setup.plugins.heirline.tabline"),
			statusline = require("setup.plugins.heirline.statusline"),
			statuscolumn = require("setup.plugins.heirline.statuscolumn"),
			winbar = require("setup.plugins.heirline.winbar"),
			opts = {
				colors = require("setup.ui.colors"),
				disable_winbar_cb = function(args)
					if vim.bo[args.buf].filetype == "neo-tree" then
						return
					end
					return require("heirline.conditions").buffer_matches({
						buftype = buftype,
						filetype = filetype,
					}, args.buf)
				end,
			},
		})
	end,
}
