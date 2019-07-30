/***********************************************************************
 * mrfmem.c -- memory accessors
 */

#ifdef MRF_EXE_DECL
MRF_EXE_DECL
#else
#include MRF_EXE_FILE
#endif

static MRFuint8_t MRF_RAM[MRF_PHYRAMSIZE];

static void mrf_abrt(MRFuint16_t code);

static MRF_INLINE void mrf_xaddr(MRFaddr_t *a, MRFuint8_t **obj) {
  if ((*a >= MRF_VIREXEBASE) && (*a < (MRF_VIREXEBASE + sizeof(MRF_EXE)))) {
    *a  -= MRF_VIREXEBASE;
    *obj = MRF_EXE;
    return;
  }
  if ((*a >= MRF_VIRRAMBASE) && (*a < (MRF_VIRRAMBASE + sizeof(MRF_RAM)))) {
    *a  -= MRF_VIRRAMBASE;
    *obj = MRF_RAM;
    return;
  }
  /*** must always catch accesses to unmapped memory */
  mrf_abrt(MRF_ABRT_INVADDR);
}

#ifndef MRF_CHECK_XWRITE
#ifndef MRF_NO_WCHECK
#define MRF_NO_WCHECK
#endif
#endif

#ifdef MRF_NO_WCHECK
#define mrf_wcheck(obj)
#else
static MRF_INLINE void mrf_wcheck(MRFuint8_t *obj) {
  if (obj != MRF_RAM)
    mrf_abrt(MRF_ABRT_WRIPM);
}
#endif

static MRFuint16_t mrf_cat(MRFaddr_t a) {
  MRFuint8_t *o;

  mrf_xaddr(&a, &o);
  return (o[a] ^ 0x80) - 0x80;
}

static MRFuint8_t mrf_cbang(MRFaddr_t a, MRFuint8_t v) {
  MRFuint8_t *o;

  mrf_xaddr(&a, &o);
  mrf_wcheck(o);
  o[a] = v;
  return v;
}

static MRFuint16_t mrf_at(MRFaddr_t a) {
  MRFuint8_t *o;

  mrf_xaddr(&a, &o);
  return (o[a] << 8) | o[a + 1];
}

static MRFuint16_t mrf_bang(MRFaddr_t a, MRFuint16_t v) {
  MRFuint8_t *o;

  mrf_xaddr(&a, &o);
  mrf_wcheck(o);
  o[a] = v >> 8;
  o[a + 1] = v & 0xff;
  return v;
}

/*** EOF mrfmem.c */

