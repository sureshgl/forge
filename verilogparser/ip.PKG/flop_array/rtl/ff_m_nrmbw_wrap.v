module ff_m_nrmbw_wrap(clk, rst, read, write, rd_adr, wr_adr, din, bw, rd_dout, flopout_en);

  parameter WIDTH = 8;
  parameter NUMADDR = 16;
  parameter BITADDR = 4;
  parameter NUMRPRT = 5;
  parameter NUMWPRT = 2;
  input  [NUMRPRT-1:0]            read;
  input  [NUMWPRT-1:0]            write;
  input  [NUMWPRT*BITADDR-1:0]    wr_adr;
  input  [NUMRPRT*BITADDR-1:0]    rd_adr;
  input  [NUMWPRT*WIDTH-1:0]      din;
  input  [NUMWPRT*WIDTH-1:0]      bw;


  output [NUMRPRT*WIDTH-1:0]      rd_dout;
  input                   clk, rst, flopout_en;

  ff_m_nrmbw  #(
        .NUMWPRT(NUMWPRT),
        .NUMRPRT(NUMRPRT),
        .WIDTH(WIDTH),
        .NUMADDR(NUMADDR),
        .BITADDR(BITADDR),
        .FLOPIN(0),
        .FLOPOUT(0),
        .FLOPMEM(0),
        .NUMPRTMUX(2),
        .RDDLY(0)
        )
    top (.clk(clk), .rst(rst), .read(read), .write(write), .rd_adr(rd_adr), .wr_adr(wr_adr), .din(din), .bw(bw), .rd_dout(rd_dout), .fout(), .rd_vld());


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


endmodule
