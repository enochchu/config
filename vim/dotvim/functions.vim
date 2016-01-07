"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" AutoHighlight [AUTO]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! AutoHighlightToggle()
	let @/ = ''

	if exists('#auto_highlight')
		au! auto_highlight
		augroup! auto_highlight
		setl updatetime=4000
		echo 'Highlight current word: off'
		return 0
	else
		augroup auto_highlight
		au!
		au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
		augroup end
		setl updatetime=500
		echo 'Highlight current word: ON'

		return 1
	endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Toggle Light and Dark Theme [TOGGLE]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! ToggleLightAndDarkTheme()
	if (g:colors_name == g:THEME_DARK)
		execute 'colorscheme ' . g:THEME_LIGHT
	else
		execute 'colorscheme ' . g:THEME_DARK
	endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Diff with file from buffer [DIFFBUFFER]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! DiffWithFileFromDisk()
	let filename=expand('%')
	let diffname = filename.'.fileFromBuffer'
	exec 'saveas! '.diffname
	diffthis
	vsplit
	exec 'edit '.filename
	diffthis
endfunction
j
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Blinktime Highlight [BLINK]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! HLNext (blinktime)
	set invcursorline
	redraw
	exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
	set invcursorline
	redraw
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Insert Tab Wrapper [INSTAB]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! InsertTabWrapper(direction)
	let col = col('.') - 1
	if !col || getline('.')[col - 1] !~ '\k'
		return "\<tab>"
	elseif "backward" == a:direction
		return "\<c-p>"
	elseif "forward" == a:direction
		return "\<c-n>"
	else
		return "\<c-x>\<c-k>"
	endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Toggle Tab Completion [TOGGLETAB]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! ToggleTabCompletion()
	if mapcheck("\<tab>", "i") != ""
		:iunmap <tab>
		:iunmap <s-tab>
		:iunmap <c-tab>
		echo "tab completion off"
	else
		:imap <tab> <c-n>
		:imap <s-tab> <c-p>
		:imap <c-tab> <c-x><c-l>
		echo "tab completion on"
	endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Show Spaces [SHOWSPACE]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function ShowSpaces(...)
	let @/='\v(\s+$)|( +\ze\t)'
	let oldhlsearch=&hlsearch
	if !a:0
		let &hlsearch=!&hlsearch
	else
		let &hlsearch=a:1
	end
	return oldhlsearch
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Trim Spaces [TRIMSPACE]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function TrimSpaces() range
	let oldhlsearch=ShowSpaces(1)
	execute a:firstline.",".a:lastline."substitute ///gec"
	let &hlsearch=oldhlsearch
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Settings for Large Files [LARGEFILE]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if !exists("my_auto_commands_loaded")
	let my_auto_commands_loaded = 1
	" Large files are > 10M
	" Set options:
	" eventignore+=FileType (no syntax highlighting etc
	" assumes FileType always on)
	" noswapfile (save copy of file)
	" bufhidden=unload (save memory when other file is viewed)
	" buftype=nowritefile (is read-only)
	" undolevels=-1 (no undo possible)
	let g:LargeFile = 1024 * 1024 * 10
	augroup LargeFile
	autocmd BufReadPre * let f=expand("<afile>") | if getfsize(f) > g:LargeFile | set eventignore+=FileType | setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 | else | set eventignore-=FileType | endif
	augroup END
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" RangerExplorer [RANGE]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function RangerExplorer()
	exec "silent !ranger --choosefile=/tmp/vim_ranger_current_file " . expand("%:p:h")
	if filereadable('/tmp/vim_ranger_current_file')
		exec 'edit ' . system('cat /tmp/vim_ranger_current_file')
		call system('rm /tmp/vim_ranger_current_file')
	endif
	redraw!
endfun