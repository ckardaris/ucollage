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
