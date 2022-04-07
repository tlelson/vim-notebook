" Vim global plugin for executing code from inside a file
" Last Change:	2020 Jul 07
" Maintainer:	Tim Elson <tpj800@gmail.com>
" License:	This file is placed in the public domain.


command -nargs=? NotebookTerminal call notebook#terminal_start(<q-args>, <q-mods>)

command -range NotebookRunCell call notebook#run_cell("<line1>", "<line2>")
if !hasmapto(':NotebookRunCell')
	nnoremap <Leader>r :NotebookRunCell <CR>
	vnoremap <Leader>r :NotebookRunCell <CR>
endif

command -range NotebookClear call notebook#clear_term()
if !hasmapto(':NotebookClear')
	nnoremap <C-l> :NotebookClear <CR>
	vnoremap <C-l> :NotebookClear <CR>
endif

command -range NotebookQuit call notebook#quit_term()
if !hasmapto(':NotebookQuit')
	nnoremap <Leader>q :NotebookQuit <CR>
	vnoremap <Leader>q :NotebookQuit <CR>
endif

" Neovim messes with the standard vim mappings. Restore them.
" Yes, it prevents use of the bash shortcut but its standard.
if has('nvim')
	:tnoremap <C-w>h <C-\><C-N><C-w>h
	:tnoremap <C-w>j <C-\><C-N><C-w>j
	:tnoremap <C-w>k <C-\><C-N><C-w>k
	:tnoremap <C-w>l <C-\><C-N><C-w>l

	" This means that the split is in normal mode when its left. Change this
	" so that it is always in insert mode when we enter.
	autocmd BufEnter notebookterm-* startinsert
endif
