# Welcome to ucollage's documentation

## What is `ucollage`?

`ucollage` is a command-line image viewer. It is able to show images on top of
your terminal window by utilizing `ueberzug`. The latter is able to do that by
exploiting the properties of the X window your terminal emulator is currently
attached to.

![](https://i.imgur.com/zWyhZXB.png)

## Why use `ucollage`?

`ucollage` is designed for keyboard-only interaction and provides the necessary
customization options to make it behave the way that you want to. The `vim` user
will feel at home.

`ucollage` aims to be your go-to program when you want to view your images.

**File support**
- images
- videos

Videos are supported through the creation of video thumbnails that is being show
alongside the other images. The user can then utilize the command execution
capabilities of `ucollage` in order to open the videos with any other program
that they like.

**Builtin actions**
- renaming
- moving to Trash
- rating
- categories
- editing images supporting undo and redo actions
- fully customizable vim keybindings
- command execution

**User defined actions**

The user can define custom scripts that will use the selected files in order to
perform different tasks. It is possible to define a script in edit mode, so that
the edit history will be available.

## Explore `ucollage` now!

```{toctree}
:maxdepth: 1

install
usage
scripts
defaultkeys
configuration
functions
examples
prglogic
```
