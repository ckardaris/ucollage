# Text Input

## Basic Input
A command line program that is not using any external library to handle input
has to do all the parsing and outputting by itself. That is what is happening in
the file `src/input.sh`.

In order to create a functional input line we need to have a cursor that can
move around and insert text at the desired points. To achieve that we define two
string variables `input_left` and `input_right`. These are concatenated at each
iteration and the cursor is places between them.

Example:
```bash
input_left="hello"
input_right=" world"
# output: hello█world
```
```bash
input_left="hello world"
input_right=""
# output: hello world█
```

Depending on the key pressed and the current values of the two strings we modify
them and output the changes on the screen. For example, by pressing the `Home`
key, we want to move the cursor to the beginning, so we just add all of
`input_left` in the front of `input_right` and then we make `input_left` empty.

## Autocomplete

Autocomplete is a functionality that is both really useful and a bit tricky to
implement considering that it has to be based. The basic idea behind its
implementation in `ucollage` follows the following principles.

When the user presses `Tab` or `Shift - Tab` for the first time, list of
suggestions is created based on the last word before the cursor in the input
line. Pressing one of the keys again, cycles through the generated suggestions.
The output is comprised of the "fixed" part of `input_left` that does not affect
the suggestion, the suggestion and then `input_right`.

The interesting part is how we handle nested autocompletions. An example of that
is when we fire up the command mode. Pressing `Tab` should cycle through all the
available commands and then after selecting a command, some of them (e.g. `set`)
have their own set of autocomplete suggestions. The tricky part is that we don't
want to mix the suggestions in case a word that can produce suggestions is at
the wrong place. For example, if we have defined suggestions for the command
`rate` and the command `set` and the command line is
```bash
:set rate █
```
we don't want to start suggesting words based on the keyword `rate`.

The solution to that is an `autocomplete_level` list.

The autocomplete for the current state of the input line is defined by the last
element of that list. In order for a keyword to be added to the list, then that
keyword needs to be present in the suggestions of the previously last element of
the list.

Example:

When we fire up the command line the current `autocomplete_level` consists of
only the keyword `ucollage`. This keyword provides the suggestions for all the
defined commands. When we write one of the commands (e.g. `set`), then, because
the `ucollage` keywords provides `set`, it is added to the `autocomplete_level`
list and the suggestions are changed accordingly. If the next word written is
does not provide any suggestions, then the suggestion keyword is not changed and
the suggestions keep coming from the last valid keyword. This permits to press
`Space` and keep receiving suggestions from the same group (useful in the `set`
command especially).

The suggestions for keywords are defined in the `spacelist` and the `sticklist`
associative arrays.

The `spacelist` consists of keywords that should provide suggestions in the next
word (after a space).

Example:
```bash
spacelist[batch]="previous next first last"
```

The `sticklist` consists of keywords that should provide suggestions right next
to current word (e.g. after `no` or `inv` in a `set` option)

Example:
```bash
sticklist[no]="showfileinfo execprompt reverse writenew"
```

**How does that work in practice?**

Say we want to have a command `cmd1` that is autocompleted in command mode. We
have to add the string `cmd1` in the `spacelist[ucollage]` string element. If we
then want `cmd1` to provide each own suggestions after writing it, we have to
add a `spacelist[cmd1]` string to the associative array, with autocomplete
suggestion values separated by spaces.
