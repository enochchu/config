"******************************************************************************
" High functional argument (option) parser
"
" Author:   Alisue <lambdalisue@hashnote.net>
" URL:      http://hashnote.net/
" License:  MIT license
" (C) 2014, Alisue, hashnote.net
"******************************************************************************
let s:save_cpo = &cpo
set cpo&vim

function! s:_vital_loaded(V) abort " {{{
  let s:P = a:V.import('Prelude')
  let s:D = a:V.import('Data.Dict')
  let s:L = a:V.import('Data.List')
  let s:H = a:V.import('System.Filepath')
endfunction " }}}
function! s:_vital_created(module) abort " {{{
  let s:const = {}
  let s:const.types = {}
  let s:const.types.any = 0
  let s:const.types.value = 1
  let s:const.types.switch = 2
  let s:const.types.choice = 3
  lockvar s:const

  call extend(a:module, s:const)
endfunction " }}}
function! s:_vital_depends() abort " {{{
  return ['Prelude', 'Data.Dict', 'Data.List', 'System.Filepath']
endfunction " }}}
function! s:_ensure_list(x) abort " {{{
  return s:P.is_list(a:x) ? a:x : [a:x]
endfunction " }}}

" Public functions
function! s:splitargs(str) abort " {{{
  let single_quote = '\v''\zs[^'']+\ze'''
  let double_quote = '\v"\zs[^"]+\ze"'
  let bare_strings = '\v[^ \t''"]+'
  let pattern = printf('\v%%(%s|%s|%s)',
        \ single_quote,
        \ double_quote,
        \ bare_strings,
        \)
  return split(a:str, printf('\v%s*\zs%%(\s+|$)\ze', pattern))
endfunction " }}}
function! s:strip_quotes(str) abort " {{{
  if a:str =~# '\v^%(".*"|''.*'')$'
    return a:str[1:-2]
  else
    return a:str
  endif
endfunction " }}}
function! s:new(...) abort " {{{
  let options = extend({
        \ 'name': '',
        \ 'description': '',
        \ 'auto_help': 1,
        \ 'validate_required': 1,
        \ 'validate_types': 1,
        \ 'validate_conflicts': 1,
        \ 'validate_superordinates': 1,
        \ 'validate_dependencies': 1,
        \ 'validate_pattern': 1,
        \ 'enable_positional_assign': 0,
        \ 'complete_unknown': function('s:complete_dummy'),
        \ 'description_unknown': '',
        \}, get(a:000, 0, {}))
  let parser = extend(deepcopy(s:parser), s:D.pick(options, [
        \ 'name',
        \ 'auto_help',
        \ 'validate_required',
        \ 'validate_types',
        \ 'validate_conflicts',
        \ 'validate_superordinates',
        \ 'validate_dependencies',
        \ 'validate_pattern',
        \ 'enable_positional_assign',
        \ 'description_unknown',
        \]))
  if s:P.is_list(options.description)
    let parser.description = join(options.description, "\n")
  else
    let parser.description = options.description
  endif
  if s:P.is_string(options.complete_unknown)
    if options.complete_unknown ==# 'file'
      let parser.complete_unknown = function('s:complete_files')
    else
      let parser.complete_unknown = function('s:complete_dummy')
    endif
  elseif s:P.is_funcref(options.complete_unknown)
    let parser.complete_unknown = options.complete_unknown
  else
    let parser.complete_unknown = function('s:complete_dummy')
  endif
  if parser.auto_help
    call parser.add_argument(
          \ '--help', '-h', 'show this help',
          \)
  endif
  return parser
