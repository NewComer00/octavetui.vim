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
    let s:default_octave_executable = 'octave.bat'
else
    let s:default_octave_executable = 'octave'
endif
let g:octavetui_octave_path= get(g:, 'octavetui_octave_path', s:default_octave_executable)

command! StartAll call octavetui#StartAll()
command! RefreshAll call octavetui#RefreshAll()
