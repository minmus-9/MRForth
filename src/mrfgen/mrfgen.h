/***********************************************************************
 * mrfgen.h
 */

#ifndef mrfgen_h__
#define mrfgen_h__

/*** allow writable rom */
#define MRF_NO_WCHECK

/*** rom declaration */
#define MRF_EXE_DECL static MRFuint8_t MRF_EXE[MRF_PHYEXESIZE];

/*** activate eval opcode */
#define MRF_OP_EVAL

/*** let custom primitives know who's compiling them */
#define MRF_SYSGEN

#endif

/*** EOF mrfgen.h */

