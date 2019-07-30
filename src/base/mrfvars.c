/***********************************************************************
 * mrfvars.c -- forth system variables
 */

/***********************************************************************
 * sysvars -- loaded at vaddr VIRRAMBASE + 0x0000
 */

#define MRF_SV_DP      0x0000
#define MRF_SV_STATE   0x0002
#define MRF_SV_CONTEXT 0x0004
#define MRF_SV_IBLEN   0x0006

#define MRF_SV_IBLIM   0x0008
#define MRF_SV_IBUF    0x000a
#define MRF_SV_IBPTR   0x000c
#define MRF_SV_SOURCE  0x000e

#define MRF_SV_BASE    0x0010
#define MRF_SV_OUTER   0x0012
#define MRF_SV_SP      0x0014
#define MRF_SV_CURRENT 0x0016

#define MRF_SV_FORTH   0x0018
#define MRF_SV_ABORT   0x001a
#define MRF_SV_CREATE  0x001c
#define MRF_SV_TICK    0x001e

#define MRF_SV_WORD    0x0020
#define MRF_SV_RSP     0x0022

#define MRF_SVSIZE (0x0024)

/***********************************************************************
 * related stuff
 */

#define mrf_sv_addr(v)     ((v) + (MRF_VIRRAMBASE))
#define mrf_sv_get(v)      (mrf_at(mrf_sv_addr(v)))
#define mrf_sv_set(v, val) (mrf_bang(mrf_sv_addr(v), (val)))

/*** ramp support for bootstrap */
#define MRF_RAMPADDR       (MRF_VIREXEBASE + 0)
#define mrf_getramp()      (mrf_at(MRF_RAMPADDR))
#define mrf_setramp(x)     (mrf_bang(MRF_RAMPADDR, x))
#define mrf_ramused()      (mrf_getramp() - MRF_VIRRAMBASE)

/*** eval hook for runtime */
#define MRF_EVALADDR       (MRF_VIREXEBASE + 2)
#define mrf_geteval()      (mrf_at(MRF_EVALADDR))
#define mrf_seteval(x)     (mrf_bang(MRF_EVALADDR, x))

/*** EOF mrfvars.c */

