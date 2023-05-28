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
		require("navigator.codeAction").code_action_prompt(bufnr)
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
	end)
end
return M
