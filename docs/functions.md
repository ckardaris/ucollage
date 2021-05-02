# Functions

## action.sh

The functions in this file all act on images selected by the user. Function
`get_image_index` is called at the beginning, in order to determing the indices
given in the `prefix`. If no prefix is given, the default is to use the
currently selected image.

### `_rate`
**Configuration**
```bash
map="ri" command="rate" script="_rate"
```
**Arguments**

If a space-separated list of ratings is given, then these ratings will be
applied to the prefix indices provided. If the ratings are less than the indices
then the last rating will be applied to all remaining indices. If no ratings are
given, the user is asked to input a different rating for each index.

**Example**
``` bash
:(*) rate 4
```
This will rate all images of the current view with a rating of 4

### `_categorize`
**Configuration**
```bash
map="ci" command="category" script="_categorize"
```

**Arguments**

In order to set the categories for an image we input a space-separated list of
words that begin with one of 3 characters:
- `+`: adds the word to the current list
- `-`: removes the word from the current list
- `=`: clears the current list and places the word as the only element

Again if no arguments are specified the user is asked to input them for each
different image.

**Examples**
```bash
:(1 2) category +nature +sea +fish -green
# or
:(**) category =sport +basketball
```
Arguments are evaluated from left to right, so in the last example all images
will have the sport AND basketball categories.

### `_rename`
**Configuration**
```bash
map="mv" command="rename" script="_rename"
```

**Arguments**

If the number of selected indices is 1 and an argument is provided, then that
argument will be used in the renaming process. In every other case, the user
will be asked to provide a new name for all images selected. 

**Example**
```bash
:(3) rename new-name.jpg
```

### `_delete`
**Configuration**
```bash
map="di" command="delete" script="_delete"
```

### `_tag`
**Configuration**
```bash
map="ti" command="tag" script="_tag tag"
map="dt" command="untag" script="_tag untag"
```

**Arguments**
This function parses all arguments given from left to right an changes behavior
based on their values.
- Type: a "tag" or "untag" argument needs to be given in order to specify the
  mode of operation
- Filter: a filter can be given in order to restrict the set of indices that we
  want to tag, based on their rating and categories.
  The rating is filtered using the operators gt (greater than), ge (greater
  equal), `eq` (equal), `ne` (not equal), `lt` (less than), `le` (less equal)
  and the logic operators `and` and `or`.
  Categories are filtered using the format we are used to from defining them.
  The prefix `+` before a word means we want to include images with that
  category, while the prefix `-` before a word means we want to exclude it.
- Strict: using the `strict` argument along with `tag` makes that only the
  images that the filter is true are tagged afterwards and any images previously
  tagged are untagged.

The different filters are places side by side separated by the the `&&` operator
for `and` and the `||` operator for `or`, so the evaluation follows the `bash`
rules. In order to group filters you can use `{` and `}` around. Be careful to
leave spaces.

**Examples**
```bash
# tag all images rated more than 3 with category nature
:(**) tag gt 3 and +nature 
# tag all images rated more than 3 with category nature or sea
:(**) tag gt 3 and { +nature or +sea }
# tag images of current view with category nature or sea
:(*) tag +nature or +sea
# tag only images with rating greater than 2. Untag all the rest.
:(**) tag gt 2 strict
```
---

## state.sh
### `_batch`
**Configuration**
```bash
map="n <Ctrl-Right>" script="_batch next"
map="N <Ctrl-Shift-Right>" script="_batch last"
map="p <Ctrl-Left>" script="_batch previous"
map="P <Ctrl-Shift-Left>" script="_batch first"
command="batch" script="_batch"
```

**Arguments**

It is evident from the configuration that this function takes a single argument
from the list of [next, last, previous, first], that sets the set of images we
want to view.

### `_select`
**Configuration**
```bash
map="h <Left>" script="_select left --nowrap"
map="<Backspace>" script="_select left"
map="j <Down>" script="_select down"
map="k <Up>" script="_select up"
map="l <Right>" script="_select right --nowrap"
map="<Space>" script="_select right"
map="si" script="_select"
```

This function does not define a command mode command. You can do that of course
but it does not provide much value.

**Arguments**

This function moves the selection. So the first argument it takes is one of
[left, right, up, down]. Adding and additional argument `--nowrap`, will prevent
`left` and `right` from moving to other lines when the selection is at the
border element of the current line. It can also understand a `prefix`, which
will consequentially move the selection to the desired image.

### `_goto`
**Configuration**
```bash
map="<Return>" command="goto" script="_goto"
```

**Arguments**

No arguments are given. The `prefix` can be used to open the desired image in
monocle mode.

---

## options.sh
### `_set`

