return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',

  config = function()
    -- Setup nvim-treesitter with new API
    require('nvim-treesitter').setup {
      install_dir = vim.fn.stdpath('data') .. '/site',
    }

    -- Define parsers to install
    local parsers = {
      'lua',
      'python',
      'javascript',
      'typescript',
      'vimdoc',
      'vim',
      'regex',
      'terraform',
      'sql',
      'dockerfile',
      'toml',
      'json',
      'java',
      'groovy',
      'go',
      'gitignore',
      'graphql',
      'yaml',
      'make',
      'cmake',
      'markdown',
      'markdown_inline',
      'bash',
      'tsx',
      'css',
      'html',
      'prisma',
    }

    -- Install parsers (async, no-op if already installed)
    require('nvim-treesitter').install(parsers)

    -- Enable treesitter highlighting for all buffers
    vim.api.nvim_create_autocmd('FileType', {
      pattern = '*',
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}