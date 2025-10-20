-- Unit testing framework for C#
return {
  {
    'nvim-neotest/nvim-nio',
  },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'Issafalcon/neotest-dotnet',
    },
  },
  {
    'Issafalcon/neotest-dotnet',
    lazy = false,
    dependencies = {
      'nvim-neotest/neotest',
    },
  },
}
