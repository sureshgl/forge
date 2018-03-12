
module algo_10ror5w_top (refr, clk, rst, ready,
                        write, wr_adr, din,
                        read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr, algo_sel,
	                t1_readA, t1_writeA, t1_addrA, t1_dwsnA, t1_bwA, t1_dinA, t1_doutA, t1_serrA, t1_refrB, t1_bankB,
	                t2_readA, t2_writeA, t2_addrA, t2_dwsnA, t2_bwA, t2_dinA, t2_doutA, t2_serrA, t2_refrB, t2_bankB,
	                t3_readA, t3_writeA, t3_addrA, t3_dwsnA, t3_bwA, t3_dinA, t3_doutA, t3_serrA, t3_refrB, t3_bankB,
	                t4_readA, t4_writeA, t4_addrA, t4_dwsnA, t4_bwA, t4_dinA, t4_doutA, t4_serrA, t4_refrB, t4_bankB, select_addr, select_bit);
   
  
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAEXT = 0;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ECCWDTH = 7;
  parameter MEMWDTH = ENAEXT ? WIDTH : ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW1 = 2048;
  parameter BITVROW1 = 11;
  parameter NUMVBNK1 = 4;
  parameter BITVBNK1 = 2;
  parameter BITPBNK1 = 4;
  parameter FLOPIN1 = 0;
  parameter FLOPOUT1 = 0;
  parameter NUMVROW2 = 512;
  parameter BITVROW2 = 9;
  parameter NUMVBNK2 = 4;
  parameter BITVBNK2 = 2;
  parameter BITPBNK2 = 3;
  parameter FLOPIN2 = 0;
  parameter FLOPOUT2 = 0;
  parameter NUMWRDS2 = 4;      // ALIGN Parameters
  parameter BITWRDS2 = 2;
  parameter NUMSROW2 = 64;
  parameter BITSROW2 = 6;
  parameter PHYWDTH2 = NUMWRDS2*MEMWDTH;
  parameter REFRESH = 1;      // REFRESH Parameters 
  parameter NUMRBNK = 8;
  parameter BITRBNK = 3;
  parameter BITWSPF = 0;
  parameter REFLOPW = 0;
  parameter NUMRROW = 16;
  parameter BITRROW = 4;
  parameter REFFREQ = 16;
  parameter REFFRHF = 0;
  parameter NUMDWS0 = 72;     // DWSN Parameters
  parameter NUMDWS1 = 72;
  parameter NUMDWS2 = 72;
  parameter NUMDWS3 = 72;
  parameter NUMDWS4 = 72;
  parameter NUMDWS5 = 72;
  parameter NUMDWS6 = 72;
  parameter NUMDWS7 = 72;
  parameter NUMDWS8 = 72;
  parameter NUMDWS9 = 72;
  parameter NUMDWS10 = 72;
  parameter NUMDWS11 = 72;
  parameter NUMDWS12 = 72;
  parameter NUMDWS13 = 72;
  parameter NUMDWS14 = 72;
  parameter NUMDWS15 = 72;
  parameter BITDWSN = 8;
  parameter SRAM_DELAY = 2;
  parameter FLOPCMD = 0;
  parameter FLOPECC = 0;
  parameter FLOPMEM = 0;

  parameter BITPADR2 = BITPBNK2+BITSROW2+BITWRDS2;
  parameter BITPADR1 = BITPBNK1+BITPADR2+1;

  input                                refr;

  input [5-1:0]                       write;
  input [5*BITADDR-1:0]               wr_adr;
  input [5*WIDTH-1:0]                 din;

  input [10-1:0]                        read;
  input [10*BITADDR-1:0]                rd_adr;
  output [10-1:0]                       rd_vld;
  output [10*WIDTH-1:0]                 rd_dout;
  output [10-1:0]                       rd_serr;
  output [10-1:0]                       rd_derr;
  output [10*BITPADR1-1:0]              rd_padr;
  input 				algo_sel;
   
  output                               ready;
  input                                clk, rst;

  output [NUMVBNK1*NUMVBNK2-1:0] t1_readA;
  output [NUMVBNK1*NUMVBNK2-1:0] t1_writeA;
  output [NUMVBNK1*NUMVBNK2*BITSROW2-1:0] t1_addrA;
  output [NUMVBNK1*NUMVBNK2*BITDWSN-1:0] t1_dwsnA;
  output [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_bwA;
  output [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_dinA;
  input [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_doutA;
  input [NUMVBNK1*NUMVBNK2-1:0] t1_serrA;
  output [NUMVBNK1*NUMVBNK2-1:0] t1_refrB;
  output [NUMVBNK1*NUMVBNK2*BITRBNK-1:0] t1_bankB;

  output [NUMVBNK1-1:0] t2_readA;
  output [NUMVBNK1-1:0] t2_writeA;
  output [NUMVBNK1*BITSROW2-1:0] t2_addrA;
  output [NUMVBNK1*BITDWSN-1:0] t2_dwsnA;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_bwA;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_dinA;
  input [NUMVBNK1*PHYWDTH2-1:0] t2_doutA;
  input [NUMVBNK1-1:0] t2_serrA;
  output [NUMVBNK1-1:0] t2_refrB;
  output [NUMVBNK1*BITRBNK-1:0] t2_bankB;

  output [NUMVBNK2-1:0] t3_readA;
  output [NUMVBNK2-1:0] t3_writeA;
  output [NUMVBNK2*BITSROW2-1:0] t3_addrA;
  output [NUMVBNK2*BITDWSN-1:0] t3_dwsnA;
  output [NUMVBNK2*PHYWDTH2-1:0] t3_bwA;
  output [NUMVBNK2*PHYWDTH2-1:0] t3_dinA;
  input [NUMVBNK2*PHYWDTH2-1:0] t3_doutA;
  input [NUMVBNK2-1:0] t3_serrA;
  output [NUMVBNK2-1:0] t3_refrB;
  output [NUMVBNK2*BITRBNK-1:0] t3_bankB;

  output [1-1:0] t4_readA;
  output [1-1:0] t4_writeA;
  output [1*BITSROW2-1:0] t4_addrA;
  output [1*BITDWSN-1:0] t4_dwsnA;
  output [1*PHYWDTH2-1:0] t4_bwA;
  output [1*PHYWDTH2-1:0] t4_dinA;
  input [1*PHYWDTH2-1:0] t4_doutA;
  input [1-1:0] t4_serrA;
  output [1-1:0] t4_refrB;
  output [1*BITRBNK-1:0] t4_bankB;

  input [BITADDR-1:0] 	 select_addr;
  input [BITWDTH-1:0] 	 select_bit; 


  //2Ror1W
   //output [NUMVBNK1*NUMVBNK2-1:0] t1_readA_a2_out ;
   //output [NUMVBNK1*NUMVBNK2-1:0] t1_writeA_a2_out ;
   //output [NUMVBNK1*NUMVBNK2*BITVROW2-1:0] t1_addrA_a2_out ;
   //output [NUMVBNK1*NUMVBNK2*WIDTH-1:0] 	  t1_dinA_a2_out ;
   //output [NUMVBNK1*NUMVBNK2-1:0] 	  t1_refrB_a2_out ;
   //input [NUMVBNK1*NUMVBNK2*WIDTH-1:0] 	  t1_doutA_a2_in ;
   //input [NUMVBNK1*NUMVBNK2-1:0] 	  t1_fwrdA_a2_in ;
   //input [NUMVBNK1*NUMVBNK2-1:0] 	  t1_serrA_a2_in ;
   //input [NUMVBNK1*NUMVBNK2-1:0] 	  t1_derrA_a2_in ;
   //input [NUMVBNK1*NUMVBNK2*(BITSROW2+BITWRDS2)-1:0] t1_padrA_a2_in ;
   
   /*output [NUMVBNK1-1:0] 			    t2_readA_a2_out ;
   output [NUMVBNK1-1:0] 			    t2_writeA_a2_out ;
   output [NUMVBNK1*BITVROW2-1:0] 		    t2_addrA_a2_out ;
   output [NUMVBNK1*WIDTH-1:0] 			    t2_dinA_a2_out ;
   output [NUMVBNK1-1:0] 			    t2_refrB_a2_out ;
   input [NUMVBNK1*WIDTH-1:0] 			    t2_doutA_a2_in ;
   input [NUMVBNK1-1:0] 			    t2_fwrdA_a2_in ;
   input [NUMVBNK1-1:0] 			    t2_serrA_a2_in ;
   input [NUMVBNK1-1:0] 			    t2_derrA_a2_in ;
   input [NUMVBNK1*(BITSROW2+BITWRDS2)-1:0] 	    t2_padrA_a2_in ;*/


   
   
   
`ifdef FORMAL_4ROR1W
   
   wire [BITRBNK-1:0] 	 select_rbnk;
   wire [BITRROW-1:0] 	 select_rrow;

   assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
   assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
   assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
   assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

   assume_select_algo_sel: assume property (@(posedge clk) disable iff (rst) (algo_sel == 0));
   assume_select_rd_wr: assume property (@(posedge clk) disable iff (rst) ((write[4:1] == 0) & (read[9:4] == 0)));
   assume_select_rd_wr_conflict: assume property (@(posedge clk) disable iff (rst) (write[0] |->  (read[3:0] == 0)));
   assume_select_wr_rd_conflict: assume property (@(posedge clk) disable iff (rst) (|read[3:0] |->  (write[0] == 0)));
   assume_select_wr_start: assume property (@(posedge clk) disable iff (rst) (!readyA1 |->  (write[4:0] == 0)));
 

   reg 		   fakemem;
   reg             fakemem_inv;
   always @(posedge clk)
     if (rst)
       fakemem_inv <= 1'b1;
     else if (write[0] && (wr_adr[BITADDR-1:0] == select_addr)) begin
        fakemem <= din[select_bit];
        fakemem_inv <= 1'b0;
     end

   wire [WIDTH-1:0] rd_dout_0 = rd_dout [WIDTH-1:0];
   wire [WIDTH-1:0] rd_dout_1 = rd_dout [2*WIDTH-1:WIDTH];
   wire [WIDTH-1:0] rd_dout_2 = rd_dout [3*WIDTH-1:2*WIDTH];
   wire [WIDTH-1:0] rd_dout_3 = rd_dout [4*WIDTH-1:3*WIDTH];
   

   assert_dout0_check: assert property (@(posedge clk) disable iff (rst || !readyA1) (read[0] && (rd_adr[BITADDR-1:0] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rd_vld[0] & (rd_dout_0[select_bit] == $past(fakemem,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));
   assert_dout1_check: assert property (@(posedge clk) disable iff (rst || !readyA1) (read[1] && (rd_adr[2*BITADDR-1:BITADDR] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rd_vld[1] & (rd_dout_1[select_bit] == $past(fakemem,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));
   assert_dout2_check: assert property (@(posedge clk) disable iff (rst || !readyA1) (read[2] && (rd_adr[3*BITADDR-1:2*BITADDR] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rd_vld[2] & (rd_dout_2[select_bit] == $past(fakemem,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));
   assert_dout3_check: assert property (@(posedge clk) disable iff (rst || !readyA1) (read[3] && (rd_adr[4*BITADDR-1:3*BITADDR] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rd_vld[3] & (rd_dout_3[select_bit] == $past(fakemem,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));


   wire [BITVROW1-1:0] select_addr_a2;
   np2_addr #(
	      .NUMADDR (NUMADDR), .BITADDR (BITADDR),
	      .NUMVBNK (NUMVBNK1), .BITVBNK (BITVBNK1),
	      .NUMVROW (NUMVROW1), .BITVROW (BITVROW1))
   adr_a2 (.vbadr(), .vradr(select_addr_a2), .vaddr(select_addr));
   
   wire [BITVROW2-1:0] select_vrow_a2;
   np2_addr #(
	      .NUMADDR (NUMVROW1), .BITADDR (BITVROW1),
	      .NUMVBNK (NUMVBNK2), .BITVBNK (BITVBNK2),
	      .NUMVROW (NUMVROW2), .BITVROW (BITVROW2))
   row_a2 (.vbadr(), .vradr(select_vrow_a2), .vaddr(select_addr_a2));
   
   `elsif FORMAL_10ROR5W

   wire [BITRBNK-1:0]  select_rbnk;
   wire [BITRROW-1:0]  select_rrow;
   assume_select_algo_sel: assume property (@(posedge clk) disable iff (rst) (algo_sel == 1));
   assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMVROW1));
   assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
   assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
   assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));
      
   assume_select_rd_wr_conflict_0: assume property (@(posedge clk) disable iff (rst) (write[0] |->  (!read[1] & !read[0])));
   assume_select_rd_wr_conflict_1: assume property (@(posedge clk) disable iff (rst) (write[1] |->  (!read[3] & !read[2])));
   assume_select_rd_wr_conflict_2: assume property (@(posedge clk) disable iff (rst) (write[2] |->  (!read[5] & !read[4])));
   assume_select_rd_wr_conflict_3: assume property (@(posedge clk) disable iff (rst) (write[3] |->  (!read[7] & !read[6])));
   assume_select_rd_wr_conflict_4: assume property (@(posedge clk) disable iff (rst) (write[4] |->  (!read[9] & !read[8])));
      
   assume_select_wr_rd_conflict_0: assume property (@(posedge clk) disable iff (rst) (|read[1:0] |->  (write[0] == 0)));
   assume_select_wr_rd_conflict_1: assume property (@(posedge clk) disable iff (rst) (|read[3:2] |->  (write[1] == 0)));
   assume_select_wr_rd_conflict_2: assume property (@(posedge clk) disable iff (rst) (|read[5:4] |->  (write[2] == 0)));
   assume_select_wr_rd_conflict_3: assume property (@(posedge clk) disable iff (rst) (|read[7:6] |->  (write[3] == 0)));
   assume_select_wr_rd_conflict_4: assume property (@(posedge clk) disable iff (rst) (|read[9:8] |->  (write[4] == 0)));
   assume_select_wr_start: assume property (@(posedge clk) disable iff (rst) (!readyA1 |->  (write[4:0] == 0)));

   reg 		   fakemem_0;
   reg 		   fakemem_1;
   reg 		   fakemem_2;
   reg 		   fakemem_3;
   reg 		   fakemem_4;
   reg             fakemem_inv_0;
   reg             fakemem_inv_1;
   reg             fakemem_inv_2;
   reg             fakemem_inv_3;
   reg             fakemem_inv_4;

   wire [WIDTH-1:0] din_0 = din [WIDTH-1:0];
   wire [WIDTH-1:0] din_1 = din [2*WIDTH-1:WIDTH];
   wire [WIDTH-1:0] din_2 = din [3*WIDTH-1:2*WIDTH];
   wire [WIDTH-1:0] din_3 = din [4*WIDTH-1:3*WIDTH];
   wire [WIDTH-1:0] din_4 = din [5*WIDTH-1:4*WIDTH];
   
   
   always @(posedge clk)
     if (rst)
       begin
	  fakemem_inv_0 <= 1'b1;
	  fakemem_inv_1 <= 1'b1;
	  fakemem_inv_2 <= 1'b1;
	  fakemem_inv_3 <= 1'b1;
	  fakemem_inv_4 <= 1'b1;
       end
     else begin
	if (write[0] && (wr_adr[BITVROW1-1:0] == select_addr)) begin
           fakemem_0 <= din_0[select_bit];
           fakemem_inv_0 <= 1'b0;
	end
	if (write[1] && (wr_adr[BITADDR+BITVROW1-1:BITADDR] == select_addr)) begin
           fakemem_1 <= din_1[select_bit];
           fakemem_inv_1 <= 1'b0;
	end
	if (write[2] && (wr_adr[2*BITADDR+BITVROW1-1:2*BITADDR] == select_addr)) begin
           fakemem_2 <= din_2[select_bit];
           fakemem_inv_2 <= 1'b0;
	end
	if (write[3] && (wr_adr[3*BITADDR+BITVROW1-1:3*BITADDR] == select_addr)) begin
           fakemem_3 <= din_3[select_bit];
           fakemem_inv_3 <= 1'b0;
	end
	if (write[4] && (wr_adr[4*BITADDR+BITVROW1-1:4*BITADDR] == select_addr)) begin
           fakemem_4 <= din_4[select_bit];
           fakemem_inv_4 <= 1'b0;
	end
     end // else: !if(rst)
   
   wire [WIDTH-1:0] rd_dout_0 = rd_dout [WIDTH-1:0];
   wire [WIDTH-1:0] rd_dout_1 = rd_dout [2*WIDTH-1:WIDTH];
   wire [WIDTH-1:0] rd_dout_2 = rd_dout [3*WIDTH-1:2*WIDTH];
   wire [WIDTH-1:0] rd_dout_3 = rd_dout [4*WIDTH-1:3*WIDTH];
   wire [WIDTH-1:0] rd_dout_4 = rd_dout [5*WIDTH-1:4*WIDTH];
   
   wire [WIDTH-1:0] rd_dout_5 = rd_dout [6*WIDTH-1:5*WIDTH];
   wire [WIDTH-1:0] rd_dout_6 = rd_dout [7*WIDTH-1:6*WIDTH];
   wire [WIDTH-1:0] rd_dout_7 = rd_dout [8*WIDTH-1:7*WIDTH];
   wire [WIDTH-1:0] rd_dout_8 = rd_dout [9*WIDTH-1:8*WIDTH];
   wire [WIDTH-1:0] rd_dout_9 = rd_dout [10*WIDTH-1:9*WIDTH];
   
   
   assert_dout0_check: assert property (@(posedge clk) disable iff (rst) (read[0] && (rd_adr[BITVROW1-1:0] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv_0,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rd_vld[0] & (rd_dout_0[select_bit] == $past(fakemem_0,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));
   assert_dout1_check: assert property (@(posedge clk) disable iff (rst) (read[1] && (rd_adr[BITADDR+BITVROW1-1:BITADDR] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv_0,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rd_vld[1] & (rd_dout_1[select_bit] == $past(fakemem_0,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));
   assert_dout2_check: assert property (@(posedge clk) disable iff (rst) (read[2] && (rd_adr[2*BITADDR+BITVROW1-1:2*BITADDR] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv_1,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rd_vld[2] & (rd_dout_2[select_bit] == $past(fakemem_1,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));
   assert_dout3_check: assert property (@(posedge clk) disable iff (rst) (read[3] && (rd_adr[3*BITADDR+BITVROW1-1:3*BITADDR] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv_1,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rd_vld[3] & (rd_dout_3[select_bit] == $past(fakemem_1,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));
   assert_dout4_check: assert property (@(posedge clk) disable iff (rst) (read[4] && (rd_adr[4*BITADDR+BITVROW1-1:4*BITADDR] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv_2,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rd_vld[4] & (rd_dout_4[select_bit] == $past(fakemem_2,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));
   assert_dout5_check: assert property (@(posedge clk) disable iff (rst) (read[5] && (rd_adr[5*BITADDR+BITVROW1-1:5*BITADDR] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv_2,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rd_vld[5] & (rd_dout_5[select_bit] == $past(fakemem_2,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));
   assert_dout6_check: assert property (@(posedge clk) disable iff (rst) (read[6] && (rd_adr[6*BITADDR+BITVROW1-1:6*BITADDR] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv_3,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rd_vld[6] & (rd_dout_6[select_bit] == $past(fakemem_3,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));
   assert_dout7_check: assert property (@(posedge clk) disable iff (rst) (read[7] && (rd_adr[7*BITADDR+BITVROW1-1:7*BITADDR] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv_3,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rd_vld[7] & (rd_dout_7[select_bit] == $past(fakemem_3,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));
   assert_dout8_check: assert property (@(posedge clk) disable iff (rst) (read[8] && (rd_adr[8*BITADDR+BITVROW1-1:8*BITADDR] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv_4,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rd_vld[8] & (rd_dout_8[select_bit] == $past(fakemem_4,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));
   assert_dout9_check: assert property (@(posedge clk) disable iff (rst) (read[9] && (rd_adr[9*BITADDR+BITVROW1-1:9*BITADDR] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv_4,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rd_vld[9] & (rd_dout_9[select_bit] == $past(fakemem_4,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));
   
wire [BITVROW1-1:0] select_addr_a2;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK1), .BITVBNK (BITVBNK1),
  .NUMVROW (NUMVROW1), .BITVROW (BITVROW1))
  adr_a2 (.vbadr(), .vradr(select_addr_a2), .vaddr(select_addr));

wire [BITVROW2-1:0] select_vrow_a2;
np2_addr #(
  .NUMADDR (NUMVROW1), .BITADDR (BITVROW1),
  .NUMVBNK (NUMVBNK2), .BITVBNK (BITVBNK2),
  .NUMVROW (NUMVROW2), .BITVROW (BITVROW2))
  row_a2 (.vbadr(), .vradr(select_vrow_a2), .vaddr(select_addr_a2));
`else
wire [BITADDR-1:0] select_addr = 0;
wire [BITWDTH-1:0] select_bit = 0;
wire [BITVROW1-1:0] select_addr_a2 = 0;
wire [BITVROW2-1:0] select_vrow_a2 = 0;
wire [BITRBNK-1:0] select_rbnk = 0;
wire [BITRROW-1:0] select_rrow = 0;
`endif

wire [2*NUMVBNK1-1:0] t1_readA_a1;
wire [2*NUMVBNK1-1:0] t1_writeA_a1;
wire [2*NUMVBNK1*BITVROW1-1:0] t1_addrA_a1;
wire [2*NUMVBNK1*WIDTH-1:0] t1_dinA_a1;
wire [2*NUMVBNK1-1:0] t1_refrB_a1;
reg [2*NUMVBNK1*WIDTH-1:0] t1_doutA_a1;
reg [2*NUMVBNK1-1:0] t1_fwrdA_a1;
reg [2*NUMVBNK1-1:0] t1_serrA_a1;
reg [2*NUMVBNK1-1:0] t1_derrA_a1;
reg [2*NUMVBNK1*BITPADR2-1:0] t1_padrA_a1;

wire [2-1:0] t3_readA_a1;
wire [2-1:0] t3_writeA_a1;
wire [2*BITVROW1-1:0] t3_addrA_a1;
wire [2*WIDTH-1:0] t3_dinA_a1;
wire [2-1:0] t3_refrB_a1;
wire [2*WIDTH-1:0] t3_doutA_a1;
wire [2-1:0] t3_fwrdA_a1;
wire [2-1:0] t3_serrA_a1;
wire [2-1:0] t3_derrA_a1;
wire [2*BITPADR2-1:0] t3_padrA_a1;

wire [NUMVBNK1-1:0] t1_a2_ready;
wire t3_a3_ready;
wire readyA1;
assign ready = !algo_sel? readyA1 : (&t1_a2_ready & &t3_a3_ready);
   
   
//4Ror1W
 wire 				write_a1 = write[0];
 wire [BITADDR-1:0] 		wr_adr_a1 = wr_adr[BITADDR-1:0];
 wire [WIDTH-1:0] 		din_a1 = din[WIDTH-1:0];

 wire [4-1:0] 		        read_a1 = read[4-1:0];
 wire [4*BITADDR-1:0]           rd_adr_a1 = rd_adr[4*BITADDR-1:0];
 wire [4-1:0]                       rd_vld_a1;
 wire [4*WIDTH-1:0]                 rd_dout_a1;
 wire [4-1:0]                       rd_serr_a1;
 wire [4-1:0]                       rd_derr_a1;
 wire [4*BITPADR1-1:0]              rd_padr_a1;

  

generate if (1) begin: a1_loop

  algo_nror1w #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .NUMADDR (NUMADDR), .BITADDR (BITADDR), .NUMVRPT (4), .NUMPRPT (2),
                .NUMVROW (NUMVROW1), .BITVROW (BITVROW1), .NUMVBNK (NUMVBNK1), .BITVBNK (BITVBNK1), .BITPBNK (BITPBNK1), .BITPADR (BITPADR1-1),
                .REFRESH (REFRESH), .REFFREQ (REFFREQ), .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPECC+FLOPMEM+FLOPIN2+FLOPOUT2), .FLOPIN (FLOPIN1), .FLOPOUT (FLOPOUT1))
    algo (.refr (refr), .clk (clk), .rst (rst || !(&t1_a2_ready) || !t3_a3_ready), .ready (readyA1),
          .write (write_a1), .wr_adr (wr_adr_a1), .din (din_a1),
	  .read (read_a1), .rd_adr (rd_adr_a1), .rd_vld (rd_vld_a1), .rd_dout (rd_dout_a1),
	  .rd_fwrd ({rd_padr_a1[4*BITPADR1-1],rd_padr_a1[3*BITPADR1-1],rd_padr_a1[2*BITPADR1-1],rd_padr_a1[BITPADR1-1]}), .rd_serr (rd_serr_a1), .rd_derr (rd_derr_a1),
          .rd_padr ({rd_padr_a1[4*BITPADR1-2:3*BITPADR1],rd_padr_a1[3*BITPADR1-2:2*BITPADR1],rd_padr_a1[2*BITPADR1-2:BITPADR1],rd_padr_a1[BITPADR1-2:0]}),
          .t1_readA (t1_readA_a1), .t1_writeA (t1_writeA_a1), .t1_addrA (t1_addrA_a1), .t1_dinA (t1_dinA_a1), .t1_doutA (t1_doutA_a1),
	  .t1_fwrdA (t1_fwrdA_a1), .t1_serrA (t1_serrA_a1), .t1_derrA (t1_derrA_a1), .t1_padrA (t1_padrA_a1), .t1_refrB (t1_refrB_a1),
          .t2_readA (t3_readA_a1), .t2_writeA (t3_writeA_a1), .t2_addrA (t3_addrA_a1), .t2_dinA (t3_dinA_a1), .t2_doutA (t3_doutA_a1),
	  .t2_fwrdA (t3_fwrdA_a1), .t2_serrA (t3_serrA_a1), .t2_derrA (t3_derrA_a1), .t2_padrA (t3_padrA_a1), .t2_refrB (t3_refrB_a1),
	  .select_addr (select_addr), .select_bit (select_bit));

end
endgenerate

reg [2-1:0] t1_readA_a1_wire [0:NUMVBNK1-1];
reg t1_writeA_a1_wire [0:NUMVBNK1-1];
reg [2*BITVROW1-1:0] t1_radrA_a1_wire [0:NUMVBNK1-1];
reg [BITVROW1-1:0] t1_wadrA_a1_wire [0:NUMVBNK1-1];
reg [WIDTH-1:0] t1_dinA_a1_wire [0:NUMVBNK1-1];
reg t1_refrB_a1_wire [0:NUMVBNK1-1];
wire [2*WIDTH-1:0] t1_doutA_a1_wire [0:NUMVBNK1-1];
wire [2-1:0] t1_fwrdA_a1_wire [0:NUMVBNK1-1];
wire [2-1:0] t1_serrA_a1_wire [0:NUMVBNK1-1];
wire [2-1:0] t1_derrA_a1_wire [0:NUMVBNK1-1];
wire [2*BITPADR2-1:0] t1_padrA_a1_wire [0:NUMVBNK1-1];
integer a1_wire_int;
always_comb begin
  t1_doutA_a1 = 0;
  t1_fwrdA_a1 = 0;
  t1_serrA_a1 = 0;
  t1_derrA_a1 = 0;
  t1_padrA_a1 = 0;
  for (a1_wire_int=0; a1_wire_int<NUMVBNK1; a1_wire_int=a1_wire_int+1) begin
    t1_readA_a1_wire[a1_wire_int] = t1_readA_a1 >> (a1_wire_int*2);
    t1_writeA_a1_wire[a1_wire_int] = t1_writeA_a1 >> (a1_wire_int*2);
    t1_radrA_a1_wire[a1_wire_int] = t1_addrA_a1 >> (a1_wire_int*2*BITVROW1);
    t1_wadrA_a1_wire[a1_wire_int] = t1_addrA_a1 >> (a1_wire_int*BITVROW1);
    t1_dinA_a1_wire[a1_wire_int] = t1_dinA_a1 >> (a1_wire_int*2*WIDTH);
    t1_refrB_a1_wire[a1_wire_int] = t1_refrB_a1 >> (a1_wire_int*2);
    t1_doutA_a1 = t1_doutA_a1 | (t1_doutA_a1_wire[a1_wire_int] << (a1_wire_int*2*WIDTH));
    t1_fwrdA_a1 = t1_fwrdA_a1 | (t1_fwrdA_a1_wire[a1_wire_int] << a1_wire_int*2);
    t1_serrA_a1 = t1_serrA_a1 | (t1_serrA_a1_wire[a1_wire_int] << a1_wire_int*2);
    t1_derrA_a1 = t1_derrA_a1 | (t1_derrA_a1_wire[a1_wire_int] << a1_wire_int*2);
    t1_padrA_a1 = t1_padrA_a1 | (t1_padrA_a1_wire[a1_wire_int] << (a1_wire_int*2*BITPADR2));
  end
end

wire [NUMVBNK2-1:0] t1_readA_a2 [0:NUMVBNK1-1];
wire [NUMVBNK2-1:0] t1_writeA_a2 [0:NUMVBNK1-1];
wire [NUMVBNK2*BITVROW2-1:0] t1_addrA_a2 [0:NUMVBNK1-1];
wire [NUMVBNK2*WIDTH-1:0] t1_dinA_a2 [0:NUMVBNK1-1];
wire [NUMVBNK2-1:0] t1_refrB_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2*WIDTH-1:0] t1_doutA_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2-1:0] t1_fwrdA_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2-1:0] t1_serrA_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2-1:0] t1_derrA_a2 [0:NUMVBNK1-1];
reg [NUMVBNK2*(BITSROW2+BITWRDS2)-1:0] t1_padrA_a2 [0:NUMVBNK1-1];

wire [NUMVBNK1-1:0] t2_readA_a2 ;
wire [NUMVBNK1-1:0] t2_writeA_a2 ;
wire [1*BITVROW2-1:0] t2_addrA_a2 [0:NUMVBNK1-1];
wire [1*WIDTH-1:0] t2_dinA_a2 [0:NUMVBNK1-1];
wire [NUMVBNK1-1:0] t2_refrB_a2 ;
reg [1*WIDTH-1:0] t2_doutA_a2 [0:NUMVBNK1-1];
reg [NUMVBNK1-1:0] t2_fwrdA_a2 ;
reg [NUMVBNK1-1:0] t2_serrA_a2 ;
reg [NUMVBNK1-1:0] t2_derrA_a2 ;
reg [1*(BITSROW2+BITWRDS2)-1:0] t2_padrA_a2 [0:NUMVBNK1-1];

//2Ror1W

   wire 			    write_a2 [0:NUMVBNK1-1];
   wire [2-1:0] 		    read_a2 [0:NUMVBNK1-1];  
   wire [2*BITVROW1-1:0] 	    rd_adr_a2[0:NUMVBNK1-1];
   wire [BITVROW1-1:0] 		    wr_adr_a2[0:NUMVBNK1-1];
   wire [WIDTH-1:0] 		    din_a2 [0:NUMVBNK1-1];
   wire [2*WIDTH-1:0] 		    rd_dout_a2 [0:NUMVBNK1-1];
   wire [2-1:0] 		    rd_fwrd_a2 [0:NUMVBNK1-1];
   wire [2-1:0] 		    rd_serr_a2 [0:NUMVBNK1-1];
   wire [2-1:0] 		    rd_derr_a2 [0:NUMVBNK1-1];
   wire [2*BITPADR2-1:0] 	    rd_padr_a2 [0:NUMVBNK1-1];
   wire [2-1:0] 		    rd_vld_a2 [0:NUMVBNK1-1];
   wire 			    refr_a2[0:NUMVBNK1-1] ;

   wire 			    write_a3 ;
   wire [2-1:0] 		    read_a3 ;  
   wire [2*BITVROW1-1:0] 	    rd_adr_a3;
   wire [BITVROW1-1:0] 		    wr_adr_a3;
   wire [WIDTH-1:0] 		    din_a3 ;
   wire [2*WIDTH-1:0] 		    rd_dout_a3 ;
   wire [2-1:0] 		    rd_fwrd_a3 ;
   wire [2-1:0] 		    rd_serr_a3 ;
   wire [2-1:0] 		    rd_derr_a3 ;
   wire [2*BITPADR2-1:0] 	    rd_padr_a3 ;
   wire [2-1:0] 		    rd_vld_a3 ;
   wire 			    refr_a3 ;

  
   reg [2*WIDTH-1:0] 	    rd_dout_a2_reg [0:NUMVBNK1-1];
   reg [2-1:0] 		    rd_serr_a2_reg [0:NUMVBNK1-1];
   reg [2-1:0] 		    rd_derr_a2_reg [0:NUMVBNK1-1];
   reg [2*BITPADR2-1:0]     rd_padr_a2_reg [0:NUMVBNK1-1];
   reg [2-1:0] 		    rd_vld_a2_reg [0:NUMVBNK1-1];
   //reg 			    refr_a2_reg [0:NUMVBNK1-1];

   reg [2*WIDTH-1:0] 	    rd_dout_a3_reg ;
   reg [2-1:0] 		    rd_serr_a3_reg ;
   reg [2-1:0] 		    rd_derr_a3_reg ;
   reg [2*BITPADR2-1:0]     rd_padr_a3_reg ;
   reg [2-1:0] 		    rd_vld_a3_reg ;
   //reg 			    refr_a3_reg ;

   reg [5-1:0] 		    write_reg;
   reg [5*BITADDR-1:0] 	    wr_adr_reg;
   reg [5*WIDTH-1:0] 	    din_reg;
   
   reg [10-1:0] 	    read_reg;
   reg [10*BITADDR-1:0]     rd_adr_reg;
   reg 			    refr_reg;
   //reg 			    algo_sel_reg;
      
   always @ (posedge clk)
     begin
	write_reg <= write;
	wr_adr_reg <= wr_adr;
	din_reg <= din;
	read_reg <= read;
	rd_adr_reg <= rd_adr;
	refr_reg <= refr;
	//algo_sel_reg <= algo_sel;
		
	rd_dout_a2_reg <= rd_dout_a2;
	rd_serr_a2_reg <= rd_serr_a2;
	rd_derr_a2_reg <= rd_derr_a2;
	rd_padr_a2_reg <= rd_padr_a2;
	rd_vld_a2_reg <= rd_vld_a2;
	//refr_a2_reg <= refr_a2;
     
	rd_dout_a3_reg <= rd_dout_a3;
	rd_serr_a3_reg <= rd_serr_a3;
	rd_derr_a3_reg <= rd_derr_a3;
	rd_padr_a3_reg <= rd_padr_a3;
	rd_vld_a3_reg <= rd_vld_a3;
	//refr_a3_reg <= refr_a3;
     end // always @ (posedge clk)
   
   genvar i;
 
   generate for (i=0; i<=NUMVBNK1; i=i+1) begin

      if(i==0) begin
	 assign rd_dout[2*WIDTH-1:0] = algo_sel? rd_dout_a2_reg[i] : rd_dout_a1[2*WIDTH-1:0];
	 assign rd_vld[2-1:0] = algo_sel? rd_vld_a2_reg[i] : rd_vld_a1[2-1:0];
	 //assign rd_fwrd [2-1:0] = algo_sel? rd_fwrd_a2[i] : rd_fwrd_a1[2-1:0];
	 assign rd_serr [2-1:0] = algo_sel? rd_serr_a2_reg[i] : rd_serr_a1[2-1:0];
	 assign rd_derr [2-1:0] = algo_sel? rd_derr_a2_reg[i] : rd_derr_a1[2-1:0];
	 assign rd_padr [2*BITPADR1-1:0] = algo_sel? rd_padr_a2_reg[i] : rd_padr_a1[2*BITPADR1-1:0];
      end
	 
      else if(i==1) begin
	assign rd_dout[4*WIDTH-1:2*WIDTH] = algo_sel? rd_dout_a2_reg[i] : rd_dout_a1[4*WIDTH-1:2*WIDTH];
	 assign rd_vld[4-1:2] = algo_sel? rd_vld_a2_reg[i] : rd_vld_a1[4-1:2];
	 //assign rd_fwrd [4-1:2] = algo_sel? rd_fwrd_a2[i] : rd_fwrd_a1[2-1:0];
	 assign rd_serr [4-1:2] = algo_sel? rd_serr_a2_reg[i] : rd_serr_a1[4-1:2];
	 assign rd_derr [4-1:2] = algo_sel? rd_derr_a2_reg[i] : rd_derr_a1[4-1:2];
	 assign rd_padr [4*BITPADR1-1:2*BITPADR1] = algo_sel? rd_padr_a2_reg[i] : rd_padr_a1[4*BITPADR1-1:2*BITPADR1];
      end

      else if(i==NUMVBNK1) begin
	 assign rd_dout [(i*2+2)*WIDTH-1:i*2*WIDTH] = algo_sel? rd_dout_a3_reg : 0;
	 assign rd_vld [i*2+2-1:i*2] = algo_sel? rd_vld_a3_reg : 0;
	 assign rd_serr [i*2+2-1:i*2] = algo_sel? rd_serr_a3_reg : 0;
	 assign rd_derr [i*2+2-1:i*2] = algo_sel? rd_derr_a3_reg : 0;
	 assign rd_padr [(i*2+2)*BITPADR1-1:i*2*BITPADR1] = algo_sel? rd_padr_a3_reg : 0;
      end
	 
      else begin
	 assign rd_dout [(i*2+2)*WIDTH-1:i*2*WIDTH] = algo_sel? rd_dout_a2_reg[i] : 0;
	 assign rd_vld [i*2+2-1:i*2] = algo_sel? rd_vld_a2_reg[i] : 0;
	 //assign rd_fwrd [i*2+2-1:i*2] = algo_sel? rd_fwrd_a2[i] : 0;
	 assign rd_serr [i*2+2-1:i*2] = algo_sel? rd_serr_a2_reg[i] : 0;
	 assign rd_derr [i*2+2-1:i*2] = algo_sel? rd_derr_a2_reg[i] : 0;
	 assign rd_padr [(i*2+2)*BITPADR1-1:i*2*BITPADR1] = algo_sel? rd_padr_a2_reg[i] : 0;
      end
      
      if(i != NUMVBNK1) begin	
	 assign write_a2[i] = algo_sel? write_reg[i] : t1_writeA_a1_wire[i];
	 assign read_a2[i] = algo_sel? read_reg[2*(i+1)-1:2*i] : t1_readA_a1_wire[i];
	 assign rd_adr_a2[i] = algo_sel? {rd_adr_reg[(i*2+1)*BITADDR+BITVROW1-1 : (i*2+1)*BITADDR], rd_adr_reg[i*2*BITADDR+BITVROW1-1 : i*2*BITADDR]} : 
                               /*rd_adr_reg[i*2*BITADDR+2*BITVROW1-1:i*2*BITADDR] : */t1_radrA_a1_wire[i];
	 assign wr_adr_a2[i] = algo_sel? wr_adr_reg[i*BITADDR+BITVROW1-1:i*BITADDR] : t1_wadrA_a1_wire[i];
	 assign din_a2[i] = algo_sel? din_reg[(i+1)*WIDTH-1:i*WIDTH] : t1_dinA_a1_wire[i];
	 assign refr_a2[i] = algo_sel? refr_reg : t1_refrB_a1_wire[i];
      end
   end
   endgenerate
	 
   assign  t1_doutA_a1_wire [0:NUMVBNK1-1] = rd_dout_a2;
   assign  t1_fwrdA_a1_wire [0:NUMVBNK1-1] = rd_fwrd_a2;
   assign  t1_serrA_a1_wire [0:NUMVBNK1-1] = rd_serr_a2;
   assign  t1_derrA_a1_wire [0:NUMVBNK1-1] = rd_derr_a2;
   assign  t1_padrA_a1_wire [0:NUMVBNK1-1] = rd_padr_a2;

//outputs
wire [NUMVBNK1-1:0] ready_a2;
assign t1_a2_ready = ready_a2;
   
   
genvar a2_int;
generate for (a2_int=0; a2_int<NUMVBNK1; a2_int=a2_int+1) begin: a2_loop

  algo_nror1w #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .NUMADDR (NUMVROW1), .BITADDR (BITVROW1), .NUMVRPT (2), .NUMPRPT (1),
                .NUMVROW (NUMVROW2), .BITVROW (BITVROW2), .NUMVBNK (NUMVBNK2), .BITVBNK (BITVBNK2), .BITPBNK (BITPBNK2), .BITPADR (BITPADR2),
                .REFRESH (REFRESH), .REFFREQ (REFFREQ), .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPECC+FLOPMEM), .FLOPIN (FLOPIN2), .FLOPOUT (FLOPOUT2))
    algo (.refr (refr_a2[a2_int]), .clk (clk), .rst (rst), .ready (ready_a2[a2_int]),
          .write (write_a2[a2_int]), .wr_adr (wr_adr_a2[a2_int]), .din (din_a2[a2_int]),
	  .read (read_a2[a2_int]), .rd_adr (rd_adr_a2[a2_int]), .rd_vld (rd_vld_a2[a2_int]), .rd_dout (rd_dout_a2[a2_int]),
	  .rd_fwrd (rd_fwrd_a2[a2_int]), .rd_serr (rd_serr_a2[a2_int]), .rd_derr (rd_derr_a2[a2_int]), .rd_padr (rd_padr_a2[a2_int]),
          .t1_readA (t1_readA_a2[a2_int]), .t1_writeA (t1_writeA_a2[a2_int]), .t1_addrA (t1_addrA_a2[a2_int]), .t1_dinA (t1_dinA_a2[a2_int]), .t1_doutA (t1_doutA_a2[a2_int]),
	  .t1_fwrdA (t1_fwrdA_a2[a2_int]), .t1_serrA (t1_serrA_a2[a2_int]), .t1_derrA (t1_derrA_a2[a2_int]), .t1_padrA (t1_padrA_a2[a2_int]), .t1_refrB (t1_refrB_a2[a2_int]),
          .t2_readA (t2_readA_a2[a2_int]), .t2_writeA (t2_writeA_a2[a2_int]), .t2_addrA (t2_addrA_a2[a2_int]), .t2_dinA (t2_dinA_a2[a2_int]), .t2_doutA (t2_doutA_a2[a2_int]),
	  .t2_fwrdA (t2_fwrdA_a2[a2_int]), .t2_serrA (t2_serrA_a2[a2_int]), .t2_derrA (t2_derrA_a2[a2_int]), .t2_padrA (t2_padrA_a2[a2_int]), .t2_refrB (t2_refrB_a2[a2_int]),
	  .select_addr (select_addr_a2), .select_bit (select_bit));

end
endgenerate

wire [WIDTH-1:0] t1_doutA_a2_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire t1_fwrdA_a2_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire t1_serrA_a2_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire t1_derrA_a2_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire [BITSROW2+BITWRDS2-1:0] t1_padrA_a2_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire t1_readA_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire t1_writeA_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire [BITSROW2-1:0] t1_addrA_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire [BITDWSN-1:0] t1_dwsnA_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire [NUMWRDS2*MEMWDTH-1:0] t1_bwA_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire [NUMWRDS2*MEMWDTH-1:0] t1_dinA_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire t1_refrB_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];
wire [BITRBNK-1:0] t1_bankB_wire [0:NUMVBNK1-1][0:NUMVBNK2-1];

genvar t1r, t1b;
generate
  for (t1r=0; t1r<NUMVBNK1; t1r=t1r+1) begin: t1r_loop
    for (t1b=0; t1b<NUMVBNK2; t1b=t1b+1) begin: t1b_loop

      wire t1_readA_a2_wire = t1_readA_a2[t1r] >> t1b;
      wire t1_writeA_a2_wire = t1_writeA_a2[t1r] >> t1b;
      wire [BITVROW2-1:0] t1_addrA_a2_wire = t1_addrA_a2[t1r] >> (t1b*BITVROW2);
      wire [WIDTH-1:0] t1_dinA_a2_wire = t1_dinA_a2[t1r] >> (t1b*WIDTH);
      wire t1_refrB_a2_wire = t1_refrB_a2[t1r] >> t1b;

      wire [NUMWRDS2*MEMWDTH-1:0] t1_doutA_wire = t1_doutA >> ((t1r*NUMVBNK2+t1b)*PHYWDTH2);
      wire [NUMWRDS2-1:0] t1_serrA_wire = t1_serrA >> (t1r*NUMVBNK2+t1b);

      if (1) begin: align_loop
        infra_align_ecc_dwsn #(.WIDTH (WIDTH), .ENAEXT (ENAEXT), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH),
                               .NUMADDR (NUMVROW2), .BITADDR (BITVROW2),
                               .NUMSROW (NUMSROW2), .BITSROW (BITSROW2), .NUMWRDS (NUMWRDS2), .BITWRDS (BITWRDS2), .BITPADR (BITSROW2+BITWRDS2),
                               .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
                               .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
                               .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
                               .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15), .BITDWSN (BITDWSN),
                               .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (FLOPECC), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPECC), .RSTZERO (1))
          infra (.read (t1_readA_a2_wire), .write (t1_writeA_a2_wire), .addr (t1_addrA_a2_wire), .din (t1_dinA_a2_wire),
                 .rd_dout (t1_doutA_a2_wire[t1r][t1b]), .rd_fwrd (t1_fwrdA_a2_wire[t1r][t1b]),
                 .rd_serr (t1_serrA_a2_wire[t1r][t1b]), .rd_derr (t1_derrA_a2_wire[t1r][t1b]), .rd_padr (t1_padrA_a2_wire[t1r][t1b]),
                 .mem_read (t1_readA_wire[t1r][t1b]), .mem_write (t1_writeA_wire[t1r][t1b]), .mem_addr (t1_addrA_wire[t1r][t1b]),
                 .mem_dwsn (t1_dwsnA_wire[t1r][t1b]), .mem_bw (t1_bwA_wire[t1r][t1b]), .mem_din (t1_dinA_wire[t1r][t1b]),
                 .mem_dout (t1_doutA_wire), .mem_serr (t1_serrA_wire),
                 .select_addr (select_vrow_a2),
                 .clk (clk), .rst (rst));
      end

      wire [BITRBNK-1:0] t1_bankA_a2_wire = t1_addrA_wire[t1r][t1b] >> (BITSROW2-BITRBNK-BITWSPF);

      if (REFRESH==1) begin: refr_loop
        infra_refr_1stage #(.NUMRBNK (NUMRBNK), .BITRBNK (BITRBNK), .REFLOPW (REFLOPW),
                            .NUMRROW (NUMRROW), .BITRROW (BITRROW), .REFFREQ (REFFREQ), .REFFRHF (REFFRHF))
          infra (.clk (clk), .rst (rst),
                 .pref (t1_refrB_a2_wire), .pacc (t1_readA_a2_wire || t1_writeA_a2_wire), .pacbadr (t1_bankA_a2_wire),
                 .prefr (t1_refrB_wire[t1r][t1b]), .prfbadr (t1_bankB_wire[t1r][t1b]),
                 .select_rbnk (select_rbnk), .select_rrow (select_rrow));
      end else begin: no_refr_loop
        assign t1_refrB_wire[t1r][t1b] = 1'b0;
        assign t1_bankB_wire[t1r][t1b] = 0;
      end
    end
  end
endgenerate

reg [NUMVBNK1*NUMVBNK2-1:0] t1_readA;
reg [NUMVBNK1*NUMVBNK2-1:0] t1_writeA;
reg [NUMVBNK1*NUMVBNK2*BITSROW2-1:0] t1_addrA;
reg [NUMVBNK1*NUMVBNK2*BITDWSN-1:0] t1_dwsnA;
reg [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_bwA;
reg [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_dinA;
reg [NUMVBNK1*NUMVBNK2-1:0] t1_refrB;
reg [NUMVBNK1*NUMVBNK2*BITRBNK-1:0] t1_bankB;
integer t1r_int, t1b_int;
always_comb begin
  t1_readA = 0;
  t1_writeA = 0;
  t1_addrA = 0;
  t1_dwsnA = 0;
  t1_bwA = 0;
  t1_dinA = 0;
  t1_refrB = 0;
  t1_bankB = 0;
  for (t1r_int=0; t1r_int<NUMVBNK1; t1r_int=t1r_int+1) begin
    t1_doutA_a2[t1r_int] = 0;
    t1_fwrdA_a2[t1r_int] = 0;
    t1_serrA_a2[t1r_int] = 0;
    t1_derrA_a2[t1r_int] = 0;
    t1_padrA_a2[t1r_int] = 0;
    for (t1b_int=0; t1b_int<NUMVBNK2; t1b_int=t1b_int+1) begin
      t1_readA = t1_readA | (t1_readA_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK2+t1b_int));
      t1_writeA = t1_writeA | (t1_writeA_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK2+t1b_int));
      t1_addrA = t1_addrA | (t1_addrA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK2+t1b_int)*BITSROW2));
      t1_dwsnA = t1_dwsnA | (t1_dwsnA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK2+t1b_int)*BITDWSN));
      t1_bwA = t1_bwA | (t1_bwA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK2+t1b_int)*PHYWDTH2));
      t1_dinA = t1_dinA | (t1_dinA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK2+t1b_int)*PHYWDTH2));
      t1_refrB = t1_refrB | (t1_refrB_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK2+t1b_int));
      t1_bankB = t1_bankB | (t1_bankB_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK2+t1b_int)*BITRBNK));
      t1_doutA_a2[t1r_int] = t1_doutA_a2[t1r_int] | (t1_doutA_a2_wire[t1r_int][t1b_int] << (t1b_int*WIDTH));
      t1_fwrdA_a2[t1r_int] = t1_fwrdA_a2[t1r_int] | (t1_fwrdA_a2_wire[t1r_int][t1b_int] << t1b_int);
      t1_serrA_a2[t1r_int] = t1_serrA_a2[t1r_int] | (t1_serrA_a2_wire[t1r_int][t1b_int] << t1b_int);
      t1_derrA_a2[t1r_int] = t1_derrA_a2[t1r_int] | (t1_derrA_a2_wire[t1r_int][t1b_int] << t1b_int);
      t1_padrA_a2[t1r_int] = t1_padrA_a2[t1r_int] | (t1_padrA_a2_wire[t1r_int][t1b_int] << (t1b_int*(BITSROW2+BITWRDS2)));
    end
  end
end

wire [WIDTH-1:0] t2_doutA_a2_wire [0:NUMVBNK1-1][0:1-1];
wire t2_fwrdA_a2_wire [0:NUMVBNK1-1][0:1-1];
wire t2_serrA_a2_wire [0:NUMVBNK1-1][0:1-1];
wire t2_derrA_a2_wire [0:NUMVBNK1-1][0:1-1];
wire [BITSROW2+BITWRDS2-1:0] t2_padrA_a2_wire [0:NUMVBNK1-1][0:1-1];
wire t2_readA_wire [0:NUMVBNK1-1][0:1-1];
wire t2_writeA_wire [0:NUMVBNK1-1][0:1-1];
wire [BITSROW2-1:0] t2_addrA_wire [0:NUMVBNK1-1][0:1-1];
wire [BITDWSN-1:0] t2_dwsnA_wire [0:NUMVBNK1-1][0:1-1];
wire [NUMWRDS2*MEMWDTH-1:0] t2_bwA_wire [0:NUMVBNK1-1][0:1-1];
wire [NUMWRDS2*MEMWDTH-1:0] t2_dinA_wire [0:NUMVBNK1-1][0:1-1];
wire t2_refrB_wire [0:NUMVBNK1-1][0:1-1];
wire [BITRBNK-1:0] t2_bankB_wire [0:NUMVBNK1-1][0:1-1];

genvar t2r, t2b;
generate
  for (t2r=0; t2r<NUMVBNK1; t2r=t2r+1) begin: t2r_loop
    for (t2b=0; t2b<1; t2b=t2b+1) begin: t2b_loop

      wire t2_readA_a2_wire = t2_readA_a2[t2r] >> t2b;
      wire t2_writeA_a2_wire = t2_writeA_a2[t2r] >> t2b;
      wire [BITVROW2-1:0] t2_addrA_a2_wire = t2_addrA_a2[t2r] >> (t2b*BITVROW2);
      wire [WIDTH-1:0] t2_dinA_a2_wire = t2_dinA_a2[t2r] >> (t2b*WIDTH);
      wire t2_refrB_a2_wire = t2_refrB_a2[t2r] >> t2b;

      wire [NUMWRDS2*MEMWDTH-1:0] t2_doutA_wire = t2_doutA >> ((t2r*1+t2b)*PHYWDTH2);
      wire [NUMWRDS2-1:0] t2_serrA_wire = t2_serrA >> (t2r*1+t2b);

      if (1) begin: align_loop
        infra_align_ecc_dwsn #(.WIDTH (WIDTH), .ENAEXT (ENAEXT), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH),
                               .NUMADDR (NUMVROW2), .BITADDR (BITVROW2),
                               .NUMSROW (NUMSROW2), .BITSROW (BITSROW2), .NUMWRDS (NUMWRDS2), .BITWRDS (BITWRDS2), .BITPADR (BITSROW2+BITWRDS2),
                               .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
                               .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
                               .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
                               .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15), .BITDWSN (BITDWSN),
                               .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (FLOPECC), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPECC), .RSTZERO (1))
          infra (.read (t2_readA_a2_wire), .write (t2_writeA_a2_wire), .addr (t2_addrA_a2_wire), .din (t2_dinA_a2_wire),
                 .rd_dout (t2_doutA_a2_wire[t2r][t2b]), .rd_fwrd (t2_fwrdA_a2_wire[t2r][t2b]),
                 .rd_serr (t2_serrA_a2_wire[t2r][t2b]), .rd_derr (t2_derrA_a2_wire[t2r][t2b]), .rd_padr (t2_padrA_a2_wire[t2r][t2b]),
                 .mem_read (t2_readA_wire[t2r][t2b]), .mem_write (t2_writeA_wire[t2r][t2b]), .mem_addr (t2_addrA_wire[t2r][t2b]),
                 .mem_dwsn (t2_dwsnA_wire[t2r][t2b]), .mem_bw (t2_bwA_wire[t2r][t2b]), .mem_din (t2_dinA_wire[t2r][t2b]),
                 .mem_dout (t2_doutA_wire), .mem_serr (t2_serrA_wire),
                 .select_addr (select_vrow_a2),
                 .clk (clk), .rst (rst));
      end
      wire [BITRBNK-1:0] t2_bankA_a2_wire = t2_addrA_wire[t2r][t2b] >> (BITSROW2-BITRBNK-BITWSPF);

      if (REFRESH==1) begin: refr_loop
        infra_refr_1stage #(.NUMRBNK (NUMRBNK), .BITRBNK (BITRBNK), .REFLOPW (REFLOPW),
                            .NUMRROW (NUMRROW), .BITRROW (BITRROW), .REFFREQ (REFFREQ), .REFFRHF (REFFRHF))
          infra (.clk (clk), .rst (rst),
                 .pref (t2_refrB_a2_wire), .pacc (t2_readA_a2_wire || t2_writeA_a2_wire), .pacbadr (t2_bankA_a2_wire),
                 .prefr (t2_refrB_wire[t2r][t2b]), .prfbadr (t2_bankB_wire[t2r][t2b]),
                 .select_rbnk (select_rbnk), .select_rrow (select_rrow));
      end else begin: no_refr_loop
        assign t2_refrB_wire[t2r][t2b] = 1'b0;
        assign t2_bankB_wire[t2r][t2b] = 0;
      end
    end
  end
