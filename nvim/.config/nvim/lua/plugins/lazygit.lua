return {
  'kdheepak/lazygit.nvim',
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  -- optional for floating window border decoration
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  -- setting the keybinding for LazyGit with 'keys' is recommended in
  -- order to load the plugin when the command is run for the first time
  keys = {
    { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'Open LazyGit' },
    { '<leader>lf', '<cmd>LazyGitCurrentFile<cr>', desc = 'LazyGit Current File' },
    { '<leader>ll', '<cmd>LazyGitFilter<cr>', desc = 'LazyGit Filter (log)' },
    { '<leader>lc', '<cmd>LazyGitConfig<cr>', desc = 'LazyGit Config' },
  },
  config = function()
    -- Lazygit floating window settings
    vim.g.lazygit_floating_window_winblend = 0 -- transparency of floating window
    vim.g.lazygit_floating_window_scaling_factor = 0.9 -- scaling factor for floating window
    vim.g.lazygit_floating_window_border_chars = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' } -- customize border
    vim.g.lazygit_floating_window_use_plenary = 0 -- use plenary.nvim to manage floating window if available
    vim.g.lazygit_use_neovim_remote = 1 -- for neovim-remote support
  end,
}
