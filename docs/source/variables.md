## Variables 
`ucollage` makes use of some configuration variables that determine its behavior
and interface. These have sane default values but the user is able to change
them according to their preferences.

You just have to export the relevant variables in the config file
`$HOME/.config/ucollage/variables` or in your `$HOME/.bashrc`.

``` bash
# Example
export UCOLLAGE_LINES=2
export UCOLLAGE_SORT=time
```

Let's see what are the available options.

<div id=test><b>UCOLLAGE_LINES</b></div>

| | |
---|---
Valid   | Integer
Default | `3`
Info    | Number of lines of the grid

<div id=UCOLLAGE_COLUMNS><b>UCOLLAGE_COLUMNS</b></div>

| | |
---|---
Valid   | Integer
Default | `4` 
Info    | Number of lines of the grid

---

<div id=UCOLLAGE_TMP_DIR><b>UCOLLAGE_TMP_DIR</b></div>

| | |
---|---
Valid   | String
Default | `/tmp/ucollage`
Info    | Temporary directory to store files during runtime

<div id=UCOLLAGE_CACHE_DIR><b>UCOLLAGE_CACHE_DIR</b></div>

| | |
---|---
Valid   | String
Default | `~/.local/share/ucollage`
Info    | Cache directory to store more files more permanently

<div id=UCOLLAGE_TRASH_DIR><b>UCOLLAGE_TRASH_DIR</b></div>

| | |
---|---
Valid   | String
Default | `~/.local/share/Trash/ucollage`
Info    | Directory to move files that have been *deleted* in the program.

NOTE: For the above 3 variables don't quote the string if you want `~` expansion
to occur. `$HOME` behaves as expected.
```bash
# Not what you expect
export UCOLLAGE_XXX_DIR="~/somedir"
# Valid
export UCOLLAGE_XXX_DIR=~/somedir
# Valid
export UCOLLAGE_XXX_DIR="$HOME/somedir"
# Valid
export UCOLLAGE_XXX_DIR=$HOME/somedir
```
---

<div id=UCOLLAGE_EXEC_PROMPT><b>UCOLLAGE_EXEC_PROMPT</b></div>

| | |
---|---
Valid   | {noexecprompt, execprompt}
Default | `execprompt`
Info    | Ask for confirmation when executing commands

If the value is `execprompt` then a confirmation message appears under the
status line: `<command> ? (Press y/Y/Enter to confirm)`.

---

<div id=UCOLLAGE_FILEINFO><b>UCOLLAGE_FILEINFO</b></div>

| | |
---|---
Valid   | {names, ratings, categories}
Default | `names`
Info    | Info to show under the images of the grid

Example output:
```
names      -> 1: filename.jpg
ratings    -> 1: ★★★★☆ 
categories -> 1: nature sea
```

<div id=UCOLLAGE_SHOW_FILEINFO><b>UCOLLAGE_SHOW_FILEINFO</b></div>

| | |
---|---
Valid   | {noshowfileinfo, showfileinfo}
Default | `showfileinfo`
Info    | Show the above fileinfo under the images of the grid

---

<div id=UCOLLAGE_EXPAND_DIRS><b>UCOLLAGE_EXPAND_DIRS</b></div>

| | |
---|---
Valid   | {0, 1, ask}
Default | `ask`
Info    | Open images residing in directory that is provided as an argument.

Example:
```bash
$ ucollage somedir
```
Output:
```
# value "0"
No images to show
```
```
# value "1"
# ucollage launches and shows images inside somedir
```
```bash
# "ask"
Expand somedir? (n, Esc: no, N: no to all)
```

No to all means that if there are more directories in the argument list we omit
expanding them all.

---

<div id=UCOLLAGE_SORT><b>UCOLLAGE_SORT</b></div>

| | |
---|---
Valid   | {name, time, size, extension}
Default | `time`
Info    | Sort files

<div id=UCOLLAGE_SORT_REVERSE><b>UCOLLAGE_SORT_REVERSE</b></div>

| | |
---|---
Valid   | {noreverse, reverse}
Default | `noreverse`
Info    | Reverse order of files after sorting

---

<div id=UCOLLAGE_VIDEO_THUMBNAILS><b>UCOLLAGE_VIDEO_THUMBNAILS</b></div>

| | |
---|---
Valid   | {0, 1}
Default | `1`
Info    | Show thumbnails for videos. First thumbnail creation for videos may increase launch time

<div id=UCOLLAGE_CACHE_THUMBNAILS><b>UCOLLAGE_CACHE_THUMBNAILS</b></div>

| | |
---|---
Valid   | {0, 1}
Default | `1`
Info    | Save thumbnails in order to avoid creating again in the future

