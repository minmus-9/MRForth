\ ucode.fth -- attempt to bootstrap using only
\ the following 9 primitives:
\ 
\   @ ! + and xor (urshift) (literal) (abort) execute
\

\ we need to generate these 12 the hard way
\
\   c@ c! drop dup swap over >r r> or exit 0< 0=
\
\ this code WILL NOT WORK because it has NEVER BEEN TESTED.
\
\ also, you will NEVER be able to write an interrupt handler
\ with this stuff because stack operations are non-atomic.
\
\ it is merely a proof of concept in thought-experiment form!
\ the performance sucks. read on.
\
\ there are lots of comments in this code; in reality, the
\ ability to include comments could only appear after the
\ definition of "drop", way down yonder in the paw paw patch.
\
\ there are presumed to be code sequences available for
\ the following:
\   (sp)       push address of sp
\   (rsp)      push address of rsp
\   (ip)       push address of ip
\   (dp)       push address of dp
\   (word)     pop addr and delim; store token at addr; push addr
\   (create)   pop addr; create dict header at here aka dp @
\   (tick)     push xt for next word in input stream
\   (state)    push address of state
\   (current)  push address of current
\ 
\ primitives execute in [1]
\ secondaries require [1] on entry for their nesting code
\

\ the inline version of , is
\   (dp) @ !           \ store TOS at HERE
\   (dp) @ 2 + (dp) !  \ bump dp
\ it executes in [9]

\ secondary version of exit
\ : exit ( R: x ret ra -- x )  \ executes in [14]
\   (rsp) @ 2 + @   ( ret ) ( R: x ret ra )
\   (ip)            ( ret ip ) ( R: x ret ra )
\   (rsp) @ 4 +     ( ret ip @x ) ( R: x ret ra )
\   (rsp) !         ( ret ip ) ( R: x )
\   !
\ ;
\ without colon et al, the definition looks like
32 (dp) @ (word) exit (create)
(tick) (literal)  (dp) @ ! (dp) @ 2 + (dp) !
(rsp)             (dp) @ ! (dp) @ 2 + (dp) !
(tick) @          (dp) @ ! (dp) @ 2 + (dp) !
(tick) (literal)  (dp) @ ! (dp) @ 2 + (dp) !
2                 (dp) @ ! (dp) @ 2 + (dp) !
(tick) +          (dp) @ ! (dp) @ 2 + (dp) !
(tick) @          (dp) @ ! (dp) @ 2 + (dp) !
(tick) (literal)  (dp) @ ! (dp) @ 2 + (dp) !
(ip)              (dp) @ ! (dp) @ 2 + (dp) !
(tick) (literal)  (dp) @ ! (dp) @ 2 + (dp) !
(rsp)             (dp) @ ! (dp) @ 2 + (dp) !
(tick) @          (dp) @ ! (dp) @ 2 + (dp) !
(tick) (literal)  (dp) @ ! (dp) @ 2 + (dp) !
4                 (dp) @ ! (dp) @ 2 + (dp) !
(tick) +          (dp) @ ! (dp) @ 2 + (dp) !
(tick) (literal)  (dp) @ ! (dp) @ 2 + (dp) !
(rsp)             (dp) @ ! (dp) @ 2 + (dp) !
(tick) !          (dp) @ ! (dp) @ 2 + (dp) !
(tick) !          (dp) @ ! (dp) @ 2 + (dp) !
\ not reached
\ executes in [14]
\
\ we made a word. yay!

\ now go for , -- comma
\
\ the forth definition is
\ : ,
\   dp @ !
\   dp @ 2 + dp !
\ ;
\
\ building on exit, we have
32 (dp) @ (word) , (create)
(tick) (literal)  (dp) @ ! (dp) @ 2 + (dp) !
(dp)              (dp) @ ! (dp) @ 2 + (dp) !
(tick) @          (dp) @ ! (dp) @ 2 + (dp) !
(tick) !          (dp) @ ! (dp) @ 2 + (dp) !
(tick) (literal)  (dp) @ ! (dp) @ 2 + (dp) !
(dp)              (dp) @ ! (dp) @ 2 + (dp) !
(tick) @          (dp) @ ! (dp) @ 2 + (dp) !
(tick) (literal)  (dp) @ ! (dp) @ 2 + (dp) !
2                 (dp) @ ! (dp) @ 2 + (dp) !
(tick) +          (dp) @ ! (dp) @ 2 + (dp) !
(tick) (literal)  (dp) @ ! (dp) @ 2 + (dp) !
(dp)              (dp) @ ! (dp) @ 2 + (dp) !
(tick) !          (dp) @ ! (dp) @ 2 + (dp) !
(tick) exit       (dp) @ ! (dp) @ 2 + (dp) !
\ this executes in [24]

\ now do bl
32 (dp) @ (word) bl (create)  \ executes in [16]
(tick) (literal)  ,
32                ,
(tick) exit       ,

\ and dp
bl (dp) @ (word) dp (create)  \ executes in [16]
(tick) (literal)  ,
(dp)              ,
(tick) exit       ,

