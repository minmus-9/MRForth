/***********************************************************************
 * mrftcl.c
 */

#include <string.h>

#include <tcl.h>

static Tcl_Interp *mrf_tcl_interp;

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

#ifdef CONST84
static int forthcmd(ClientData    cd,
		    Tcl_Interp   *interp,
		    int           argc,
		    CONST84 char *argv[]) {
#else
static int forthcmd(ClientData    cd,
		    Tcl_Interp   *interp,
		    int           argc,
		    char         *argv[]) {
#endif
  MRFuint16_t rc = 0;
  char        buf[32];

  mrf_tcl_interp = interp;
  argc--; argv++;
  if (!argc) {
    Tcl_SetResult(interp,
		  "usage: mrforth {reset|init|run|eval} ...",
		  TCL_STATIC);
    return TCL_ERROR;
  }

  if (!strcmp(argv[0], "run")) {
    MRFuint16_t steps;

    if (argc > 2) {
      Tcl_SetResult(interp,
		    "usage: mrforth run [nsteps]",
		    TCL_STATIC);
      return TCL_ERROR;
    }
    if (argc != 1) {
      int ist;

      if (Tcl_GetInt(interp, argv[1], &ist) != TCL_OK)
	return TCL_ERROR;
      if (ist < 0) {
	Tcl_SetResult(interp,
		      "mrforth run: nsteps cannot be negative",
		      TCL_STATIC);
	return TCL_ERROR;
      }
      if (ist > 0xffff) {
	Tcl_SetResult(interp,
		      "mrforth run: nsteps too large",
		      TCL_STATIC);
	return TCL_ERROR;
      }
      steps = ist;
    } else
      steps = 0;
    rc = mrf_runsecs(steps);
    sprintf(buf, "%d", rc);
    Tcl_SetResult(interp, buf, TCL_VOLATILE);
    if (rc && (rc != MRF_ABRT_YIELD))
      mrf_init_app();
    return TCL_OK;
  }

  if (!strcmp(argv[0], "eval")) {
    if (argc == 1) {
      Tcl_SetResult(interp,
		    "usage: mrforth eval ...",
		    TCL_STATIC);
      return TCL_ERROR;
    }
    argc--; argv++;
    while (argc--) {
      const char *cp = *argv++;

      if ((rc = mrf_eval(cp, strlen(cp)))) {
	mrf_init_app();
	if (rc == 1)
	  break;
	sprintf(buf, "MrFORTH ERR# %d", rc);
	Tcl_SetResult(interp, buf, TCL_VOLATILE);
	return TCL_ERROR;
      }
    }
    sprintf(buf, "%d", rc);
    Tcl_SetResult(interp, buf, TCL_VOLATILE);
    return TCL_OK;
  }

  if (!strcmp(argv[0], "init")) {
    if (argc != 1) {
      Tcl_SetResult(interp,
		    "usage: mrforth init",
		    TCL_STATIC);
      return TCL_ERROR;
    }
    mrf_init_app();
    return TCL_OK;
  }

  if (!strcmp(argv[0], "reset")) {
    if (argc != 1) {
      Tcl_SetResult(interp,
		    "usage: mrforth reset",
		    TCL_STATIC);
      return TCL_ERROR;
    }
    mrf_sv_copytab();
    mrf_init_app();
    return TCL_OK;
  }

  Tcl_SetResult(interp,
		"unknown cmd\nusage: mrforth {reset|init|run|eval} ...",
		TCL_STATIC);
  return TCL_ERROR;
}

int Mrforth_Init(Tcl_Interp *interp) {
  mrf_sv_copytab();
  mrf_init_app();
  return Tcl_CreateCommand(interp,
			   "mrforth",
			   forthcmd,
			   NULL,
			   NULL) == NULL ?
    TCL_ERROR : TCL_OK;
}

/*** EOF mrftcl.c */

