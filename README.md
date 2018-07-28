# vim-markdown-toc

A folk to help the original plugin work with [plasticboy/vim-markdown](https://github.com/plasticboy/vim-markdown)

A vim 7.4+ plugin to generate table of contents for Markdown files.

[中文版使用指南][7]

## Table of Contents

<!-- vim-markdown-toc GFM -->

* [Features](#features)
* [Installation](#installation)
* [Usage](#usage)
    * [Generate table of contents](#generate-table-of-contents)
    * [Update existing table of contents](#update-existing-table-of-contents)
    * [Remove table of contents](#remove-table-of-contents)
* [Options](#options)
* [Screenshots](#screenshots)
* [References](#references)

<!-- vim-markdown-toc -->

## Features

* Generate table of contents for Markdown files.

  Supported Markdown parsers:

  - [x] GFM (GitHub Flavored Markdown)
  - [x] GitLab
  - [x] Redcarpet

* Update existing table of contents.

* Auto update existing table of contents on save.

## Installation

Suggest to manage your vim plugins via [Vundle][4] so you can install it simply three steps:

1. add the following line to your vimrc file

    ```
    Plugin 'mzlogin/vim-markdown-toc'
    ```

2. `:so $MYVIMRC`

3. `:PluginInstall`

Installation with [vim-plug][8] is likeness.

## Usage

### Generate table of contents

Move the cursor to the line you want to append table of contents, then type a command below suit you. The command will generate **headings after the cursor** into table of contents.

1. `:TocGenGFM`

    Generate table of contents in [GFM][2] link style.

    This command is suitable for Markdown files in GitHub repositories, like `README.md`, and Markdown files for GitBook.

2. `:TocGenRedcarpet`

    Generate table of contents in [Redcarpet][3] link style.

    This command is suitable for Jekyll or anywhere else use Redcarpet as its Markdown parser.

3. `:TocGenGitLab`

    Generate table of contents in [GitLab][9] link style.

    This command is suitable for GitLab repository and wiki.

4. `:TocGenMarked`

    Generate table of contents for [iamcco/markdown-preview.vim][10] which use [Marked][11] markdown parser.

You can view [here][1] to know differences between *GFM* and *Redcarpet* style toc links.

### Update existing table of contents

Generally you don't need to do this manually, existing table of contents will auto update on save by default.

The `:TocUpdate` command, which is designed to update toc manually, can only work when `g:vmt_auto_update_on_save` turned off, and keep insert fence.

### Remove table of contents

`:TocRemove` command will do this for you, just remember keep insert fence option by default.

## Options

1. `g:vmt_auto_update_on_save`

   default: 1

   This plugin will update existing table of contents on save automatic.

   You can close this feature by add the following line to your vimrc file:

   ```viml
   let g:vmt_auto_update_on_save = 0
   ```

2. `g:vmt_dont_insert_fence`

   default: 0

   By default, the `:TocGenXXX` commands will add `<!-- vim-markdown-toc -->` fence to the table of contents, it is designed for feature of auto update table of contents on save and `:TocUpdate` command, it won't effect what your Markdown file looks like after parse.

   If you don't like this, you can remove the fence by add the following line to your vimrc file:

   ```viml
   let g:vmt_dont_insert_fence = 1
   ```

   But then you will lose the convenience of auto update tables of contents on save and `:TocUpdate` command. When you want to update toc, you need to remove existing toc manually and rerun `:TocGenXXX` commands.

3. `g:vmt_cycle_list_item_markers`

   default: 0

   By default, `*` is used to denote every level of a list:

   ```
   * [Level 1](#level-1)
       * [Level 1-1](#level-1-1)
       * [Level 1-2](#level-1-2)
           * [Level 1-2-1](#level-1-2-1)
   * [Level 2](level-2)
   ```

   If you set:

   ```viml
   let g:vmt_cycle_list_item_markers = 1
   ```

   every level will instead cycle between the valid list item markers `*`, `-` and `+`:

   ```
   * [Level 1](#level-1)
       - [Level 1-1](#level-1-1)
       - [Level 1-2](#level-1-2)
           + [Level 1-2-1](#level-1-2-1)
   * [Level 2](level-2)
   ```

   This renders the same according to Markdown rules, but might appeal to those who care about readability of the source.

4. `g:vmt_list_item_char`

    default: `*`

    The list item marker, it can be `*`, `-` or `+`.

## Screenshots

* [online demo in English][5]

![](./screenshots/english.gif)

* [online demo in Chinese][6]

![](./screenshots/chinese.gif)

## References

* <https://github.com/ajorgensen/vim-markdown-toc>

[1]: http://mazhuang.org/2015/12/05/diff-between-gfm-and-redcarpet/
[2]: https://help.github.com/articles/github-flavored-markdown/
[3]: https://github.com/vmg/redcarpet
[4]: http://github.com/VundleVim/Vundle.Vim
[5]: https://github.com/mzlogin/chinese-copywriting-guidelines/blob/Simplified/README.en.md
[6]: https://github.com/mzlogin/awesome-adb
[7]: http://mazhuang.org/2015/12/19/vim-markdown-toc/
[8]: https://github.com/junegunn/vim-plug
[9]: https://docs.gitlab.com/ee/user/markdown.html
[10]:https://github.com/iamcco/markdown-preview.vim
[11]:https://github.com/markedjs/marked
