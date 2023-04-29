return {
	"rebelot/heirline.nvim",
	event = { "VimEnter" },
	dependencies = { "tiagovla/scope.nvim", config = true },
	config = function()
		local filetype = {
			"^git.*",
			"fugitive",
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
			"quickfix",
		}
		local align = { provider = "%=" }
		local spacer = { provider = " " }
		local statusline = require("setup.plugins.heirline.statusline")
		local winbar = require("setup.plugins.heirline.winbar")
		local tabline = require("setup.plugins.heirline.bufferline")
		local sc = require("setup.plugins.heirline.statuscolumn")
		local conditions = require("heirline.conditions")

		require("heirline").setup({
			tabline = {
				condition = function()
					return not conditions.buffer_matches({
						buftype = buftype,
						filetype = filetype,
					})
				end,
				tabline,
			},
			statusline = require("heirline.utils").insert(
				{
					static = statusline.stl_static,
					hl = { bg = "bg" },
				},
                spacer,
				statusline.vimMode,
				statusline.git,
				statusline.macroRecording,
				statusline.overseer,
				require("setup.plugins.heirline").left_components,
				{ provider = "%=" },
				require("setup.plugins.heirline").right_components,
				statusline.session,
				statusline.lazy,
				statusline.lspstatus,
				statusline.ruler,
				statusline.fileLastModified
			),
			statuscolumn = {
				condition = function()
					return not conditions.buffer_matches({
						buftype = buftype,
						filetype = filetype,
					})
				end,
				static = sc.static,
				init = sc.init,
				sc.signs,
				-- config.spacer,
				align,
				sc.line_numbers,
				spacer,
				sc.git_signs,
				spacer,
				sc.folds,
				spacer,
			},
			winbar = {
				{
					condition = function()
						return conditions.buffer_matches({
							buftype = buftype,
							filetype = filetype,
						})
					end,
					init = function()
						vim.opt_local.winbar = nil
					end,
				},
				winbar.navic,
				require("setup.plugins.heirline").left_components,
				{ provider = "%=" },
				require("setup.plugins.heirline").right_components,
				winbar.lspDiagnostics,
				spacer,
				winbar.fileLocation,
			},
			opts = {
				colors = require("setup.ui.colors"),
				disable_winbar_cb = function(args)
					if vim.bo[args.buf].filetype == "neo-tree" then
						return
					end
					return conditions.buffer_matches({
						buftype = buftype,
						filetype = filetype,
					}, args.buf)
				end,
			},
		})

		vim.api.nvim_create_user_command("HeirlineResetStatusline", function()
			vim.o.statusline = "%{%v:lua.require'heirline'.eval_statusline()%}"
		end, {})
		vim.opt_local.winbar = "%{%v:lua.require'heirline'.eval_winbar()%}"
	end,
}
