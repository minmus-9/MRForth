( 1000-string.fth -- string ops )

( ################################################################### )
( string stuff )

: (str)
  token drop
  here b@ 1+ allot
;

: ('str)
  ascii ' (str)
;

: ("str)
  ascii " (str)
;

: (c")
  r> dup dup   ( caddr caddr caddr ) ( R: )
  b@ + 1+      ( caddr ra )
  >r
;

: c"
  compile (c")
  ("str)
; immediate

: c'
  compile (c")
  ('str)
; immediate

: (s")
  r> dup dup   ( caddr caddr caddr ) ( R: )
  b@ + 1+      ( caddr ra )
  >r
  count        ( addr u )
;

: s"
  compile (s")
  ("str)
; immediate

: s'
  compile (s")
  ('str)
; immediate

: (.")
  r> dup dup   ( caddr caddr caddr ) ( R: )
  b@ + 1+      ( caddr ra )
  >r
  count        ( addr u )
  type
;

: ."
  compile (.")
  ("str)
; immediate

: .'
  compile (.")
  ('str)
; immediate

: lit"
  ascii " word count type
; immediate

( #################################################################### )
( set mem blocks )
: fill ( addr n char -- )
  -rot 0 ?do        ( char addr )
    2dup c! 1+
  loop
;

: erase ( addr u -- )
  0 fill
;

: blank ( addr u -- )
  bl fill
;

( #################################################################### )
( move stuff around )
: cmove ( src dst n -- )
  0 ?do
    over c@
    over c!
    1+ swap
    1+ swap
  loop
  2drop
;

: cmove> ( src dst n -- )
  dup >r       ( src dst n ) ( R: n )
  + 1- swap    ( dst' src ) ( R: n )
  r> swap      ( dst' n src )
  over + 1-    ( dst' n src' )
  -rot 0 ?do   ( src' dst' )
    over c@
    over c!
    1- swap
    1- swap
  loop
  2drop
;

( this handles overlapping moves correctly )
: <cmove> ( src dst n -- )
  >r
  2dup = if
    r> drop 2drop exit
  then
  2dup u< if
    r> cmove>
  else
    r> cmove
  then
;

( cell-based overlapping mover )
: move ( src dst n -- )
  cells <cmove>
;

( #################################################################### )
( simple string ops )
: tolower ( b -- b' )
  dup ascii A ascii Z between if
    ascii A - ascii a +
  then
;

: toupper ( c -- c' )
  dup ascii a ascii z between if
    [ ascii a ascii A - ] cliteral -
  then
;

: strcasecmp ( addr1 cnt1 addr2 cnt2 -- bool, true if strings match )
  >r over r>       ( addr1 cnt1 addr2 cnt1 cnt2 )
  <> if
    2drop drop
    false exit
  then swap        ( addr1 addr2 cnt )
  >r begin
    r> dup while
    1- >r
    over c@
    over c@ <> if
      2drop r> drop
      false exit
    then
    1+ swap
    1+ swap
  repeat
  2drop drop true
;

( EOF 1000-string.fth )

