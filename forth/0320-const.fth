( 0320-const.fth -- constants )

: constant
  create ,
  does>
  @
;

: cconstant
  create c,
  does>
  c@
;

: bconstant
  create c,
  does>
  b@
;

-1 constant true
 0 constant false

( EOF 0320-const.fth )