endfunction " }}}
function! s:new_argument(name, ...) abort " {{{
  " determind name
  if a:name =~# '^--\?'
    let positional = 0
    let name = substitute(a:name, '^--\?', '', '')
  else
    let positional = 1
    let name = a:name
  endif
  " determind arguments
  if a:0 == 0 " add_argument({name})
    let alias = ''
    let description = ''
    let options = {}
  elseif a:0 == 1
    " add_argument({name}, {description})
    " add_argument({name}, {options})
    if s:P.is_string(a:1) || s:P.is_list(a:1)
      let alias = ''
      let description = a:1
      let options = {}
    else
      let alias = ''
      let description = ''
      let options = a:1
    endif
  elseif a:0 == 2
    " add_argument({name}, {alias}, {description})
    " add_argument({name}, {description}, {options})
    if s:P.is_string(a:2) || s:P.is_list(a:2)
      let alias = a:1
      let description = a:2
      let options = {}
    elseif s:P.is_dict(a:2)
      let alias = ''
      let description = a:1
      let options = a:2
    endif
  elseif a:0 == 3
    " add_argument({name}, {alias}, {description}, {options})
    let alias = a:1
    let description = a:2
    let options = a:3
  else
    throw 'vital: ArgumentParser: too much arguments are specified'
  endif
  let Choices = get(options, 'choices', [])
  " create an argument instance
  let argument = extend(deepcopy(s:argument), extend({
        \ 'name': name,
        \ 'description': s:_ensure_list(description),
        \ 'positional': positional,
        \ 'alias': substitute(alias, '^-', '', ''),
        \ 'choices': Choices,
        \}, options))
  " automatically assign argument type
  if argument.type == -1
    if s:P.is_funcref(Choices) || !empty(Choices)
      let argument.type = s:const.types.choice
    elseif !empty(argument.pattern)
      let argument.type = s:const.types.value
    elseif argument.positional
      let argument.type = s:const.types.value
    else
      let argument.type = s:const.types.switch
    endif
  endif
  " validate options
  if positional && argument.alias
    throw 'vital: ArgumentParser: "alias" option cannot be specified to a positional argument'
  elseif positional && argument.alias
    throw 'vital: ArgumentParser: "default" option cannot be specified to a positional argument'
  elseif positional && argument.type != s:const.types.value && argument.type != s:const.types.choice
    throw 'vital: ArgumentParser: "type" option cannot be ANY or SWITCH for a positional argument'
  elseif positional && !empty(argument.conflicts)
    throw 'vital: ArgumentParser: "conflicts" option cannot be specified to a positional argument'
  elseif positional && !empty(argument.dependencies)
    throw 'vital: ArgumentParser: "dependencies" option cannot be specified to a positional argument'
  elseif positional && !empty(argument.superordinates)
    throw 'vital: ArgumentParser: "superordinates" option cannot be specified to a positional argument'
  elseif !empty(argument.default) && argument.required
    throw 'vital: ArgumentParser: "default" and "required" option cannot be specified together'
  elseif empty(argument.choices) && argument.type == s:const.types.choice
    throw 'vital: ArgumentParser: "type" is specified to "choice" but no "choices" is specified'
  elseif !empty(argument.pattern) && argument.type == s:const.types.switch
    throw 'vital: ArgumentParser: "pattern" option cannot be specified for SWITCH argument'
  endif
  " register complete callback
  let Complete = get(argument, 'complete', 0)
  if has_key(argument, 'complete')
    unlet argument.complete
  endif
  if s:P.is_funcref(Complete)
    let argument.complete = Complete
  elseif s:P.is_string(Complete)
    if Complete ==# 'choices'
      let argument.complete = function('s:complete_choices')
    elseif Complete ==# 'file'
      let argument.complete = function('s:complete_files')
    else
      let argument.complete = function('s:complete_dummy')
    endif
  elseif s:P.is_number(Complete)
    if argument.type == s:const.types.choice
      let argument.complete = function('s:complete_choices')
    elseif argument.type == s:const.types.any || argument.type == s:const.types.value
      let argument.complete = function('s:complete_files')
    else
      let argument.complete = function('s:complete_dummy')
    endif
  endif
  return argument
endfunction " }}}

function! s:complete_dummy(arglead, cmdline, cursorpos, ...) abort " {{{
  return []
endfunction " }}}
function! s:complete_files(arglead, cmdline, cursorpos, ...) abort " {{{
  let extra = extend({
        \ 'argument': {},
        \ 'opts': {},
        \}, get(a:000, 0, {}))
  let root = expand(get(extra.argument, '__complete_files_root', '.'))
  let candidates = split(
        \ glob(s:H.join(root, a:arglead . '*'), 0),
        \ "\n",
        \)
  " substitute 'root'
  call map(candidates, printf("substitute(v:val, '^%s/', '', '')", root))
  " substitute /home/<user> to ~/ if ~/ is specified
  if a:arglead =~# '^\~'
    call map(candidates, printf("substitute(v:val, '^%s', '~', '')", expand('~')))
  endif
  call map(candidates, "escape(isdirectory(v:val) ? v:val.'/' : v:val, ' \\')")
  return candidates
