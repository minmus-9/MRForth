( 1300-misc.fth -- more random ops )

( ################################################################### )
( [re]define search, find, tick )

( make name>cfa work with primitives, too. )
' name>cfa
: name>cfa
  dup [ , ] swap    ( NB old defn called! )
  c@ flag-prim and
  if c@ then
;

: nfa.match ( addr nfa -- bool, true if match )
  ( smudged? )
  dup c@ flag-smudge and if
    2drop 0 exit
  then
  ( lengths match? )
  over c@ over c@ namelengthmask and dup >r <> if
    2drop r> drop false exit
  then
  r> maxnamestore min             ( addr nfa maxcmp )
  swap 1+ swap                    ( addr nptr maxcmp )
  dup >r rot                      ( nptr maxcmp addr ) ( R: maxcmp )
  count r> min                    ( nptr maxcmp addr cnt )
  strcasecmp
;

: search.nfa ( nfa addr -- addr 0 | nfa 1 | nfa -1 )
  swap >r begin             ( addr ) ( R: nfa )
    r> dup while            ( addr nfa )
    2dup nfa.match if
      nip                   ( nfa )
      -1 over c@ flag-immed ( nfa -1 hed imm )
      and if
        negate
      then
      exit
    then                    ( addr nfa )
    name>link @ >r          ( addr ) ( R: nfa' )
  repeat
  drop 0
;

: search ( nfa addr cfa? -- addr 0 | [nc]fa 1 | [nc]fa -1 )
  >r search.nfa r>
  over if                ( addr bool cfa? )
    if                   ( addr -1|1 )
      swap name>cfa swap
    then
  else
    drop
  then
;

: searchx ( addr cfa? -- addr 0 | [nc]fa 1 | [nc]fa -1 )
  tuck
  context @ @ -rot search
  dup if
    rot drop exit
  then drop swap
  (forth) @ -rot search
;

: find ( addr -- addr 0 | [nc]fa 1 | [nc]fa -1 )
  1 searchx
;

: (')
  bl word find 0= if
    ?nohandler if
      ." unknown word [" count type ." ] encountered!" cr
    then
    xbadword throw
  then
;

' (') '(') !

( ################################################################### )
( postpone )

: postpone
  bl word find
  dup 0= if
    drop 1 abort" postpone cannot find word!"
    exit
  then
  dup 1 = if
    drop compile,
    exit
  then
  drop
  (compile)
; immediate

( ################################################################### )
( evil words )

: marker
  latest here create , ,
  does>
  dup           ( ctxaddr ctxaddr )
  @             ( ctxaddr olddp )
  dp !          ( ctxaddr )
  cell+ @       ( oldctx  )
  context @ !   ( ) \ context since that's where it's found
;

: forget
  bl token 0 searchx
  0= if xbadword throw then
  ( make sure we're not in rom :-)
  dup (xb) @ u<= abort" Can't forget word in ROM!"
  ( okey doke -- do it )
  dup name>link @ context @ ! dp ! \ context since that's where it's found
;

( ################################################################### )
( more dict-banging )
: (id) ( nfa -- addr cnt )
  dup 1+ swap name>nchars
;

: id. ( nfa -- )
  dup b@ namelengthmask and swap  ( namelen nfa )
  (id) tuck type                  ( namelen nch )
  - dup 0> if
    0 do ascii _ emit loop
  else
    drop
  then
;

: words ( -- , print all defined words )
  latest
  begin
    dup while
      dup c@ flag-smudge and 0= if
        dup id. space
      then
      name>link @
  repeat
  drop cr
;

( EOF 1300-misc.fth )

