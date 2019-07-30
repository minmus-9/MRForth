/***********************************************************************
 * mrflib.h -- mrforth runtime api
 */

#ifndef mrflib_h__
#define mrflib_h__

#ifdef __cplusplus
extern "C" {
#endif

#include "mrftypes.h"

/*** initialization funcs */
extern void mrf_sv_copytab(void);
extern void mrf_init_app(void);

/*** run secondaries */
extern MRFuint16_t mrf_runsecs(MRFuint16_t count);

/*** simple wrapper for all of the above */
extern MRFuint16_t mrf_run(MRFuint16_t count);

/*** eval api */
char *mrf_eval_ptr(MRFuint16_t string_len);
void  mrf_eval_start(void);

/*** wrapper for the above */
MRFuint16_t mrf_eval(const char *forth_src, MRFuint16_t src_len);

#ifdef __cplusplus
};
#endif

#endif

/*** EOF mrflib.h */