endfunction " }}}
function! s:complete_choices(arglead, cmdline, cursorpos, ...) abort " {{{
  let extra = extend({
        \ 'argument': {},
        \ 'opts': {},
        \}, get(a:000, 0, {}))
  if !has_key(extra.argument, 'get_choices')
    return []
  endif
  let candidates = extra.argument.get_choices(extra.opts)
  call filter(candidates, printf('v:val =~# "^%s"', a:arglead))
  return candidates
endfunction " }}}

" Instance
let s:argument = {
      \ 'name': '',
      \ 'description': [],
      \ 'terminal': 0,
      \ 'positional': 0,
      \ 'required': 0,
      \ 'default': '',
      \ 'alias': '',
      \ 'type': -1,
      \ 'deniable': 0,
      \ 'choices': [],
      \ 'pattern': '',
      \ 'conflicts': [],
      \ 'dependencies': [],
      \ 'superordinates': [],
      \}
function! s:argument.get_choices(opts) abort " {{{
  if s:P.is_funcref(self.choices)
    let candidates = self.choices(deepcopy(a:opts))
  elseif s:P.is_list(self.choices)
    let candidates = self.choices
  else
    let candidates = []
  endif
  return candidates
endfunction " }}}

let s:parser = {
      \ 'hooks': {},
      \ 'arguments': {},
      \ '_arguments': [],
      \ 'positional': [],
      \ 'required': [],
      \ 'alias': {},
      \}
function! s:parser._call_hook(name, ...) abort " {{{
  if has_key(self.hooks, a:name)
    call call(self.hooks[a:name], a:000, self)
  endif
endfunction " }}}
function! s:parser.add_argument(...) abort " {{{
  let argument = call('s:new_argument', a:000)
  " register argument
  let self.arguments[argument.name] = argument
  call add(self._arguments, argument)
  " register positional
  if argument.positional
    call add(self.positional, argument.name)
  endif
  " register required
  if argument.required
    call add(self.required, argument.name)
  endif
  " register alias
  if !empty(argument.alias)
    let self.alias[argument.alias] = argument.name
  endif
  " return an argument instance for further manipulation
  return argument
endfunction " }}}
function! s:parser.get_conflicted_arguments(name, opts) abort " {{{
  let conflicts = self.arguments[a:name].conflicts
  if empty(conflicts)
    return []
  endif
  let conflicts_pattern = printf('\v^%%(%s)$', join(conflicts, '|'))
  return filter(keys(a:opts), 'v:val =~# conflicts_pattern')
endfunction " }}}
function! s:parser.get_superordinate_arguments(name, opts) abort " {{{
  let superordinates = self.arguments[a:name].superordinates
  if empty(superordinates)
    return []
  endif
  let superordinates_pattern = printf('\v^%%(%s)$', join(superordinates, '|'))
  return filter(keys(a:opts), 'v:val =~# superordinates_pattern')
endfunction " }}}
function! s:parser.get_missing_dependencies(name, opts) abort " {{{
  let dependencies = self.arguments[a:name].dependencies
  if empty(dependencies)
    return []
  endif
  let exists_pattern = printf('\v^%%(%s)$', join(keys(a:opts), '|'))
  return filter(dependencies, 'v:val !~# exists_pattern')
endfunction " }}}
function! s:parser.get_positional_arguments() abort " {{{
  return deepcopy(self.positional)
endfunction " }}}
function! s:parser.get_optional_arguments() abort " {{{
  return map(filter(values(self.arguments), '!v:val.positional'), 'v:val.name')
endfunction " }}}
function! s:parser.get_optional_argument_aliases() abort " {{{
  return keys(self.alias)
