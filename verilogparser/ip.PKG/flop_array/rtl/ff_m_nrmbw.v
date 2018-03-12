module ff_m_nrmbw (clk, rst, read, write, rd_adr, wr_adr, din, bw, rd_dout, fout, rd_vld);

  parameter WIDTH = 8;
  parameter NUMADDR = 30;
  parameter BITADDR = 5;
  parameter NUMRPRT = 2;
  parameter NUMWPRT = 2;
  parameter NUMPRTMUX = 2;
  parameter NUMPRTDEMUX = 2;
  parameter FFINSRTR = 32'b0000_0000;
  parameter FFINSRTW = 32'b1111_1111;
  parameter RDDLY = 1;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 1; 
  parameter FLOPMEM = 0;
   
   
  localparam DEPTH = 2 ** BITADDR;  
  localparam MUXLEVEL = $clog2(DEPTH)/$clog2(NUMPRTMUX) ;
  localparam DEMUXLEVEL =  $clog2(DEPTH)/$clog2(NUMPRTDEMUX);
  localparam ARRAYMAXDEPTH = DEPTH/NUMPRTMUX;
  localparam BITNUMPRTMUX = $clog2(NUMPRTMUX);
   
  
  input  [NUMRPRT-1:0]            read;
  input  [NUMWPRT-1:0]            write;
  input  [NUMWPRT*BITADDR-1:0]    wr_adr;
  input  [NUMRPRT*BITADDR-1:0]    rd_adr;
  input  [NUMWPRT*WIDTH-1:0]      din;
  input  [NUMWPRT*WIDTH-1:0]      bw;


   
  output [NUMRPRT-1:0]            rd_vld;
  output [NUMRPRT*WIDTH-1:0]      rd_dout;
  output [NUMADDR*WIDTH-1:0] 	  fout;
  input 		          clk, rst;

   
  wire [DEPTH-1:0] 		 fout_temp [0:WIDTH-1] ;
  reg [NUMADDR*WIDTH-1:0] 	 fout;
  wire [BITADDR-1:0] 		 select_adr;
   


  //Backdoor Access Tasks

  //synopsys translate_off
 `ifndef FORMAL  
   task ff_cell_ReadTask;
      input [BITADDR-1:0] addr;
      output [WIDTH-1:0] dout;
      begin
         dout = flop_mem_wrap.flop_mem_bd[addr];
      end
   endtask
   
   task ff_cell_WriteTask;
     input [BITADDR-1:0] addr;
     input [WIDTH-1:0] din;
      begin
	 flop_mem_wrap.flop_mem_bd_wr = 1'b1;
	 flop_mem_wrap.flop_mem_bd[addr] = din;
      end
   endtask
   
   task ff_cell_ResetTask;
     begin
	flop_mem_wrap.flop_mem_bd_wr = 1'b0;
     end
   endtask 
    `endif
   //synopsys translate_on 

