<div align="center">

# OneStop.nvim

[![License](https://img.shields.io/badge/License-GPLv3-blue)](#license)
[![issues - OneStop.nvim](https://img.shields.io/github/issues/charlie39/OneStop.nvim)](https://github.com/charlie39/OneStop.nvim/issues)

</div>

## Synopsis


This plugin is an attempt to provide an easier way to configure running various

build and compile commands that you may require for your various project development.

The goal is to  the _pain_ in having to configure each external commands that

one may require in their project[s].

## Requirements

* nvim +0.8
* LSP client


## Problems

1. Do you find yourself configuring separate keymappings to run ```npm``` commands for ```node```
   projects ? ```maven``` commands for your ```maven``` projects? ```make``` commands for your
   ```Make``` based projects? ```cargo``` commands for ```rust``` projects?
   ```go``` commands for ```golang``` projects? ( .. and so on )

2. Do you wish for an easier way to configure to run your commands in a split terminal buffer ?
   vsplit terminal buffer ? floating window ? or even in an external terminal emulator window?

## One Stop solution

This plugin takes care of that.
Just install the plugin and do a basic configuration.


## Demos
* Running command in external terminal:

![external-terminal](https://user-images.githubusercontent.com/13074369/185806273-e5d56b4b-0ad2-4b99-83a6-1f03fb8deac0.gif)

* Running command in floating window , split and vsplit term buffer:

[![asciicast](https://asciinema.org/a/516276.svg)](https://asciinema.org/a/516276)

## Installation

* packer

```
use { 'charlie39/OneStop.nvim', branch = 'main' }
```
this plugin depends on language server clients to find your project root as well
as club your commands. So you need to configure the commands based on under
which language server client you would use them. The assigned commands would be
available only under the given LSP client.


## Configuration

```lua
require'onestop'.setup {

    --[[ For running commands in an external terminal window, assign a table
    to this key.First item should be your terminal emulator and second item
    should be the emulator option for launching a command
    e.g. if you use suckless terminal]]
    terminal = {'st','-e' },

    --[[configure the layout for the floating window as per your screen ( if the default is not good for you)]]
    layout = {
        style = 'minimal',
        relative = 'editor',
        heigth = 40,
        width = 120,
        border = { "⌜", "-", "⌝", "|", "⌟", "_", "⌞", "|" }
    },

    --[[ this plugin depends on LSP clients to find the  project root_dir as well as
    club your commands, when a particular LSP client is attached only the
    commands assigned to them would be available.]]
    lscmds = {
        ['jdt.ls'] = {
            "mvn run",
            "mvn build",
            "mvn compile",
            "mvn spring-boot:run",
            "mvn package",
            "java -jar",
        },
        rust_analyzer = {
            "cargo build",
            "cargo run",
        },
        sumneko_lua = {
            "lua",
        }
        ...

    },
    --[[the only default keymap, this for toggling the floating window ]]
    map = {
        ['<M-i>'] = 'toggle_float',
    },
}

```

the setup function provides the command ```OSRunner```. This comamand by default
launches the commands in the configured terminal [ The default is st, so if you
don't have st installed you must set the terminal to one that is available].
OSRunner takes three subcommands:

- float = launches the command in a float term buffer
- sp[lit] = launches the command in a split term buffer
- vs[plit] = launches the command in vsplit term buffer
- external = launches the command in the configured  external terminal

you can map these to your custom key binds.
e.g:

```
 vim.keymap.set('n','<leader>C', '<cmd>OSRunner external<cr>',{noremap = true})
 vim.keymap.set('n','<leader>of', '<cmd>OSRunner float<cr>',{ noremap = true})
 vim.keymap.set('n','<leader>ov', '<cmd>OSRunner vsplit<cr>',{ noremap = true})
 vim.keymap.set('n','<leader>os', '<cmd>OSRunner split<cr>',{ noremap = true})

```

## Features

* run [preconfigured] commands in a floating window with toggle support
* run [preconfigured] commands in a split terminal buffer
* run [preconfigured] commands in a vsplit terminal buffer
* run [preconfigured] commands in an external terminal window

## TODO

* add support for tmux panes
* collect as many build tools specific commands [ and other commands related to
development ]

## NOTE

This is a tiny project that i started after comming across a few posts on reddit about how to configure running external commands.
This is in pre pre [yeah two times] alpha stage. Not much testing has been done.
The recommended plugin manager is packer as cited above or the manual way with
git.

```sh
git clone https://github.com/charlie39/OneShot.nvim
~/.local/share/nvim/site/pack/packer/start/ [adjust according to your plugin.path]
```
If you have problem installing with other plugin manager, feel free to open an issue.

## Contribution

maintaining a repository of build tool/package manager commands would be a challenge for
me as i won't be able to test for all of them. Hence  commnunity
contributions, PRs that add new commands are welcome.



## License

Released under [GPLv3](/LICENSE) by [@charlie39](https://github.com/charlie39).
