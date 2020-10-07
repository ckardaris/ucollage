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
UCOLLAGE_LINES        | Integer | 3 | number of lines when the scripts starts
UCOLLAGE_COLUMNS      | Integer | 4 | number of columns when the scripts starts
UCOLLAGE_TMP_DIR      |  String | /tmp/ucollage | temporary directory to store script relevant files
UCOLLAGE_EXEC_PROMPT  | {0, 1}  | 0 | whether or not to ask for confirmation when executing commands # in monocle mode
UCOLLAGE_SHOW_NAMES   | {0, 1}  | 1 | whether or not show the names of all images in the wide view
UCOLLAGE_EXPAND_DIRS  | {0, 1, ask} | ask | whether or not directories should be expanded when given as arguments
UCOLLAGE_SORT_BY      | {name, time, size, extension} | name | sort image files by name, time, size or extension
UCOLLAGE_SORT_REVERSE | {0, 1}  | 0 | whether or not image files should be sorted in reverse order
UCOLLAGE_SCALER       | {crop, distort, fit\_contain, contain, forced_cover, cover} | cover | image scaler to use with ueberzug

#### Image scalers explained (taken from [ueberzug](https://github.com/seebye/ueberzug#add))
| Name          | Description                                                                      |
|---------------|----------------------------------------------------------------------------------|
| crop          | Crops out an area of the size of the placement size.                             |
| distort       | Distorts the image to the placement size.                                        |
| fit_contain   | Resizes the image that either the width matches the maximum width or the height matches the maximum height while keeping the image ratio. |
| contain       | Resizes the image to a size <= the placement size while keeping the image ratio. |
| forced_cover  | Resizes the image to cover the entire area which should be filled while keeping the image ratio. If the image is smaller than the desired size it will be stretched to reach the desired size. If the ratio of the area differs from the image ratio the edges will be cut off. |
| cover         | The same as forced_cover but images won't be stretched if they are smaller than the area which should be filled. |
