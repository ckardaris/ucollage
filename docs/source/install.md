# Installation

---

## Dependencies

**Required**
- `ueberzug` 
- `bash >= 4.2`
- `file`
- `bc`
- `md5sum`
- `sed`
- `grep`

**Optional**
- `imagemagick` for image rotation

- `ffmpeg` for video thumbnails

- `xclip` for clipboard pasting

### Arch Linux
```
sudo pacman --needed -S ueberzug file bc sed imagemagick ffmpeg xclip
```
### Other OS
`ueberzug` can be installed via `pip`
```
$ pip3 install --user ueberzug
```
The rest of the dependencies should be available in the official repositories of your
distribution.

---

## `ucollage`

### Arch Linux
Since this is my preferred distribution I have created an `AUR` package, so you
can install ucollage with your favorite `AUR` helper.
```bash
yay -S ucollage
```
### Other OS

- Clone the repository
  ```bash
  $ git clone https://github.com/ckardaris/ucollage.git
  $ cd ucollage
    ```
or

- Grab the release file (recommended for stability)
  ```bash
  $ wget https://github.com/ckardaris/ucollage/archive/v1.0.0.tar.gz
  $ tar –xvzf ucollage-1.0.0.tar.gz
  $ cd ucollage-1.0.0
  ```

The source directory contains a `Makefile`.

Run `make` or `make help` to check the available options.
```bash
$ make help
Usage: make [PREFIX=<path>] <option>

Optional arguments:
PREFIX      the directory to install the ucollage tree (default: /)

Options:
install     install ucollage
uninstall   remove ucollage files and directories
help        show this message
```

If you want to install `ucollage` in your root directory then run
```bash
$ sudo make install

```
