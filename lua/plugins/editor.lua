return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		cmd = "Neotree",
		deactivate = function()
			vim.cmd([[Neotree close]])
		end,
		init = function()
			vim.g.neo_tree_remove_legacy_commands = 1
			if vim.fn.argc() == 1 then
				local stat = vim.loop.fs_stat(vim.fn.argv(0))
				if stat and stat.type == "directory" then
					require("neo-tree")
				end
			end
		end,
		keys = require("setup.plugins.neotree").keys,
		config = function()
			require("setup.plugins.neotree").setup()
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		lazy = true,
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
			},
			{ "nvim-telescope/telescope-live-grep-args.nvim" },
		},
		keys = require("setup.plugins.telescope").keys,
		config = function()
			require("setup.plugins.telescope").setup()
		end,
	},

	{
		"kevinhwang91/nvim-ufo",
		event = "VeryLazy",
		dependencies = { "kevinhwang91/promise-async" },
		config = function()
			require("setup.plugins.nvim-ufo")
		end,
	},

	{
		"folke/trouble.nvim",
		cmd = { "TroubleToggle", "Trouble" },
		opts = { use_diagnostic_signs = true },
		keys = require("setup.plugins.trouble"),
	},

	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufNewFile" },
		opts = { delay = 200 },
		config = function(_, opts)
			require("illuminate").configure(opts)

			local function map(key, dir, buffer)
				vim.keymap.set("n", key, function()
					require("illuminate")["goto_" .. dir .. "_reference"](false)
				end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
			end

			map("]]", "next")
			map("[[", "prev")

			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					local buffer = vim.api.nvim_get_current_buf()
					map("]]", "next", buffer)
					map("[[", "prev", buffer)
				end,
			})
		end,
		keys = {
			{ "]]", desc = "Next Reference" },
			{ "[[", desc = "Prev Reference" },
		},
	},

	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoTelescope" },
		event = { "BufReadPost", "BufNewFile" },
		keys = require("setup.plugins.others").todoComment().keys,
		config = function()
			require("setup.plugins.others").todoComment().setup()
		end,
	},
	{
		"nvim-pack/nvim-spectre",
		config = true,
		keys = {
			{
				"<leader>rr",
				function()
					require("spectre").open()
				end,
				desc = "Replace in files (Spectre)",
			},
			{
				"<leader>rw",
				function()
					require("spectre").open_visual()
				end,
				desc = "Select Current Word (Spectre)",
				mode = { "v" },
			},
		},
	},

	{
		"jake-stewart/jfind.nvim",
		keys = require("setup.plugins.jfind").keys,
		config = function()
			require("setup.plugins.jfind").setup()
		end,
	},

	{
		"jakewvincent/mkdnflow.nvim",
		ft = { "markdown" },
		cmd = require("setup.plugins.note-taking").cmd_mkdnflow,
		keys = require("setup.plugins.note-taking").mkdn_expl,
		config = function()
			require("setup.plugins.note-taking").mkdnflow_setup()
		end,
	},

	{
		"andrewferrier/wrapping.nvim",
		cmd = { "HardWrapMode", "SoftWrapMode", "ToggleWrapMode" },
		opts = {
			create_commands = true,
			create_keymappings = false,
		},
	},

	{
		"folke/flash.nvim",
		event = "VeryLazy",
		keys = require("setup.plugins.others").flash().keys,
		config = function()
			require("setup.plugins.others").flash().setup()
		end,
	},
}
