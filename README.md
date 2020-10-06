# ucollage
An image viewer for the terminal based on Überzug

![](resources/usage.gif)

## Dependencies
- `Überzug` 

    Überzug is a command line util which allows to draw images on terminals by using child windows.
- `bash`

### Optional
For image rotation:

- `imagemagick`
- `basename`

## Installation
`ucollage` is a bash script, so you only have to download the file and make it executable.

To install `Überzug` you have several options:

Via pip:
```bash
$ pip3 install --user ueberzug
```

Via pacman:
```bash
$ sudo pacman -S ueberzug
```

## Usage
```bash
ucollage [images] [directories]
```
Using no arguments implies
```bash
ucollage *
```
Set `UCOLLAGE_EXPAND_DIRS` variable to determine how this should be handled

### Controls

Key          | Action
-------------|-------
`m/M`        | enter monocle mode: show only one image (equivalent to `1g`/`1G`)
`Backspace`  | exit monocle mode
`n`          | get next batch of images
`N`          | get previous batch of images
`s`          | input exact number for lines and columns
`q`          | exit

#### Controls with vim-like prefix counters

Key      | Action                                                    | No-Prefix Default
---------|-----------------------------------------------------------|------------------
`[N]-`   | decrease both the numbers of columns and lines by N       | 1
`[N]+/=` | increase both the numbers of columns and lines by N       | 1
`[N]h`   | decrease number of columns by N                           | 1
`[N]j`   | decrease number of lines by N                             | 1
`[N]k`   | increase number of lines by N                             | 1
`[N]l`   | increase number of columns by N                           | 1
`[N]c/C` | rename image with (local/global) index N                  | info message
`[N]g/G` | go to image with (local/global) index N                   | ask for input
`[N]x/X` | execute command for image with (local/global) index N   * | info message

\* placeholders are available for common substitutions<br>
- `%s` original image filename
- `%r` rotated image filename


#### Monocle mode controls

Key  | Action
-----|-------
`r`  | rotate image 90 degrees clockwise
`R`  | rotate image 90 degrees counterclockwise
`u`  | rotate image 180 degrees

### Default values

You can set default values for some of the variables. You just have to export the relevant variables in your `.bashrc`

``` bash
# number of lines when the scripts starts
export UCOLLAGE_LINES=2                    # valid: integer  default: 3

# number of columns when the scripts starts
export UCOLLAGE_COLUMNS=2                  # valid: integer  default: 4

# temporary directory to store script relevant files
export UCOLLAGE_TMP_DIR="/tmp/directory"   # valid: string   default: "/tmp/ucollage"

# whether or not to ask for confirmation when executing commands
# in monocle mode
export UCOLLAGE_EXEC_PROMPT=1              # valid: {0, 1}   default: 0

# whether or not show the names of all images in the wide view
export UCOLLAGE_SHOW_NAMES=1               # valid: {0, 1}   default: 1

# whether or not directories should be expanded when given as arguments
export UCOLLAGE_EXPAND_DIRS=0              # valid: {0, 1}   default: 0
```