endgenerate

reg [NUMVBNK1-1:0] t2_readA;
reg [NUMVBNK1-1:0] t2_writeA;
reg [NUMVBNK1*BITSROW2-1:0] t2_addrA;
reg [NUMVBNK1*BITDWSN-1:0] t2_dwsnA;
reg [NUMVBNK1*PHYWDTH2-1:0] t2_bwA;
reg [NUMVBNK1*PHYWDTH2-1:0] t2_dinA;
reg [NUMVBNK1-1:0] t2_refrB;
reg [NUMVBNK1*BITRBNK-1:0] t2_bankB;

integer t2r_int, t2b_int;
always_comb begin
  t2_readA = 0;
  t2_writeA = 0;
  t2_addrA = 0;
  t2_dwsnA = 0;
  t2_bwA = 0;
  t2_dinA = 0;
  t2_refrB = 0;
  t2_bankB = 0;
  for (t2r_int=0; t2r_int<NUMVBNK1; t2r_int=t2r_int+1) begin
    t2_doutA_a2[t2r_int] = 0;
    t2_fwrdA_a2[t2r_int] = 0;
    t2_serrA_a2[t2r_int] = 0;
    t2_derrA_a2[t2r_int] = 0;
    t2_padrA_a2[t2r_int] = 0;
    for (t2b_int=0; t2b_int<1; t2b_int=t2b_int+1) begin
      t2_readA = t2_readA | (t2_readA_wire[t2r_int][t2b_int] << (t2r_int*1+t2b_int));
      t2_writeA = t2_writeA | (t2_writeA_wire[t2r_int][t2b_int] << (t2r_int*1+t2b_int));
      t2_addrA = t2_addrA | (t2_addrA_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*BITSROW2));
      t2_dwsnA = t2_dwsnA | (t2_dwsnA_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*BITDWSN));
      t2_bwA = t2_bwA | (t2_bwA_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*PHYWDTH2));
      t2_dinA = t2_dinA | (t2_dinA_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*PHYWDTH2));
      t2_refrB = t2_refrB | (t2_refrB_wire[t2r_int][t2b_int] << (t2r_int*1+t2b_int));
      t2_bankB = t2_bankB | (t2_bankB_wire[t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*BITRBNK));
      t2_doutA_a2[t2r_int] = t2_doutA_a2[t2r_int] | (t2_doutA_a2_wire[t2r_int][t2b_int] << (t2b_int*WIDTH));
      t2_fwrdA_a2[t2r_int] = t2_fwrdA_a2[t2r_int] | (t2_fwrdA_a2_wire[t2r_int][t2b_int] << t2b_int);
      t2_serrA_a2[t2r_int] = t2_serrA_a2[t2r_int] | (t2_serrA_a2_wire[t2r_int][t2b_int] << t2b_int);
      t2_derrA_a2[t2r_int] = t2_derrA_a2[t2r_int] | (t2_derrA_a2_wire[t2r_int][t2b_int] << t2b_int);
      t2_padrA_a2[t2r_int] = t2_padrA_a2[t2r_int] | (t2_padrA_a2_wire[t2r_int][t2b_int] << (t2b_int*(BITSROW2+BITWRDS2)));
    end
  end
