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
Rg[!] [options] {pattern} [{directory|file}]
```
See [doc/rg.txt](doc/rg.txt) for more information.

## Configuration

Default configuration is as follows.

```vim
let g:rg_config = {
    \ 'command': 'rg',
    \ 'options': '',
    \ 'format': '%f:%l:%c:%m',
    \ 'follow_case_setting': 1,
    \ 'highlight': 1,
    \ 'qflist' : { 'open': 1, 'position': 'botright', 'height': '' }
    \ 'loclist': { 'open': 1, 'position': 'botright', 'height': '' }
    \}

```

|Configurations       |Default    |Description                                                                                          |
|---------------------|-----------|-----------------------------------------------------------------------------------------------------|
|`command`            |rg         |Path to `rg` command. You can set this If you install `rg` to the path which is not included `$PATH`.|
|`options`            |           |`ripgrep` options you want to set always.                                                            |
|`format`             |%f:%l:%c:%m|Format of search result.                                                                             |
|`follow_case_setting`|1          |Whether the plugin follows `ignorecase` and `smartcase`.                                             |
|`highlight`          |1          |Whether use highlighting or not.                                                                     |
|`qflist.open`        |1          |Whether open quickfix list after finish searching.                                                   |
|`qflist.position`    |botright   |Position of quickfix list.                                                                           |
|`qflist.height`      |           |Height of quickfix list.                                                                             |
|`loclist.open`       |1          |Whether open location list after finish searching.                                                   |
|`loclist.position`   |botright   |Position of location list.                                                                           |
|`loclist.height`     |           |Height of location list.                                                                             |

You can over overwrite the default configurations.
For example, If you want to set `options`, write the follows in your `.vimrc`.

```vim
let g:rg_config  = {
    \ 'options': '--hidden'
    \ }
```

## Commands


|Command                       |Description                                                                               |
|------------------------------|------------------------------------------------------------------------------------------|
|`Rg[!] [option] {pattern} [dir\|file]`    |Search pattern and open new quickfix list.                                                |
|`RgAdd[!] [option] {pattern} [dir\|file]`|Search pattern and append result to the current quickfix list.                            |
|`LRg[!] [option] {pattern} [dir\|file]`   |Search pattern and open new location list.                                                |
|`LRgAdd[!] [option] {pattern} [dir\|file]`|Search pattern and append result to the current location list.                            |
|`RgShowConfig`                |Shows the configurations for this plugin.                                                 |
|`RgShowImplicitOpts`          |Shows implicit options set by `g:rg_config.options` and `g:rg_config.follow_case_setting`.|
|`RgFollowCaseSetting [0\|1]`   |Set enable(1) or disable(1) to `g:rg_config.follow_case_setting`.                         |

Note: Regarding the search commands, After the `[option]` field, you can specify the arguments that can be specified in ripgrep. See ripgrep's help (`$ rg --help`).

## Mappings

|Mapping                     |Command        |Description                                      |
|----------------------------|---------------|-------------------------------------------------|
|`<Plug>(rg-rg)`             |`Rg<Space>`    |Put `Rg` on the command area.                    |
|`<Plug>(rg-rgadd)`          |`RgAdd<Space>` |Put `RgAdd` on the command area.                 |
|`<Plug>(rg-lrg)`            |`LRg<Space>`   |Put `LRg` on the command area.                   |
|`<Plug>(rg-lrgadd)`         |`LRgAdd<Space>`|Put `LRgAdd` on the command area.                |
|`<Plug>(rg-rg-cur-word)`    |`Rg<CR>`       |Run `Rg` with the word at the current cursor.    |
|`<Plug>(rg-rgadd-cur-word)` |`RgAdd<CR>`    |Run `RgAdd` with the word at the current cursor. |
|`<Plug>(rg-lrg-cur-word)`   |`LRg<CR>`      |Run `LRg` with the word at the current cursor.   |
|`<Plug>(rg-lrgadd-cur-word)`|`LRgAdd<CR>`   |Run `LRgAdd` with the word at the current cursor.|

<!--
vim:tw=78:sw=4:sts=4:ts=4:et
-->
