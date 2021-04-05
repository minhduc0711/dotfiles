let b:coc_enabled = 0

nmap <buffer> <silent> gd :JavaSearch -x declarations<CR>
nmap <buffer> <silent> gi :JavaSearch -x implementors<CR>
nmap <buffer> <silent> gr :JavaSearch -x references<CR>
nmap <buffer> <silent> <C-l> :JavaImportOrganize<CR>

let g:EclimCompletionMethod = 'omnifunc'
if !exists('g:neocomplcache_force_omni_patterns')
  let g:neocomplcache_force_omni_patterns = {}
endif
let g:neocomplcache_force_omni_patterns.java = '\k\.\k*'
let g:EclimJavaSearchSingleResult = "edit"
NeoComplCacheEnable
