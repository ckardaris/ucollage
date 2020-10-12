# ucollage
An image viewer for the terminal based on Überzug

**Disclaimer:** The usage gif below is showing only a subset of the capabilities of the script. It is older and needs updating
![](resources/usage.gif)

## Supports
- images
- video thumbnails
- showing file names
- image tags
- renaming
- deleting
- general command execution
- vim-like movements and prefix arguments

## Dependencies
- `Überzug` 

   Überzug is a command line util which allows to draw images on terminals by using child windows.

- `bash >= 4.2`
- `file`

### Optional
For image rotation:

- `imagemagick`

For video thumbnails:
- `ffmpeg`

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
`;`          | enter tag mode
`n/N`        | get next/last batch of images
`p/P`        | get previous/first batch of images
`E`          | toggle exec prompt
`F`          | toggle filenames on screen
`o`          | change sort type
`O`          | sort reverse
`S`          | change scaler
`q`          | exit

#### Controls with vim-like prefix counters

Key      | Action                                                                     | No-Prefix Default
---------|----------------------------------------------------------------------------|------------------
`(N)s`   | input exact number for lines and columns                                   | ask for input  *
`(N)-`   | decrease both the numbers of columns and lines by N                        | 1
`(N)+/=` | increase both the numbers of columns and lines by N                        | 1
`(N)h`   | decrease number of columns by N                                            | 1
`(N)j`   | decrease number of lines by N                                              | 1
`(N)k`   | increase number of lines by N                                              | 1
`(N)l`   | increase number of columns by N                                            | 1
`(N)c/C` | rename image with (local/global) index N                                   | ask for input  *
`(N)d/D` | move image with (local/global) index N to Trash                            | ask for input  *
`(N)g/G` | go to image with (local/global) index N                                    | ask for input  *
`(N)t/T` | tag image with (local/global) index N                                      | ask for input  *
`(N)u/U` | untag image with (local/global) index N                                    | ask for input  *
`(N)x/X` | execute different commands for each image with (local/global) index N   ** | ask for input  *
`(N)b/B` | execute one command for all images with (local/global) index N  \*\*\*     | ask for input  *

