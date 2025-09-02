return {
  {
    'Shatur/neovim-ayu',
    opts = {
      overrides = {
        Normal = { bg = 'None' },
        NormalFloat = { bg = 'none' },
        ColorColumn = { bg = 'None' },
        SignColumn = { bg = 'None' },
        Folded = { bg = 'None' },
        FoldColumn = { bg = 'None' },
        CursorLine = { bg = 'None' },
        CursorColumn = { bg = 'None' },
        VertSplit = { bg = 'None' },
      },
    },
    config = function(_, opts) require('ayu').setup(opts) end,
  },
  {
    'LazyVim/LazyVim',
    opts = {
      colorscheme = 'ayu-dark',
    },
  },
}
