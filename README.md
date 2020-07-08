# Vim-Notebook

Vim-Notebook allows for rapid code exectution of line segments from within a vim buffer without switching to the shell.

**How is this different from tmux + vim ?**

With default vim and tmux or another terminal you might write in vim, then copy the command to run into your clipboard then switch context to the terminal and paste the line.  With vim-notebook you execute the line or visual selection quickly from vim and observe the results without leaving your current buffer.

## Pre-requisites

You should know vim basics such as changing focus between vim splits, entering and exiting insert mode.

Note that `<Esc>` does not exit insert mode in a vim terminal but `<C-\><C-n>` does.  I have remapped this pattern to `<Esc>` because i have never used `<Esc>` in a shell.

## Tutorial

Here is some code you can try out.  Open this file in vim:

Visual highlight the following lines and run the command `:RunCell`

```bash
TMP_PATH=/tmp
find $TMP_PATH -name '*log' | head

ls ~
```

Change to the terminal split and close it with `exit` or similar.

Now open up a python shell with `:OpenTerminal python`.

`:RunCell` is mapped to `<leader>r` on a selection or on an individual line, without a selection. So position your cursor on the first line of python and hit `<leader>r` 4 times.

```python
import json 

d = json.loads('{"name": "flojo"}')
d['name']
```

If you open up a python file, `:RunCell` (or the mapped keys) will automatically start an `ipython` shell to run the code.  If it can't find it, it will start a `python` shell.

You can start any shell you want with `:OpenTerminal <shell name>`, e.g `:OpenTerminal node` .  Once the shell is open, highlighted code will go to it for execution.  Having multiple shell types open is not supported by Vim-Notebook.

By default the terminal will start below the current file but if you want to start it to the right, provide the standard vim modifier `vertical`. E.g `:vert OpenTerminal bash`.

The default shell is the default system shell, so if that is `bash` then this is equivalent to `vert OpenTerminal`. 
