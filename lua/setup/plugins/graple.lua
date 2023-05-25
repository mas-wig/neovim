local M = {}

M.init = function()
	require("legendary").keymaps({
		{
			itemgroup = "Graple",
			description = "Grap me Daddy",
			icon = "🔭",
			keymaps = {
				{
					"<leader>jm",
					function()
						require("grapple").toggle()
					end,
					desc = "GrapleToggle Anon",
				},
				{
					"<leader>jt",
					function()
						vim.ui.input({ prompt = " Graple name " }, function(name)
							if name ~= nil then
								return require("grapple").toggle({ key = name })
							end
						end)
					end,
					desc = "GrapleToggle name",
				},
				{
					"<leader>js",
					function()
						vim.ui.input({ prompt = " Graple select " }, function(name)
							if name ~= nil then
								return require("grapple").select({ key = name })
							end
						end)
					end,
					desc = "Graple select name",
				},
				{
					"<leader>jp",
					function()
						require("grapple").popup_tags()
					end,
					desc = "Graple popup tags",
				},
				{
					"[j",
					function()
						require("grapple").cycle_backward()
					end,
					desc = "Graple tag prev",
				},
				{
					"]j",
					function()
						require("grapple").cycle_forward()
					end,
					desc = "Graple tag next",
				},
				{
					"<leader>jr",
					function()
						vim.ui.input({ prompt = " Graple reset " }, function(name)
							vim.cmd("GrappleReset " .. name)
						end)
					end,
					desc = "Graple reset scope",
				},
			},
		},
	})
end

M.setup = function()
	require("grapple").setup({
		scope = require("grapple.scope").fallback({
			require("grapple").resolvers.lsp_fallback,
			require("grapple").resolvers.git_fallback,
			require("grapple").resolvers.static,
		}),
		popup_options = {
			relative = "editor",
			width = 75,
			height = 15,
			style = "minimal",
			focusable = false,
			border = "rounded",
		},
		integrations = {
			resession = true,
		},
	})
end

return M
