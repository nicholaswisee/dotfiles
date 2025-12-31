return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-mini/mini.nvim',
  },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {},

  keys = {
    { '<leader>m', '<cmd>RenderMarkdown toggle<CR>', desc = 'Toggle Markdown Render' },
    { '<leader>me', '<cmd>RenderMarkdown enable<CR>', desc = 'Enable Markdown Render' },
    { '<leader>md', '<cmd>RenderMarkdown disable<CR>', desc = 'Disable Markdown Render' },
  },
}
