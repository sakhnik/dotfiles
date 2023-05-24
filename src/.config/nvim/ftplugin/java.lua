local function configureBuffer() --(client, bufnr)
  require("local.lsp").configureBuffer()

  local opts = {noremap = true, silent = true, buffer = true}
  vim.keymap.set('n', '<A-o>', require'jdtls'.organize_imports, opts)
  vim.keymap.set('n', 'crv', require('jdtls').extract_variable, opts)
  vim.keymap.set('v', 'crv', function() require('jdtls').extract_variable(true) end, opts)
  vim.keymap.set('n', 'crv', require('jdtls').extract_variable, opts)
  vim.keymap.set('v', 'crv', function() require('jdtls').extract_variable(true) end, opts)
  vim.keymap.set('v', 'crm', function() require('jdtls').extract_method(true) end, opts)

  vim.cmd [[
    command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)
    command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)
    command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()
    command! -buffer JdtJol lua require('jdtls').jol()
    command! -buffer JdtBytecode lua require('jdtls').javap()
    command! -buffer JdtJshell lua require('jdtls').jshell()
  ]]
end

local config = {
  cmd = {'jdtls'},
  root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', '.hg', 'mvnw'}, { upward = true })[1]),
  on_attach = configureBuffer,
  settings = {
    java = {
      configuration = {
        -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
        -- And search for `interface RuntimeOption`
        -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
        runtimes = {
          {
            name = "JavaSE-1.8",
            path = "/home/sakhnik/.sdkman/candidates/java/8.0.362.fx-zulu/",
          },
          {
            name = "JavaSE-11",
            path = "/home/sakhnik/.sdkman/candidates/java/11.0.19.fx-zulu/",
          },
        }
      }
    }
  }
}
require('jdtls').start_or_attach(config)
