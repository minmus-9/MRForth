( 0150-math.fth -- some math words )

-1 : -1 [ ' (literal) , , ] ;
 2 :  2 [ ' (literal) , , ] ;

: 1+      1 + ;
: 1-     -1 + ;
: invert -1 xor ;
: negate invert 1+ ;
: -      negate + ;
: cell+  cell + ;
: cell-  cell - ;

: 2*       dup + ;
: cells    2* ;
: cellbits [ cell 2* 2* 2* ] literal ;
: signbit  [ -1 -1 (urshift) xor ] literal ;

\ we call this "2/" for "division by 2"; however, it isn't
\ really division by 2 if the dividend is negative and odd.
\ oh, well...
: 2/       ( x -- x>>1 )
  signbit xor (urshift)
  [ signbit (urshift) negate ] literal
  +
;
: 4/  2/   2/ ; ( x -- x>>2 )
: 8/  4/   2/ ; ( x -- x>>3 )

( EOF 0150-math.fth )

