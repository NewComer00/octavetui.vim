let s:autoload_root = fnamemodify(resolve(expand('<sfile>:p')), ':h')

" give octave some time to execute our commands
let s:variable_check_interval = 200
let s:breakpoint_check_interval = 200

let s:history_num = 20
let s:color_breakpoint = 'darkblue'

let s:main_winnr = ''
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


function! s:Init() abort
    call s:RemoveTmpFile()
    let s:main_winnr = winnr()
endfunction

function! s:Update() abort
    call s:RemoveTmpFile()

    let cmd = 'run octavetui_update'
    call term_sendkeys(s:cli_bufnr, cmd . "\<CR>")

    call timer_start(s:variable_check_interval,
                \ function('s:UpdateVarExp', []),
                \ {'repeat': -1})

    call timer_start(s:breakpoint_check_interval,
                \ function('s:UpdateBreakpoint', []),
                \ {'repeat': -1})
endfunction

function! s:RemoveTmpFile() abort
    call delete(s:tmpfile_variable)
    call delete(s:tmpfile_breakpoint)
endfunction

function! s:UpdateVarExp(timerid) abort
    if s:FileIsFree(s:tmpfile_variable)
        call timer_stop(a:timerid)
        call deletebufline(s:vexp_bufnr, 1, '$')
        call setbufline(s:vexp_bufnr, 1, readfile(s:tmpfile_variable))
        call delete(s:tmpfile_variable)
    endif
endfunction

" if a file is readable, and it is not occupied by Octave fopen(...,'wt')
function! s:FileIsFree(filename) abort
    if !filereadable(a:filename)
        return v:false
    else
        let l:temp = tempname()
        call rename(a:filename, l:temp)
        if filereadable(a:filename)
            " file is readable but occupied
            call delete(l:temp)
            return v:false
        else
            call rename(l:temp, a:filename)
            return v:true
        endif
    endif
endfunction

" TODO
" clear all the old drawn breakpoints first, then update and redraw all breakpoints
" this might be slow if there are too many breakpoints
function! s:UpdateBreakpoint(timerid) abort
    if s:FileIsFree(s:tmpfile_breakpoint)
        call timer_stop(a:timerid)

        call clearmatches(s:main_winnr)
        let l:breakpoint_list = readfile(s:tmpfile_breakpoint)
        for l:bp in l:breakpoint_list
            let l:info = split(l:bp, '\t')
            let l:bp_name = l:info[0]
            let l:bp_file = l:info[1]
            let l:bp_line = str2nr(l:info[2])
            let l:bp_cond = l:info[3]

            let l:main_buf_file = expand('#'.winbufnr(s:main_winnr).':p')
            if l:bp_file == l:main_buf_file
                call matchaddpos('octavetui_hl_breakpoint', [l:bp_line],
                            \ 10, -1,
                            \ {'window': s:main_winnr}
                            \ )
            endif
        endfor
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
    tnoremap <silent><buffer> <CR> <CR><Cmd>call <SID>Update()<CR>
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
    let l:cmd = "octavetui_toggle_breakpoint set '".l:octave_filename."' ".l:line_num
    call term_sendkeys(s:cli_bufnr, "\<C-E>\<C-U>".l:cmd."\<CR>")
    call timer_start(s:breakpoint_check_interval,
                \ function('s:UpdateBreakpoint', []),
                \ {'repeat': -1})
endfunction

function! octavetui#UnsetBreakpoint() abort
    let l:octave_filename = expand('%:t')
    let l:line_num = line('.')
    let l:cmd = "octavetui_toggle_breakpoint unset '".l:octave_filename."' ".l:line_num
    call term_sendkeys(s:cli_bufnr, "\<C-E>\<C-U>".l:cmd."\<CR>")
    call timer_start(s:breakpoint_check_interval,
                \ function('s:UpdateBreakpoint', []),
                \ {'repeat': -1})
endfunction

function! octavetui#RefreshAll() abort
    call s:Update()
endfunction

function! octavetui#StartAll() abort
    call s:Init()
    call octavetui#StartVarExp()
    call octavetui#StartCli()
    nnoremap <silent> <C-q> :call octavetui#QuitCli()<CR>
    nnoremap <silent> <C-b> :call octavetui#SetBreakpoint()<CR>
    nnoremap <silent> <M-b> :call octavetui#UnsetBreakpoint()<CR>
    augroup octavetui
        autocmd!
        " refresh tui after open another code file
        autocmd! BufReadPost * if winnr() == s:main_winnr | call s:Update() | endif
    augroup END
endfunction