end

wire [NUMVBNK2-1:0] t3_readA_a3;
wire [NUMVBNK2-1:0] t3_writeA_a3;
wire [NUMVBNK2*BITVROW2-1:0] t3_addrA_a3;
wire [NUMVBNK2*WIDTH-1:0] t3_dinA_a3;
wire [NUMVBNK2-1:0] t3_refrB_a3;
reg [NUMVBNK2*WIDTH-1:0] t3_doutA_a3;
reg [NUMVBNK2-1:0] t3_fwrdA_a3;
reg [NUMVBNK2-1:0] t3_serrA_a3;
reg [NUMVBNK2-1:0] t3_derrA_a3;
reg [NUMVBNK2*(BITSROW2+BITWRDS2)-1:0] t3_padrA_a3;

wire [1-1:0] t4_readA_a3;
wire [1-1:0] t4_writeA_a3;
wire [1*BITVROW2-1:0] t4_addrA_a3;
wire [1*WIDTH-1:0] t4_dinA_a3;
wire [1-1:0] t4_refrB_a3;
reg [1*WIDTH-1:0] t4_doutA_a3;
reg [1-1:0] t4_fwrdA_a3;
reg [1-1:0] t4_serrA_a3;
reg [1-1:0] t4_derrA_a3;
reg [1*(BITSROW2+BITWRDS2)-1:0] t4_padrA_a3;

      
   assign write_a3 = algo_sel? write_reg[4] : t3_writeA_a1[0];
   assign read_a3 = algo_sel? read_reg[10-1:8] : t3_readA_a1;
   assign rd_adr_a3 = algo_sel? {rd_adr_reg[9*BITADDR+BITVROW1-1:9*BITADDR], rd_adr_reg[8*BITADDR+BITVROW1-1:8*BITADDR]} : 
		      t3_addrA_a1;
   assign wr_adr_a3 = algo_sel? wr_adr_reg[4*BITADDR+BITVROW1-1:4*BITADDR] : t3_addrA_a1[BITVROW1-1:0];
   assign din_a3 =  algo_sel?  din_reg[5*WIDTH-1:4*WIDTH] : t3_dinA_a1[WIDTH-1:0];
   assign refr_a3 = algo_sel? refr_reg : t3_refrB_a1[0];
   

   assign t3_doutA_a1 = rd_dout_a3;
   assign t3_fwrdA_a1 = rd_fwrd_a3;
   assign t3_serrA_a1 = rd_serr_a3;
   assign t3_derrA_a1 = rd_derr_a3;
   assign t3_padrA_a1 = rd_padr_a3;
   
