/***********************************************************************
 * mrfdict.c -- dictionary stuff, code only used during sysgen
 */

#define MRF_FLAG_PRIM    0x20
#define MRF_FLAG_IMMED   0x40
#define MRF_BFLAG_SMUDGE 7
#define MRF_FLAG_SMUDGE  (1 << MRF_BFLAG_SMUDGE)

#define MRF_NAMELENMASK  0x1f

static MRF_INLINE MRFuint8_t mrf_xcount(MRFaddr_t *a) {
  MRFuint8_t ret = mrf_cat(*a);

  *a = *a + 1;
  return ret;
}

static MRF_INLINE char mrf_uc(char c) {
  return ((c >= 'a') && (c <= 'z')) ? (c - 'a' + 'A') : c;
}

static MRFaddr_t mrf__find(MRFaddr_t  a,           /*** vocab head addr */
			   MRFaddr_t  na,          /*** addr of name */
			   MRFuint8_t nl,          /*** len of name */
			   MRFuint8_t do_cfa,      /*** find cfa? else nfa */
			   MRFuint8_t *flag) {     /*** out: immed? */
  if (!nl) {
    *flag = 0;
    return 0;
  }
  while (a) {
    MRFaddr_t  b = a + 1;
    MRFuint8_t f, m = mrf_cat(a), n = m & MRF_NAMELENMASK;
    MRFuint8_t p = (n < MRF_MAXNAMESTORE) ? n : MRF_MAXNAMESTORE;
    MRFaddr_t  l = b + p;

    if ((n == nl) && !(m & MRF_FLAG_SMUDGE)) {
      f = 1;
      for (n = 0; n < p; n++) {
	if (mrf_uc(mrf_cat(b + n)) != mrf_uc(mrf_cat(na + n))) {
	  f = 0;
	  break;
	}
      }
      if (f) {
	*flag = m & MRF_FLAG_IMMED;
	if (do_cfa) {
	  a = l + 2;
	  if (m & MRF_FLAG_PRIM)
	    a = mrf_cat(a);
	}
	return a;
      }
    }
    a = mrf_at(l);
  }
  *flag = 0;
  return a;
}

static void mrf_find(void) {
  MRFaddr_t  a, b;
  MRFuint8_t n;
  MRFuint8_t i;

  a = mrf_tos();
  n = mrf_xcount(&a) & MRF_NAMELENMASK;
  while (1) {
    if ((b = mrf__find(mrf_at(mrf_sv_get(MRF_SV_CONTEXT)), a, n, 1, &i)))
      break;
    if ((b = mrf__find(mrf_sv_get(MRF_SV_FORTH), a, n, 1, &i)))
      break;
    mrf_push(0);
    return;
  }
  mrf_stos(b);
  mrf_push(i ? 1 : -1);
}

static void mrf_linkdictent(void) {
  MRFaddr_t  a = mrf_sv_get(MRF_SV_DP);
  MRFuint8_t n = mrf_cat(a) & MRF_NAMELENMASK,
             p = (n < MRF_MAXNAMESTORE) ? n : MRF_MAXNAMESTORE;
  MRFaddr_t  l = a + 1 + p;

  mrf_cbang(a, n);
  mrf_bang(l, mrf_at(mrf_sv_get(MRF_SV_CURRENT)));
  mrf_bang(mrf_sv_get(MRF_SV_CURRENT), a);
  mrf_sv_set(MRF_SV_DP, l + 2);
}

#define MRF_OP_LLCREATE { mrf_pop(); mrf_linkdictent(); }

#define mrf_pad() (mrf_sv_get(MRF_SV_DP) + (MRF_PAD_OFFSET))

#define MRF_OP_TICK { \
  mrf_push(' '); \
  mrf_push(mrf_pad()); \
  mrf_op_word(); \
  mrf_find(); \
  if (! mrf_pop()) \
    mrf_abrt(MRF_ABRT_UNKWORD); \
}

/*** EOF mrfdict.c */

