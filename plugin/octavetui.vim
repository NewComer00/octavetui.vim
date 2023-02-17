" Title:        octavetui.vim
" Description:  This plugin is aimed to provide a text-based user interfaces
"               (TUI) for GNU Octave.
" Maintainer:   NewComer00 <https://github.com/NewComer00>

if exists('g:loaded_octavetui')
    finish
endif
if v:version < 801
    echoerr "OctaveTUI: this plugin requires vim >= 8.1.2269"
    finish
endif
if (v:version == 801 && !has('patch-8.1.2269'))
    echoerr "OctaveTUI: this plugin requires vim >= 8.1.2269"
    finish
endif
let g:loaded_octavetui = 1

if has('win32')
    let g:octavetui_octave_executable = get(g:, 'octavetui_octave_executable', 'octave.bat')
else
    let g:octavetui_octave_executable = get(g:, 'octavetui_octave_executable', 'octave-cli')
endif
let g:octavetui_callback_interval = get(g:, 'octavetui_callback_interval', 100)
let g:octavetui_history_number = get(g:, 'octavetui_history_number', 20)
let g:octavetui_max_displayed_numel = get(g:, 'octavetui_max_displayed_numel', 20)
let g:octavetui_max_displayed_precision = get(g:, 'octavetui_max_displayed_precision', 4)
let g:octavetui_enable_welcome_text = get(g:, 'octavetui_enable_welcome_text', 1)

let g:octavetui_breakpoint_symbol = get(g:, 'octavetui_breakpoint_symbol', '🔴')
let g:octavetui_breakpoint_hlcolor = get(g:, 'octavetui_breakpoint_hlcolor', 'darkblue')
let g:octavetui_breakpoint_priority = get(g:, 'octavetui_breakpoint_priority', 100)

let g:octavetui_nextexec_symbol = get(g:, 'octavetui_nextexec_symbol', '⏩')
let g:octavetui_nextexec_hlcolor = get(g:, 'octavetui_nextexec_hlcolor', 'darkgreen')
let g:octavetui_nextexec_priority = get(g:, 'octavetui_nextexec_priority', 101)

let g:octavetui_watch_symbol = get(g:, 'octavetui_watch_symbol', '📌')
let g:octavetui_watch_priority = get(g:, 'octavetui_watch_priority', 100)

command! OctaveTUIStart call octavetui#StartTUI()
