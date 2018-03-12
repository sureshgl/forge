module ff_m_nrmbw_async_wrap (wr_clk, rd_clk, wr_rst, rd_rst, read, write, rd_adr, wr_adr, din, bw, rd_dout,flopout_en);

  parameter WIDTH = 4;
  parameter NUMADDR = 32;
  parameter BITADDR = 5;
  parameter NUMRPRT = 2;
  parameter NUMWPRT = 2;
  
  localparam BITADR_S = BITADDR >= 3? BITADDR :3;
  
  input  [NUMRPRT-1:0]            read;
  input  [NUMWPRT-1:0]            write;
  input  [NUMWPRT*BITADDR-1:0]    wr_adr;
  input  [NUMRPRT*BITADDR-1:0]    rd_adr;
  input  [NUMWPRT*WIDTH-1:0]      din;
  input  [NUMWPRT*WIDTH-1:0]      bw;


  output [NUMRPRT*WIDTH-1:0]      rd_dout;
  input                           wr_clk,rd_clk, rd_rst, wr_rst, flopout_en;

  ff_m_nrmbw_async  #(
        .NUMWPRT(NUMWPRT),
        .NUMRPRT(NUMRPRT),
        .WIDTH(WIDTH),
        .NUMADDR(NUMADDR),
        .BITADDR(BITADR_S),
        .FLOPIN(0),
        .FLOPOUT(0),
        .FLOPMEM(0),
        .NUMPRTMUX(2),
        .RDDLY(0)
        )
    top (.rdclk(rd_clk), .wrclk(wr_clk), .rst(rd_rst), .read(read), .write(write), .rd_adr({{(BITADR_S-BITADDR){1'b0}},rd_adr}), .wr_adr({{(BITADR_S-BITADDR){1'b0}},wr_adr}), .din(din), .bw(bw), .rd_dout(rd_dout), .fout(), .rd_vld());

//synopsys translate_off
`ifndef FORMAL
   task ff_cell_ReadTask;
      input [BITADDR-1:0] addr;
      output [WIDTH-1:0] dout;
      begin
        top.ff_cell_ReadTask(addr,dout);
      end
   endtask

   task ff_cell_WriteTask;
     input [BITADDR-1:0] addr;
     input [WIDTH-1:0] din;
      begin
        top.ff_cell_WriteTask(addr,din);
      end
   endtask

   task ff_cell_ResetTask;
     begin
        top.ff_cell_ResetTask();
     end
   endtask // for
`endif
   //synopsys translate_on


/*
  parameter NUMPRTMUX = 2;
  parameter NUMPRTDEMUX = 2;
  parameter FFINSRTR = 32'b0000_0000;
  parameter FFINSRTW = 32'b1111_1111;
  parameter RDDLY = 2;
  parameter FLOPIN = 1;
  parameter FLOPOUT = 1;
  parameter FLOPMEM = 0;


  localparam DEPTH = 2 ** BITADDR;
  localparam MUXLEVEL = $clog2(DEPTH)/$clog2(NUMPRTMUX) ;
  localparam DEMUXLEVEL =  $clog2(DEPTH)/$clog2(NUMPRTDEMUX);
  localparam ARRAYMAXDEPTH = DEPTH/NUMPRTMUX;
  localparam BITNUMPRTMUX = $clog2(NUMPRTMUX);
*/




endmodule
