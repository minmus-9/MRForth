( 0800-case.fth -- case stmt )

( ################################################################### )
( case stmt )

variable of-count

: case ( n -- n , start case stmt ) ( -c- -- old-count )
  of-count @
  0 of-count !
; immediate

: (?of) ( n flag -- | n , do if true )
  [compile] if
  compile   drop
  1 of-count +!
;

: of ( n t -- | n , do if match )
  compile over compile =
  [compile] (?of)
; immediate

: (?rangeof) ( n l h -- n flag )
  >r over <=    ( n lbool ) ( R: h )
  over r> <=    ( n lbool hbool )
  and
;

: rangeof ( n l h -- | n , do if in bounds )
  compile   (?rangeof)
  [compile] (?of)
; immediate

: endof ( -- , finish "of" )
  [compile] else
; immediate

: endcase ( n -- ) ( -c- old-count -- )
  compile drop
  ( match everything up )
  of-count @ 0
  ?do
    [compile] then
  loop
  of-count !
; immediate

( EOF 0800-case.fth )

