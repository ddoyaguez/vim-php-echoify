if exists("g:loaded_php_echoify")
    finish
endif
let g:loaded_php_echoify = 1


" Function to escape all double quotes
function! PHPEchoifyEscapeDoubleQuotes() range
    execute a:firstline . ',' . a:lastline . 's/"/\\"/g'
endfunction

" Function to insert echo
function! PHPEchoifyInsertEcho() range
    execute a:firstline . ',' . a:lastline . "normal! ^iecho \"\<esc>A\";\<esc>=="
endfunction

" Function to delete echo
function! PHPEchoifyDeleteEcho() range
    execute a:firstline . ',' . a:lastline . "normal! ^dwxg_xx"
endfunction

" Function to unescape double quotes
function! PHPEchoifyUnescapeDoubleQuotes() range
    execute a:firstline . ',' . a:lastline . 's/\\"/"/g'
endfunction

" Function to test if a line is echoified
function! PHPEchoifyIsEchoified(lnum)
    let l:line = getline(a:lnum)
    let l:firstword = split(l:line)[0]
    if l:firstword ==# "echo"
        return 1
    else
        return 0
    endif
endfunction

" Function to force the echoify. Does nothing if is echoified
function! PHPEchoify() range
    for l:num in range(a:firstline, a:lastline)
        let l:isecho = PHPEchoifyIsEchoified(l:num)
        if !l:isecho
            execute l:num . "call PHPEchoifyEscapeDoubleQuotes()"
            execute l:num . "call PHPEchoifyInsertEcho()"
        endif
    endfor
endfunction

" Function to force the unechoify. Does nothing if is not echoified
function! PHPUnechoify() range
    for l:num in range(a:firstline, a:lastline)
        let l:isecho = PHPEchoifyIsEchoified(l:num)
        if l:isecho
            execute l:num . "call PHPEchoifyDeleteEcho()"
            execute l:num . "call PHPEchoifyUnescapeDoubleQuotes()"
        endif
    endfor
endfunction

" Generate commands
command -range PHPEchoify <line1>,<line2>call PHPEchoify()
command -range PHPUnechoify <line1>,<line2>call PHPUnechoify()

" Mappings
nnoremap <leader>e :call PHPEchoify()<CR>
vnoremap <leader>e :call PHPEchoify()<CR>
nnoremap <leader>u :call PHPUnechoify()<CR>
vnoremap <leader>u :call PHPUnechoify()<CR>
