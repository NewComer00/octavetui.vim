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

- Suggested Octave version: GNU Octave >= 6
- [x] Support for Vim >= 8.2
- [ ] Support for Neovim

---

![Plugin Screenshot](https://user-images.githubusercontent.com/37762193/221892507-989a53a8-d3e5-444d-8045-6340154110d2.png)

---

## Installation
You can use any conventional plugin manager for Vim, such as [vim-plug](https://github.com/junegunn/vim-plug):
```vim
Plug 'NewComer00/octavetui.vim', {'branch': 'main'}
```

This plugin can also be lazily loaded.
```vim
Plug 'NewComer00/octavetui.vim', {'branch': 'main', 'on': 'OctaveTUIStart'}
```

**🟨 IMPORTANT:** The GNU Octave package provided by `snap` [does not](https://askubuntu.com/questions/1238211/how-to-make-snaps-access-hidden-files-and-folders-in-home) have access to the hidden files and dirs placed in `$HOME` directory (for example, `~/.vim/`). This plugin will not work normally if its installation path is not accessible to Octave. To solve this problem, you can specify a different Vim plugin installation path, or you can reinstall the GNU Octave package by another package manager like `apt`.

## Features
- [x] Variable explorer
- [x] Octave command line interface
- [x] Variable watch list
- [x] Visualizing the breakpoints and the program counter
- [x] Debugging directly from the code buffer using hotkeys
- [x] Allowing users to customize their debugger hotkeys
- [ ] More ...

## Known Bugs
Currently this Vim plugin communicates with Octave CLI in a very simple way. The plugin sends command strings to the terminal buffer where Octave CLI is running, and Octave CLI writes the output to some temp files which are then read and parsed by Vim. Communications between this plugin and Octave CLI are asynchronous.

The known bugs are listed below:
1. **Commands across multiple lines cannot be run directly in the Octave CLI buffer.** Once you press `<CR>` in the Octave CLI buffer, a command to update the TUI will be sent to Octave CLI automatically.
2. **On Windows, the display of some variables or breakpoints might disappears rarely.** Try `:OctaveTUIRefresh` command to refresh the TUI. 

## Usage
You need to open an Octave `.m` script with Vim, then type the command below to start the TUI.
```vim
:OctaveTUIStart
```
Also, you can start the TUI with arguments which will be delivered to the Octave executable.
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
You can specify the GNU Octave executable used by this plugin. The default configuration is
```vim
" on Windows
let g:octavetui_octave_executable = 'octave.bat'

" on the other platforms
let g:octavetui_octave_executable = 'octave-cli'
```

Modify this value in your Vim config if you have the GNU Octave executable installed in a different place. For example:
```vim
" on Windows
let g:octavetui_octave_executable = 'C:\Program Files\GNU Octave\Octave-7.3.0\mingw64\bin\octave.bat'

" on the other platforms
let g:octavetui_octave_executable = '/usr/bin/octave-cli'
```

### Keymaps
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

## Tips
### Customizing the prompt of the Octave CLI
Please refer to this [documentation](https://docs.octave.org/latest/Customizing-the-Prompt.html). For example, you can create a personal config file `~/.octaverc` and place the following command in it:
```
% using ANSI escape sequences for a colorful prompt
PS1('\[\033[01;31m\]octave:\#> \[\033[0m\]');
```
Now open the Octave CLI application (or start this plugin in Vim). You will get the prompt displayed in **red**.

**NOTE:** ANSI escape sequences are supported by `windows cmd` on Windows 10 and above, but you need to manually enable it. Run `regedit`; go to the path `HKEY_CURRENT_USER\Console` and create a DWORD item named `VirtualTerminalLevel` with the value of `1`. Now your `windows cmd` should be able to display the colored text. [Ref. 1](https://learn.microsoft.com/en-us/windows/console/console-virtual-terminal-sequences) [Ref. 2](https://ss64.com/nt/syntax-ansi.html)

## About
The ASCII art letters are generated on the website http://patorjk.com/software/taag/ .
