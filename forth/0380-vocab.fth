( 0380-vocab.fth -- vocabularies )

: forth (forth) context ! ;

: definitions context @ current ! ;

: (svocabulary)
  create cell (ralloc) ,  
  does> @ context !
;

: (vocabulary)
  create 0 ,
  does> context !
;

variable '(vocabulary)
' (svocabulary) '(vocabulary) !

: (link>forth) ( -- ; relink latest word into forth vocab )
  latest dup >r      ( head )      ( R: head )  ( get latest nfa )
  name>link          ( link )      ( R: head )  ( get latest lfa )
  dup @              ( link hed0 ) ( R: head )  ( save lfa, get penult nfa )
  current @ !        ( link )      ( R: head )  ( unlink from current )
  (forth) @ swap !   ( )           ( R: head )  ( lfa gets latest forth )
  r> (forth) !       ( )           ( R: )       ( link to forth )
;

\ all vocabuaries live in the forth
\ vocabulary; this way, we can always
\ find them...
: vocabulary
  '(vocabulary) @x
  (link>forth)
;

( EOF 0380-vocab.fth )

