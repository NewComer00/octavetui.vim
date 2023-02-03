# octavetui.vim [ ⚒Under Development ... ]
This plugin is aimed to provide a text-based user interfaces (TUI) for GNU Octave.

- [x] Support for Vim
- [ ] Support for Neovim

## Installation
You can use any conventional plugin manager for Vim, such as [vim-plug](https://github.com/junegunn/vim-plug):
```vim
Plug 'NewComer00/octavetui.vim', {'branch': 'main'}
```

## Features
- [x] Variable explorer
- [ ] Display the values of variables
- [x] Octave command line interface
- [x] Visualizing the breakpoints and the program counter
- [x] Debugging directly from the code buffer using hotkeys
- [ ] Allowing users to customize their debugger hotkeys

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

## Debugger Commands & Hotkeys
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
