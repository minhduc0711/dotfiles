lua << EOF
  local root_markers = {'gradlew', '.git'}
  local root_dir = require('jdtls.setup').find_root(root_markers)
  local home = os.getenv('HOME')
  local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
  require('jdtls').start_or_attach({
    cmd = {'java-lsp', workspace_folder}
  })
EOF
