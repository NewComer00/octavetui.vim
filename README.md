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
- [X] Display the values of variables
- [X] Variable watch list
- [x] Octave command line interface
- [x] Visualizing the breakpoints and the program counter
- [x] Debugging directly from the code buffer using hotkeys
- [ ] Allowing users to customize their debugger hotkeys
- [ ] More ...

## Usage
Frist, open an Octave code file with Vim. Then type the command below to start the TUI.
```vim
:OctaveTUIStart
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

Commands                  | Hotkeys
--------------------------|--------
`:OctaveTUISetBreakpoint` | `b`
`:OctaveTUIDelBreakpoint` | `B`
`:OctaveTUINext`          | `n`
`:OctaveTUIStepIn`        | `s`
`:OctaveTUIStepOut`       | `S`
`:OctaveTUIRun`           | `r`
`:OctaveTUIRunStacked`    | `R`
`:OctaveTUIQuit`          | `q`
`:OctaveTUIQuitStacked`   | `Q`
`:OctaveTUIContinue`      | `c`

### Variable Explorer
All the listed normal-mode-keymaps only take effect in the **variable explorer**.

Commands                    | Hotkeys
----------------------------|--------
`:OctaveTUIAddToWatch`      | `p`
`:OctaveTUIRemoveFromWatch` | `P`

## Tips
### Customizing the prompt of the Octave CLI
Please refer to this [documentation](https://docs.octave.org/latest/Customizing-the-Prompt.html). For example, you can create a personal config file `~/.octaverc` and place the following command in it:
```
% using ANSI escape sequences for the colorful prompt
PS1('\[\033[01;31m\]octave:\#> \[\033[0m\]');
```
Now open the Octave CLI application (or start this plugin in Vim). You will get the prompt displayed in **red**.

**NOTE:** ANSI escape sequences are supported by `windows cmd` on Windows 10 and above, but you need to manually enable it. Run `regedit`; go to the path `HKEY_CURRENT_USER\Console` and create a DWORD item named `VirtualTerminalLevel` with the value of `1`. Now your `windows cmd` should be able to display the colored text. [Ref. 1](https://learn.microsoft.com/en-us/windows/console/console-virtual-terminal-sequences) [Ref. 2](https://ss64.com/nt/syntax-ansi.html)

## About
The ASCII art letters are generated on the website http://patorjk.com/software/taag/ .