genvar a3_int;
generate for (a3_int=0; a3_int<1; a3_int=a3_int+1) begin: a3_loop
 
  algo_nror1w #(.WIDTH (WIDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .BITWDTH (BITWDTH), .NUMADDR (NUMVROW1), .BITADDR (BITVROW1), .NUMVRPT (2), .NUMPRPT (1),
                .NUMVROW (NUMVROW2), .BITVROW (BITVROW2), .NUMVBNK (NUMVBNK2), .BITVBNK (BITVBNK2), .BITPBNK (BITPBNK2), .BITPADR (BITPADR2),
                .REFRESH (REFRESH), .REFFREQ (REFFREQ), .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPECC+FLOPMEM), .FLOPIN (FLOPIN2), .FLOPOUT (FLOPOUT2))
    algo (.refr (refr_a3), .clk (clk), .rst (rst), .ready (t3_a3_ready),
          .write (write_a3), .wr_adr (wr_adr_a3), .din (din_a3),
          .read (read_a3), .rd_adr (rd_adr_a3), .rd_vld (rd_vld_a3), .rd_dout (rd_dout_a3),
	  .rd_fwrd (rd_fwrd_a3), .rd_serr (rd_serr_a3), .rd_derr (rd_derr_a3), .rd_padr (rd_padr_a3),
          .t1_readA (t3_readA_a3), .t1_writeA (t3_writeA_a3), .t1_addrA (t3_addrA_a3), .t1_dinA (t3_dinA_a3), .t1_doutA (t3_doutA_a3),
	  .t1_fwrdA (t3_fwrdA_a3), .t1_serrA (t3_serrA_a3), .t1_derrA (t3_derrA_a3), .t1_padrA (t3_padrA_a3), .t1_refrB (t3_refrB_a3),
          .t2_readA (t4_readA_a3), .t2_writeA (t4_writeA_a3), .t2_addrA (t4_addrA_a3), .t2_dinA (t4_dinA_a3), .t2_doutA (t4_doutA_a3),
	  .t2_fwrdA (t4_fwrdA_a3), .t2_serrA (t4_serrA_a3), .t2_derrA (t4_derrA_a3), .t2_padrA (t4_padrA_a3), .t2_refrB (t4_refrB_a3),
	  .select_addr (select_addr_a2), .select_bit (select_bit));

