local M = {}

M.treesitter = function()
	local plugin = require("lazy.core.config").spec.plugins["nvim-treesitter"]
	local opts = require("lazy.core.plugin").values(plugin, "opts", false)
	local enabled = false
	if opts.textobjects then
		for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
			if opts.textobjects[mod] and opts.textobjects[mod].enable then
				enabled = true
				break
			end
		end
	end
	if not enabled then
		require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
	end
end

M.miniai = function()
	local ai = require("mini.ai")
	ai.setup({
		n_lines = 500,
		custom_textobjects = {
			o = ai.gen_spec.treesitter({
				a = { "@block.outer", "@conditional.outer", "@loop.outer" },
				i = { "@block.inner", "@conditional.inner", "@loop.inner" },
			}, {}),
			f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
			c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
			m = ai.gen_spec.treesitter({ a = "@method.outer", i = "@method.inner" }),
			p = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
			h = ai.gen_spec.treesitter({ a = "@attribute.outer", i = "@attribute.inner" }),
			s = ai.gen_spec.treesitter({ a = "@scopename.outer", i = "@scopename.inner" }),
		},
	})

	if require("setup.utils").has("which-key.nvim") then
		local i = {
			[" "] = "Whitespace",
			['"'] = 'Balanced "',
			["'"] = "Balanced '",
			["`"] = "Balanced `",
			["("] = "Balanced (",
			[")"] = "Balanced ) including white-space",
			[">"] = "Balanced > including white-space",
			["<lt>"] = "Balanced <",
			["]"] = "Balanced ] including white-space",
			["["] = "Balanced [",
			["}"] = "Balanced } including white-space",
			["{"] = "Balanced {",
			["?"] = "User Prompt",
			_ = "Underscore",
			a = "Argument",
			b = "Balanced ), ], }",
			c = "Class",
			m = "Method",
			p = "Parameter",
			f = "Function",
			o = "Block, conditional, loop",
			q = "Quote `, \", '",
			t = "Tag",
			h = "Atribute",
			s = "Scope Name",
		}
		local a = vim.deepcopy(i)
		for k, v in pairs(a) do
			a[k] = v:gsub(" including.*", "")
		end

		local ic = vim.deepcopy(i)
		local ac = vim.deepcopy(a)
		for key, name in pairs({ n = "Next", l = "Last" }) do
			i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
			a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
		end
		require("which-key").register({
			mode = { "o", "x" },
			i = i,
			a = a,
		})
	end
end

M.various_textobj = function() end

return M
