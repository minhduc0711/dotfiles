" lua << EOF
"   local root_markers = {'.git', 'gradlew'}
"   local root_dir = require('jdtls.setup').find_root(root_markers)
"   local home = os.getenv('HOME')
"   local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
"   local config = {
"     cmd = {'java-lsp', workspace_folder},
"     root_dir = root_dir,
"     settings = {
"       java = {
"         autobuild = {
"           enabled = true
"         },
"         configuration = {
"           runtimes = {
"             {
"               name = "JavaSE-15",
"               path = "/usr/lib/jvm/java-15-adoptopenjdk",
"             },
"           }
"         },
"       },
"       import = {
"         maven = {
"           enabled = false
"         },
"         gradle = {
"           enabled = false
"         }
"       }
"     }
"   }
"   require('jdtls').start_or_attach(config)
" EOF


" Temp switch to Eclim for more stability
" Mappings
" nmap <buffer> <silent> gd :JavaSearch -x declarations<CR>
" nmap <buffer> <silent> gi :JavaSearch -x implementors<CR>
" nmap <buffer> <silent> gr :JavaSearch -x references<CR>
" nmap <buffer> <silent> <C-l> :JavaImportOrganize<CR>
" nmap <buffer> <silent> <C-e> :lopen<CR>

" let g:SuperTabDefaultCompletionType = 'context'
