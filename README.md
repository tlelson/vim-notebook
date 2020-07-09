# Vim-Notebook

Vim-Notebook allows for rapid code execution of line segments from within a vim buffer without switching to the shell.

**How is this different from tmux + vim ?**

With default vim and tmux or another terminal you might write in vim, then copy the command to run into your clipboard then switch context to the terminal and paste the line.  With vim-notebook you execute the line or visual selection quickly from vim and observe the results without leaving your current buffer.

## Pre-requisites

You should know vim basics such as changing focus between vim splits, entering and exiting insert mode.

> Note that `<Esc>` does not exit insert mode in a vim terminal but `<C-\><C-n>` does.  Personally, I have remapped this pattern to `<Esc>` in terminal mode with `tnoremap <Esc> <C-\><C-n>`.

You should also know what your _mapleader_ is.  If you don't, use the command `:set mapleader?` to print it.  If it errors it is the vim default, backslash character `\`.

## Tutorial

Here is some code you can try out.  Open this file in vim:

Visual highlight the following lines and run the command `:RunCell`

```bash
TMP_PATH=/tmp
find $TMP_PATH -name '*log' 2>&1 | head -n 4

ls ~
```

Now go up to the line with `ls ~` and modify it in someway, for example add `-a`.  Run it again.

Change to the terminal split (`<C-w>j`) and close it with `exit` or similar.

Now open up a python shell with `:OpenTerminal python`.

### Using the key mapping

`:RunCell` is mapped to `<leader>r` on a selection or on an individual line, without a selection. So position your cursor on the first line of python and hit `<leader>r` 4 times.

```python
import json 

d = json.loads('{"name": "flojo"}')
d['name']
```

4 lines will go to the shell including the blank one.  The result should be displayed `'flojo'` without leaving your current buffer.

## File-type Recognition

If the above python code was in a file that vim recognised as `filetype=python`, `:RunCell` (or the mapped keys) will automatically start an `ipython` shell to run the code.  If `ipython` is not found, it will start a `python` shell. If no suitable shells can be found for the _filetype_, the default system shell will be used.

You can start any shell you want with `:OpenTerminal <shell name>`, e.g `:OpenTerminal node` .  Once the shell is open, selected code will go to it for execution without changing focus.  Having multiple shell types open is not supported by Vim-Notebook.

**N.B If you move to the shell buffer and exit insert mode. Any new lines you sent to it with `:RunCell` will not be displayed until the buffer is back in insert mode (I'm going to fix this.))**

By default the terminal will start below the current file but if you want to start it to the right, provide the standard vim modifier `vertical`. E.g `:vert OpenTerminal bash`. If the default system shell is `bash` then this is equivalent to `vert OpenTerminal`. 
