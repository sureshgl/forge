module ff_m_nrmbw (clk, rst, read, write, rd_adr, wr_adr, din, bw, rd_dout, fout, rd_vld);

  parameter WIDTH = 8;
  parameter NUMADDR = 32;
  parameter BITADDR = 5;
  parameter NUMRPRT = 5;
  parameter NUMWPRT = 2;
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
   
   assert_rd_dout_check_0: assert property (@(posedge clk) disable iff(rst) (read[0] && rd_adr[BITADDR-1:0] == select_adr[BITADDR-1:0]) |-> ##RDDLY ($past(fmem_inv,RDDLY) || ((rd_vld[0] == 1'b1) && (rd_dout[WIDTH-1:0] == $past(fmem,RDDLY)))));
   assert_rd_dout_check_1: assert property (@(posedge clk) disable iff(rst) (read[1] && rd_adr[2*BITADDR-1:BITADDR] == select_adr[BITADDR-1:0]) |-> ##RDDLY ($past(fmem_inv,RDDLY) || ((rd_vld[1] == 1'b1) && (rd_dout[2*WIDTH-1:WIDTH] == $past(fmem,RDDLY)))));
   
`endif //  `ifdef FORMAL
   

   
   always_comb begin
      for(int i=0; i<NUMADDR; i++)
	for(int j=0; j<WIDTH; j++)
	  fout[i*WIDTH+j] = fout_temp[j][i];
   end
   
   reg [NUMWPRT-1:0] 		 write_ff ;
   reg [NUMWPRT*BITADDR-1:0] 	 wr_adr_ff ;
   reg [NUMWPRT*WIDTH-1:0] 	 din_ff ;
   reg [NUMWPRT*WIDTH-1:0] 	 bw_ff ;
   reg [NUMRPRT*BITADDR-1:0] 	 rd_adr_ff ;
   reg [NUMRPRT*BITADDR-1:0] 	 rd_adr_ff_mux;

   /*
    wire [NUMWPRT-1:0] 		 write_ff_wire;
    wire [NUMWPRT*BITADDR-1:0] 	 wr_adr_ff_wire;
    wire [NUMWPRT*WIDTH-1:0] 	 din_ff_wire;
    wire [NUMWPRT*WIDTH-1:0] 	 bw_ff_wire;
    wire [NUMRPRT*BITADDR-1:0] 	 rd_adr_ff_wire_read;
    wire [NUMRPRT*BITADDR-1:0] 	 rd_adr_ff_wire_mux;
    */

   generate if(FLOPMEM)
     begin
	always @ (posedge clk)
	  rd_adr_ff_mux <= rd_adr_ff;
     end
   else
     begin
       always_comb begin
	rd_adr_ff_mux = rd_adr_ff;
       end
     end
   endgenerate
   
   generate if((FLOPIN>0) || (FLOPMEM>0)) 
     begin
	always @ (posedge clk) begin
	   write_ff <= write;
	   wr_adr_ff <= wr_adr;
	   din_ff <= din ;
	   bw_ff <= bw ;
           rd_adr_ff <= rd_adr ;
	end
     end
   else
     begin
	always_comb begin
	   write_ff = write;
	   wr_adr_ff = wr_adr;
	   din_ff = din ;
	   bw_ff = bw ;
           rd_adr_ff = rd_adr ;
	end
     end // else: !if((FLOPIN>0) || (FLOPMEM>0))
   endgenerate
   
   
   genvar i,j,k;
   
   //reg [NUMRPRT*BITADDR-1:0] rdaddr_reg [0: MUXLEVEL-1]; 
   wire [NUMRPRT*BITADDR-1:0] rdaddr_stg [0: MUXLEVEL-1];
   
   reg [NUMRPRT*BITADDR-1:0] rdaddr_ff_0;
   reg [NUMRPRT*BITADDR-1:0] rdaddr_ff_1;
   reg [NUMRPRT*BITADDR-1:0] rdaddr_ff_2;
   reg [NUMRPRT*BITADDR-1:0] rdaddr_ff_3;
    
   generate if(FFINSRTR[0]) 
     begin
	always @ (posedge clk)
	  rdaddr_ff_0 <= rd_adr_ff_mux;
     end
   else
     begin
	always_comb begin
	   rdaddr_ff_0 = rd_adr_ff_mux;
	end
     end // else: !if(FFINSRTR[0])
   endgenerate

   generate if(FFINSRTR[1]) 
     begin
	always @ (posedge clk)
	  rdaddr_ff_1 <= rdaddr_stg[0];
     end
   else
     begin
	always_comb begin
	   rdaddr_ff_1 = rdaddr_stg[0]; 
	end
     end 
   endgenerate

   generate if(FFINSRTR[2]) 
     begin
	always @ (posedge clk)
	  rdaddr_ff_2 <= rdaddr_stg[1];
     end
   else
     begin
	always_comb begin
	   rdaddr_ff_2 = rdaddr_stg[1]; 
	end
     end 
   endgenerate

   generate if(FFINSRTR[3]) 
     begin
	always @ (posedge clk)
	  rdaddr_ff_3 <= rdaddr_stg[2];
     end
   else
     begin
	always_comb begin
	   rdaddr_ff_3 = rdaddr_stg[2]; 
	end
     end 
   endgenerate
   
	     
	  
/*
 always @ (posedge clk)
 begin
 rdaddr_reg [0] <= rd_adr_ff_mux;
 
 for(int i=1; i<MUXLEVEL; i++) begin
 rdaddr_reg [i] <= rdaddr_stg[i-1];
	end
     end
 */
     
   generate for (i=0; i<MUXLEVEL; i++) begin
      if(i==0)
	assign rdaddr_stg[i] = rdaddr_ff_0 ;//FFINSRTR[i]? rdaddr_reg[i] : rd_adr_ff_mux;
      else if(i==1)
	assign rdaddr_stg[i] = ((FFINSRTR[i] & !FFINSRTR[i-1])? rdaddr_ff_0 : FFINSRTR[i]? rdaddr_ff_1 : rdaddr_stg[i-1]);
      else if(i==2)
	assign rdaddr_stg[i] = ((FFINSRTR[i] & !FFINSRTR[i-1])? rdaddr_ff_1 : FFINSRTR[i]? rdaddr_ff_2 : rdaddr_stg[i-1]);
      else if(i==3)
	assign rdaddr_stg[i] = ((FFINSRTR[i] & !FFINSRTR[i-1])? rdaddr_ff_2 : FFINSRTR[i]? rdaddr_ff_3 : rdaddr_stg[i-1]);
      else
	assign rdaddr_stg[i] = rdaddr_stg[i-1];
   end // for (i=0; i<MUXLEVEL; i++)
   endgenerate
				
   //((FFINSRTR[i] & !FFINSRTR[i-1])? rdaddr_reg[i-1] : 
   //				FFINSRTR[i]? rdaddr_reg[i] : rdaddr_stg[i-1]);
   

   wire [WIDTH-1:0]   mux_dout_int [0:NUMRPRT-1][0: MUXLEVEL-1][0:ARRAYMAXDEPTH-1];  
   //reg [WIDTH-1:0]    mux_dout_reg [0:NUMRPRT-1][0: MUXLEVEL-1][0:ARRAYMAXDEPTH-1];
   reg [WIDTH-1:0]    mux_dout_ff_0 [0:NUMRPRT-1][0:ARRAYMAXDEPTH-1];
   reg [WIDTH-1:0]    mux_dout_ff_1 [0:NUMRPRT-1][0:ARRAYMAXDEPTH-1];
   reg [WIDTH-1:0]    mux_dout_ff_2 [0:NUMRPRT-1][0:ARRAYMAXDEPTH-1];
   reg [WIDTH-1:0]    mux_dout_ff_3 [0:NUMRPRT-1][0:ARRAYMAXDEPTH-1];
   
   reg [WIDTH-1:0]    mux_dout_stg [0:NUMRPRT-1][0: MUXLEVEL-1][0:ARRAYMAXDEPTH-1];  
   wire [WIDTH-1:0]   flop_mem_dout [0: NUMRPRT-1][0: ARRAYMAXDEPTH-1];
   
   
   generate if(FFINSRTR[0])
     begin
	always @ (posedge clk) begin
	      for(int i=0; i<NUMRPRT; i++) 
		 for(int k=0; k<ARRAYMAXDEPTH; k++) 
		    mux_dout_ff_0 [i][k] <= flop_mem_dout [i][k];
	end
     end
   else
     begin
	always_comb begin
	    for(int i=0; i<NUMRPRT; i++) 
		 for(int k=0; k<ARRAYMAXDEPTH; k++) 
		    mux_dout_ff_0 [i][k] = flop_mem_dout [i][k];
	end
     end // else: !if(FFINSRTR[0])
   endgenerate

   generate if(FFINSRTR[1])
     begin
	always @ (posedge clk) begin
	      for(int i=0; i<NUMRPRT; i++) 
		 for(int k=0; k<ARRAYMAXDEPTH; k++) 
		    mux_dout_ff_1 [i][k] <= mux_dout_int [i][0][k];
	end
     end
   else
     begin
	always_comb begin
	    for(int i=0; i<NUMRPRT; i++) 
		 for(int k=0; k<ARRAYMAXDEPTH; k++) 
		    mux_dout_ff_1 [i][k] = mux_dout_int [i][0][k];
	end
     end 
   endgenerate


   generate if(FFINSRTR[2])
     begin
	always @ (posedge clk) begin
	      for(int i=0; i<NUMRPRT; i++) 
		 for(int k=0; k<ARRAYMAXDEPTH; k++) 
		    mux_dout_ff_2 [i][k] <= mux_dout_int [i][1][k];
	end
     end
   else
     begin
	always_comb begin
	    for(int i=0; i<NUMRPRT; i++) 
		 for(int k=0; k<ARRAYMAXDEPTH; k++) 
		    mux_dout_ff_2 [i][k] = mux_dout_int [i][1][k];
	end
     end 
   endgenerate


   generate if(FFINSRTR[3])
     begin
	always @ (posedge clk) begin
	      for(int i=0; i<NUMRPRT; i++) 
		 for(int k=0; k<ARRAYMAXDEPTH; k++) 
		    mux_dout_ff_3 [i][k] <= mux_dout_int [i][2][k];
	end
     end
   else
     begin
	always_comb begin
	    for(int i=0; i<NUMRPRT; i++) 
		 for(int k=0; k<ARRAYMAXDEPTH; k++) 
		    mux_dout_ff_3 [i][k] = mux_dout_int [i][2][k];
	end
     end 
   endgenerate

  
/*
   always @ (posedge clk) begin
      for(int i=0; i<NUMRPRT; i++) begin
	 for(int j=0; j<MUXLEVEL; j++) begin
            for(int k=0; k<ARRAYMAXDEPTH; k++) begin
               mux_dout_reg [i][j][k] <= (j==0)? flop_mem_dout[i][k] : mux_dout_int[i][j-1][k] ;
               
            end
	 end
      end
   end
 */  
 
   always_comb
     begin
	for(int i=0; i<NUMRPRT; i++) begin
           for(int j=0; j<MUXLEVEL; j++) begin
	      for(int k=0; k<ARRAYMAXDEPTH; k++) begin
                 if(j==0)  
                   mux_dout_stg[i][j][k] = mux_dout_ff_0[i][k] ;//FFINSRTR[j]? mux_dout_reg[i][j][k] : flop_mem_dout[i][k];
                 else if(j==1)
                   mux_dout_stg[i][j][k] = FFINSRTR[j]? mux_dout_ff_1[i][k] : mux_dout_int[i][j-1][k]; //FFINSRTR[j]? mux_dout_reg[i][j][k] : mux_dout_int[i][j-1][k];
		 else if(j==2)
                   mux_dout_stg[i][j][k] = FFINSRTR[j]? mux_dout_ff_2[i][k] : mux_dout_int[i][j-1][k];
		 else if(j==3)
                   mux_dout_stg[i][j][k] = FFINSRTR[j]? mux_dout_ff_3[i][k] : mux_dout_int[i][j-1][k];
		 else
		   mux_dout_stg[i][j][k] = mux_dout_int[i][j-1][k];
	      end 
           end
        end
     end 
   
   wire [BITNUMPRTMUX-1:0] mux_sel_addr[0:NUMRPRT-1][0:MUXLEVEL-1];

   generate for(i=0; i<NUMRPRT; i++) begin
       for(j=0; j<MUXLEVEL-1; j++) begin
	  for(k=ARRAYMAXDEPTH/NUMPRTMUX; k<ARRAYMAXDEPTH; k++) begin
	     assign mux_dout_int [i][j][k] = 0;
	  end
       end
    end
    endgenerate
   
   generate for(i=0; i<NUMRPRT; i++) begin
      for(j=0; j<MUXLEVEL-1; j++) begin
	    //assign mux_sel_addr [i][j]= (rdaddr_stg[j][(i+1)*BITADDR-1 -: BITADDR] >> ((j+1)*BITNUMPRTMUX));
	    assign mux_sel_addr [i][j]= rdaddr_stg[j][i*BITADDR+(j+2)*BITNUMPRTMUX-1 : i*BITADDR+(j+1)*BITNUMPRTMUX];
            for(k=0; k<ARRAYMAXDEPTH/NUMPRTMUX; k++) begin
	       if (k < ((ARRAYMAXDEPTH/NUMPRTMUX) >> (j*BITNUMPRTMUX))) begin
                mux_m_nr #(.WIDTH(WIDTH),.BITWIDTH(BITNUMPRTMUX), .NUMPRT(NUMPRTMUX)) mux_ug  (.pin(mux_dout_stg[i][j][(k+1)*NUMPRTMUX-1 -:NUMPRTMUX]), .select(mux_sel_addr[i][j]), .pout(mux_dout_int[i][j][k]));       
               end
	       else
		 assign mux_dout_int[i][j][k] = 0;
	    end
      end
   end
   endgenerate
        
   reg [MUXLEVEL+FLOPMEM+FLOPOUT:0] rd_vld_reg [0:NUMRPRT-1];  
   reg [MUXLEVEL+FLOPMEM+FLOPOUT:0] rd_vld_nxt [0:NUMRPRT-1];    
   wire [NUMRPRT*WIDTH-1:0] rd_dout_pf;


   reg [NUMRPRT*WIDTH-1:0] rd_dout_ff ;

   generate if(FLOPOUT > 0) 
     begin
	always @ (posedge clk)
	  rd_dout_ff <= rd_dout_pf;
     end
   else
     begin
	always_comb
	  rd_dout_ff = rd_dout_pf;
     end
   endgenerate
  
   assign rd_dout = rd_dout_ff ;
  
   
   generate for (i=0; i<NUMRPRT; i++) begin
      assign rd_dout_pf[(i+1)*WIDTH-1 -: WIDTH] = mux_dout_int[i][MUXLEVEL-2][0]; //FFINSRTR[MUXLEVEL-1]? mux_dout_reg[i][MUXLEVEL-1][0] : mux_dout_int[i][MUXLEVEL-2][0];
      if(RDDLY !=0) 
	assign rd_vld[(i+1)-1 -: 1] = rd_vld_reg[i][RDDLY-1];
      else
	assign rd_vld[(i+1)-1 -: 1] = read[(i+1)-1 -: 1];
   end
   endgenerate
   
    always_comb
     begin
	rd_vld_nxt = rd_vld_reg;
	for(int i=0; i<NUMRPRT; i++) begin
	   for(int j=0; j<= (MUXLEVEL+FLOPMEM+FLOPOUT); j++)
	     rd_vld_nxt [i][j] = ((j==0)? read[(i+1)-1 -: 1] : rd_vld_reg [i][j-1]);
	end
     end

   always @ (posedge clk)
     if(rst)
       begin
	  for(int i=0; i<NUMRPRT; i++)
	    rd_vld_reg[i] <= 0;
       end
     else
       rd_vld_reg <= rd_vld_nxt;



   ff_m_mem_wrap #(.NUMRDPT(NUMRPRT), .NUMWRPT(NUMWPRT), .BITADDR(BITADDR), .WIDTH(WIDTH), .DEPTH(DEPTH), .FF_DEPTH(NUMADDR), .BITMUXPRT(BITNUMPRTMUX), .NUMDEMUXPT(NUMPRTDEMUX), .FFINSRT(FFINSRTW), .FLOP_MEM(FLOPMEM)) flop_mem_wrap (.dout(flop_mem_dout), .write(write_ff), .rdaddr(rd_adr_ff), .wraddr(wr_adr_ff), .din(din_ff), .bw(bw_ff), .fout(fout_temp), .rst(rst), .clk(clk));
	    
endmodule // memoir_ff_m_nrmbw


