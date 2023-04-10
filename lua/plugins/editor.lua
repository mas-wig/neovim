return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		lazy = true,
		dependencies = {
			{ "nvim-telescope/telescope-fzf-native.nvim", lazy = true, build = "make" },
			{ "nvim-telescope/telescope-file-browser.nvim", lazy = true },
		},
		opts = function()
			local actions = require("telescope.actions")
			local actions_layout = require("telescope.actions.layout")

			return {
				defaults = {
					winblend = 0,
					borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					color_devicons = true,
					set_env = { ["COLORTERM"] = "truecolor" },
					layout_config = {
						horizontal = {
							prompt_position = "top",
							preview_width = 0.55,
							results_width = 0.8,
						},
						vertical = {
							mirror = false,
						},
						width = 0.87,
						height = 0.80,
						preview_cutoff = 120,
					},
					prompt_prefix = " 🔎 ",
					path_display = { "smart" },
					dynamic_preview_title = true,
					selection_caret = "🟣 ",
					entry_prefix = " ",
					initial_mode = "insert",
					selection_strategy = "reset",
					sorting_strategy = "ascending",
					file_ignore_patterns = {
						"^.git/*",
					},
					file_previewer = require("telescope.previewers").vim_buffer_cat.new,
					grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
					qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
					buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
					file_sorter = require("telescope.sorters").get_fuzzy_file,
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--hidden",
						"--column",
						"--smart-case",
						"--trim",
					},
					mappings = {
						n = { ["q"] = require("telescope.actions").close },
					},
				},
				pickers = {
					find_files = {
						find_command = {
							"fd",
							"--type",
							"f",
							"--strip-cwd-prefix",
							"--color=never",
							"--hidden",
						},
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
					file_browser = {
						multi_icon = " 👉 ",
						layout_config = {
							horizontal = {
								prompt_position = "top",
								results_width = 0.8,
							},
							vertical = {
								mirror = false,
							},
							width = 0.90,
							height = 0.84,
						},
						-- theme             = "ivy",
						hide_parent_dir = true,
						hijack_netrw = true,
						previewer = false,
						prompt_path = true,
						hidden = true,
						respect_gitignore = false,
						grouped = true,
						border = true,
						mappings = {
							i = {
								["<C-j>"] = actions.move_selection_next,
								["<C-k>"] = actions.move_selection_previous,
								["<C-n>"] = actions.cycle_history_next,
								["<C-p>"] = actions.cycle_history_prev,
								["?"] = actions_layout.toggle_preview,
							},
						},
					},
				},
			}
		end,
		config = function(_, opts)
			require("telescope").setup(opts)
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("file_browser")
		end,
		init = function()
			local t = require("legendary.toolbox")
			require("legendary").keymaps({
				{
					itemgroup = "Telescope",
					description = "Fuck me Daddy",
					icon = "🔭",
					keymaps = {
						{ "<leader>fb", "<cmd>Telescope file_browser<cr>", description = "File browser" },
						{
							"<leader>bs",
							"<cmd>Telescope current_buffer_fuzzy_find<cr>",
							desc = "Buffer Search",
						},
						{
							"<leader>ff",
							t.lazy_required_fn("telescope.builtin", "find_files", { hidden = true }),
							description = "Find files",
						},
						{
							"<C-g>",
							t.lazy_required_fn(
								"telescope.builtin",
								"live_grep",
								{ prompt_title = "Open Files", path_display = { "shorten" }, grep_open_files = true }
							),
							description = "Find in open files",
						},
						{
							"<Leader>gb",
							t.lazy_required_fn(
								"telescope.builtin",
								"live_grep",
								{ prompt_title = "Search CWD", path_display = { "smart" } }
							),
							description = "Search CWD",
						},
						{
							"<leader>bl",
							t.lazy_required_fn(
								"telescope.builtin",
								"buffers",
								{ prompt_title = "Buffer List", path_display = { "smart" } }
							),
							description = "List buffers",
						},
					},
				},
			})
		end,
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		cmd = "Neotree",
		keys = {
			{
				"<leader>e",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = require("setup.utils").get_root() })
				end,
				desc = "Explorer NeoTree (root dir)",
			},
			{
				"<leader>E",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
				end,
				desc = "Explorer NeoTree (cwd)",
			},
		},
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
		opts = {
			hide_root_node = true,
			filesystem = {
				bind_to_cwd = false,
				follow_current_file = true,
				hijack_netrw_behavior = "open_current",
				use_libuv_file_watcher = true,
			},
			event_handlers = {
				{
					event = "neo_tree_buffer_enter",
					handler = function(_)
						vim.opt_local.signcolumn = "auto"
					end,
				},
			},
			window = {
				mappings = {
					["<space>"] = "none",
				},
			},
			source_selector = {
				winbar = true,
				content_layout = "center",
				tab_labels = {
					filesystem = " " .. " Files",
					buffers = " " .. " Buffers",
					git_status = " " .. " Git",
					diagnostics = "裂 " .. " Diagnostics",
				},
			},
			default_component_configs = {
				indent = {
					with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
				icon = {
					folder_closed = require("ui.icons").ui.Folder,
					folder_open = require("ui.icons").ui.FolderOpen,
					folder_empty = require("ui.icons").ui.EmptyFolder,
					folder_empty_open = require("ui.icons").ui.EmptyFolderOpen,
					git_status = {
						symbols = require("ui.icons").git,
					},
				},
			},
			filtered_items = {
				hide_by_name = {
					".DS_Store",
					"thumbs.db",
					"node_modules",
				},
				hide_by_pattern = {
					"*.meta",
				},
				always_show = {
					".gitignored",
				},
				never_show = {
					".DS_Store",
					"thumbs.db",
				},
			},
		},
		config = function(_, opts)
			require("neo-tree").setup(opts)
		end,
	},
}