end
endgenerate

wire [WIDTH-1:0] t3_doutA_a3_wire [0:NUMVBNK2-1]; 
wire t3_fwrdA_a3_wire [0:NUMVBNK2-1];
wire t3_serrA_a3_wire [0:NUMVBNK2-1];
wire t3_derrA_a3_wire [0:NUMVBNK2-1];
wire [(BITSROW2+BITWRDS2)-1:0] t3_padrA_a3_wire [0:NUMVBNK2-1];
wire t3_readA_wire [0:NUMVBNK2-1];
wire t3_writeA_wire [0:NUMVBNK2-1];
wire [BITSROW2-1:0] t3_addrA_wire [0:NUMVBNK2-1];
wire [BITDWSN-1:0] t3_dwsnA_wire [0:NUMVBNK2-1];
wire [NUMWRDS2*MEMWDTH-1:0] t3_bwA_wire [0:NUMVBNK2-1];
wire [NUMWRDS2*MEMWDTH-1:0] t3_dinA_wire [0:NUMVBNK2-1];
wire t3_refrB_wire [0:NUMVBNK2-1];
wire [BITRBNK-1:0] t3_bankB_wire [0:NUMVBNK2-1];

genvar t3;
generate for (t3=0; t3<NUMVBNK2; t3=t3+1) begin: t3_loop
  wire t3_readA_a3_wire = t3_readA_a3 >> t3;
  wire t3_writeA_a3_wire = t3_writeA_a3 >> t3;
  wire [BITVROW2-1:0] t3_addrA_a3_wire = t3_addrA_a3 >> (t3*BITVROW2);
  wire [WIDTH-1:0] t3_dinA_a3_wire = t3_dinA_a3 >> (t3*WIDTH);
  wire t3_refrB_a3_wire = t3_refrB_a3 >> t3;

  wire [NUMWRDS2*MEMWDTH-1:0] t3_doutA_wire = t3_doutA >> (t3*PHYWDTH2);
  wire [NUMWRDS2-1:0] t3_serrA_wire = t3_serrA >> t3;

  if (1) begin: align_loop
    infra_align_ecc_dwsn #(.WIDTH (WIDTH), .ENAEXT (ENAEXT), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH),
                           .NUMADDR (NUMVROW2), .BITADDR (BITVROW2),
                           .NUMSROW (NUMSROW2), .BITSROW (BITSROW2), .NUMWRDS (NUMWRDS2), .BITWRDS (BITWRDS2), .BITPADR (BITSROW2+BITWRDS2),
                           .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
                           .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
                           .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
                           .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15), .BITDWSN (BITDWSN),
                           .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (FLOPECC), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPECC), .RSTZERO (1))
      infra (.read (t3_readA_a3_wire), .write (t3_writeA_a3_wire), .addr (t3_addrA_a3_wire), .din (t3_dinA_a3_wire),
             .rd_dout (t3_doutA_a3_wire[t3]), .rd_fwrd (t3_fwrdA_a3_wire[t3]),
             .rd_serr (t3_serrA_a3_wire[t3]), .rd_derr (t3_derrA_a3_wire[t3]), .rd_padr (t3_padrA_a3_wire[t3]),
             .mem_read (t3_readA_wire[t3]), .mem_write (t3_writeA_wire[t3]), .mem_addr (t3_addrA_wire[t3]),
             .mem_dwsn (t3_dwsnA_wire[t3]), .mem_bw (t3_bwA_wire[t3]), .mem_din (t3_dinA_wire[t3]),
             .mem_dout (t3_doutA_wire), .mem_serr (t3_serrA_wire),
             .select_addr (select_vrow_a2),
             .clk (clk), .rst (rst));
  end

  wire [BITRBNK-1:0] t3_bankA_wire = t3_addrA_wire[t3] >> (BITSROW2-BITRBNK-BITWSPF);

  if (REFRESH==1) begin: refr_loop
    infra_refr_1stage #(.NUMRBNK (NUMRBNK), .BITRBNK (BITRBNK), .REFLOPW (REFLOPW),
                        .NUMRROW (NUMRROW), .BITRROW (BITRROW), .REFFREQ (REFFREQ), .REFFRHF (REFFRHF))
        infra (.clk (clk), .rst (rst),
               .pref (t3_refrB_a3_wire), .pacc (t3_readA_wire[t3] || t3_writeA_wire[t3]), .pacbadr (t3_bankA_wire),
               .prefr (t3_refrB_wire[t3]), .prfbadr (t3_bankB_wire[t3]),
               .select_rbnk (select_rbnk), .select_rrow (select_rrow));
  end else begin: no_refr_loop
    assign t3_refrB_wire[t3] = 1'b0;
    assign t3_bankB_wire[t3] = 0;
  end
