( 0920-math.fth -- misc math ops )

: urshift ( ux n -- ux>>n )
  [ cellbits 1- ] bliteral and
  0 ?do
    (urshift)
  loop
;

: rshift ( x n -- x>>n )
  [ cellbits 1- ] bliteral and
  0 ?do
    2/
  loop
;

: csplit ( x -- xl xh )
  sp@           ( x @x )
  dup 1+ b@     ( x @x xl )
  swap b@       ( x xl xh )
  rot drop
;

: cjoin ( xl xh -- x )
  sp@ cell+     ( xl xh @xl )
  c!
;

: lshift ( x n -- x<<n )
  [ cellbits 1- ] bliteral and
  0 ?do
    2*
  loop
;

: between ( n l h -- bool )
  >r over <= swap r> <= and
;

( EOF 0920-math.fth )

