( 0400-math.fth -- basic math stuff )

\  optimized multiplication by small constants
:  3* dup 2* + ;
:  4* 2* 2* ;
:  5* dup 4* + ;
:  6* 2* 3* ;
:  7* dup 6* + ;
:  8* 4* 2* ;
:  9* 3* 3* ;
: 10* 2* 5* ;
: 11* dup 10* + ;
: 12* 4* 3* ;
: 13* dup 12* + ;
: 14* 2* 7* ;
: 15* 3* 5* ;
: 16* 4* 4* ;

: char+ 1 + ;
: char- 1 - ;
: chars ;

: binary  [  2 ] bliteral base ! ;
: octal   [  8 ] bliteral base ! ;
: decimal [ 10 ] bliteral base ! ;
: hex     [ 16 ] bliteral base ! ;

: abs dup 0< tuck + xor ;

: not 0= ;
: <   - 0< ;
: =   - 0= ;
: >   swap < ;
: 0>  negate 0< ;
: 0<> 0= invert ;
: <>  - 0<> ;
: >=  <  not ;
: <=  >  not ;
: 0>= 0< not ;
: 0<= 0> not ;

: & and ;
: | or ;
: ^ xor ;
: ~ invert ;

: on  -1 swap ! ;
: off  0 swap ! ;

: u< ( x y -- bool )
  2dup - >r    ( x  y ) ( R: x-y )
  swap invert  ( y ~x ) ( R: x-y )
  2dup or r>   ( y ~x ~x|y x-y )
  and >r       ( y ~x ) ( R: ~x|y & x-y )
  and r> or    ( bool )
  0<
;

: u<= ( x y -- bool )
  swap 2dup - invert >r   ( y x ) ( R: ~{y-x} )
  2dup xor r> or >r       ( y x ) ( R: x^y | ~{y-x} )
  invert or r> and        ( bool )
  0<
;

: u> swap u< ;

: u>= u< not ;

( EOF 0400-math.fth )

