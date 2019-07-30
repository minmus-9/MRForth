( 2100-private.fth -- privatization )

( ################################################################### )
( privatization )

: (smudge) ( nfa -- )
  \ drop exit \ NB uncomment this for "make colls"
  flag-bsmudge csetbit
;

: (unsmudge) ( nfa -- )
  flag-bsmudge cclrbit
;

: smudge
  bl word 0 searchx
  not abort" SMUDGE cannot find word!"
  (smudge)
;

: unsmudge
  bl word 0 searchx
  not abort" UNSMUDGE cannot find word!"
  (unsmudge)
;

variable $priv-begin
variable $priv-end

: private{
  $priv-begin @ abort" extra private{"
  latest $priv-begin !
  0      $priv-end   !
;

: }private
  $priv-begin @ 0= abort" missing private{"
  $priv-end   @    abort" extra }private"
;

: privatize
  $priv-begin @ 0= abort" missing private{"
  $priv-end   @ 0= abort" missing }private"
  $priv-end   @
  begin
    dup $priv-begin @ u>
    while
      dup (smudge)
      name>link @
  repeat
  drop
  0 $priv-begin !
  0 $priv-end   !
;

( EOF 2100-private.fth )

