# ucollage
An image viewer for the terminal based on Überzug

![](resources/usage.gif)

## Dependencies
- `Überzug` 

    Überzug is a command line util which allows to draw images on terminals by using child windows.
- `bash`

### Optional
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
```
ucollage [images]
```

### Controls

`n` get next batch of images

`N` get previous batch of images

`h` decrease number of columns by 1

`j` decrease number of lines by 1

`k` increase number of lines by 1

`l` increase number of columns by 1

`-` decrease both the numbers of columns and lines by 1

`+/=` increase both the numbers of columns and lines by 1

`s` input exact number for lines and columns

`q` exit

`m` enter monocle mode: show only one image

`M` exit monocle mode

#### Monocle mode specific controls

`r` rotate image 90 degrees clockwise

`R` rotate image 90 degrees counterclockwise

`u` rotate image 180 degrees

`x` execute command (use `%s` as placeholder for the image filename)

### Default values

You can set default values for the number of lines and columns the program
starts with. You just have to export the relevant variables in your `.bashrc`

``` bash
# If you want a 2x2 grid
export UCOLLAGE_LINES=2
export UCOLLAGE_COLUMNS=2
```
