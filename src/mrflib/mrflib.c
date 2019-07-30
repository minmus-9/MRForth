/***********************************************************************
 * mrflib.c -- mrforth runtime library
 */

#ifdef __cplusplus
extern "C" {
#endif

#include "mrfconfig.h"

#include "mrfabrt.h"

/*** this MUST be included before mrfoptab.h and mrfrun.c */
#include "mrfio.c"

#include "mrfmem.c"
#include "mrfoptab.h"
#include "mrfvars.c"
#include "mrfsvtab.c"

#include "mrfstk.c"
#include "mrfcore.c"

#include "mrfabrt.c"
#include "mrfplabrt.c"

#include "mrfrun.c"

#ifdef __cplusplus
};
#endif

/*** EOF mrflib.c */

