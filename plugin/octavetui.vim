" Title:        octavetui.vim
" Description:  This plugin is aimed to provide a text-based user interfaces
"               (TUI) for GNU Octave.
" Last Change:  25 JAN 2023
" Maintainer:   NewComer00 <https://github.com/NewComer00>

if exists('g:loaded_octavetui')
    finish
endif
let g:loaded_octavetui = 1

if has('win32')
    let g:octavetui_octave_executable = get(g:, 'octavetui_octave_executable', 'octave.bat')
else
    let g:octavetui_octave_executable = get(g:, 'octavetui_octave_executable', 'octave')
endif
let g:octavetui_callback_interval = get(g:, 'octavetui_callback_interval', 50)
let g:octavetui_history_number = get(g:, 'octavetui_history_number', 20)

let g:octavetui_breakpoint_symbol = get(g:, 'octavetui_breakpoint_symbol', '🔴')
let g:octavetui_breakpoint_hlcolor = get(g:, 'octavetui_breakpoint_hlcolor', 'darkblue')
let g:octavetui_breakpoint_priority = get(g:, 'octavetui_breakpoint_priority', 100)

let g:octavetui_nextexec_symbol = get(g:, 'octavetui_nextexec_symbol', '⏩')
let g:octavetui_nextexec_hlcolor = get(g:, 'octavetui_nextexec_hlcolor', 'darkgreen')
let g:octavetui_nextexec_priority = get(g:, 'octavetui_nextexec_priority', 101)


command! OctaveTUIStart call octavetui#StartTUI()
command! OctaveTUIStop call octavetui#StopTUI()
