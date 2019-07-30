( 1200-abort.fth -- abort/bye/quit )

variable abort"msg

: (abort") ( flag -- )
  r> dup dup         ( flag caddr caddr caddr ) ( R: )
  b@ + 1+ >r         ( flag caddr ) ( R: ra )
  swap               ( caddr flag )
  if                 ( caddr )
    dup abort"msg !  ( caddr )
    ?nohandler if
      count type cr
    else
      drop
    then
    xabort" throw
  then
  drop
;

: abort" ( bool -- )
  compile (abort")
  ("str)
; immediate

: abort
  xabort throw
;

( EOF 1200-abort.fth )

