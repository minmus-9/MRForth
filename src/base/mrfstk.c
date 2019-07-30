/***********************************************************************
 * mrfstk.c -- forth stack ops
 */

/***********************************************************************
 * data stack
 */

static MRFuint16_t mrf_ss;

#ifdef MRF_FAST_STACK

static MRFuint16_t mrf_ss2;
#define mrf_getsp()    ((MRF_RAM[MRF_SV_SP] << 8) | MRF_RAM[MRF_SV_SP + 1])
#define mrf_setsp(val) (mrf_ss2 = (val), \
                        MRF_RAM[MRF_SV_SP] = mrf_ss2 >> 8, \
			MRF_RAM[MRF_SV_SP + 1] = mrf_ss2, \
			mrf_ss2)

#else

#define mrf_getsp()    (mrf_sv_get(MRF_SV_SP))
#define mrf_setsp(val) (mrf_sv_set(MRF_SV_SP, (val)))

#endif

#define mrf_tos()      (mrf_at(mrf_getsp()))
#define mrf_stos(val)  (mrf_bang(mrf_getsp(), val))
#define mrf_push(val)  (mrf_ss = (val), \
                        mrf_bang(mrf_setsp(mrf_getsp() - 2), \
                        mrf_ss))
#define mrf_pop()      (mrf_ss = mrf_getsp(), \
                        mrf_setsp(mrf_ss + 2), \
                        mrf_at(mrf_ss))
#define mrf_depth()    (((MRFuint16_t) ((MRF_SP0) - mrf_getsp())) >> 1)
#define mrf_dupe()     (mrf_push(mrf_tos()))
#define mrf_drop()     (mrf_setsp(mrf_getsp() + 2))

/*** not essential as a secondary, but gives good speed improvement */
#define mrf_over()     (mrf_push(mrf_at(mrf_getsp() + 2)))

static void mrf_swap() {
  MRFaddr_t a1 = mrf_getsp(), a2 = a1 + 2, a = mrf_at(a1), b = mrf_at(a2);

  mrf_bang(a1, b); mrf_bang(a2, a);
}

/***********************************************************************
 * return stack
 */

#ifdef MRF_FAST_STACK

static MRFuint16_t mrf_rs;
#define mrf_getrsp()    ((MRF_RAM[MRF_SV_RSP] << 8) | MRF_RAM[MRF_SV_RSP + 1])
#define mrf_setrsp(val) (mrf_rs = (val), \
                         MRF_RAM[MRF_SV_RSP] = mrf_rs >> 8, \
			 MRF_RAM[MRF_SV_RSP + 1] = mrf_rs, \
			 mrf_rs)

#else

#define mrf_getrsp()    (mrf_sv_get(MRF_SV_RSP))
#define mrf_setrsp(val) (mrf_sv_set(MRF_SV_RSP, (val)))

#endif

#define mrf_rdepth()    (((MRFuint16_t) ((MRF_RSP0) - mrf_getrsp())) >> 1)
#define mrf_rpush(val)  (mrf_bang(mrf_setrsp(mrf_getrsp() - 2), (val)))
#define mrf_rpop()      (mrf_ss = mrf_getrsp(), \
                         mrf_setrsp(mrf_ss + 2), \
                         mrf_at(mrf_ss))

/*** EOF mrfstk.c */

