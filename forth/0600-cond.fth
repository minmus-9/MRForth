( 0600-cond.fth -- conditionals )

( ################################################################### )
( conditionals )

\ 7478 bytes abs, 7429 bytes rel => only save 49 bytes!
\ hurts performance a few %
\
\ : (branch) ( R: ra -- ra' )
\   r> dup c@ + >r
\ ;
\ 
\ : (0branch) ( flag -- ) ( R: ra -- ra' )
\   0= dup invert    ( z !z ) ( 0 => -1 0 // !0 => 0 -1 )
\   r> tuck          ( z ra !z ra )
\   1+ and           ( z ra taddr|0 )
\   >r dup c@ + and  ( faddr|0 ) ( R: taddr|0 )
\   r> or >r         ( ra' )
\ ;
\ 
\ : >mark    here 0 c, ;
\ : >resolve ( -c- src -- )
\   here     ( src dst )
\   over -   ( src delta )
\   swap c!
\ ;
\ : <mark    here ;
\ : <resolve ( -c- dst -- )
\   here     ( dst src )
\   - c,
\ ;

: (branch)
  r> @ >r
;

: (0branch) ( flag -- ) ( R: ra -- ra' )
  0= dup invert  ( z !z ) ( 0 => -1 0 // !0 => 0 -1 )
  r> tuck        ( z ra !z ra )
  cell+ and      ( z ra taddr|0 )
  >r @ and r>    ( faddr|0 taddr|0 )
  or >r
;

: >mark    here 0 , ;
: >resolve here swap ! ;
: <mark    here ;
: <resolve , ;

: if       compile (0branch) >mark             ; immediate
: begin    <mark                               ; immediate
: then     >resolve                            ; immediate
: again    compile  (branch) <resolve          ; immediate
: until    compile (0branch) <resolve          ; immediate
: while    [compile] if swap                   ; immediate
: repeat   [compile] again [compile] then      ; immediate
: ahead    compile (branch) >mark              ; immediate
: else     [compile] ahead swap [compile] then ; immediate

( EOF 0600-cond.fth )

