( 1100-exc.fth -- structured exception handling )

( this'n always does the same thing )
: (bye)
  (sp0) sp!  \ clear stack
  0 (abort)  \ and exit
;

: bye
  ." Bye!" cr
  (bye)
;

here 0 , constant (prx)

variable catch-handler

: ?nohandler
  catch-handler @ 0=
;

: catch ( xt -- exc#|0 )
  sp@ >r                  ( R: sp )
  catch-handler @ >r      ( R: sp ch )
  rp@ catch-handler !     ( R: sp ch )
  execute
  r> catch-handler !      ( R: sp )
  r> drop                 ( R: )
  0
;

: throw ( exc# -- |exc# )
  ?dup
  if
    catch-handler @
    dup 0=
    if
      ." Terminating on unhandled exception!" cr
      (prx) @ dup if
        nip execute
      then
      bye
    then
    rp!                   \ restore return stack      ( R: sp ch )
    r> catch-handler !    \ restore previous handler  ( R: sp )
    r> swap >r            \ swizzle ( sp ) ( R: exc# )
    sp!                   \ restore sp
    r>                    \ done ( exc# )
  then
;

' throw '(abort) !

 -1 constant xabort       ( abort called )
 -2 constant xabort"      ( abort" called )
 -3 constant xaddr        ( invalid address )
 -4 constant xparm        ( invalid param requested )
 -5 constant xwripm       ( write to program memory )
 -6 constant xillinstr    ( illegal vm instruction )
 -7 constant xrscorrupt   ( return stack corrupt )
 -8 constant xbadword     ( unknown word )
 -9 constant xsund        ( stack underflow )
-10 constant xsovr        ( stack overflow )
-11 constant xrund        ( return stack underflow )
-12 constant xrovr        ( return stack overflow )

( EOF 1100-exc.fth )

