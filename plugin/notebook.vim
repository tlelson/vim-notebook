" Test Function
"
function! TestFunc(args, mods)
	echom "args:" . a:args
	echom "mods:" . a:mods
	"for arg in a:args
		"echom arg
	"endfor
	"echom "mods:"
	for mod in split(a:mods)
		echom mod
	endfor
endfunction

command -nargs=? TestCom call TestFunc(<q-args>, <q-mods>)

" Sends the currently selected visual selection to the terminal
function! RunCell(startline, endline)
	" 0. Check if shell bufer open, if not open one
	" TODO: Try this
	let term_bufnr = bufnr("notebookterm-")
	if term_bufnr ==# -1
		term_bufnr = OpenTerminal('bash')
	endif

	" 1. Get range of text to send to terminal
	let raw = join(getline(a:startline, a:endline), "\n") . "\n"

	" 2. Copy text in selected range to variable
	call term_sendkeys(term_bufnr, raw)
	call term_wait(term_bufnr)
endfunction

command -range RunCell call RunCell("<line1>", "<line2>")

function! OpenTerminal(shell, mods)
	let shell = a:shell
	let mods = split(a:mods)

	if shell ==? ""
		let shell = 'bash'
	endif

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

	" open shell
	execute a:mods . term_cmd . shell 
	" Set buffer name so we can find it again
	let bufname = "notebookterm-" . shell
	execute "file! " . bufname
	" Jump back to previous split
	execute "normal! \<C-w>p"  
	return bufnr("$")
endfunction

command -nargs=? OpenTerminal call OpenTerminal(<q-args>, <q-mods>)


" TODO:
"  - Map RunCell to Ctrl-<Enter>
"  - Make sure terminal auto open works for bash

" Extension bits
" - detect shell type from code (first filetype setting then maybe advanced
"   analysis?!)