endfunction " }}}
function! s:parser.parse(bang, range, ...) abort " {{{
  let cmdline = get(a:000, 0, '')
  let args = s:P.is_string(cmdline) ? s:splitargs(cmdline) : cmdline
  let opts = self._parse_args(args, extend({
        \ '__bang__': s:P.is_string(a:bang) ? a:bang == '!' : a:bang,
        \ '__range__': a:range,
        \}, get(a:000, 1, {})))
  call self._regulate_opts(opts)
  " to avoid exception in validation
  if self.auto_help && get(opts, 'help', 0)
    redraw | echo self.help()
    return {}
  endif
  call self._call_hook('pre_validate', opts)
  try
    call self._validate_opts(opts)
  catch /vital: ArgumentParser:/
    echohl WarningMsg
    redraw
    echo printf('%s validation error:', self.name)
    echohl None
    echo substitute(v:exception, '^vital: ArgumentParser: ', '', '')
    if self.auto_help
      echo printf("See a command usage by ':%s -h'",
            \ self.name,
            \)
    endif
    return {}
  endtry
  call self._call_hook('post_validate', opts)
  return opts
endfunction " }}}
" @vimlint(EVL104, 1, l:name)
" @vimlint(EVL101, 1, l:value)
function! s:parser._parse_args(args, ...) abort " {{{
  let opts = extend({
        \ '__unknown__': [],
        \ '__args__': [],
        \}, get(a:000, 0, {}))
  let opts.__args__ = extend(opts.__args__, a:args)
  let length = len(opts.__args__)
  let cursor = 0
  let arguments_pattern = printf('\v^%%(%s)$', join(keys(self.arguments), '|'))
  let positional_length = len(self.positional)
  let positional_cursor = 0
  while cursor < length
    let cword = opts.__args__[cursor]
    let nword = (cursor+1 < length) ? opts.__args__[cursor+1] : ''
    if cword ==# '--'
      let cursor += 1
      let opts.__terminated__ = 1
      break
    elseif cword =~# '^--\?'
      " optional argument
      let m = matchlist(cword, '\v^\-\-?([^=]+|)%(\=(.*)|)')
      let name = get(self.alias, m[1], m[1])
      if name =~# arguments_pattern
        if !empty(m[2])
          let opts[name] = s:strip_quotes(m[2])
        elseif get(self, 'enable_positional_assign', 0) && !empty(nword) && nword !~# '^--\?'
          let opts[name] = s:strip_quotes(nword)
          let cursor += 1
        else
          let opts[name] = get(self.arguments[name], 'on_default', 1)
        endif
      elseif substitute(name, '^no-', '', '') =~# arguments_pattern
        let name = substitute(name, '^no-', '', '')
        if self.arguments[name].deniable
          let opts[name] = 0
        else
          call add(opts.__unknown__, cword)
        endif
      else
        call add(opts.__unknown__, cword)
      endif
    else
      if positional_cursor < positional_length
        let name = self.positional[positional_cursor]
        let opts[name] = s:strip_quotes(cword)
        let positional_cursor += 1
      else
        let name = ''
        call add(opts.__unknown__, cword)
      endif
    endif
    " terminal check
    if !empty(name) && get(self.arguments, name, { 'terminal': 0 }).terminal
      let cursor += 1
      let opts.__terminated__ = 1
      break
    else
      let cursor += 1
    endif
  endwhile
  " assign remaining args as unknown
  let opts.__unknown__ = extend(
        \ opts.__unknown__,
        \ opts.__args__[ cursor : ],
        \)
  return opts
endfunction " @vimlint(EVL104, 0, l:name) @vimlint(EVL101, 0, l:value) }}}
function! s:parser._regulate_opts(opts) abort " {{{
  " assign default values
  let exists_pattern = printf('\v^%%(%s)$', join(keys(a:opts), '|'))
  for argument in values(self.arguments)
    if !empty(argument.default) && argument.name !~# exists_pattern
      let a:opts[argument.name] = argument.default
    endif
  endfor
endfunction " }}}
function! s:parser._validate_opts(opts) abort " {{{
  if self.validate_required
    call self._validate_required(a:opts)
  endif
  if self.validate_types
    call self._validate_types(a:opts)
  endif
  if self.validate_conflicts
    call self._validate_conflicts(a:opts)
  endif
  if self.validate_superordinates
    call self._validate_superordinates(a:opts)
  endif
  if self.validate_dependencies
    call self._validate_dependencies(a:opts)
  endif
  if self.validate_pattern
    call self._validate_pattern(a:opts)
  endif
