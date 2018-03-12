module ff_m_mem_wrap (rst, clk, din, bw, dout, wraddr, write, rdaddr, fout);

   parameter NUMWRPT = 1;
   parameter NUMRDPT = 1;
   parameter BITADDR = 4;
   parameter WIDTH = 16;
   parameter DEPTH = 16;
   parameter FF_DEPTH = 16;
   parameter BITMUXPRT = 1;
   parameter NUMDEMUXPT = 2;
   parameter FFINSRT = 32'b1111_1111;
   parameter FLOP_MEM = 0;

   localparam MUXPRT = 2**BITMUXPRT; 
   localparam MXDEPTH = DEPTH/MUXPRT;
   localparam DEMUXLEVEL = BITADDR/$clog2(NUMDEMUXPT);
   localparam BITNUMDEMUXPT = $clog2(NUMDEMUXPT);
   localparam MAXDEPTH = DEPTH/NUMDEMUXPT;

   

   input      clk;
   input      rst;
   input [NUMWRPT-1:0] write;
   input [NUMWRPT*BITADDR-1:0] wraddr;
   input [NUMWRPT*WIDTH-1:0]   din;
   input [NUMWRPT*WIDTH-1:0]   bw;
   input [NUMRDPT*BITADDR-1:0] rdaddr;

   wire [NUMRDPT*BITADDR-1:0] rdaddr_temp;
   reg [NUMRDPT*BITADDR-1:0]  rdaddr_ff [0:4];
 
   output [WIDTH-1:0] 	       dout [0: NUMRDPT-1][0: MXDEPTH-1];
   output [DEPTH-1:0] 	       fout [0:WIDTH-1] ;
   
   wire [DEPTH-1:0] 	       dout_temp_wire [0:WIDTH-1] ;
   reg [DEPTH-1:0] 	       dout_temp [0:WIDTH-1] ;
   reg [DEPTH-1:0] 	       dout_temp_ff [0:WIDTH-1] [0:4] ;

   always @ (posedge clk)
     begin
        rdaddr_ff[0] <= (FLOP_MEM >0)? rdaddr : 0;
	for(int j=0; j<WIDTH; j++) begin
	   dout_temp_ff[j][0] <= (FLOP_MEM >0)? dout_temp_wire [j] : 0;
	end
     end
   
   always @ (posedge clk)
     begin
	for(int i=1; i<4; i++) begin
	   rdaddr_ff[i] <= (i <FLOP_MEM)? rdaddr_ff[i-1] : 0;
	   for(int j=0; j<WIDTH; j++) begin
	      dout_temp_ff [j][i] <= (i <FLOP_MEM)? dout_temp_ff[j][i-1] : 0;
	   end
	end
     end
   genvar idx;
   generate if(FLOP_MEM >0) begin
      assign rdaddr_temp = rdaddr_ff[FLOP_MEM-1];
      for(idx=0; idx<WIDTH; idx++) begin
	 assign dout_temp [idx] = dout_temp_ff [idx][FLOP_MEM-1];
      end
   end
   else
     begin
	assign rdaddr_temp = rdaddr;
	for(idx=0; idx<WIDTH; idx++) begin
	   assign dout_temp [idx] = dout_temp_wire [idx];
	end
     end // else: !if(FLOP_MEM >0)
   endgenerate
   
	
      
	
   
   wire [NUMWRPT-1:0] 	       flop_mem_cell_din [0:WIDTH-1];
   //wire [WIDTH-1:0] 	       flop_mem_din [0 : NUMWRPT-1][0:DEPTH-1];
   wire [NUMWRPT-1:0] 	       flop_mem_cell_bw [0:WIDTH-1];
   wire [NUMWRPT-1:0] 	       flop_mem_cell_write;
   wire [NUMWRPT*BITADDR-1 :0] flop_mem_cell_addr;
   
   reg [BITADDR-1:0] 	       wraddr_reg [0 : NUMWRPT-1][0 : DEMUXLEVEL-1];
   reg 			       write_reg [0 : NUMWRPT-1][0 : DEMUXLEVEL];
   reg [WIDTH-1:0]             din_reg [0 : NUMWRPT-1][0 : DEMUXLEVEL];
   
   wire [WIDTH-1:0]            din_stg [0 : NUMWRPT-1][0 : DEMUXLEVEL];
   wire [BITADDR-1:0] 	       wraddr_stg [0 : NUMWRPT-1][0:DEMUXLEVEL-1];
   wire 		       write_stg [0 : NUMWRPT-1][0:DEMUXLEVEL];  
   
   genvar i,j, k;
   generate for(i=0; i<NUMWRPT; i++) begin
      for(j=0; j<WIDTH; j++) begin
	 assign flop_mem_cell_din [j][i] = din[i*WIDTH+j];
	 assign flop_mem_cell_bw [j][i] = bw[i*WIDTH+j];
      end
   end
   endgenerate  

   assign flop_mem_cell_write = write;
   assign flop_mem_cell_addr = wraddr;
   
   reg [WIDTH-1:0] flop_mem_bd [0:DEPTH-1];
   reg [DEPTH-1:0] flop_mem_bd_tp [0:WIDTH-1];
   reg 		   flop_mem_bd_wr;
   
   always @ (posedge clk)
     if(rst)
       flop_mem_bd_wr <= 1'b0;


      
   //synopsys translate_off
   always @ (posedge clk)
     begin
	for(int idx=0; idx<WIDTH; idx++) begin
	   for(int idx2=0; idx2 < NUMWRPT; idx2++) begin
	      if(flop_mem_cell_write[idx2])
		flop_mem_bd [flop_mem_cell_addr[(idx2+1)*BITADDR-1 -: BITADDR]][idx] <= flop_mem_cell_din [idx][idx2];
	   end
	end
     end
   //synopsys translate_on

   always_comb begin
      flop_mem_bd_tp = '{default:'0};
      //synopsys translate_off
      for(int i=0; i<WIDTH; i++) begin
	 for(int j=0; j<DEPTH; j++) begin
	    flop_mem_bd_tp [i][j] = flop_mem_bd [j][i];
	 end
      end
      //synopsys translate_on
   end


   generate for(i=0; i<WIDTH; i++) begin: width_loop
      ff_m_mem_cell #(.BITADDR(BITADDR), .NUMWRPT(NUMWRPT), .FF_DEPTH(FF_DEPTH)) 
      flop_mem_cell_inst (.clk(clk), .write(flop_mem_cell_write), .addr(flop_mem_cell_addr), .bw(flop_mem_cell_bw[i]), .din(flop_mem_cell_din[i]), 
			  .dout(dout_temp_wire[i]), .bd_write(flop_mem_bd_wr), .bd_data(flop_mem_bd_tp[i]));
   end
   endgenerate
   
   generate for(i=0; i<NUMRDPT; i++) begin : port_loop
      for(j=0; j<WIDTH; j++) begin: width_loop
         for(k=0; k<MXDEPTH; k++)  begin : depth_loop
	    mux_m_1b #(.BITMUXPRT(BITMUXPRT)) mux_inst (.in(dout_temp[j][(k+1)*MUXPRT-1 -: MUXPRT]), .sel(rdaddr_temp[i*BITADDR+BITMUXPRT-1 -:BITMUXPRT]), .out(dout[i][k][j]));	 
         end
      end
   end
   endgenerate

   assign fout = dout_temp_wire;


`ifdef FORMAL
   //assume_bd_wr_check: assume property(@(posedge clk) disable iff(rst) (flop_mem_bd_wr == 0  && $stable(flop_mem_bd_wr)));
   assert_cell_bw_check: assert property (@(posedge clk) disable iff(rst) (flop_mem_cell_bw[0][0] == bw[0]));
`endif
             
endmodule
