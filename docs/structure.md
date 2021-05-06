# Program Structure

In this page the logic of the program will be explained in order to help anyone
who wants to contribute.

## Starting up
The program is called by executing the
[ucollage](https://github.com/ckardaris/ucollage/blob/master/ucollage) script which resides in
`{UCOLLAGE_PREFIX_DIR}/usr/bin`.

The next steps are:
- Source the configuration files and the the files residing in the
  `{UCOLLAGE_PREFIX_DIR}/usr/share/ucollage/src`
  [directory](https://github.com/ckardaris/ucollage/tree/master/src).
- Initialize `spacelist` and `sticklist` associative arrays that permit the <a
  href="autocomplete.html">autocomplete</a> functionality. 
- Check dependencies, parse the configuration files and set up the option variables. 
- Start the ueberzug daemon.
- The outer loop is initialized. This loops starts reading the files specified in the command line
  and is repeated **only** if we have a need to re-read the files (i.e. when the sort order is
  changed)
- The screen is cleared and at last,
- The inner [loop](https://github.com/ckardaris/ucollage/blob/master/src/loop.sh) is initialized.

## Looping
The loop function is quite simple.

The sequence of actions is:
- Wait for input by the user for a limited time(`-t` option in `read`). This permits reading input
  in a non-blocking way in order to be able to handle signals.
- Depending on the input, update the `prefix` or the `mapping`.
- If the mapping is valid (part of a defined mapping), show it on the status. If the mapping is
  complete execute the defined script. 
- Read files when they are available (i.e. during start up and after executing the `load_files`
  function).
- Update the status line.
