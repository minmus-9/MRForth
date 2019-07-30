/***********************************************************************
 * mrfio.c -- io handling, wish-specific
 */

#include <stdio.h>
#include <stdlib.h>

#include <tcl.h>

/* if (key)  is a primitive, its code MUST be named MRF_OP_KEY
 * if (emit) is a primitive, its code MUST be named MRF_OP_EMIT
 */

static MRF_INLINE MRFuint8_t mrf_key() {
  char *cp;

  if (Tcl_Eval(mrf_tcl_interp, "mrf_forth_key") != TCL_OK)
    return 0x00;
  if ((cp = Tcl_GetStringResult(mrf_tcl_interp)) == NULL)
    return 0x00;
  return *cp;
}

#define MRF_OPN_KEY "(key)"
#define MRF_OP_KEY  { mrf_push(mrf_key()); }

static MRF_INLINE void mrf_emit(MRFuint8_t c) {
  char buf[32];

  if (c == '\r')
    c = '\n';
  sprintf(buf, "mrf_forth_emit %d", c);
  Tcl_Eval(mrf_tcl_interp, buf);
}

#define MRF_OPN_EMIT "(emit)"
#define MRF_OP_EMIT  { mrf_emit(mrf_pop() & 0x7f); }

/*** EOF mrfio.c */

