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

M.setup = function()
	return M.on_attach(function(client, bufnr)
		-- require("navigator.dochighlight").documentHighlight(bufnr)
		-- require("navigator.codeAction").code_action_prompt(bufnr)

		if client.name == "gopls" then
			client.server_capabilities.document_formatting = false
			client.server_capabilities.documentFormattingProvider = false
		end

		if client.server_capabilities.documentSymbolProvider then
			require("nvim-navic").attach(client, bufnr)
		end

		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({
				group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
				buffer = bufnr,
			})
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						filter = function(client)
							return client.name == "null-ls"
						end,
						bufnr = bufnr,
						id = client.id,
						timeout_ms = 5000,
						async = true,
					})
				end,
			})
		end

		require("legendary").autocmds({
			{
				name = "LspOnAttachAutocmds",
				clear = false,
				{
					{ "CursorHold", "CursorHoldI" },
					":silent! lua vim.lsp.buf.document_highlight()",
					opts = { buffer = bufnr },
				},
				{
					"CursorMoved",
					":silent! lua vim.lsp.buf.clear_references()",
					opts = { buffer = bufnr },
				},
			},
		})
	end)
end
return M
