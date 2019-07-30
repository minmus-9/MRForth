/***********************************************************************
 * mrfoptab.h -- vm opcodes
 */

#ifdef MRF_PROFILE
char *mrf_opnames[] = {
#define MRF_NAMEOP(x) x,
#else
#define MRF_NAMEOP(x)
#endif

MRF_NAMEOP("(ill_insn)")
MRF_NAMEOP("c@")
#define MRF_OPC_CAT      0x01
MRF_NAMEOP("c!")
#define MRF_OPC_CBANG    0x02
MRF_NAMEOP("@")
#define MRF_OPC_AT       0x03
MRF_NAMEOP("!")
#define MRF_OPC_BANG     0x04
MRF_NAMEOP("drop")
#define MRF_OPC_DROP     0x05
MRF_NAMEOP("dup")
#define MRF_OPC_DUP      0x06
MRF_NAMEOP("swap")
#define MRF_OPC_SWAP     0x07
MRF_NAMEOP(">r")
#define MRF_OPC_TOR      0x08
MRF_NAMEOP("r>")
#define MRF_OPC_RTO      0x09
MRF_NAMEOP("+")
#define MRF_OPC_ADD      0x0a
MRF_NAMEOP("and")
#define MRF_OPC_AND      0x0b
MRF_NAMEOP("or")
#define MRF_OPC_OR       0x0c
MRF_NAMEOP("xor")
#define MRF_OPC_XOR      0x0d
MRF_NAMEOP("(urshift)")
#define MRF_OPC_URSHIFT  0x0e
MRF_NAMEOP("execute")
#define MRF_OPC_EXECUTE  0x0f
MRF_NAMEOP("(literal)")
#define MRF_OPC_LITERAL  0x10
MRF_NAMEOP("exit")
#define MRF_OPC_EXIT     0x11
MRF_NAMEOP("(abort)")
#define MRF_OPC_ABORT    0x12

/*** these aren't essential but give good speed improvements */

/*** : 0< 256/ 128/ ; */
MRF_NAMEOP("0<")
#define MRF_OPC_ZEROLT   0x13

/*** : 0= abs 1- 0< ; */
MRF_NAMEOP("0=")
#define MRF_OPC_ZEROEQ   0x14

/*** : over >r dup r> swap ; */
MRF_NAMEOP("over")
#define MRF_OPC_OVER     0x15

/*** YIELD primitive */
#ifdef MRF_PRIM_YIELD
MRF_NAMEOP("yield")
#define MRF_OPC_YIELD    0x16
#define MRF_NCORE_OPS    0x17
#else
#define MRF_NCORE_OPS    0x16
#endif

/*** these are hardware-dependent but can be overridden
 *** with a runtime impl; the c impls are needed by the
 *** peecee runtime
 ***/
/*** XXX mrfgen always implements these -- wrong if cross-compiling */
#ifdef MRF_OP_EMIT
MRF_NAMEOP("(emit)")
#define MRF_OPC_EMIT     (MRF_NCORE_OPS)
#define MRF_EMIT_OPS     ((MRF_OPC_EMIT) + 1)
#else
#define MRF_EMIT_OPS     (MRF_NCORE_OPS)
#endif
#ifdef MRF_OP_KEY
MRF_NAMEOP("(key)")
#define MRF_OPC_KEY      (MRF_EMIT_OPS)
#define MRF_NOPS         ((MRF_EMIT_OPS) + 1)
#else
#define MRF_NOPS         (MRF_EMIT_OPS)
#endif

/*** profiling runtime support
 ***/
#ifdef MRF_PROFILE
MRF_NAMEOP("(preset)")
#define MRF_OPC_PRESET (MRF_NOPS)
MRF_NAMEOP("(pprims)")
#define MRF_OPC_PPRIMS ((MRF_NOPS) + 1)
MRF_NAMEOP("(psecs)")
#define MRF_OPC_PSECS ((MRF_NOPS) + 2)
MRF_NAMEOP("(ppcnt)")
#define MRF_OPC_PPCNT ((MRF_NOPS) + 3)
#define MRF_POPS ((MRF_NOPS) + 4)
#else
#define MRF_POPS (MRF_NOPS)
#endif

/*** only need these during sysgen */
#ifdef MRF_OP_WORD
MRF_NAMEOP("(word)")
#define MRF_OPC_WORD     (MRF_POPS)
#define MRF_NOPS1        ((MRF_POPS) + 1)
#else
#define MRF_NOPS1        (MRF_POPS)
#endif

#ifdef MRF_OP_PARAM
MRF_NAMEOP("(param)")
#define MRF_OPC_PARAM    (MRF_NOPS1)
#define MRF_NOPS2        ((MRF_NOPS1) + 1)
#else
#define MRF_NOPS2        (MRF_NOPS1)
#endif

#ifdef MRF_OP_TICK
MRF_NAMEOP("(')")
#define MRF_OPC_TICK     (MRF_NOPS2)
#define MRF_NOPS3        ((MRF_NOPS2) + 1)
#else
#define MRF_NOPS3        (MRF_NOPS2)
#endif

#ifdef MRF_OP_LLCREATE
MRF_NAMEOP("(llcreate)")
#define MRF_OPC_LLCREATE (MRF_NOPS3)
#define MRF_NOPS4        ((MRF_NOPS3) + 1)
#else
#define MRF_NOPS4        (MRF_NOPS3)
#endif

#ifdef MRF_OP_EVAL
MRF_NAMEOP("evaluate")
#define MRF_OPC_EVAL     (MRF_NOPS4)
#define MRFNOPS          ((MRF_NOPS4) + 1)
#else
#define MRFNOPS          (MRF_NOPS4)
#endif

#ifdef MRF_PROFILE
};
#endif

/*** EOF mrfoptab.h */

