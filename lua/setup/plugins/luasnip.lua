return function()
	require("luasnip").config.set_config({
		history = true,
		delete_check_events = "TextChanged",
		region_check_events = "CursorMoved",
		ext_opts = {
			[require("luasnip.util.types").choiceNode] = {
				active = { hl_group = "DiagnosticHint", virt_text = { { "󰊖 ", "DiagnosticHint" } } },
			},
		},
	})
	require("luasnip.loaders.from_vscode").lazy_load({
		paths = { "./after/snippets/" },
	})
	vim.api.nvim_create_autocmd("InsertLeave", {
		callback = function()
			if
				require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
				and not require("luasnip").session.jump_active
			then
				require("luasnip").unlink_current()
			end
		end,
	})
end
