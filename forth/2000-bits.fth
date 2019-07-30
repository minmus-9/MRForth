( 2000-bits.fth -- bit banging )

( ################################################################### )
( basic bit banging )

: $7 [ 7 ] bliteral ;

: csetbit ( addr n -- )
  $7 and 1 swap lshift
  over c@ or swap c!
;

: cclrbit ( addr n -- )
  $7 and 1 swap lshift 255 xor
  over c@ and swap c!
;

: ctogbit ( addr n -- )
  $7 and 1 swap lshift
  over c@ xor swap c!
;

: cbit? ( addr n -- )
  $7 and 1 swap lshift
  swap c@ and 0<>
;

( EOF 2000-bits.fth )