<div id=UCOLLAGE_THUMBNAIL_WIDTH><b>UCOLLAGE_THUMBNAIL_WIDTH</b></div>

| | |
---|---
Valid   | Integer
Default | `500`
Info    | Width of thumbnails for videos.

---

<div id=UCOLLAGE_LEADER><b>UCOLLAGE_LEADER</b></div>

| | |
---|---
Valid   | String
Default | `\\`
Info    | String that will replace the `<Leader>` placeholder in keybindings

---

<div id=UCOLLAGE_HASHFUNC><b>UCOLLAGE_HASHFUNC</b></div>

| | |
---|---
Valid   | String
Default | `md5sum`
Info    | Hash function to use for keeping info about files no matter their name

A default of `md5sum` has been selected because it will probably be present in
most systems, but there exist alternatives, especially if speed of computation
is important. For example utilizing `xxhsash` you could set the variable to
`xxh128sum`.

---

<div id=UCOLLAGE_MAX_LOAD><b>UCOLLAGE_MAX_LOAD</b></div>

| | |
---|---
Valid   | Integer
Default | `1000`
Info    | Maximum number of files to check at start-up and each reload

This setting needs a bit more explaining. Suppose that you want to view a large
amount of files with `ucollage`. What `ucollage` will do first is check that the
files provided as arguments are images or videos. To achieve that it takes some
steps:
- it computes the hash of some part of the file using `UCOLLAGE_HASHFUNC`
- it uses it to check whether the file has already been encountered in the past
- if no information is stored, it uses the `file` command in order to determine
  its filetype.

This procedure is computationally intensive, so the `CPU` will work a bit more.
But the reality of the situation is that you won't need to view all images right
away and it is entirely possible that you change your mind and some images won't
be viewed at all. So it is logical to split the computation in smaller parts and
load the necessary images as needed. `UCOLLAGE_MAX_LOAD` is the size of this
smaller part that we want to examine.

---

At last we have the variables that correspond to `ueberzug` and consequently the
way images are drawn. We provide support for configuring 3 parameters.

<div id=UCOLLAGE_SCALER><b>UCOLLAGE_SCALER</b></div>

| | |
---|---
Valid   | {crop, distort, fit\_contain, contain, forced_cover, cover}
Default | `contain`
Info    | Image scaler

Again here we have to give some more clarification of how each scaler operates.
Let's start by giving a formal description of each one taken directly from the
`ueberzug` [README](https://github.com/seebye/ueberzug#add).

Name          | Description                                                                      |
--------------|----------------------------------------------------------------------------------|
crop          | Crops out an area of the size of the placement size.                             |
distort       | Distorts the image to the placement size.                                        |
fit_contain   | Resizes the image that either the width matches the maximum width or<br>the height matches the maximum height while keeping the image ratio. |
contain       | Resizes the image to a size <= the placement size while keeping the image ratio. |
forced_cover  | Resizes the image to cover the entire area which should be filled while <br>keeping the image ratio. If the image is smaller than the desired size<br>it will be stretched to reach the desired size.<br>If the ratio of the area differs from the image ratio the edges will be cut off. |
cover         | The same as forced_cover but images won't be stretched<br>if they are smaller than the area which should be filled. |

We can summarize the effect of each scaler on a random image in the table below.

Scaler        | Keep image ratio | Crop part of image | Distortion
--------------|:---:|:---:|:---:
crop          | image \< area                | image \> area            | ✗
distort       | image ratio ==<br>area ratio | ✗                        | image dimension \<<br>area dimension
fit_contain   | ✓                            | ✗                        | image \< area
contain       | ✓                            | ✗                        | ✗
forced_cover  | ✓                            | image ratio > area ratio | image < area
cover         | ✓                            | image > area             | ✗

From the above we can understand that the default, `contain`, is the one that
preserves the image properties in all cases. You should, however, test every
scaler to see what works best for you.

<div id=UCOLLAGE_SCALINGX><b>UCOLLAGE_SCALINGX</b></div>

| | |
---|---
Valid   | Integer [0, 100]
Default | `50`
Info    | Scaling center in x-axis when part of image is hidden

<div id=UCOLLAGE_SCALINGY><b>UCOLLAGE_SCALINGY</b></div>

| | |
---|---
Valid   | Integer [0, 100]
Default | `50`
Info    | Scaling center in y-axis when part of image is hidden

For the end we leave the scaling center in the 2 axis. When part of the image is
hidden (e.g. when using the `crop` scaler) we can specify the part of the image
that we want to view at each time with these two variables. The default values
of `50`, make that the center of the image is being shown.
