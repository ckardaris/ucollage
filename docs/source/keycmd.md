# Keybindings and Commands

In order to configure custom keybindings and commands `ucollage` reads the
`$HOME/.config/ucollage/scripts` configuration file.

---
**Set Keybinding**
```bash
map=<keybinding> script=<script>
```

**Unset Keybinding**
```bash
unmap=<keybinding>
```

**Command**
```bash
command=<command> script=<script>
```

You can combine keybindings and commands that share the same script by writing
```bash
map=<keybinding> command=<command> script=<script>
```

The order of keywords is not important as each line is parsed using `eval`.

---

The `map` describes the keybinding that the user should press in order to execute their script. 

It can contain printable and non-printable characters (e.g. `Home`, `End`,
etc.). The full list of non-printable characters that the program currently
supports is as follows.

`<Leader>` `<Ctrl-[A-Z]` `<Tab>` `<Shift-Tab>` `<Return>` `<Enter>` `<Insert>`
`<Ctrl-Insert>` `<Delete>` `<Ctrl-Delete>` `<Shift-Delete>`
`<Ctrl-Shift-Delete>` `<Home>` `<Ctrl-Home>` `<Shift-Home>` `<Ctrl-Shift-Home>`
`<End>` `<Ctrl-End>` `<Shift-End>` `<Ctrl-Shift-End>` `<PageUp>` `<Ctrl-PageUp>`
`<PageDown>` `<Ctrl-PageDown>` `<F[1-10]>` `<Up>` `<Down>` `<Right>` `<Left>`
`<Ctrl-Up>` `<Ctrl-Down>` `<Ctrl-Right>` `<Ctrl-Left>` `<Shift-Up>`
`<Shift-Down>` `<Shift-Right>` `<Shift-Left>` `<Ctrl-Shift-Up>`
`<Ctrl-Shift-Down>` `<Ctrl-Shift-Right>` `<Ctrl-Shift-Left>`

**NOTE** <br>
Using spaces in this option will result in creating two different keybindings for the same
script.

**Examples**
```bash
map="<Ctrl-A>" script="feh %s"
# or
map="<Ctrl-A>b" scripts="feh %S"
# or
map="abc abC" script="convert -monochrome %s %d" # this creates 2 different keybindings
```
---

Much in the same way we can set commands that execute the configured script in
command mode by pressing

`:` `command` `<Enter>`

What actually happens is that the keyword we select is substituted by the
program to the builtin function name that is defined in the code and all
arguments are passed to it.

**Example**
``` bash
command="fehimg" script="feh %s"
```
---
In order to better understand how these work we can examine how the builtin
rotation is configured.

```bash
map="rl" command="rorateright" script="convert -rotate 90 %s %d"
map="rh" command="rotateleft" script="convert -rotate -90 %s %d"
```

You can find the full information about the builtin commands and keybindings in
the <a href="functions.html">functions</a> page.
