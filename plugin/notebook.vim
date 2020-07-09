" Vim global plugin for executing code from inside a file
" Last Change:	2020 Jul 07
" Maintainer:	Tim Elson <tpj800@gmail.com>
" License:	This file is placed in the public domain.


command -nargs=? NotebookTerminal call notebook#terminal_start(<q-args>, <q-mods>)

command -range NotebookRunCell call notebook#run_cell("<line1>", "<line2>")
if !hasmapto(':NotebookRunCell')
	nnoremap <Leader>r :NotebookRunCell "<CR>
	vnoremap <Leader>r :NotebookRunCell "<CR>
endif

