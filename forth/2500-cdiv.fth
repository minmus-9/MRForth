( 2500-cdiv.fth -- division by constants )

: 2// ( n -- n/2 )
  dup 0< swap abs
  2/
  swap if negate then
;

: 2/mod ( n -- r q )
  dup  2//       ( n q )
  tuck 2* -      ( q r )
  swap
;

: 3/ ( n -- n/3 )
  dup 0< swap abs
  $ 5556 m* nip
  swap if negate then
;

: 3/mod ( n -- r q )
  dup  3/
  tuck 3* -
  swap
;

: 4// ( n -- n/4 )
  dup 0< swap abs
  4/
  swap if negate then
;

: 4/mod ( n -- r q )
  dup  4//
  tuck 4* -
  swap
;

: 5/ ( n -- n/5 )
  dup 0< swap abs
  $ 6667 m* nip 2/
  swap if negate then
;

: 5/mod ( n -- r q )
  dup  5/
  tuck 5* -
  swap
;

: 6/ ( n -- n/6 )
  2// 3/
;

: 6/mod ( n -- r q )
  dup  6/
  tuck 6* -
  swap
;

: 7/ ( n -- n/7 )
  dup 0< swap abs
  $ 9249 um* nip 4/
  swap if negate then
;

: 7/mod
  dup 7/
  tuck 7* -
  swap
;

: 8// ( n -- n/8 )
  dup 0< swap abs
  8/
  swap if negate then
;

: 8/mod ( n -- r q )
  dup  8//
  tuck 8* -
  swap
;

: 9/ ( n -- n/9 )
  dup 0< swap abs
  3/ 3/
  swap if negate then
;

: 9/mod ( n -- r q )
  dup  9/
  tuck 9* -
  swap
;

: 10/ ( n -- n/10 )
  dup 0< swap abs
  2/ 5/
  swap if negate then
;

: 10/mod ( n -- r q )
  dup  10/
  tuck 10* -
  swap
;

( EOF 2500-cdiv.fth )

