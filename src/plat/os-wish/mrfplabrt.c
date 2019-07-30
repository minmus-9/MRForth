/***********************************************************************
 * mrplfabrt.c -- platform-dependent exception handler
 */

#include <stdio.h>
#include <stdlib.h>

static MRFuint16_t  mrf_abrt_code;
static char        *mrf_abrt_text;

static void mrf_doabrt(MRFuint16_t code) {
  MRFint16_t c = (((int) code) ^ 0x8000) - 0x8000;

  mrf_abrt_code = code;
  switch (c) {
    case 0: {
      /*** mrfabrt.c already set mrf_quit for us... */
      mrf_abrt_text = "bye!";
      return;
    }
    case -1: {
      mrf_abrt_text = "abort!";
      break;
    }
    case -2: {
      mrf_abrt_text = "abort\" called";
      break;
    }
    case -3: {
      mrf_abrt_text = "address fault";
      break;
    }
    case -4: {
      mrf_abrt_text = "invalid param requested";
      break;
    }
    case -5: {
      mrf_abrt_text = "illegal write to program memory";
      break;
    }
    case -6: {
      mrf_abrt_text = "illegal vm instruction";
      break;
    }
    case -7: {
      mrf_abrt_text = "return stack corrupt";
      break;
    }
    case -8: {
      mrf_abrt_text = "undefined word!";
      break;
    }
    case -9: {
      mrf_abrt_text = "stack underflow!";
      break;
    }
    case -10: {
      mrf_abrt_text = "stack overflow!";
      break;
    }
    case -11: {
      mrf_abrt_text = "return stack underflow!";
      break;
    }
    case -12: {
      mrf_abrt_text = "return stack overflow!";
      break;
    }
    default: {
      mrf_abrt_text = "Abort with unknown code";
      break;
    }
  }
  /*** mrfabrt.c set it to code + 1; reset for reporting in wish */
  if (c)
    mrf_quit = code;
}

/*** EOF mrfplabrt.c */

