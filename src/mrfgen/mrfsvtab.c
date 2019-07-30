/***********************************************************************
 * mrfsvtab.c
 */

static void mrf_sv_initialize(void) {
  mrf_sv_set(MRF_SV_DP,      (MRF_VIREXEBASE) + 4);
  mrf_sv_set(MRF_SV_STATE,   0x0);
  mrf_sv_set(MRF_SV_CONTEXT, mrf_sv_addr(MRF_SV_FORTH));
  mrf_sv_set(MRF_SV_IBLEN,   0x0);

  mrf_sv_set(MRF_SV_IBLIM,   0x0);
  mrf_sv_set(MRF_SV_IBUF,    0x0000);
  mrf_sv_set(MRF_SV_IBPTR,   0x0);
  mrf_sv_set(MRF_SV_SOURCE,  0x0);

  mrf_sv_set(MRF_SV_BASE,    10);
  mrf_sv_set(MRF_SV_OUTER,   0x0000);
  mrf_sv_set(MRF_SV_SP,      MRF_SP0);
  mrf_sv_set(MRF_SV_CURRENT, mrf_sv_addr(MRF_SV_FORTH));

  mrf_sv_set(MRF_SV_FORTH,   0x0000);
  mrf_sv_set(MRF_SV_ABORT,   0x0000);
  mrf_sv_set(MRF_SV_CREATE,  0x0000);
  mrf_sv_set(MRF_SV_TICK,    0x0000);

  mrf_sv_set(MRF_SV_WORD,    0x0000);

  mrf_setramp(mrf_sv_addr(MRF_SVSIZE));
  mrf_seteval(0x0000);
}

static void mrf_sv_fini(MRFaddr_t);

static MRFuint16_t mrf_sv_copytab(void) {
  MRFaddr_t   a = mrf_sv_get(MRF_SV_DP);
  MRFuint16_t n = mrf_ramused(), p = mrf_getramp(), i, ret;

  /*** stash ptr */
  mrf_bang(MRF_VIREXEBASE, a);
  /*** stash count */
  mrf_bang(a, n);
  a += 2;
  /*** ret is exe size */
  ret = a + n - MRF_VIREXEBASE;
  /*** set sysvars for load */
  mrf_sv_fini(p);
  /*** copy initialized ram to rom */
  for (i = 0; i < n; i++)
    mrf_cbang(a + i, mrf_cat((MRF_VIRRAMBASE) + i));
  return ret;
}

/*** EOF mrfsvtab.c */

