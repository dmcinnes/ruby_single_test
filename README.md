RubySingleTest
==============

VIM plugin for running a single Ruby test under the cursor.

Supports Test::Unit, Rspec and Minitest.

When editing a Ruby test file, hit
`<leader>.`
and the test the cursor is over, and only that test, will run in quickfix.
That's it!

(`<leader>` is usually `\` or `,` so the command would be `\.` or `,.`)

To remap the command, to `<leader>t` for instance, add something
like this to your .vimrc:
`nmap <silent> <leader>t <Plug>ExecuteRubyTest`

Ruby Single Test default to using make! with a bang.  To disable
this behavior drop this in your .vimrc:
`let g:ruby_single_test_no_bang = 1`

You will need to set the appropiate `makeprg` for this to work.
