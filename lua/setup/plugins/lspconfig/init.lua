local M = {}

M.on_attach = function(on_attach)
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local buffer = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			on_attach(client, buffer)
		end,
	})
end

M.diagnostics = function()
	for type, icon in pairs(require("setup.ui.icons").diagnostics) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end
end

M.setup = function()
	return M.on_attach(function(client, bufnr)
		require("setup.plugins.lspconfig.keymaps").on_attach(client, bufnr)
		if client.name == "gopls" then
			require("legendary").keymaps({
				{
					itemgroup = "Golang",
					description = "Go me daddy...",
					icon = "🚀 ",
					keymaps = {
						{ "<leader>ly", "<cmd>GoModTidy<cr>", desc = "Go Mod Tidy" },
						{ "<leader>lc", "<cmd>GoCoverage<Cr>", desc = "Go Test Coverage" },
						{ "<leader>lt", "<cmd>GoTest<Cr>", desc = "Go Test" },
						{ "<leader>lR", "<cmd>GoRun<Cr>", desc = "Go Run" },
						{ "<leader>dT", "<cmd>lua require('dap-go').debug_test()<cr>", desc = "Go Debug Test" },
					},
				},
			})
		end

		if client.server_capabilities.documentSymbolProvider then
			require("nvim-navic").attach(client, bufnr)
		end

		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({
				group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
				buffer = bufnr,
			})
			return vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
				buffer = bufnr,
				callback = function()
					local buf = vim.api.nvim_get_current_buf()
					local ft = vim.bo[buf].filetype
					local have_nls = package.loaded["null-ls"]
						and (#require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") > 0)

					vim.lsp.buf.format({
						bufnr = buf,
						filter = function(client)
							if have_nls then
								return client.name == "null-ls"
							end
							return client.name ~= "null-ls"
						end,
					})
				end,
			})
		else
			return vim.cmd([[
                augroup FormatAutogroup
                autocmd!
                autocmd BufWritePost * FormatWrite
                augroup END
            ]])
		end
	end)
end
return M
