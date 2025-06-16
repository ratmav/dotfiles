-- Plugin definitions
local paq = require "paq"
paq {
  -- plugin manager
  "savq/paq-nvim";

  -- dependencies
  "nvim-lua/plenary.nvim";
  "nvim-tree/nvim-web-devicons";

  -- workflow
  {"nvim-telescope/telescope.nvim", tag = "0.1.8"};
  "ratmav/epoch";
  "ratmav/marv";
  "ratmav/nerdtree";
  "ratmav/trap";
  "ratmav/vim-bufkill";
  "ratmav/vim-maximizer";
  "ratmav/vim-fugitive";
  "ratmav/winresizer.vim";
  "ratmav/wisp";
  "sindrets/diffview.nvim";

  -- display
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"};
  "ratmav/vim-gitgutter";
  "ratmav/gruvbox";
  "ratmav/rainbow_parentheses.vim";
  "ratmav/vim-airline";
}
