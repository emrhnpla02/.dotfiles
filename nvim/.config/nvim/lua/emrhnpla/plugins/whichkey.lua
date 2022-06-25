local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	return
end

local setup = {
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20, -- how many suggestions should be shown in the list?
		},
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = false, -- adds help for motions
			text_objects = false, -- help for text objects triggered after entering an operator
			windows = false, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
	-- add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset / operators plugin above
	-- operators = { gc = "Comments" },
	key_labels = {
		-- override the label used to display some keys. It doesn't effect WK in any other way.
		-- For example:
		-- ["<space>"] = "SPC",
		-- ["<CR>"] = "RET",
		-- ["<tab>"] = "TAB",
	},
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
	popup_mappings = {
		scroll_down = "<c-d>", -- binding to scroll down inside the popup
		scroll_up = "<c-u>", -- binding to scroll up inside the popup
	},
	window = {
		border = "rounded", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0,
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "center", -- align columns left, center or right
	},
	ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
	show_help = true, -- show help message on the command line when the popup is visible
	triggers = "auto", -- automatically setup triggers
	-- triggers = {"<leader>"} -- or specify a list manually
	triggers_blacklist = {
		-- list of mode / prefixes that should never be hooked by WhichKey
		-- this is mostly relevant for key maps that start with a native binding
		-- most people should not need to change this
		i = { "j", "k" },
		v = { "j", "k" },
	},
}

