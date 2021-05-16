" Config for working with Eclim + Eclipse
" Remap goto commands
nmap <buffer> <silent> gd :JavaSearch -x declarations<CR>
nmap <buffer> <silent> gi :JavaSearch -x implementors<CR>
nmap <buffer> <silent> gr :JavaSearch -x references<CR>
nmap <buffer> <silent> K :JavaDocPreview<CR>
nmap <buffer> <silent> <C-l> :JavaImportOrganize<CR>

" Enable omni completion in nvim-compe
call compe#setup({'source': { 'omni': v:true, 'path': v:true, 'buffer': v:true }})
