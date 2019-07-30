/***********************************************************************
 * mrfrun.c -- vm implementation
 */

#include <string.h>

#ifdef MRF_PROFILE
static unsigned long mrf_nprim = 0, mrf_nsecs = 0;

static unsigned long mrf_opcnts[MRFNOPS];

static void mrf_prof_reset(void) {
  int i;

  mrf_nprim = (unsigned long) -1;
  mrf_nsecs = 0;
  for (i = 0; i < MRFNOPS; i++)
    mrf_opcnts[i] = 0;
}

static void mrf_prof_prims(void) {
  mrf_nprim--;
  mrf_push(mrf_nprim &  0xffff);
  mrf_push(mrf_nprim >> 16);
}

static void mrf_prof_secs(void) {
  mrf_nprim--;
  mrf_push(mrf_nsecs &  0xffff);
  mrf_push(mrf_nsecs >> 16);
}

static void mrf_prof_count(void) {
  MRFuint16_t p = mrf_tos();
  mrf_nprim--;
  mrf_stos(mrf_opcnts[p % MRFNOPS]);
}
#endif

static void mrf_runxt(MRFaddr_t xt) {
  if (xt < MRFNOPS) {
    switch (xt) {
      case MRF_OPC_CAT:      { MRF_OP_CAT; break; }
      case MRF_OPC_CBANG:    { MRF_OP_CBANG; break; }
      case MRF_OPC_AT:       { MRF_OP_AT; break; }
      case MRF_OPC_BANG:     { MRF_OP_BANG; break; }
  
      case MRF_OPC_DROP:     { MRF_OP_DROP; break; }
      case MRF_OPC_DUP:      { MRF_OP_DUP; break; }
      case MRF_OPC_SWAP:     { MRF_OP_SWAP; break; }
      case MRF_OPC_TOR:      { MRF_OP_TOR; break; }
  
      case MRF_OPC_RTO:      { MRF_OP_RTO; break; }
      case MRF_OPC_ADD:      { MRF_OP_ADD; break; }
      case MRF_OPC_AND:      { MRF_OP_AND; break; }
      case MRF_OPC_OR:       { MRF_OP_OR; break; }
  
      case MRF_OPC_XOR:      { MRF_OP_XOR; break; }
      case MRF_OPC_URSHIFT:  { MRF_OP_URSHIFT; break; }
      case MRF_OPC_EXECUTE:  {
        /*** avoid recursion */
        while (mrf_tos() == MRF_OPC_EXECUTE)
	  mrf_drop();
        MRF_OP_EXECUTE;
        break;
      }
      case MRF_OPC_LITERAL:  { MRF_OP_LITERAL; break; }
  
      case MRF_OPC_EXIT:     { MRF_OP_EXIT; break; }
      case MRF_OPC_ABORT:    { MRF_OP_ABORT; break; }
      case MRF_OPC_ZEROLT:   { MRF_OP_ZEROLT; break; }
      case MRF_OPC_ZEROEQ:   { MRF_OP_ZEROEQ; break; }
  
      case MRF_OPC_OVER:     { MRF_OP_OVER; break; }
  
#ifdef MRF_OP_YIELD
      case MRF_OPC_YIELD:    { MRF_OP_YIELD; break; }
#endif

#ifdef MRF_OP_EMIT
      case MRF_OPC_EMIT:     { MRF_OP_EMIT; break; }
#endif
#ifdef MRF_OP_KEY
      case MRF_OPC_KEY:      { MRF_OP_KEY; break; }
#endif

#ifdef MRF_PROFILE
      case MRF_OPC_PRESET:   { mrf_prof_reset(); break; }
      case MRF_OPC_PPRIMS:   { mrf_prof_prims(); break; }
      case MRF_OPC_PSECS:    { mrf_prof_secs(); break; }
      case MRF_OPC_PPCNT:    { mrf_prof_count(); break; }
#endif

#ifdef MRF_OP_WORD
      case MRF_OPC_WORD:     { MRF_OP_WORD; break; }
#endif
#ifdef MRF_OP_PARAM
      case MRF_OPC_PARAM:    { MRF_OP_PARAM; break; }
#endif
#ifdef MRF_OP_TICK
      case MRF_OPC_TICK:     { MRF_OP_TICK; break; }
#endif
#ifdef MRF_OP_LLCREATE
      case MRF_OPC_LLCREATE: { MRF_OP_LLCREATE; break; }
#endif
#ifdef MRF_OP_EVAL
      case MRF_OPC_EVAL:     { mrf_interpret(); break; }
#endif

      default: {
        /* illegal instruction */
#ifdef MRF_PROFILE
	mrf_opcnts[0]++;
	mrf_nprim++;
#endif
	mrf_abrt(MRF_ABRT_ILLINST);
	/* NOT REACHED */
	return;
      }
    }
#ifdef MRF_PROFILE
    mrf_opcnts[xt]++;
    mrf_nprim++;
#endif
  } else {
#ifdef MRF_CHECK_RSTACK
    /*** check return stack -- reset and abort if needed */
    if (mrf_rdepth() >= MRF_MAXR) {
      /*** overflow */
      mrf_setrsp(MRF_RSP0);
      /*** always leave one stack slot for exc code */
      if (mrf_depth() >= MRF_MAXS) {
	/*** overflow */
	mrf_setsp(MRF_SP0);
      }
      mrf_abrt(MRF_ABRT_RSTOVR);
    }
#endif
    /*** nest for secondary execution */
    mrf_rpush(mrf_getip());
    mrf_setip(xt);
#ifdef MRF_PROFILE
    mrf_nsecs++;
#endif
    return;
  }
#ifdef MRF_CHECK_STACK
  /*** check stack -- reset and abort if needed */
  if (mrf_getsp() > MRF_SP0) {
    /*** underflow */
    mrf_setsp(MRF_SP0);
    mrf_abrt(MRF_ABRT_STKUND);
  }
  /*** always leave one slot for exc code */
  if (mrf_depth() >= MRF_MAXS) {
    /*** overflow */
    mrf_setsp(MRF_SP0);
    mrf_abrt(MRF_ABRT_STKOVR);
  }
#endif
#ifdef MRF_CHECK_RSTACK
  /*** check return stack -- reset and abort if needed */
  if (mrf_getrsp() > MRF_RSP0) {
    /*** underflow */
    mrf_setrsp(MRF_RSP0);
    /*** always leave one stack slot for exc code */
    if (mrf_depth() >= MRF_MAXS) {
      /*** overflow */
      mrf_setsp(MRF_SP0);
    }
    mrf_abrt(MRF_ABRT_RSTUND);
  }
  /*** check return stack -- reset and abort if needed */
  if (mrf_rdepth() > MRF_MAXR) {
    /*** overflow */
    mrf_setrsp(MRF_RSP0);
    /*** always leave one stack slot for exc code */
    if (mrf_depth() >= MRF_MAXS) {
      /*** overflow */
      mrf_setsp(MRF_SP0);
    }
    mrf_abrt(MRF_ABRT_RSTOVR);
  }
#endif
}

