( 9999-fini.fth -- finalize core dict )

\ switch to execute mode versions of things
' (variable)   '(variable)   !
' (cvariable)  '(cvariable)  !
' (2variable)  '(2variable)  !
' (vocabulary) '(vocabulary) !

\ smudge internal words
smudge (param)
smudge (llcreate)
smudge (ramp)
smudge (ralloc)
smudge (svariable)
smudge (variable)
smudge '(variable)
smudge (scvariable)
smudge (cvariable)
smudge '(cvariable)
smudge (s2variable)
smudge (2variable)
smudge '(2variable)
smudge (forth)
smudge (svocabulary)
smudge (vocabulary)
smudge '(vocabulary)

smudge (rpar)
smudge (does>)
smudge (iblen)
smudge (iblimit)
smudge (ibuf)
smudge (source)
smudge (outer)
smudge (sp)
smudge '(abort)
smudge '(create)
smudge '(')
smudge '(word)
smudge (rsp)
smudge (eob)
smudge (link>forth)
smudge (branch)
smudge (0branch)
smudge >mark
smudge >resolve
smudge <mark
smudge <resolve
smudge ahead
smudge (do)
smudge (?do)
smudge (loop)
smudge (+loop)
smudge of-count
smudge (?of)
smudge (?rangeof)
smudge (str)
smudge ('str)
smudge ("str)
smudge (c")
smudge (s")
smudge (.")
smudge catch-handler
smudge (abort")
smudge nfa.match
smudge search.nfa
smudge (')
smudge (id)
smudge (set-source)
smudge (interact)
smudge (d>>)
smudge $ml
smudge $mh
smudge $ql
smudge $qh
smudge (uds/)
smudge (hold)
smudge (npad)
smudge $nl
smudge $nh
smudge (dfldefer)
smudge (smudge)
smudge (unsmudge)
smudge $priv-begin
smudge $priv-end
smudge '(frame)
smudge (frame)
smudge (accept)
smudge (in-ch)
smudge (wadios)
smudge (wurd)
smudge (dpy-err)
smudge (eval)
smudge (prx)
smudge (prex)

smudge (literal)
smudge (urshift)
smudge (abort)
smudge (emit)
smudge (key)
smudge (word)
smudge (create)
smudge (compile)
smudge (cliteral)
smudge (bliteral)
smudge (2literal)
smudge (bye)

smudge (.)
smudge (u.)
smudge (p.r)
smudge (d.)
smudge (ud.)

: end_forth ;

( EOF 9999-fini.fth )

