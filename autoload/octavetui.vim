let s:plugin_root = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
let s:octave_script_dir = s:plugin_root . '/octave'

let s:octave_executable = g:octavetui_octave_executable
let s:callback_check_interval = g:octavetui_callback_interval
let s:history_num = g:octavetui_history_number

let s:welcome_text_file = s:plugin_root . '/welcome.txt'
let s:enable_welcome_text = g:enable_welcome_text

let s:main_winid = ''
let s:cli_buf_name = 'Octave CLI'
let s:cli_bufnr = ''
let s:cli_winid = ''
let s:vexp_buf_name = 'Variable Explorer'
let s:vexp_bufnr = ''
let s:vexp_winid = ''

let s:tmpfile_history = tempname()
let s:envvar_history = 'OCTAVETUI_HISTORY'
let s:envvar_history_num = 'OCTAVETUI_HISTORY_NUM'
let s:tmpfile_variable = tempname()
let s:envvar_variable = 'OCTAVETUI_VARIABLE'
let s:tmpfile_breakpoint = tempname()
let s:envvar_breakpoint = 'OCTAVETUI_BREAKPOINT'
let s:tmpfile_nextexec = tempname()
let s:envvar_nextexec = 'OCTAVETUI_NEXTEXEC'


let s:highlight_breakpoint_name = 'octavetui_hl_breakpoint'
let s:highlight_breakpoint_color = g:octavetui_breakpoint_hlcolor
call hlset([{'name': s:highlight_breakpoint_name,
            \ 'ctermbg': s:highlight_breakpoint_color,
            \ 'guibg': s:highlight_breakpoint_color,
            \ }])
let s:sign_breakpoint_name = 'octavetui_sign_breakpoint'
let s:sign_breakpoint_group = s:sign_breakpoint_name
let s:sign_breakpoint_hl = s:highlight_breakpoint_name
let s:sign_breakpoint_text = g:octavetui_breakpoint_symbol
let s:sign_breakpoint_priority = g:octavetui_breakpoint_priority
call sign_define(s:sign_breakpoint_name,
            \ {'linehl': s:sign_breakpoint_hl,
            \ 'text': s:sign_breakpoint_text,
            \ 'texthl': 'SignColumn',
            \ })

let s:highlight_nextexec_name = 'octavetui_hl_nextexec'
let s:highlight_nextexec_color = g:octavetui_nextexec_hlcolor
call hlset([{'name': s:highlight_nextexec_name,
            \ 'ctermbg': s:highlight_nextexec_color,
            \ 'guibg': s:highlight_nextexec_color,
            \ }])
let s:sign_nextexec_name = 'octavetui_sign_nextexec'
let s:sign_nextexec_group = s:sign_nextexec_name
let s:sign_nextexec_hl = s:highlight_nextexec_name
let s:sign_nextexec_text = g:octavetui_nextexec_symbol
let s:sign_nextexec_priority = g:octavetui_nextexec_priority
call sign_define(s:sign_nextexec_name,
            \ {'linehl': s:sign_nextexec_hl,
            \ 'text': s:sign_nextexec_text,
            \ 'texthl': 'SignColumn',
            \ })


" ============================================================================
" COMMANDS FOR USERS
" ============================================================================

function! s:SetPluginCommand() abort
    command! OctaveTUIStop call octavetui#StopTUI()

    command! OctaveTUIActivateKeymap call octavetui#SetKeymap()
    command! OctaveTUIDeactivateKeymap call octavetui#DelKeymap()

    command! OctaveTUIRun call octavetui#DBRun(1)
    command! OctaveTUIRunStacked call octavetui#DBRun(0)
    command! OctaveTUISetBreakpoint call octavetui#SetBreakpoint()
    command! OctaveTUIDelBreakpoint call octavetui#DelBreakpoint()
    command! OctaveTUINext call octavetui#DBStep('')
    command! OctaveTUIStepIn call octavetui#DBStep('in')
    command! OctaveTUIStepOut call octavetui#DBStep('out')
    command! OctaveTUIQuit call octavetui#DBQuit('all')
    command! OctaveTUIQuitStacked call octavetui#DBQuit('')
    command! OctaveTUIContinue call octavetui#DBContinue()
