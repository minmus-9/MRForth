/***********************************************************************
 * mrfgen.c -- sysgen impl: generate forth dict
 */

#include <string.h>

#include "mrfgen.h"
#include "mrfconfig.h"

#include "mrfabrt.h"
#include "mrfmem.c"
#include "mrfvars.c"
#include "mrfstk.c"
#include "mrfcore.c"

/*** these MUST be included before mrfoptab.h and mrfrun.c */
#include "mrfio.c"
#include "mrfdict.c"
#include "mrfparse.c"
#include "mrfparam.c"

#include "mrfoptab.h"
#include "mrfsvtab.c"

#include "mrfabrt.c"
#include "mrfplabrt.c"
#include "mrfnum.c"
#include "mrfinterp.c"

#include "mrfrun.c"
#include "mrfmain.c"

/***********************************************************************
 * dict bootstrap
 */

static MRFaddr_t mrf_makedictent(char *name) {
  MRFaddr_t  a = mrf_sv_get(MRF_SV_DP),
             b = a + 1;
  MRFuint8_t n = strlen(name) & MRF_NAMELENMASK,
             p = (n < MRF_MAXNAMESTORE) ? n : MRF_MAXNAMESTORE,
             i;

  mrf_cbang(a, n);
  for (i = 0; i < p; i++)
    mrf_cbang(b + i, (MRFuint8_t) name[i]);
  return a;
}

static void mrf_makeprim(MRFuint16_t index, char *name, MRFuint8_t flags) {
  MRFaddr_t  a;
  MRFuint8_t f;

  a = mrf_makedictent(name);
  mrf_linkdictent();
  f = MRF_FLAG_PRIM | flags;
  mrf_cbang(a, mrf_cat(a) | f);
  a = mrf_sv_get(MRF_SV_DP);
  mrf_cbang(a, index);
  mrf_sv_set(MRF_SV_DP, a + 1);
}

static void mrf_makeprims(void) {
  mrf_makeprim(MRF_OPC_CAT,      MRF_OPN_CAT, 0x0);
  mrf_makeprim(MRF_OPC_CBANG,    MRF_OPN_CBANG, 0x0);
  mrf_makeprim(MRF_OPC_AT,       MRF_OPN_AT, 0x0);
  mrf_makeprim(MRF_OPC_BANG,     MRF_OPN_BANG, 0x0);

  mrf_makeprim(MRF_OPC_DROP,     MRF_OPN_DROP, 0x0);
  mrf_makeprim(MRF_OPC_DUP,      MRF_OPN_DUP, 0x0);
  mrf_makeprim(MRF_OPC_SWAP,     MRF_OPN_SWAP, 0x0);
  mrf_makeprim(MRF_OPC_TOR,      MRF_OPN_TOR, 0x0);

  mrf_makeprim(MRF_OPC_RTO,      MRF_OPN_RTO, 0x0);
  mrf_makeprim(MRF_OPC_ADD,      MRF_OPN_ADD, 0x0);
  mrf_makeprim(MRF_OPC_AND,      MRF_OPN_AND, 0x0);
  mrf_makeprim(MRF_OPC_OR,       MRF_OPN_OR, 0x0);

  mrf_makeprim(MRF_OPC_XOR,      MRF_OPN_XOR, 0x0);
  mrf_makeprim(MRF_OPC_URSHIFT,  MRF_OPN_URSHIFT, 0x0);
  mrf_makeprim(MRF_OPC_EXECUTE,  MRF_OPN_EXECUTE, 0x0);
  mrf_makeprim(MRF_OPC_LITERAL,  MRF_OPN_LITERAL, 0x0);

  mrf_makeprim(MRF_OPC_EXIT,     MRF_OPN_EXIT, 0x0);
  mrf_makeprim(MRF_OPC_ABORT,    MRF_OPN_ABORT, 0x0);
  mrf_makeprim(MRF_OPC_ZEROLT,   MRF_OPN_ZEROLT, 0x0);
  mrf_makeprim(MRF_OPC_ZEROEQ,   MRF_OPN_ZEROEQ, 0x0);

  mrf_makeprim(MRF_OPC_OVER,     MRF_OPN_OVER, 0x0);

#ifdef MRF_PRIM_YIELD
  mrf_makeprim(MRF_OPC_YIELD,    MRF_OPN_YIELD, 0x0);
#endif

  /*** these are hardware dependent but can be overridden */
  mrf_makeprim(MRF_OPC_EMIT,     MRF_OPN_EMIT, 0x0);
  mrf_makeprim(MRF_OPC_KEY,      MRF_OPN_KEY, 0x0);

#ifdef MRF_PROFILE
  mrf_makeprim(MRF_OPC_PRESET,   "(preset)", 0x0);
  mrf_makeprim(MRF_OPC_PPRIMS,   "(pprims)", 0x0);
  mrf_makeprim(MRF_OPC_PSECS,    "(psecs)",  0x0);
  mrf_makeprim(MRF_OPC_PPCNT,    "(ppcnt)",  0x0);
#endif

  /*** these aren't present after sysgen */
  mrf_makeprim(MRF_OPC_PARAM,    MRF_OPN_PARAM, 0x0);
  mrf_sv_set(MRF_SV_WORD,        MRF_OPC_WORD);
  mrf_sv_set(MRF_SV_TICK,        MRF_OPC_TICK);
  mrf_sv_set(MRF_SV_CREATE,      MRF_OPC_LLCREATE);
  mrf_seteval(MRF_OPC_EVAL);
}