end
endgenerate

reg [NUMVBNK2-1:0] t3_readA;
reg [NUMVBNK2-1:0] t3_writeA;
reg [NUMVBNK2*BITSROW2-1:0] t3_addrA;
reg [NUMVBNK2*BITDWSN-1:0] t3_dwsnA;
reg [NUMVBNK2*PHYWDTH2-1:0] t3_bwA;
reg [NUMVBNK2*PHYWDTH2-1:0] t3_dinA;
reg [NUMVBNK2-1:0] t3_refrB;
reg [NUMVBNK2*BITRBNK-1:0] t3_bankB;

integer t3_out_int;
always_comb begin
  t3_readA = 0;
  t3_writeA = 0;
  t3_addrA = 0;
  t3_dwsnA = 0;
  t3_bwA = 0;
  t3_dinA = 0;
  t3_refrB = 0;
  t3_bankB = 0;
  t3_doutA_a3 = 0;
  t3_fwrdA_a3 = 0;
  t3_serrA_a3 = 0;
  t3_derrA_a3 = 0;
  t3_padrA_a3 = 0;
  for (t3_out_int=0; t3_out_int<NUMVBNK2; t3_out_int=t3_out_int+1) begin
    t3_readA = t3_readA | (t3_readA_wire[t3_out_int] << t3_out_int);
    t3_writeA = t3_writeA | (t3_writeA_wire[t3_out_int] << t3_out_int);
    t3_addrA = t3_addrA | (t3_addrA_wire[t3_out_int] << (t3_out_int*BITSROW2));
    t3_dwsnA = t3_dwsnA | (t3_dwsnA_wire[t3_out_int] << (t3_out_int*BITDWSN));
    t3_bwA = t3_bwA | (t3_bwA_wire[t3_out_int] << (t3_out_int*PHYWDTH2));
    t3_dinA = t3_dinA | (t3_dinA_wire[t3_out_int] << (t3_out_int*PHYWDTH2));
    t3_doutA_a3 = t3_doutA_a3 | (t3_doutA_a3_wire[t3_out_int] << (t3_out_int*WIDTH));
    t3_fwrdA_a3 = t3_fwrdA_a3 | (t3_fwrdA_a3_wire[t3_out_int] << t3_out_int);
    t3_serrA_a3 = t3_serrA_a3 | (t3_serrA_a3_wire[t3_out_int] << t3_out_int);
    t3_derrA_a3 = t3_derrA_a3 | (t3_derrA_a3_wire[t3_out_int] << t3_out_int);
    t3_padrA_a3 = t3_padrA_a3 | (t3_padrA_a3_wire[t3_out_int] << (t3_out_int*(BITSROW2+BITWRDS2)));
    t3_refrB = t3_refrB | (t3_refrB_wire[t3_out_int] << t3_out_int);
    t3_bankB = t3_bankB | (t3_bankB_wire[t3_out_int] << (t3_out_int*BITRBNK));
  end
