return {
  'echasnovski/mini.hipatterns',
  event = 'BufReadPre',
  config = function()
    local hipatterns = require 'mini.hipatterns'

    hipatterns.setup {
      highlighters = {
        -- Highlight hex colors (#fff, #ffffff)
        hex_color = hipatterns.gen_highlighter.hex_color(),

        -- Highlight rgb()/rgba()
        rgb_color = {
          pattern = 'rgb%(%d+,%s*%d+,%s*%d+%)',
          group = function(_, match)
            return hipatterns.compute_hex_color_group(match, 'bg')
          end,
        },

        -- TODO / FIXME / comments
        todo = {
          pattern = '%f[%w]()TODO()%f[%W]',
          group = 'MiniHipatternsTodo',
        },
        fixme = {
          pattern = '%f[%w]()FIXME()%f[%W]',
          group = 'MiniHipatternsFixme',
        },
      },
    }
  end,
}