static void mrf_sv_fini(MRFaddr_t newdp) {
  mrf_sv_set(MRF_SV_DP,      newdp);
  mrf_sv_set(MRF_SV_STATE,   0x0);
  mrf_sv_set(MRF_SV_CONTEXT, mrf_sv_addr(MRF_SV_FORTH));
  mrf_sv_set(MRF_SV_IBLEN,   0x0);
  mrf_sv_set(MRF_SV_IBLIM,   0x0);
  mrf_sv_set(MRF_SV_IBUF,    0x0000);
  mrf_sv_set(MRF_SV_IBPTR,   0x0);
  mrf_sv_set(MRF_SV_SOURCE,  0x0);
  mrf_sv_set(MRF_SV_BASE,    10);
  mrf_setsp(MRF_SP0);
  mrf_setrsp(MRF_RSP0);
  mrf_sv_set(MRF_SV_CURRENT, mrf_sv_addr(MRF_SV_FORTH));
}

static void mrf_usage(void) {
  fprintf(stderr, "usage: mrfgen ifile... [-- ofile]\n");
  exit(1);
}

static int mrf_go(int argc, char *argv[]) {
  MRFuint16_t  ndict, col, i;
  FILE        *ofp;

  if (!argc)
    mrf_usage();

  /*** get ready */
  mrf_sv_initialize();
  mrf_makeprims();
  mrf_setsp(MRF_SP0); mrf_setrsp(MRF_RSP0);
  fprintf(stderr, "prim dict uses %d bytes\n",
	  mrf_sv_get(MRF_SV_DP) - (MRF_VIREXEBASE) - 2 /* for RAMPADDR */);
  fprintf(stderr, "loading"); fflush(stderr);
  while (argc--) {
    MRFuint16_t rc;

    /*** check for ofile switch */
    if (!strcmp(*argv, "--")) {
      if (argc != 1)
	mrf_usage();
      argv++;
      break;
    }

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
  argc++;
  fprintf(stderr, "\n"); fflush(stderr);

  /*** get sysvars into known state */
  ndict = mrf_sv_copytab();

  fprintf(stderr, "dict is %.3fkB\n", ndict / 1024.0);
  fprintf(stderr, "writing output to [%s]\n",
	  argc ? *argv : MRF_EXE_FILE);
  if ((ofp = fopen(argc ? *argv : MRF_EXE_FILE, "w")) == NULL) {
    perror("fopen");
    exit(1);
  }
  if (argc) {
    fwrite(MRF_EXE, sizeof(MRFuint8_t), ndict, ofp);
  } else {
    fprintf(ofp, "/*** DO NOT EDIT THIS FILE */\n");
    fprintf(ofp, "#ifdef  MRF_COMPACT_CORE\n");
    fprintf(ofp, "#define MRF_CORE_DECL %d\n", ndict);
    fprintf(ofp, "#else\n");
    fprintf(ofp, "#define MRF_CORE_DECL (MRF_PHYEXESIZE)\n");
    fprintf(ofp, "#endif\n");
    fprintf(ofp, "static MRFuint8_t MRF_EXE[MRF_CORE_DECL] = {\n");

    col = 0;
    for (i = 0; i < ndict; i++) {
      char buf[16];
      
      sprintf(buf, "%3d%s",
	      MRF_EXE[i],
	      (i == ndict - 1) ? "" : ",");
      col += strlen(buf) + 1;
      if (col >= 79) {
	fprintf(ofp, "%s\n", buf);
	col = 0;
      } else {
	fprintf(ofp, "%s ", buf);
      }
    }
    fprintf(ofp, "};\n");
  }
  fclose(ofp);
  return 0;
}

/*** EOF mrfgen.c */

