return {
	"mhartington/formatter.nvim",
	cmd = { "Format", "FormatWrite" },
	config = function()
		local _, formatter = pcall(require, "formatter")
		local _, util = pcall(require, "formatter.util")
		formatter.setup({
			filetype = {
				["lua"] = {
					function()
						return {
							exe = "stylua",
							args = {
								"--indent-type",
								"Tabs",
								"--indent-width",
								"4",
								"--stdin-filepath",
								util.escape_path(util.get_current_buffer_file_path()),
								"--",
								"-",
							},
							stdin = true,
						}
					end,
				},
				["php"] = {
					function()
						return {
							exe = "php-cs-fixer",
							args = {
								"--no-interaction",
								"--quiet",
								"fix",
							},
							stdin = false,
						}
					end,
				},

				["javascript"] = {
					function()
						return {
							exe = "prettier",
							args = {
								"--use-tabs",
								"true",
								"--tab-width",
								"4",
								util.escape_path(util.get_current_buffer_file_path()),
							},
							stdin = true,
						}
					end,
				},

				["json"] = {
					function()
						return {
							exe = "prettier",
							args = {
								"--use-tabs",
								"true",
								"--tab-width",
								"4",
								util.escape_path(util.get_current_buffer_file_path()),
							},
							stdin = true,
						}
					end,
				},

				["html"] = {
					function()
						return {
							exe = "prettier",
							args = {
								"--use-tabs",
								"true",
								"--tab-width",
								"4",
								util.escape_path(util.get_current_buffer_file_path()),
							},
							stdin = true,
						}
					end,
				},

				["css"] = {
					function()
						return {
							exe = "prettier",
							args = {
								"--use-tabs",
								"true",
								"--tab-width",
								"4",
								util.escape_path(util.get_current_buffer_file_path()),
							},
							stdin = true,
						}
					end,
				},

				["javascriptreact"] = {
					function()
						return {
							exe = "prettier",
							args = {
								"--use-tabs",
								"true",
								"--tab-width",
								"4",
								util.escape_path(util.get_current_buffer_file_path()),
							},
							stdin = true,
						}
					end,
				},

				["typescriptreact"] = {
					function()
						return {
							exe = "prettier",
							args = {
								"--use-tabs",
								"true",
								"--tab-width",
								"4",
								util.escape_path(util.get_current_buffer_file_path()),
							},
							stdin = true,
						}
					end,
				},

				["typescript"] = {
					function()
						return {
							exe = "prettier",
							args = {
								"--use-tabs",
								"true",
								"--tab-width",
								"4",
								util.escape_path(util.get_current_buffer_file_path()),
							},
							stdin = true,
						}
					end,
				},

				["rust"] = {
					function()
						return {
							exe = "rustfmt",
							args = { "--emit=stdout" },
							stdin = true,
						}
					end,
				},

				["cpp"] = {
					function()
						return {
							exe = "clang-format",
							args = {},
							stdin = true,
						}
					end,
				},

				["java"] = {
					function()
						return {
							exe = "clang-format",
							args = {},
							stdin = true,
						}
					end,
				},
				["c"] = {
					function()
						return {
							exe = "clang-format",
							args = {},
							stdin = true,
						}
					end,
				},

				["python"] = {
					function()
						return {
							exe = "autopep8",
							args = { "-" },
							stdin = true,
						}
					end,
				},
			},
		})
	end,
}
