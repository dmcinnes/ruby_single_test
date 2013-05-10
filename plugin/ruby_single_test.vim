" Ruby Single Test
"
" Description: Plugin for running a single Ruby test under the cursor
"              Supports TestUnit, Rspec and Minitest
" Last Change:	May 10, 2013
" Version: 1.0.3
" Author:	Doug McInnes <doug@dougmcinnes.com>
" URL: http://github.com/dmcinnes/ruby_single_test/tree
"
" When a ruby test file with your cursor within a test block, hit
" <leader>.
" and that test, and only that test, will run in quickfix.
" That's it!
"
" To remap the command, to <leader>t for instance, add something
" like this to your .vimrc:
" nmap <silent> <leader>t <Plug>ExecuteRubyTest
"
" Ruby Single Test default to using make! with a bang.  To disable
" this behavior drop this in your .vimrc:
" let g:ruby_single_test_no_bang = 1
"
"
" TODO: add Shoulda support

if exists("loaded_ruby_single_test")
  finish
endif
let loaded_ruby_single_test = 1

function! s:Run()
  let s:make_cmd = "make" . (exists("g:ruby_single_test_no_bang") ? "" : "!")
  if &filetype == "rspec" || &makeprg =~ "spec"
    call s:ExecuteRubySpec()
  elseif &makeprg =~ "ruby" " Test::Unit
    call s:ExecuteRubyUnitTest()
  else
    echo "Not a test file"
  endif
endfunction

function! s:ExecuteRubyUnitTest()
  let s:line_no = search('^\s*def\s*test_', 'bcnW')

  if s:line_no
    let s:selector = split(getline(s:line_no), ' ')[1]
  else
    let s:line_no = search('\v^\s*(it|test|specify)\s+("|'')', 'bcnW')
    if s:line_no
      let s:selector = "/" . split(getline(s:line_no), '\v("|'')')[1] . "/"
    endif
  endif

  if s:line_no
    exec s:make_cmd . " \"%\" -n \"" . s:selector . "\""
  else
    echo "Can't find a test!"
  endif
endfunction

function! s:ExecuteRubySpec()
  exec s:make_cmd . " \"%\" -l " . line(".")
endfunction

nmap <unique> <script> <Plug>ExecuteRubyTest  <SID>Run
nmap <SID>Run  :call <SID>Run()<CR>

if !hasmapto('<Plug>ExecuteRubyTest')
  nmap <silent> <leader>. <Plug>ExecuteRubyTest
endif