\ do token
bl dp @ (word) token (create)  \ executes in [33]
(tick) dp         ,
(tick) @          ,
(tick) (word)     ,
(tick) exit       ,

\ do tick
bl token ' (create)  \ executes in [16]
(tick) (tick)     ,
(tick) exit       ,

\ do state
bl token state (create)  \ executes in [16]
' (literal)       ,
  (state)         ,
' exit            ,

\ and current
bl token current (create)  \ executes in [16]
' (literal)       ,
  (current)       ,
' exit            ,

\ and zero!
0
bl token 0 (create)  \ executes in [16]
' (literal)       ,
                  ,
' exit            ,

\ and cell -- no more "2"
bl token cell (create)  \ executes in [16]
' (literal)       ,
  2               ,
' exit            ,

\ we're heading towards defining semicolon... but
\ a bunch of stuff is needed first... semicolon is
\ an immediate word, which means we need to be able
\ to set the bit 0x40 in the length/flags byte in
\ its nfa. the forth definition of immediate looks
\ like
\ : immediate
\   current @ @
\   dup b@
\   64 or
\   swap c!
\ ;
\ we need dup, b@, or, swap, and c! -- roll up yer sleeves

\ dup is
\ : dup
\   (sp) @ 2 + @
\ ;

\ do cell+ for easy access
bl token cell+ (create)  \ executes in [32]
' cell            ,
' +               ,
' exit            ,

\ do sp
bl token sp (create)  \ executes in [16]
' (literal)       ,
  (sp)            ,
' exit            ,

\ do dup as
\ : dup
\   sp @ cell+ @
\ ;
bl token dup (create)  \ executes in [65]
' sp              ,
' @               ,
' cell+           ,
' @               ,
' exit            ,

\ b@ will work as follows: decrement the address
\ by 1, do @, and clear the high 8 bits. first
\ we'll do 1- though
-1
bl token -1 (create)  \ executes in [16]
' (literal)       ,
                  ,
' exit            ,

bl token 1- (create)  \ executes in [32]
' -1              ,
' +               ,
' exit            ,

\ : b@ ( addr -- char )
\   1- @ 255 and
\ ;
bl token b@ (create)  \ executes in [49]
' 1-              ,
' @               ,
' (literal)       ,
  255             ,
' and             ,
' exit            ,

\ we'll build or from and, swap, and invert. so we
\ need invert
bl token invert (create)  \ executes in [32]
' -1              ,
' xor             ,
' exit            ,

\ do swap
\ : swap ( a b -- b a )
\   dup          ( a b bb )
\   sp @ 6 +     ( a b bb @a )
\   dup @        ( a b bb @a aa )
\   sp @ 8 +     ( a b bb @a aa @b )
\   ! !          ( b a )
\ ;
bl token swap (create)  \ executes in [186]
' dup             ,  \ 65
' sp              ,  \ 16   81
' @               ,  \  1   82
' (literal)       ,  \  1   83
  6               ,
' +               ,  \  1   84
' dup             ,  \ 65  149
' @               ,  \  1  150
' sp              ,  \ 16  166
' @               ,  \  1  167
' (literal)       ,  \  1  168
  8               ,
' +               ,  \  1  169
' !               ,  \  1  170
' !               ,  \  1  171
' exit            ,  \ 14  185

\ back to or
\ : or
\   invert swap invert
\   and invert
\ ;
bl token or (create)  \ executes in [298]
' invert          ,
' swap            ,
' invert          ,
' and             ,
' invert          ,
' exit            ,

\ we'll need over for c!
\ : over ( a b -- a b a )
\   sp @ cell+ cell+ @
\ ;
bl token over (create)  \ executes in [97]
' sp              ,  \ 16   16
' @               ,  \  1   17
' cell+           ,  \ 32   49
' cell+           ,  \ 32   81
' @               ,  \  1   82
' exit            ,  \ 14   96

\ at long last we get to c!
\ : c! ( char addr -- )
\   1- swap        ( addr char )
\   255 and        ( addr lo )
\   over @         ( addr lo cur )
\   65280 and      ( addr lo hi )
\   or swap !
\ ;
bl token c! (create)  \ executes in [820]
' 1-              ,  \  32   32
' swap            ,  \ 186  218
' (literal)       ,  \   1  219
  255             ,
' and             ,  \   1  220
' over            ,  \  97  317
' @               ,  \   1  318
' (literal)       ,  \   1  319
  65280           ,
' and             ,  \   1  320
' or              ,  \ 298  618
' swap            ,  \ 186  804
' !               ,  \   1  805
' exit            ,  \  14  819

\ finally we get to immediate -- remember immediate?
\ here it is again, phrased without c@ and c!
bl token immediate (create)  \ executes in [1452]
' current         ,  \  16   16
' @               ,  \   1   17
' @               ,  \   1   18
' dup             ,  \  65   83
' b@              ,  \  49  132
' (literal)       ,  \   1  133
  64              ,
