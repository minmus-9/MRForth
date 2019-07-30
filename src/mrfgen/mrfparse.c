/***********************************************************************
 * mrfparse.c
 */

#define MRF_EOB 0xff

static MRF_INLINE MRFuint8_t mrf_inch(void) {
  MRFuint16_t ofs = mrf_sv_get(MRF_SV_IBPTR);

  if (ofs >= mrf_sv_get(MRF_SV_IBLEN))
    return MRF_EOB;
  mrf_sv_set(MRF_SV_IBPTR, ofs + 1);
  return mrf_cat(mrf_sv_get(MRF_SV_IBUF) + ofs);
}

static void mrf_op_word(void) {
  MRFaddr_t  dst  = mrf_pop(), ptr = dst + 1;
  MRFuint8_t delm, cc;

  delm = mrf_tos() & 0x7f;
  mrf_stos(dst);
  mrf_cbang(dst, 0);
  if (delm == ' ') {
    while (1) {
      cc = mrf_inch();
      if (cc == MRF_EOB) {
	mrf_cbang(ptr, MRF_EOB);
	return;
      }
      cc &= 0x7f;
      if (!((cc == ' ') || (cc == '\t') || (cc == '\n') || (cc == '\r')))
	break;
    }
    mrf_cbang(ptr++, cc);
  }
  while (1) {
    cc = mrf_inch();
    if (cc == MRF_EOB)
      break;
    cc &= 0x7f;
    if (cc == delm)
      break;
    if ((delm == ' ') && ((cc == '\t') || (cc == '\n') || (cc == '\r')))
      break;
    mrf_cbang(ptr++, cc);
    if (ptr - 1 - dst == 0xff)
      break;
  }
  mrf_cbang(ptr, MRF_EOB);
  mrf_cbang(dst, ptr - 1 - dst);
}

#define MRF_OPN_WORD "(word)"
#define MRF_OP_WORD  { mrf_op_word(); }

/*** EOF mrfparse.c */

