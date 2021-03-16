# ucollage
A command line image viewer based on Überzug

![](https://i.imgur.com/VFKi4L2.png)
You can also checkout a [usage gif](https://i.imgur.com/aN5eACA.mp4), showing some of the capabilities of the script in a little more
detail.

#### !ATTENTION!
Both the image and the video are showing the capabilities of v0.1.0 of the script. Be sure to
check out the newest changes.

## Supports
- images
- video thumbnails
- showing file names
- image tags
- renaming
- deleting
- rotating
- sorting
- general command execution
- vim-like movements and prefix arguments

### Active Development
To checkout the newest changes you have to run the script residing in the
`dev` branch.

## Dependencies
- `Überzug` 

   Überzug is a command line utility which allows to draw images on terminals by using child windows.

- `bash >= 4.2`
- `file`
- `xxhash`

### Optional
For image rotation:

- `imagemagick`

For video thumbnails:
- `ffmpeg`

## Installation
`ucollage` is a bash script, so you only have to download the file and make it executable.

For Arch Linux users you can also download it from the AUR. Using `yay` that would be

```bash
yay -S ucollage
```

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
`n/right arrow`      | get next batch of images
`N/shift+right arrow`| get last batch of images
`p/left arrow`      | get previous batch of images
`P/shift+left arrow`| get first batch of images
`p/P`        | get previous/first batch of images
`E`          | toggle exec prompt
`F`          | toggle filenames on screen
`o`          | change sort type
`O`          | sort reverse
`S`          | change scaler
`q`          | exit

#### Controls with vim-like prefix counters

Key     | Action                                                      | No-Prefix Default
--------|-------------------------------------------------------------|------------------
`(N)s`  | input exact number for lines and columns                    | ask for input  *
`(N)-`  | decrease both the numbers of columns and lines by N         | 1
`(N)+/=`| increase both the numbers of columns and lines by N         | 1
`(N)h`  | decrease number of columns by N                             | 1
`(N)j`  | decrease number of lines by N                               | 1
`(N)k`  | increase number of lines by N                               | 1
`(N)l`  | increase number of columns by N                             | 1
`(N)c`  | rename image with index N                                   | ask for input  *
`(N)d`  | move image with index N to Trash                            | ask for input  *
`(N)g`  | go to image with index N                                    | ask for input  *
`(N)t`  | tag image with index N                                      | ask for input  *
`(N)w`  | save edits of image with index N                            | ask for input  *
`(N)u`  | untag image with index N                                    | ask for input  *
`(N)x`  | execute different commands for each image with index N   ** | ask for input  *
`(N)b`  | execute one command for all images with index N  \*\*\*     | ask for input  *

Prefix (N) is a space-separated list of values. <br>
`*` selects all available indices in the current view.<br>
`**` selects all available indices currently open by ucollage.<br>
The current value of the prefix can be seen on the second line of the screen.
- `s` uses only the first 2 values of (N)
- `h`, `j`, `k`, `l`, `+/=`, `-` use only the first value of (N)
- the rest of the commands use the whole prefix according to their definition

\* The input behaves exactly like the prefix list. It accepts multiple space-separated values. Write
`*` to select all indices of the current view and `**` to select the indices of all images.

\*\* placeholders are available for common substitutions<br>
- `%s` image filename

\*\*\* placeholders
- `%S` all image filenames side by side


#### Monocle mode controls

Key   | Action
------|-------
`b`| execute command for image   **
`c`| rename image
`d`| move image to Trash
`r`| rotate image 90 degrees clockwise
`R`| rotate image 90 degrees counterclockwise
`t`| tag image
`u`| untag image
`w`| save edits for image for image
`x`| execute command for image   *

\* placeholders
- `%s` original image filename
- `%r` rotated image filename

\*\* placeholders
- `%S` original image filename

#### Tag mode controls
Key| Action
---|-------
`b`| execute one command for all tagged images **
`c`| rename tagged images one by one
`d`| move tagged images to Trash
`m`| go to first tagged image
`u`| untag tagged images
`w`| save edits for tagged images
`x`| execute different command for every tagged image *

\* placeholders
- `%s` tagged image filename

\*\* placeholders
- `%S` all tagged images filenames side by side

#### Control examples
- `1` `└─┘` `2` `└─┘` `4` `d`: delete images with indices 1,2 and 4 (same as `d` `1` `└─┘` `2` `└─┘` `4` `Enter`)
- `*` `t`: tag all images in the current view<br>
- `*` `*` `t`: tag all images available<br>
- `;` `d`: delete all tagged images
- `*` `c` : rename all tagged images
- `2` `└─┘` `3` `s`: set 2x3 grid
- `2` `l` : increase number of columns by 2

### Default values

You can set default values for some of the variables. You just have to export the relevant variables in the config file `$HOME/.config/ucollage/config.sh` or in your `.bashrc`

``` bash
# Example
export UCOLLAGE_LINES=2
export UCOLLAGE_SORT_BY=time
```

Variable | Valid | Default | Description
---|:---:|:---:|---
UCOLLAGE_LINES            | Integer | 3 | number of lines when the scripts starts
UCOLLAGE_COLUMNS          | Integer | 4 | number of columns when the scripts starts
UCOLLAGE_MAX_LINES        | Integer | 20| number of max lines permitted
UCOLLAGE_MAX_COLUMNS      | Integer | 20| number of max columns permitted
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
UCOLLAGE_MESSAGE_TIMEOUT  | Real    | 1 | time in seconds to show messages (error, success, warning) on screen (0 to hide messages, very big to never hide)

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

### User Scripts
The user can now set custom keybindings in order to be able to execute scripts of their own for
the selected images.

Two types of user scripts are introduced:
- `edit scripts`
- `use scripts`

`use scripts` make use of the selected images in order to perform another action.

`edit scripts` edit the selected images and the user can save the changes at a later time.

In order to set these user scripts you have to add lines in your `config` file like the following:
```
edit_script[key]=path/to/script
use_script[key]=path/to/script
```

For example you could have: <br>
```
use_script[w]="feh --bg-fill"
```
That would provide the option to set your background from within
`ucollage`.

#### !ATTENTION!
- The `use scripts` are executed by providing the image selected as the first and only argument. What
  is executed internally is the responsibility of the user.
- The `edit scripts` are executed by providing the image selected as the first argument and the
  temporary file used to make the edits as the second argument. So the script should be able
  to be called like
  ```
  ./script infile outfile
  ```
- Setting an `edit_script` refreshes the view. For example, if you provide a custom script to apply
  a filter on an image (e.g. monochrome).
