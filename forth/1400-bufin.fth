( 1400-bufin.fth -- input buffer mgt )

( ################################################################### )
( input mgt )

: source ( -- addr len )
  (ibuf)  @
  (iblen) @
;

: (set-source) ( addr len -- )
  (iblen) !
  (ibuf)  !
;

: set-source ( addr len -- )
  dup (iblimit) !
  (set-source)
  -1 (source) !
  0 >in !
;

: source-id ( -- bool, true if user buffer, false if input dev )
  (source) @
;

: save-input
  source
  (iblimit) @
  >in @
  source-id
  5
;

: restore-input
  5 <> abort" invalid restore-input record!"
  (source) !
  >in !
  (iblimit) !
  (set-source)
;

: (interact) ( -- , set up to get input from user )
  \ set src to tib
  tib_size (iblimit) !
  tib      (ibuf)    !
  0        (iblen)   !
  0        >in       !
;

( EOF 1400-bufin.fth )

