" Vim global plugin for executing code from inside a file
" Last Change:	2020 Jul 07
" Maintainer:	Tim Elson <tpj800@gmail.com>
" License:	This file is placed in the public domain.


" Define shell names for filetypes. Order sets the priority
" TODO: Allow user settings to augment this map
let s:shell = { 'python' : ['ipython', 'python'], 'javascript': ['node'] }
let s:shell_args = { 'ipython': ' --no-autoindent'}

function! s:safe_open_term(mods) abort
	let term_bufnr = -1

	" Use default if can't guess
	if has_key(s:shell, &filetype) == 0
		return s:unsafe_term('', a:mods)
	endif

	let shells = get(s:shell, &filetype, [''])
	for shell in get(s:shell, &filetype, [''])
		if executable(shell) > 0
			return s:unsafe_term(shell, a:mods)
		endif
	endfor

	call s:echoError("No suitable shell found for '" . &filetype. " from: " . join(shells, ", "))
	return term_bufnr
endfunction

" Sends the currently selected visual selection to the terminal
function! notebook#run_cell(startline, endline) abort
	" 0. Check if shell bufer open, if not open one
	" if multiple shells open → error message
	let term_bufnr = bufnr("notebookterm-")
	if term_bufnr ==# -1
		let term_bufnr = s:safe_open_term('')
	endif

	" 1. Get range of text to send to terminal
	let raw = join(getline(a:startline, a:endline), "\n") . "\n"

	" 2. Copy text in selected range to variable
	" How to stop text appearing before shell loads ?
	" TODO: Check if terminal is in INSERT mode, if not, make it
	call term_sendkeys(term_bufnr, raw)
	call term_wait(term_bufnr)
	normal j
endfunction

" Have to check that `shell` exists first because even if `bash`
" doesn't exist it will open a terminal and use it as a command.
" In this case, the terminal will exist and will get a buffer.
function! s:unsafe_term(shell, mods) abort
	let mods = split(a:mods)

	let horisontal_split = 1
	for mod in mods
		if mod ==? 'vertical'
			let horisontal_split = 0
		endif
	endfor

	" Work out terminal command
	let term_cmd = " belowright terminal ++close "
	if horisontal_split
		let term_cmd = term_cmd . "++rows=15 "
	endif

	" Work out shell command - allow args
	let shell_cmd = a:shell
	if has_key(s:shell_args, a:shell) != 0
	    let shell_cmd = shell_cmd . ' '. s:shell_args[a:shell]
	endif

	" open shell
	silent execute a:mods . term_cmd . shell_cmd
	" Set buffer name so we can find it again
	let bufname = "notebookterm-" . a:shell
	execute "file! " . bufname
	" Jump back to previous split
	execute "normal! \<C-w>p"
	"return bufnr("$")
	return bufnr(bufname) " -1 if not. (this never happens unfortunately)
endfunction

function! notebook#terminal_start(shell, mods) abort
	let term_bufnr = -1
	if a:shell !=# '' && executable(a:shell) < 1
		call s:echoError("Failed to find shell: " . a:shell)
		return term_bufnr
	endif

	" Close existing terminals before opening a new one.
	let term_bufnr = bufnr("notebookterm-")
	if term_bufnr >= 0
		execute "bdelete! " . term_bufnr
	endif

	return s:unsafe_term(a:shell, a:mods)
endfunction

" Stole this function from NERDTree
fun! s:echoError(msg)
    echohl errormsg
    "call s:echo(a:msg)
    echo a:msg
    echohl normal
endf

" TODO:
"  - Make `RunCell` put the terminal into insert mode before executing code

" Extension bits
" - detect shell type from code (first filetype setting then maybe advanced
"   analysis?!)

