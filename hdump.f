warnings off
require mf/mf.f

: not  0= ;
: fsize  ( a n - u )
  r/o open-file throw dup file-size throw d>s swap close-file throw ;

0 value /line
variable off

: h#     ( n )    # # ;
: .off            off @ s>d <# cell for h# next #> type ;
: align  ( n )    /line swap - 3 * spaces ;
: h.     ( n )    s>d <# h# #> type space ;
: bytes  ( a n )  swap a! for c@+ h. next ;
: c.     ( c )    dup bl 127 within not if drop [char] . then emit ;
: text   ( a n )  swap a! for c@+ c. next ;
: line   ( a n )  .off 2 spaces 2dup bytes dup align 2 spaces text ;

variable remaining
0 value fd

: size        ( - n )  remaining @ /line min ;
: remaining-  ( n )    negate remaining +! ;
: off+        ( n )    off +! ;
: update      ( n )    dup remaining- off+ ;

: open      ( a n )    r/o open-file throw to fd ;
: position  ( n )      s>d fd reposition-file throw ;
: close                fd close-file throw ;
: read      ( a - n )  size fd read-file throw dup update ;

: setup  ( a n start end width )
  to /line  over - remaining !  push
  open pop position  0 off ! hex ;

: (hdump)  ( a n start end width )
  setup begin here read dup while here swap line cr repeat drop close ;

: hdumped  ( a n )  2dup fsize 0 swap 16 (hdump) ;
: hdump  bl word count hdumped ;
