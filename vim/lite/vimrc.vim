""
""
"" |------------------------------------------------|
"" | Some useful shortcuts and commands             |
"" |------------------------------------------------|
"" | <C-W> gf              | Open file under cursor |
"" |                       |                        |
"" | :file <buffername>    | Renames buffer if      |
"" |                       | buffer has no name     |
"" |                       |                        |
"" | G?foo<CR>             | Search backwards       |
"" |------------------------------------------------|
""
""

filetype plugin indent on
syntax on

if has("gui_running")
	set guioptions-=T
	set guioptions-=e
	set guioptions-=r
	set guioptions+=LlRrb
	set guioptions-=LlRrb
	set guitablabel=%M\ %t

	colorscheme blue
else
	set background=dark
endif

if has("mouse")
	set mouse=a
endif

if has('win32')
	set guifont=Consolas:h10
endif

autocmd BufWritePre * :call TrimSpaces()
autocmd FileType qf nnoremap <buffer> <Enter><Enter> <C-W>gf<CR>

set autochdir
set autoindent
set autoread
set backspace=2
set binary
set cmdheight=1
set colorcolumn=80
set complete=.,w,b,u,i
set completeopt=longest,menuone
set encoding=utf8
set ffs=unix,dos,mac
set foldcolumn=0
set foldlevel=1
set foldmethod=manual
set foldnestmax=10
set hid
set hlsearch
set ignorecase
set incsearch
set lazyredraw
set lbr
set list
set listchars=tab:▸\ ,extends:❯,precedes:❮
set magic
set mat=2
set nobackup
set noeol
set noerrorbells
set noerrorbells visualbell t_vb=
set noexpandtab
set nofoldenable
set noswapfile
set novisualbell
set nowb
set number
set omnifunc=syntaxcomplete#Complete
set path=$PWD/**
set relativenumber
set ruler
set shiftwidth=4
set showtabline=0
set smartcase
set smartindent
set smarttab
set so=7
set tags=./tags;
set t_Co=256
set t_vb=
set tabstop=4
set tm=500
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.class,*.pyc,*.jar
set wildchar=<Tab> wildmenu wildmode=full
set wildcharm=<C-Z>
set wildmenu
set wildmode=longest,list,full

map <C-space> :nohl<CR>
map <F1> :ToggleQuickfix 25<CR>
map <F2> :vimgrep // **/*<left><left><left><left><left><left>
map <F3> <C-]>
map <leader>t :tabs<CR>
map <leader>b :b <C-Z>
map <leader>o <C-w>gf<CR>
map <leader>r :s%///<left><left>
map <leader>s :vimgrep // **/*<left><left><left><left><left><left>

function! DiffToggle()
	if &diff
		diffoff
	else
		diffthis
	endif
endfunction

nnoremap <silent> <Leader>df :call DiffToggle()<CR>

function! FindFiles(filename)
	let error_file = tempname()

	silent execute '!find . -name "'.a:filename.'" | xargs file | sed "s/:/:1:/" > '.error_file

	set errorformat=%f:%l:%m

	execute "cfile ". error_file

	copen

	call delete(error_file)
endfunction

command! -nargs=1 FindFile call FindFiles(<q-args>)

function ListAllFiles()
	if filereadable("./.git")
		execute 'r! git ls-files'
	elseif has("win32")
		execute 'r! dir * /b/s'
	else
		execute 'r! find `pwd` -type f'
	end
endfunction

function ListAllFilesToBuffer()
	execute 'new'

	call ListAllFiles()

	execute 'file listoffiles'

	execute 'setlocal nomodifiable'
endfunction

command! ListAllFilesToBuffer call ListAllFilesToBuffer()

function LogMode()
	set autoread

	set nomodifiable
endfunction

command! LogMode call LogMode()

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

function! ToggleQuickfix(height)
	if !exists("g:quickfix_is_open")
		let g:quickfix_is_open = 0
	endif

	if g:quickfix_is_open
		let g:quickfix_is_open = 0

		cclose
	else
		let g:quickfix_is_open = 1

		execute "topleft copen ".a:height
	endif
endfunction

command! -nargs=1 ToggleQuickfix call ToggleQuickfix(<q-args>)

function TrimSpaces() range
	let oldhlsearch=ShowSpaces(1)

	execute a:firstline.",".a:lastline."substitute ///gec"

	let &hlsearch=oldhlsearch
endfunction
