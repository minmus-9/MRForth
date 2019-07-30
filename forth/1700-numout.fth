( 1700-numout.fth -- number output )

( ################################################################### )
( number formatting )

variable (hold)

: hold ( char -- )
  -1 (hold) +!
  (hold) @ c!
;

: (npad) pad ;

: <# ( -- )
  (npad) (hold) !
;

: #> ( d -- addr len )
  2drop
  (hold) @ (npad) over -
;

: sign ( n -- )
  0< if ascii - hold then
;

: # ( d -- d )
  base @ 2 max 36 min mu/mod rot   ( d' rem )
  9 over < if
    10 - ascii a
  else
    ascii 0
  then + hold
;

: #s ( d -- d )
  begin
    # 2dup d0=
  until
;

: (ud.) ( ud -- addr count )
  <# #s #>
;

: ud. ( ud -- )
  (ud.) type space
;

: ud.r ( ud n -- )
  >r (ud.)
  r> over -
  0 max spaces
  type
;

: (d.) ( d -- addr count )
  tuck dabs <# #s rot sign #>
;

: d. ( d -- )
  (d.) type space
;

: (p.r) ( addr count width -- )
  over - 0 max spaces type
;

: d.r ( d n -- )
  >r (d.) r> (p.r)
;

: (u.) ( n -- addr u )
  0 (ud.)
;

: u.
  0 ud.
;

: u.r ( u n -- )
  0 swap ud.r
;

: (.) ( x -- addr u )
  s>d (d.)
;

: . (.) type space ;

: .r ( n w -- )
  >r (.) r> (p.r)
;

: ? @ . ;

: (prex)
  ." EXC# = " . cr
;

' (prex) (prx) !

( EOF 1700-numout.fth )

