/***********************************************************************
 * mrplfabrt.c -- platform-dependent exception handler
 */

#include <stdio.h>
#include <stdlib.h>

static void mrf_doabrt(MRFuint16_t code) {
  MRFint16_t c = (((int) code) ^ 0x8000) - 0x8000;

  switch (c) {
    case 0: {
      /*** mrfabrt.c already set mrf_quit for us... */
      return;
    }
    case -1: {
      fprintf(stderr, "abort!\n");
      break;
    }
    case -2: {
      fprintf(stderr, "abort\" called\n");
      break;
    }
    case -3: {
      fprintf(stderr, "address fault\n");
      break;
    }
    case -4: {
      fprintf(stderr, "invalid param requested\n");
      break;
    }
    case -5: {
      fprintf(stderr, "illegal write to program memory\n");
      break;
    }
    case -6: {
      fprintf(stderr, "illegal vm instruction\n");
      break;
    }
    case -7: {
      fprintf(stderr, "return stack corrupt\n");
      break;
    }
    case -8: {
      fprintf(stderr, "undefined word!\n");
      break;
    }
    case -9: {
      fprintf(stderr, "stack underflow!\n");
      break;
    }
    case -10: {
      fprintf(stderr, "stack overflow!\n");
      break;
    }
    case -11: {
      fprintf(stderr, "return stack underflow!\n");
      break;
    }
    case -12: {
      fprintf(stderr, "return stack overflow!\n");
      break;
    }
    default: {
      char buf[32];
      sprintf(buf, "Abort with code %x %d\n", code, c);
      fprintf(stderr, buf);
    }
  }
  exit(1);
}

/*** EOF mrfplabrt.c */

