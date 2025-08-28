# Neovim Configuration: kickstart.nvim

## Project Overview

This directory contains a Neovim configuration based on the [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) repository. It's a single-file, well-documented starting point for building a personalized Neovim editor. The configuration uses Lua and the `lazy.nvim` plugin manager to handle a curated set of plugins.

**Key Technologies:**

*   **Editor:** Neovim
*   **Language:** Lua
*   **Plugin Manager:** `lazy.nvim`

**Core Plugins:**

*   **`telescope.nvim`**: A fuzzy finder for files, LSP, and more.
*   **`nvim-lspconfig`**: Configures the Language Server Protocol (LSP) for features like go-to-definition, find references, and autocompletion.
*   **`mason.nvim`**: Manages the installation of LSPs.
*   **`conform.nvim`**: Provides auto-formatting capabilities.
*   **`blink.cmp`**: Powers autocompletion.
*   **`tokyonight.nvim`**: The default colorscheme.
*   **`nvim-treesitter`**: Handles syntax highlighting and code parsing.
*   **`mini.nvim`**: A collection of smaller utility plugins.

## Building and Running

This is a Neovim configuration, so there is no traditional "build" process. To "run" the project, you simply need to open Neovim:

```bash
nvim
```

On the first launch, `lazy.nvim` will automatically install the configured plugins.

**Key Commands:**

*   `:Lazy`: View the status of your plugins.
*   `:Lazy update`: Update your plugins.
*   `:Telescope find_files`: Fuzzy find files in the current directory.
*   `:Telescope live_grep`: Search for a string in the current directory.

## Development Conventions

The `kickstart.nvim` project encourages a modular approach to configuration. While the base configuration is a single `init.lua` file, users are encouraged to add their own plugins and customizations in the `lua/custom/plugins/` directory.

**Adding Plugins:**

To add a new plugin, create a new `.lua` file in the `lua/custom/plugins/` directory and return a table with the plugin's specification. For example:

```lua
-- lua/custom/plugins/my-plugin.lua
return {
  'user/repo',
  -- Plugin options
}
```

**Formatting:**

The project uses `stylua` for Lua code formatting. The configuration for `stylua` can be found in the `.stylua.toml` file.
