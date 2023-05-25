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
						vim.cmd("GrappleToggle")
					end,
					desc = "GrapleToggle Anon",
				},
				{
					"<leader>jt",
					function()
						vim.ui.input({ prompt = " Graple name " }, function(name)
							if name ~= nil then
								vim.cmd("GrappleToggle key=" .. name)
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
								vim.cmd("GrappleSelect key=" .. name)
							end
						end)
					end,
					desc = "Graple select name",
				},
				{
					"<leader>p",
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
		scope = require("grapple.scope").resolver(function()
			return vim.fn.getcwd()
		end, { cache = "DirChanged" }),
		popup_options = {
			relative = "editor",
			width = 90,
			height = 15,
			style = "minimal",
			focusable = false,
			border = "rounded",
		},
		integrations = {
			resession = false,
		},
	})
end

return M
