return require("neo-tree").setup({
	hide_root_node = false,
	popup_border_style = "single",
	filesystem = {
		follow_current_file = true,
		hijack_netrw_behavior = "open_current",
		use_libuv_file_watcher = true,
		filtered_items = {
			visible = false,
			hide_dotfiles = true,
			hide_gitignored = true,
			hide_hidden = true,
			hide_by_name = {
				".DS_Store",
				"thumbs.db",
				-- "node_modules",
				"tmp",
			},
			hide_by_pattern = {
				"*.meta",
			},
			always_show = {
				".gitignored",
				".env",
			},
			never_show = {
				".DS_Store",
				"thumbs.db",
			},
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
		winbar = false, -- set true jika lu mau set winbar git, buffers dll
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
			with_markers = true,
			indent_marker = "│",
			last_indent_marker = "└",
			expander_collapsed = "",
			expander_expanded = "",
			expander_highlight = "NeoTreeExpander",
			indent_size = 3,
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
})
