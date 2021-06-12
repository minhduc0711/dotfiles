" toggle ibus-bamboo
" WARNING: cause delays when switching modes, makes bracket expanding very slow
function! IBusOff()
  " Lưu engine hiện tại
  let g:ibus_prev_engine = system('ibus engine')
  " Chuyển sang engine tiếng Anh
  silent! execute '!ibus engine xkb:us::eng'
endfunction

function! IBusOn()
  let l:current_engine = system('ibus engine')
  " nếu engine được set trong normal mode thì
  " lúc vào insert mode dùng luôn engine đó
  if l:current_engine !~? 'xkb:us::eng'
    let g:ibus_prev_engine = l:current_engine
  endif
  " Khôi phục lại engine
  silent! execute '!ibus engine ' . g:ibus_prev_engine
endfunction

" TODO: there is probably a more correct way
augroup IBusHandler
  " Khôi phục ibus engine khi tìm kiếm
  autocmd CmdLineEnter <buffer> silent call IBusOn()
  autocmd CmdLineLeave <buffer> silent call IBusOff()
  " Khôi phục ibus engine khi vào insert mode
  autocmd InsertEnter <buffer> silent call IBusOn()
  " Tắt ibus engine khi vào normal mode
  autocmd InsertLeave <buffer> silent call IBusOff()
augroup END
