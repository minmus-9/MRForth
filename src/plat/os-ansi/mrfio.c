/***********************************************************************
 * mrfio.c -- io handling
 */

#include <stdio.h>
#include <unistd.h>

/* if (key)  is a primitive, its code MUST be named MRF_OP_KEY
 * if (emit) is a primitive, its code MUST be named MRF_OP_EMIT
 */

/*** XXX this uses cooked mode */
#define MRF_OPN_KEY "(key)"
#define MRF_OP_KEY  { mrf_push(getc(stdin)); }

static MRF_INLINE void mrf_emit(MRFuint8_t c) {
  write(1, &c, 1);
}

#define MRF_OPN_EMIT "(emit)"
#define MRF_OP_EMIT  { mrf_emit(mrf_pop() & 0x7f); }

/*** EOF mrfio.c */

