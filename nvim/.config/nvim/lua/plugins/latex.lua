return {
  -- VimTeX - LaTeX plugin for Neovim
  {
    'lervag/vimtex',
    lazy = false, -- lazy-loading will disable inverse search
    ft = { 'tex', 'bib' },
    config = function()
      -- Viewer configuration
      -- Set the PDF viewer (zathura, evince, okular, etc.)
      vim.g.vimtex_view_method = 'zathura' -- Change to your preferred viewer

      -- Compiler configuration
      -- VimTeX will auto-detect latexmk, pdflatex, etc.
      vim.g.vimtex_compiler_method = 'latexmk'

      -- Compiler options
      vim.g.vimtex_compiler_latexmk = {
        build_dir = '',
        callback = 1,
        continuous = 1,
        executable = 'latexmk',
        options = {
          '-pdf',
          '-verbose',
          '-file-line-error',
          '-synctex=1',
          '-interaction=nonstopmode',
        },
      }

      -- Table of contents configuration
      vim.g.vimtex_toc_config = {
        name = 'TOC',
        layers = { 'content', 'todo', 'include' },
        split_width = 30,
        todo_sorted = 0,
        show_help = 1,
        show_numbers = 1,
      }

      -- Disable automatic quickfix window opening
      vim.g.vimtex_quickfix_mode = 0

      -- Disable overfull/underfull warnings
      vim.g.vimtex_quickfix_ignore_filters = {
        'Overfull',
        'Underfull',
      }

      -- Enable fold
      vim.g.vimtex_fold_enabled = 0

      -- Conceal configuration (optional, set to 0 to disable)
      vim.g.vimtex_syntax_conceal_disable = 0

      -- Disable some default mappings if needed
      vim.g.vimtex_mappings_enabled = 1

      -- Formatter configuration (if using external formatter)
      vim.g.vimtex_format_enabled = 0

      -- Keybindings
      vim.keymap.set('n', '<leader>lb', '<cmd>VimtexCompile<CR>', { desc = 'LaTeX: Build/Compile' })
      vim.keymap.set('n', '<leader>lv', '<cmd>VimtexView<CR>', { desc = 'LaTeX: View PDF' })
      vim.keymap.set('n', '<leader>lc', '<cmd>VimtexClean<CR>', { desc = 'LaTeX: Clean auxiliary files' })
      vim.keymap.set('n', '<leader>lt', '<cmd>VimtexTocToggle<CR>', { desc = 'LaTeX: Toggle TOC' })
      vim.keymap.set('n', '<leader>lk', '<cmd>VimtexStop<CR>', { desc = 'LaTeX: Stop compilation' })
      vim.keymap.set('n', '<leader>le', '<cmd>VimtexErrors<CR>', { desc = 'LaTeX: Show errors' })
      vim.keymap.set('n', '<leader>li', '<cmd>VimtexInfo<CR>', { desc = 'LaTeX: Show info' })
      vim.keymap.set('n', '<leader>ls', '<cmd>VimtexStatus<CR>', { desc = 'LaTeX: Show status' })

      -- Auto-compile on save (optional)
      vim.api.nvim_create_autocmd('BufWritePost', {
        pattern = '*.tex',
        callback = function()
          -- Automatically compile when saving .tex files
          -- Comment this out if you prefer manual compilation
          -- vim.cmd('VimtexCompile')
        end,
      })

      -- Set filetype-specific options for LaTeX
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'tex',
        callback = function()
          vim.opt_local.spell = true
          vim.opt_local.spelllang = 'en_us'
          vim.opt_local.conceallevel = 2
          vim.opt_local.textwidth = 80
          vim.opt_local.wrap = true
          vim.opt_local.linebreak = true
        end,
      })
    end,
  },
}
