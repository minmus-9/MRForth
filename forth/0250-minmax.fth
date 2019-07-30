( 0250-minmax.fth -- min/max words )

: min0 ( x -- x|0, lesser of x and 0 )
  dup 0<         ( x f ) ( f: 0 if x>=0, -1 if x<0 )
  and
;

: max0 ( x -- x|0, greater of x and 0 )
  dup 0<         ( x f ) ( f: 0 if x>=0, -1 if x<0 )
  invert         ( x f ) ( f: 0 if x<0, -1 if x>=0 )
  and
;

: min ( x y -- x|y, lesser of x and y )
  tuck - min0         ( y f ) ( f: x-y if x<y, 0 if x>=y )
  +
;

: max ( x y -- x|y, greater of x and y )
  tuck - max0         ( y f ) ( f: 0 if x<y, x-y if x>=y )
  +
;

( EOF 0250-minmax.fth )