endfunction

function! s:DelPluginCommand() abort
    delcommand OctaveTUIStop

    delcommand OctaveTUIActivateKeymap
    delcommand OctaveTUIDeactivateKeymap

    delcommand OctaveTUIRun
    delcommand OctaveTUIRunStacked
    delcommand OctaveTUISetBreakpoint
    delcommand OctaveTUIDelBreakpoint
    delcommand OctaveTUINext
    delcommand OctaveTUIStepIn
    delcommand OctaveTUIStepOut
    delcommand OctaveTUIQuit
    delcommand OctaveTUIQuitStacked
    delcommand OctaveTUIContinue
endfunction


" ============================================================================
" KEYMAPS FOR USERS
" ============================================================================

" set up keymap for current buffer
" TODO: let user customize keymap
function! octavetui#SetKeymap() abort
    nnoremap <buffer> <silent> b :OctaveTUISetBreakpoint<CR>
    nnoremap <buffer> <silent> B :OctaveTUIDelBreakpoint<CR>
    nnoremap <buffer> <silent> n :OctaveTUINext<CR>
    nnoremap <buffer> <silent> s :OctaveTUIStepIn<CR>
    nnoremap <buffer> <silent> S :OctaveTUIStepOut<CR>
    nnoremap <buffer> <silent> r :OctaveTUIRun<CR>
    nnoremap <buffer> <silent> R :OctaveTUIRunStacked<CR>
    nnoremap <buffer> <silent> q :OctaveTUIQuit<CR>
    nnoremap <buffer> <silent> Q :OctaveTUIQuitStacked<CR>
    nnoremap <buffer> <silent> c :OctaveTUIContinue<CR>
endfunction

" unset keymap for current buffer
" TODO: original keymap is lost
function! octavetui#DelKeymap() abort
    silent! nunmap <buffer> b
    silent! nunmap <buffer> B
    silent! nunmap <buffer> n
    silent! nunmap <buffer> s
    silent! nunmap <buffer> S
    silent! nunmap <buffer> r
    silent! nunmap <buffer> R
    silent! nunmap <buffer> q
    silent! nunmap <buffer> Q
    silent! nunmap <buffer> c
endfunction


" ============================================================================
" PUBLIC FUNCTIONS
" ============================================================================

function! octavetui#StartTUI() abort
    call s:Init()
    call octavetui#StartVarExp()
    call octavetui#StartCli()
endfunction

function! octavetui#StopTUI() abort
    call s:Deinit()
    call octavetui#StopVarExp()
    call octavetui#StopCli()
endfunction

function! octavetui#StartCli() abort
    let l:cli_envs = {
                \ s:envvar_history: s:tmpfile_history,
                \ s:envvar_history_num: s:history_num,
                \ s:envvar_variable: s:tmpfile_variable,
                \ s:envvar_breakpoint: s:tmpfile_breakpoint,
                \ s:envvar_nextexec: s:tmpfile_nextexec,
                \ }

    let l:cli_start_options = {
                \ 'env': l:cli_envs,
                \ 'term_kill': 'term',
                \ 'term_name': s:cli_buf_name,
                \ 'term_finish': 'close',
                \ }

    let l:cli_start_cmd = [s:octave_executable, '--path', s:octave_script_dir]

    let s:cli_bufnr = term_start(l:cli_start_cmd, l:cli_start_options)
    let s:cli_winid = win_getid()

    tnoremap <silent><buffer> <CR> <CR><Cmd>call <SID>Update()<CR>
endfunction

function! octavetui#StopCli() abort
    let l:cmd_octave_quit = 'exit'
    call term_sendkeys(s:cli_bufnr, "\<C-E>\<C-U>".l:cmd_octave_quit."\<CR>")
endfunction