' or              ,  \ 298  431
' swap            ,  \ 186  617
' c!              ,  \ 820 1437
' exit            ,  \  14 1451

\ ok -- define semicolon
bl token ; (create) \ executes in [73]
' (literal)       ,  \  1  1
' exit            ,
' ,               ,  \ 24 25
' 0               ,  \ 16 41
' state           ,  \ 16 57
' !               ,  \  1 58
' exit            ,  \ 14 72

\ maybe go out and have a bite for this one:
immediate
\ wow.

\ <nap/> ok, let's get ready to appreciate our colon
1
bl token 1 (create)  \ executes in [16]
' (literal)       ,
                  ,
' exit            ,

bl token : (create)  \ executes in [98]
' bl              ,  \ 16   16
' token           ,  \ 33   49
  (create)        ,  \  1   50
' 1               ,  \ 16   66
' state           ,  \ 16   82
' !               ,  \  1   83
' exit            ,  \ 14   97

\ our first "normal" definition follows:
: here dp @ ;  \ executes in [
\ wow.

: pad here 128 + ;

: word pad (word) ;

: eol 10 ;

: drop ( n -- )  \ executes in [89]
  sp @ cell+ cell+ sp !
;

: \ eol word drop ; immediate  \ executes in [171]
\ this is the first legitimate "\" comment in this
\ file. we could've jury rigged something a while
\ ago, though

\ the other style of comment
: ( 41 word drop ; immediate  \ executes in [156]
( now these comments are legitimate as well )

\ colon doesn't yet smudge; define 1 the hard way
1
bl token 1 (create)  \ executes in [16]
' (literal)        ,
                   ,
' exit             ,

: 1+ ( n -- n+1 )  \ executes in [32]
  1 +
;

: negate ( n -- -n )  \ executes in [79]
  invert 1+
;

: - ( x y -- x-y )  \ executes in [95]
  negate +
;

( c@ need to extend the sign bit... )
( this is why we have b@ )
: c@ ( addr -- char )  \ executes in [68]
  b@ 128 xor -128 +
;

\ let's get some useful tools from compile.fth
: [ 0 state ! ; immediate  \ executes in 
: ] 1 state ! ;

: cell-  \ executes in [16]
  [ cell negate ] +
;

: compile, , ;  \ executes in [39]

: [compile] ' compile, ; immediate  \ executes in [55]

: literal  \ executes in [64]
  (literal)
  [compile] (literal)
  , ,
; immediate

\ and from stack.fth
: signbit  \ executes in [16]
  [ -1 -1 (urshift) xor ] literal
;

: 2/       ( x -- x>>1 )  \ executes in [35]
  signbit xor (urshift)
  [ signbit (urshift) negate ] literal
  +
;

\ here ya go.
: 0<  \ executes in [540]
  2/ 2/ 2/ 2/
  2/ 2/ 2/ 2/
  2/ 2/ 2/ 2/
  2/ 2/ 2/
;

: tuck  \ executes in [298]
  swap over
;

: nip  \ executes in [290]
  swap drop
;

: abs ( n -- |n| )  \ executes in [920]
  dup 0< tuck + xor
;

: 0= ( n -- bool )  \ executes in [1507]
  abs 1- 0<
;

\ it is certainly now possible to implement both
\ >r and r>
\ 
\ i don't have the heart...

\ here's the run time table for
\ what we've defined so far:
\ 
\   exit        14
\   ,           24
\   bl          16
\   dp          16
\   token       33
\   '           16
\   state       16
\   current     16
\   0           16
\   cell        16
\   cell+       32
\   sp          16
\   dup         65
\   -1          16
\   1-          32
\   b@          49
\   invert      32
\   swap       186
\   or         298
\   over        97
\   c!         820
\   immediate 1452  <-- zoiks!
\   ;           73
\   1           16
\   :           98
\   here        32
\   pad         49
\   word        65
\   eol         16
\   drop        89
\   \          171
\   (          156
\   1           16
\   1+          32
\   negate      79
\   -           95
\   c@          68
\   [           48
\   ]           48
\   cell-       16
\   compile,    39
\   [compile]   55
\   literal     64
\   signbit     16
\   2/          35
\   0<         540  <-- oof!
\   tuck       298  <-- ow.
\   nip        290  <-- likewise.
\   abs        920
\   0=        1507  <-- gak! conditionals are 31+ dB slower :D
\
\ let's not lose sight of the fact that we managed
\ to do a hell of a lot with those 7 ops -- we didn't
\ even use (abort) and execute!
\
\ if you look at boot.fth, you'll see that execute is
\ used for those magical code sequences mentioned at
\ the top of this file.
\ 
\ so we did it with 8 primitives, in reality.
\

( the morals of the story: )
( )
(  - if i could make a peta-mip machine but could only )
(    choose a dozen ops, i know what they would be :-)
( )
(  - implementing 21 ops instead of 9 speeds up all )
(    conditionals by a factor of 1500. this is the )
(    best deal you will ever get. )
( )
( --mark )

\ EOF ucode.fth

