# Scripts

`ucollage` recognizes and executes 3 types of scripts.

- Builtin scripts that perform one of the default actions available by the
  program (renaming, moving to Trash, tagging, etc). These scripts have the
  argument logic programmed into them, so they don't need any guidance regarding
  what image they are operating on.
- Simple scripts that take an image as argument in order to act upon it. An
  example of such a script would be one that sets the desktop background with an
  image.
- Edit scripts that have the goal of making modifications to the actual image.
  Rotating an image falls under that category as does a script that passes the
  image through a filter (e.g. monochrome).

To the naked eye it may seem unnecessary to have 3 different types, because the
last step to executing each type of script is always an `eval` command.

But there are some **key** differences. 

- Executing a script that falls under the 2nd type (simple scripts) performs
  none post-execution actions. That means that if the state of the images
  change, that won't be reflected on the view. For this reason such scripts are
  useful **only** in cases where we want to use our images with other programs.

- The builtin scripts (1st type) are especially coded in such a way that the
  most logical post-execution actions are performed. For example, after renaming
  an image the relevant filenames are changed in the internal representation of
  the images by the program.

- At last, edit scripts come with builtin edit history support. Editing images
  is not always an exact procedure and the user may need to go back and forth
  until they reach the desired result. By specifying a script as such they have
  the luxury of making mistakes and only save the result once they are ready.

**How does `ucollage` distinguish between them?**

- Edit scripts need to provide a source image and a destination image that will
  be used to produce the edit history intermediate results. So the expected
  format of edit scripts is
  ``` bash
  <script> [arguments] %s [arguments] %d [arguments]
  ```

  What the above means is that `ucollage` with take the command and replace the
  `%s` and `%d` placeholders with the source and destination as needed.

  Example: Rotate an image
  ``` bash
  convert -rotate 90 %s %d
  ```

- After checking if a script is of the above type (by checking that both
  placeholders are present) it checks for scripts that contain the following
  placeholders: `%s`, `%S`, `%e`, `%E`

  In that case, we know that it is a simple script

- At last the program treats all remaining scripts the same and just uses `eval`
  to execute them.
