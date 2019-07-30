( 1900-value.fth -- values and deferred words )

( #################################################################### )
( values and deferred words )

: value
  create
  ,
  immediate
  does>
    state @
    if
      [compile] literal
      compile @
    else
      @
    then        
;

: to
  bl word find
  0= abort" cannot find requested word"
  >body
  state @
  if
    [compile] literal
    compile !
  else
    !
  then
; immediate

: (dfldefer)
  1 abort" undefined deferred word called!"
;

: defer
  create
  compile (dfldefer)
  does>
    @x
; immediate

( EOF 1900-value.fth )

