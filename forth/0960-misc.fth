( 0960-misc.fth -- misc ops )

: allot   dp +! ;
: aligned [ cell 1- ] bliteral + [ cell negate ] bliteral and ;
: align   dp @ aligned dp ! ;

: ?dup
  dup if dup then
;

( EOF 0960-misc.fth )