MRFuint16_t mrf_runsecs(MRFuint16_t opcnt) {
  MRFuint16_t incr;
  MRFaddr_t   i;

  if (opcnt)
    incr = -1;
  else {
    opcnt = 1;
    incr  = 0;
  }
  mrf_quit = 0;
  i = mrf_getip();
  for (; i && !mrf_quit && opcnt; opcnt += incr) {
    mrf_setip(i + 2);
    mrf_runxt(mrf_at(i));
    i = mrf_getip();
  }
  /*** clear return stack on exception -- or BYE */
  if (mrf_quit && (mrf_quit != MRF_ABRT_YIELD))
    mrf_setrsp(MRF_RSP0);
  return mrf_quit;
}

void mrf_init_app(void) {
  mrf_setsp(MRF_SP0);
  mrf_setrsp(MRF_RSP0);
  mrf_rpush(0x0000);
  mrf_setip(mrf_sv_get(MRF_SV_OUTER));
}

MRFuint16_t mrf_run(MRFuint16_t opcnt) {
  static MRFuint8_t init = 0;

  if (!init) {
    mrf_sv_copytab();
    mrf_init_app();
    init = 1;
  }
  return mrf_runsecs(opcnt);
}

char *mrf_eval_ptr(MRFuint16_t sl) {
  MRFuint16_t xt = mrf_geteval();
  MRFaddr_t   base;

#ifdef MRF_SYSGEN
  /*** rom used: dict + pad */
  base = mrf_sv_get(MRF_SV_DP) + MRF_PAD_OFFSET - MRF_VIREXEBASE;
#else
  /*** find end of rom -- after frozen svtab */
  base = mrf_getramp() + 2 + mrf_at(mrf_getramp());
#endif

  /*** free space left? */
  if (MRF_PHYEXESIZE - base < sl)
    return NULL;
  /*** load at top of rom */
  base = MRF_VIREXEBASE + (MRF_PHYEXESIZE - sl);
  /*** check eval hook */
  if (!xt)
    return NULL;
  /*** push addr, count, and xt */
  mrf_push(base);
  mrf_push(sl);
  mrf_push(xt);
  /*** return buffer pos */
  return &MRF_EXE[base - MRF_VIREXEBASE];
}

void mrf_eval_start(void) {
  mrf_setip(0x0000);
  mrf_runxt(MRF_OPC_EXECUTE);
}

MRFuint16_t mrf_eval(const char *s, MRFuint16_t sl) {
  char *dst = mrf_eval_ptr(sl);

  if (dst == NULL)
    return 0xffff;
  if (!sl)
    return 0x0;
  memcpy(dst, s, sl);
  mrf_eval_start();
  return mrf_runsecs(0);
}

/*** EOF mrfrun.c */

