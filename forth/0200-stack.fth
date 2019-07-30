( 0200-stack.fth -- basic stack words )

: 2drop drop drop ;
: 2dup  over over ;
: nip   swap drop ;
: tuck  swap over ;

: r@ ( -- x ) ( R: x -- x)
             ( R: x ra )
  r> r>      ( ra x ) ( R: )
  dup >r     ( ra x ) ( R: x )
  swap >r    ( x ) ( R: x ra )
;

: rot ( a b c -- b c a )
  >r    ( a b ) ( R: c )
  swap  ( b a ) ( R: c )
  r>    ( b a c )
  swap  ( b c a )
;

: -rot ( a b c -- c a b )
  swap  ( a c b )
  >r    ( a c ) ( R: b )
  swap  ( c a ) ( R: b )
  r>    ( c a b )
;

: 2swap ( a b c d -- c d a b )
  rot >r    ( a c d ) ( R: b )
  rot r>    ( c d a b )
;

: 2over ( a b c d -- a b c d a b )
  >r >r 2dup   ( a b a b )     ( R: d c )
  r> -rot      ( a b c a b )   ( R: d )
  r> -rot      ( a b c d a b )
;

: 2>r ( a b -- ) ( R: -- a b )
           ( a b )    ( R: ra )
  swap r>  ( b a ra ) ( R: )
  -rot     ( ra b a ) ( R: )
  >r >r >r ( R: a b ra )
;

: 2r> ( R: a b -- ) ( -- a b )
           ( )        ( R: a b ra )
  r>       ( ra )     ( R: a b )
  r> r>    ( ra b a )
  rot >r   ( b a ) ( R: ra )
  swap     ( a b )
;

: 2r@ ( R: a b -- a b ) ( -- a b )
  2r> 2dup 2>r
;

: 2rot ( x1 x2 x3 x4 x5 x6 -- x3 x4 x5 x6 x1 x2 )
  >r >r >r    ( x1 x2 x3 )    ( R: x6 x5 x4 )
  -rot r>     ( x3 x1 x2 x4 ) ( R: x6 x5 )
  -rot r> r>  ( x3 x4 x1 x2 x5 x6 )
  2swap       ( x3 x4 x5 x6 x1 x2 )
;

( EOF 0200-stack.fth )

