# ucollage
An image viewer for the terminal based on Überzug

![](resources/usage.gif)

## Dependencies
- `Überzug` 

   Überzug is a command line util which allows to draw images on terminals by using child windows.

- `bash`
- `file`
- `basename`

### Optional
For image rotation:

- `imagemagick`

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

#### NOTE
`ucollage` is still growing and the controls may change from time to time. Be sure to first check
the README or the help page if something is not working as expected in regard to that matter.

#### General
Key          | Action
-------------|-------
`m/M`        | enter monocle mode: show only one image (equivalent to `1g`/`1G`)
`Backspace`  | exit monocle mode
`n/N`        | get next/last batch of images
`p/P`        | get previous/first batch of images
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


#### Monocle mode controls

Key   | Action
------|-------
`r`   | rotate image 90 degrees clockwise
`R`   | rotate image 90 degrees counterclockwise
`u`   | rotate image 180 degrees
`c/C` | rename image
`x/X` | execute command for image   * 

\* placeholders are available for common substitutions<br>
- `%s` original image filename
- `%r` rotated image filename

### Default values

You can set default values for some of the variables. You just have to export the relevant variables in your `.bashrc`

``` bash
# Example
export UCOLLAGE_LINES=2
export UCOLLAGE_SORT_BY=time
```

Variable | Valid | Default | Description
---|:---:|:---:|---
UCOLLAGE\_LINES | Integer | 3 | number of lines when the scripts starts
UCOLLAGE\_COLUMNS | Integer | 4 | number of columns when the scripts starts
UCOLLAGE\_TMP\_DIR |  String | /tmp/ucollage | temporary directory to store script relevant files
UCOLLAGE\_EXEC\_PROMPT | {0, 1} | 0 | whether or not to ask for confirmation when executing commands # in monocle mode
UCOLLAGE\_SHOW\_NAMES | {0, 1} | 1 | whether or not show the names of all images in the wide view
UCOLLAGE\_EXPAND\_DIRS | {0, 1, ask} | ask | whether or not directories should be expanded when given as arguments
UCOLLAGE\_SORT\_BY | {name, time, size, extension} | name | sort image files by name, time, size or extension
UCOLLAGE\_SORT\_REVERSE | {0, 1} | 0 | whether or not image files should be sorted in reverse order
