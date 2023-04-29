return require("navigator").setup({
	border = "single",
	ts_fold = false,
	default_mapping = false,
	transparency = 100,
	lsp_signature_help = false,
	lsp = {
		disable_lsp = "all",
		format_on_save = false,
		diagnostic = {
			underline = true,
			update_in_insert = false,
			virtual_text = {
				spacing = 10,
				underline = true,
				update_in_insert = false,
				prefix = "  ",
			},
			severity_sort = true,
		},
		diagnostic_virtual_text = true,
		diagnostic_scrollbar_sign = false,
		diagnostic_update_in_insert = true,
		disply_diagnostic_qf = true,
	},
	icons = {
		diagnostic_err = require("setup.ui.icons").diagnostics.Error,
		diagnostic_warn = require("setup.ui.icons").diagnostics.Warn,
		diagnostic_info = require("setup.ui.icons").diagnostics.Info,
		diagnostic_hint = require("setup.ui.icons").diagnostics.Hint,
	},
})
