( 2400-kbd.fth -- keyboard support )

\ create overridable "key"
variable '(key)

' (key) '(key) !

: key '(key) @x ;

\ line-reading from kbd
: (accept)
  begin
    key
    \ line end?
    dup eol = over cret = or if
      drop exit
    then
    \ check for backspace
    dup 8 = if
      drop
      lv0 @ 0<> if
        -1 lv0 +!  \ dec cnt
        -1 lv2 +!  \ dec addr
         1 lv1 +!  \ inc len
      then
    else
      \ normal char
      1 lv0 +!      \ bump count
      lv2 tuck @    \ get addr
      c! 1 swap +!  \ store and bump addr
      lv1 @ 1-      \ decr len
      \ out of space?
      dup 0= if
        2drop exit
      then
      lv1 !
    then
  again
;

: accept ( caddr len -- cnt )
  3 alloca
  dup 0= if
    nip exit
  then
  0 lv0 !   ( 0 => cnt  )
    lv1 !   ( 1 => len  )
    lv2 !   ( 2 => addr )
  (accept)
  lv0 @  
;

\ get another line from current input src if possible
: refill ( -- bool )
  source-id if false exit then
  \ get ready
  (interact)
  \ read a line
  tib tib_size accept
  \ adjust buffer len
  (iblen) !
  true
;

\ replace (word), at long last
: (in-ch) ( -- char|EOB )
  >in @ dup (iblen) @ >= if   ( ibptr )
    drop (eob) exit
  then
  dup 1+ >in !                ( ibptr )
  (ibuf) @ + b@               ( char  )
;

: is-white ( char -- bool, if char whitespace? )
  case
    bl    of true endof
    eol   of true endof
    cret  of true endof
    tab   of true endof
    false swap
  endcase
;

\ finish up (word)
: (wadios) ( -- )
  (eob) lv0 @ tuck c!    ( ptr )
  lv2 @ tuck             ( dst ptr dst )
  - 1- swap c!           ( -- )
;

: (wurd) ( delm dst -- dst, parse word )
  3 alloca                    ( delm dst )
  0 over c!                   ( dst, zero dst's len )
  dup lv2 !                   ( dst, lv2 is dst )
  1+ lv0 !                    ( -- , lv0 is ptr )
  [ 127 ] bliteral and lv1 !  ( dst, lv1 is delm )
  lv2 @                       ( leave dst on stack, ignore in stk pix below )
  ( skip leading delms if delm is space )
  lv1 @ bl = if
    begin                     ( -- )
      (in-ch)                 ( char )
      dup (eob) = if
        lv0 @ c! exit
      then
      [ 127 ] bliteral and    ( char, make it be ascii )
      dup is-white while      ( char )
      drop                    ( -- )
    repeat                    ( char )
    lv0 @ tuck c!             ( ptr )
    1+ lv0 !                  ( -- , ptr updated )
  then
  ( read rest of chars )
  begin                       ( -- )
    (in-ch)
    dup (eob) = if            ( char )
      drop (wadios) exit
    then                      ( char )
    [ 127 ] bliteral and      ( char, make it be ascii )
    ( delim? )
    lv1 @ bl = if             ( char )
      dup is-white
    else
      dup lv1 @ =
    then                      ( char delm? )
    if
      drop (wadios) exit
    then                      ( char )
    ( save it, check space )
    lv0 @ tuck c!             ( ptr )
    1+ dup lv0 !              ( ptr' )
    lv2 @ - 255 > if          ( -- )
      (wadios) exit
    then
  again
;

' (wurd) '(word) !

( EOF 2400-kbd.fth )

