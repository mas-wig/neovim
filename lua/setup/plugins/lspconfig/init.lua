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
		local lsp_exclude = { "html", "css", "jsonls" }
		for _, lsp_name in pairs(lsp_exclude) do
			if client.name ~= lsp_name then
				require("navigator.codeAction").code_action_prompt(bufnr)
				require("setup.plugins.lspconfig.keymaps").on_attach(client, bufnr)
			end
			if client.server_capabilities.documentSymbolProvider then
				require("nvim-navic").attach(client, bufnr)
			end
		end
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end)
end
return M