**Configuration**
```bash
map="tf" script="_set showfileinfo!"
map="tr" script="_set reverse!"
map="tp" script="_set execprompt!"
map="sg" script="_set gridlines= gridcolumns="
map="++" script="_set gridlines+=1 gridcolumns+=1"
map="--" script="_set gridlines-=1 gridcolumns-=1"
map="+|" script="_set gridcolumns+=1"
map="-|" script="_set gridcolumns-=1"
map="+_" script="_set gridlines+=1"
map="-_" script="_set gridlines-=1"
command="set" script="_set"
```

This command is fully inspired by, and tries to imitate as much as possible, the `:set` command of
`vim`. It works as expected with the difference that setting an option to its default value uses the
`@` character instead of `&`.

`ucollage` can support a number of different types of options. These are:
- boolean: can be on or off
- number: can only take natural numbers and zero as a value
- enum: takes values from a pretedermined set
- string

In a little more detail:
```
:set {option}?          Show value of option.

:set {option}           boolean option: switch it on.
                        number option : show value.
                        enum   option : >>
                        string option : >>

:set no{option}         boolean option: switch it off (supports autocompletion).
                        number option : error message.
                        enum   option : >>
                        string option : >>

:set {option}! or
:set inv{option}        boolean option: invert value.
                        number option : error message.
                        enum   option : >>
                        string option : >>

:set {option}@          Reset option to its default value provided by 
                        the configuration file or `ucollage` itself.

:set all@               Reset all options to their default value

:set {option}=          
:set {option}:          boolean option: error message.
                        number option : set option if valid else display error message.
                        enum   option : >> (supports autocompletion).
                        string option : set option

:set {option}+=         boolean option: error message.
                        number option : add value to option if valid else display error message.
                        enum   option : error message.
                        string option : append value to option.

:set {option}-=         boolean option: error message.
                        number option : subtract value from option if valid else display error message.
                        enum   option : error message.
                        string option : remove all occurences of value from option.

:set {option}^=         boolean option: error message.
                        number option : multiply value with option if valid else display error message.
                        enum   option : error message.
                        string option : prepend value to option.

```
The {option} arguments to `:set` may be repeated. For example:
```
:set gridlines=3 gridcolumns=4 fileinfo=ratings noexecprompt.
```
If an error occurs to one of the arguments then an error will be shown, but the rest of the
arguments will be parsed.

If a `prefix` is given to the command then the `prefix` will override all values passed to any
`number` options. If the indices of the `prefix` are less than the number of `number` options being
modified then the last `index` is repeated as needed.

For example:
```
:(3 4) set gridcolumns=2 gridlines=3
```
will set `gridcolumns` to 3 and `gridlines` to 4
```
:(1) set gridcolumns=2 gridlines=3
```
will set both `gridcolumns` to `gridlines` to 1

![](https://i.imgur.com/AyanAy4.jpg)

A list of the currently supported options is:
Option | Type
---|---
execprompt      | boolean
showfileinfo    | boolean
reverse         | boolean
scaler          | enum
sort            | enum
fileinfo        | enum
gridcolumns     | number
gridlines       | number
maxload         | number
scalingx        | number
scalingy        | number

Their description is provided in the <a href=variables.html>Configuration
Variables</a> page.

---

## edit.sh
### `_write`
**Configuration**
```bash
map="wi" command="write" script="_write"
```

### `_history`
**Configuration**
```bash
map="u" command="undo" script="_history --undo"
map="<Ctrl-R>" command="redo" script="_history --redo"
```

**Arguments**

This function takes one argument `--undo` or `--redo` based on the operation we
want to perform.

---

## filelist.sh
### `load_files`
**Configuration**
```bash
map="<Ctrl-L>" command="loadfiles" script="load_files"
```
---

## command.sh
### `command_mode`
**Configuration**
```bash
map="ss" script="command_mode --left set sort"
map="su" script="command_mode --left set scaler"
map="sf" script="command_mode --left set fileinfo"
map="!" script="command_mode --left !%_%"
```

At last we have one of the most useful functions for creating custom
keybindings. This function provides the ability to enter command mode and fill
the input line with the desired text, much like `vim` normal mode keybindings
that start with the `:` character.

**Arguments**

This function will parse all arguments from left to right. There are 3 keyword
arguments that set the command line as desired.
- `--left`
- `--right`
- `--enter`

When `--left` is encountered, the program will read all arguments following
that, until it reaches `--right` or `--enter`, and add all the words to the left
of the cursor. The same thing happens with `--right`. If `--enter` is present,
that means that we don't want to enter the command line and wait for input by
the user and then pressing enter. Instead we execute the command defined by the
joining the left and right parts.

**NOTE**<br>
By design the left and right parts are stripped of trailing and starting
whitespace. If the user still wants to enter a space at any of these points,
they can use the `%_%` placeholder.

**Example**
```bash
map=<keybinding> script="command_mode --left set lines= --right %_%columns="
```

This will create a mapping that when pressed, will enter command mode and show
the text below

```
:set lines=█columns=
```
