scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:verbosefiles = []

function! s:_verbosefile_push(file)
	call add(s:verbosefiles, &verbosefile)
	let &verbosefile = a:file
	return a:file
endfunction


function! s:_verbosefile_pop()
	let filename = &verbosefile
	let &verbosefile = get(s:verbosefiles, -1)
	call remove(s:verbosefiles, -1)
	return filename
endfunction


function! s:_reset()
	let s:verbosefiles = []
endfunction


function! s:extend(dict, src)
	for [key, value] in items(a:src)
		let a:dict[key] = value
		unlet value
	endfor
endfunction


function! s:command(cmd, ...)
	" Workaround : Vim 7.3.xxx in Travis and Ubuntu
	" https://github.com/osyo-manga/vital-palette/issues/5
" 	call extend(l:, get(a:, 1, {}))
	if a:0 > 0
		call s:extend(l:, a:1)
	endif

	call s:_verbosefile_push(tempname())
	try
		redir =>result
		silent execute a:cmd
	finally
		redir END
	endtry
	call s:_verbosefile_pop()
" 	let result = substitute(result, "<SRN>", "\<SNR>", "g")
" 	let result = substitute(result, "<SID>", "\<SID>", "g")
	return result
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
