-- Auto-close and auto-rename HTML/XML tags in Razor/Blazor files
return {
  'windwp/nvim-ts-autotag',
  event = 'InsertEnter',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  opts = {
    -- Defaults
    enable_close = true, -- Auto close tags
    enable_rename = true, -- Auto rename pairs of tags
    enable_close_on_slash = false, -- Auto close on trailing </
  },
  config = function(_, opts)
    require('nvim-ts-autotag').setup(opts)
  end,
}
