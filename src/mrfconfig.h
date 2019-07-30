/***********************************************************************
 * mrfconfig.h
 */

#ifndef mrfconfig_h__
#define mrfconfig_h__

#include "mrftypes.h"

/* flash/ram sizes */
#define MRF_PHYEXESIZE 0x8000
#define MRF_PHYRAMSIZE 0x2000

/* virt addrs for flash/ram */
#define MRF_VIREXEBASE 0x0000
#define MRF_VIRRAMBASE 0xe000

/* define to include YIELD primitive */
#define MRF_PRIM_YIELD

/* define to include primitive call-count profiling */
/*#define MRF_PROFILE*/

/* define for runtime stack checking */
#define MRF_CHECK_STACK

/* define for runtime return stack checking */
#define MRF_CHECK_RSTACK

/* define to detect attempted writes to program memory */
#define MRF_CHECK_XWRITE

/* define for fast stack ops (circumvent vm mem accessors)
 * gives a good speedup
 */
#define MRF_FAST_STACK

/* pad offset */
#define MRF_PAD_OFFSET (0x80)

/* max #chars to store in dict */
#define MRF_MAXNAMESTORE 5

/***************************************
 * mrforth memory map:
 *
 * +--------------+
 * | tib          |
 * +--------------+
 * | rstack       |
 * +--------------+
 * | stack        |
 * +--------------+
 * | RAM          |
 * +--------------+ MRF_VIRRAMBASE
 * | code (r/o)   |
 * +--------------+ MRF_VIREXEBASE
 *
 * after the system is generated, the number of
 * bytes of initialized RAM are written at DP
 * and the contents of the initialized RAM are
 * copied to DP + 2. the value of DP is written
 * to VIREXEBASE. this way, the runtime can find
 * and copy this table to RAM, restoring it to
 * the state it had after sysgen.
 *
 */

/* sizes/initial values of RSP, SP, TIB */
#define MRF_NTIB (0x50)
#define MRF_TIB  ((MRFaddr_t) (MRF_VIRRAMBASE + (MRF_PHYRAMSIZE - MRF_NTIB)))

#define MRF_RSP0 (MRF_TIB)
#define MRF_MAXR (0x100)

#define MRF_SP0  ((MRFaddr_t) (MRF_RSP0 - MRF_MAXR))
#define MRF_MAXS (0x100)

/*** top of user ram */
#define MRF_RTOP ((MRFaddr_t) (MRF_SP0 - MRF_MAXS))

/*** define as empty string if your compiler doesn't support inline */
#define MRF_INLINE inline

/*** exe data that gets included in mrforth binary */
#define MRF_EXE_FILE "mrforth.inc"

#endif

/*** EOF mrfconfig.h */

