return function()
	local map = require("setup.utils").map
	map("n", "<leader>rt", "<Plug>RestNvim<cr>", { desc = "Run HTTP test" })
	map("n", "<leader>rv", "<Plug>RestNvimPreview<cr>", { desc = "Run HTTP test preview" })
	map("n", "<leader>rl", "<Plug>RestNvimLast<cr>", { desc = "Run HTTP last test" })

	require("rest-nvim").setup({
		result_split_in_place = false,
		encode_url = true,
		highlight = {
			enabled = true,
			timeout = 300,
		},
		result = {
			show_url = true,
			show_curl_command = false,
			show_http_info = true,
			show_headers = true,
			formatters = {
				json = "jq",
				html = function(body)
					return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
				end,
			},
		},
	})
end
