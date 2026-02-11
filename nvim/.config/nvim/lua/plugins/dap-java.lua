return {
  -- DAP (Debug Adapter Protocol) for Neovim
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      -- UI for nvim-dap
      {
        'rcarriga/nvim-dap-ui',
        dependencies = {
          'nvim-neotest/nvim-nio',
        },
      },
      -- Virtual text support for debugging
      'theHamsta/nvim-dap-virtual-text',
      -- Mason integration for DAP
      'jay-babu/mason-nvim-dap.nvim',
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'
      
      -- Setup DAP UI
      dapui.setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '▸' },
        mappings = {
          expand = { '<CR>', '<2-LeftMouse>' },
          open = 'o',
          remove = 'd',
          edit = 'e',
          repl = 'r',
          toggle = 't',
        },
        layouts = {
          {
            elements = {
              { id = 'scopes', size = 0.25 },
              { id = 'breakpoints', size = 0.25 },
              { id = 'stacks', size = 0.25 },
              { id = 'watches', size = 0.25 },
            },
            size = 40,
            position = 'left',
          },
          {
            elements = {
              { id = 'repl', size = 0.5 },
              { id = 'console', size = 0.5 },
            },
            size = 10,
            position = 'bottom',
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = 'rounded',
          mappings = {
            close = { 'q', '<Esc>' },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil,
          max_value_lines = 100,
        },
      }
      
      -- Setup virtual text
      require('nvim-dap-virtual-text').setup {
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        filter_references_pattern = '<module',
        virt_text_pos = 'eol',
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil,
      }
      
      -- Mason DAP setup
      require('mason-nvim-dap').setup {
        ensure_installed = { 'java-debug-adapter', 'java-test' },
        automatic_installation = true,
      }
      
      -- Automatically open/close DAP UI
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end
      
      -- DAP keybindings (IntelliJ-style)
      -- F5 = Continue/Start
      vim.keymap.set('n', '<F5>', function()
        require('dap').continue()
      end, { desc = 'Debug: Start/Continue' })
      
      -- F9 = Toggle Breakpoint
      vim.keymap.set('n', '<F9>', function()
        require('dap').toggle_breakpoint()
      end, { desc = 'Debug: Toggle Breakpoint' })
      
      -- F10 = Step Over
      vim.keymap.set('n', '<F10>', function()
        require('dap').step_over()
      end, { desc = 'Debug: Step Over' })
      
      -- F11 = Step Into
      vim.keymap.set('n', '<F11>', function()
        require('dap').step_into()
      end, { desc = 'Debug: Step Into' })
      
      -- Shift+F11 = Step Out
      vim.keymap.set('n', '<S-F11>', function()
        require('dap').step_out()
      end, { desc = 'Debug: Step Out' })
      
      -- Leader keybindings for debugging
      vim.keymap.set('n', '<leader>db', function()
        require('dap').toggle_breakpoint()
      end, { desc = 'Debug: Toggle Breakpoint' })
      
      vim.keymap.set('n', '<leader>dB', function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end, { desc = 'Debug: Set Conditional Breakpoint' })
      
      vim.keymap.set('n', '<leader>dc', function()
        require('dap').continue()
      end, { desc = 'Debug: Continue' })
      
      vim.keymap.set('n', '<leader>dC', function()
        require('dap').run_to_cursor()
      end, { desc = 'Debug: Run to Cursor' })
      
      vim.keymap.set('n', '<leader>dd', function()
        require('dap').disconnect()
      end, { desc = 'Debug: Disconnect' })
      
      vim.keymap.set('n', '<leader>dg', function()
        require('dap').session()
      end, { desc = 'Debug: Get Session' })
      
      vim.keymap.set('n', '<leader>di', function()
        require('dap').step_into()
      end, { desc = 'Debug: Step Into' })
      
      vim.keymap.set('n', '<leader>do', function()
        require('dap').step_over()
      end, { desc = 'Debug: Step Over' })
      
      vim.keymap.set('n', '<leader>dO', function()
        require('dap').step_out()
      end, { desc = 'Debug: Step Out' })
      
      vim.keymap.set('n', '<leader>dp', function()
        require('dap').pause()
      end, { desc = 'Debug: Pause' })
      
      vim.keymap.set('n', '<leader>dr', function()
        require('dap').repl.toggle()
      end, { desc = 'Debug: Toggle REPL' })
      
      vim.keymap.set('n', '<leader>ds', function()
        require('dap').continue()
      end, { desc = 'Debug: Start' })
      
      vim.keymap.set('n', '<leader>dt', function()
        require('dap').terminate()
      end, { desc = 'Debug: Terminate' })
      
      vim.keymap.set('n', '<leader>du', function()
        require('dapui').toggle()
      end, { desc = 'Debug: Toggle UI' })
      
      vim.keymap.set('n', '<leader>dw', function()
        require('dap.ui.widgets').hover()
      end, { desc = 'Debug: Widgets' })
      
      -- DAP signs (breakpoint icons)
      vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
      vim.fn.sign_define('DapBreakpointCondition', { text = '🟡', texthl = 'DapBreakpointCondition', linehl = '', numhl = '' })
      vim.fn.sign_define('DapLogPoint', { text = '📝', texthl = 'DapLogPoint', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '▶️', texthl = 'DapStopped', linehl = 'DapStoppedLine', numhl = '' })
      vim.fn.sign_define('DapBreakpointRejected', { text = '⭕', texthl = 'DapBreakpointRejected', linehl = '', numhl = '' })
    end,
  },
}
