" Ruby Single Test
"
" Description: Plugin for running a single Ruby test under the cursor
"              Supports TestUnit and Rspec
" Last Change:	Feb 15, 2009
" Version: 1.0
" Author:	Doug McInnes <doug@dougmcinnes.com>
" URL: http://github.com/dmcinnes/ruby_single_test/tree
"
" When a ruby test file with your cursor within a test block, hit
" <leader>.
" and that test, and only that test, will run in quickfix.
" That's it!
"
" TODO: add Shoulda support

if exists("loaded_ruby_single_test")
  finish
endif
let loaded_ruby_single_test = 1

function s:Run()
  if bufname("%") =~ "_test.rb$"
    call s:ExecuteRubyUnitTest()
  elseif bufname("%") =~ "_spec.rb$"
    call s:ExecuteRubySpec()
  else
    echo "Not a test file"
  endif
endfunction

function s:ExecuteRubyUnitTest()
  let s:line_no = search('^\s*def\s*test_', 'bcnW')
  if s:line_no
    let s:old_make = &makeprg
    let &l:makeprg = "ruby\ %"
    exec "make -n \"" . split(getline(s:line_no))[1] . "\""
    let &l:makeprg = s:old_make
  else
    echo "Can't find a test!"
  endif
endfunction

function s:ExecuteRubySpec()
  let s:line_no = search('^\s*it\s*"', 'bcnW')
  if s:line_no
    let s:old_make = &makeprg
    let &l:makeprg = "spec\ %"
    exec "make -l " . s:line_no
    let &l:makeprg = s:old_make
  else
    echo "Can't find a test!"
  endif
endfunction

nmap <unique> <script> <Plug>ExecuteRubyTest  <SID>Run
nmap <SID>Run  :call <SID>Run()<CR>

if !hasmapto('<Plug>ExecuteRubyTest')
  nmap <silent> <leader>. <Plug>ExecuteRubyTest
endif