Prefix (N) is a space-separated list of values. <br>
`*` selects all available indices for the given [scope](#scope-explained) (local/global).<br>
The current value of the prefix can be seen on the status line inside parentheses.
- `s` uses only the first 2 values of (N)
- `h`, `j`, `k`, `l`, `+/=`, `-` use only the first value of (N)
- the rest of the commands use the whole prefix according to their definition

\* The input behaves exactly like the prefix list. It accepts multiple space-separated values. Write
`*` to select all values of the scope (local/global)

\*\* placeholders are available for common substitutions<br>
- `%s` image filename

\*\*\* placeholders
- `%S` all image filenames side by side


#### Monocle mode controls

Key   | Action
------|-------
`r`   | rotate image 90 degrees clockwise
`R`   | rotate image 90 degrees counterclockwise
`c/C` | rename image
`d/D` | move image to Trash
`x/X` | execute command for image   *
`b/B` | execute command for image   **

\* placeholders
- `%s` original image filename
- `%r` rotated image filename

\*\* placeholders
- `%S` original image filename
- `%r` rotated image filename

#### Tag mode controls
Key   | Action
------|-------
`c/C` | rename (local/global) tagged images one by one
`d/D` | move (local/global) tagged images to Trash
`g/G` | go to first (local/global) tagged image
`x/X` | execute different command for every (local/global) tagged image *
`b/B` | execute one command for all (local/global) tagged images **

\* placeholders
- `%s` tagged image filename

\*\* placeholders
- `%S` all tagged images filenames side by side

#### Scope explained
When you press any lowercase letter from the ones that correspond to an action on images (rename,
tag, delete, go to, etc.), the action will be performed strictly on images that you can see on your
screen (local scope). If you input indices that are out of the local scope, then you will see an
error. If you are in tag mode, then only images that are tagged and local will be used.

The opposite case is global scope. Pressing any capital letter will use all images available. The
only error can happen by selecting indices that surpass the total number of images available.

#### Control examples
- `1` `└─┘` `2` `└─┘` `4` `d`: delete images with local indices 1,2 and 4 (same as `d` `1` `└─┘` `2` `└─┘` `4` `Enter`)
- `*` `T`: tag all images available<br>
- `;` `d`: delete the local tagged images
- `*` `c` : rename all local images
- `2` `└─┘` `3` `s`: set 2x3 grid
- `2` `l` : increase number of columns by 2

### Default values

You can set default values for some of the variables. You just have to export the relevant variables in your `.bashrc`

``` bash
# Example
export UCOLLAGE_LINES=2
export UCOLLAGE_SORT_BY=time
```

Variable | Valid | Default | Description
---|:---:|:---:|---
UCOLLAGE_LINES            | Integer | 3 | number of lines when the scripts starts
UCOLLAGE_COLUMNS          | Integer | 4 | number of columns when the scripts starts
UCOLLAGE_TMP_DIR  *       | String  | /tmp/ucollage | temporary directory to store script relevant files
UCOLLAGE_CACHE_DIR  *     | String  | ~/.local/share/ucollage | cache directory to store script relevant files
UCOLLAGE_TRASH_DIR  *     | String  | ~/.local/share/Trash/ucollage | cache directory to move "deleted" files
UCOLLAGE_EXEC_PROMPT      | {0, 1}  | 0 | whether or not to ask for confirmation when executing commands # in monocle mode
UCOLLAGE_SHOW_NAMES       | {0, 1}  | 1 | whether or not show the names of all images in the wide view
UCOLLAGE_EXPAND_DIRS      | {0, 1, ask} | ask | whether or not directories should be expanded when given as arguments
UCOLLAGE_SORT_BY          | {name, time, size, extension} | name | sort image files by name, time, size or extension
UCOLLAGE_SORT_REVERSE     | {0, 1}  | 0 | whether or not image files should be sorted in reverse order
UCOLLAGE_SCALER           | {crop, distort, fit\_contain, contain, forced_cover, cover} | contain | image scaler to use with ueberzug
UCOLLAGE_VIDEO_THUMBNAILS | {0, 1} | 1 | whether or not support showing video thumbnails. Slower startup time if the first batch consists of many thumbnails which are not present in the cache directory.
UCOLLAGE_CACHE_THUMBNAILS | {0, 1} | 1 | whether or not save computed thumbnails for future usage
UCOLLAGE_THUMBNAIL_WIDTH  | Integer | 500 | width of thumbnails of videos, image ratio is preserved. Actual appearance on screen will depend on the value of UCOLLAGE_SCALER
UCOLLAGE_MESSAGE_TIMEOUT  | Real    | 1 | time in seconds to show messages (error, success, warning) on screen (0 to hide, very big to never hide)

\* don't quote directories if you want tilde expansion (~) to occur. $HOME should be fine either way

#### Image scalers explained (taken from [ueberzug](https://github.com/seebye/ueberzug#add))
| Name          | Description                                                                      |
|---------------|----------------------------------------------------------------------------------|
| crop          | Crops out an area of the size of the placement size.                             |
| distort       | Distorts the image to the placement size.                                        |
| fit_contain   | Resizes the image that either the width matches the maximum width or the height matches the maximum height while keeping the image ratio. |
| contain       | Resizes the image to a size <= the placement size while keeping the image ratio. |
| forced_cover  | Resizes the image to cover the entire area which should be filled while keeping the image ratio. If the image is smaller than the desired size it will be stretched to reach the desired size. If the ratio of the area differs from the image ratio the edges will be cut off. |
| cover         | The same as forced_cover but images won't be stretched if they are smaller than the area which should be filled. |
