( 0940-double.fth -- basic double-word stuff )

: 2! ( xl xh addr -- )
  tuck ! cell+ !
;

: 2@ ( addr -- xl xh )
  dup cell+ @ swap @
;

: s>d
  dup 0<
;

: d>s
  drop
;

( EOF 0940-double.fth )

