/***********************************************************************
 * mrfcore.c -- core runtime operations
 */

#define MRF_OPN_CAT "c@"
#define MRF_OP_CAT  { mrf_stos(mrf_cat(mrf_tos())); }

#define MRF_OPN_CBANG "c!"
#define MRF_OP_CBANG  { MRFuint16_t a = mrf_pop(); mrf_cbang(a, mrf_pop()); }

#define MRF_OPN_AT "@"
#define MRF_OP_AT  { mrf_stos(mrf_at(mrf_tos())); }

#define MRF_OPN_BANG "!"
#define MRF_OP_BANG  { MRFuint16_t a = mrf_pop(); mrf_bang(a, mrf_pop()); }

#define MRF_OPN_DROP "drop"
#define MRF_OP_DROP  { mrf_drop(); }

#define MRF_OPN_DUP "dup"
#define MRF_OP_DUP  { mrf_dupe(); }

#define MRF_OPN_SWAP "swap"
#define MRF_OP_SWAP  { mrf_swap(); }

#define MRF_OPN_TOR ">r"
#define MRF_OP_TOR  { mrf_rpush(mrf_pop()); }

#define MRF_OPN_RTO "r>"
#define MRF_OP_RTO  { mrf_push(mrf_rpop()); }

#define MRF_OPN_ADD "+"
#define MRF_OP_ADD  { MRFuint16_t v = mrf_pop(); mrf_stos(mrf_tos() + v); }

#define MRF_OPN_AND "and"
#define MRF_OP_AND  { MRFuint16_t v = mrf_pop(); mrf_stos(mrf_tos() & v); }

#define MRF_OPN_OR "or"
#define MRF_OP_OR  { MRFuint16_t v = mrf_pop(); mrf_stos(mrf_tos() | v); }

#define MRF_OPN_XOR "xor"
#define MRF_OP_XOR  { MRFuint16_t v = mrf_pop(); mrf_stos(mrf_tos() ^ v); }

#define MRF_OPN_URSHIFT "(urshift)"
#define MRF_OP_URSHIFT  { mrf_stos(mrf_tos() >> 1); }

/***********************************************************************
 * ip and basic execution
 */

static MRFaddr_t mrf_ip;

#define mrf_getip()    (mrf_ip)
#define mrf_setip(val) (mrf_ip = (val))

#define MRF_OPN_EXECUTE "execute"
#define MRF_OP_EXECUTE  { mrf_runxt(mrf_pop()); }

#define MRF_OPN_LITERAL "(literal)"
#define MRF_OP_LITERAL  {    \
  MRFaddr_t i = mrf_getip(); \
  mrf_setip(i + 2);          \
  mrf_push(mrf_at(i));       \
}

#define MRF_OPN_EXIT "exit"
#define MRF_OP_EXIT  { mrf_setip(mrf_rpop()); }

#ifdef  MRF_PRIM_YIELD
#define MRF_OPN_YIELD "yield"
#define MRF_OP_YIELD  { mrf_quit = MRF_ABRT_YIELD; }
#endif

/***********************************************************************
 * these aren't essential but give good performance improvements
 */
#define MRF_OPN_ZEROLT "0<"
#define MRF_OP_ZEROLT  { mrf_stos((mrf_tos() & 0x8000) ? -1 : 0); }

#define MRF_OPN_ZEROEQ "0="
#define MRF_OP_ZEROEQ  { mrf_stos(mrf_tos() ? 0 : -1); }

#define MRF_OPN_OVER   "over"
#define MRF_OP_OVER    { mrf_over(); }

/*** EOF mrfcore.c */