endfunction " }}}
function! s:parser._validate_required(opts) abort " {{{
  let exists_pattern = printf('\v^%%(%s)$', join(keys(a:opts), '|'))
  for name in self.required
    if name !~# exists_pattern
      throw printf(
            \ 'vital: ArgumentParser: Argument "%s" is required but not specified.',
            \ name,
            \)
    endif
  endfor
endfunction " }}}
function! s:parser._validate_types(opts) abort " {{{
  for [name, value] in items(a:opts)
    if name !~# '\v^__.*__$'
      let type = self.arguments[name].type
      if type == s:const.types.value && s:P.is_number(value)
        throw printf(
              \ 'vital: ArgumentParser: Argument "%s" is VALUE argument but no value is specified.',
              \ name,
              \)
      elseif type == s:const.types.switch && s:P.is_string(value)
        throw printf(
              \ 'vital: ArgumentParser: Argument "%s" is SWITCH argument but "%s" is specified.',
              \ name,
              \ value,
              \)
      elseif type == s:const.types.choice
        let candidates = self.arguments[name].get_choices(a:opts)
        let pattern = printf('\v^%%(%s)$', join(candidates, '|'))
        if s:P.is_number(value)
          throw printf(
                \ 'vital: ArgumentParser: Argument "%s" is CHOICE argument but no value is specified.',
                \ name,
                \)
        elseif value !~# pattern
          throw printf(
                \ 'vital: ArgumentParser: Argument "%s" is CHOICE argument but an invalid value "%s" is specified.',
                \ name,
                \ value,
                \)
        endif
      endif
    endif
    silent! unlet name
    silent! unlet value
  endfor
endfunction " }}}
function! s:parser._validate_conflicts(opts) abort " {{{
  for [name, value] in items(a:opts)
    if name !~# '\v^__.*__$'
      let conflicts = self.get_conflicted_arguments(name, a:opts)
      if !empty(conflicts)
        throw printf(
              \ 'vital: ArgumentParser: Argument "%s" conflicts with an argument "%s"',
              \ name,
              \ conflicts[0],
              \)
      endif
    endif
    silent! unlet name
    silent! unlet value
  endfor
endfunction " }}}
function! s:parser._validate_superordinates(opts) abort " {{{
  for [name, value] in items(a:opts)
    if name !~# '\v^__.*__$'
      let superordinates = self.get_superordinate_arguments(name, a:opts)
      if !empty(self.arguments[name].superordinates) && empty(superordinates)
        throw printf(
              \ 'vital: ArgumentParser: No superordinate argument(s) of "%s" is specified',
              \ name,
              \)
      endif
    endif
    silent! unlet name
    silent! unlet value
  endfor
endfunction " }}}
function! s:parser._validate_dependencies(opts) abort " {{{
  for [name, value] in items(a:opts)
    if name !~# '\v^__.*__$'
      let dependencies = self.get_missing_dependencies(name, a:opts)
      if !empty(dependencies)
        throw printf(
              \ 'vital: ArgumentParser: Argument "%s" is required for an argument "%s" but missing',
              \ dependencies[0],
              \ name,
              \)
      endif
    endif
    silent! unlet name
    silent! unlet value
  endfor
endfunction " }}}
function! s:parser._validate_pattern(opts) abort " {{{
  for [name, value] in items(a:opts)
    if name !~# '\v^__.*__$'
      let pattern = self.arguments[name].pattern
      if !empty(pattern) && value !~# pattern
        throw printf(
              \ 'vital: ArgumentParser: A value of argument "%s" does not follow a specified pattern "%s".',
              \ name,
              \ pattern,
              \)
      endif
    endif
    silent! unlet name
    silent! unlet value
  endfor
