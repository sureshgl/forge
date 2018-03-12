module core_afifo (
                   rst, 
                   push_clk, push, push_data, push_err,
                   pop_clk, pop, pop_data, pop_vld, pop_err,
                   empty, full
                   );

  parameter WIDTH   = 32;
  parameter NUMWRDS =  8;
  parameter BITAPTR =  3;

  // TBD: BITAPTR will result in more mem entries being created
  // for e.g. NUMWRDS=6 => BITAPTR=3 => num entries addressed by
  // BITAPTR will be 8 i.e, mem will be 8 entries deep

  localparam SYNCDELAY = 2;

  input rst;

  input push_clk;
  input push;
  input [WIDTH-1:0] push_data;
  output push_err;

  input pop_clk;
  input pop;
  output [WIDTH-1:0] pop_data;
  output pop_vld;
  output pop_err;

  output full;
  output empty;

  // reset sync
  reg [SYNCDELAY-1:0] pu_rst_p;
  always @(posedge push_clk)
    pu_rst_p <= {pu_rst_p[SYNCDELAY-2:0], rst};

  reg [SYNCDELAY-1:0] po_rst_p;
  always @(posedge pop_clk)
    po_rst_p <= {po_rst_p[SYNCDELAY-2:0], rst};

  wire pu_rst = pu_rst_p[SYNCDELAY-1];
  wire po_rst = po_rst_p[SYNCDELAY-1];

  // FIFO memory
  wire write;
  wire read;
  wire [BITAPTR-1:0] raddr;
  wire [BITAPTR-1:0] waddr;
  wire [WIDTH-1:0] wdata;
  wire [WIDTH-1:0] rdata;
  reg [WIDTH-1:0] mem [0:NUMWRDS-1];
  always @(posedge push_clk)
    if (write)
      mem[waddr] <= wdata;
  assign rdata = read ? mem[raddr] : {WIDTH{1'bx}};

  // FIFO control
  reg  [BITAPTR-1:0] pu_ptr;
  wire [BITAPTR-1:0] pu_po_ptr;
  reg  [BITAPTR-1:0] po_ptr;
  wire [BITAPTR-1:0] po_pu_ptr;

  always @(posedge push_clk)
    if (pu_rst)
      pu_ptr <= {BITAPTR{1'b0}};
    else if (push)
      pu_ptr <= {pu_ptr[BITAPTR-2:0],~pu_ptr[BITAPTR-1]};

  assign waddr = pu_ptr;
  assign write = push;
  assign wdata = push_data;

  assign full = 1'b0; // TBD: need to implement full
  assign push_err = 1'b0; // TBD: implement
  
  integer           po_pu_int;
  reg [BITAPTR-1:0]      po_pu_ptr_reg [0:SYNCDELAY-1];
  always @(posedge pop_clk)
    for (po_pu_int=0; po_pu_int<SYNCDELAY; po_pu_int=po_pu_int+1)
      if (po_pu_int>0)
        po_pu_ptr_reg[po_pu_int] <= po_pu_ptr_reg[po_pu_int-1];
      else
        po_pu_ptr_reg[po_pu_int] <= pu_ptr;
  assign po_pu_ptr = po_pu_ptr_reg[SYNCDELAY-1];

  always @(posedge pop_clk)
    if (po_rst)
      po_ptr <= {BITAPTR{1'b0}};
    else if (pop)
      po_ptr <= {po_ptr[BITAPTR-2:0],~po_ptr[BITAPTR-1]};

  assign empty = (po_ptr == po_pu_ptr);
  assign read = pop;
  assign raddr = po_ptr;
  assign pop_data = rdata;
  assign pop_err = 1'b0; // TBD: need to implement
  assign pop_vld = pop; // TBD: depends on empty

  integer           pu_po_int;
  reg [BITAPTR-1:0]      pu_po_ptr_reg [0:SYNCDELAY-1];
  always @(posedge push_clk)
    for (pu_po_int=0; pu_po_int<SYNCDELAY; pu_po_int=pu_po_int+1)
      if (pu_po_int>0)
        pu_po_ptr_reg[pu_po_int] <= pu_po_ptr_reg[pu_po_int-1];
      else
        pu_po_ptr_reg[pu_po_int] <= po_ptr;
  assign pu_po_ptr = pu_po_ptr_reg[SYNCDELAY-1];

endmodule // core_afifo