`ifdef FORMAL

   reg [WIDTH-1:0] 		 fmem;
   reg 				 fmem_inv;
   always @(posedge clk)
   begin
      if (rst)
	begin
	   fmem_inv <= 1'b1;
	   fmem <= 0;
	end
      else 
	begin
	   for(int i=0; i<NUMWPRT; i++) begin
	      if (write[i] && (wr_adr[(i+1)*BITADDR-1 -: BITADDR] == select_adr)) begin
		 fmem <= din[(i+1)*WIDTH-1 -: WIDTH];
		 fmem_inv <= 1'b0;
	      end
	   end
	end // else: !if(rst)
   end // always @ (posedge clk)

   assume_select_addr_check: assume property(@(posedge clk) disable iff(rst) (select_adr < NUMADDR  && $stable(select_adr) && (bw == {NUMWPRT*WIDTH{1'b1}}) && $stable(bw)));
   assume_rd_conflict_check: assume property (@(posedge clk) disable iff(rst) ((read[0] && read[1]) |-> (rd_adr[BITADDR-1:0] != rd_adr[2*BITADDR-1:BITADDR])));
   assume_wr_conflict_check: assume property (@(posedge clk) disable iff(rst) ((write[0] && write[1]) |-> (wr_adr[BITADDR-1:0] != wr_adr[2*BITADDR-1:BITADDR])));
   assume_rd_wr_conflict_check0: assume property (@(posedge clk) disable iff(rst) write[0] |-> !((read[0] && (rd_adr[BITADDR-1:0] == wr_adr[BITADDR-1:0])) || (read[1] && (rd_adr[2*BITADDR-1:BITADDR] == wr_adr[BITADDR-1:0]))));
   assume_rd_wr_conflict_check1: assume property (@(posedge clk) disable iff(rst) write[1] |-> !((read[0] & (rd_adr[BITADDR-1:0] == wr_adr[2*BITADDR-1:BITADDR])) || (read[1] & (rd_adr[2*BITADDR-1:BITADDR] == wr_adr[2*BITADDR-1:BITADDR])))); 
   
generate if (RDDLY>0) begin: d_l
   assert_rd_dout_check_0: assert property (@(posedge clk) disable iff(rst) (read[0] && rd_adr[BITADDR-1:0] == select_adr[BITADDR-1:0]) |-> ##RDDLY ($past(fmem_inv,RDDLY) || ((rd_vld[0] == 1'b1) && (rd_dout[WIDTH-1:0] == $past(fmem,RDDLY)))));
   assert_rd_dout_check_1: assert property (@(posedge clk) disable iff(rst) (read[1] && rd_adr[2*BITADDR-1:BITADDR] == select_adr[BITADDR-1:0]) |-> ##RDDLY ($past(fmem_inv,RDDLY) || ((rd_vld[1] == 1'b1) && (rd_dout[2*WIDTH-1:WIDTH] == $past(fmem,RDDLY)))));
  end else begin : nd_l
   assert_rd_dout_check_0: assert property (@(posedge clk) disable iff(rst) (read[0] && rd_adr[BITADDR-1:0] == select_adr[BITADDR-1:0]) |-> ##RDDLY (fmem_inv || ((rd_vld[0] == 1'b1) && (rd_dout[WIDTH-1:0] == fmem))));
   assert_rd_dout_check_1: assert property (@(posedge clk) disable iff(rst) (read[1] && rd_adr[2*BITADDR-1:BITADDR] == select_adr[BITADDR-1:0]) |-> ##RDDLY (fmem_inv || ((rd_vld[1] == 1'b1) && (rd_dout[2*WIDTH-1:WIDTH] == fmem))));
end
endgenerate
   
`endif //  `ifdef FORMAL
   

   
   always_comb begin
      for(int i=0; i<NUMADDR; i++)
	for(int j=0; j<WIDTH; j++)
	  fout[i*WIDTH+j] = fout_temp[j][i];
   end
   
   reg [NUMWPRT-1:0] 		 write_ff [0:FLOPIN] ;
   reg [NUMWPRT*BITADDR-1:0] 	 wr_adr_ff [0:FLOPIN] ;
   reg [NUMWPRT*WIDTH-1:0] 	 din_ff [0:FLOPIN] ;
   reg [NUMWPRT*WIDTH-1:0] 	 bw_ff [0:FLOPIN];
   reg [NUMRPRT*BITADDR-1:0] 	 rd_adr_ff [0:FLOPIN+FLOPMEM+FLOPOUT] ;
   reg [NUMRPRT-1:0] 		 read_ff [0:FLOPIN+FLOPMEM+FLOPOUT] ;

   wire [WIDTH-1:0] 		 flop_mem_dout [0:DEPTH-1];
   reg [NUMRPRT*WIDTH-1:0] 	 rd_dout_wire;
   reg [NUMRPRT*WIDTH-1:0] 	 rd_dout_ff[0:FLOPOUT];

   always_comb begin
      for(int i=0; i<NUMRPRT; i++)
	rd_dout_wire[(i+1)*WIDTH-1 -: WIDTH] = flop_mem_dout[rd_adr_ff[FLOPIN+FLOPMEM][(i+1)*BITADDR-1 -: BITADDR]];
   end

   genvar i;
   generate for(i=0; i<=FLOPIN; i++)
     begin
	if(i==0) begin
	   always_comb
	     begin
		write_ff[0] = write;
		wr_adr_ff[0] = wr_adr;
		din_ff[0] = din;
		bw_ff[0] = bw;
	     end
	end
	else
	  begin
	     always @ (posedge clk)
	       begin
		  write_ff[i] <= write_ff[i-1];
		  wr_adr_ff[i] <= wr_adr_ff[i-1];
		  din_ff[i] <= din_ff[i-1];
		  bw_ff[i] <= bw_ff[i-1];
	       end
	  end // else: !if(FLOPIN==0)
     end // for (i=0; i<=FLOPIN; i++)
   endgenerate
   
      
   genvar j;
   generate for(j=0; j<=(FLOPIN+FLOPMEM+FLOPOUT); j++) begin
      if(j==0) begin
	 always_comb begin
	    rd_adr_ff[j] = rd_adr;
	    read_ff[j] = read;
	 end
      end
      else begin
	 always @ (posedge clk)
	   begin
	      rd_adr_ff[j] <= rd_adr_ff[j-1];
	      read_ff[j] <= read_ff[j-1];
	   end
      end // else: !if(j==0)
   end
   endgenerate
   
   genvar k;
   generate for(k=0; k<=FLOPOUT; k++)
     begin
	if(k==0) begin
	   always_comb begin
		 rd_dout_ff[k] = rd_dout_wire;
	   end
	end
	else begin
	   always @ (posedge clk)
	     rd_dout_ff[k] <= rd_dout_ff[k-1];
	end
     end // for (k=0; k<=FLOPOUT; k++)
   endgenerate

 

   ff_m_mem_wrap #(.NUMRDPT(NUMRPRT), .NUMWRPT(NUMWPRT), .BITADDR(BITADDR), .WIDTH(WIDTH), .DEPTH(DEPTH), .FF_DEPTH(NUMADDR), .BITMUXPRT(BITNUMPRTMUX), .NUMDEMUXPT(NUMPRTDEMUX), .FFINSRT(FFINSRTW), .FLOP_MEM(FLOPMEM)) flop_mem_wrap (.dout(flop_mem_dout), .write(write_ff[FLOPIN]), .rdaddr(rd_adr_ff[FLOPIN]), .wraddr(wr_adr_ff[FLOPIN]), .din(din_ff[FLOPIN]), .bw(bw_ff[FLOPIN]), .fout(fout_temp), .rst(rst), .clk(clk));



   assign rd_dout = rd_dout_ff[FLOPOUT];
   assign rd_vld = read_ff[FLOPIN+FLOPMEM+FLOPOUT];

   
endmodule // memoir_ff_m_nrmbw


