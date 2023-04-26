return {
	{
		"rebelot/heirline.nvim",
		event = "VeryLazy",
		dependencies = { "tiagovla/scope.nvim", config = true },
		config = function()
			local configs = require("plugins.heirline.config")
			configs.colorscheme()
			require("heirline").setup({
				tabline = {
					configs.tabline,
				},
				statusline = {
					configs.statusline,
				},
				statuscolumn = {
					configs.statuscoloumn,
				},
				winbar = {
					configs.winbar,
				},
				opts = { configs.opts },
			})
			vim.api.nvim_create_user_command("HeirlineResetStatusline", function()
				vim.o.statusline = "%{%v:lua.require'heirline'.eval_statusline()%}"
			end, {})
			vim.opt_local.winbar = "%{%v:lua.require'heirline'.eval_winbar()%}"
		end,
	},
}
