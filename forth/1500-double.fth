( 1500-double.fth -- double number ops )

: 2constant  ( x1 x2 -- ) ( runtime: x1 x2 )
  create , ,
  does>
  dup cell+ @ swap @
;

: (s2variable)
  2 cells (ralloc) constant
;

: (2variable)
  create 0 , 0 ,
  does>
;

here 0 , constant '(2variable)

' (s2variable) '(2variable) !

: 2variable
  '(2variable) @x
;

: (2literal)
  r> dup cell+ dup cell+ >r
  @ swap @
;

: 2literal
  (literal)
  [compile] (2literal)
  , , ,
; immediate

: dand ( d1 d2 -- d1&d2 )
  >r rot  and
  swap r> and
;

: dor
  >r rot  or
  swap r> or
;

: dxor
  >r rot  xor
  swap r> xor
;

: m+ ( xl xh yl -- x+yl x+yh, 32+16->32 )
  swap >r           ( xl yl ) ( R: xh )
  over +            ( xl zl ) ( R: xh )
  dup rot           ( zl zl xl ) ( R: xh )
  u< negate         ( zl c ) ( R: xh )
  r> +
;

: d+ ( xl xh yl yh -- x+yl x+yh, 32+32->32 )
  >r m+ r> +
;

: d<< ( d -- d<<1 )
  >r                  ( xl ) ( R: xh )
  dup 0< negate       ( xl b ) ( R: xh )
  swap 2* swap        ( xl<<1 b ) ( R: xh )
  r> 2* or
;

: dlshift ( d n -- d<<n )
  [ cellbits 2* 1- ] bliteral and
  dup 0<= if drop exit then
  0 do d<< loop
;

: (d>>) ( xl xh -- xl>>1 xh )
  dup 1 and           ( xl xh xh0 )
  negate signbit and  ( xl xh xln )
  swap >r swap        ( xln xl ) ( R: xh )
  (urshift) or
  r>                  ( xl>>1 xh )
;

: d>> ( d -- d>>1, dbl arith right shift )
  (d>>) 2/
;

: ud>> ( d -- d>>1, dbl logical right shift )
  (d>>) (urshift)
;

: dinvert ( d -- ~d )
  >r invert
  r> invert
;

: dnegate ( d -- -d )
  dinvert 1 m+
;

: dabs ( d -- |d| )
  dup 0< if dnegate then
;

: d0=
  or 0=
;

: d0<>
  or 0<>
;

: d0<
  nip 0<
;

: d0>=
  d0< not
;

: d0>
  nip 0>
;

: d0<=
  d0> not
;

: d2*
  2dup d+
;

: d2/
  d>>
;

: d-
  dnegate d+
;

: d=
  d- d0=
;

: d<>
  d- d0<>
;

: d<
  d- 0<
;

: d<=
  d- d0<=
;

: d>
  d- d0>
;

: d>=
  d- d0>=
;

: dmin ( d1 d2 -- d )
  2over 2over d> if
    2swap
  then 2drop
;

: dmax ( d1 d2 -- d )
  2over 2over d< if
    2swap
  then 2drop
;

: drshift ( d n -- d>>n, arithmetic )
  [ cellbits 2* 1- ] bliteral and
  dup 0<= if drop exit then
  0 do d>> loop
;

: udrshift ( d n -- d>>n, logical )
  [ cellbits 2* 1- ] bliteral and
  dup 0<= if drop exit then
  0 do ud>> loop
;

( EOF 1500-double.fth )

