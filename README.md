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

## Installation
You can use any conventional plugin manager for Vim, such as [vim-plug](https://github.com/junegunn/vim-plug):
```vim
Plug 'NewComer00/octavetui.vim', {'branch': 'main'}
```
**🟨 IMPORTANT:** The GNU Octave package provided by `snap` [does not](https://askubuntu.com/questions/1238211/how-to-make-snaps-access-hidden-files-and-folders-in-home) have access to the hidden files and dirs placed in `$HOME` directory (for example, `~/.vim/`). This plugin will not work normally if its installation path is not accessible to Octave. To solve this problem, you can specify a different Vim plugin installation path, or you can reinstall the GNU Octave package by another package manager like `apt`.


## Features
- [x] Variable explorer
- [x] Octave command line interface
- [X] Variable watch list
- [x] Visualizing the breakpoints and the program counter
- [x] Debugging directly from the code buffer using hotkeys
- [ ] Allowing users to customize their debugger hotkeys
- [ ] More ...

## Usage
You need to open an Octave `.m` script with Vim, then type the command below to start the TUI.
```vim
:OctaveTUIStart
```
Also, you can start the TUI with arguments which will be delivered to the Octave executable.
```vim
" on Windows, please use double quotes to deal with space characters
:OctaveTUIStart -q --image-path "D:\My Pictures"
```

Once the TUI is started, the current Vim tab will be divided into three windows -- the **code buffer** window, the **variable explorer** window and the **Octave CLI** window.

**NOTE:** The TUI only takes control of the **current tab**. You can create a new tab with command `:tabnew` to edit other files.

If you need to exit the TUI, please type the command below.
```vim
:OctaveTUIStop
```

## Commands & Hotkeys
### Debugger-related (For Code Buffer)
All the listed normal-mode-keymaps only take effect in the **code buffer**. You can manually disable them using command `:OctaveTUIDeactivateKeymap` and re-enable them using command `:OctaveTUIActivateKeymap`.

Command                   | Hotkey  | Description 
--------------------------|---------|-------------
`:OctaveTUISetBreakpoint` | `b`     | Set a breakpoint on or near the current line.
`:OctaveTUIDelBreakpoint` | `B`     | Delete the breakpoint on or near the current line.
`:OctaveTUINext`          | `n`     | Step over the next code line.
`:OctaveTUIStepIn`        | `s`     | Step into the next code line.
`:OctaveTUIStepOut`       | `S`     | Step out of the current function or script.
`:OctaveTUIContinue`      | `c`     | Continue the code execution until it meets the next breakpoint.
`:OctaveTUIRun`           | `r`     | Quit all existing debugging sessions; clear variables; then run the script in the code buffer.
`:OctaveTUIRunStacked`    | `R`     | Run the script in the code buffer on top of the current debugging session. **Only for Octave >= 6**.
`:OctaveTUIQuit`          | `q`     | Quit all existing debugging sessions.
`:OctaveTUIQuitStacked`   | `Q`     | Quit the current debugging session. **Only for Octave >= 6**.

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
