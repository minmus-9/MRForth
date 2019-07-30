( 2200-patch.fth -- compiler patch )

( ################################################################### )
( compiler patch )

( semi needs to unsmudge the word being defined )
' ;
: ;
  [ compile, ]
  latest (unsmudge)
[ ' exit , immediate

( colon smudges the word being defined )
' :
: :
  [ compile, ]
  latest (smudge)
[ ' exit ,

( EOF 2200-patch.fth )

