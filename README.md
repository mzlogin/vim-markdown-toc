# vim-markdown-toc

A vim plugin to generate table of contents for a markdown file.

## Usage

There are *GFM* and *Redcarpet* two styles TOC links, see [here][1] to view their difference.

1. `:GenTocGFM`

    Generate table of contents in [GFM][2] link style.

2. `:GenTocRedcarpet`

    Generate table of contents in [Redcarpet][3] link style.

## Installation

Suggest to manage your vim plugins via [Vundle][4] so you can install it simply three steps:

1. add the following line to your vimrc file

    ```
    Plugin 'mzlogin/vim-markdown-toc'
    ```

2. `:so $MYVIMRC`

3. `:PluginInstall`

## References

* <https://github.com/ajorgensen/vim-markdown-toc>

[1]: http://mazhuang.org/2015/12/05/diff-between-gfm-and-redcarpet/
[2]: https://help.github.com/articles/github-flavored-markdown/
[3]: https://github.com/vmg/redcarpet
[4]: http://github.com/VundleVim/Vundle.Vim
