# rg.vim

This vim plugin is a front-end for [ripgrep(rg)](https://github.com/BurntSushi/ripgrep).

## Requirements

This plugin requires the follows.
* [ripgrep](https://github.com/BurntSushi/ripgrep).

## Installation

In case of using plugin manager,  
Specify `okayson/rg.vim` in the usual way!

In case of manual install,  
clone `rg.vim` in anywhere you want to locate and  set runtimepath to it in your `.vimrc`.
```sh
set runtimepath+=/path/to/located/rg.vim/
```

## Usage

Basically, you can use typing as follows.
```sh
Rg [options] {pattern} [{directory|file}]
```
After the `[option]` field, you can specify the arguments that can be specified in ripgrep. See ripgrep's help (`$ rg --help`).  
If you are interested in this plugin, see [doc/rg.txt](doc/rg.txt) for more information about  `Configurations`, `Interfaces` and so on.

<!--
vim:tw=78:sw=4:sts=4:ts=4:et
-->
