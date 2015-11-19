# EasyClipRing.vim

Autocomplete style vim pop-up menu for your registers. See screenshot in
the [Usage](#usage) section.

This plugin requires [vim-easyclip](https://github.com/svermeulen/vim-easyclip)
which requires [vim-repeat](https://github.com/tpope/vim-repeat)

## Installation

You can just drop this plugin into your `.vim/` dir. Make sure vim-repeat and
vim-easyclip are also installed.

I recommend using [vim-plug](https://github.com/junegunn/vim-plug) in general:

    call plug#begin()

    Plug 'tpope/vim-repeat'
          \| Plug 'svermeulen/vim-easyclip'
          \| Plug 'davidosomething/EasyClipRing.vim'

    call plug#end()

Note the dependency scaffold there -- vim-easyclip integrates with vim-repeat,
and EasyClipRing.vim uses vim-easyclip.

## Usage

The default mapping is `<Leader>cr` (for "clipring"). Press this in __insert__
mode to trigger the pop-up menu:

![Screenshot of output](screenshot.png)

## Settings

### g:ecr_disable_default_mapping

Disable the default mapping to open the completion pop-up.

    let g:ecr_disable_default_mapping = 1

## Custom Mapping

Define a custom mapping like so:

    imap    <Leader>cr  <Plug>(EasyClipRing)

## Thanks

- /u/rgvim on [reddit](https://www.reddit.com/r/vim/comments/3td6l6/can_someone_help_with_this_easyclip_yanks_in_a/)
who really helped with the formatting!

- [Steve Vermeulen](https://github.com/svermeulen/) for creating easyclip

## License

MIT


