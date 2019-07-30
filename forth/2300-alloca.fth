( 2300-alloca.fth -- alloca-style allocation )

( ################################################################### )
( alloca-style frame support )

( frame pointer var )
variable '(frame)
0 '(frame) !

: (frame) ( R: cra frame... ofp rsp -- cra )
  r> r>      ( rsp ofp )
  '(frame) ! ( rsp )
  rp!
;

: alloca ( #cells -- )
  r> swap         ( ra #cells )        ( R: cra )
  cells           ( ra ofs )           ( R: cra )
  rp@ dup rot -   ( ra rsp rsp' )      ( R: cra )
  tuck            ( ra fptr rsp rsp' ) ( R: cra )
  rp!             ( ra fptr rsp )      ( R: cra frame... )
  '(frame) @ >r   ( ra fptr rsp )      ( R: cra frame... ofp )
  >r              ( ra fptr )          ( R: cra frame... ofp rsp )
  '(frame) !      ( ra )               ( R: cra frame... ofp rsp )
  ['] (frame)     ( ra fa )            ( R: cra frame... ofp rsp )
  literal >r      ( ra )               ( R: cra frame... ofp rsp fa )
  >r              ( )                  ( R: cra frame... ofp rsp fa ra )
;

: lvar ( n -- addr ) ( R: cra frame... rsp fa ra )
  cells '(frame) @ +
;

: lv0 0 lvar ;
: lv1 1 lvar ;
: lv2 2 lvar ;
: lv3 3 lvar ;

( EOF 2300-alloca.fth )

