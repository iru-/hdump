require mf/mf.f

: >addr  ( n - a n )  s>d hex <# 2 cells for # next #> decimal ;
: >hex   ( c - a n )  s>d hex <# # # #> decimal ;
: >char  ( c - c )    dup 32 127 within if exit then drop [char] . ;

0 value /line
variable off

: .addr    ( a )    >addr type ;
: .filler  ( n )    /line swap - 3 * spaces ;
: .hexes   ( a n )  swap a! for c@+ >hex type space next ;
: .chars   ( a n )  swap a! for c@+ >char emit next ;
: .line    ( a n )
  off @ .addr 2 spaces 2dup .hexes dup .filler 2 spaces .chars ;


variable remaining
0 value fd

: /read       ( - n )  remaining @ /line min ;
: -remaining  ( n )    negate remaining +! ;

: open      ( a n )  r/o open-file throw to fd ;
: position  ( n )    s>d fd reposition-file throw ;
: close              fd close-file throw ;
: read      ( - a n )  
  here /read fd read-file throw
  dup -remaining  dup off +!  here swap ;

: setup  ( a n start end line# )
  to /line  over - remaining !  push
  open pop position  0 off ! ;

: (hdump)  ( a n start end #line )
  setup cr begin read dup while .line cr repeat drop drop close ;

: fsize  ( a n - u )
  r/o open-file throw dup file-size throw d>s swap close-file throw ;

: hdump  ( a n )  2dup fsize 0 swap 16 (hdump) ;
