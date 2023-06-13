local M = {}

M.keys = function()
	local function diagnostic_goto(next, severity)
		local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
		severity = severity and vim.diagnostic.severity[severity] or nil
		return function()
			go({ severity = severity })
		end
	end

	return {
		{ "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
		{ "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Goto Definition", has = "definition" },
		{
			"gr",
			function()
				require("telescope.builtin").lsp_references(require("telescope.themes").get_ivy({
					prompt_title = "",
					layout_config = {
						preview_width = 0.5,
						height = 0.6,
						prompt_position = "bottom",
					},
				}))
			end,
			desc = "References",
			has = "references",
		},
		{ "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
		{ "gI", "<cmd>Telescope lsp_implementations<cr>", desc = "Goto Implementation" },
		{ "gy", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto T[y]pe Definition" },
		{ "K", vim.lsp.buf.hover, desc = "Hover" },
		{ "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
		{ "]d", diagnostic_goto(true), desc = "Next Diagnostic" },
		{ "[d", diagnostic_goto(false), desc = "Prev Diagnostic" },
		{ "]e", diagnostic_goto(true, "ERROR"), desc = "Next Error" },
		{ "[e", diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
		{ "]w", diagnostic_goto(true, "WARN"), desc = "Next Warning" },
		{ "[w", diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
		{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
		{
			"<leader>cA",
			function()
				vim.lsp.buf.code_action({
					context = {
						only = {
							"source",
						},
						diagnostics = {},
					},
				})
			end,
			desc = "Source Action",
			has = "codeAction",
		},
	}
end

M.mappings = function(client, bufnr)
	local Keys = require("lazy.core.handler.keys")
	local keymaps = {}

	for _, value in ipairs(M.keys()) do
		local keys = Keys.parse(value)
		if keys[2] == vim.NIL or keys[2] == false then
			keymaps[keys.id] = nil
		else
			keymaps[keys.id] = keys
		end
	end

	for _, keys in pairs(keymaps) do
		if not keys.has or client.server_capabilities[keys.has .. "Provider"] then
			local opts = Keys.opts(keys)
			opts.has = nil
			opts.silent = opts.silent ~= false
			opts.buffer = buffer
			vim.keymap.set(keys.mode or "n", keys[1], keys[2], opts)
		end
	end
end

M.ui = function()
	for type, icon in pairs(require("setup.ui.icons").diagnostics) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end

	-- :h vim.lsp.util.open_floating_preview
	local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
	function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
		opts = opts or {}
		opts.border = opts.border or "rounded"
		opts.max_width = opts.max_width or 90
		opts.wrap = true
		return orig_util_open_floating_preview(contents, syntax, opts, ...)
	end
end

M.buffer_attach = function()
	local function set_attach(on_attach)
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local buffer = args.buf
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				on_attach(client, buffer)
			end,
		})
	end

	return set_attach(function(client, bufnr)
		local lsp_exclude = { "html", "css", "jsonls" }
		local opts = { bold = true, reverse = true }
		local lsp_doc_hl = vim.api.nvim_create_augroup("lsp_document_highlight", {})
		for _, lsp_name in pairs(lsp_exclude) do
			if client.name ~= lsp_name then
				if client.server_capabilities.hoverProvider then -- in 8.0 - server_capabilities
					vim.api.nvim_set_hl(0, "LspReferenceRead", opts)
					vim.api.nvim_set_hl(0, "LspReferenceText", opts)
					vim.api.nvim_set_hl(0, "LspReferenceWrite", opts)
					vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", opts)
					vim.api.nvim_create_autocmd("CursorHold", {
						-- pattern = "*",
						buffer = bufnr,
						callback = vim.lsp.buf.document_highlight,
						group = lsp_doc_hl,
					})
					vim.api.nvim_create_autocmd("CursorMoved", {
						-- pattern = "*",
						buffer = bufnr,
						callback = vim.lsp.buf.clear_references,
						group = lsp_doc_hl,
					})
				end
			end
			if client.server_capabilities.documentSymbolProvider then
				require("nvim-navic").attach(client, bufnr)
			end
		end
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
		M.mappings(client, bufnr)
	end)
end

M.server = function()
	return {
		lua_ls = {
			filetypes = { "lua" },
			Lua = {
				workspace = { checkThirdParty = false },
				telemetry = { enable = false },
				completion = { callSnippet = "Replace" },
			},
		},
		tsserver = {
			init_options = { hostInfo = "neovim" },
			root_dir = function()
				return os.getenv("PWD")
			end,
			single_file_support = true,
		},
	}
end

M.setup = function()
	M.buffer_attach()
	M.ui()
	local servers = M.server()
	local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
	local function setup(server)
		local server_opts =
			vim.tbl_deep_extend("force", { capabilities = vim.deepcopy(capabilities) }, servers[server] or {})
		require("lspconfig")[server].setup(server_opts)
	end
	local have_mason, mlsp = pcall(require, "mason-lspconfig")
	local available = have_mason and mlsp.get_available_servers() or {}
	local ensure_installed = {}
	for server, server_opts in pairs(servers) do
		if server_opts then
			server_opts = server_opts == true and {} or server_opts
			if server_opts.mason == false or not vim.tbl_contains(available, server) then
				setup(server)
			else
				ensure_installed[#ensure_installed + 1] = server
			end
		end
	end
	if have_mason then
		mlsp.setup({ ensure_installed = ensure_installed, automatic_installation = true })
		mlsp.setup_handlers({ setup })
	end
end

return M
