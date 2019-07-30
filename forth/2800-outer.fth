( 2800-outer.fth -- outer intepreter )

: get-entry ( -- xt )
  (outer) @
;

: set-entry ( xt -- )
  (outer) !
;

: cmpl-lit ( d -- )
  ( handle double/single )
  dup case      ( xl xh xh )
      -1 of     ( xl xh, neg sngl? )
         over 0< not if
           ( double. )
           [compile] 2literal exit
         then
         ( yup, neg sngl -- fall through )
         endof
       0 of     ( xl xh, pos sngl -- fall through )
         endof
    ( double. )
    drop [compile] 2literal exit
  endcase
  drop                    ( n )
  ( smaller than double )
  dup csplit case         ( n nl nh )
     255 of               ( n nl, neg char? )
         dup 128 and not if
           ( cell. )
           drop [compile] literal exit
         then
         ( neg char. )
         [compile] cliteral drop exit
         endof
       0 of               ( n nl, pos byte )
         [compile] bliteral drop exit
         endof
  endcase
  ( cell. )
  drop [compile] literal exit
; immediate

: interpret
  begin
    bl word              ( addr )
    dup b@ 0=            ( addr empty? )
    if drop exit then    ( addr )
    find                 ( addr # )
    dup if               ( addr # )
      1 =                ( addr b1 )
      state @ not        ( addr b2 )
      or if              ( addr )
        execute          ( )
      else
        ,                ( )
      then
    else                 ( addr # )
      drop               ( addr )
      ?number
      if
        state @ if
          [compile] cmpl-lit
        else
          d>s
        then
      else
        ." unknown word len="
        count dup .
        ." [" type ." ]" cr
        xbadword throw
      then
    then
  again
;

: evaluate ( addr len -- )
  save-input
  5 <> abort" logs in the bedpan!"
  >r >r >r >r >r
  set-source
  interpret
  r> r> r> r> r> 5
  restore-input
;

' evaluate (eval) !

: (patchit)
  \ empty stack
  (sp0) sp!
  \ unlink if compiling
  state @ if
    0 state !              ( enter execution mode )
    latest                 ( get nfa of partially compiled defn )
    dup dp !               ( reset dp )
    name>link              ( get lfa )
    @ current @ !          ( get prev nfa, update current )
  then
  \ reset return stack
  0 (rsp0) !               ( rtos => 0 for runxt in mrfrun.c )
  get-entry (rsp0) cell -  ( prep push of restart addr )
  tuck ! rp!               ( do the push; execution resumes at restart )
;

: (dpy-err)
  ." ERROR: "
  case
     -1 of ." ABORT called"           endof
     -2 of .' ABORT" called: '
           abort"msg @ count type     endof
     -3 of ." Address fault"          endof
     -4 of ." Invalid param"          endof
     -5 of ." Exe bus fault"          endof
     -6 of ." Illegal VM instruction" endof
     -7 of ." Return stack corrupt"   endof
     -8 of ." Undefined word"         endof
     -9 of ." Stack underflow"        endof
    -10 of ." Stack overflow"         endof
    -11 of ." Return stack underflow" endof
    -12 of ." Return stack overflow"  endof
    ." code = s:" dup . ." u:" dup u. ." 0x" dup h.
  endcase
  cr
;

: quit
  begin
    (interact)
    ." mrforth> "
    refill while
      'compile interpret
      catch
      dup if
        (dpy-err)
        (patchit)
        \ NOT REACHED
      else
        drop
        ." ok" cr
      then
  repeat
;

: (banner)
  mrfstats
  cr
  \ welcome msg
  ." Welcome to mrforth!" cr
  cr
  .' Type "bye" to exit mrforth' cr
  cr
;
forth

: (main)
  (banner)
  \ restart goes to quit
  'compile quit set-entry
  \ jump to entry
  (patchit)
;

' (main) set-entry

( EOF 2800-outer.fth )

