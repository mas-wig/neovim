return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			-- { "folke/neodev.nvim", ft = "lua", opts = { experimental = { pathStrict = true } } },
			{ "williamboman/mason-lspconfig.nvim", lazy = true },
		},
		opts = {
			setup = {},
		},
		config = function(_, opts)
			require("setup.plugins.lspconfig.keymaps")
			require("setup.plugins.lspconfig").setup()
			for name, icon in pairs(require("setup.ui.icons").diagnostics) do
				name = "DiagnosticSign" .. name
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end

			local servers = require("setup.plugins.lspconfig.server")

			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
			local function setup(server)
				local server_opts =
					vim.tbl_deep_extend("force", { capabilities = vim.deepcopy(capabilities) }, servers[server] or {})
				if opts.setup[server] then
					if opts.setup[server](server, server_opts) then
						return
					end
				elseif opts.setup["*"] then
					if opts.setup["*"](server, server_opts) then
						return
					end
				end
				require("lspconfig")[server].setup(server_opts)
			end
			local have_mason, mlsp = pcall(require, "mason-lspconfig")
			local available = have_mason and mlsp.get_available_servers() or {}
			local ensure_installed = {}
			for server, server_opts in pairs(require("setup.plugins.lspconfig.server")) do
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
		end,
	},

	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonInstallAll" },
		lazy = true,
		config = function()
			require("setup.plugins.mason")()
		end,
	},

	{
		"jose-elias-alvarez/null-ls.nvim",
		event = "LspAttach",
		config = function()
			require("setup.plugins.null-ls")()
		end,
	},

	{
		"ray-x/navigator.lua",
		branch = "master",
		event = { "BufReadPre", "BufNewFile" },
		lazy = true,
		init = function()
			if vim.o.ft == "clap_input" and vim.o.ft == "guihua" and vim.o.ft == "guihua_rust" then
				require("cmp").setup.buffer({ completion = { enable = false } })
			end
		end,
		dependencies = {
			"ray-x/guihua.lua",
			branch = "master",
			lazy = true,
			build = "cd lua/fzy && make",
		},
		config = function()
			return require("setup.plugins.navigator")
		end,
	},
}
