( 2600-utils.fth )

: pick ( xn ... x0 n -- xn ... x0 xn )
  1+ cells sp@ + @
;

: depth ( -- n )
  sp@ (sp0) swap - (urshift)
;

: h.
  base @ >r hex
  u.
  r> base !
;

: (dump) ( n -- )
  base @ >r
  decimal
  dup ." s: " s>d
    tuck dabs <# #s rot 0< if ascii - else bl then hold #>
    6 over - 0 max spaces type ."  | "
  dup ." u: " 5 u.r ."  | "
  hex
  ." h: 0x" 0 <# # # # # #> type
  r> base !
;

: .s ( -- )
  depth
  ." stack[" dup 0 <# #s #> type ." ] -> {"
  begin
    dup 0> while
      dup pick cr 2 spaces (dump)
      1-
      dup 0= if cr then
  repeat
  drop ." }" cr
;

: rdepth ( -- n )
  rp@ (rsp0) swap - (urshift)
;

: rpick ( xn ... x0 n -- xn ... x0 xn )
  cells rp@ + @
;

: .rs ( -- )
  rdepth
  ." rstack[" dup 0 <# #s #> type ." ] -> {"
  begin
    dup 0> while
      dup rpick cr 2 spaces (dump)
      1-
      dup 0= if cr then
  repeat
  drop ." }" cr
;

\ basic debug support via (debug)
variable '(debug)

: (nodebug) ;

' (nodebug) '(debug) !

: (debug) '(debug) @x ;

\ debug dumps stack
' .s '(debug) !

: h.s ( -- )
  depth
  ." stack " dup . ." -> "
  begin
    dup 0> while
      dup pick h.
      1-
  repeat
  drop cr
;

: unused ( -- nbytes )
  (ramtop) here -
;

: dump ( addr cnt -- )
  2 alloca           ( addr col# )
  over 5 u.r space ascii = emit ascii > emit cr
  7 +  -8 and
  swap -8 and
    lv0 !
  0 lv1 !
  0 ?do
    \ print addr?
    lv1 @ 0= if
      lv0 @ 5 u.r ascii : emit space
    then
    \ print data
    lv0 @ b@ 3 u.r space
    \ update addr
    1 lv0 +!
    \ update col#
    lv1 @ 1+ dup 8 = if
      drop 0 cr
    then
    lv1 !
  loop
  lv1 @ if cr then
;

: hexx
  '
  base @ >r
  hex
  catch
  r> base !
  throw
;

: wordcnt ( -- n, # of words defined in context vocab )
  1 alloca
  0 lv0 !
  latest begin
    dup while
    1 lv0 +!
    name>link @
  repeat drop
  lv0 @
;

: vwordcnt ( -- n, # unsmudged words defined )
  1 alloca
  0 lv0 !
  latest begin
    dup while
      dup c@ flag-smudge and 0=
      negate lv0 +!
      name>link @
  repeat drop
  lv0 @
;

: headcnt ( -- n, #bytes used for headers in context vocab )
  1 alloca
  0 lv0 !
  latest begin
    dup while            ( nfa )
    dup name>link        ( nfa lfa )
    tuck swap - cell+    ( lfa cnt )
    lv0 +! @             ( nfa )
  repeat drop
  lv0 @
;

: romcnt ( -- n, #bytes rom used )
  (xb) dup @         ( base endcode )
  dup @ cell+ +      ( base endsvtab )
  swap -
;

: ram0cnt ( -- n, #bytes ram used by core )
  (xb) @ @
;

: mrfstats ( -- , display mrforth stats )
  \ rom stats
  romcnt (u.) type
    ascii / emit
    (xs) (u.) type
    ."  ROM bytes used"
  cr
  2 spaces
  ram0cnt cell+ dup (u.) type ." svtab+"
    romcnt swap -   (u.) type ." code"
  cr
  \ dict stats
  vwordcnt (u.) type
    ascii / emit
    wordcnt u. ." vis/total words"
  cr
  2 spaces
  headcnt romcnt ram0cnt cell+ - over - swap
    (u.) type ." hdrs+"
    (u.) type ." defs"
  cr
  \ ram stats
  (rs) unused - (u.) type
    ascii / emit
    (rs) (u.) type
    ."  RAM bytes used"
  cr
  2 spaces
  ram0cnt     (u.) type ." core+"
    tib_size  (u.) type ." tib+"
    (maxrstk) (u.) type ." rstk+"
    (maxstk)  (u.) type ." stk"
  cr
  unused u. ." bytes RAM avail"
  cr
;

( EOF 2600-utils.fth )

