( 1600-muldiv.fth -- multiplication and division )

( ################################################################### )
( mult/div )

: * ( i j -- i*j, 16*16->16 )
  0 -rot >r         ( r i ) ( R: j )
  begin             ( r i ) ( R: j )
    r> dup          ( r i j j )
    while           ( r i j )
      dup 1 and     ( r i j b )
      swap          ( r i b j )
      (urshift) >r  ( r i 0|1 ) ( R: j' )
      invert 1+     ( r i 0|-1 ) ( R: j' )
      >r tuck r>    ( i r i 0|-1 ) ( R: j' )
      and + swap    ( r' i ) ( R: j' )
      2*            ( r' i' ) ( R: j' )
  repeat
  2drop
;

variable $ml
variable $mh
: um* ( i j -- i*j, 16*16->32 unsigned )
  0 $ml !
  0 $mh !
  >r 0              (  i ih ) ( R: j )
  begin             ( il ih ) ( R: j )
    r> dup          ( il ih j j )
    while           ( il ih j )
      dup 1 and     ( il ih j b )
      swap          ( il ih b j )
      (urshift) >r  ( il ih b ) ( R: j' )
      negate        ( il ih m ) ( R: j' )
      >r 2dup r>    ( il ih il ih m ) ( R: j' )
      dup dand      ( il ih ql qh ) ( R: j' )
      $ml @ $mh @   ( il ih ql qh rl rh ) ( R: j' )
      d+            ( il ih rl' rh' ) ( R: j' )
      $mh ! $ml !   ( il ih ) ( R: j' )
      d<<           ( il' ih' ) ( R: j' )
  repeat
  drop 2drop
  $ml @ $mh @
;

: m* ( i j -- i*j, 16*16->32 signed )
  dup 0< dup >r        ( i j j<0 )       ( R: j<0 )
  tuck + xor           ( i |j| )         ( R: j<0 )
  swap dup 0< dup      ( |j| i i<0 i<0 ) ( R: j<0 )
  r> xor >r            ( |j| i i<0 )     ( R: p<0 )
  tuck + xor           ( |j| |i| )       ( R: p<0 )
  um*                  ( ul uh )
  r> if
    dnegate
  then
;

: sbits ( x -- highest-bit-set-in-x )
  signbit [ cellbits 1- ] literal >r
  begin            ( x mask ) ( R: n )
    2dup and if
      2drop r>
      exit
    then
    (urshift)
    r> 1-
    dup 0= if      ( x mask' n' )
      nip nip
      exit
    then
    >r
  again
;

: dbits ( d -- highest-bit-set-in-d )
  sbits
  dup if
    nip cellbits +
    exit
  then
  drop sbits
;

variable $ql
variable $qh
: (uds/) ( nl nh den -- rem ql qh, 32/16->32+16 unsigned )
  ( count bits )
  dup >r sbits >r         ( nl nh )                  ( R: d db )
  2dup dbits r> -         ( nl nh j )                ( R: d )
  ( prep denominator )
  r> swap >r 0 r@         ( nl nh dl dh j )          ( R: j )
  dlshift dnegate         ( nl nh vl vh )            ( R: j )
  0 $ql !
  0 $qh !
  begin                   ( nl nh vl vh )            ( R: j )
    r> dup 0>= while      ( nl nh vl vh j )
      1- >r               ( nl nh vl vh )            ( R: j' )
      2over 2over d+      ( nl nh vl vh zl zh )      ( R: j' )
      dup 0< if
        2drop
        0                 ( nl nh vl vh qb )         ( R: j' )
      else
        >r >r             ( nl nh vl vh )            ( R: j' zh zl )
        rot drop          ( nl vl vh )               ( R: j' zh zl )
        rot drop          ( vl vh )                  ( R: j' zh zl )
        r> -rot           ( zl vl vh )               ( R: j' zh )
        r> -rot           ( zl zh vl vh )            ( R: j' )
        1                 ( zl zh vl vh qb )         ( R: j' )
      then                ( nl' nh' vl vh qb )       ( R: j' )
      $ql @ $qh @         ( nl' nh' vl vh qb ql qh ) ( R: j' )
      d<< >r or r>        ( nl' nh' vl vh ql' qh' )  ( R: j' )
      $qh ! $ql !         ( nl' nh' vl vh )          ( R: j' )
      d>>                 ( nl' nh' vl' vh' )        ( R: j' )
  repeat
  2drop 2drop             ( rem )
  $ql @ $qh @             ( rem ql qh )
;

: mu/mod ( dnum den -- rem ql qh, 32/16->32+16 unsigned )
  dup 0= abort" zero divide!"
  dup 1 = if
    drop 0 -rot
    exit
  then
  (uds/)
;

: uds/ ( nl nh d -- rem quo, 32/16->16+16 unsigned )
  ( check for zero divide )
  dup 0= abort" zero divide!"
  ( check for divisor of 1 )
  dup 1 = if
    2drop 0 swap
    exit
  then
  (uds/) drop
;

\ XXX wrong! should be ( ud u -- r q )
: um/mod ( n1 n2 d -- r q, 16*16/16->16+16 unsigned )
  um* uds/
;

: /mod ( n d -- r q, 16/16->16+16 signed )
  swap dup 0< dup >r  ( d n n<0 )     ( R: n<0 )
  tuck + xor          ( d |n| )       ( R: n<0 )
  swap dup 0< dup >r  ( |n| d d<0 )   ( R: n<0 d<0 )
  tuck + xor          ( |n| |d| )     ( R: n<0 d<0 )
  0 swap uds/         ( r q )         ( R: n<0 d<0 )
  r> r> tuck xor      ( r q n<0 q<0 )
  swap >r             ( r q q<0 )     ( R: n<0 )
  if negate then      ( r q )         ( R: n<0 )
  swap r>             ( q r r<0 )
  if negate then
  swap
;

: / ( n d -- q, signed )
  /mod nip
;

: mod ( n d -- r, signed )
  /mod drop
;

: */mod ( n1 n2 d -- r q, signed )
  -rot m*             ( d xl xh, x=n1*n2 )
  dup 0< dup >r       ( d xl xh x<0 ) ( R: x<0 )
  if dnegate then     ( d zl zh )     ( R: n<0 ) ( z = |x| )
  rot dup 0< dup >r   ( zl zh d d<0 ) ( R: x<0 d<0 )
  tuck + xor          ( zl zh |d| )   ( R: x<0 d<0 )
  uds/                ( r q )         ( R: x<0 d<0 )
  r> r> tuck xor      ( r q x<0 q<0 )
  swap >r             ( r q q<0 )     ( R: x<0 )
  if negate then      ( r q )         ( R: x<0 )
  swap r>             ( q r r<0 )
  if negate then
  swap
;

: */ ( n1 n2 -- pl ph, signed )
  */mod nip
;

( EOF 1600-muldiv.fth )

