# octavetui.vim [ ⚒Under Development ... ]
```
     _──,_           ___     _                     _____        _____
   _//¯¯|_|         /___\___| |_ __ ___   _____   /__   \/\ /\  \_   \
  |_|  \─┴┐─┐      //  // __| __/ _` \ \ / / _ \    / /\/ / \ \  / /\/
    \\ _`\\||     / \_/| (__| || (_| |\ V |  __/   / /  \ \_/ /\/ /_
     -|_|´\\|     \___/ \___|\__\__,_| \_/ \___|   \/    \___/\____/
           ¯´
```

This plugin is aimed to provide a text-based user interfaces (TUI) for GNU Octave.

- Required editor version: `Vim >= 8.2` or `Neovim >= 0.3`
- Recommended Octave version: `GNU Octave >= 8.2` with [better support for UTF-8 encoding ](https://octave.org/news/release/2023/04/13/octave-8.2.0-released.html)
- Required Octave version: `GNU Octave >= 5`

---

![Plugin Screenshot](https://user-images.githubusercontent.com/37762193/224270959-b5920ef1-a46f-4bcf-a2b8-da2d563049b6.png)

---

## Recommended Environments
### Windows

<details>
  <summary>details</summary>

- Windows native [gVim](https://www.vim.org/download.php#pc) or native [Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim#windows)
- Windows native [GNU Octave](https://octave.org/download#ms-windows) (built with MSYS2 in MINGW64 environment)

**NOTE:** Currently, it is not supported by this plugin that using the Vim from Cygwin/Git Bash/MSYS/MSYS2 (where `:echo has('win32unix')` returns `1`) together with the Windows native GNU Octave. If you'd like to use the Vim from Cygwin, a pure [Cygwin environment](#cygwin-posix-environment-on-windows) could be one of your choices.

</details>

### Cygwin (POSIX Environment on Windows)

<details>
  <summary>details</summary>

- Cygwin package [Vim](https://cygwin.com/packages/summary/vim.html)
- Cygwin package [GNU Octave](https://cygwin.com/packages/summary/octave.html)
- `fuser` command is required for this plugin on Cygwin. You can get it from Cygwin package [psmisc](https://cygwin.com/packages/summary/psmisc.html).

</details>

### Unix-like OS

<details>
  <summary>details</summary>

- Vim package or Neovim package
- GNU Octave package
- `lsof` or `fuser` command is required for this plugin on Unix-like OS.

**NOTE:** The GNU Octave package provided by `snap` [does not](https://askubuntu.com/questions/1238211/how-to-make-snaps-access-hidden-files-and-folders-in-home) have access to the hidden files and dirs placed in `$HOME` directory (for example, `~/.vim/`). This plugin will not work normally if its installation path is not accessible to Octave. To solve this problem, you can specify a different Vim plugin installation path, or you can reinstall the GNU Octave package by another package manager like `apt`.

</details>

## Installation
You can use any conventional plugin manager for Vim, such as [vim-plug](https://github.com/junegunn/vim-plug):
```vim
Plug 'NewComer00/octavetui.vim', {'branch': 'main'}
```

This plugin can also be lazily loaded.
```vim
Plug 'NewComer00/octavetui.vim', {'branch': 'main', 'on': 'OctaveTUIStart'}
```

## Features
- [x] Variable explorer & Variable watch list
- [x] Octave command line interface
- [x] Visualized breakpoints & Program Counter
- [x] Hotkeys for debugger
- [ ] More ...

## Known Bugs
Currently this Vim plugin communicates with Octave CLI in a very simple way. The plugin sends command strings to the terminal buffer where Octave CLI is running, and Octave CLI writes the output to some temp files which are then read and parsed by Vim. Communications between this plugin and Octave CLI are asynchronous.

The known bugs are listed below:
1. **[FIXED]** On Windows, the display of some variables or breakpoints might disappears rarely. Try `:OctaveTUIRefresh` command to refresh the TUI. 
2. **Commands across multiple lines cannot be run directly in the Octave CLI buffer.** Once you press `<CR>` in the Octave CLI buffer, a command to update the TUI will be sent to Octave CLI automatically.
3. In the **debugging mode** of the Octave CLI (where the prompt displays `debug> `), **pressing `<CR>` with an empty command line** will cause a TUI-update instead of repeating the last debugging command. Besides, **the last command line history will be eaten up** after pressing `<CR>` with an empty command line in the debugging-mode CLI, which is an undesired behavior.

## Usage
After the installation of this plugin, please assign the location of your Octave CLI executable to the variable [`g:octavetui_octave_executable`](#octave-executable) in your Vim config. For example:
```vim
if has('win32')
    let g:octavetui_octave_executable = 'C:\Program Files\GNU Octave\Octave-7.3.0\mingw64\bin\octave.bat'
else
    let g:octavetui_octave_executable = '/usr/bin/octave-cli'
endif
```
After the config takes effect, you can open an Octave `.m` script with Vim, then type the command below to start the TUI.
```vim
:OctaveTUIStart
```
Besides, you can also start the TUI with arguments which will be delivered to the Octave executable.
```vim
" please use the double quotes to deal with whitespace characters
:OctaveTUIStart -q --image-path "D:\My Pictures"
```

Once the TUI is started, the current Vim tab will be divided into three windows -- the **code buffer** window, the **variable explorer** window and the **Octave CLI** window.

**NOTE:** The TUI only takes control of the **current tab**. You can create a new tab with command `:tabnew` to edit other files.

If you need to exit the TUI, please type the command below.
```vim
:OctaveTUIStop
```

## Commands & Hotkeys
Here we introduce the commands of this plugin and their default keymaps. You can customize those keymaps in your [configuration](#keymaps).

### Debugger-related (For Code Buffer)
All the listed normal-mode-keymaps only take effect in the **code buffer**. You can manually disable them using command `:OctaveTUIDeactivateKeymap` and re-enable them using command `:OctaveTUIActivateKeymap`.

Command                   | Hotkey  | Description 
--------------------------|---------|-------------
`:OctaveTUISetBreakpoint` | `[N]b`  | Set a breakpoint on or near the `N`th line. If `N` is omitted, set the breakpoint on or near the current line.
`:OctaveTUIDelBreakpoint` | `[N]B`  | Delete the breakpoint on or near the `N`th line. If `N` is omitted, delete the breakpoint on or near the current line.
`:OctaveTUIRun`           | `r`     | Quit all existing debugging sessions; clear variables; then run the script in the code buffer.
`:OctaveTUIRunStacked`    | `R`     | Run the script in the code buffer on top of the current debugging session. **Only for Octave >= 6**.
`:OctaveTUIQuit`          | `q`     | Quit all existing debugging sessions.
`:OctaveTUIQuitStacked`   | `Q`     | Quit the current debugging session. **Only for Octave >= 6**.
`:OctaveTUINext`          | `[N]n`  | Execute the next `N` lines of code. If `N` is omitted, execute the next single line of code.
`:OctaveTUIStepIn`        | `s`     | Step into the next code line.
`:OctaveTUIStepOut`       | `S`     | Step out of the current function or script.
`:OctaveTUIContinue`      | `c`     | Continue the code execution until it meets the next breakpoint.
`:OctaveTUIGoToLastError` | `E`     | Jump to the code line where the last error occurred.

### Variable Explorer
All the listed normal-mode-keymaps only take effect in the **variable explorer**.

Command                     | Hotkey  | Description 
----------------------------|---------|-------------
`:OctaveTUIAddToWatch`      | `p`     | Pin the variable of the current line to the top of the variable explorer.
`:OctaveTUIRemoveFromWatch` | `P`     | Unpin the variable of the current line from the top of the variable explorer.

## Configuration
### Octave Executable

<details>
  <summary>details</summary>

You can specify the GNU Octave executable used by this plugin. The default configuration is
```vim
if has('win32')
    let g:octavetui_octave_executable = 'octave.bat'
else
    let g:octavetui_octave_executable = 'octave-cli'
endif
```

Modify this value in your Vim config if you have the GNU Octave executable installed in a different place. For example:
```vim
if has('win32')
    let g:octavetui_octave_executable = 'C:\Program Files\GNU Octave\Octave-7.3.0\mingw64\bin\octave.bat'
else
    let g:octavetui_octave_executable = '/usr/bin/octave-cli'
endif
```

</details>

### Keymaps

<details>
  <summary>details</summary>

A global dictionary `g:octavetui_user_keymaps` is used to record the user's keymaps. The default keymaps are listed below.
```vim
let g:octavetui_user_keymaps = {
            \ 'OctaveTUISetBreakpoint':     'b',
            \ 'OctaveTUIDelBreakpoint':     'B',
            \ 'OctaveTUINext':              'n',
            \ 'OctaveTUIStepIn':            's',
            \ 'OctaveTUIStepOut':           'S',
            \ 'OctaveTUIRun':               'r',
            \ 'OctaveTUIRunStacked':        'R',
            \ 'OctaveTUIQuit':              'q',
            \ 'OctaveTUIQuitStacked':       'Q',
            \ 'OctaveTUIContinue':          'c',
            \ 'OctaveTUIAddToWatch':        'p',
            \ 'OctaveTUIRemoveFromWatch':   'P',
            \ 'OctaveTUIGoToLastError':     'E',
            \ }
```

You can customize some of them (or all of them) if you want. Also, you can assign an empty key string `''` to the command which you don't want to map at all. The rest commands are bound to the default keymaps.

**NOTE:** Please specify some **unused** keys for this plugin. For example, the original keymap for `<F5>` will be overwritten or removed if I apply the following configuration.
```vim
let g:octavetui_user_keymaps = {
            \ 'OctaveTUISetBreakpoint':     '<F12>',
            \ 'OctaveTUIDelBreakpoint':     '<Leader><F12>',
            \ 'OctaveTUINext':              '<F10>',
            \ 'OctaveTUIStepIn':            '<F11>',
            \ 'OctaveTUIStepOut':           '<Leader><F11>',
            \ 'OctaveTUIRun':               '<F5>',
            \ 'OctaveTUIRunStacked':        '',
            \ 'OctaveTUIQuit':              '<Leader><F5>',
            \ 'OctaveTUIQuitStacked':       '',
            \ 'OctaveTUIContinue':          '<Leader>c',
            \ 'OctaveTUIGoToLastError':     '<Leader>e',
            \ }
```

</details>

### Highlight Groups & Signs

<details>
  <summary>details</summary>

Default configuration:
```vim
" the style of the code line where a breakpoint is placed
let g:octavetui_breakpoint_symbol = '🔴'
let g:octavetui_breakpoint_hlcolor = 'darkblue'
" please refer to :h sign-priority
let g:octavetui_breakpoint_priority = 100

" the style of the code line to be executed next
let g:octavetui_nextexec_symbol = '⏩'
let g:octavetui_nextexec_hlcolor = 'darkgreen'
let g:octavetui_nextexec_priority = 101

" the style of lines in the watchlist
let g:octavetui_watch_symbol = '📌'
let g:octavetui_watch_priority = 100
```

The customized configuration. For example:
```vim
let g:octavetui_breakpoint_hlcolor = 'DarkRed'
let g:octavetui_breakpoint_symbol = 'B'
let g:octavetui_nextexec_symbol = '->'
let g:octavetui_watch_symbol = 'W'
```
**NOTE:** The names of highlight colors can be found in `:h cterm-colors`. For a better color display, you can add `set termguicolors` to your Vim config if your terminal emulator supports [TrueColor](https://github.com/termstandard/colors#truecolor-support-in-output-devices).

</details>

### Variable Explorer Configs

<details>
  <summary>details</summary>

Default configuration:
```vim
" display the value of each element in VAR only if numel(VAR) <= 20
let g:octavetui_max_displayed_numel = 20

" display the value using 4 digits of precision (trailing zeros are not displayed)
let g:octavetui_max_displayed_precision = 4

" enable the startup logo in the variable explorer window
let g:octavetui_enable_welcome_text = 1
```

The customized configuration. For example:
```vim
let g:octavetui_max_displayed_numel = 30
let g:octavetui_max_displayed_precision = 2

" do not show the logo on the plugin's startup
let g:octavetui_enable_welcome_text = 0
```

</details>

## Tips
### Customizing the prompt of the Octave CLI
Please refer to this [documentation](https://docs.octave.org/latest/Customizing-the-Prompt.html). For example, you can add the following lines in your Octave config `~/.octaverc`. Then open the Octave CLI application (or start this plugin in Vim). You will get the prompt displayed in **red**.

```
% use ANSI escape sequences for a colorful prompt
PS1('\[\033[01;31m\]octave:\#> \[\033[0m\]');
```

**NOTE:** ANSI escape sequences are supported by `windows cmd` on Windows 10 and above, but you need to manually enable it. Run `regedit`; go to the path `HKEY_CURRENT_USER\Console` and create a DWORD item named `VirtualTerminalLevel` with the value of `1`. Now your `windows cmd` should be able to display the colored text. [Ref. 1](https://learn.microsoft.com/en-us/windows/console/console-virtual-terminal-sequences) [Ref. 2](https://ss64.com/nt/syntax-ansi.html)

## About
The ASCII art letters are generated on the website http://patorjk.com/software/taag/ .
