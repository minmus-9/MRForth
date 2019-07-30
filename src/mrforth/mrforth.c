/***********************************************************************
 * mrforth.c -- minimal rom-able forth runtime vm
 */

#include <stdio.h>
#include <string.h>

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
#include "mrfmain.c"

static void mrf_usage(void) {
  fprintf(stderr, "usage: mrforth [ifile...] [-- imgfile]\n");
  exit(1);
}

static int mrf_go(int argc, char *argv[]) {
  FILE *fp;

  /*** load image, if requested */
  if ((argc >= 2) && !strcmp(*(argv + argc - 2), "--")) {
    if (mrf_fsize(*(argv + argc - 1)) > sizeof(MRF_EXE)) {
      fprintf(stderr, "core %s too large to load\n", *(argv + argc - 1));
      exit(1);
    }
    if ((fp = fopen(*(argv + argc - 1), "r")) == NULL) {
      perror("fopen");
      exit(1);
    }
    fprintf(stderr, "loaded %d bytes from image [%s]\n",
	    fread(MRF_EXE, sizeof(MRFuint8_t), sizeof(MRF_EXE), fp),
	    *(argv + argc - 1));
    fclose(fp);
    argc -= 2;
  }

  /*** init sysvars */
  mrf_sv_copytab();

  /*** process source files */
  if (argc) {
    fprintf(stderr, "loading"); fflush(stderr);
    while (argc--) {
      MRFuint16_t rc;

      if (!strcmp(*argv, "--"))
	mrf_usage();

      /*** process each input file */
      fprintf(stderr, " [%s]", *argv); fflush(stderr);
      if ((rc = mrf_dofile(*argv++)))
	return rc;	

      /*** check stacks */
      if (mrf_getsp() != MRF_SP0) {
	fprintf(stderr, "extra junk on stack:\n");
	while (mrf_getsp() != MRF_SP0)
	  fprintf(stderr, "  %04x\n", mrf_pop());
	fprintf(stderr, "please fix this\n");
	exit(1);
      }
      if (mrf_getrsp() != MRF_RSP0) {
	fprintf(stderr, "extra junk on return stack:\n");
	while (mrf_getrsp() != MRF_RSP0)
	  fprintf(stderr, "  %04x\n", mrf_rpop());
	fprintf(stderr, "please fix this\n");
	exit(1);
      }
    }
    fprintf(stderr, "\n"); fflush(stderr);
  }

  /*** run application */
  mrf_init_app();
  return mrf_runsecs(0);
}

/*** EOF mrforth.c */

