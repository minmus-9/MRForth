/***********************************************************************
 * mrfparam.c -- expose compilation params, only used during sysgen
 */

/*** yeah, some if this is clunky. not to worry, it doesn't
 *** exist in the runtime vm...
 ***/
static MRF_INLINE void mrf_op_param(void) {
  MRFuint16_t p = mrf_pop();

  switch (p) {
    case  0: { p = MRF_PHYEXESIZE; break; }
    case  1: { p = MRF_PHYRAMSIZE; break; }
    case  2: { p = MRF_VIREXEBASE; break; }
    case  3: { p = MRF_VIRRAMBASE; break; }
    case  4: { p = MRF_PAD_OFFSET; break; }
    case  5: { p = MRF_NTIB; break; }
    case  6: { p = MRF_TIB; break; }
    case  7: { p = MRF_RSP0; break; }
    case  8: { p = MRF_MAXR; break; }
    case  9: { p = MRF_SP0; break; }
    case 10: { p = MRF_MAXS; break; }
    case 11: { p = MRF_RTOP; break; }
    case 12: { p = MRF_RAMPADDR; break; }
    case 13: { p = MRF_SVSIZE; break; }
    case 14: { p = mrf_sv_addr(MRF_SV_CREATE); break; }
    case 15: { p = MRF_FLAG_PRIM; break; }
    case 16: { p = MRF_FLAG_IMMED; break; }
    case 17: { p = MRF_BFLAG_SMUDGE; break; }
    case 18: { p = MRF_NAMELENMASK; break; }
    case 19: { p = MRF_MAXNAMESTORE; break; }
    case 20: { p = 2; /* cell size */ break; }
    case 21: { p = ' '; break; }
    case 22: { p = '\n'; break; }
    case 23: { p = ')'; break; }
    case 24: { p = '\r'; break; }
    case 25: { p = mrf_sv_addr(MRF_SV_TICK); break; }
    case 26: { p = MRF_FLAG_SMUDGE; break; }
    case 27: { p = MRF_EOB; break; }
    case 28: { p = '\t'; break; }
    case 29: { p = mrf_sv_addr(MRF_SV_WORD); break; }
    case 30: { p = MRF_EVALADDR; break; }
    default: { mrf_abrt(MRF_ABRT_INVPARM); }
  }
  mrf_push(p);
}

#define MRF_OPN_PARAM "(param)"
#define MRF_OP_PARAM  { mrf_op_param(); }

/*** EOF mrfparam.c */

