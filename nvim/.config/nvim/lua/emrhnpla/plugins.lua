local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

return packer.startup(function(use)
	use("wbthomason/packer.nvim") -- Have packer manage itself

	-- Colorschemes
	use("arcticicestudio/nord-vim") -- Nord colorscheme

	-- Transparency
	use("xiyaowong/nvim-transparent")

	-- Cursor flashing
	use("rainbowhxch/beacon.nvim")

	-- Completion & Snippets
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-calc",
			"hrsh7th/cmp-emoji",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"David-Kunz/cmp-npm",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
		},
	})

	-- Lsp
	use({
		"neovim/nvim-lspconfig",
		"williamboman/nvim-lsp-installer",
		{
			"jose-elias-alvarez/null-ls.nvim",
			requires = {
				"nvim-lua/plenary.nvim",
			},
		},
	})

	-- Dap
	use({
		"mfussenegger/nvim-dap",
		"rcarriga/nvim-dap-ui",
	})

	-- Telescope
	use({
		{
			{
				"nvim-telescope/telescope.nvim",
				requires = {
					"nvim-lua/plenary.nvim",
				},
			},
			"nvim-telescope/telescope-ui-select.nvim",
		},
		{
			"nvim-telescope/telescope-media-files.nvim",
			requires = {
				"nvim-lua/popup.nvim",
			},
		},
	})

	-- Treesitter
	use({
		{
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
		},
		"p00f/nvim-ts-rainbow",
		"windwp/nvim-ts-autotag",
	})

	-- ReactJS
	use("napmn/react-extract.nvim")

	-- Autopairs
	use("windwp/nvim-autopairs")

	-- Comment
	use({
		"numToStr/Comment.nvim",
		"JoosepAlviste/nvim-ts-context-commentstring",
	})

	-- Git
	use({
		"lewis6991/gitsigns.nvim",
		"github/copilot.vim",
	})

	-- Nvimtree
	use({
		"kyazdani42/nvim-tree.lua",
		"kyazdani42/nvim-web-devicons",
	})

	-- Bufferline
	use({
		{
			"akinsho/bufferline.nvim",
			tag = "*",
			requires = "kyazdani42/nvim-web-devicons",
		},
		"famiu/bufdelete.nvim",
	})

	-- Lualine
	use({
		"nvim-lualine/lualine.nvim",
		requires = "kyazdani42/nvim-web-devicons",
	})

	-- Indentline
	use("lukas-reineke/indent-blankline.nvim")

	-- Symbols-Outline
	use("simrat39/symbols-outline.nvim")

	-- Toggleterm
	use("akinsho/toggleterm.nvim")

	--  Project
	use("ahmedkhalf/project.nvim")

	-- Impantient
	use("lewis6991/impatient.nvim")

	-- Alpha
	use({
		"goolord/alpha-nvim",
		requires = "kyazdani42/nvim-web-devicons",
	})

	-- Whichkey
	use("folke/which-key.nvim")

	-- Markdown
	use("ellisonleao/glow.nvim")

	-- Hop
	use({ "phaazon/hop.nvim", branch = "v1" })

	-- Neoscroll
	use("karb94/neoscroll.nvim")

	-- Hlslens
	use({ "kevinhwang91/nvim-hlslens" })

	-- Iswap
	use("mizlan/iswap.nvim")

	-- Numb
	use("nacro90/numb.nvim")

	-- Regexplainer
	use({
		"bennypowers/nvim-regexplainer",
		requires = {
			"nvim-treesitter/nvim-treesitter",
			"MunifTanjim/nui.nvim",
		},
	})

	-- Tmux
	use("aserowy/tmux.nvim")

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
