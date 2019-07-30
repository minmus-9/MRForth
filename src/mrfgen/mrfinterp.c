/***********************************************************************
 * mrfinterp.c -- source interpreter
 */

static MRFuint16_t mrf_runsecs(MRFuint16_t);

static void mrf_interpret() {
  MRFuint16_t nstr, r;
  MRFaddr_t   str;
  MRFuint8_t  s, nch;

  nstr = mrf_pop();
  str  = mrf_pop();
  mrf_sv_set(MRF_SV_SOURCE, -1);
  mrf_sv_set(MRF_SV_IBUF,   str);
  mrf_sv_set(MRF_SV_IBLEN,  nstr);
  mrf_sv_set(MRF_SV_IBLIM,  nstr);
  mrf_sv_set(MRF_SV_IBPTR,  0);
  while (1) {
    mrf_push(' ');
    mrf_push(mrf_pad());
    mrf_op_word();
    if (!(nch = mrf_cat(mrf_tos()))) {
      mrf_pop();
      break;
    }
    s = mrf_sv_get(MRF_SV_STATE);
    mrf_find();
    if ((r = mrf_pop())) {
      if (!s || (r == 1)) {
	mrf_runxt(mrf_pop());
	if (mrf_runsecs(0))
	  return;
      } else {
	MRFaddr_t d = mrf_sv_get(MRF_SV_DP);
	mrf_bang(d, mrf_pop());
	mrf_sv_set(MRF_SV_DP, d + 2);
      }
      continue;
    }
    mrf_numberq();
    if ((r = mrf_pop())) {
      if (s) {
	MRFaddr_t d = mrf_sv_get(MRF_SV_DP);

	mrf_bang(d, MRF_OPC_LITERAL);
	mrf_bang(d + 2, mrf_pop());
	mrf_sv_set(MRF_SV_DP, d + 4);
      }
      continue;
    }
#if 1
    do{
      MRFaddr_t  a = mrf_tos();
      MRFuint8_t n = mrf_xcount(&a);

      mrf_emit('[');
      while (n--) mrf_emit(mrf_cat(a++));
      mrf_emit(']'); mrf_emit(' ');
    } while (0);
#endif
    mrf_stos(-8);
    mrf_op_abort();
  }
  mrf_sv_set(MRF_SV_SOURCE, 0);
  mrf_sv_set(MRF_SV_IBUF,   0x0000);
  mrf_sv_set(MRF_SV_IBLEN,  0);
  mrf_sv_set(MRF_SV_IBLIM,  0);
  mrf_sv_set(MRF_SV_IBPTR,  0);
}

/*** EOF mrfinterp.c */

