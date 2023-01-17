" Title:        Example Plugin
" Description:  A plugin to provide an example for creating Vim plugins.
" Last Change:  8 November 2021
" Maintainer:   Example User <https://github.com/example-user>

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
