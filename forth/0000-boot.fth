21 (param) 3 (param) @ 29 (param) @ execute cell 14 (param) @ execute
25 (param) @ execute (literal)  3 (param) @ !   3 (param) @ 2 + 3 (param) !
20 (param)                      3 (param) @ !   3 (param) @ 2 + 3 (param) !
25 (param) @ execute exit       3 (param) @ !   3 (param) @ 2 + 3 (param) !

21 (param) 3 (param) @ 29 (param) @ execute bl 14 (param) @ execute
25 (param) @ execute (literal)  3 (param) @ !   3 (param) @ cell + 3 (param) !
21 (param)                      3 (param) @ !   3 (param) @ cell + 3 (param) !
25 (param) @ execute exit       3 (param) @ !   3 (param) @ cell + 3 (param) !

bl 3 (param) @ 29 (param) @ execute dp 14 (param) @ execute
25 (param) @ execute (literal)  3 (param) @ !   3 (param) @ cell + 3 (param) !
3 (param)                       3 (param) @ !   3 (param) @ cell + 3 (param) !
25 (param) @ execute exit       3 (param) @ !   3 (param) @ cell + 3 (param) !

bl 3 (param) @ 29 (param) @ execute @x 14 (param) @ execute
25 (param) @ execute @          dp @ !  dp @ cell + dp !
25 (param) @ execute execute    dp @ !  dp @ cell + dp !
25 (param) @ execute exit       dp @ !  dp @ cell + dp !

bl dp @ 29 (param) @x , 14 (param) @x
25 (param) @x dp     dp @ !   dp @ cell + dp !
25 (param) @x dup    dp @ !   dp @ cell + dp !
25 (param) @x >r     dp @ !   dp @ cell + dp !
25 (param) @x @      dp @ !   dp @ cell + dp !
25 (param) @x dup    dp @ !   dp @ cell + dp !
25 (param) @x >r     dp @ !   dp @ cell + dp !
25 (param) @x !      dp @ !   dp @ cell + dp !
25 (param) @x r>     dp @ !   dp @ cell + dp !
25 (param) @x cell   dp @ !   dp @ cell + dp !
25 (param) @x +      dp @ !   dp @ cell + dp !
25 (param) @x r>     dp @ !   dp @ cell + dp !
25 (param) @x !      dp @ !   dp @ cell + dp !
25 (param) @x exit   dp @ !   dp @ cell + dp !

bl dp @ 29 (param) @x (word) 14 (param) @x
25 (param) @x (literal)   ,
              29 (param)  ,
25 (param) @x @x          ,
25 (param) @x exit        ,

bl dp @ (word) token 14 (param) @x
25 (param) @x dp     ,
25 (param) @x @      ,
25 (param) @x (word) ,
25 (param) @x exit   ,

bl dp @ (word) ' 14 (param) @x
25 (param) @x (literal)  ,
              25 (param) ,
25 (param) @x @x         ,
25 (param) @x exit       ,

bl token (create) 14 (param) @x
' (literal) ,
14 (param)  ,
' @         ,
' execute   ,
' exit      ,

bl token state (create)
' (literal)  ,
cell
3 (param) +  ,
' exit       ,

bl token current (create)
' (literal)     ,
3 (param) 22 +  ,
' exit          ,

0
bl token 0 (create)
' (literal) ,
            ,
' exit      ,

bl token immediate (create)
' current   ,
' @         ,
' @         ,
' dup       ,
' c@        ,
' (literal) ,
16 (param)  ,
' or        ,
' swap      ,
' c!        ,
' exit      ,

bl token ; (create)
' (literal) ,
' exit      ,
' ,         ,
' 0         ,
' state     ,
' !         ,
' exit      ,
immediate

1
bl token 1 (create)
' (literal) ,
            ,
' exit      ,

bl token : (create)
' bl       ,
' token    ,
' (create) ,
' 1        ,
' state    ,
' !        ,
' exit     ,

: here dp @ ;

bl token pad (create)
' here      ,
' (literal) ,
4 (param)   ,
' +         ,
' exit      ,

: word pad (word) ;

bl token eol (create)
' (literal) ,
22 (param)  ,
' exit      ,

: \ eol word drop ; immediate

\ first forth core comment!

\ ************************************************************
\ what WAS all that junk?
\
\ the guts of the compiler were being
\ bootstrapped into existence:
\   - defined "cell"
\   - defined "bl" as an ascii space
\   - defined "dp" which is Critical
\   - defined "@x" as "@ execute"
\   - defined "," which is Real Helpful
\   - defined "token"
\   - defined "'"
\   - defined "(create)"
\   - defined "state"
\   - defined "current"
\   - defined 0 (memory saver)
\   - defined "immediate"
\   - defined ";"
\   - defined 1 (memory saver)
\   - defined ":"
\   - defined "here"
\   - defined "pad"
\   - defined "word"
\   - defined "eol"
\   - defined "\"
\ then things got more or less normal...
\ ************************************************************
\ note that this construction implies that the
\ following are implemented as primitives:
\
\   + @ (word) execute (literal) ! exit
\   dup >r r> c@ or swap c! (param)
\
\ as well as the number parser and implementations
\ of (create), tick ...
\ ************************************************************

bl token (rpar) (create)
' (literal) ,
23 (param)  ,
' exit      ,

: ( (rpar) word drop ; immediate

( third forth core comment! )

( EOF 0000-boot.fth )