function! octavetui#StartVarExp() abort
    let s:vexp_bufnr = bufadd(s:vexp_buf_name)
    call setbufvar(s:vexp_bufnr, '&buftype', 'nofile')
    call bufload(s:vexp_bufnr)
    exec 'botright vertical sbuffer' . s:vexp_bufnr

    setlocal nowrap
    setlocal nolist
    setlocal nonumber
    setlocal norelativenumber
    let s:vexp_winid = win_getid()

    if s:enable_welcome_text
        call s:DisplayWelcomeText()
    endif
endfunction

function! octavetui#StopVarExp() abort
    exec 'bdelete' . s:vexp_bufnr
endfunction

function! octavetui#SetBreakpoint() abort
    let l:octave_filename = expand('%:t')
    let l:line_num = line('.')
    let l:cmd = "octavetui_toggle_breakpoint set '".l:octave_filename."' ".l:line_num
    call term_sendkeys(s:cli_bufnr, "\<C-E>\<C-U>".l:cmd."\<CR>")
    call timer_start(s:callback_check_interval,
                \ function('s:UpdateBreakpoint', []),
                \ {'repeat': -1})
endfunction

function! octavetui#DelBreakpoint() abort
    let l:octave_filename = expand('%:t')
    let l:line_num = line('.')
    let l:cmd = "octavetui_toggle_breakpoint del '".l:octave_filename."' ".l:line_num
    call term_sendkeys(s:cli_bufnr, "\<C-E>\<C-U>".l:cmd."\<CR>")
    call timer_start(s:callback_check_interval,
                \ function('s:UpdateBreakpoint', []),
                \ {'repeat': -1})
endfunction

function! octavetui#Refresh() abort
    call s:Update()
endfunction

function! octavetui#ExecCmd(cmd) abort
    call term_sendkeys(s:cli_bufnr, "\<C-E>\<C-U>".a:cmd."\<CR>")
    call s:Update()
endfunction

function! octavetui#DBQuit(arguments) abort
    let l:cmd = 'dbquit ' . a:arguments
    call octavetui#ExecCmd(l:cmd)
endfunction

function! octavetui#DBRun(quit_before_run) abort
    if a:quit_before_run
        call octavetui#DBQuit('all')
    endif
    let l:main_buf_file = expand('#'.winbufnr(s:main_winid).':p')
    let l:cmd = 'run '.l:main_buf_file
    call octavetui#ExecCmd(l:cmd)
endfunction

function! octavetui#DBStep(arguments) abort
    let l:cmd = 'dbstep ' . a:arguments
    call octavetui#ExecCmd(l:cmd)
endfunction

function! octavetui#DBContinue() abort
    let l:cmd = 'dbcont'
    call octavetui#ExecCmd(l:cmd)
endfunction


" ============================================================================
" PRIVATE FUNCTIONS
" ============================================================================

function! s:Init() abort
    call s:RemoveTmpFile()
    let s:main_winid = win_getid()

    call s:SetPluginCommand()
    call octavetui#SetKeymap()

    augroup octavetui
        autocmd!
        autocmd! BufEnter *.m,*.oct
                    \ if win_getid() == s:main_winid |
                    \ call octavetui#SetKeymap() |
                    \ else |
                    \ call octavetui#DelKeymap() |
                    \ endif
        autocmd! TabEnter *
                    \ if win_getid() == s:main_winid |
                    \ call octavetui#SetKeymap() |
                    \ else |
                    \ call octavetui#DelKeymap() |
                    \ endif
    augroup END
endfunction

function! s:Deinit() abort
    augroup octavetui
        autocmd!
    augroup END

    call win_gotoid(s:main_winid)
    call octavetui#DelKeymap()
    call s:DelPluginCommand()

    call sign_unplace(s:sign_nextexec_group)
    call sign_unplace(s:sign_breakpoint_group)
endfunction

function! s:Update() abort
    call s:RemoveTmpFile()

    let cmd = 'run octavetui_update'
    call term_sendkeys(s:cli_bufnr, cmd . "\<CR>")

    call timer_start(s:callback_check_interval,
                \ function('s:UpdateVarExp', []),
                \ {'repeat': -1})

    call timer_start(s:callback_check_interval,
                \ function('s:UpdateBreakpoint', []),
                \ {'repeat': -1})

    call timer_start(s:callback_check_interval,
                \ function('s:UpdateNextexec', []),
                \ {'repeat': -1})
