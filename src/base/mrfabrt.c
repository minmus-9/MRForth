/***********************************************************************
 * mrfabrt.c -- exception handling
 */

static MRFuint16_t mrf_quit = 0;

static void mrf_doabrt(MRFuint16_t code);
static void mrf_runxt(MRFaddr_t xt);

static void mrf_abrt(MRFuint16_t code) {
  MRFaddr_t a = mrf_sv_get(MRF_SV_ABORT);

  if (a && code) {
    mrf_push(code);
    mrf_runxt(a);
  } else {
    /*** code of zero always gets here */
    mrf_quit = code == 0xffff ? 0xffff : code + 1;
    /*** do the platform-dependent thing */
    mrf_doabrt(code);
  }
}

static void mrf_op_abort(void) { mrf_abrt(mrf_pop()); }

#define MRF_OPN_ABORT "(abort)"
#define MRF_OP_ABORT  { mrf_op_abort(); }

/*** EOF mrfabrt.c */

