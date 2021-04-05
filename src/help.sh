help(){
    echo "Usage: ucollage [images] [directories]"
    echo
    echo "Controls:"
    echo "  Backspace            exit monocle mode"
    echo "  :                    enter command mode"
    echo "  .                    repeat last action (a new prefix must be given)"
    echo "  n/right arrow        get next batch of images"
    echo "  N/shift+right arrow  get last batch of images"
    echo "  p/left arrow         get previous batch of images"
    echo "  P/shift+left arrow   get first batch of images"
    echo "  tp                   toggle exec prompt"
    echo "  tn                   toggle filenames on screen"
    echo "  ss                   set sort type"
    echo "  tr                   toggle reverse sort"
    echo "  su                   set ueberzug scaler"
    echo "  q                    exit"
    echo
    echo "Controls with vim-like prefix counters"
    echo "  (N)-        decrease both the numbers of columns and lines by N"
    echo "  (N)+/=      increase both the numbers of columns and lines by N"
    echo "  (N)ci       rename image with index N"
    echo "  (N)di       move image with index N to Trash"
    echo "  (N)u        undo edits of image with index N"
    echo "  (N)Ctrl+r   redo edits of image with index N"
    echo "  (N)r        rotate clockwise image with index N"
    echo "  (N)R        rotate counter-clockwise image with index N"
    echo "  (N)h        decrease number of columns by N"
    echo "  (N)j        decrease number of lines by N"
    echo "  (N)k        increase number of lines by N"
    echo "  (N)l        increase number of columns by N"
    echo "  (N)gi       enter monocle mode; go to image with index N"
    echo "  (N)sg       set grid size"
    echo "  (N)ti       tag image with index N"
    echo "  (N)dt       untag image with index N"
    echo "  (N)wi       save edits of image with index N"
    echo "  (N)xi       execute different commands for each image with index N"
    echo "              placeholders are available for command execution"
    echo "                  %s - image filename"
    echo "                  %e - edited image filename"
    echo "  (N)xs       execute same command for each image with index N"
    echo "              placeholders are available for command execution"
    echo "                  %s - image filename"
    echo "                  %e - edited image filename"
    echo "  (N)xg       execute one command for all images with index N"
    echo "              placeholders"
    echo "                  %S - all image filenames side by side"
    echo "                  %E - all edited image filenames side by side"
}