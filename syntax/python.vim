" Vim syntax file
" Language:	Python
" Maintainer:	Dmitry Vasiliev <dima@hlabs.spb.ru>
" URL:		http://www.hlabs.spb.ru/vim/python.vim
" Last Change:	$Date: 2003/10/13 07:33:29 $
" Filenames:	*.py
" $Revision: 1.17 $
"
" Based on python.vim (from Vim 6.1 distribution)
" by Neil Schemenauer <nas@python.ca>
"
" Options:
" For highlighted builtin functions:
"
"    let python_highlight_builtins = 1
"
" For highlighted standard exceptions:
"
"    let python_highlight_exceptions = 1
"
" For highlighted string formatting:
"
"    let python_highlight_string_formatting = 1
"
" If you want all possible Python highlighting:
"
"    let python_highlight_all = 1
"
" TODO: Check more errors?

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if exists("python_highlight_all")
  let python_highlight_builtins = 1
  let python_highlight_exceptions = 1
  let python_highlight_string_formatting = 1
endif

" Keywords
syn keyword pythonStatement	break continue del
syn keyword pythonStatement	exec return
syn keyword pythonStatement	pass print raise
syn keyword pythonStatement	global assert
syn keyword pythonStatement	lambda yield
syn keyword pythonStatement	def class nextgroup=pythonFunction skipwhite
syn match   pythonFunction	"\h\w*" contained
syn keyword pythonRepeat	for while
syn keyword pythonConditional	if elif else
syn keyword pythonImport	import from as
syn keyword pythonException	try except finally
syn keyword pythonOperator	and in is not or

" Comments
syn match   pythonComment	"#.*$" display contains=pythonTodo,pythonCoding,pythonRun
syn match   pythonRun		"\%^#!.*$" contained
syn match   pythonCoding	"\%^.*\(\n.*\)\?#.*coding[:=]\s*[0-9A-Za-z-_.]\+.*$" contained
syn keyword pythonTodo		TODO FIXME XXX contained

" Erroneous characters that cannont be in a python program
syn match pythonError		"[@$?]" display
" Mixing spaces and tabs is bad
syn match pythonIndentError	"^\s*\(\t \| \t\)\s*" display

" Strings
syn region pythonString		start=+'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ contains=pythonEscape,pythonEscapeError
syn region pythonString		start=+"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ contains=pythonEscape,pythonEscapeError
syn region pythonString		start=+"""+ end=+"""+ contains=pythonEscape,pythonEscapeError
syn region pythonString		start=+'''+ end=+'''+ contains=pythonEscape,pythonEscapeError

