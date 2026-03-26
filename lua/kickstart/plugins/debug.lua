-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<F6>',
      function()
        -- Find all .sln files walking up from current file
        local dir = vim.fn.expand '%:p:h'
        local solutions = {}
        while dir and dir ~= '' do
          local slns = vim.fn.glob(dir .. '/*.sln', false, true)
          for _, s in ipairs(slns) do
            table.insert(solutions, s)
          end
          local parent = vim.fn.fnamemodify(dir, ':h')
          if parent == dir then
            break
          end
          dir = parent
        end
        if #solutions == 0 then
          vim.notify('No .sln found', vim.log.levels.ERROR)
          return
        end
        local function build(sln_path)
          local sln_dir = vim.fn.fnamemodify(sln_path, ':h')
          local sln_name = vim.fn.fnamemodify(sln_path, ':t')
          vim.notify('Building ' .. sln_name .. '...', vim.log.levels.INFO)
          vim.fn.jobstart('dotnet build --nologo "' .. sln_path .. '"', {
            stdout_buffered = true,
            stderr_buffered = true,
            on_exit = function(_, code)
              vim.schedule(function()
                if code == 0 then
                  -- Set cwd so F5 launch.json resolves ${workspaceFolder} correctly
                  vim.cmd('cd ' .. vim.fn.fnameescape(sln_dir))
                  vim.notify('Build succeeded (' .. sln_name .. ')\ncwd set to ' .. sln_dir, vim.log.levels.INFO)
                else
                  vim.notify('Build failed (' .. sln_name .. ')', vim.log.levels.ERROR)
                end
              end)
            end,
          })
        end
        if #solutions == 1 then
          build(solutions[1])
        else
          vim.ui.select(solutions, { prompt = 'Select solution to build:' }, function(choice)
            if choice then
              build(choice)
            end
          end)
        end
      end,
      desc = 'Build .NET solution',
    },
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
        'coreclr',
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Change breakpoint icons
    -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    -- local breakpoint_icons = vim.g.have_nerd_font
    --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    -- for type, icon in pairs(breakpoint_icons) do
    --   local tp = 'Dap' .. type
    --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
    --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    -- end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }

    -- C# / .NET config
    dap.adapters.coreclr = {
      type = 'executable',
      command = vim.fn.stdpath 'data' .. '/mason/packages/netcoredbg/netcoredbg/netcoredbg.exe',
      args = { '--interpreter=vscode' },
    }

    -- Load launch.json from .vscode/ first (these appear at the top)
    require('dap.ext.vscode').load_launchjs(nil, { coreclr = { 'cs' } })

    -- Append fallback configs at the end
    local cs_configs = dap.configurations.cs or {}
    table.insert(cs_configs, {
      type = 'coreclr',
      name = 'Launch DLL',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
      end,
      cwd = function()
        return vim.fn.getcwd()
      end,
    })
    table.insert(cs_configs, {
      type = 'coreclr',
      name = 'Attach to process',
      request = 'attach',
      processId = require('dap.utils').pick_process,
    })
    dap.configurations.cs = cs_configs
  end,
}
