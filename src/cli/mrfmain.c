/***********************************************************************
 * mrfos.c -- code shared by mrfgen.c and mrforth.c
 */

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>
#include <time.h>

#ifdef MRF_PROFILE
static double ticks() {
  return ((double) clock()) / CLOCKS_PER_SEC;
}
#endif

static MRFuint16_t mrf_fsize(char *fn) {
  struct stat sb;

  if (stat(fn, &sb)) {
    perror("stat");
    exit(1);
  }
  if (sb.st_size > 0xffff) {
    fprintf(stderr, "source file too large!\n");
    exit(2);
  }
  return sb.st_size;
}

static void mrf_load(char *fn) {
  MRFuint16_t  cnt = mrf_fsize(fn);
  int          fd;
  char        *cp;

  if ((cp = mrf_eval_ptr(cnt)) == NULL) {
    fprintf(stderr, "source file too large\n");
    exit(2);
  }
  if ((fd = open(fn, O_RDONLY)) < 0) {
    perror("open");
    exit(1);
  }
  if (read(fd, cp, cnt) != cnt) {
    perror("read");
    close(fd);
    exit(1);
  }
  close(fd);
}

static MRFuint16_t mrf_dointerpret() {
  mrf_eval_start();
  return mrf_runsecs(0);
}

static MRFuint16_t mrf_dofile(char *fn) {
  mrf_load(fn);
  return mrf_dointerpret();
}

static int mrf_go(int argc, char *argv[]);

int main(int argc, char *argv[]) {
#ifdef MRF_PROFILE
  double t;
  int    i;
#endif
  int rc;

#ifdef MRF_PROFILE
  t = ticks();
#endif
  rc = mrf_go(argc - 1, argv + 1);
  if (rc == 1)
    rc = 0;
  if (rc == MRF_ABRT_YIELD)
    rc = 0;
  if (rc)
    fprintf(stderr, "exit code 0x%04x %d\n", rc, ((rc ^ 0x8000) - 0x8000));
#ifdef MRF_PROFILE
  fprintf(stderr, "executed %ld prims, %ld secs, %ld tot\n",
	  mrf_nprim, mrf_nsecs, mrf_nprim + mrf_nsecs);
  t = ticks() - t;
  fprintf(stderr, "runtime  %.3fs\n", t);
  fprintf(stderr, "kops/sec %.3f\n", (mrf_nprim + mrf_nsecs) / (1024 * t));
  for (i = 0; i < MRFNOPS; i++) {
    fprintf(stderr, "op 0x%02x %-10s: %8ld %4.1f%%     ",
	    i, mrf_opnames[i], mrf_opcnts[i],
	    ((float) 100.0 * mrf_opcnts[i]) / (mrf_nprim + mrf_nsecs));
    if (i & 0x1)
      fprintf(stderr, "\n");
  }
  if (MRFNOPS & 0x1)
    fprintf(stderr, "\n");
#endif
  return rc;
}

/*** EOF mrfos.c */

