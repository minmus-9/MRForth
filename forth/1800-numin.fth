( 1800-numin.fth -- number input )

variable $nl
variable $nh
: ?number ( caddr -- d -1 | caddr 0 )
  \ count it
  dup >r count              ( addr count ) ( R: caddr )
  dup 0= if
    2drop r> 0 exit
  then
  \ determine base
  base @
  2 max 36 min
  >r                        ( addr count ) ( R: caddr base )
  \ check for leading -
  over b@ ascii - = if
    1- swap 1+ swap
    dup 0= if
      2drop r> 0 exit
    then
    1
  else
    0    
  then r> swap >r >r        ( addr count ) ( R: caddr neg? base )
  \ init result
  0 $nl ! 0 $nh !
  begin
    dup while
    \ lowercase the digit
    over b@ tolower
    \ range check
    dup ascii 0 ascii 9 between if
      ascii 0
    else
      dup ascii a ascii z between if
        ascii a 10 -
      else
        2drop r> r> 2drop
        r> 0 exit
      then
    then -                 ( addr count digit ) ( R: caddr neg? base )
    dup r@ >= if
      2drop drop r> r>
      2drop r> 0 exit
    then                   ( addr count dig )       ( R: caddr neg? base )
    \ multiply low 16
    r@ $nl @ um*           ( addr count dig d1 )    ( R: caddr neg? base )
    \ multiply high 16
    r@ $nh @ um*           ( addr count dig d1 d2 ) ( R: caddr neg? base )
    drop 0 swap            ( addr count dig d1 d' ) ( R: caddr neg? base )
    d+ rot m+              ( addr count d )         ( R: caddr neg? base )
    $nh ! $nl !            ( addr count )           ( R: caddr neg? base )
    \ prep for next round
    1- swap 1+ swap
  repeat
  \ finish up
  2drop r> drop            ( )   ( R: caddr neg? )
  $nl @ $nh @              ( d ) ( R: caddr neg? )
  r> if                    ( d ) ( R: caddr )
    dnegate
  then
  r> drop -1               ( d -1 )
;

\ XXX need >number ( ud addr cnt -- ud' addr' cnt' )
\ convert until unconvertible char encountered or
\ entire string consumed

\ XXX if number contains a dot, it's double otherwise single
\     outer.fth can make use of this fact

: $
  base @ >r
  hex
  bl word ?number
  r> base !
  not abort" invalid hex number!"
  drop
  state @ if
    [compile] literal
  then
; immediate

( EOF 1800-numin.fth )

