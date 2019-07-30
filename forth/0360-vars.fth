( 0360-vars.fth -- variables )

\ during core generation, dp points into what will later be rom,
\ so we need a concept of "comma" for ram. the next word provides
\ exactly this functionality and is used to implement vars.
: (ralloc)        ( n -- )
  (ramp) dup >r   ( n ramp ) ( R: ramp )
  @ tuck +        ( rp rp' ) ( R: ramp )
  r> !            ( rp )
  0 over !        ( rp )
;

\ variable decl in sysgen mode
: (svariable)
  cell (ralloc) constant
;

\ variable decl in execute mode
: (variable)
  create 0 ,
  does>
;

here 0 , constant '(variable)

' (svariable) '(variable) !

\ we make all this transparent to the user
: variable
  '(variable) @x
;

\ do cvariable
: (scvariable)
  1 (ralloc) constant
;

: (cvariable)
  create 0 c,
  does>
;

here 0 , constant '(cvariable)

' (scvariable) '(cvariable) !

: cvariable
  '(cvariable) @x
;

\ and, finally, bvariable
: bvariable cvariable ;

( EOF 0360-vars.fth )

