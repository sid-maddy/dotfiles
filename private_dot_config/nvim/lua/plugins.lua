local fn = vim.fn
local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
end

return require("packer").startup(function(use)
  -- Packer can manage itself
  use "wbthomason/packer.nvim"

  -- Chezmoi
  use "alker0/chezmoi.vim"

  -- Treesitter
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
  require("nvim-treesitter.configs").setup({
    highlight = {
      enable = true
    },
    indent = {
      enable = true
    },
    rainbow = {
      enable = true
    },
  })

  -- tpope
  use "tpope/vim-commentary"
  use "tpope/vim-fugitive"
  use "tpope/vim-repeat"
  use "tpope/vim-surround"

  -- Rainbow parens!
  use "p00f/nvim-ts-rainbow"

  -- Startpage
  use "mhinz/vim-startify"

  -- Colorscheme
  use "Luxed/ayu-vim"

  -- Statusline
  use {
    "nvim-lualine/lualine.nvim",
    requires = {"kyazdani42/nvim-web-devicons", opt = true}
  }

  -- Completer, formatter, and linter
  use { "neoclide/coc.nvim", branch = "release" }

  -- File picker
  use {
    "nvim-telescope/telescope.nvim",
    requires = { "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons" }
  }

  -- Play nice with other editors
  use "editorconfig/editorconfig-vim"

  -- Automatically set up configuration after cloning packer.nvim
  if packer_bootstrap then
    require("packer").sync()
  end
end)