end

wire [WIDTH-1:0] t4_doutA_a3_wire [0:1-1];
wire t4_fwrdA_a3_wire [0:1-1];
wire t4_serrA_a3_wire [0:1-1];
wire t4_derrA_a3_wire [0:1-1];
wire [(BITSROW2+BITWRDS2)-1:0] t4_padrA_a3_wire [0:1-1];
wire t4_readA_wire [0:1-1];
wire t4_writeA_wire [0:1-1];
wire [BITSROW2-1:0] t4_addrA_wire [0:1-1];
wire [BITDWSN-1:0] t4_dwsnA_wire [0:1-1];
wire [NUMWRDS2*MEMWDTH-1:0] t4_bwA_wire [0:1-1];
wire [NUMWRDS2*MEMWDTH-1:0] t4_dinA_wire [0:1-1];
wire t4_refrB_wire [0:1-1];
wire [BITRBNK-1:0] t4_bankB_wire [0:1-1];

genvar t4;
generate for (t4=0; t4<1; t4=t4+1) begin: t4_loop
  wire t4_readA_a3_wire = t4_readA_a3 >> t4;
  wire t4_writeA_a3_wire = t4_writeA_a3 >> t4;
  wire [BITVROW2-1:0] t4_addrA_a3_wire = t4_addrA_a3 >> (t4*BITVROW2);
  wire [WIDTH-1:0] t4_dinA_a3_wire = t4_dinA_a3 >> (t4*WIDTH);
  wire t4_refrB_a3_wire = t4_refrB_a3 >> t4;

  wire [NUMWRDS2*MEMWDTH-1:0] t4_doutA_wire = t4_doutA >> (t4*PHYWDTH2);
  wire [NUMWRDS2-1:0] t4_serrA_wire = t4_serrA >> t4;

  if (1) begin: align_loop
    infra_align_ecc_dwsn #(.WIDTH (WIDTH), .ENAEXT (ENAEXT), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH),
                           .NUMADDR (NUMVROW2), .BITADDR (BITVROW2),
                           .NUMSROW (NUMSROW2), .BITSROW (BITSROW2), .NUMWRDS (NUMWRDS2), .BITWRDS (BITWRDS2), .BITPADR (BITSROW2+BITWRDS2),
                           .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
                           .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
                           .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
                           .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15), .BITDWSN (BITDWSN),
                           .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (FLOPECC), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPECC), .RSTZERO (1))
      infra (.read (t4_readA_a3_wire), .write (t4_writeA_a3_wire), .addr (t4_addrA_a3_wire), .din (t4_dinA_a3_wire),
             .rd_dout (t4_doutA_a3_wire[t4]), .rd_fwrd (t4_fwrdA_a3_wire[t4]),
             .rd_serr (t4_serrA_a3_wire[t4]), .rd_derr (t4_derrA_a3_wire[t4]), .rd_padr (t4_padrA_a3_wire[t4]),
             .mem_read (t4_readA_wire[t4]), .mem_write (t4_writeA_wire[t4]), .mem_addr (t4_addrA_wire[t4]),
             .mem_dwsn (t4_dwsnA_wire[t4]), .mem_bw (t4_bwA_wire[t4]), .mem_din (t4_dinA_wire[t4]),
             .mem_dout (t4_doutA_wire), .mem_serr (t4_serrA_wire),
             .select_addr (select_vrow_a2),
             .clk (clk), .rst (rst));
  end

  wire [BITRBNK-1:0] t4_bankA_wire = t4_addrA_wire[t4] >> (BITSROW2-BITRBNK-BITWSPF);

  if (REFRESH==1) begin: refr_loop
    infra_refr_1stage #(.NUMRBNK (NUMRBNK), .BITRBNK (BITRBNK), .REFLOPW (REFLOPW),
                        .NUMRROW (NUMRROW), .BITRROW (BITRROW), .REFFREQ (REFFREQ), .REFFRHF (REFFRHF))
      infra (.clk (clk), .rst (rst),
             .pref (t4_refrB_a3_wire), .pacc (t4_readA_wire[t4] || t4_writeA_wire[t4]), .pacbadr (t4_bankA_wire),
             .prefr (t4_refrB_wire[t4]), .prfbadr (t4_bankB_wire[t4]),
             .select_rbnk (select_rbnk), .select_rrow (select_rrow));
  end else begin: no_refr_loop
    assign t4_refrB_wire[t4] = 1'b0;
    assign t4_bankB_wire[t4] = 0;
  end

