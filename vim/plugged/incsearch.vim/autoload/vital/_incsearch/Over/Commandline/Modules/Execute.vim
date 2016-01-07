scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! s:silent_feedkeys(expr, name, ...)
	let mode = get(a:, 1, "m")
	let map = printf("<Plug>(%s)", a:name)
	if mode == "n"
		let command = "nnoremap"
	else
		let command = "nmap"
	endif
	execute command "<silent>" map printf("%s:nunmap %s<CR>", a:expr, map)
	call feedkeys(printf("\<Plug>(%s)", a:name))
endfunction


function! s:_is_input_enter(cmdline)
	return a:cmdline.is_input("\<CR>")
\		|| a:cmdline.is_input("\<NL>")
\		|| a:cmdline.is_input("\<C-j>")
endfunction


let s:module = {
\	"name" : "Execute"
\}

function! s:module.on_char_pre(cmdline)
	if s:_is_input_enter(a:cmdline)
		call self.execute(a:cmdline)
		call a:cmdline.setchar("")
		call a:cmdline.exit(0)
	endif
	if a:cmdline.is_input("<Over>(execute-no-exit)")
		call self.execute(a:cmdline)
		call a:cmdline.setchar("")
	endif
endfunction

function! s:module.execute(cmdline)
	return a:cmdline.execute()
endfunction


function! s:make()
	return deepcopy(s:module)
endfunction


let s:search = deepcopy(s:module)
let s:search.prefix = "/"


function! s:search.execute(cmdline)
	call s:silent_feedkeys(":call histdel('/', -1)\<CR>", "remove_hist", "n")
	let cmd = printf("call s:silent_feedkeys(\"%s%s\<CR>\", 'search', 'n')", self.prefix, a:cmdline.getline())
	execute cmd
" 	let cmd = printf("call search('%s')", a:cmdline.getline())
" 	call a:cmdline.execute(cmd)
" 	let @/ = a:cmdline.getline()
" 	call s:silent_feedkeys(":let &hlsearch = &hlsearch\<CR>", "hlsearch", "n")
endfunction



function! s:make_search(...)
	let result = deepcopy(s:search)
	let result.prefix = get(a:, 1, "/")
	return result
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
