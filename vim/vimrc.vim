source ~/vimplugins/plugins.vim

filetype plugin indent on
syntax on

if has("gui_running")
	set guioptions-=T
	set guioptions-=e
	set guioptions-=r
	set guioptions+=LlRrb
	set guioptions-=LlRrb
	set guitablabel=%M\ %t

	colorscheme koehler
else
	set background=dark
endif

if has("mouse")
	set mouse=a
endif

if executable('ag')
	let g:ackprg = 'ag --vimgrep'
endif

if has('win32')
	set guifont=Consolas:h10
endif

autocmd BufWritePre * :call TrimSpaces()
autocmd FileType qf nnoremap <buffer> <Enter><Enter> <C-W>gf<CR>

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
set switchbuf=usetab
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
map <F1> :NERDTreeToggle<CR>
map <F3> <C-]>
map <F8> :sbnext<CR>
map <S-F8> :sbprevious<CR>
map <leader>t :tabs<CR>
map <leader>b :b <C-Z>
map <leader>o <C-w>gf<CR>
map <leader>r :s%///<left><left>
map <leader>s :set syntax=
map <leader>s :Ack<space>
map <leader>S :Ack <cword><CR>

" FZF Settings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

let g:fzf_layout = { 'down': '~40%' }

let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '10split enew' }

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

let g:fzf_history_dir = '~/.local/share/fzf-history'

" Easymotion Default settings
" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)
" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)
" Move to line
map <Leader>l <Plug>(easymotion-bd-jk)
nmap <Leader>l <Plug>(easymotion-overwin-line)
" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

" CtrlP Settings

set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
set wildignore+=*.class
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }
let g:ctrlp_max_files=0

map <C-f> :CtrlPLine<CR>
map <C-r> :CtrlPBufTag<CR>
map <C-S-r> :CtrlPTagAll<CR>

function! ConvertEndings()
	execute '%s/\r//g'
endfunction

command! ConvertEndings call ConvertEndings()

function! SetFileFormatDOS()
	execute 'ed ++ff=dos %'
endfunction

command! SetFileFormatDOS call SetFileFormatDOS()

function! DetectCtrlPUserCommand()
	if isdirectory("./.git")
		let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
	elseif has("win32")
		let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d'  " Windows
	else
		let g:ctrlp_user_command = 'find %s -type f'        " MacOSX/Linux
	end
endfunction

command! DetectCtrlPUserCommand call DetectCtrlPUserCommand()

autocmd BufEnter * :DetectCtrlPUserCommand

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

function! LargeFileSettings()
	set eventignore+=FileType
	setlocal bufhidden=unload
	setlocal buftype=nowrite
	setlocal noswapfile
	setlocal ro
	setlocal syntax=off
	setlocal undolevels=-1
endfunction

command! LargeFileSettings call LargeFileSettings()

function ListAllFiles()
	if isdirectory("./.git")
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

""
""
"" Cheat sheet
""
"" vimgrep /dostuff()/g ../**/*
""
""
