# Default Keybindings

Actions where the `prefix` is not meaningful
Key                       | Action
--------------------------|-------
`.`                       | repeat last action
`:`                       | enter command mode
`Backspace`               | exit monocle mode or select previous image in wide mode (with line wrapping)
`Ctrl - l`                | load more images
`Space`                   | select next image in wide mode (with line wrapping)
`n` or `Ctrl - →`         | get next batch of images
`N` or `Ctrl - Shift - →` | get last batch of images
`p` or `Shift - ←`        | get previous batch of images
`P` or `Ctrl - Shift - ←` | get first batch of images
`q`                       | quit
`sf`                      | set fileinfo type (names, ratings, categories)
`ss`                      | set sort type (name, time, size, extension)
`su`                      | set ueberzug scaler (crop, distort, fit_contain, contain, forced_cover, cover)
`tf`                      | toggle fileinfo on screen
`tp`                      | toggle exec prompt
`tr`                      | toggle reverse sort

The majority of the actions need a prefix to work. If the user does not type one, then the currently
selected image will be used or a prefix of one in the cases where a number is necessary. 

Key                   | Action                                                  | No-Prefix Default
----------------------|---------------------------------------------------------|------------------
`prefix` `++`         | increase both the numbers of columns and lines | 1
`prefix` `+\|`        | increase number of columns                     | 1
`prefix` `+_`         | increase number of lines                       | 1
`prefix` `--`         | decrease both the numbers of columns and lines | 1
`prefix` `-\|`        | decrease number of columns                     | 1
`prefix` `-_`         | decrease number of lines                       | 1
`prefix` `Enter`      | enter monocle mode; go to image                | current selection
`prefix` `Shift - ←`  | shift image left (when it applies)             | 1
`prefix` `Shift - ↑`  | shift image up (when it applies)             | 1
`prefix` `Shift - →`  | shift image right (when it applies)            | 1
`prefix` `Shift - ↓`  | shift image down (when it applies)             | 1
`prefix` `ci`         | set categories                                 | current selection
`prefix` `di`         | move to Trash                                  | current selection
`prefix` `dt`         | untag                                          | current selection
`prefix` `h or ←`     | move selection left (no line wrapping)         | 1
`prefix` `j or ↓`     | move selection down (no line wrapping)         | 1
`prefix` `k or ↑`     | move selection up (no line wrapping)           | 1
`prefix` `l or →`     | move selection right (no line wrapping)        | 1
`prefix` `mv`         | rename                                         | current selection
`prefix` `rh`         | rotate counter-clockwise                       | current selection
`prefix` `rl`         | rotate clockwise                               | current selection
`prefix` `ri`         | rate                                           | current selection
`prefix` `si`         | set current selection                          | do nothing
`prefix` `sg`         | set grid size                                  | do nothing
`prefix` `ti`         | tag                                            | current selection
`prefix` `u`          | undo edits                                     | current selection
`prefix` `Ctrl - r`   | redo edits                                     | current selection
`prefix` `wi`         | save edits                                     | current selection
`prefix` `!`          | execute command *                              | current selection

\* When the user wants to execute a custom command it is useful to be able to refer to the filenames
of the images that have been selected with the `prefix`. In order to do that it is possible to
make use of the following placeholders.

- `%s` is replaced with the original file
- `%S` is replaced by all original files
- `%e` is replaced with the edited file or the original file if not edited (see
  <a href="scripts.html">Scripts</a>)
- `%E` is replaced by all the edited files or the original files if not edited
- `%d` is replaced with the destination file in edit scripts

Example:
``` bash
:(2) ! feh %s
```

You can change the default keybindings by following the instructions <a
href="keycmd.html">here</a>.