local opts = {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
	["q"] = { "<cmd>q!<CR>", "Quit" },
	["a"] = { "<cmd>Lspsaga code_action<CR>", "Code Action" },
	["h"] = { "<cmd>Lspsaga lsp_finder<CR>", "Lsp Finder" },
	["c"] = { "<cmd>lua require('Comment.api').toggle_current_linewise()<CR>", "Comment" },
	["T"] = { "<cmd>lua require('jester').run_file()<CR>", "Run current file" },
	["r"] = {
		"<cmd>:Lspsaga rename<CR>",
		"Rename",
	},
	["R"] = {
		"<cmd>lua require('regexplainer').show{display = 'popup', popup={border = {padding = { 1, 2 }, style = 'solid'}}}<CR>",
		"Regex Explainer",
	},
	["e"] = { "<cmd>NvimTreeToggle<CR>", "Explorer" },
	["o"] = { "<cmd>SymbolsOutline<CR>", "Symbols" },
	["b"] = {
		"<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<CR>",
		"Buffers",
	},
	["f"] = {
		"<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false, hidden=true})<CR>",
		"Find files",
	},
	["m"] = { "<cmd>Telescope media_files<CR>", "Find Media Files" },
	["F"] = { "<cmd>Telescope live_grep<CR>", "Find Text" },
	["P"] = { "<cmd>Telescope projects<CR>", "Projects" },
	w = {
		s = { "<cmd>split<CR>", "Split Window" },
		v = { "<cmd>vsplit<CR>", "Split Window Vertically" },
	},
	p = {
		name = "Packer",
		c = { "<cmd>PackerCompile<CR>", "Compile" },
		i = { "<cmd>PackerInstall<CR>", "Install" },
		s = { "<cmd>PackerSync<CR>", "Sync" },
		S = { "<cmd>PackerStatus<CR>", "Status" },
		u = { "<cmd>PackerUpdate<CR>", "Update" },
	},
	g = {
		name = "Git",
		g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
		j = { "<cmd>lua require 'gitsigns'.next_hunk()<CR>", "Next Hunk" },
		k = { "<cmd>lua require 'gitsigns'.prev_hunk()<CR>", "Prev Hunk" },
		l = { "<cmd>lua require 'gitsigns'.blame_line()<CR>", "Blame" },
		p = { "<cmd>lua require 'gitsigns'.preview_hunk()<CR>", "Preview Hunk" },
		r = { "<cmd>lua require 'gitsigns'.reset_hunk()<CR>", "Reset Hunk" },
		R = { "<cmd>lua require 'gitsigns'.reset_buffer()<CR>", "Reset Buffer" },
		s = { "<cmd>lua require 'gitsigns'.stage_hunk()<CR>", "Stage Hunk" },
		u = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<CR>", "Undo Stage Hunk" },
		o = { "<cmd>Telescope git_status<CR>", "Open changed file" },
		b = { "<cmd>Telescope git_branches<CR>", "Checkout branch" },
		c = { "<cmd>Telescope git_commits<CR>", "Checkout commit" },
		d = { "<cmd>Gitsigns diffthis HEAD<CR>", "Diff" },
	},
	l = {
		name = "LSP",
		h = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover" },
		r = { "<cmd>Telescope lsp_references<CR>", "References" },
		a = { "<cmd>Lspsaga code_action<CR>", "Code Actions" },
		i = { "<cmd>Telescope lsp_implementations<CR>", "Implementations" },
		t = { "<cmd>Telescope lsp_type_definitions<CR>", "Type Definitions" },
		f = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "Format" },
		l = { "<cmd>lua vim.diagnostic.open_float({ border = 'rounded' })", "Float Diagnostic" },
		d = { "<cmd>Telescope lsp_definitions<CR>", "Definitions" },
		D = { "<cmd>Telescope diagnostics<CR>", "Diagnostics" },
		s = { "<cmd>Telescope lsp_document_symbols<CR>", "Document Symbols" },
		S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", "Workspace Symbols" },
		w = { "<cmd>Telescope lsp_workspace_diagnostics<CR>", "Workspace Diagnostics" },
	},
	d = {
		name = "DAP",
		b = { "<cmd>lua require('dap').toggle_breakpoint()<CR>", "Toggle breakpoint" },
		c = { "<cmd>lua require('dap').continue()<CR>", "Continue" },
		k = { "<cmd>lua require('dap').step_out()<CR>", "Step out" },
		l = { "<cmd>lua require('dap').step_into()<CR>", "Step into" },
		j = { "<cmd>lua require('dap').step_over()<CR>", "Step over" },
		_ = { "<cmd>lua require('dap').run_last()<CR>", "Run last" },
		u = { "<cmd>lua require('dapui').toggle()<CR>", "DAP UI" },
		s = { "<cmd>lua require('dapui').float_element('scopes')<CR>", "Scopes" },
		S = { "<cmd>lua require('dapui').float_element('stacks')<CR>", "Stacks" },
		w = { "<cmd>lua require('dapui').float_element('watches')<CR>", "Watches" },
		B = { "<cmd>lua require('dapui').float_element('breakpoints')<CR>", "Breakpoints" },
		r = { "<cmd>lua require('dapui').float_element('repl')<CR>", "Repl" },
		i = {
			"<cmd>lua require('dap.ui.variables').hover(function () return vim.fn.expand('<cexpr>') end)<CR>",
			"Hover",
		},
		I = { "<cmd>lua require('dap').repl.open({}, 'vsplit')<CR>", "Inspect" },
		e = { "<cmd>lua require('dap').set_exception_breakpoints({'all'})<CR>", "Set exception breakpoints" },
	},
	j = {
		t = { "<cmd>lua require('jester').run()<CR>", "Run nearest test(s) under the cursor" },
		f = { "<cmd>lua require('jester').run_file()<CR>", "Run current file" },
		l = { "<cmd>lua require('jester').run_last()<CR>", "Run last test(s)" },
		d = { "<cmd>lua require('jester').debug()<CR>", "Debug nearest test(s) under the cursor" },
		c = { "<cmd>lua require('jester').debug_file()<CR>", "Debug current file" },
		g = { "<cmd>lua require('jester').debug_last()<CR>", "Debug last test(s)" },
	},
	s = {
		name = "Search",
		b = { "<cmd>Telescope git_branches<CR>", "Checkout branch" },
		c = { "<cmd>Telescope colorscheme<CR>", "Colorscheme" },
		h = { "<cmd>Telescope help_tags<CR>", "Find Help" },
		p = { "<cmd>Telescope projects<CR>", "Projects" },
		M = { "<cmd>Telescope man_pages<CR>", "Man Pages" },
		r = { "<cmd>Telescope oldfiles<CR>", "Open Recent File" },
		R = { "<cmd>Telescope registers<CR>", "Registers" },
		k = { "<cmd>Telescope keymaps<CR>", "Keymaps" },
		C = { "<cmd>Telescope commands<CR>", "Commands" },
	},
	t = {
		name = "Terminal",
		n = { "<cmd>lua _NODE_TOGGLE()<CR>", "Node" },
		u = { "<cmd>lua _NCDU_TOGGLE()<CR>", "NCDU" },
		t = { "<cmd>lua _HTOP_TOGGLE()<CR>", "Htop" },
		p = { "<cmd>lua _PYTHON_TOGGLE()<CR>", "Python" },
		g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
		f = { "<cmd>lua _TMUX_TOGGLE()<CR>", "Float" },
		h = { "<cmd>ToggleTerm size=10 direction=horizontal<CR>", "Horizontal" },
		v = { "<cmd>ToggleTerm size=80 direction=vertical<CR>", "Vertical" },
	},
}

local vopts = {
	mode = "v", -- VISUAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}
local vmappings = {
	["/"] = { '<ESC><CMD>lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>', "Comment" },
	["r"] = { "<cmd>lua require('react-extract').extract_to_new_file()<CR>", "Extract React Component" },
	d = {
		name = "DAP",
		i = {
			"<cmd>lua require('dap.ui.variables').visual_hover()<CR>",
			"Visual Hover",
		},
	},
}

which_key.setup(setup)
which_key.register(mappings, opts)
which_key.register(vmappings, vopts)
