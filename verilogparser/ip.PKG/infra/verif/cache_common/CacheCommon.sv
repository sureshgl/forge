typedef enum {CH_WRITE, CH_READ, CH_FLUSH, CH_INVAL, CH_NOP, CH_RSV12, CH_RSV13, CH_RSV14} cache_op;
typedef enum {CH_REQ_NOACK, CH_REQ_ACK} cache_creq_att_0;
typedef enum {CH_REQ_NOCACHE, CH_REQ_CACHE} cache_creq_att_1;
typedef enum {CH_D_NOP,CH_LAST_DATA,CH_RSV32,CH_RSV33,CH_RSV34,CH_RSV35,CH_RSV36,CH_RSV37} cache_dreq_att;
typedef enum {CH_R_NOP,CH_LAST_REQ_DATA,CH_ADDR_ERR,CH_RSV42,CH_DATA_ERR,CH_RSV43,CH_RSV44,CH_RSV45} cache_rreq_att;
typedef enum {DBG_WRITE, DBG_READ} dbg_op;
