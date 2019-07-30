/***********************************************************************
 * mrfsvtab.c
 */

void mrf_sv_copytab(void) {
  MRFaddr_t   a = mrf_at(MRF_VIREXEBASE);
  MRFuint16_t n = mrf_at(a), i;

  a += 2;
  /*** copy rom table to ram */
  for (i = 0; i < n; i++)
    mrf_cbang((MRF_VIRRAMBASE) + i, mrf_cat(a + i));
}

/*** EOF mrfsvtab.c */

