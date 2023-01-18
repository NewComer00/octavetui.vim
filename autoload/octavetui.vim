let s:autoload_root = fnamemodify(resolve(expand('<sfile>:p')), ':h')

let s:hook_variable_check_interval = 1000
let s:hook_breakpoint_check_interval = 500
let s:history_num = 10
let s:color_breakpoint = 'darkblue'

let s:cli_buf_name = 'Octave CLI'
let s:cli_bufnr = ''
let s:vexp_buf_name = 'Variable Explorer'
let s:vexp_bufnr = ''

let s:cmd_set_envvar = 'export'
let s:shell_command_flag = '-c'
if has('win32')
    let s:cmd_set_envvar = 'set'
    let s:shell_command_flag = '/K'
endif

let s:tmpfile_history = $TMP.'/octavetui_history'
let s:envvar_history = 'OCTAVETUI_HISTORY'

let s:envvar_history_num = 'OCTAVETUI_HISTORY_NUM'

let s:tmpfile_variable = $TMP.'/octavetui_variable'
let s:envvar_variable = 'OCTAVETUI_VARIABLE'

let s:tmpfile_breakpoint = $TMP.'/octavetui_breakpoint'
let s:envvar_breakpoint = 'OCTAVETUI_BREAKPOINT'


exec 'highlight octavetui_hl_breakpoint ctermbg='.s:color_breakpoint.' guibg='.s:color_breakpoint


function! s:UpdateVexp(timerid) abort
    if filereadable(s:tmpfile_history) && filereadable(s:tmpfile_variable)
        call timer_stop(a:timerid)
        call deletebufline(s:vexp_bufnr, 1, '$')
        call setbufline(s:vexp_bufnr, 1, readfile(s:tmpfile_variable))
        call delete(s:tmpfile_variable)
    endif
endfunction

function! s:CheckVar() abort
    let cmd = 'run octavetui_update_hook'
    call term_sendkeys(s:cli_bufnr, cmd . "\<CR>")
    call timer_start(s:hook_variable_check_interval,
                \ function('s:UpdateVexp', []),
                \ {'repeat': -1})
endfunction

function! s:UpdateBreakpoint(timerid) abort
    if filereadable(s:tmpfile_history) && filereadable(s:tmpfile_breakpoint)
        call timer_stop(a:timerid)
        let l:breakpoint_line = readfile(s:tmpfile_breakpoint)
        call matchaddpos('octavetui_hl_breakpoint', [l:breakpoint_line])
        call delete(s:tmpfile_breakpoint)
    endif
endfunction

function! octavetui#StartCli() abort
    let l:cmd_cli_startup = [ &shell, s:shell_command_flag,
                \ s:cmd_set_envvar.' '.s:envvar_history.'='.s:tmpfile_history
                \ .' && '.s:cmd_set_envvar.' '.s:envvar_history_num.'='.s:history_num
                \ .' && '.s:cmd_set_envvar.' '.s:envvar_variable.'='.s:tmpfile_variable
                \ .' && '.s:cmd_set_envvar.' '.s:envvar_breakpoint.'='.s:tmpfile_breakpoint
                \ .' && '.g:octavetui_octave_path
                \ .' --path '.s:autoload_root
                \ ]

    let s:cli_bufnr = term_start(l:cmd_cli_startup,
                \ {"term_kill": "term", "term_name": s:cli_buf_name})
    tnoremap <silent><buffer> <CR> <CR><Cmd>call <SID>CheckVar()<CR>
endfunction

function! octavetui#QuitCli() abort
    let l:cmd_octave_quit = 'exit'
    let l:cmd_shell_quit = 'exit'
    call term_sendkeys(s:cli_bufnr, "\<C-E>\<C-U>".l:cmd_octave_quit."\<CR>")
    call term_sendkeys(s:cli_bufnr, l:cmd_shell_quit."\<CR>")
    sleep 500m
    exec 'bdelete' . s:cli_bufnr
endfunction

function! octavetui#StartVarExp() abort
    let s:vexp_bufnr = bufadd(s:vexp_buf_name)
    call setbufvar(s:vexp_bufnr, '&buftype', 'nofile')
    call bufload(s:vexp_bufnr)
    exec 'botright vertical sbuffer' . s:vexp_bufnr
endfunction

function! octavetui#SetBreakpoint() abort
    let l:octave_filename = expand('%:t')
    let l:line_num = line('.')
    let l:cmd = "octavetui_breakpoint_hook '".l:octave_filename."' '".l:line_num."'"
    call term_sendkeys(s:cli_bufnr, "\<C-E>\<C-U>".l:cmd."\<CR>")
    call timer_start(s:hook_breakpoint_check_interval,
                \ function('s:UpdateBreakpoint', []),
                \ {'repeat': -1})
endfunction

function! octavetui#StartAll() abort
    call octavetui#StartVarExp()
    call octavetui#StartCli()
    nnoremap <silent> <C-q> :call octavetui#QuitCli()<CR>
    nnoremap <silent> <C-b> :call octavetui#SetBreakpoint()<CR>
endfunction
