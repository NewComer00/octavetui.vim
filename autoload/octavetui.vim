let s:cli_buf_name = 'Octave CLI'
let s:cli_bufnr = ''
let s:vexp_buf_name = 'Variable Explorer'
let s:vexp_bufnr = ''

function! s:UpdateVexp(variable_file, history_file, timerid) abort
    if filereadable(a:variable_file) && filereadable(a:history_file)
        call timer_stop(a:timerid)

        call deletebufline(s:vexp_bufnr, 1, '$')
        call setbufline(s:vexp_bufnr, 1, readfile(a:variable_file))
        call delete(a:variable_file)
        call delete(a:history_file)
    endif
endfunction

function! s:CheckVar() abort
    let history_file = tempname()
    let history_num = 10
    let cmd_save_history = "__octavetui_histnum__=".history_num.";__octavetui_tmp__='".history_file."';history('-w',__octavetui_tmp__);__octavetui_str__=fileread(__octavetui_tmp__);__octavetui_fp__=fopen(__octavetui_tmp__,'wt');fputs(__octavetui_fp__,strjoin(strsplit(__octavetui_str__,newline)(max(1,end-1-__octavetui_histnum__):end-1),newline));fclose(__octavetui_fp__);clear __octavetui_tmp__ __octavetui_fp__ __octavetui_str__ __octavetui_histnum__;"
    let cmd_restore_history = "history('-r','".history_file."');"

    let variable_file = tempname()
    let cmd = "__octavetui_fp__=fopen('".variable_file."','at');fputs(__octavetui_fp__,evalc('whos -regexp (?!^__octavetui_fp__$)(^.*$)'));__octavetui_fp__=fclose(__octavetui_fp__);clear __octavetui_fp__;"

    call term_sendkeys(s:cli_bufnr, cmd_save_history . cmd . cmd_restore_history . "\<CR>")
    call timer_start(200,
                \ function('s:UpdateVexp', [variable_file,history_file]),
                \ {'repeat': -1})
endfunction

function! octavetui#StartCli() abort
    if has('nvim')
        exec 'split term://' . g:octavetui_octave_path
    else
        let s:cli_bufnr = term_start(g:octavetui_octave_path,
                    \ {"term_kill": "term", "term_name": s:cli_buf_name})
        tnoremap <silent><buffer> <CR> <CR><Cmd>call <SID>CheckVar()<CR>
    endif
endfunction

function! octavetui#StartVarExp() abort
    let s:vexp_bufnr = bufadd(s:vexp_buf_name)
    call setbufvar(s:vexp_bufnr, '&buftype', 'nofile')
    call bufload(s:vexp_bufnr)
    exec 'botright vertical sbuffer' . s:vexp_bufnr
endfunction

function! octavetui#StartAll() abort
    call octavetui#StartVarExp()
    call octavetui#StartCli()
endfunction
