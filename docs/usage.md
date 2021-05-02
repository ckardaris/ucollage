# Usage

## Launching
``` bash
ucollage [images] [directories]
```
Using no arguments implies
``` bash
ucollage *
```
Set [UCOLLAGE_EXPAND_DIRS](variables.html#UCOLLAGE_EXPAND_DIRS) variable to
determine how this should be handled

## Modes

### Normal
The `Normal` mode is inspired from the `vim` normal mode. The user is able to
use shortcuts in order to achieve most supported actions.  A `Normal` mode key
sequence consists of an optional [prefix](#the-prefix) (when that is supported
for an action) followed by the keybinding of the desired action.

### Command
Much like in `vim` the user is able to perform the actions of the `Normal` mode
in a `Command` mode which can be initiated by pressing `:`. A `Command` mode
command has the following structure
```
:(prefix) command [arguments]
```
The `prefix` can be automatically placed on the command line if the user types
the desired indices before typing `:`. In any case the user can type `(`
`prefix` `)` and achieve the same effect.  Modifications of the `prefix` are of
course possible by simply erasing and rewriting the `prefix` part.

The `command` is a keyword describing the desired action. The `argument` is used
in commands that currently support arguments. The supported commands with their
optional arguments along with their corresponding `Normal` mode keybindings are

<div style="outline-style:double;outline-offset:3px">
Check out all the defined functions along with their default keybindings and
corresponding commands <a href=functions.html>here</a>.
</div><br>

## The `prefix`

Unlike `vim` where the prefix in the general case serves as a counter, in
`ucollage` the purpose of the prefix in most cases is to inform the program
about the images that should be used/affected by the performed action. Each
image in view is assigned an index starting from `1` and the user can input a
space separated list of indices as the current action prefix.

For example in order to select images 1 and 4 in `Normal` mode the user can press
`1` `└─┘` `4`. The visual confirmation of the selection exists in the form of an info line where
the selected indices will be displayed inside parentheses, like `(1 4)`. It is possible to alter
the current selection of indices simply by erasing the current numbers and writing new ones.

**Special Cases**<br>
`*` selects all images of the current view<br>
`**` selects all images currently loaded by the program<br>
`;` selects all the tagged images<br>
`#` selects the last selected images

## The `action`
When you are ready with the prefix, you can begin typing the action keybinding, which should
consist of letters. For example in order to tag the selected images one can type `t` `i` after the
prefix.

## Text input shortcuts

- `Tab` and `Shift - Tab`<br>
  When the user is required to type some input then basic autocomplete is
  provided.

- `Up` and `Down` arrows<br>
  The intuitive action of pressing the `Up` and `Down`
  arrows to iterate over the command history works as expected. This feauture is
  a little "smart", in the sense that it only shows commands that have the same
  prefix as the currently typed input. 

- `Ctrl - U` delete input from cursor to the start of the line
- `Ctrl - W` delete last word from the cursor to the left
- `Ctrl - (Left|Right)` move between words
