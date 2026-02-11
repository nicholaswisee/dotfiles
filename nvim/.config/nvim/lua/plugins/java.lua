return {
  'mfussenegger/nvim-jdtls',
  ft = { 'java' },
  dependencies = {
    'mfussenegger/nvim-dap',
  },
  config = function()
    local jdtls = require 'jdtls'
    local home = os.getenv 'HOME'
    
    -- Find root directory (Maven or Gradle project)
    local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
    local root_dir = require('jdtls.setup').find_root(root_markers)
    
    -- Workspace directory - separate workspace per project
    local workspace_dir = home .. '/.local/share/nvim/jdtls-workspace/' .. vim.fn.fnamemodify(root_dir, ':p:h:t')
    
    -- Path to jdtls installation (Mason installs it here)
    local mason_registry = require 'mason-registry'
    local jdtls_path = mason_registry.get_package('jdtls'):get_install_path()
    
    -- Path to jar file
    local jar_path = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
    
    -- Determine OS-specific config directory
    local system = 'linux'
    if vim.fn.has 'mac' == 1 then
      system = 'mac'
    elseif vim.fn.has 'win32' == 1 then
      system = 'win'
    end
    local config_dir = jdtls_path .. '/config_' .. system
    
    -- Path to java-debug and vscode-java-test bundles (for debugging and testing)
    local bundles = {}
    
    -- Add java-debug adapter
    local java_debug_path = mason_registry.get_package('java-debug-adapter'):get_install_path()
    local java_debug_jar = vim.fn.glob(java_debug_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar', true)
    if java_debug_jar ~= '' then
      table.insert(bundles, java_debug_jar)
    end
    
    -- LSP capabilities from blink.cmp
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    
    -- Extended client capabilities for jdtls
    local extendedClientCapabilities = jdtls.extendedClientCapabilities
    extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
    
    local config = {
      cmd = {
        'java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-jar', jar_path,
        '-configuration', config_dir,
        '-data', workspace_dir,
      },
      
      root_dir = root_dir,
      
      settings = {
        java = {
          eclipse = {
            downloadSources = true,
          },
          configuration = {
            updateBuildConfiguration = 'interactive',
            runtimes = {
              -- Add your Java installations here if needed
              -- {
              --   name = 'JavaSE-17',
              --   path = '/usr/lib/jvm/java-17-openjdk',
              -- },
            },
          },
          maven = {
            downloadSources = true,
          },
          implementationsCodeLens = {
            enabled = true,
          },
          referencesCodeLens = {
            enabled = true,
          },
          references = {
            includeDecompiledSources = true,
          },
          format = {
            enabled = true,
            settings = {
              -- Use Google Java Style Guide
              url = 'https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml',
              profile = 'GoogleStyle',
            },
          },
          signatureHelp = { enabled = true },
          contentProvider = { preferred = 'fernflower' },
          completion = {
            favoriteStaticMembers = {
              'org.junit.jupiter.api.Assertions.*',
              'org.junit.Assert.*',
              'org.mockito.Mockito.*',
            },
            filteredTypes = {
              'com.sun.*',
              'io.micrometer.shaded.*',
              'java.awt.*',
              'jdk.*',
              'sun.*',
            },
          },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
          codeGeneration = {
            toString = {
              template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
            },
            useBlocks = true,
          },
        },
      },
      
      flags = {
        allow_incremental_sync = true,
      },
      
      init_options = {
        bundles = bundles,
        extendedClientCapabilities = extendedClientCapabilities,
      },
      
      capabilities = capabilities,
      
      -- Keybindings and commands
      on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        
        local opts = { noremap = true, silent = true, buffer = bufnr }
        
        -- Java-specific keybindings
        vim.keymap.set('n', '<leader>jo', function()
          require('jdtls').organize_imports()
        end, vim.tbl_extend('force', opts, { desc = 'Java: Organize imports' }))
        
        vim.keymap.set('n', '<leader>jv', function()
          require('jdtls').extract_variable()
        end, vim.tbl_extend('force', opts, { desc = 'Java: Extract variable' }))
        
        vim.keymap.set('v', '<leader>jv', function()
          require('jdtls').extract_variable(true)
        end, vim.tbl_extend('force', opts, { desc = 'Java: Extract variable' }))
        
        vim.keymap.set('n', '<leader>jc', function()
          require('jdtls').extract_constant()
        end, vim.tbl_extend('force', opts, { desc = 'Java: Extract constant' }))
        
        vim.keymap.set('v', '<leader>jc', function()
          require('jdtls').extract_constant(true)
        end, vim.tbl_extend('force', opts, { desc = 'Java: Extract constant' }))
        
        vim.keymap.set('v', '<leader>jm', function()
          require('jdtls').extract_method(true)
        end, vim.tbl_extend('force', opts, { desc = 'Java: Extract method' }))
        
        -- Update runtime
        vim.keymap.set('n', '<leader>ju', function()
          require('jdtls').update_project_config()
        end, vim.tbl_extend('force', opts, { desc = 'Java: Update project config' }))
        
        -- JShell (Java REPL)
        vim.keymap.set('n', '<leader>js', function()
          require('jdtls').jshell()
        end, vim.tbl_extend('force', opts, { desc = 'Java: JShell' }))
        
        -- Setup DAP (Debugging)
        require('jdtls').setup_dap { hotcodereplace = 'auto' }
      end,
    }
    
    -- Start or attach to jdtls
    jdtls.start_or_attach(config)
    
    -- Auto-organize imports on save (optional, comment out if unwanted)
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*.java',
      callback = function()
        local _, err = pcall(vim.lsp.buf.format, { timeout_ms = 1000 })
        if err then
          vim.notify('Format error: ' .. err, vim.log.levels.WARN)
        end
        -- Uncomment to auto-organize imports on save
        -- require('jdtls').organize_imports()
      end,
    })
  end,
}
