( 0340-params.fth -- system parameters )

\ param 3 is VIRRAMBASE where the sysvars live
3 (param)
\ define all the sysvars
          \            dp -- already defined
   cell + \            state -- already defined
   cell + dup constant context
   cell + dup constant (iblen)

   cell + dup constant (iblimit)
   cell + dup constant (ibuf)
   cell + dup constant >in
   cell + dup constant (source)

   cell + dup constant base     \ yes, base is a cell
   cell + dup constant (outer)
   cell + dup constant (sp)
   cell + \            current -- already defined

   cell + dup constant (forth)
   cell + dup constant '(abort)
   cell + dup constant '(create)
   cell + dup constant '(')

   cell + dup constant '(word)
   cell + dup constant (rsp)
drop

\ time to override (create)
' (llcreate) '(create) !

\ define sp get/set
: sp@ (sp) @ cell+ ;
: sp! (sp) ! ;

\ define rsp get/set
: rp@ (rsp) @ cell+ ;
: rp! r> swap (rsp) ! >r ;

\ grope all the compile-time params
   0 (param) constant (xs)      \ exe size
   1 (param) constant (rs)      \ ram size
   2 (param) constant (xb)      \ exe base
   3 (param) constant (rb)      \ ram base
\  4 (param) is "pad" defined earlier
   5 (param) constant tib_size
   6 (param) constant tib
   7 (param) constant (rsp0)
   8 (param) constant (maxrstk)
   9 (param) constant (sp0)
  10 (param) constant (maxstk)
  11 (param) constant (ramtop)
  12 (param) constant (ramp)
  13 (param) constant (svsize)
\ 14 (param) is "'(create)" defined above
  15 (param) constant flag-prim
  16 (param) constant flag-immed
  17 (param) constant flag-bsmudge ( 1 << flag-bsmudge is FLAG_SMUDGE )
  18 (param) constant namelengthmask
  19 (param) constant maxnamestore
\ 20 (param) is "cell" defined earlier
\ 21 (param) is "bl" defined earlier
\ 22 (param) is "eol" defined earlier
\ 23 (param) is "(rpar)" defined eariler
  24 (param) constant cret
\ 25 (param) is "'(')" defined above
  26 (param) constant flag-smudge
  27 (param) constant (eob)
  28 (param) constant tab
\ 29 (param) is "'(word)" defined above
  30 (param) constant (eval)
\ 
\ that's all, folks!

( EOF 0340-params.fth )

