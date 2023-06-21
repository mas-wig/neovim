local M = {}

M.keys = {
	{
		"<leader><leader>",
		function()
			vim.cmd("GrappleToggle")
		end,
		desc = "GrapleToggle Anon",
	},
	{
		"<leader>jt",
		function()
			vim.ui.input({ prompt = " Graple name " }, function(name)
				local suffix = ""
				if name ~= nil then
					suffix = name:gsub(" ", "_"):gsub("[^A-Za-z0-9-]", ""):lower()
					vim.cmd("GrappleToggle key=" .. suffix)
				end
			end)
		end,
		desc = "GrapleToggle name",
	},
	{
		"<leader>js",
		function()
			vim.ui.input({ prompt = " Graple select " }, function(name)
				local suffix = ""
				if name ~= nil then
					suffix = name:gsub(" ", "_"):gsub("[^A-Za-z0-9-]", ""):lower()
					vim.cmd("GrappleSelect key=" .. suffix)
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
		"<S-Tab>",
		function()
			require("grapple").cycle_backward()
		end,
		desc = "Graple tag prev",
	},
	{
		"<Tab>",
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
}

M.setup = function()
	require("grapple").setup({
		scope = require("grapple.scope").resolver(function()
			return os.getenv("PWD")
		end, { cache = "DirChanged" }),
		popup_options = {
			relative = "editor",
			width = 90,
			height = 15,
			style = "minimal",
			focusable = true,
			border = "rounded",
		},
		integrations = {
			resession = true,
		},
	})
end

return M
