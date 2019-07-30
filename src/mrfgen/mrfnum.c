/***********************************************************************
 * mrfnum.c -- number parser, only used during sysgen
 */

static void mrf_numberq(void) {
  MRFaddr_t  a = mrf_tos();
  MRFuint8_t n = mrf_xcount(&a), b, c, s;
  MRFint16_t r = 0;

  if (!n) {
    mrf_push(0);
    return;
  }
  b = mrf_sv_get(MRF_SV_BASE);
  b = (b < 2) ? 2 : ((b > 36) ? 36 : b);
  c = mrf_cat(a);
  if (c == '-') {
    s = 1;
    a++;
    n--;
    if (!n) {
      mrf_push(0);
      return;
    }
  } else
    s = 0;
  while (n) {
    c = mrf_cat(a);
    if ((c >= '0') && (c <= '9')) {
      c -= '0';
    } else {
      if ((c >= 'A') && (c <= 'F')) {
	c -= 'A' - 10;
      } else {
	if ((c >= 'a') && (c <= 'f')) {
	  c -= 'a' - 10;
	} else {
	  mrf_push(0);
	  return;
	}
      }
    }
    if (c >= b) {
      mrf_push(0);
      return;
    }
    r = (r * b) + c;
    a++;
    n--;
  }
  if (s)
    r = -r;
  mrf_stos(r);
  mrf_push(-1);
}

/*** EOF mrfnum.c */

