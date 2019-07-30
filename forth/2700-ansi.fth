( 2700-ansi.fth -- ansi terminal control )

vocabulary ansiterm

ansiterm definitions

: (leader)
  27 emit ascii [ emit
;

( colors and attributes )

0 constant black
1 constant red
2 constant green
3 constant yellow
4 constant blue
5 constant magenta
6 constant cyan
7 constant white

: (dec)
  base @ >r decimal catch r> base ! throw
;

: (fg)
  (leader)
  30 + 
  (.) type ascii m emit
;

: fg 'compile (fg) (dec) ;

: (bg)
  (leader)
  40 +
  (.) type ascii m emit
;

: bg 'compile (bg) (dec) ;

: (attr)
  (leader)
  (.) type ascii m emit
;

: (setattr)
  create c,
  does>
    b@ 'compile (attr) (dec)
;

0 (setattr) normal
1 (setattr) bright
2 (setattr) dim
4 (setattr) underscore
5 (setattr) blink
7 (setattr) reverse
8 (setattr) hidden

( clearing lines/screen )

: clr2eol
  (leader) ascii K emit
;

: clr2bol
  (leader) ." 1K"
;

: clrline
  (leader) ." 2K"
;

: clreos
  (leader) ascii J emit
;

: clrbos
  (leader) ." 1J"
;

: clrscr
  (leader) ." 2J"
;

( cursor motion )

: home
  (leader) ascii H emit
;

: up
  (leader) ascii A emit
;

: down
  (leader) ascii B emit
;

: right
  (leader) ascii C emit
;

: left
  (leader) ascii D emit
;

: (moveto)
  (leader) (.) type ascii ; emit (.) type ascii f emit
;

: moveto ( x y -- )
  'compile (moveto) (dec)
;

forth definitions

( EOF 2700-ansi.fth )

