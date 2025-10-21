-- Better UI for LSP code actions and selections using Telescope
return {
  'nvim-telescope/telescope-ui-select.nvim',
  config = function()
    require('telescope').setup {
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown {
            -- You can customize the theme here
            -- Options: get_dropdown, get_cursor, get_ivy
          },
        },
      },
    }
    -- Load the extension
    require('telescope').load_extension('ui-select')
  end,
}
