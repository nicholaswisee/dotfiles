return {
  '3rd/image.nvim',
  lazy = true,
  ft = { 'markdown', 'norg', 'vimwiki' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    backend = 'kitty', -- Kitty graphics protocol (works with Ghostty)
    processor = 'magick_rock', -- Uses LuaRock magick bindings

    -- Integration settings
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        filetypes = { 'markdown', 'vimwiki' },
        -- Resolve Obsidian wiki-link image syntax ![[image.png]]
        resolve_image_path = function(document_path, image_path, fallback)
          -- Handle Obsidian wiki-link style (already extracted without brackets)
          local expanded = vim.fn.expand(image_path)
          if vim.fn.filereadable(expanded) == 1 then
            return expanded
          end

          -- Try relative to document
          local doc_dir = vim.fn.fnamemodify(document_path, ':h')
          local relative_path = doc_dir .. '/' .. image_path
          if vim.fn.filereadable(relative_path) == 1 then
            return relative_path
          end

          -- Search in Obsidian vault attachments folder
          local vault_path = vim.fn.expand('~/kolak')
          local search_result = vim.fn.globpath(vault_path, '**/' .. image_path, 0, 1)
          if #search_result > 0 then
            return search_result[1]
          end

          return fallback(document_path, image_path)
        end,
      },
      neorg = {
        enabled = true,
        filetypes = { 'norg' },
      },
      html = {
        enabled = false,
      },
      css = {
        enabled = false,
      },
    },

    -- Display settings
    max_width = nil, -- max width in character cells
    max_height = nil, -- max height in character cells
    max_width_window_percentage = 80, -- max % of window width
    max_height_window_percentage = 50, -- max % of window height

    -- Window overlap settings
    window_overlap_clear_enabled = true,
    window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },

    -- Editor options for correct rendering
    editor_only_render_when_focused = false,

    -- tmux specific settings (required for image display through tmux)
    tmux_show_only_in_active_window = true,

    -- Hijack file types for image preview
    hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif' },
  },

  -- Setup function for additional configuration
  config = function(_, opts)
    require('image').setup(opts)
  end,
}
