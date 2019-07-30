( 0900-output.fth -- emit and friends )

\ create overridable "emit"
variable '(emit)

' (emit) '(emit) !

: emit '(emit) @x ;

\ emit-related stuff
: space bl  emit ;
: cr    eol emit ;

: type ( addr n -- )
  0 ?do
    dup c@ emit 1+
  loop
  drop
;

: count dup 1+ swap b@ ;

: .(
  (rpar) word count type cr
; immediate

: char
  bl word 1+ c@ 127 and
;

: [char] char [compile] bliteral ; immediate

: ascii
  char
  state @ if
    [compile] bliteral
  then
; immediate

: spaces
  0 ?do space loop
;

\ we need count for this...
: parse word count ;

( EOF 0900-output.fth )

