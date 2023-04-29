local M = {}

M.init = function()
	require("legendary").keymaps({
		{
			"<C-n>",
			function()
				require("neo-tree.command").execute({ toggle = true })
			end,
			description = "Explorer NeoTree (root dir)",
		},
		{
			"<leader>E",
			function()
				require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
			end,
			description = "Explorer NeoTree (cwd)",
		},
	})
end
M.setup = function()
	require("neo-tree").setup({
		hide_root_node = true,
		filesystem = {
			follow_current_file = true,
			hijack_netrw_behavior = "open_current",
			use_libuv_file_watcher = true,
			filtered_items = {
				visible = false,
				hide_dotfiles = true,
				hide_gitignored = true,
				hide_hidden = true,
			},
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
			sources = {
				{
					source = "filesystem",
					display_name = "  Files ",
				},
				{
					source = "buffers",
					display_name = "  Buffers",
				},
				{
					source = "git_status",
					display_name = "  Git ",
				},
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
				folder_closed = require("setup.ui.icons").ui.Folder,
				folder_open = require("setup.ui.icons").ui.FolderOpen,
				folder_empty = require("setup.ui.icons").ui.EmptyFolder,
				folder_empty_open = require("setup.ui.icons").ui.EmptyFolderOpen,
			},
			git_status = {
				symbols = require("setup.ui.icons").git,
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
	})
end

return M
