( 0100-compile.fth -- forth compilation words )

( these are needed below )
: +! dup >r @ + r> ! ;
: c, here c! 1 dp +! ;

( #################################################################### )
( compiler words )
: latest current @ @ ;

: [ 0 state ! ; immediate
: ] 1 state ! ;

: compile, , ;

: [compile] ' compile, ; immediate

: literal
  (literal)
  [compile] (literal)
  , ,
; immediate

: 'compile ' [compile] literal ; immediate

: (compile)
  [compile] literal
  [ ' compile, ] literal
  compile,
;

: compile ' (compile) ; immediate

: (cliteral)
  r> dup 1 + >r c@
;

: cliteral
  (literal)
  [compile] (cliteral)
  , c,
; immediate

: b@ c@ 255 and ;

: (bliteral)
  r> dup 1 + >r b@
;

: bliteral
  (literal)
  [compile] (bliteral)
  , c,
; immediate

: ['] ' ; immediate

: :noname here ] ;

( EOF 0100-compile.fth )