endfunction " }}}
function! s:parser.complete(arglead, cmdline, cursorpos, ...) abort " {{{
  let cmdline = substitute(a:cmdline, '\v^[^ ]+\s', '', '')
  let cmdline = substitute(cmdline, '\v[^ ]+$', '', '')
  let opts = extend(
        \ self._parse_args(s:splitargs(cmdline)),
        \ get(a:000, 0, {}),
        \)
  call self._call_hook('pre_complete', opts)
  if get(opts, '__terminated__')
    if s:P.is_funcref(get(self, 'complete_unknown'))
      let candidates = self.complete_unknown(
            \ a:arglead,
            \ cmdline,
            \ a:cursorpos,
            \ opts,
            \)
    else
      let candidates = []
    endif
  elseif empty(a:arglead)
    let candidates = []
    let candidates += self._complete_positional_argument_value(
          \ a:arglead,
          \ cmdline,
          \ a:cursorpos,
          \ opts,
          \)
    let candidates += self._complete_optional_argument(
          \ a:arglead,
          \ cmdline,
          \ a:cursorpos,
          \ opts,
          \)
  elseif a:arglead =~# '\v^\-\-?[^=]+\='
    let candidates = self._complete_optional_argument_value(
          \ a:arglead,
          \ cmdline,
          \ a:cursorpos,
          \ opts,
          \)
  elseif a:arglead =~# '\v^\-\-?'
    let candidates = self._complete_optional_argument(
          \ a:arglead,
          \ cmdline,
          \ a:cursorpos,
          \ opts,
          \)
  else
    let candidates = self._complete_positional_argument_value(
          \ a:arglead,
          \ cmdline,
          \ a:cursorpos,
          \ opts,
          \)
  endif
  call self._call_hook('post_complete', candidates, opts)
  return candidates
endfunction " }}}
function! s:parser._complete_optional_argument_value(arglead, cmdline, cursorpos, opts) abort " {{{
  let m = matchlist(a:arglead, '\v^\-\-?([^=]+)\=(.*)')
  let name = m[1]
  let value = m[2]
  if has_key(self.arguments, name)
    let candidates = self.arguments[name].complete(
          \ value, a:cmdline, a:cursorpos, {
          \   'argument': self.arguments[name],
          \   'opts': a:opts,
          \})
  else
    let candidates = []
  endif
  call self._call_hook('post_complete_argument_value', candidates, a:opts)
  return candidates
endfunction " }}}
function! s:parser._complete_optional_argument(arglead, cmdline, cursorpos, opts) abort " {{{
  let candidates = []
  for argument in values(self.arguments)
    if has_key(a:opts, argument.name) || argument.positional
      continue
    elseif !empty(argument.conflicts) && !empty(self.get_conflicted_arguments(argument.name, a:opts))
      continue
    elseif !empty(argument.superordinates) && empty(self.get_superordinate_arguments(argument.name, a:opts))
      continue
    endif
    if '--' . argument.name =~# '^' . a:arglead && len(argument.name) > 1
      call add(candidates, '--' . argument.name)
    elseif '-' . argument.name =~# '^' . a:arglead && len(argument.name) == 1
      call add(candidates, '-' . argument.name)
    endif
    if !empty(argument.alias) && '-' . argument.alias =~# '^' . a:arglead
      call add(candidates, '-' . argument.alias)
    endif
  endfor
  call self._call_hook('post_complete_optional_argument', candidates, a:opts)
  return candidates
endfunction " }}}
function! s:parser._complete_positional_argument_value(arglead, cmdline, cursorpos, opts) abort " {{{
  let candidates = []
  let npositional = 0
  for argument in values(self.arguments)
    if argument.positional && has_key(a:opts, argument.name)
      let npositional += 1
    endif
  endfor
  if !empty(a:arglead) && npositional > 0
    let npositional -= 1
  endif
  let cpositional = get(self.arguments, get(self.positional, npositional), {})
  if !empty(cpositional)
    let candidates = cpositional.complete(
          \ a:arglead, a:cmdline, a:cursorpos, {
          \   'argument': cpositional,
          \   'opts': a:opts,
          \})
  endif
  call self._call_hook('post_complete_positional_argument', candidates, a:opts)
  return candidates
endfunction " }}}

