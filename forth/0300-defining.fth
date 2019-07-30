( 0300-defining.fth -- basic defining words )

: name>nchars ( nfa -- n )
  c@
  [ 18 (param) ] bliteral ( NAMELENMASK -- see below )  and
  [ 19 (param) ] bliteral ( MAXNAMESTORE -- see below ) min
;

: name>link ( addr -- laddr )
  dup name>nchars   ( addr len )
  + 1+
;

: (llcreate)
  drop
  here
  dup c@ [ 18 (param) ] bliteral and   ( here len ; name truncated )
  2dup swap c!                         ( here len ; name len updated )
  [ 19 (param) ] bliteral min          ( here cnt ; name char cnt done )
  over + 1 +                           ( here lfa ; got lfa )
  current @ @ over !                   ( here lfa ; lfa updated )
  swap current @ !                     ( lfa      ; current updated )
  2 + dp !                             (          ; dp updated )
;

\ in 1300-dict.fth we add the ability to do
\ name>cfa on primitives. for now, we can
\ only do it on secondaries (not a big deal)
: name>cfa ( addr -- xt )
  name>link cell+
;

: >body cell+ ;

: recurse
  latest name>cfa compile,
; immediate

: (does>) ( xt -- )
  latest name>cfa
  !
;

: does>
  0 [compile] literal
  here cell -
  compile (does>)
  [compile] ;
  :noname
  swap !
  compile r>
; immediate

: create
  bl token
  (create)
  0 ,
;

( EOF 0300-defining.fth )