syn match  pythonEscape		+\\[abfnrtv'"\\]+ display contained
syn match  pythonEscapeError	+\\[^abfnrtv'"\\]+ display contained
syn match  pythonEscape		"\\\o\o\=\o\=" display contained
syn match  pythonEscapeError	"\\\o\{,2}[89]" display contained
syn match  pythonEscape		"\\x\x\{2}" display contained
syn match  pythonEscapeError	"\\x\x\=\X" display contained
syn match  pythonEscape		"\\$"

" Unicode strings
syn region pythonUniString	start=+[uU]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ contains=pythonEscape,pythonUniEscape,pythonEscapeError,pythonUniEscapeError
syn region pythonUniString	start=+[uU]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ contains=pythonEscape,pythonUniEscape,pythonEscapeError,pythonUniEscapeError
syn region pythonUniString	start=+[uU]"""+ end=+"""+ contains=pythonEscape,pythonUniEscape,pythonEscapeError,pythonUniEscapeError
syn region pythonUniString	start=+[uU]'''+ end=+'''+ contains=pythonEscape,pythonUniEscape,pythonEscapeError,pythonUniEscapeError

syn match  pythonUniEscape	"\\u\x\{4}" display contained
syn match  pythonUniEscapeError	"\\u\x\{,3}\X" display contained
syn match  pythonUniEscape	"\\U\x\{8}" display contained
syn match  pythonUniEscapeError	"\\U\x\{,7}\X" display contained
syn match  pythonUniEscape	"\\N{[A-Z ]\+}" display contained
syn match  pythonUniEscapeError	"\\N{[^A-Z ]\+}" display contained

" Raw strings
syn region pythonRawString	start=+[rR]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ contains=pythonRawEscape
syn region pythonRawString	start=+[rR]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ contains=pythonRawEscape
syn region pythonRawString	start=+[rR]"""+ end=+"""+
syn region pythonRawString	start=+[rR]'''+ end=+'''+

syn match pythonRawEscape	+\\['"]+ display transparent contained

" Unicode raw strings
syn region pythonUniRawString	start=+[uU][rR]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ contains=pythonRawEscape,pythonUniRawEscape,pythonUniRawEscapeError
syn region pythonUniRawString	start=+[uU][rR]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ contains=pythonRawEscape,pythonUniRawEscape,pythonUniRawEscapeError
syn region pythonUniRawString	start=+[uU][rR]"""+ end=+"""+ contains=pythonUniRawEscape,pythonUniRawEscapeError
syn region pythonUniRawString	start=+[uU][rR]'''+ end=+'''+ contains=pythonUniRawEscape,pythonUniRawEscapeError

syn match  pythonUniRawEscape		"\([^\\]\(\\\\\)*\)\@<=\\u\x\{4}" display contained
syn match  pythonUniRawEscapeError	"\([^\\]\(\\\\\)*\)\@<=\\u\x\{,3}\X" display contained

if exists("python_highlight_string_formatting")
  " String formatting
  syn match pythonStrFormat	"%\(([^)]\+)\)\=[-#0 +]\=\d*\(\.\d\+\)\=[hlL]\=[diouxXeEfFgGcrs%]" contained containedin=pythonString,pythonUniString,pythonRawString
  syn match pythonStrFormat	"%[-#0 +]\=\(\*\|\d\+\)\=\(\.\(\*\|\d\+\)\)\=[hlL]\=[diouxXeEfFgGcrs%]" contained containedin=pythonString,pythonUniString,pythonRawString
endif

" Numbers (ints, longs, floats, complex)
syn match   pythonNumber	"\<0[xX]\x\+[lL]\=\>" display
syn match   pythonNumber	"\<\d\+[lLjJ]\=\>" display
syn match   pythonFloat		"\.\d\+\([eE][+-]\=\d\+\)\=[jJ]\=\>" display
syn match   pythonFloat		"\<\d\+[eE][+-]\=\d\+[jJ]\=\>" display
syn match   pythonFloat		"\<\d\+\.\d*\([eE][+-]\=\d\+\)\=[jJ]\=" display
syn match   pythonOctalError	"\<0\o*[89]\d*[lLjJ]\=\>" display

if exists("python_highlight_builtins")
  " Builtin functions, types and objects, not really part of the syntax
  syn keyword pythonBuiltinObj	True False Ellipsis None NotImplemented

  syn keyword pythonBuiltinFunc	__import__ abs apply
  syn keyword pythonBuiltinFunc	basestring bool buffer callable
  syn keyword pythonBuiltinFunc	chr classmethod cmp coerce compile complex
  syn keyword pythonBuiltinFunc	delattr dict dir divmod enumerate eval
  syn keyword pythonBuiltinFunc	execfile file filter float getattr globals
  syn keyword pythonBuiltinFunc	hasattr hash hex id input int intern isinstance
  syn keyword pythonBuiltinFunc	issubclass iter len list locals long map max
  syn keyword pythonBuiltinFunc	min object oct open ord pow property range
  syn keyword pythonBuiltinFunc	raw_input reduce reload repr round setattr
  syn keyword pythonBuiltinFunc	slice staticmethod str sum super tuple
  syn keyword pythonBuiltinFunc	type unichr unicode vars xrange zip
endif

if exists("python_highlight_exceptions")
  " Builtin exceptions and warnings
  syn keyword pythonExClass	Exception StandardError ArithmeticError
  syn keyword pythonExClass	LookupError EnvironmentError

  syn keyword pythonExClass	AssertionError AttributeError EOFError
  syn keyword pythonExClass	FloatingPointError IOError ImportError
  syn keyword pythonExClass	IndexError KeyError KeyboardInterrupt
  syn keyword pythonExClass	MemoryError NameError NotImplementedError
  syn keyword pythonExClass	OSError OverflowError ReferenceError
  syn keyword pythonExClass	RuntimeError StopIteration SyntaxError
  syn keyword pythonExClass	IndentationError TabError
  syn keyword pythonExClass	SystemError SystemExit TypeError
  syn keyword pythonExClass	UnboundLocalError UnicodeError
  syn keyword pythonExClass	UnicodeEncodeError UnicodeDecodeError
  syn keyword pythonExClass	UnicodeTranslateError ValueError
  syn keyword pythonExClass	WindowsError ZeroDivisionError

  syn keyword pythonExClass	Warning UserWarning DeprecationWarning
  syn keyword pythonExClass	PendingDepricationWarning SyntaxWarning
  syn keyword pythonExClass	RuntimeWarning FutureWarning
endif

" This is fast but code inside triple quoted strings screws it up. It
" is impossible to fix because the only way to know if you are inside a
" triple quoted string is to start from the beginning of the file. If
" you have a fast machine you can try uncommenting the "sync minlines"
" and commenting out the rest.
syn sync match pythonSync grouphere NONE "):$"
syn sync maxlines=200
"syn sync minlines=2000

if version >= 508 || !exists("did_python_syn_inits")
  if version <= 508
    let did_python_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink pythonStatement	Statement
  HiLink pythonImport		Statement
  HiLink pythonFunction		Function
  HiLink pythonConditional	Conditional
  HiLink pythonRepeat		Repeat
  HiLink pythonException	Exception
  HiLink pythonOperator		Operator

  HiLink pythonComment		Comment
  HiLink pythonCoding		Special
  HiLink pythonRun		Special
  HiLink pythonTodo		Todo

  HiLink pythonError		Error
  HiLink pythonIndentError	Error

  HiLink pythonString		String
  HiLink pythonUniString	String
  HiLink pythonRawString	String
  HiLink pythonUniRawString	String

  HiLink pythonEscape			Special
  HiLink pythonEscapeError		Error
  HiLink pythonUniEscape		Special
  HiLink pythonUniEscapeError		Error
  HiLink pythonUniRawEscape		Special
  HiLink pythonUniRawEscapeError	Error

  if exists("python_highlight_string_formatting")
    HiLink pythonStrFormat	Special
  endif

  HiLink pythonNumber		Number
  HiLink pythonFloat		Float
  HiLink pythonOctalError	Error

  if exists("python_highlight_builtins")
    HiLink pythonBuiltinObj	Structure
    HiLink pythonBuiltinFunc	Function
  endif

  if exists("python_highlight_exceptions")
    HiLink pythonExClass	Structure
  endif

  delcommand HiLink
endif

let b:current_syntax = "python"