end
endgenerate
reg [1-1:0] t4_readA;
reg [1-1:0] t4_writeA;
reg [1*BITSROW2-1:0] t4_addrA;
reg [1*BITDWSN-1:0] t4_dwsnA;
reg [1*PHYWDTH2-1:0] t4_bwA;
reg [1*PHYWDTH2-1:0] t4_dinA;
reg [1-1:0] t4_refrB;
reg [1*BITRBNK-1:0] t4_bankB;

integer t4_out_int;
always_comb begin
  t4_readA = 0;
  t4_writeA = 0;
  t4_addrA = 0;
  t4_dwsnA = 0;
  t4_bwA = 0;
  t4_dinA = 0;
  t4_doutA_a3 = 0;
  t4_fwrdA_a3 = 0;
  t4_serrA_a3 = 0;
  t4_derrA_a3 = 0;
  t4_padrA_a3 = 0;
  t4_refrB = 0;
  t4_bankB = 0;
  for (t4_out_int=0; t4_out_int<1; t4_out_int=t4_out_int+1) begin
    t4_readA = t4_readA | (t4_readA_wire[t4_out_int] << t4_out_int);
    t4_writeA = t4_writeA | (t4_writeA_wire[t4_out_int] << t4_out_int);
    t4_addrA = t4_addrA | (t4_addrA_wire[t4_out_int] << (t4_out_int*BITSROW2));
    t4_dwsnA = t4_dwsnA | (t4_dwsnA_wire[t4_out_int] << (t4_out_int*BITDWSN));
    t4_bwA = t4_bwA | (t4_bwA_wire[t4_out_int] << (t4_out_int*PHYWDTH2));
    t4_dinA = t4_dinA | (t4_dinA_wire[t4_out_int] << (t4_out_int*PHYWDTH2));
    t4_doutA_a3 = t4_doutA_a3 | (t4_doutA_a3_wire[t4_out_int] << (t4_out_int*WIDTH));
    t4_fwrdA_a3 = t4_fwrdA_a3 | (t4_fwrdA_a3_wire[t4_out_int] << t4_out_int);
    t4_serrA_a3 = t4_serrA_a3 | (t4_serrA_a3_wire[t4_out_int] << t4_out_int);
    t4_derrA_a3 = t4_derrA_a3 | (t4_derrA_a3_wire[t4_out_int] << t4_out_int);
    t4_padrA_a3 = t4_padrA_a3 | (t4_padrA_a3_wire[t4_out_int] << (t4_out_int*(BITSROW2+BITWRDS2)));
    t4_refrB = t4_refrB | (t4_refrB_wire[t4_out_int] << t4_out_int);
    t4_bankB = t4_bankB | (t4_bankB_wire[t4_out_int] << (t4_out_int*BITRBNK));
  end
end


endmodule
