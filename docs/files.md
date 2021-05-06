# Parsing Files

Handling the files specified as arguments in the command line creates some
interesting problems.

1. We have to determine if a file is an image, a video or any other file, in
   order to determine if it will be shown by the program or ignored. This
   process should be done as fast as possible. 
2. We need to complete the above process in parallel, in order to not block the
   main waiting loop of the program.

## Determining the file type

The program `file` can used to query the file type of any file. The relevant
command is
```bash
$ file --mime-type -b <file>
```

The naive approach was to execute the command on all file arguments each time
`ucollage` is executed. But since in the general use case the same files are
opened with `ucollage` again and again, and we also want to store some other
information about each file (rating, categories, etc.), another solution had to
be found. 

The final result is the use of a [hash
function](variables.html#UCOLLAGE_HASHFUNC). 

At first encounter with a file the hash of its first `100000` bytes is computed
(the `100000` number is completely arbitrary and was a selected as a nice
compromise between speed of computation and relative assurance that we won't
have hash collisions).

After determining the file type we create a file named after the hash value in
the appropriate directory in the
[UCOLLAGE_CACHE_DIR](variables.html#UCOLLAGE_CACHE_DIR). Hashes that correspond
to images go in `UCOLLAGE_CACHE_DIR/hash/images`, videos in
`UCOLLAGE_CACHE_DIR/hash/videos` and all other files in
`UCOLLAGE_CACHE_DIR/hash/other`. 

Each of the files can then store other information about that file (ratings,
categories, etc.). Using this model has 3 benefits:
- We can determine really fast if we have encountered a file, just by computing
  its hash and searching in our cache directory.
- We can store various information about each file.
- The info we store about a file are independent of its name, so we can rename
  it as many times as we want and the stored information refers to the same
  original file.

## Parallel execution

As mentioned reads **must not** block the main waiting loop of the program. The
idea is to run the `read_images` function in the background and do all
_interprocess_ communication by reading and writing files in the `tmp`
directory.

An race condition can arise in case we command the program to load more files
manually, using the `load_files` function. In order to prevent that, a simple
locking mechanism is implemented, again with the help of reading and writing
temporary files. When `read_images` is started it writes `1` in the `read_lock`
file in the temporary directory. A `0` is written when it finishes. The
`load_files` function must then confirm that the value written in the file is
`0` before it proceeds to ask the repetition of the procedure.
