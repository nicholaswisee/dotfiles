return {
  'epwalsh/obsidian.nvim',
  version = '*',
  lazy = true,
  ft = 'markdown',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'hrsh7th/nvim-cmp',
    'nvim-telescope/telescope.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    -- Update this path to your Obsidian vault location
    workspaces = {
      {
        name = 'kolak',
        path = '~/kolak',
      },
    },

    -- Completion settings
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },

    -- Note ID generation
    note_id_func = function(title)
      local suffix = ''
      if title ~= nil then
        suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
      else
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. '-' .. suffix
    end,

    -- Daily notes configuration
    daily_notes = {
      folder = 'daily',
      date_format = '%Y-%m-%d',
      alias_format = '%B %-d, %Y',
      template = nil,
    },

    -- Templates
    templates = {
      folder = 'Personal/templates',
      date_format = '%Y-%m-%d',
      time_format = '%H:%M',
    },

    -- UI settings
    ui = {
      enable = true,
      update_debounce = 200,
      checkboxes = {
        [' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
        ['x'] = { char = '', hl_group = 'ObsidianDone' },
        ['>'] = { char = '', hl_group = 'ObsidianRightArrow' },
        ['~'] = { char = '󰰱', hl_group = 'ObsidianTilde' },
      },
      bullets = { char = '•', hl_group = 'ObsidianBullet' },
      external_link_icon = { char = '', hl_group = 'ObsidianExtLinkIcon' },
      reference_text = { hl_group = 'ObsidianRefText' },
      highlight_text = { hl_group = 'ObsidianHighlightText' },
      tags = { hl_group = 'ObsidianTag' },
      block_ids = { hl_group = 'ObsidianBlockID' },
    },

    -- Attachments
    attachments = {
      img_folder = 'assets/imgs',
    },

    mappings = {
      -- Overrides the 'gf' mapping to work on markdown links
      ['gf'] = {
        action = function()
          return require('obsidian').util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Toggle check-boxes
      ['<leader>ch'] = {
        action = function()
          return require('obsidian').util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      -- Smart action on <CR>: toggle checkbox if there is one, else enter newline.
      ['<CR>'] = {
        action = function()
          if vim.bo.modifiable then
            return require('obsidian').util.smart_action()
          else
            return '<CR>'
          end
        end,
        opts = { buffer = true, expr = true },
      },
    },
  },

  keys = {
    { '<leader>on', '<cmd>ObsidianNew<CR>', desc = 'New Obsidian note' },
    { '<leader>oo', '<cmd>ObsidianOpen<CR>', desc = 'Open in Obsidian app' },
    { '<leader>os', '<cmd>ObsidianQuickSwitch<CR>', desc = 'Quick switch note' },
    { '<leader>of', '<cmd>ObsidianSearch<CR>', desc = 'Search notes' },
    { '<leader>ot', '<cmd>ObsidianToday<CR>', desc = "Today's daily note" },
    { '<leader>oy', '<cmd>ObsidianYesterday<CR>', desc = "Yesterday's daily note" },
    { '<leader>ob', '<cmd>ObsidianBacklinks<CR>', desc = 'Show backlinks' },
    { '<leader>ol', '<cmd>ObsidianLinks<CR>', desc = 'Show links' },
    { '<leader>oi', '<cmd>ObsidianPasteImg<CR>', desc = 'Paste image from clipboard' },
    { '<leader>or', '<cmd>ObsidianRename<CR>', desc = 'Rename note' },
    { 'gf', function()
        if require('obsidian').util.cursor_on_markdown_link() then
          return '<cmd>ObsidianFollowLink<CR>'
        else
          return 'gf'
        end
      end,
      desc = 'Follow link',
      expr = true,
    },
  },

  config = function(_, opts)
    require('obsidian').setup(opts)

    -- Set conceallevel for markdown files (required for obsidian UI features)
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'markdown',
      callback = function()
        vim.opt_local.conceallevel = 2
      end,
    })
  end,
}