endfunction

function! s:RemoveTmpFile() abort
    call delete(s:tmpfile_variable)
    call delete(s:tmpfile_breakpoint)
    call delete(s:tmpfile_nextexec)
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
        if has('win32')
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
        else
            " on linux or other system with lsof command
            let l:cmd = 'lsof ' . a:filename
            silent call system(l:cmd)
            " if the file is opened in other processes
            if v:shell_error == 0
                return v:false
            else
                return v:true
            endif
        endif
    endif
endfunction

" TODO
" clear all the old drawn breakpoints first, then update and redraw all breakpoints
" this might be slow if there are too many breakpoints
function! s:UpdateBreakpoint(timerid) abort
    if s:FileIsFree(s:tmpfile_breakpoint)
        call timer_stop(a:timerid)

        call sign_unplace(s:sign_breakpoint_group,
                    \ {'buffer':winbufnr(s:main_winid)})

        let l:breakpoint_list = readfile(s:tmpfile_breakpoint)
        let l:main_buf_file = expand('#'.winbufnr(s:main_winid).':p')
        let l:sign_list = []
        for l:bp in l:breakpoint_list
            let l:info = split(l:bp, '\t')
            let l:bp_name = l:info[0]
            let l:bp_file = l:info[1]
            let l:bp_line = str2nr(l:info[2])
            let l:bp_cond = l:info[3]

            if l:bp_file == l:main_buf_file
                let l:sign_dict = {
                            \ 'group': s:sign_breakpoint_group,
                            \ 'id': l:bp_line,
                            \ 'name': s:sign_breakpoint_name,
                            \ 'buffer': l:bp_file,
                            \ 'lnum': l:bp_line,
                            \ 'priority': s:sign_breakpoint_priority,
                            \ }
                call add(l:sign_list, l:sign_dict)
            endif
        endfor
        call sign_placelist(l:sign_list)

        call delete(s:tmpfile_breakpoint)
    endif
endfunction

function! s:UpdateNextexec(timerid) abort
    if s:FileIsFree(s:tmpfile_nextexec)
        call timer_stop(a:timerid)

        call sign_unplace(s:sign_nextexec_group)

        let l:main_buf_file = expand('#'.winbufnr(s:main_winid).':p')
        let l:nextexec = readfile(s:tmpfile_nextexec)
        if len(l:nextexec) == 1
            let l:info = split(l:nextexec[0], '\t')
            if len(l:info) == 2
                let l:old_winid = win_getid()
                " jump to code file and code line
                let l:codeline = l:info[0]
                let l:codefile = l:info[1]
                call win_gotoid(s:main_winid)
                " change buffer file in the code window
                if l:main_buf_file != l:codefile
                    exec 'e +' . l:codeline . ' ' . l:codefile
                else
                    exec l:codeline
                endif
                " center the code line
                normal! zz
                call win_gotoid(l:old_winid)

                let l:sign_dict = {
                            \ 'group': s:sign_nextexec_group,
                            \ 'id': l:codeline,
                            \ 'name': s:sign_nextexec_name,
                            \ 'buffer': l:codefile,
                            \ 'lnum': l:codeline,
                            \ 'priority': s:sign_nextexec_priority,
                            \ }
                call sign_placelist([l:sign_dict])
            endif
        endif
        call delete(s:tmpfile_nextexec)
    endif
endfunction

function! s:DisplayWelcomeText() abort
        let l:welcome_text = readfile(s:welcome_text_file)

        let l:vexp_height = winheight(s:vexp_bufnr)
        let l:padding_vertical = repeat([''], l:vexp_height/2)
        call setbufline(s:vexp_bufnr, 1,
                    \ l:padding_vertical
                    \ + l:welcome_text
                    \ + l:padding_vertical
                    \ )

        let l:init_line = len(l:welcome_text)/2 + l:vexp_height/2
        exec ':' . l:init_line
        normal! zz
endfunction
