vim.loader.enable()
require("setup.options")
require("setup.lazy")

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("setup.autocmds")
		require("setup.mappings")
	end,
})
