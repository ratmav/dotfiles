-- Plugin definitions
local paq = require "paq"
paq {
  -- plugin manager
  "savq/paq-nvim";

  -- workflow
  -- telescope and dependencies
  "nvim-lua/plenary.nvim";
  {"nvim-telescope/telescope.nvim", tag = "0.1.8"};
  "ratmav/marv";
  "ratmav/nerdtree"; -- TODO: replace with neotree.
  "ratmav/wisp";
  "ratmav/vim-bufkill"; -- TODO: lua?
  "ratmav/vim-maximizer"; -- TODO: lua?
  "ratmav/winresizer.vim"; -- TODO: lua?
  "ratmav/vim-fugitive"; -- TODO: lua?
  "sindrets/diffview.nvim"; -- TODO: lua?

  -- display
  "nvim-tree/nvim-web-devicons";
  "ratmav/vim-gitgutter"; -- TODO: lua?
  "ratmav/gruvbox"; -- TODO: lua?
  "ratmav/rainbow_parentheses.vim"; -- TODO: lua?
  "ratmav/vim-airline"; -- TODO: lua?

  -- treesitter
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"};
}