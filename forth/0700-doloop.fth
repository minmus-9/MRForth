( 0700-doloop.fth -- do loops )

( ################################################################### )
( do loops )

: (do)  ( end bgn -- ) ( R: ra -- end bgn ra )
  r> -rot        ( ra' end bgn )
  swap >r >r >r  ( R: end bgn ra' )
;

: do
  compile (do)
  false          ( no exit addr )
  here           ( loop target )
; immediate

: (?do)  ( end bgn -- ) ( R: ra -- [end bgn] ra' )
  2dup <= if
    2drop
    r> @ >r       ( R: ra' )
    exit
  then
  r> cell+ -rot   ( skip exit addr )
  swap >r >r >r
;

: ?do
  compile (?do)
  here          ( fwd exit addr )
  true
  0 ,
  here          ( loop target )
; immediate

: (loop)     ( R: end cur ra )
  r> r> r>   ( ra cur end )
  swap 1+    ( ra end cur' )
  2dup > if  ( ra end cur' )
    swap
    >r >r    ( ra ) ( R: end cur' )
    @ >r     ( R: end cur' ra' )
    exit
  then
  2drop
  cell+ >r   ( R: ra' )
;

: loop
  compile (loop)
  ( compile loop target )
  compile,
  ( compile exit addr if needed )
  if here swap ! then
; immediate

: unloop     ( R: end cur ra -- ra )
  r> r> r>
  2drop >r
;

: (+loop)    ( inc ) ( R: end cur ra )
  r> swap    ( ra inc ) ( R: end cur )
  r> + r>    ( ra cur' end )
  swap       ( ra end cur' )
  2dup > if  ( ra end cur' )
    swap
    >r >r    ( ra ) ( R: end cur' )
    @ >r     ( R: end cur' ra' )
    exit
  then
  2drop
  cell+ >r   ( R: ra' )
;

: +loop
  compile (+loop)
  ( compile loop target )
  compile,
  ( compile exit addr if needed )
  if here swap ! then
; immediate

: leave ( R: end cur ra -- end end ra )
  r> r> drop r>    ( ra end )
  dup >r >r >r     ( R: end end ra )
;

: i ( -- cur ) ( R: end cur ra )
  r> r@ swap >r
;

: j ( -- cur ) ( R: end cur end2 cur2 ra )
  r> r> r> r@  ( ra cur2 end2 cur ) ( R: end cur )
  swap >r -rot ( cur ra cur2 )      ( R: end cur end2 )
  >r >r
;

( EOF 0700-doloop.fth )