function! s:parser.help() abort " {{{
  let definitions  = { 'positional': [], 'optional': [] }
  let descriptions = { 'positional': [], 'optional': [] }
  let commandlines = { 'positional': [], 'optional': [] }
  for argument in self._arguments
    if argument.positional
      let [definition, description] = self._help_positional_argument(argument)
      call add(definitions.positional, definition)
      call add(descriptions.positional, description)
      if argument.required
        call add(commandlines.positional, definition)
      else
        call add(commandlines.positional, printf('[%s]', definition))
      endif
    else
      let [definition, description] = self._help_optional_argument(argument)
      let partial_definition = substitute(definition, '\v^%([ ]+|\-.,\s)', '', '')
      call add(definitions.optional, definition)
      call add(descriptions.optional, description)
      if argument.required
        call add(commandlines.optional, printf('%s', partial_definition))
      else
        call add(commandlines.optional, printf('[%s]', partial_definition))
      endif
    endif
  endfor
  " find a length of the longest definition
  let max_length = len(s:L.max_by(definitions.positional + definitions.optional, 'len(v:val)'))
  let buflines = []
  call add(buflines, printf(
        \ ':%s', join(filter([
        \ self.name,
        \ join(commandlines.positional),
        \ join(commandlines.optional),
        \ empty(self.description_unknown)
        \   ? ''
        \   : printf('-- %s', self.description_unknown),
        \], '!empty(v:val)'))))
  call add(buflines, '')
  call add(buflines, self.description)
  if !empty(self.positional)
    call add(buflines, '')
    call add(buflines, 'Positional arguments:')
    for [definition, description] in s:L.zip(definitions.positional, descriptions.positional)
      let _definitions = split(definition, "\n")
      let _descriptions = split(description, "\n")
      let n = max([len(_definitions), len(_descriptions)])
      let i = 0
      while i < n
        let _definition = get(_definitions, i, '')
        let _description = get(_descriptions, i, '')
        call add(buflines, printf(
              \ printf("  %%-%ds  %%s", max_length),
              \ _definition,
              \ _description,
              \))
        let i += 1
      endwhile
    endfor
  endif
  call add(buflines, "")
  call add(buflines, 'Optional arguments:')
  for [definition, description] in s:L.zip(definitions.optional, descriptions.optional)
    let _definitions = split(definition, "\n")
    let _descriptions = split(description, "\n")
    let n = max([len(_definitions), len(_descriptions)])
    let i = 0
    while i < n
      let _definition = get(_definitions, i, '')
      let _description = get(_descriptions, i, '')
      call add(buflines, printf(
            \ printf("  %%-%ds  %%s", max_length),
            \ _definition,
            \ _description,
            \))
      let i += 1
    endwhile
  endfor
  return join(buflines, "\n")
endfunction " }}}
function! s:parser._help_optional_argument(arg) abort " {{{
  if empty(a:arg.alias)
    let alias = '    '
  else
    let alias = printf('-%s, ', a:arg.alias)
  endif
  if a:arg.deniable
    let deniable = '[no-]'
  else
    let deniable = ''
  endif
  if a:arg.type == s:const.types.any
    let definition = printf(
          \ '%s--%s%s[=%s]',
          \ alias,
          \ deniable,
          \ a:arg.name,
          \ toupper(a:arg.name)
          \)
  elseif a:arg.type == s:const.types.value
    let definition = printf(
          \ '%s--%s%s=%s',
          \ alias,
          \ deniable,
          \ a:arg.name,
          \ toupper(a:arg.name)
          \)
  elseif a:arg.type == s:const.types.choice
    let definition = printf(
          \ '%s--%s%s={%s}',
          \ alias,
          \ deniable,
          \ a:arg.name,
          \ toupper(a:arg.name)
          \)
  else
    let definition = printf(
          \ '%s--%s%s',
          \ alias,
          \ deniable,
          \ a:arg.name,
          \)
  endif
  let description = join(a:arg.description, "\n")
  if a:arg.required
    let description = printf('%s (*)', description)
  endif
  return [definition, description]
endfunction " }}}
function! s:parser._help_positional_argument(arg) abort " {{{
  let definition = printf('%s', a:arg.name)
  let description = join(a:arg.description, "\n")
  if a:arg.required
    let description = printf('%s (*)', description)
  endif
  return [definition, description]
endfunction " }}}

let &cpo = s:save_cpo
unlet s:save_cpo
"vim: sts=2 sw=2 smarttab et ai textwidth=0 fdm=marker