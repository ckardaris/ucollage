help(){
    echo "Usage: ucollage [images] [directories]"
    echo
    echo "Controls:"
    echo "  .                       repeat last action"
    echo "  :                       enter command mode"
    echo "  Backspace               exit monocle mode or select previous image in wide mode"
    echo "  Ctrl - l                load more images"
    echo "  Space                   select next image in wide mode"
    echo "  n or Ctrl - →           get next batch of images"
    echo "  N or Ctrl - Shift - →   arrow  get last batch of images"
    echo "  p or Ctrl - ←           get previous batch of images"
    echo "  P or Ctrl - Shift - ←   get first batch of images"
    echo "  q                       exit"
    echo "  sf                      set fileinfo type"
    echo "  ss                      set sort type"
    echo "  su                      set ueberzug scaler"
    echo "  tf                      toggle fileinfo on screen"
    echo "  tp                      toggle exec prompt"
    echo "  tr                      toggle reverse sort"
    echo
    echo "Controls with vim-like prefix counters"
    echo "  ++                      increase both the numbers of columns and lines"
    echo "  +|                      increase the number of columns"
    echo "  +_                      increase the number of lines"
    echo "  -+                      decrease both the numbers of columns and lines"
    echo "  -|                      decrease the number of columns"
    echo "  -_                      decrease the number of lines"
    echo "  Enter                   enter monocle mode; go to image"
    echo "  Shift - ←               shift image left"
    echo "  Shift - ↑               shift image up"
    echo "  Shift - →               shift image right"
    echo "  Shift - ↓               shift image down"
    echo "  ci                      set categories"
    echo "  di                      move to Trash"
    echo "  dt                      untag"
    echo "  h - ←                   shift image left"
    echo "  j - ↓                   shift image down"
    echo "  k - ↑                   shift image up"
    echo "  l - →                   shift image right"
    echo "  mv                      rename"
    echo "  rh                      rotate counter-clockwise"
    echo "  rl                      rotate clockwise"
    echo "  ri                      rate"
    echo "  si                      set current selection"
    echo "  sg                      set grid size"
    echo "  ti                      tag"
    echo "  u                       undo edits"
    echo "  Ctrl - r                redo edits"
    echo "  wi                      save edits"
    echo "  !                       execute command"
    echo "                          -> placeholders:"
    echo "                                  %s - original file"
    echo "                                  %S - all original files"
    echo "                                  %e - edited file"
    echo "                                  %E - all edited files"
    echo "                                  %d - destination file in edit scripts"
}
