return {
	{
		"folke/tokyonight.nvim",
		event = "VimEnter",
		opts = {
			style = "night",
			transparent = false,
			terminal_colors = true,
			styles = {
				comments = { italic = true },
				keywords = { italic = true },
				functions = { italic = true, bold = true },
				variables = { italic = true },
				sidebars = "normal",
				floats = "normal", -- style for floating windows
			},
			sidebars = { "qf", "help", "lazy", "neo-tree", "TelescopePrompt" },
			hide_inactive_statusline = false,
			dim_inactive = false,
			lualine_bold = false,
			on_highlights = function(highlights, _)
				local override = require("setup.ui.hl")
				for name, color in pairs(override) do
					highlights[name] = color
				end
			end,
		},
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd.colorscheme("tokyonight")
		end,
	},
}
