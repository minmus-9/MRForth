/***********************************************************************
 * mrfabrt.h
 */

#ifndef mrfabrt_h__
#define mrfabrt_h__

/*** see also forth/1100-exc.fth */

#define MRF_ABRT_ABORT    -1  /*** abort called */
#define MRF_ABRT_ABORTQ   -2  /*** abort" called */
#define MRF_ABRT_INVADDR  -3  /*** invalid address */
#define MRF_ABRT_INVPARM  -4  /*** invalid param requested */
#define MRF_ABRT_WRIPM    -5  /*** write to program memory */
#define MRF_ABRT_ILLINST  -6  /*** illegal vm instruction */
#define MRF_ABRT_RSTCORR  -7  /*** return stack corrupt */
#define MRF_ABRT_UNKWORD  -8  /*** unknown word */
#define MRF_ABRT_STKUND   -9  /*** stack underflow */
#define MRF_ABRT_STKOVR  -10  /*** stack overflow */
#define MRF_ABRT_RSTUND  -11  /*** return stack underflow */
#define MRF_ABRT_RSTOVR  -12  /*** return stack overflow */

#define MRF_ABRT_YIELD 0x8000 /*** force mrf_runsecs() to return */

#endif

/*** EOF mrfabrt.h */

