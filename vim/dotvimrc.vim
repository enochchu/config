"" Variables [VAR]
"" Auto Commands [AU]
"" Options [OPS]
"" Key Mappings [REMAP]
"" OS Specific Settings [OS]

source ~/.vim/functions.vim
source ~/.vim/plugins.vim
source ~/.vim/settings.vim

set shell=/bin/bash

filetype plugin indent on
syntax on

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Variables [VAR]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:EasyMotion_smartcase = 1
let g:EasyMotion_startofline = 0
let g:ctindentLine_char='•'
let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$\|\.class'
let g:ctrlp_dotfiles=0
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
let g:ctrlp_max_files=0
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others']
let g:ctrlp_working_path_mode = 0
let g:gitgutter_sign_column_always = 1
let g:indentLine_color_gui='#222222'
let g:indentLirlp_working_path_mode = ''
let g:matchparen_insert_timeout=5
let g:qs_highlight_on_keys = ['f', 'F']
let g:rbpt_loadcmd_toggle = 0
let g:rbpt_max = 16
let g:syntastic_mode_map = { "mode" : "passive",
	\ "active_filetypes" : [],
	\ "passive_filetypes" : [] }
let g:THEME_DARK="xoria256"
let g:THEME_LIGHT="eclipse"
let g:THEME_TERMINAL="xoria256"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Auto Commands [AU]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

au BufWritePost * :set nobinary | set eol
au BufWritePre * :call TrimSpaces()
au BufWritePre * :set binary | set noeol
au FileType css set omnifunc=csscomplete#CompleteCSS
au GUIEnter * set visualbell t_vb=
au InsertEnter * :set number
au InsertLeave * :set relativenumber
au Syntax * RainbowParenthesesLoadBraces
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesToggle
au WinEnter * set cursorline cursorcolumn
au WinLeave * set nocursorline nocursorcolumn

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Options [OPS]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set autoindent
set autoread
set background=dark
set backspace=2
set cmdheight=2
set colorcolumn=80
set complete=.,w,b,u,i
set completeopt=longest,menuone
set cursorline cursorcolumn
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
set noerrorbells
set noerrorbells visualbell t_vb=
set noexpandtab
set nofoldenable
set noswapfile
set novisualbell
set nowb
set omnifunc=syntaxcomplete#Complete
set path=$PWD/**
set relativenumber
set ruler
set shell=/bin/bash
set shiftwidth=4
set showtabline=0
set smartcase
set smartindent
set smarttab
set so=7
set t_Co=256
set t_vb=
set tabstop=4
set tm=500
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.class,*.pyc,*.jar
set wildmenu
set wildmode=longest,list,full

hi NonText ctermfg=darkgrey guifg=#222222
hi clear SpecialKey
hi link SpecialKey NonText
hi clear SignColumn

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Key Mappings [REMAP]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

inoremap " ""<Left>
inoremap <% <%  %><Left><Left><Left><Left>
inoremap <c-x><c-]> <c-]>
inoremap <tab> <c-r>=InsertTabWrapper ("forward")<CR>
inoremap <s-tab> <c-r>=InsertTabWrapper ("backward")<CR>
inoremap <c-tab> <c-r>=InsertTabWrapper ("startkey")<CR>
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <c-space> <c-x><c-o>
map  / <Plug>(easymotion-sn)
map  N <Plug>(easymotion-prev)
map  n <Plug>(easymotion-next)
map , <leader>
map ,b :NERDTreeFromBookmark<space>
map <C-b> :CtrlPBuffer<CR>
map <C-e> :CtrlPBookmarkDir<CR>
map <C-f> :CtrlPLine<CR>
map <C-r> :CtrlPBufTag<CR>
map <C-t> :CtrlPMixed<CR>
map <C-z> <C-y>,
map <S-left> <esc>:tabprevious<CR>
map <S-right> <esc>:tabnext<CR>
map <f2> :GundoToggle<CR>
map <f3> <C-]>
map <f4> :call TrimSpaces()<CR>
map <f7> :SyntasticToggleMode<CR>
map <leader>1 <esc>1@a
map <leader>2 <esc>1@s
map <leader>3 <esc>1@d
map <leader>4 <esc>1@f
map <leader>a :!
map <leader>w <Plug>(easymotion-prefix)
map <leader>x :bd!<CR>
map j gj
map k gk
map z/ <Plug>(incsearch-fuzzy-/)
map z? <Plug>(incsearch-fuzzy-?)
map zg/ <Plug>(incsearch-fuzzy-stay)
nmap ,c :call DiffWithFileFromDisk()<cr>
nmap ,gb :Gblame<CR>
nmap ,gc :Gcommit<CR>
nmap ,gd :Gdiff<CR>
nmap ,gg :Gbrowse<CR>
nmap ,gs :Gstatus<CR>
nmap ,h :sp<CR>
nmap ,v :vsp<CR>
nmap <Down> gj
nmap <S-Left> <<
nmap <S-Right> >>
nmap <S-h> <<
nmap <S-l> >>
nmap <Up> gk
nmap <f5> viB
nmap <leader>w :w!<cr>
nmap j gj
nmap k gk
nmap s <Plug>(easymotion-s2)
nmap t <Plug>(easymotion-t2)
nnoremap <BS> <C-^>
nnoremap <leader>' ""yls<c-r>={'"': "'", "'": '"'}[@"]<cr><esc>
nnoremap <leader>ba va{
nnoremap <leader>bi vi{
nnoremap <leader>cd :cd
nnoremap <leader>d :OverCommandLine <CR> %s/
nnoremap <leader>pa va(
nnoremap <leader>pi vi(
nnoremap <leader>s :set syntax=
nnoremap <silent> <F8> :TagbarToggle<CR>
nnoremap <silent> <leader>? :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>
nnoremap <silent> N N:call HLNext(0.4)<CR>
nnoremap <silent> n n:call HLNext(0.4)<CR>
nnoremap D d$
nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
noremap  <up>    <C-W>+
noremap <down>  <C-W>-
noremap <left>  3<C-W><
noremap <right> 3<C-W>>
noremap <silent> <leader><space> :noh<cr>:call clearmatches()<cr>
omap / <Plug>(easymotion-tn)
vmap <S-Down> :call <SID>swap_down()<CR>
vmap <S-Left> <<
vmap <S-Right> >>
vmap <S-Up> :call <SID>swap_up()<CR>
vmap <f5> :sort u<CR>
vnoremap H <gv
vnoremap J xp`[V`]
vnoremap K xkP`[V`]
vnoremap L >gv

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" OS Specific Settings [OS]
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has("mac") || has("macunix")
	if has("gui_running")
		set gfn=Monaco:h10
	endif
elseif has("linux")
    set gfn=Monospace\ 11
endif

if has("gui_running")
	execute 'colorscheme ' . g:THEME_DARK

	set guioptions-=T
	set guioptions-=e
	set guioptions-=r
	set guioptions+=LlRrb
	set guioptions-=LlRrb
	set guitablabel=%M\ %t

	map <f10> :call ToggleLightAndDarkTheme()<CR>
	map <f1> :NERDTreeToggle<CR>
else
	execute 'colorscheme ' . g:THEME_TERMINAL
	map ,p :FZF<CR>
endif

if has("mouse")
	set mouse=a
endif