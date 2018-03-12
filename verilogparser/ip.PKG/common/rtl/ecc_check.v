module ecc_check
(din,  eccin, dout, sec_err, ded_err, clk, rst);
  parameter ECCDWIDTH = 3;
  parameter ECCWIDTH  = 4;
  parameter FLOPECC1  = 0;
  parameter FLOPECC2  = 0;

  input [ECCDWIDTH-1:0]            din;  
  input [ECCWIDTH-1:0]             eccin;

  output [ECCDWIDTH-1:0]           dout;  
  output                           sec_err; // asserted if a single error is detected/corrected
  output                           ded_err; // asserted if two errors are detected

  input                            clk;
  input                            rst;

  generate if (1) begin: inst
    if  (ECCDWIDTH <= 4)  begin
        wire [4-1:0] dout_tmp_4;
        ecc_check_4 #(.FLOPECC1(FLOPECC1), .FLOPECC2(FLOPECC2))
			ecc_check (.din(4'b0|din), .eccin(eccin), .dout(dout_tmp_4), .sec_err(sec_err), .ded_err(ded_err), .clk(clk), .rst(rst));
        assign dout = dout_tmp_4;
    end else if  (ECCDWIDTH <= 11) begin
        wire [11-1:0] dout_tmp_11;
        ecc_check_11 #(.FLOPECC1(FLOPECC1), .FLOPECC2(FLOPECC2))
			ecc_check (.din(11'b0|din), .eccin(eccin), .dout(dout_tmp_11), .sec_err(sec_err), .ded_err(ded_err), .clk(clk), .rst(rst));
        assign dout = dout_tmp_11;
    end else if  (ECCDWIDTH <= 26) begin
        wire [26-1:0] dout_tmp_26;
        ecc_check_26 #(.FLOPECC1(FLOPECC1), .FLOPECC2(FLOPECC2))
			ecc_check (.din(26'b0|din), .eccin(eccin), .dout(dout_tmp_26), .sec_err(sec_err), .ded_err(ded_err), .clk(clk), .rst(rst));
        assign dout = dout_tmp_26;
    end else if  (ECCDWIDTH <= 57) begin
        wire [57-1:0] dout_tmp_57;
        ecc_check_57 #(.FLOPECC1(FLOPECC1), .FLOPECC2(FLOPECC2))
			ecc_check (.din(57'b0|din), .eccin(eccin), .dout(dout_tmp_57), .sec_err(sec_err), .ded_err(ded_err), .clk(clk), .rst(rst));
        assign dout = dout_tmp_57;
    end else if  (ECCDWIDTH <= 120) begin
        wire [120-1:0] dout_tmp_120;
        ecc_check_120 #(.FLOPECC1(FLOPECC1), .FLOPECC2(FLOPECC2))
			ecc_check (.din(120'b0|din), .eccin(eccin), .dout(dout_tmp_120), .sec_err(sec_err), .ded_err(ded_err), .clk(clk), .rst(rst));
        assign dout = dout_tmp_120;
    end else if  (ECCDWIDTH <= 247) begin
        wire [247-1:0] dout_tmp_247;
        ecc_check_247 #(.FLOPECC1(FLOPECC1), .FLOPECC2(FLOPECC2))
			ecc_check (.din(247'b0|din), .eccin(eccin), .dout(dout_tmp_247), .sec_err(sec_err), .ded_err(ded_err), .clk(clk), .rst(rst));
        assign dout = dout_tmp_247;
    end else if  (ECCDWIDTH <= 502) begin
        wire [502-1:0] dout_tmp_502;
        ecc_check_502 #(.FLOPECC1(FLOPECC1), .FLOPECC2(FLOPECC2))
			ecc_check (.din(502'b0|din), .eccin(eccin), .dout(dout_tmp_502), .sec_err(sec_err), .ded_err(ded_err), .clk(clk), .rst(rst));
        assign dout = dout_tmp_502;
    end
  end
  endgenerate

endmodule

module ecc_check_4 #(parameter FLOPECC1=0, parameter FLOPECC2=0) (din,  eccin, dout, sec_err, ded_err, clk, rst);

  localparam ECCDWIDTH = 4;
  localparam ECCWIDTH  = 4;
  
  input [ECCDWIDTH-1:0]            din;  
  input [ECCWIDTH-1:0]             eccin;

  output [ECCDWIDTH-1:0]           dout;  
  output                           sec_err; // asserted if a single error is detected/corrected
  output                           ded_err; // asserted if two errors are detected

  input                            clk;
  input                            rst;

  wire       sec_err;
  wire       ded_err;
  wire [ECCDWIDTH-1:0]      dout;
  
  wire [ECCDWIDTH+ECCWIDTH-1:0]   ecchmatrix [0:ECCWIDTH-1];
  wire [ECCWIDTH-1:0]    sbits_wire;

  wire [ECCDWIDTH+ECCWIDTH-1:0]   biterr_wire;

// Generate the H Matrix in Perl

   assign ecchmatrix[0][0] = 1;
   assign ecchmatrix[1][0] = 1;
   assign ecchmatrix[2][0] = 1;
   assign ecchmatrix[3][0] = 0;
   assign ecchmatrix[0][1] = 1;
   assign ecchmatrix[1][1] = 1;
   assign ecchmatrix[2][1] = 0;
   assign ecchmatrix[3][1] = 1;
   assign ecchmatrix[0][2] = 1;
   assign ecchmatrix[1][2] = 0;
   assign ecchmatrix[2][2] = 1;
   assign ecchmatrix[3][2] = 1;
   assign ecchmatrix[0][3] = 0;
   assign ecchmatrix[1][3] = 1;
   assign ecchmatrix[2][3] = 1;
   assign ecchmatrix[3][3] = 1;
   assign ecchmatrix[0][4] = 1;
   assign ecchmatrix[1][4] = 0;
   assign ecchmatrix[2][4] = 0;
   assign ecchmatrix[3][4] = 0;
   assign ecchmatrix[0][5] = 0;
   assign ecchmatrix[1][5] = 1;
   assign ecchmatrix[2][5] = 0;
   assign ecchmatrix[3][5] = 0;
   assign ecchmatrix[0][6] = 0;
   assign ecchmatrix[1][6] = 0;
   assign ecchmatrix[2][6] = 1;
   assign ecchmatrix[3][6] = 0;
   assign ecchmatrix[0][7] = 0;
   assign ecchmatrix[1][7] = 0;
   assign ecchmatrix[2][7] = 0;
   assign ecchmatrix[3][7] = 1;


  assign sbits_wire[3] = (^(ecchmatrix[3]&din)) ^ eccin[3] ;
  assign sbits_wire[2] = (^(ecchmatrix[2]&din)) ^ eccin[2] ;
  assign sbits_wire[1] = (^(ecchmatrix[1]&din)) ^ eccin[1] ;
  assign sbits_wire[0] = (^(ecchmatrix[0]&din)) ^ eccin[0] ;
  
  wire [ECCWIDTH-1:0]    sbits;
  wire [ECCDWIDTH-1:0]	din_f1;
  generate if(FLOPECC1) begin
	reg [ECCWIDTH-1:0]    sbits_reg;
	reg [ECCDWIDTH-1:0]	din_f1_reg;
	always @(posedge clk) begin
		sbits_reg <= sbits_wire;
		din_f1_reg <= din;
	end
	assign sbits = sbits_reg;
	assign din_f1 = din_f1_reg;
  end else begin
	assign sbits = sbits_wire;
	assign din_f1 = din;
  end
  endgenerate

  assign biterr_wire[7] = ~(
         ecchmatrix[3][7]^sbits[3] |
         ecchmatrix[2][7]^sbits[2] |
         ecchmatrix[1][7]^sbits[1] |
         ecchmatrix[0][7]^sbits[0]);
  assign biterr_wire[6] = ~(
         ecchmatrix[3][6]^sbits[3] |
         ecchmatrix[2][6]^sbits[2] |
         ecchmatrix[1][6]^sbits[1] |
         ecchmatrix[0][6]^sbits[0]);
  assign biterr_wire[5] = ~(
         ecchmatrix[3][5]^sbits[3] |
         ecchmatrix[2][5]^sbits[2] |
         ecchmatrix[1][5]^sbits[1] |
         ecchmatrix[0][5]^sbits[0]);
  assign biterr_wire[4] = ~(
         ecchmatrix[3][4]^sbits[3] |
         ecchmatrix[2][4]^sbits[2] |
         ecchmatrix[1][4]^sbits[1] |
         ecchmatrix[0][4]^sbits[0]);
  assign biterr_wire[3] = ~(
         ecchmatrix[3][3]^sbits[3] |
         ecchmatrix[2][3]^sbits[2] |
         ecchmatrix[1][3]^sbits[1] |
         ecchmatrix[0][3]^sbits[0]);
  assign biterr_wire[2] = ~(
         ecchmatrix[3][2]^sbits[3] |
         ecchmatrix[2][2]^sbits[2] |
         ecchmatrix[1][2]^sbits[1] |
         ecchmatrix[0][2]^sbits[0]);
  assign biterr_wire[1] = ~(
         ecchmatrix[3][1]^sbits[3] |
         ecchmatrix[2][1]^sbits[2] |
         ecchmatrix[1][1]^sbits[1] |
         ecchmatrix[0][1]^sbits[0]);
  assign biterr_wire[0] = ~(
         ecchmatrix[3][0]^sbits[3] |
         ecchmatrix[2][0]^sbits[2] |
         ecchmatrix[1][0]^sbits[1] |
         ecchmatrix[0][0]^sbits[0]);
		 
  wire [ECCDWIDTH+ECCWIDTH-1:0]   biterr;
  wire [ECCDWIDTH-1:0]	din_f2;
  wire [ECCWIDTH-1:0]   sbits_f2;
  generate if(FLOPECC2) begin
	reg [ECCDWIDTH+ECCWIDTH-1:0]   biterr_reg;
	reg [ECCDWIDTH-1:0]	din_f2_reg;
	reg [ECCWIDTH-1:0] sbits_f2_reg;
	always @(posedge clk) begin
		biterr_reg <= biterr_wire;
		din_f2_reg <= din_f1;
		sbits_f2_reg <= sbits;
	end
	assign biterr = biterr_reg;
	assign din_f2 = din_f2_reg;
	assign sbits_f2 = sbits_f2_reg;
  end else begin
	assign biterr = biterr_wire;
	assign din_f2 = din_f1;
	assign sbits_f2 = sbits;
  end
  endgenerate

assign  dout    = din_f2 ^ biterr;
assign  sec_err = |biterr;
assign  ded_err = |sbits_f2 & ~|biterr;

endmodule

module ecc_check_11 #(parameter FLOPECC1=0, parameter FLOPECC2=0) (din,  eccin, dout, sec_err, ded_err, clk, rst);

  localparam ECCDWIDTH = 11;
  localparam ECCWIDTH  = 5;
  
  input [ECCDWIDTH-1:0]            din;  
  input [ECCWIDTH-1:0]             eccin;

  output [ECCDWIDTH-1:0]           dout;  
  output                           sec_err; // asserted if a single error is detected/corrected
  output                           ded_err; // asserted if two errors are detected

  input                            clk;
  input                            rst;

  wire       sec_err;
  wire       ded_err;
  wire [ECCDWIDTH-1:0]      dout;
  
  wire [ECCDWIDTH+ECCWIDTH-1:0]   ecchmatrix [0:ECCWIDTH-1];
  wire [ECCWIDTH-1:0]    sbits_wire;

  wire [ECCDWIDTH+ECCWIDTH-1:0]   biterr_wire;

// Generate the H Matrix in Perl

   assign ecchmatrix[0][0] = 1;
   assign ecchmatrix[1][0] = 1;
   assign ecchmatrix[2][0] = 1;
   assign ecchmatrix[3][0] = 0;
   assign ecchmatrix[4][0] = 0;
   assign ecchmatrix[0][1] = 1;
   assign ecchmatrix[1][1] = 1;
   assign ecchmatrix[2][1] = 0;
   assign ecchmatrix[3][1] = 1;
   assign ecchmatrix[4][1] = 0;
   assign ecchmatrix[0][2] = 1;
   assign ecchmatrix[1][2] = 1;
   assign ecchmatrix[2][2] = 0;
   assign ecchmatrix[3][2] = 0;
   assign ecchmatrix[4][2] = 1;
   assign ecchmatrix[0][3] = 1;
   assign ecchmatrix[1][3] = 0;
   assign ecchmatrix[2][3] = 1;
   assign ecchmatrix[3][3] = 1;
   assign ecchmatrix[4][3] = 0;
   assign ecchmatrix[0][4] = 1;
   assign ecchmatrix[1][4] = 0;
   assign ecchmatrix[2][4] = 1;
   assign ecchmatrix[3][4] = 0;
   assign ecchmatrix[4][4] = 1;
   assign ecchmatrix[0][5] = 1;
   assign ecchmatrix[1][5] = 0;
   assign ecchmatrix[2][5] = 0;
   assign ecchmatrix[3][5] = 1;
   assign ecchmatrix[4][5] = 1;
   assign ecchmatrix[0][6] = 0;
   assign ecchmatrix[1][6] = 1;
   assign ecchmatrix[2][6] = 1;
   assign ecchmatrix[3][6] = 1;
   assign ecchmatrix[4][6] = 0;
   assign ecchmatrix[0][7] = 0;
   assign ecchmatrix[1][7] = 1;
   assign ecchmatrix[2][7] = 1;
   assign ecchmatrix[3][7] = 0;
   assign ecchmatrix[4][7] = 1;
   assign ecchmatrix[0][8] = 0;
   assign ecchmatrix[1][8] = 1;
   assign ecchmatrix[2][8] = 0;
   assign ecchmatrix[3][8] = 1;
   assign ecchmatrix[4][8] = 1;
   assign ecchmatrix[0][9] = 0;
   assign ecchmatrix[1][9] = 0;
   assign ecchmatrix[2][9] = 1;
   assign ecchmatrix[3][9] = 1;
   assign ecchmatrix[4][9] = 1;
   assign ecchmatrix[0][10] = 1;
   assign ecchmatrix[1][10] = 1;
   assign ecchmatrix[2][10] = 1;
   assign ecchmatrix[3][10] = 1;
   assign ecchmatrix[4][10] = 1;
   assign ecchmatrix[0][11] = 1;
   assign ecchmatrix[1][11] = 0;
   assign ecchmatrix[2][11] = 0;
   assign ecchmatrix[3][11] = 0;
   assign ecchmatrix[4][11] = 0;
   assign ecchmatrix[0][12] = 0;
   assign ecchmatrix[1][12] = 1;
   assign ecchmatrix[2][12] = 0;
   assign ecchmatrix[3][12] = 0;
   assign ecchmatrix[4][12] = 0;
   assign ecchmatrix[0][13] = 0;
   assign ecchmatrix[1][13] = 0;
   assign ecchmatrix[2][13] = 1;
   assign ecchmatrix[3][13] = 0;
   assign ecchmatrix[4][13] = 0;
   assign ecchmatrix[0][14] = 0;
   assign ecchmatrix[1][14] = 0;
   assign ecchmatrix[2][14] = 0;
   assign ecchmatrix[3][14] = 1;
   assign ecchmatrix[4][14] = 0;
   assign ecchmatrix[0][15] = 0;
   assign ecchmatrix[1][15] = 0;
   assign ecchmatrix[2][15] = 0;
   assign ecchmatrix[3][15] = 0;
   assign ecchmatrix[4][15] = 1;


  assign sbits_wire[4] = (^(ecchmatrix[4]&din)) ^ eccin[4] ;
  assign sbits_wire[3] = (^(ecchmatrix[3]&din)) ^ eccin[3] ;
  assign sbits_wire[2] = (^(ecchmatrix[2]&din)) ^ eccin[2] ;
  assign sbits_wire[1] = (^(ecchmatrix[1]&din)) ^ eccin[1] ;
  assign sbits_wire[0] = (^(ecchmatrix[0]&din)) ^ eccin[0] ;

  wire [ECCWIDTH-1:0]    sbits;
  wire [ECCDWIDTH-1:0]	din_f1;
  generate if(FLOPECC1) begin
	reg [ECCWIDTH-1:0]    sbits_reg;
	reg [ECCDWIDTH-1:0]	din_f1_reg;
	always @(posedge clk) begin
		sbits_reg <= sbits_wire;
		din_f1_reg <= din;
	end
	assign sbits = sbits_reg;
	assign din_f1 = din_f1_reg;
  end else begin
	assign sbits = sbits_wire;
	assign din_f1 = din;
  end
  endgenerate
  
  assign biterr_wire[15] = ~(
         ecchmatrix[4][15]^sbits[4] |
         ecchmatrix[3][15]^sbits[3] |
         ecchmatrix[2][15]^sbits[2] |
         ecchmatrix[1][15]^sbits[1] |
         ecchmatrix[0][15]^sbits[0]);
  assign biterr_wire[14] = ~(
         ecchmatrix[4][14]^sbits[4] |
         ecchmatrix[3][14]^sbits[3] |
         ecchmatrix[2][14]^sbits[2] |
         ecchmatrix[1][14]^sbits[1] |
         ecchmatrix[0][14]^sbits[0]);
  assign biterr_wire[13] = ~(
         ecchmatrix[4][13]^sbits[4] |
         ecchmatrix[3][13]^sbits[3] |
         ecchmatrix[2][13]^sbits[2] |
         ecchmatrix[1][13]^sbits[1] |
         ecchmatrix[0][13]^sbits[0]);
  assign biterr_wire[12] = ~(
         ecchmatrix[4][12]^sbits[4] |
         ecchmatrix[3][12]^sbits[3] |
         ecchmatrix[2][12]^sbits[2] |
         ecchmatrix[1][12]^sbits[1] |
         ecchmatrix[0][12]^sbits[0]);
  assign biterr_wire[11] = ~(
         ecchmatrix[4][11]^sbits[4] |
         ecchmatrix[3][11]^sbits[3] |
         ecchmatrix[2][11]^sbits[2] |
         ecchmatrix[1][11]^sbits[1] |
         ecchmatrix[0][11]^sbits[0]);
  assign biterr_wire[10] = ~(
         ecchmatrix[4][10]^sbits[4] |
         ecchmatrix[3][10]^sbits[3] |
         ecchmatrix[2][10]^sbits[2] |
         ecchmatrix[1][10]^sbits[1] |
         ecchmatrix[0][10]^sbits[0]);
  assign biterr_wire[9] = ~(
         ecchmatrix[4][9]^sbits[4] |
         ecchmatrix[3][9]^sbits[3] |
         ecchmatrix[2][9]^sbits[2] |
         ecchmatrix[1][9]^sbits[1] |
         ecchmatrix[0][9]^sbits[0]);
  assign biterr_wire[8] = ~(
         ecchmatrix[4][8]^sbits[4] |
         ecchmatrix[3][8]^sbits[3] |
         ecchmatrix[2][8]^sbits[2] |
         ecchmatrix[1][8]^sbits[1] |
         ecchmatrix[0][8]^sbits[0]);
  assign biterr_wire[7] = ~(
         ecchmatrix[4][7]^sbits[4] |
         ecchmatrix[3][7]^sbits[3] |
         ecchmatrix[2][7]^sbits[2] |
         ecchmatrix[1][7]^sbits[1] |
         ecchmatrix[0][7]^sbits[0]);
  assign biterr_wire[6] = ~(
         ecchmatrix[4][6]^sbits[4] |
         ecchmatrix[3][6]^sbits[3] |
         ecchmatrix[2][6]^sbits[2] |
         ecchmatrix[1][6]^sbits[1] |
         ecchmatrix[0][6]^sbits[0]);
  assign biterr_wire[5] = ~(
         ecchmatrix[4][5]^sbits[4] |
         ecchmatrix[3][5]^sbits[3] |
         ecchmatrix[2][5]^sbits[2] |
         ecchmatrix[1][5]^sbits[1] |
         ecchmatrix[0][5]^sbits[0]);
  assign biterr_wire[4] = ~(
         ecchmatrix[4][4]^sbits[4] |
         ecchmatrix[3][4]^sbits[3] |
         ecchmatrix[2][4]^sbits[2] |
         ecchmatrix[1][4]^sbits[1] |
         ecchmatrix[0][4]^sbits[0]);
  assign biterr_wire[3] = ~(
         ecchmatrix[4][3]^sbits[4] |
         ecchmatrix[3][3]^sbits[3] |
         ecchmatrix[2][3]^sbits[2] |
         ecchmatrix[1][3]^sbits[1] |
         ecchmatrix[0][3]^sbits[0]);
  assign biterr_wire[2] = ~(
         ecchmatrix[4][2]^sbits[4] |
         ecchmatrix[3][2]^sbits[3] |
         ecchmatrix[2][2]^sbits[2] |
         ecchmatrix[1][2]^sbits[1] |
         ecchmatrix[0][2]^sbits[0]);
  assign biterr_wire[1] = ~(
         ecchmatrix[4][1]^sbits[4] |
         ecchmatrix[3][1]^sbits[3] |
         ecchmatrix[2][1]^sbits[2] |
         ecchmatrix[1][1]^sbits[1] |
         ecchmatrix[0][1]^sbits[0]);
  assign biterr_wire[0] = ~(
         ecchmatrix[4][0]^sbits[4] |
         ecchmatrix[3][0]^sbits[3] |
         ecchmatrix[2][0]^sbits[2] |
         ecchmatrix[1][0]^sbits[1] |
         ecchmatrix[0][0]^sbits[0]);

  wire [ECCDWIDTH+ECCWIDTH-1:0]   biterr;
  wire [ECCDWIDTH-1:0]	din_f2;
  wire [ECCWIDTH-1:0]   sbits_f2;
  generate if(FLOPECC2) begin
	reg [ECCDWIDTH+ECCWIDTH-1:0]   biterr_reg;
	reg [ECCDWIDTH-1:0]	din_f2_reg;
	reg [ECCWIDTH-1:0] sbits_f2_reg;
	always @(posedge clk) begin
		biterr_reg <= biterr_wire;
		din_f2_reg <= din_f1;
		sbits_f2_reg <= sbits;
	end
	assign biterr = biterr_reg;
	assign din_f2 = din_f2_reg;
	assign sbits_f2 = sbits_f2_reg;
  end else begin
	assign biterr = biterr_wire;
	assign din_f2 = din_f1;
	assign sbits_f2 = sbits;
  end
  endgenerate
		 
 assign  dout    = din_f2 ^ biterr;
 assign  sec_err = |biterr;
 assign  ded_err = |sbits_f2 & ~|biterr;

endmodule

module ecc_check_26 #(parameter FLOPECC1=0, parameter FLOPECC2=0) (din,  eccin, dout, sec_err, ded_err, clk, rst);

  localparam ECCDWIDTH = 26;
  localparam ECCWIDTH  = 6;
  
  input [ECCDWIDTH-1:0]            din;  
  input [ECCWIDTH-1:0]             eccin;

  output [ECCDWIDTH-1:0]           dout;  
  output                           sec_err; // asserted if a single error is detected/corrected
  output                           ded_err; // asserted if two errors are detected

  input                            clk;
  input                            rst;

  wire       sec_err;
  wire       ded_err;
  wire [ECCDWIDTH-1:0]      dout;
  
  wire [ECCDWIDTH+ECCWIDTH-1:0]   ecchmatrix [0:ECCWIDTH-1];
  wire [ECCWIDTH-1:0]    sbits_wire;

  wire [ECCDWIDTH+ECCWIDTH-1:0]   biterr_wire;

// Generate the H Matrix in Perl

   assign ecchmatrix[0][0] = 1;
   assign ecchmatrix[1][0] = 1;
   assign ecchmatrix[2][0] = 1;
   assign ecchmatrix[3][0] = 0;
   assign ecchmatrix[4][0] = 0;
   assign ecchmatrix[5][0] = 0;
   assign ecchmatrix[0][1] = 1;
   assign ecchmatrix[1][1] = 1;
   assign ecchmatrix[2][1] = 0;
   assign ecchmatrix[3][1] = 1;
   assign ecchmatrix[4][1] = 0;
   assign ecchmatrix[5][1] = 0;
   assign ecchmatrix[0][2] = 1;
   assign ecchmatrix[1][2] = 1;
   assign ecchmatrix[2][2] = 0;
   assign ecchmatrix[3][2] = 0;
   assign ecchmatrix[4][2] = 1;
   assign ecchmatrix[5][2] = 0;
   assign ecchmatrix[0][3] = 1;
   assign ecchmatrix[1][3] = 1;
   assign ecchmatrix[2][3] = 0;
   assign ecchmatrix[3][3] = 0;
   assign ecchmatrix[4][3] = 0;
   assign ecchmatrix[5][3] = 1;
   assign ecchmatrix[0][4] = 1;
   assign ecchmatrix[1][4] = 0;
   assign ecchmatrix[2][4] = 1;
   assign ecchmatrix[3][4] = 1;
   assign ecchmatrix[4][4] = 0;
   assign ecchmatrix[5][4] = 0;
   assign ecchmatrix[0][5] = 1;
   assign ecchmatrix[1][5] = 0;
   assign ecchmatrix[2][5] = 1;
   assign ecchmatrix[3][5] = 0;
   assign ecchmatrix[4][5] = 1;
   assign ecchmatrix[5][5] = 0;
   assign ecchmatrix[0][6] = 1;
   assign ecchmatrix[1][6] = 0;
   assign ecchmatrix[2][6] = 1;
   assign ecchmatrix[3][6] = 0;
   assign ecchmatrix[4][6] = 0;
   assign ecchmatrix[5][6] = 1;
   assign ecchmatrix[0][7] = 1;
   assign ecchmatrix[1][7] = 0;
   assign ecchmatrix[2][7] = 0;
   assign ecchmatrix[3][7] = 1;
   assign ecchmatrix[4][7] = 1;
   assign ecchmatrix[5][7] = 0;
   assign ecchmatrix[0][8] = 1;
   assign ecchmatrix[1][8] = 0;
   assign ecchmatrix[2][8] = 0;
   assign ecchmatrix[3][8] = 1;
   assign ecchmatrix[4][8] = 0;
   assign ecchmatrix[5][8] = 1;
   assign ecchmatrix[0][9] = 1;
   assign ecchmatrix[1][9] = 0;
   assign ecchmatrix[2][9] = 0;
   assign ecchmatrix[3][9] = 0;
   assign ecchmatrix[4][9] = 1;
   assign ecchmatrix[5][9] = 1;
   assign ecchmatrix[0][10] = 0;
   assign ecchmatrix[1][10] = 1;
   assign ecchmatrix[2][10] = 1;
   assign ecchmatrix[3][10] = 1;
   assign ecchmatrix[4][10] = 0;
   assign ecchmatrix[5][10] = 0;
   assign ecchmatrix[0][11] = 0;
   assign ecchmatrix[1][11] = 1;
   assign ecchmatrix[2][11] = 1;
   assign ecchmatrix[3][11] = 0;
   assign ecchmatrix[4][11] = 1;
   assign ecchmatrix[5][11] = 0;
   assign ecchmatrix[0][12] = 0;
   assign ecchmatrix[1][12] = 1;
   assign ecchmatrix[2][12] = 1;
   assign ecchmatrix[3][12] = 0;
   assign ecchmatrix[4][12] = 0;
   assign ecchmatrix[5][12] = 1;
   assign ecchmatrix[0][13] = 0;
   assign ecchmatrix[1][13] = 1;
   assign ecchmatrix[2][13] = 0;
   assign ecchmatrix[3][13] = 1;
   assign ecchmatrix[4][13] = 1;
   assign ecchmatrix[5][13] = 0;
   assign ecchmatrix[0][14] = 0;
   assign ecchmatrix[1][14] = 1;
   assign ecchmatrix[2][14] = 0;
   assign ecchmatrix[3][14] = 1;
   assign ecchmatrix[4][14] = 0;
   assign ecchmatrix[5][14] = 1;
   assign ecchmatrix[0][15] = 0;
   assign ecchmatrix[1][15] = 1;
   assign ecchmatrix[2][15] = 0;
   assign ecchmatrix[3][15] = 0;
   assign ecchmatrix[4][15] = 1;
   assign ecchmatrix[5][15] = 1;
   assign ecchmatrix[0][16] = 0;
   assign ecchmatrix[1][16] = 0;
   assign ecchmatrix[2][16] = 1;
   assign ecchmatrix[3][16] = 1;
   assign ecchmatrix[4][16] = 1;
   assign ecchmatrix[5][16] = 0;
   assign ecchmatrix[0][17] = 0;
   assign ecchmatrix[1][17] = 0;
   assign ecchmatrix[2][17] = 1;
   assign ecchmatrix[3][17] = 1;
   assign ecchmatrix[4][17] = 0;
   assign ecchmatrix[5][17] = 1;
   assign ecchmatrix[0][18] = 0;
   assign ecchmatrix[1][18] = 0;
   assign ecchmatrix[2][18] = 1;
   assign ecchmatrix[3][18] = 0;
   assign ecchmatrix[4][18] = 1;
   assign ecchmatrix[5][18] = 1;
   assign ecchmatrix[0][19] = 0;
   assign ecchmatrix[1][19] = 0;
   assign ecchmatrix[2][19] = 0;
   assign ecchmatrix[3][19] = 1;
   assign ecchmatrix[4][19] = 1;
   assign ecchmatrix[5][19] = 1;
   assign ecchmatrix[0][20] = 1;
   assign ecchmatrix[1][20] = 1;
   assign ecchmatrix[2][20] = 1;
   assign ecchmatrix[3][20] = 1;
   assign ecchmatrix[4][20] = 1;
   assign ecchmatrix[5][20] = 0;
   assign ecchmatrix[0][21] = 1;
   assign ecchmatrix[1][21] = 1;
   assign ecchmatrix[2][21] = 1;
   assign ecchmatrix[3][21] = 1;
   assign ecchmatrix[4][21] = 0;
   assign ecchmatrix[5][21] = 1;
   assign ecchmatrix[0][22] = 1;
   assign ecchmatrix[1][22] = 1;
   assign ecchmatrix[2][22] = 1;
   assign ecchmatrix[3][22] = 0;
   assign ecchmatrix[4][22] = 1;
   assign ecchmatrix[5][22] = 1;
   assign ecchmatrix[0][23] = 1;
   assign ecchmatrix[1][23] = 1;
   assign ecchmatrix[2][23] = 0;
   assign ecchmatrix[3][23] = 1;
   assign ecchmatrix[4][23] = 1;
   assign ecchmatrix[5][23] = 1;
   assign ecchmatrix[0][24] = 1;
   assign ecchmatrix[1][24] = 0;
   assign ecchmatrix[2][24] = 1;
   assign ecchmatrix[3][24] = 1;
   assign ecchmatrix[4][24] = 1;
   assign ecchmatrix[5][24] = 1;
   assign ecchmatrix[0][25] = 0;
   assign ecchmatrix[1][25] = 1;
   assign ecchmatrix[2][25] = 1;
   assign ecchmatrix[3][25] = 1;
   assign ecchmatrix[4][25] = 1;
   assign ecchmatrix[5][25] = 1;
   assign ecchmatrix[0][26] = 1;
   assign ecchmatrix[1][26] = 0;
   assign ecchmatrix[2][26] = 0;
   assign ecchmatrix[3][26] = 0;
   assign ecchmatrix[4][26] = 0;
   assign ecchmatrix[5][26] = 0;
   assign ecchmatrix[0][27] = 0;
   assign ecchmatrix[1][27] = 1;
   assign ecchmatrix[2][27] = 0;
   assign ecchmatrix[3][27] = 0;
   assign ecchmatrix[4][27] = 0;
   assign ecchmatrix[5][27] = 0;
   assign ecchmatrix[0][28] = 0;
   assign ecchmatrix[1][28] = 0;
   assign ecchmatrix[2][28] = 1;
   assign ecchmatrix[3][28] = 0;
   assign ecchmatrix[4][28] = 0;
   assign ecchmatrix[5][28] = 0;
   assign ecchmatrix[0][29] = 0;
   assign ecchmatrix[1][29] = 0;
   assign ecchmatrix[2][29] = 0;
   assign ecchmatrix[3][29] = 1;
   assign ecchmatrix[4][29] = 0;
   assign ecchmatrix[5][29] = 0;
   assign ecchmatrix[0][30] = 0;
   assign ecchmatrix[1][30] = 0;
   assign ecchmatrix[2][30] = 0;
   assign ecchmatrix[3][30] = 0;
   assign ecchmatrix[4][30] = 1;
   assign ecchmatrix[5][30] = 0;
   assign ecchmatrix[0][31] = 0;
   assign ecchmatrix[1][31] = 0;
   assign ecchmatrix[2][31] = 0;
   assign ecchmatrix[3][31] = 0;
   assign ecchmatrix[4][31] = 0;
   assign ecchmatrix[5][31] = 1;


  assign sbits_wire[5] = (^(ecchmatrix[5]&din)) ^ eccin[5] ;
  assign sbits_wire[4] = (^(ecchmatrix[4]&din)) ^ eccin[4] ;
  assign sbits_wire[3] = (^(ecchmatrix[3]&din)) ^ eccin[3] ;
  assign sbits_wire[2] = (^(ecchmatrix[2]&din)) ^ eccin[2] ;
  assign sbits_wire[1] = (^(ecchmatrix[1]&din)) ^ eccin[1] ;
  assign sbits_wire[0] = (^(ecchmatrix[0]&din)) ^ eccin[0] ;

  wire [ECCWIDTH-1:0]    sbits;
  wire [ECCDWIDTH-1:0]	din_f1;
  generate if(FLOPECC1) begin
	reg [ECCWIDTH-1:0]    sbits_reg;
	reg [ECCDWIDTH-1:0]	din_f1_reg;
	always @(posedge clk) begin
		sbits_reg <= sbits_wire;
		din_f1_reg <= din;
	end
	assign sbits = sbits_reg;
	assign din_f1 = din_f1_reg;
  end else begin
	assign sbits = sbits_wire;
	assign din_f1 = din;
  end
  endgenerate
  
  assign biterr_wire[31] = ~(
         ecchmatrix[5][31]^sbits[5] |
         ecchmatrix[4][31]^sbits[4] |
         ecchmatrix[3][31]^sbits[3] |
         ecchmatrix[2][31]^sbits[2] |
         ecchmatrix[1][31]^sbits[1] |
         ecchmatrix[0][31]^sbits[0]);
  assign biterr_wire[30] = ~(
         ecchmatrix[5][30]^sbits[5] |
         ecchmatrix[4][30]^sbits[4] |
         ecchmatrix[3][30]^sbits[3] |
         ecchmatrix[2][30]^sbits[2] |
         ecchmatrix[1][30]^sbits[1] |
         ecchmatrix[0][30]^sbits[0]);
  assign biterr_wire[29] = ~(
         ecchmatrix[5][29]^sbits[5] |
         ecchmatrix[4][29]^sbits[4] |
         ecchmatrix[3][29]^sbits[3] |
         ecchmatrix[2][29]^sbits[2] |
         ecchmatrix[1][29]^sbits[1] |
         ecchmatrix[0][29]^sbits[0]);
  assign biterr_wire[28] = ~(
         ecchmatrix[5][28]^sbits[5] |
         ecchmatrix[4][28]^sbits[4] |
         ecchmatrix[3][28]^sbits[3] |
         ecchmatrix[2][28]^sbits[2] |
         ecchmatrix[1][28]^sbits[1] |
         ecchmatrix[0][28]^sbits[0]);
  assign biterr_wire[27] = ~(
         ecchmatrix[5][27]^sbits[5] |
         ecchmatrix[4][27]^sbits[4] |
         ecchmatrix[3][27]^sbits[3] |
         ecchmatrix[2][27]^sbits[2] |
         ecchmatrix[1][27]^sbits[1] |
         ecchmatrix[0][27]^sbits[0]);
  assign biterr_wire[26] = ~(
         ecchmatrix[5][26]^sbits[5] |
         ecchmatrix[4][26]^sbits[4] |
         ecchmatrix[3][26]^sbits[3] |
         ecchmatrix[2][26]^sbits[2] |
         ecchmatrix[1][26]^sbits[1] |
         ecchmatrix[0][26]^sbits[0]);
  assign biterr_wire[25] = ~(
         ecchmatrix[5][25]^sbits[5] |
         ecchmatrix[4][25]^sbits[4] |
         ecchmatrix[3][25]^sbits[3] |
         ecchmatrix[2][25]^sbits[2] |
         ecchmatrix[1][25]^sbits[1] |
         ecchmatrix[0][25]^sbits[0]);
  assign biterr_wire[24] = ~(
         ecchmatrix[5][24]^sbits[5] |
         ecchmatrix[4][24]^sbits[4] |
         ecchmatrix[3][24]^sbits[3] |
         ecchmatrix[2][24]^sbits[2] |
         ecchmatrix[1][24]^sbits[1] |
         ecchmatrix[0][24]^sbits[0]);
  assign biterr_wire[23] = ~(
         ecchmatrix[5][23]^sbits[5] |
         ecchmatrix[4][23]^sbits[4] |
         ecchmatrix[3][23]^sbits[3] |
         ecchmatrix[2][23]^sbits[2] |
         ecchmatrix[1][23]^sbits[1] |
         ecchmatrix[0][23]^sbits[0]);
  assign biterr_wire[22] = ~(
         ecchmatrix[5][22]^sbits[5] |
         ecchmatrix[4][22]^sbits[4] |
         ecchmatrix[3][22]^sbits[3] |
         ecchmatrix[2][22]^sbits[2] |
         ecchmatrix[1][22]^sbits[1] |
         ecchmatrix[0][22]^sbits[0]);
  assign biterr_wire[21] = ~(
         ecchmatrix[5][21]^sbits[5] |
         ecchmatrix[4][21]^sbits[4] |
         ecchmatrix[3][21]^sbits[3] |
         ecchmatrix[2][21]^sbits[2] |
         ecchmatrix[1][21]^sbits[1] |
         ecchmatrix[0][21]^sbits[0]);
  assign biterr_wire[20] = ~(
         ecchmatrix[5][20]^sbits[5] |
         ecchmatrix[4][20]^sbits[4] |
         ecchmatrix[3][20]^sbits[3] |
         ecchmatrix[2][20]^sbits[2] |
         ecchmatrix[1][20]^sbits[1] |
         ecchmatrix[0][20]^sbits[0]);
  assign biterr_wire[19] = ~(
         ecchmatrix[5][19]^sbits[5] |
         ecchmatrix[4][19]^sbits[4] |
         ecchmatrix[3][19]^sbits[3] |
         ecchmatrix[2][19]^sbits[2] |
         ecchmatrix[1][19]^sbits[1] |
         ecchmatrix[0][19]^sbits[0]);
  assign biterr_wire[18] = ~(
         ecchmatrix[5][18]^sbits[5] |
         ecchmatrix[4][18]^sbits[4] |
         ecchmatrix[3][18]^sbits[3] |
         ecchmatrix[2][18]^sbits[2] |
         ecchmatrix[1][18]^sbits[1] |
         ecchmatrix[0][18]^sbits[0]);
  assign biterr_wire[17] = ~(
         ecchmatrix[5][17]^sbits[5] |
         ecchmatrix[4][17]^sbits[4] |
         ecchmatrix[3][17]^sbits[3] |
         ecchmatrix[2][17]^sbits[2] |
         ecchmatrix[1][17]^sbits[1] |
         ecchmatrix[0][17]^sbits[0]);
  assign biterr_wire[16] = ~(
         ecchmatrix[5][16]^sbits[5] |
         ecchmatrix[4][16]^sbits[4] |
         ecchmatrix[3][16]^sbits[3] |
         ecchmatrix[2][16]^sbits[2] |
         ecchmatrix[1][16]^sbits[1] |
         ecchmatrix[0][16]^sbits[0]);
  assign biterr_wire[15] = ~(
         ecchmatrix[5][15]^sbits[5] |
         ecchmatrix[4][15]^sbits[4] |
         ecchmatrix[3][15]^sbits[3] |
         ecchmatrix[2][15]^sbits[2] |
         ecchmatrix[1][15]^sbits[1] |
         ecchmatrix[0][15]^sbits[0]);
  assign biterr_wire[14] = ~(
         ecchmatrix[5][14]^sbits[5] |
         ecchmatrix[4][14]^sbits[4] |
         ecchmatrix[3][14]^sbits[3] |
         ecchmatrix[2][14]^sbits[2] |
         ecchmatrix[1][14]^sbits[1] |
         ecchmatrix[0][14]^sbits[0]);
  assign biterr_wire[13] = ~(
         ecchmatrix[5][13]^sbits[5] |
         ecchmatrix[4][13]^sbits[4] |
         ecchmatrix[3][13]^sbits[3] |
         ecchmatrix[2][13]^sbits[2] |
         ecchmatrix[1][13]^sbits[1] |
         ecchmatrix[0][13]^sbits[0]);
  assign biterr_wire[12] = ~(
         ecchmatrix[5][12]^sbits[5] |
         ecchmatrix[4][12]^sbits[4] |
         ecchmatrix[3][12]^sbits[3] |
         ecchmatrix[2][12]^sbits[2] |
         ecchmatrix[1][12]^sbits[1] |
         ecchmatrix[0][12]^sbits[0]);
  assign biterr_wire[11] = ~(
         ecchmatrix[5][11]^sbits[5] |
         ecchmatrix[4][11]^sbits[4] |
         ecchmatrix[3][11]^sbits[3] |
         ecchmatrix[2][11]^sbits[2] |
         ecchmatrix[1][11]^sbits[1] |
         ecchmatrix[0][11]^sbits[0]);
  assign biterr_wire[10] = ~(
         ecchmatrix[5][10]^sbits[5] |
         ecchmatrix[4][10]^sbits[4] |
         ecchmatrix[3][10]^sbits[3] |
         ecchmatrix[2][10]^sbits[2] |
         ecchmatrix[1][10]^sbits[1] |
         ecchmatrix[0][10]^sbits[0]);
  assign biterr_wire[9] = ~(
         ecchmatrix[5][9]^sbits[5] |
         ecchmatrix[4][9]^sbits[4] |
         ecchmatrix[3][9]^sbits[3] |
         ecchmatrix[2][9]^sbits[2] |
         ecchmatrix[1][9]^sbits[1] |
         ecchmatrix[0][9]^sbits[0]);
  assign biterr_wire[8] = ~(
         ecchmatrix[5][8]^sbits[5] |
         ecchmatrix[4][8]^sbits[4] |
         ecchmatrix[3][8]^sbits[3] |
         ecchmatrix[2][8]^sbits[2] |
         ecchmatrix[1][8]^sbits[1] |
         ecchmatrix[0][8]^sbits[0]);
  assign biterr_wire[7] = ~(
         ecchmatrix[5][7]^sbits[5] |
         ecchmatrix[4][7]^sbits[4] |
         ecchmatrix[3][7]^sbits[3] |
         ecchmatrix[2][7]^sbits[2] |
         ecchmatrix[1][7]^sbits[1] |
         ecchmatrix[0][7]^sbits[0]);
  assign biterr_wire[6] = ~(
         ecchmatrix[5][6]^sbits[5] |
         ecchmatrix[4][6]^sbits[4] |
         ecchmatrix[3][6]^sbits[3] |
         ecchmatrix[2][6]^sbits[2] |
         ecchmatrix[1][6]^sbits[1] |
         ecchmatrix[0][6]^sbits[0]);
  assign biterr_wire[5] = ~(
         ecchmatrix[5][5]^sbits[5] |
         ecchmatrix[4][5]^sbits[4] |
         ecchmatrix[3][5]^sbits[3] |
         ecchmatrix[2][5]^sbits[2] |
         ecchmatrix[1][5]^sbits[1] |
         ecchmatrix[0][5]^sbits[0]);
  assign biterr_wire[4] = ~(
         ecchmatrix[5][4]^sbits[5] |
         ecchmatrix[4][4]^sbits[4] |
         ecchmatrix[3][4]^sbits[3] |
         ecchmatrix[2][4]^sbits[2] |
         ecchmatrix[1][4]^sbits[1] |
         ecchmatrix[0][4]^sbits[0]);
  assign biterr_wire[3] = ~(
         ecchmatrix[5][3]^sbits[5] |
         ecchmatrix[4][3]^sbits[4] |
         ecchmatrix[3][3]^sbits[3] |
         ecchmatrix[2][3]^sbits[2] |
         ecchmatrix[1][3]^sbits[1] |
         ecchmatrix[0][3]^sbits[0]);
  assign biterr_wire[2] = ~(
         ecchmatrix[5][2]^sbits[5] |
         ecchmatrix[4][2]^sbits[4] |
         ecchmatrix[3][2]^sbits[3] |
         ecchmatrix[2][2]^sbits[2] |
         ecchmatrix[1][2]^sbits[1] |
         ecchmatrix[0][2]^sbits[0]);
  assign biterr_wire[1] = ~(
         ecchmatrix[5][1]^sbits[5] |
         ecchmatrix[4][1]^sbits[4] |
         ecchmatrix[3][1]^sbits[3] |
         ecchmatrix[2][1]^sbits[2] |
         ecchmatrix[1][1]^sbits[1] |
         ecchmatrix[0][1]^sbits[0]);
  assign biterr_wire[0] = ~(
         ecchmatrix[5][0]^sbits[5] |
         ecchmatrix[4][0]^sbits[4] |
         ecchmatrix[3][0]^sbits[3] |
         ecchmatrix[2][0]^sbits[2] |
         ecchmatrix[1][0]^sbits[1] |
         ecchmatrix[0][0]^sbits[0]);

  wire [ECCDWIDTH+ECCWIDTH-1:0]   biterr;
  wire [ECCDWIDTH-1:0]	din_f2;
  wire [ECCWIDTH-1:0]   sbits_f2;
  generate if(FLOPECC2) begin
	reg [ECCDWIDTH+ECCWIDTH-1:0]   biterr_reg;
	reg [ECCDWIDTH-1:0]	din_f2_reg;
	reg [ECCWIDTH-1:0] sbits_f2_reg;
	always @(posedge clk) begin
		biterr_reg <= biterr_wire;
		din_f2_reg <= din_f1;
		sbits_f2_reg <= sbits;
	end
	assign biterr = biterr_reg;
	assign din_f2 = din_f2_reg;
	assign sbits_f2 = sbits_f2_reg;
  end else begin
	assign biterr = biterr_wire;
	assign din_f2 = din_f1;
	assign sbits_f2 = sbits;
  end
  endgenerate
		 
 assign  dout    = din_f2 ^ biterr;
 assign  sec_err = |biterr;
 assign  ded_err = |sbits_f2 & ~|biterr;

endmodule

module ecc_check_57 #(parameter FLOPECC1=0, parameter FLOPECC2=0) (din,  eccin, dout, sec_err, ded_err, clk, rst);

  localparam ECCDWIDTH = 57;
  localparam ECCWIDTH  = 7;
  
  input [ECCDWIDTH-1:0]            din;  
  input [ECCWIDTH-1:0]             eccin;

  output [ECCDWIDTH-1:0]           dout;  
  output                           sec_err; // asserted if a single error is detected/corrected
  output                           ded_err; // asserted if two errors are detected

  input                            clk;
  input                            rst;

  wire       sec_err;
  wire       ded_err;
  wire [ECCDWIDTH-1:0]      dout;
  
  wire [ECCDWIDTH+ECCWIDTH-1:0]   ecchmatrix [0:ECCWIDTH-1];
  wire [ECCWIDTH-1:0]    sbits_wire;

  wire [ECCDWIDTH+ECCWIDTH-1:0]   biterr_wire;

// Generate the H Matrix in Perl

   assign ecchmatrix[0][0] = 1;
   assign ecchmatrix[1][0] = 1;
   assign ecchmatrix[2][0] = 1;
   assign ecchmatrix[3][0] = 0;
   assign ecchmatrix[4][0] = 0;
   assign ecchmatrix[5][0] = 0;
   assign ecchmatrix[6][0] = 0;
   assign ecchmatrix[0][1] = 1;
   assign ecchmatrix[1][1] = 1;
   assign ecchmatrix[2][1] = 0;
   assign ecchmatrix[3][1] = 1;
   assign ecchmatrix[4][1] = 0;
   assign ecchmatrix[5][1] = 0;
   assign ecchmatrix[6][1] = 0;
   assign ecchmatrix[0][2] = 1;
   assign ecchmatrix[1][2] = 1;
   assign ecchmatrix[2][2] = 0;
   assign ecchmatrix[3][2] = 0;
   assign ecchmatrix[4][2] = 1;
   assign ecchmatrix[5][2] = 0;
   assign ecchmatrix[6][2] = 0;
   assign ecchmatrix[0][3] = 1;
   assign ecchmatrix[1][3] = 1;
   assign ecchmatrix[2][3] = 0;
   assign ecchmatrix[3][3] = 0;
   assign ecchmatrix[4][3] = 0;
   assign ecchmatrix[5][3] = 1;
   assign ecchmatrix[6][3] = 0;
   assign ecchmatrix[0][4] = 1;
   assign ecchmatrix[1][4] = 1;
   assign ecchmatrix[2][4] = 0;
   assign ecchmatrix[3][4] = 0;
   assign ecchmatrix[4][4] = 0;
   assign ecchmatrix[5][4] = 0;
   assign ecchmatrix[6][4] = 1;
   assign ecchmatrix[0][5] = 1;
   assign ecchmatrix[1][5] = 0;
   assign ecchmatrix[2][5] = 1;
   assign ecchmatrix[3][5] = 1;
   assign ecchmatrix[4][5] = 0;
   assign ecchmatrix[5][5] = 0;
   assign ecchmatrix[6][5] = 0;
   assign ecchmatrix[0][6] = 1;
   assign ecchmatrix[1][6] = 0;
   assign ecchmatrix[2][6] = 1;
   assign ecchmatrix[3][6] = 0;
   assign ecchmatrix[4][6] = 1;
   assign ecchmatrix[5][6] = 0;
   assign ecchmatrix[6][6] = 0;
   assign ecchmatrix[0][7] = 1;
   assign ecchmatrix[1][7] = 0;
   assign ecchmatrix[2][7] = 1;
   assign ecchmatrix[3][7] = 0;
   assign ecchmatrix[4][7] = 0;
   assign ecchmatrix[5][7] = 1;
   assign ecchmatrix[6][7] = 0;
   assign ecchmatrix[0][8] = 1;
   assign ecchmatrix[1][8] = 0;
   assign ecchmatrix[2][8] = 1;
   assign ecchmatrix[3][8] = 0;
   assign ecchmatrix[4][8] = 0;
   assign ecchmatrix[5][8] = 0;
   assign ecchmatrix[6][8] = 1;
   assign ecchmatrix[0][9] = 1;
   assign ecchmatrix[1][9] = 0;
   assign ecchmatrix[2][9] = 0;
   assign ecchmatrix[3][9] = 1;
   assign ecchmatrix[4][9] = 1;
   assign ecchmatrix[5][9] = 0;
   assign ecchmatrix[6][9] = 0;
   assign ecchmatrix[0][10] = 1;
   assign ecchmatrix[1][10] = 0;
   assign ecchmatrix[2][10] = 0;
   assign ecchmatrix[3][10] = 1;
   assign ecchmatrix[4][10] = 0;
   assign ecchmatrix[5][10] = 1;
   assign ecchmatrix[6][10] = 0;
   assign ecchmatrix[0][11] = 1;
   assign ecchmatrix[1][11] = 0;
   assign ecchmatrix[2][11] = 0;
   assign ecchmatrix[3][11] = 1;
   assign ecchmatrix[4][11] = 0;
   assign ecchmatrix[5][11] = 0;
   assign ecchmatrix[6][11] = 1;
   assign ecchmatrix[0][12] = 1;
   assign ecchmatrix[1][12] = 0;
   assign ecchmatrix[2][12] = 0;
   assign ecchmatrix[3][12] = 0;
   assign ecchmatrix[4][12] = 1;
   assign ecchmatrix[5][12] = 1;
   assign ecchmatrix[6][12] = 0;
   assign ecchmatrix[0][13] = 1;
   assign ecchmatrix[1][13] = 0;
   assign ecchmatrix[2][13] = 0;
   assign ecchmatrix[3][13] = 0;
   assign ecchmatrix[4][13] = 1;
   assign ecchmatrix[5][13] = 0;
   assign ecchmatrix[6][13] = 1;
   assign ecchmatrix[0][14] = 1;
   assign ecchmatrix[1][14] = 0;
   assign ecchmatrix[2][14] = 0;
   assign ecchmatrix[3][14] = 0;
   assign ecchmatrix[4][14] = 0;
   assign ecchmatrix[5][14] = 1;
   assign ecchmatrix[6][14] = 1;
   assign ecchmatrix[0][15] = 0;
   assign ecchmatrix[1][15] = 1;
   assign ecchmatrix[2][15] = 1;
   assign ecchmatrix[3][15] = 1;
   assign ecchmatrix[4][15] = 0;
   assign ecchmatrix[5][15] = 0;
   assign ecchmatrix[6][15] = 0;
   assign ecchmatrix[0][16] = 0;
   assign ecchmatrix[1][16] = 1;
   assign ecchmatrix[2][16] = 1;
   assign ecchmatrix[3][16] = 0;
   assign ecchmatrix[4][16] = 1;
   assign ecchmatrix[5][16] = 0;
   assign ecchmatrix[6][16] = 0;
   assign ecchmatrix[0][17] = 0;
   assign ecchmatrix[1][17] = 1;
   assign ecchmatrix[2][17] = 1;
   assign ecchmatrix[3][17] = 0;
   assign ecchmatrix[4][17] = 0;
   assign ecchmatrix[5][17] = 1;
   assign ecchmatrix[6][17] = 0;
   assign ecchmatrix[0][18] = 0;
   assign ecchmatrix[1][18] = 1;
   assign ecchmatrix[2][18] = 1;
   assign ecchmatrix[3][18] = 0;
   assign ecchmatrix[4][18] = 0;
   assign ecchmatrix[5][18] = 0;
   assign ecchmatrix[6][18] = 1;
   assign ecchmatrix[0][19] = 0;
   assign ecchmatrix[1][19] = 1;
   assign ecchmatrix[2][19] = 0;
   assign ecchmatrix[3][19] = 1;
   assign ecchmatrix[4][19] = 1;
   assign ecchmatrix[5][19] = 0;
   assign ecchmatrix[6][19] = 0;
   assign ecchmatrix[0][20] = 0;
   assign ecchmatrix[1][20] = 1;
   assign ecchmatrix[2][20] = 0;
   assign ecchmatrix[3][20] = 1;
   assign ecchmatrix[4][20] = 0;
   assign ecchmatrix[5][20] = 1;
   assign ecchmatrix[6][20] = 0;
   assign ecchmatrix[0][21] = 0;
   assign ecchmatrix[1][21] = 1;
   assign ecchmatrix[2][21] = 0;
   assign ecchmatrix[3][21] = 1;
   assign ecchmatrix[4][21] = 0;
   assign ecchmatrix[5][21] = 0;
   assign ecchmatrix[6][21] = 1;
   assign ecchmatrix[0][22] = 0;
   assign ecchmatrix[1][22] = 1;
   assign ecchmatrix[2][22] = 0;
   assign ecchmatrix[3][22] = 0;
   assign ecchmatrix[4][22] = 1;
   assign ecchmatrix[5][22] = 1;
   assign ecchmatrix[6][22] = 0;
   assign ecchmatrix[0][23] = 0;
   assign ecchmatrix[1][23] = 1;
   assign ecchmatrix[2][23] = 0;
   assign ecchmatrix[3][23] = 0;
   assign ecchmatrix[4][23] = 1;
   assign ecchmatrix[5][23] = 0;
   assign ecchmatrix[6][23] = 1;
   assign ecchmatrix[0][24] = 0;
   assign ecchmatrix[1][24] = 1;
   assign ecchmatrix[2][24] = 0;
   assign ecchmatrix[3][24] = 0;
   assign ecchmatrix[4][24] = 0;
   assign ecchmatrix[5][24] = 1;
   assign ecchmatrix[6][24] = 1;
   assign ecchmatrix[0][25] = 0;
   assign ecchmatrix[1][25] = 0;
   assign ecchmatrix[2][25] = 1;
   assign ecchmatrix[3][25] = 1;
   assign ecchmatrix[4][25] = 1;
   assign ecchmatrix[5][25] = 0;
   assign ecchmatrix[6][25] = 0;
   assign ecchmatrix[0][26] = 0;
   assign ecchmatrix[1][26] = 0;
   assign ecchmatrix[2][26] = 1;
   assign ecchmatrix[3][26] = 1;
   assign ecchmatrix[4][26] = 0;
   assign ecchmatrix[5][26] = 1;
   assign ecchmatrix[6][26] = 0;
   assign ecchmatrix[0][27] = 0;
   assign ecchmatrix[1][27] = 0;
   assign ecchmatrix[2][27] = 1;
   assign ecchmatrix[3][27] = 1;
   assign ecchmatrix[4][27] = 0;
   assign ecchmatrix[5][27] = 0;
   assign ecchmatrix[6][27] = 1;
   assign ecchmatrix[0][28] = 0;
   assign ecchmatrix[1][28] = 0;
   assign ecchmatrix[2][28] = 1;
   assign ecchmatrix[3][28] = 0;
   assign ecchmatrix[4][28] = 1;
   assign ecchmatrix[5][28] = 1;
   assign ecchmatrix[6][28] = 0;
   assign ecchmatrix[0][29] = 0;
   assign ecchmatrix[1][29] = 0;
   assign ecchmatrix[2][29] = 1;
   assign ecchmatrix[3][29] = 0;
   assign ecchmatrix[4][29] = 1;
   assign ecchmatrix[5][29] = 0;
   assign ecchmatrix[6][29] = 1;
   assign ecchmatrix[0][30] = 0;
   assign ecchmatrix[1][30] = 0;
   assign ecchmatrix[2][30] = 1;
   assign ecchmatrix[3][30] = 0;
   assign ecchmatrix[4][30] = 0;
   assign ecchmatrix[5][30] = 1;
   assign ecchmatrix[6][30] = 1;
   assign ecchmatrix[0][31] = 0;
   assign ecchmatrix[1][31] = 0;
   assign ecchmatrix[2][31] = 0;
   assign ecchmatrix[3][31] = 1;
   assign ecchmatrix[4][31] = 1;
   assign ecchmatrix[5][31] = 1;
   assign ecchmatrix[6][31] = 0;
   assign ecchmatrix[0][32] = 0;
   assign ecchmatrix[1][32] = 0;
   assign ecchmatrix[2][32] = 0;
   assign ecchmatrix[3][32] = 1;
   assign ecchmatrix[4][32] = 1;
   assign ecchmatrix[5][32] = 0;
   assign ecchmatrix[6][32] = 1;
   assign ecchmatrix[0][33] = 0;
   assign ecchmatrix[1][33] = 0;
   assign ecchmatrix[2][33] = 0;
   assign ecchmatrix[3][33] = 1;
   assign ecchmatrix[4][33] = 0;
   assign ecchmatrix[5][33] = 1;
   assign ecchmatrix[6][33] = 1;
   assign ecchmatrix[0][34] = 0;
   assign ecchmatrix[1][34] = 0;
   assign ecchmatrix[2][34] = 0;
   assign ecchmatrix[3][34] = 0;
   assign ecchmatrix[4][34] = 1;
   assign ecchmatrix[5][34] = 1;
   assign ecchmatrix[6][34] = 1;
   assign ecchmatrix[0][35] = 1;
   assign ecchmatrix[1][35] = 1;
   assign ecchmatrix[2][35] = 1;
   assign ecchmatrix[3][35] = 1;
   assign ecchmatrix[4][35] = 1;
   assign ecchmatrix[5][35] = 0;
   assign ecchmatrix[6][35] = 0;
   assign ecchmatrix[0][36] = 1;
   assign ecchmatrix[1][36] = 1;
   assign ecchmatrix[2][36] = 1;
   assign ecchmatrix[3][36] = 1;
   assign ecchmatrix[4][36] = 0;
   assign ecchmatrix[5][36] = 1;
   assign ecchmatrix[6][36] = 0;
   assign ecchmatrix[0][37] = 1;
   assign ecchmatrix[1][37] = 1;
   assign ecchmatrix[2][37] = 1;
   assign ecchmatrix[3][37] = 1;
   assign ecchmatrix[4][37] = 0;
   assign ecchmatrix[5][37] = 0;
   assign ecchmatrix[6][37] = 1;
   assign ecchmatrix[0][38] = 1;
   assign ecchmatrix[1][38] = 1;
   assign ecchmatrix[2][38] = 1;
   assign ecchmatrix[3][38] = 0;
   assign ecchmatrix[4][38] = 1;
   assign ecchmatrix[5][38] = 1;
   assign ecchmatrix[6][38] = 0;
   assign ecchmatrix[0][39] = 1;
   assign ecchmatrix[1][39] = 1;
   assign ecchmatrix[2][39] = 1;
   assign ecchmatrix[3][39] = 0;
   assign ecchmatrix[4][39] = 1;
   assign ecchmatrix[5][39] = 0;
   assign ecchmatrix[6][39] = 1;
   assign ecchmatrix[0][40] = 1;
   assign ecchmatrix[1][40] = 1;
   assign ecchmatrix[2][40] = 1;
   assign ecchmatrix[3][40] = 0;
   assign ecchmatrix[4][40] = 0;
   assign ecchmatrix[5][40] = 1;
   assign ecchmatrix[6][40] = 1;
   assign ecchmatrix[0][41] = 1;
   assign ecchmatrix[1][41] = 1;
   assign ecchmatrix[2][41] = 0;
   assign ecchmatrix[3][41] = 1;
   assign ecchmatrix[4][41] = 1;
   assign ecchmatrix[5][41] = 1;
   assign ecchmatrix[6][41] = 0;
   assign ecchmatrix[0][42] = 1;
   assign ecchmatrix[1][42] = 1;
   assign ecchmatrix[2][42] = 0;
   assign ecchmatrix[3][42] = 1;
   assign ecchmatrix[4][42] = 1;
   assign ecchmatrix[5][42] = 0;
   assign ecchmatrix[6][42] = 1;
   assign ecchmatrix[0][43] = 1;
   assign ecchmatrix[1][43] = 1;
   assign ecchmatrix[2][43] = 0;
   assign ecchmatrix[3][43] = 1;
   assign ecchmatrix[4][43] = 0;
   assign ecchmatrix[5][43] = 1;
   assign ecchmatrix[6][43] = 1;
   assign ecchmatrix[0][44] = 1;
   assign ecchmatrix[1][44] = 1;
   assign ecchmatrix[2][44] = 0;
   assign ecchmatrix[3][44] = 0;
   assign ecchmatrix[4][44] = 1;
   assign ecchmatrix[5][44] = 1;
   assign ecchmatrix[6][44] = 1;
   assign ecchmatrix[0][45] = 1;
   assign ecchmatrix[1][45] = 0;
   assign ecchmatrix[2][45] = 1;
   assign ecchmatrix[3][45] = 1;
   assign ecchmatrix[4][45] = 1;
   assign ecchmatrix[5][45] = 1;
   assign ecchmatrix[6][45] = 0;
   assign ecchmatrix[0][46] = 1;
   assign ecchmatrix[1][46] = 0;
   assign ecchmatrix[2][46] = 1;
   assign ecchmatrix[3][46] = 1;
   assign ecchmatrix[4][46] = 1;
   assign ecchmatrix[5][46] = 0;
   assign ecchmatrix[6][46] = 1;
   assign ecchmatrix[0][47] = 1;
   assign ecchmatrix[1][47] = 0;
   assign ecchmatrix[2][47] = 1;
   assign ecchmatrix[3][47] = 1;
   assign ecchmatrix[4][47] = 0;
   assign ecchmatrix[5][47] = 1;
   assign ecchmatrix[6][47] = 1;
   assign ecchmatrix[0][48] = 1;
   assign ecchmatrix[1][48] = 0;
   assign ecchmatrix[2][48] = 1;
   assign ecchmatrix[3][48] = 0;
   assign ecchmatrix[4][48] = 1;
   assign ecchmatrix[5][48] = 1;
   assign ecchmatrix[6][48] = 1;
   assign ecchmatrix[0][49] = 1;
   assign ecchmatrix[1][49] = 0;
   assign ecchmatrix[2][49] = 0;
   assign ecchmatrix[3][49] = 1;
   assign ecchmatrix[4][49] = 1;
   assign ecchmatrix[5][49] = 1;
   assign ecchmatrix[6][49] = 1;
   assign ecchmatrix[0][50] = 0;
   assign ecchmatrix[1][50] = 1;
   assign ecchmatrix[2][50] = 1;
   assign ecchmatrix[3][50] = 1;
   assign ecchmatrix[4][50] = 1;
   assign ecchmatrix[5][50] = 1;
   assign ecchmatrix[6][50] = 0;
   assign ecchmatrix[0][51] = 0;
   assign ecchmatrix[1][51] = 1;
   assign ecchmatrix[2][51] = 1;
   assign ecchmatrix[3][51] = 1;
   assign ecchmatrix[4][51] = 1;
   assign ecchmatrix[5][51] = 0;
   assign ecchmatrix[6][51] = 1;
   assign ecchmatrix[0][52] = 0;
   assign ecchmatrix[1][52] = 1;
   assign ecchmatrix[2][52] = 1;
   assign ecchmatrix[3][52] = 1;
   assign ecchmatrix[4][52] = 0;
   assign ecchmatrix[5][52] = 1;
   assign ecchmatrix[6][52] = 1;
   assign ecchmatrix[0][53] = 0;
   assign ecchmatrix[1][53] = 1;
   assign ecchmatrix[2][53] = 1;
   assign ecchmatrix[3][53] = 0;
   assign ecchmatrix[4][53] = 1;
   assign ecchmatrix[5][53] = 1;
   assign ecchmatrix[6][53] = 1;
   assign ecchmatrix[0][54] = 0;
   assign ecchmatrix[1][54] = 1;
   assign ecchmatrix[2][54] = 0;
   assign ecchmatrix[3][54] = 1;
   assign ecchmatrix[4][54] = 1;
   assign ecchmatrix[5][54] = 1;
   assign ecchmatrix[6][54] = 1;
   assign ecchmatrix[0][55] = 0;
   assign ecchmatrix[1][55] = 0;
   assign ecchmatrix[2][55] = 1;
   assign ecchmatrix[3][55] = 1;
   assign ecchmatrix[4][55] = 1;
   assign ecchmatrix[5][55] = 1;
   assign ecchmatrix[6][55] = 1;
   assign ecchmatrix[0][56] = 1;
   assign ecchmatrix[1][56] = 1;
   assign ecchmatrix[2][56] = 1;
   assign ecchmatrix[3][56] = 1;
   assign ecchmatrix[4][56] = 1;
   assign ecchmatrix[5][56] = 1;
   assign ecchmatrix[6][56] = 1;
   assign ecchmatrix[0][57] = 1;
   assign ecchmatrix[1][57] = 0;
   assign ecchmatrix[2][57] = 0;
   assign ecchmatrix[3][57] = 0;
   assign ecchmatrix[4][57] = 0;
   assign ecchmatrix[5][57] = 0;
   assign ecchmatrix[6][57] = 0;
   assign ecchmatrix[0][58] = 0;
   assign ecchmatrix[1][58] = 1;
   assign ecchmatrix[2][58] = 0;
   assign ecchmatrix[3][58] = 0;
   assign ecchmatrix[4][58] = 0;
   assign ecchmatrix[5][58] = 0;
   assign ecchmatrix[6][58] = 0;
   assign ecchmatrix[0][59] = 0;
   assign ecchmatrix[1][59] = 0;
   assign ecchmatrix[2][59] = 1;
   assign ecchmatrix[3][59] = 0;
   assign ecchmatrix[4][59] = 0;
   assign ecchmatrix[5][59] = 0;
   assign ecchmatrix[6][59] = 0;
   assign ecchmatrix[0][60] = 0;
   assign ecchmatrix[1][60] = 0;
   assign ecchmatrix[2][60] = 0;
   assign ecchmatrix[3][60] = 1;
   assign ecchmatrix[4][60] = 0;
   assign ecchmatrix[5][60] = 0;
   assign ecchmatrix[6][60] = 0;
   assign ecchmatrix[0][61] = 0;
   assign ecchmatrix[1][61] = 0;
   assign ecchmatrix[2][61] = 0;
   assign ecchmatrix[3][61] = 0;
   assign ecchmatrix[4][61] = 1;
   assign ecchmatrix[5][61] = 0;
   assign ecchmatrix[6][61] = 0;
   assign ecchmatrix[0][62] = 0;
   assign ecchmatrix[1][62] = 0;
   assign ecchmatrix[2][62] = 0;
   assign ecchmatrix[3][62] = 0;
   assign ecchmatrix[4][62] = 0;
   assign ecchmatrix[5][62] = 1;
   assign ecchmatrix[6][62] = 0;
   assign ecchmatrix[0][63] = 0;
   assign ecchmatrix[1][63] = 0;
   assign ecchmatrix[2][63] = 0;
   assign ecchmatrix[3][63] = 0;
   assign ecchmatrix[4][63] = 0;
   assign ecchmatrix[5][63] = 0;
   assign ecchmatrix[6][63] = 1;


  assign sbits_wire[6] = (^(ecchmatrix[6]&din)) ^ eccin[6] ;
  assign sbits_wire[5] = (^(ecchmatrix[5]&din)) ^ eccin[5] ;
  assign sbits_wire[4] = (^(ecchmatrix[4]&din)) ^ eccin[4] ;
  assign sbits_wire[3] = (^(ecchmatrix[3]&din)) ^ eccin[3] ;
  assign sbits_wire[2] = (^(ecchmatrix[2]&din)) ^ eccin[2] ;
  assign sbits_wire[1] = (^(ecchmatrix[1]&din)) ^ eccin[1] ;
  assign sbits_wire[0] = (^(ecchmatrix[0]&din)) ^ eccin[0] ;

  wire [ECCWIDTH-1:0]    sbits;
  wire [ECCDWIDTH-1:0]	din_f1;
  generate if(FLOPECC1) begin
	reg [ECCWIDTH-1:0]    sbits_reg;
	reg [ECCDWIDTH-1:0]	din_f1_reg;
	always @(posedge clk) begin
		sbits_reg <= sbits_wire;
		din_f1_reg <= din;
	end
	assign sbits = sbits_reg;
	assign din_f1 = din_f1_reg;
  end else begin
	assign sbits = sbits_wire;
	assign din_f1 = din;
  end
  endgenerate
  
  assign biterr_wire[63] = ~(
         ecchmatrix[6][63]^sbits[6] |
         ecchmatrix[5][63]^sbits[5] |
         ecchmatrix[4][63]^sbits[4] |
         ecchmatrix[3][63]^sbits[3] |
         ecchmatrix[2][63]^sbits[2] |
         ecchmatrix[1][63]^sbits[1] |
         ecchmatrix[0][63]^sbits[0]);
  assign biterr_wire[62] = ~(
         ecchmatrix[6][62]^sbits[6] |
         ecchmatrix[5][62]^sbits[5] |
         ecchmatrix[4][62]^sbits[4] |
         ecchmatrix[3][62]^sbits[3] |
         ecchmatrix[2][62]^sbits[2] |
         ecchmatrix[1][62]^sbits[1] |
         ecchmatrix[0][62]^sbits[0]);
  assign biterr_wire[61] = ~(
         ecchmatrix[6][61]^sbits[6] |
         ecchmatrix[5][61]^sbits[5] |
         ecchmatrix[4][61]^sbits[4] |
         ecchmatrix[3][61]^sbits[3] |
         ecchmatrix[2][61]^sbits[2] |
         ecchmatrix[1][61]^sbits[1] |
         ecchmatrix[0][61]^sbits[0]);
  assign biterr_wire[60] = ~(
         ecchmatrix[6][60]^sbits[6] |
         ecchmatrix[5][60]^sbits[5] |
         ecchmatrix[4][60]^sbits[4] |
         ecchmatrix[3][60]^sbits[3] |
         ecchmatrix[2][60]^sbits[2] |
         ecchmatrix[1][60]^sbits[1] |
         ecchmatrix[0][60]^sbits[0]);
  assign biterr_wire[59] = ~(
         ecchmatrix[6][59]^sbits[6] |
         ecchmatrix[5][59]^sbits[5] |
         ecchmatrix[4][59]^sbits[4] |
         ecchmatrix[3][59]^sbits[3] |
         ecchmatrix[2][59]^sbits[2] |
         ecchmatrix[1][59]^sbits[1] |
         ecchmatrix[0][59]^sbits[0]);
  assign biterr_wire[58] = ~(
         ecchmatrix[6][58]^sbits[6] |
         ecchmatrix[5][58]^sbits[5] |
         ecchmatrix[4][58]^sbits[4] |
         ecchmatrix[3][58]^sbits[3] |
         ecchmatrix[2][58]^sbits[2] |
         ecchmatrix[1][58]^sbits[1] |
         ecchmatrix[0][58]^sbits[0]);
  assign biterr_wire[57] = ~(
         ecchmatrix[6][57]^sbits[6] |
         ecchmatrix[5][57]^sbits[5] |
         ecchmatrix[4][57]^sbits[4] |
         ecchmatrix[3][57]^sbits[3] |
         ecchmatrix[2][57]^sbits[2] |
         ecchmatrix[1][57]^sbits[1] |
         ecchmatrix[0][57]^sbits[0]);
  assign biterr_wire[56] = ~(
         ecchmatrix[6][56]^sbits[6] |
         ecchmatrix[5][56]^sbits[5] |
         ecchmatrix[4][56]^sbits[4] |
         ecchmatrix[3][56]^sbits[3] |
         ecchmatrix[2][56]^sbits[2] |
         ecchmatrix[1][56]^sbits[1] |
         ecchmatrix[0][56]^sbits[0]);
  assign biterr_wire[55] = ~(
         ecchmatrix[6][55]^sbits[6] |
         ecchmatrix[5][55]^sbits[5] |
         ecchmatrix[4][55]^sbits[4] |
         ecchmatrix[3][55]^sbits[3] |
         ecchmatrix[2][55]^sbits[2] |
         ecchmatrix[1][55]^sbits[1] |
         ecchmatrix[0][55]^sbits[0]);
  assign biterr_wire[54] = ~(
         ecchmatrix[6][54]^sbits[6] |
         ecchmatrix[5][54]^sbits[5] |
         ecchmatrix[4][54]^sbits[4] |
         ecchmatrix[3][54]^sbits[3] |
         ecchmatrix[2][54]^sbits[2] |
         ecchmatrix[1][54]^sbits[1] |
         ecchmatrix[0][54]^sbits[0]);
  assign biterr_wire[53] = ~(
         ecchmatrix[6][53]^sbits[6] |
         ecchmatrix[5][53]^sbits[5] |
         ecchmatrix[4][53]^sbits[4] |
         ecchmatrix[3][53]^sbits[3] |
         ecchmatrix[2][53]^sbits[2] |
         ecchmatrix[1][53]^sbits[1] |
         ecchmatrix[0][53]^sbits[0]);
  assign biterr_wire[52] = ~(
         ecchmatrix[6][52]^sbits[6] |
         ecchmatrix[5][52]^sbits[5] |
         ecchmatrix[4][52]^sbits[4] |
         ecchmatrix[3][52]^sbits[3] |
         ecchmatrix[2][52]^sbits[2] |
         ecchmatrix[1][52]^sbits[1] |
         ecchmatrix[0][52]^sbits[0]);
  assign biterr_wire[51] = ~(
         ecchmatrix[6][51]^sbits[6] |
         ecchmatrix[5][51]^sbits[5] |
         ecchmatrix[4][51]^sbits[4] |
         ecchmatrix[3][51]^sbits[3] |
         ecchmatrix[2][51]^sbits[2] |
         ecchmatrix[1][51]^sbits[1] |
         ecchmatrix[0][51]^sbits[0]);
  assign biterr_wire[50] = ~(
         ecchmatrix[6][50]^sbits[6] |
         ecchmatrix[5][50]^sbits[5] |
         ecchmatrix[4][50]^sbits[4] |
         ecchmatrix[3][50]^sbits[3] |
         ecchmatrix[2][50]^sbits[2] |
         ecchmatrix[1][50]^sbits[1] |
         ecchmatrix[0][50]^sbits[0]);
  assign biterr_wire[49] = ~(
         ecchmatrix[6][49]^sbits[6] |
         ecchmatrix[5][49]^sbits[5] |
         ecchmatrix[4][49]^sbits[4] |
         ecchmatrix[3][49]^sbits[3] |
         ecchmatrix[2][49]^sbits[2] |
         ecchmatrix[1][49]^sbits[1] |
         ecchmatrix[0][49]^sbits[0]);
  assign biterr_wire[48] = ~(
         ecchmatrix[6][48]^sbits[6] |
         ecchmatrix[5][48]^sbits[5] |
         ecchmatrix[4][48]^sbits[4] |
         ecchmatrix[3][48]^sbits[3] |
         ecchmatrix[2][48]^sbits[2] |
         ecchmatrix[1][48]^sbits[1] |
         ecchmatrix[0][48]^sbits[0]);
  assign biterr_wire[47] = ~(
         ecchmatrix[6][47]^sbits[6] |
         ecchmatrix[5][47]^sbits[5] |
         ecchmatrix[4][47]^sbits[4] |
         ecchmatrix[3][47]^sbits[3] |
         ecchmatrix[2][47]^sbits[2] |
         ecchmatrix[1][47]^sbits[1] |
         ecchmatrix[0][47]^sbits[0]);
  assign biterr_wire[46] = ~(
         ecchmatrix[6][46]^sbits[6] |
         ecchmatrix[5][46]^sbits[5] |
         ecchmatrix[4][46]^sbits[4] |
         ecchmatrix[3][46]^sbits[3] |
         ecchmatrix[2][46]^sbits[2] |
         ecchmatrix[1][46]^sbits[1] |
         ecchmatrix[0][46]^sbits[0]);
  assign biterr_wire[45] = ~(
         ecchmatrix[6][45]^sbits[6] |
         ecchmatrix[5][45]^sbits[5] |
         ecchmatrix[4][45]^sbits[4] |
         ecchmatrix[3][45]^sbits[3] |
         ecchmatrix[2][45]^sbits[2] |
         ecchmatrix[1][45]^sbits[1] |
         ecchmatrix[0][45]^sbits[0]);
  assign biterr_wire[44] = ~(
         ecchmatrix[6][44]^sbits[6] |
         ecchmatrix[5][44]^sbits[5] |
         ecchmatrix[4][44]^sbits[4] |
         ecchmatrix[3][44]^sbits[3] |
         ecchmatrix[2][44]^sbits[2] |
         ecchmatrix[1][44]^sbits[1] |
         ecchmatrix[0][44]^sbits[0]);
  assign biterr_wire[43] = ~(
         ecchmatrix[6][43]^sbits[6] |
         ecchmatrix[5][43]^sbits[5] |
         ecchmatrix[4][43]^sbits[4] |
         ecchmatrix[3][43]^sbits[3] |
         ecchmatrix[2][43]^sbits[2] |
         ecchmatrix[1][43]^sbits[1] |
         ecchmatrix[0][43]^sbits[0]);
  assign biterr_wire[42] = ~(
         ecchmatrix[6][42]^sbits[6] |
         ecchmatrix[5][42]^sbits[5] |
         ecchmatrix[4][42]^sbits[4] |
         ecchmatrix[3][42]^sbits[3] |
         ecchmatrix[2][42]^sbits[2] |
         ecchmatrix[1][42]^sbits[1] |
         ecchmatrix[0][42]^sbits[0]);
  assign biterr_wire[41] = ~(
         ecchmatrix[6][41]^sbits[6] |
         ecchmatrix[5][41]^sbits[5] |
         ecchmatrix[4][41]^sbits[4] |
         ecchmatrix[3][41]^sbits[3] |
         ecchmatrix[2][41]^sbits[2] |
         ecchmatrix[1][41]^sbits[1] |
         ecchmatrix[0][41]^sbits[0]);
  assign biterr_wire[40] = ~(
         ecchmatrix[6][40]^sbits[6] |
         ecchmatrix[5][40]^sbits[5] |
         ecchmatrix[4][40]^sbits[4] |
         ecchmatrix[3][40]^sbits[3] |
         ecchmatrix[2][40]^sbits[2] |
         ecchmatrix[1][40]^sbits[1] |
         ecchmatrix[0][40]^sbits[0]);
  assign biterr_wire[39] = ~(
         ecchmatrix[6][39]^sbits[6] |
         ecchmatrix[5][39]^sbits[5] |
         ecchmatrix[4][39]^sbits[4] |
         ecchmatrix[3][39]^sbits[3] |
         ecchmatrix[2][39]^sbits[2] |
         ecchmatrix[1][39]^sbits[1] |
         ecchmatrix[0][39]^sbits[0]);
  assign biterr_wire[38] = ~(
         ecchmatrix[6][38]^sbits[6] |
         ecchmatrix[5][38]^sbits[5] |
         ecchmatrix[4][38]^sbits[4] |
         ecchmatrix[3][38]^sbits[3] |
         ecchmatrix[2][38]^sbits[2] |
         ecchmatrix[1][38]^sbits[1] |
         ecchmatrix[0][38]^sbits[0]);
  assign biterr_wire[37] = ~(
         ecchmatrix[6][37]^sbits[6] |
         ecchmatrix[5][37]^sbits[5] |
         ecchmatrix[4][37]^sbits[4] |
         ecchmatrix[3][37]^sbits[3] |
         ecchmatrix[2][37]^sbits[2] |
         ecchmatrix[1][37]^sbits[1] |
         ecchmatrix[0][37]^sbits[0]);
  assign biterr_wire[36] = ~(
         ecchmatrix[6][36]^sbits[6] |
         ecchmatrix[5][36]^sbits[5] |
         ecchmatrix[4][36]^sbits[4] |
         ecchmatrix[3][36]^sbits[3] |
         ecchmatrix[2][36]^sbits[2] |
         ecchmatrix[1][36]^sbits[1] |
         ecchmatrix[0][36]^sbits[0]);
  assign biterr_wire[35] = ~(
         ecchmatrix[6][35]^sbits[6] |
         ecchmatrix[5][35]^sbits[5] |
         ecchmatrix[4][35]^sbits[4] |
         ecchmatrix[3][35]^sbits[3] |
         ecchmatrix[2][35]^sbits[2] |
         ecchmatrix[1][35]^sbits[1] |
         ecchmatrix[0][35]^sbits[0]);
  assign biterr_wire[34] = ~(
         ecchmatrix[6][34]^sbits[6] |
         ecchmatrix[5][34]^sbits[5] |
         ecchmatrix[4][34]^sbits[4] |
         ecchmatrix[3][34]^sbits[3] |
         ecchmatrix[2][34]^sbits[2] |
         ecchmatrix[1][34]^sbits[1] |
         ecchmatrix[0][34]^sbits[0]);
  assign biterr_wire[33] = ~(
         ecchmatrix[6][33]^sbits[6] |
         ecchmatrix[5][33]^sbits[5] |
         ecchmatrix[4][33]^sbits[4] |
         ecchmatrix[3][33]^sbits[3] |
         ecchmatrix[2][33]^sbits[2] |
         ecchmatrix[1][33]^sbits[1] |
         ecchmatrix[0][33]^sbits[0]);
  assign biterr_wire[32] = ~(
         ecchmatrix[6][32]^sbits[6] |
         ecchmatrix[5][32]^sbits[5] |
         ecchmatrix[4][32]^sbits[4] |
         ecchmatrix[3][32]^sbits[3] |
         ecchmatrix[2][32]^sbits[2] |
         ecchmatrix[1][32]^sbits[1] |
         ecchmatrix[0][32]^sbits[0]);
  assign biterr_wire[31] = ~(
         ecchmatrix[6][31]^sbits[6] |
         ecchmatrix[5][31]^sbits[5] |
         ecchmatrix[4][31]^sbits[4] |
         ecchmatrix[3][31]^sbits[3] |
         ecchmatrix[2][31]^sbits[2] |
         ecchmatrix[1][31]^sbits[1] |
         ecchmatrix[0][31]^sbits[0]);
  assign biterr_wire[30] = ~(
         ecchmatrix[6][30]^sbits[6] |
         ecchmatrix[5][30]^sbits[5] |
         ecchmatrix[4][30]^sbits[4] |
         ecchmatrix[3][30]^sbits[3] |
         ecchmatrix[2][30]^sbits[2] |
         ecchmatrix[1][30]^sbits[1] |
         ecchmatrix[0][30]^sbits[0]);
  assign biterr_wire[29] = ~(
         ecchmatrix[6][29]^sbits[6] |
         ecchmatrix[5][29]^sbits[5] |
         ecchmatrix[4][29]^sbits[4] |
         ecchmatrix[3][29]^sbits[3] |
         ecchmatrix[2][29]^sbits[2] |
         ecchmatrix[1][29]^sbits[1] |
         ecchmatrix[0][29]^sbits[0]);
  assign biterr_wire[28] = ~(
         ecchmatrix[6][28]^sbits[6] |
         ecchmatrix[5][28]^sbits[5] |
         ecchmatrix[4][28]^sbits[4] |
         ecchmatrix[3][28]^sbits[3] |
         ecchmatrix[2][28]^sbits[2] |
         ecchmatrix[1][28]^sbits[1] |
         ecchmatrix[0][28]^sbits[0]);
  assign biterr_wire[27] = ~(
         ecchmatrix[6][27]^sbits[6] |
         ecchmatrix[5][27]^sbits[5] |
         ecchmatrix[4][27]^sbits[4] |
         ecchmatrix[3][27]^sbits[3] |
         ecchmatrix[2][27]^sbits[2] |
         ecchmatrix[1][27]^sbits[1] |
         ecchmatrix[0][27]^sbits[0]);
  assign biterr_wire[26] = ~(
         ecchmatrix[6][26]^sbits[6] |
         ecchmatrix[5][26]^sbits[5] |
         ecchmatrix[4][26]^sbits[4] |
         ecchmatrix[3][26]^sbits[3] |
         ecchmatrix[2][26]^sbits[2] |
         ecchmatrix[1][26]^sbits[1] |
         ecchmatrix[0][26]^sbits[0]);
  assign biterr_wire[25] = ~(
         ecchmatrix[6][25]^sbits[6] |
         ecchmatrix[5][25]^sbits[5] |
         ecchmatrix[4][25]^sbits[4] |
         ecchmatrix[3][25]^sbits[3] |
         ecchmatrix[2][25]^sbits[2] |
         ecchmatrix[1][25]^sbits[1] |
         ecchmatrix[0][25]^sbits[0]);
  assign biterr_wire[24] = ~(
         ecchmatrix[6][24]^sbits[6] |
         ecchmatrix[5][24]^sbits[5] |
         ecchmatrix[4][24]^sbits[4] |
         ecchmatrix[3][24]^sbits[3] |
         ecchmatrix[2][24]^sbits[2] |
         ecchmatrix[1][24]^sbits[1] |
         ecchmatrix[0][24]^sbits[0]);
  assign biterr_wire[23] = ~(
         ecchmatrix[6][23]^sbits[6] |
         ecchmatrix[5][23]^sbits[5] |
         ecchmatrix[4][23]^sbits[4] |
         ecchmatrix[3][23]^sbits[3] |
         ecchmatrix[2][23]^sbits[2] |
         ecchmatrix[1][23]^sbits[1] |
         ecchmatrix[0][23]^sbits[0]);
  assign biterr_wire[22] = ~(
         ecchmatrix[6][22]^sbits[6] |
         ecchmatrix[5][22]^sbits[5] |
         ecchmatrix[4][22]^sbits[4] |
         ecchmatrix[3][22]^sbits[3] |
         ecchmatrix[2][22]^sbits[2] |
         ecchmatrix[1][22]^sbits[1] |
         ecchmatrix[0][22]^sbits[0]);
  assign biterr_wire[21] = ~(
         ecchmatrix[6][21]^sbits[6] |
         ecchmatrix[5][21]^sbits[5] |
         ecchmatrix[4][21]^sbits[4] |
         ecchmatrix[3][21]^sbits[3] |
         ecchmatrix[2][21]^sbits[2] |
         ecchmatrix[1][21]^sbits[1] |
         ecchmatrix[0][21]^sbits[0]);
  assign biterr_wire[20] = ~(
         ecchmatrix[6][20]^sbits[6] |
         ecchmatrix[5][20]^sbits[5] |
         ecchmatrix[4][20]^sbits[4] |
         ecchmatrix[3][20]^sbits[3] |
         ecchmatrix[2][20]^sbits[2] |
         ecchmatrix[1][20]^sbits[1] |
         ecchmatrix[0][20]^sbits[0]);
  assign biterr_wire[19] = ~(
         ecchmatrix[6][19]^sbits[6] |
         ecchmatrix[5][19]^sbits[5] |
         ecchmatrix[4][19]^sbits[4] |
         ecchmatrix[3][19]^sbits[3] |
         ecchmatrix[2][19]^sbits[2] |
         ecchmatrix[1][19]^sbits[1] |
         ecchmatrix[0][19]^sbits[0]);
  assign biterr_wire[18] = ~(
         ecchmatrix[6][18]^sbits[6] |
         ecchmatrix[5][18]^sbits[5] |
         ecchmatrix[4][18]^sbits[4] |
         ecchmatrix[3][18]^sbits[3] |
         ecchmatrix[2][18]^sbits[2] |
         ecchmatrix[1][18]^sbits[1] |
         ecchmatrix[0][18]^sbits[0]);
  assign biterr_wire[17] = ~(
         ecchmatrix[6][17]^sbits[6] |
         ecchmatrix[5][17]^sbits[5] |
         ecchmatrix[4][17]^sbits[4] |
         ecchmatrix[3][17]^sbits[3] |
         ecchmatrix[2][17]^sbits[2] |
         ecchmatrix[1][17]^sbits[1] |
         ecchmatrix[0][17]^sbits[0]);
  assign biterr_wire[16] = ~(
         ecchmatrix[6][16]^sbits[6] |
         ecchmatrix[5][16]^sbits[5] |
         ecchmatrix[4][16]^sbits[4] |
         ecchmatrix[3][16]^sbits[3] |
         ecchmatrix[2][16]^sbits[2] |
         ecchmatrix[1][16]^sbits[1] |
         ecchmatrix[0][16]^sbits[0]);
  assign biterr_wire[15] = ~(
         ecchmatrix[6][15]^sbits[6] |
         ecchmatrix[5][15]^sbits[5] |
         ecchmatrix[4][15]^sbits[4] |
         ecchmatrix[3][15]^sbits[3] |
         ecchmatrix[2][15]^sbits[2] |
         ecchmatrix[1][15]^sbits[1] |
         ecchmatrix[0][15]^sbits[0]);
  assign biterr_wire[14] = ~(
         ecchmatrix[6][14]^sbits[6] |
         ecchmatrix[5][14]^sbits[5] |
         ecchmatrix[4][14]^sbits[4] |
         ecchmatrix[3][14]^sbits[3] |
         ecchmatrix[2][14]^sbits[2] |
         ecchmatrix[1][14]^sbits[1] |
         ecchmatrix[0][14]^sbits[0]);
  assign biterr_wire[13] = ~(
         ecchmatrix[6][13]^sbits[6] |
         ecchmatrix[5][13]^sbits[5] |
         ecchmatrix[4][13]^sbits[4] |
         ecchmatrix[3][13]^sbits[3] |
         ecchmatrix[2][13]^sbits[2] |
         ecchmatrix[1][13]^sbits[1] |
         ecchmatrix[0][13]^sbits[0]);
  assign biterr_wire[12] = ~(
         ecchmatrix[6][12]^sbits[6] |
         ecchmatrix[5][12]^sbits[5] |
         ecchmatrix[4][12]^sbits[4] |
         ecchmatrix[3][12]^sbits[3] |
         ecchmatrix[2][12]^sbits[2] |
         ecchmatrix[1][12]^sbits[1] |
         ecchmatrix[0][12]^sbits[0]);
  assign biterr_wire[11] = ~(
         ecchmatrix[6][11]^sbits[6] |
         ecchmatrix[5][11]^sbits[5] |
         ecchmatrix[4][11]^sbits[4] |
         ecchmatrix[3][11]^sbits[3] |
         ecchmatrix[2][11]^sbits[2] |
         ecchmatrix[1][11]^sbits[1] |
         ecchmatrix[0][11]^sbits[0]);
  assign biterr_wire[10] = ~(
         ecchmatrix[6][10]^sbits[6] |
         ecchmatrix[5][10]^sbits[5] |
         ecchmatrix[4][10]^sbits[4] |
         ecchmatrix[3][10]^sbits[3] |
         ecchmatrix[2][10]^sbits[2] |
         ecchmatrix[1][10]^sbits[1] |
         ecchmatrix[0][10]^sbits[0]);
  assign biterr_wire[9] = ~(
         ecchmatrix[6][9]^sbits[6] |
         ecchmatrix[5][9]^sbits[5] |
         ecchmatrix[4][9]^sbits[4] |
         ecchmatrix[3][9]^sbits[3] |
         ecchmatrix[2][9]^sbits[2] |
         ecchmatrix[1][9]^sbits[1] |
         ecchmatrix[0][9]^sbits[0]);
  assign biterr_wire[8] = ~(
         ecchmatrix[6][8]^sbits[6] |
         ecchmatrix[5][8]^sbits[5] |
         ecchmatrix[4][8]^sbits[4] |
         ecchmatrix[3][8]^sbits[3] |
         ecchmatrix[2][8]^sbits[2] |
         ecchmatrix[1][8]^sbits[1] |
         ecchmatrix[0][8]^sbits[0]);
  assign biterr_wire[7] = ~(
         ecchmatrix[6][7]^sbits[6] |
         ecchmatrix[5][7]^sbits[5] |
         ecchmatrix[4][7]^sbits[4] |
         ecchmatrix[3][7]^sbits[3] |
         ecchmatrix[2][7]^sbits[2] |
         ecchmatrix[1][7]^sbits[1] |
         ecchmatrix[0][7]^sbits[0]);
  assign biterr_wire[6] = ~(
         ecchmatrix[6][6]^sbits[6] |
         ecchmatrix[5][6]^sbits[5] |
         ecchmatrix[4][6]^sbits[4] |
         ecchmatrix[3][6]^sbits[3] |
         ecchmatrix[2][6]^sbits[2] |
         ecchmatrix[1][6]^sbits[1] |
         ecchmatrix[0][6]^sbits[0]);
  assign biterr_wire[5] = ~(
         ecchmatrix[6][5]^sbits[6] |
         ecchmatrix[5][5]^sbits[5] |
         ecchmatrix[4][5]^sbits[4] |
         ecchmatrix[3][5]^sbits[3] |
         ecchmatrix[2][5]^sbits[2] |
         ecchmatrix[1][5]^sbits[1] |
         ecchmatrix[0][5]^sbits[0]);
  assign biterr_wire[4] = ~(
         ecchmatrix[6][4]^sbits[6] |
         ecchmatrix[5][4]^sbits[5] |
         ecchmatrix[4][4]^sbits[4] |
         ecchmatrix[3][4]^sbits[3] |
         ecchmatrix[2][4]^sbits[2] |
         ecchmatrix[1][4]^sbits[1] |
         ecchmatrix[0][4]^sbits[0]);
  assign biterr_wire[3] = ~(
         ecchmatrix[6][3]^sbits[6] |
         ecchmatrix[5][3]^sbits[5] |
         ecchmatrix[4][3]^sbits[4] |
         ecchmatrix[3][3]^sbits[3] |
         ecchmatrix[2][3]^sbits[2] |
         ecchmatrix[1][3]^sbits[1] |
         ecchmatrix[0][3]^sbits[0]);
  assign biterr_wire[2] = ~(
         ecchmatrix[6][2]^sbits[6] |
         ecchmatrix[5][2]^sbits[5] |
         ecchmatrix[4][2]^sbits[4] |
         ecchmatrix[3][2]^sbits[3] |
         ecchmatrix[2][2]^sbits[2] |
         ecchmatrix[1][2]^sbits[1] |
         ecchmatrix[0][2]^sbits[0]);
  assign biterr_wire[1] = ~(
         ecchmatrix[6][1]^sbits[6] |
         ecchmatrix[5][1]^sbits[5] |
         ecchmatrix[4][1]^sbits[4] |
         ecchmatrix[3][1]^sbits[3] |
         ecchmatrix[2][1]^sbits[2] |
         ecchmatrix[1][1]^sbits[1] |
         ecchmatrix[0][1]^sbits[0]);
  assign biterr_wire[0] = ~(
         ecchmatrix[6][0]^sbits[6] |
         ecchmatrix[5][0]^sbits[5] |
         ecchmatrix[4][0]^sbits[4] |
         ecchmatrix[3][0]^sbits[3] |
         ecchmatrix[2][0]^sbits[2] |
         ecchmatrix[1][0]^sbits[1] |
         ecchmatrix[0][0]^sbits[0]);

  wire [ECCDWIDTH+ECCWIDTH-1:0]   biterr;
  wire [ECCDWIDTH-1:0]	din_f2;
  wire [ECCWIDTH-1:0]   sbits_f2;
  generate if(FLOPECC2) begin
	reg [ECCDWIDTH+ECCWIDTH-1:0]   biterr_reg;
	reg [ECCDWIDTH-1:0]	din_f2_reg;
	reg [ECCWIDTH-1:0] sbits_f2_reg;
	always @(posedge clk) begin
		biterr_reg <= biterr_wire;
		din_f2_reg <= din_f1;
		sbits_f2_reg <= sbits;
	end
	assign biterr = biterr_reg;
	assign din_f2 = din_f2_reg;
	assign sbits_f2 = sbits_f2_reg;
  end else begin
	assign biterr = biterr_wire;
	assign din_f2 = din_f1;
	assign sbits_f2 = sbits;
  end
  endgenerate
		 
 assign  dout    = din_f2 ^ biterr;
 assign  sec_err = |biterr;
 assign  ded_err = |sbits_f2 & ~|biterr;

endmodule

module ecc_check_120 #(parameter FLOPECC1=0, parameter FLOPECC2=0) (din,  eccin, dout, sec_err, ded_err, clk, rst);

  localparam ECCDWIDTH = 120;
  localparam ECCWIDTH  = 8;
  
  input [ECCDWIDTH-1:0]            din;  
  input [ECCWIDTH-1:0]             eccin;

  output [ECCDWIDTH-1:0]           dout;  
  output                           sec_err; // asserted if a single error is detected/corrected
  output                           ded_err; // asserted if two errors are detected

  input                            clk;
  input                            rst;

  wire       sec_err;
  wire       ded_err;
  wire [ECCDWIDTH-1:0]      dout;
  
  wire [ECCDWIDTH+ECCWIDTH-1:0]   ecchmatrix [0:ECCWIDTH-1];
  wire [ECCWIDTH-1:0]    sbits_wire;

  wire [ECCDWIDTH+ECCWIDTH-1:0]   biterr_wire;

// Generate the H Matrix in Perl

   assign ecchmatrix[0][0] = 1;
   assign ecchmatrix[1][0] = 1;
   assign ecchmatrix[2][0] = 1;
   assign ecchmatrix[3][0] = 0;
   assign ecchmatrix[4][0] = 0;
   assign ecchmatrix[5][0] = 0;
   assign ecchmatrix[6][0] = 0;
   assign ecchmatrix[7][0] = 0;
   assign ecchmatrix[0][1] = 1;
   assign ecchmatrix[1][1] = 1;
   assign ecchmatrix[2][1] = 0;
   assign ecchmatrix[3][1] = 1;
   assign ecchmatrix[4][1] = 0;
   assign ecchmatrix[5][1] = 0;
   assign ecchmatrix[6][1] = 0;
   assign ecchmatrix[7][1] = 0;
   assign ecchmatrix[0][2] = 1;
   assign ecchmatrix[1][2] = 1;
   assign ecchmatrix[2][2] = 0;
   assign ecchmatrix[3][2] = 0;
   assign ecchmatrix[4][2] = 1;
   assign ecchmatrix[5][2] = 0;
   assign ecchmatrix[6][2] = 0;
   assign ecchmatrix[7][2] = 0;
   assign ecchmatrix[0][3] = 1;
   assign ecchmatrix[1][3] = 1;
   assign ecchmatrix[2][3] = 0;
   assign ecchmatrix[3][3] = 0;
   assign ecchmatrix[4][3] = 0;
   assign ecchmatrix[5][3] = 1;
   assign ecchmatrix[6][3] = 0;
   assign ecchmatrix[7][3] = 0;
   assign ecchmatrix[0][4] = 1;
   assign ecchmatrix[1][4] = 1;
   assign ecchmatrix[2][4] = 0;
   assign ecchmatrix[3][4] = 0;
   assign ecchmatrix[4][4] = 0;
   assign ecchmatrix[5][4] = 0;
   assign ecchmatrix[6][4] = 1;
   assign ecchmatrix[7][4] = 0;
   assign ecchmatrix[0][5] = 1;
   assign ecchmatrix[1][5] = 1;
   assign ecchmatrix[2][5] = 0;
   assign ecchmatrix[3][5] = 0;
   assign ecchmatrix[4][5] = 0;
   assign ecchmatrix[5][5] = 0;
   assign ecchmatrix[6][5] = 0;
   assign ecchmatrix[7][5] = 1;
   assign ecchmatrix[0][6] = 1;
   assign ecchmatrix[1][6] = 0;
   assign ecchmatrix[2][6] = 1;
   assign ecchmatrix[3][6] = 1;
   assign ecchmatrix[4][6] = 0;
   assign ecchmatrix[5][6] = 0;
   assign ecchmatrix[6][6] = 0;
   assign ecchmatrix[7][6] = 0;
   assign ecchmatrix[0][7] = 1;
   assign ecchmatrix[1][7] = 0;
   assign ecchmatrix[2][7] = 1;
   assign ecchmatrix[3][7] = 0;
   assign ecchmatrix[4][7] = 1;
   assign ecchmatrix[5][7] = 0;
   assign ecchmatrix[6][7] = 0;
   assign ecchmatrix[7][7] = 0;
   assign ecchmatrix[0][8] = 1;
   assign ecchmatrix[1][8] = 0;
   assign ecchmatrix[2][8] = 1;
   assign ecchmatrix[3][8] = 0;
   assign ecchmatrix[4][8] = 0;
   assign ecchmatrix[5][8] = 1;
   assign ecchmatrix[6][8] = 0;
   assign ecchmatrix[7][8] = 0;
   assign ecchmatrix[0][9] = 1;
   assign ecchmatrix[1][9] = 0;
   assign ecchmatrix[2][9] = 1;
   assign ecchmatrix[3][9] = 0;
   assign ecchmatrix[4][9] = 0;
   assign ecchmatrix[5][9] = 0;
   assign ecchmatrix[6][9] = 1;
   assign ecchmatrix[7][9] = 0;
   assign ecchmatrix[0][10] = 1;
   assign ecchmatrix[1][10] = 0;
   assign ecchmatrix[2][10] = 1;
   assign ecchmatrix[3][10] = 0;
   assign ecchmatrix[4][10] = 0;
   assign ecchmatrix[5][10] = 0;
   assign ecchmatrix[6][10] = 0;
   assign ecchmatrix[7][10] = 1;
   assign ecchmatrix[0][11] = 1;
   assign ecchmatrix[1][11] = 0;
   assign ecchmatrix[2][11] = 0;
   assign ecchmatrix[3][11] = 1;
   assign ecchmatrix[4][11] = 1;
   assign ecchmatrix[5][11] = 0;
   assign ecchmatrix[6][11] = 0;
   assign ecchmatrix[7][11] = 0;
   assign ecchmatrix[0][12] = 1;
   assign ecchmatrix[1][12] = 0;
   assign ecchmatrix[2][12] = 0;
   assign ecchmatrix[3][12] = 1;
   assign ecchmatrix[4][12] = 0;
   assign ecchmatrix[5][12] = 1;
   assign ecchmatrix[6][12] = 0;
   assign ecchmatrix[7][12] = 0;
   assign ecchmatrix[0][13] = 1;
   assign ecchmatrix[1][13] = 0;
   assign ecchmatrix[2][13] = 0;
   assign ecchmatrix[3][13] = 1;
   assign ecchmatrix[4][13] = 0;
   assign ecchmatrix[5][13] = 0;
   assign ecchmatrix[6][13] = 1;
   assign ecchmatrix[7][13] = 0;
   assign ecchmatrix[0][14] = 1;
   assign ecchmatrix[1][14] = 0;
   assign ecchmatrix[2][14] = 0;
   assign ecchmatrix[3][14] = 1;
   assign ecchmatrix[4][14] = 0;
   assign ecchmatrix[5][14] = 0;
   assign ecchmatrix[6][14] = 0;
   assign ecchmatrix[7][14] = 1;
   assign ecchmatrix[0][15] = 1;
   assign ecchmatrix[1][15] = 0;
   assign ecchmatrix[2][15] = 0;
   assign ecchmatrix[3][15] = 0;
   assign ecchmatrix[4][15] = 1;
   assign ecchmatrix[5][15] = 1;
   assign ecchmatrix[6][15] = 0;
   assign ecchmatrix[7][15] = 0;
   assign ecchmatrix[0][16] = 1;
   assign ecchmatrix[1][16] = 0;
   assign ecchmatrix[2][16] = 0;
   assign ecchmatrix[3][16] = 0;
   assign ecchmatrix[4][16] = 1;
   assign ecchmatrix[5][16] = 0;
   assign ecchmatrix[6][16] = 1;
   assign ecchmatrix[7][16] = 0;
   assign ecchmatrix[0][17] = 1;
   assign ecchmatrix[1][17] = 0;
   assign ecchmatrix[2][17] = 0;
   assign ecchmatrix[3][17] = 0;
   assign ecchmatrix[4][17] = 1;
   assign ecchmatrix[5][17] = 0;
   assign ecchmatrix[6][17] = 0;
   assign ecchmatrix[7][17] = 1;
   assign ecchmatrix[0][18] = 1;
   assign ecchmatrix[1][18] = 0;
   assign ecchmatrix[2][18] = 0;
   assign ecchmatrix[3][18] = 0;
   assign ecchmatrix[4][18] = 0;
   assign ecchmatrix[5][18] = 1;
   assign ecchmatrix[6][18] = 1;
   assign ecchmatrix[7][18] = 0;
   assign ecchmatrix[0][19] = 1;
   assign ecchmatrix[1][19] = 0;
   assign ecchmatrix[2][19] = 0;
   assign ecchmatrix[3][19] = 0;
   assign ecchmatrix[4][19] = 0;
   assign ecchmatrix[5][19] = 1;
   assign ecchmatrix[6][19] = 0;
   assign ecchmatrix[7][19] = 1;
   assign ecchmatrix[0][20] = 1;
   assign ecchmatrix[1][20] = 0;
   assign ecchmatrix[2][20] = 0;
   assign ecchmatrix[3][20] = 0;
   assign ecchmatrix[4][20] = 0;
   assign ecchmatrix[5][20] = 0;
   assign ecchmatrix[6][20] = 1;
   assign ecchmatrix[7][20] = 1;
   assign ecchmatrix[0][21] = 0;
   assign ecchmatrix[1][21] = 1;
   assign ecchmatrix[2][21] = 1;
   assign ecchmatrix[3][21] = 1;
   assign ecchmatrix[4][21] = 0;
   assign ecchmatrix[5][21] = 0;
   assign ecchmatrix[6][21] = 0;
   assign ecchmatrix[7][21] = 0;
   assign ecchmatrix[0][22] = 0;
   assign ecchmatrix[1][22] = 1;
   assign ecchmatrix[2][22] = 1;
   assign ecchmatrix[3][22] = 0;
   assign ecchmatrix[4][22] = 1;
   assign ecchmatrix[5][22] = 0;
   assign ecchmatrix[6][22] = 0;
   assign ecchmatrix[7][22] = 0;
   assign ecchmatrix[0][23] = 0;
   assign ecchmatrix[1][23] = 1;
   assign ecchmatrix[2][23] = 1;
   assign ecchmatrix[3][23] = 0;
   assign ecchmatrix[4][23] = 0;
   assign ecchmatrix[5][23] = 1;
   assign ecchmatrix[6][23] = 0;
   assign ecchmatrix[7][23] = 0;
   assign ecchmatrix[0][24] = 0;
   assign ecchmatrix[1][24] = 1;
   assign ecchmatrix[2][24] = 1;
   assign ecchmatrix[3][24] = 0;
   assign ecchmatrix[4][24] = 0;
   assign ecchmatrix[5][24] = 0;
   assign ecchmatrix[6][24] = 1;
   assign ecchmatrix[7][24] = 0;
   assign ecchmatrix[0][25] = 0;
   assign ecchmatrix[1][25] = 1;
   assign ecchmatrix[2][25] = 1;
   assign ecchmatrix[3][25] = 0;
   assign ecchmatrix[4][25] = 0;
   assign ecchmatrix[5][25] = 0;
   assign ecchmatrix[6][25] = 0;
   assign ecchmatrix[7][25] = 1;
   assign ecchmatrix[0][26] = 0;
   assign ecchmatrix[1][26] = 1;
   assign ecchmatrix[2][26] = 0;
   assign ecchmatrix[3][26] = 1;
   assign ecchmatrix[4][26] = 1;
   assign ecchmatrix[5][26] = 0;
   assign ecchmatrix[6][26] = 0;
   assign ecchmatrix[7][26] = 0;
   assign ecchmatrix[0][27] = 0;
   assign ecchmatrix[1][27] = 1;
   assign ecchmatrix[2][27] = 0;
   assign ecchmatrix[3][27] = 1;
   assign ecchmatrix[4][27] = 0;
   assign ecchmatrix[5][27] = 1;
   assign ecchmatrix[6][27] = 0;
   assign ecchmatrix[7][27] = 0;
   assign ecchmatrix[0][28] = 0;
   assign ecchmatrix[1][28] = 1;
   assign ecchmatrix[2][28] = 0;
   assign ecchmatrix[3][28] = 1;
   assign ecchmatrix[4][28] = 0;
   assign ecchmatrix[5][28] = 0;
   assign ecchmatrix[6][28] = 1;
   assign ecchmatrix[7][28] = 0;
   assign ecchmatrix[0][29] = 0;
   assign ecchmatrix[1][29] = 1;
   assign ecchmatrix[2][29] = 0;
   assign ecchmatrix[3][29] = 1;
   assign ecchmatrix[4][29] = 0;
   assign ecchmatrix[5][29] = 0;
   assign ecchmatrix[6][29] = 0;
   assign ecchmatrix[7][29] = 1;
   assign ecchmatrix[0][30] = 0;
   assign ecchmatrix[1][30] = 1;
   assign ecchmatrix[2][30] = 0;
   assign ecchmatrix[3][30] = 0;
   assign ecchmatrix[4][30] = 1;
   assign ecchmatrix[5][30] = 1;
   assign ecchmatrix[6][30] = 0;
   assign ecchmatrix[7][30] = 0;
   assign ecchmatrix[0][31] = 0;
   assign ecchmatrix[1][31] = 1;
   assign ecchmatrix[2][31] = 0;
   assign ecchmatrix[3][31] = 0;
   assign ecchmatrix[4][31] = 1;
   assign ecchmatrix[5][31] = 0;
   assign ecchmatrix[6][31] = 1;
   assign ecchmatrix[7][31] = 0;
   assign ecchmatrix[0][32] = 0;
   assign ecchmatrix[1][32] = 1;
   assign ecchmatrix[2][32] = 0;
   assign ecchmatrix[3][32] = 0;
   assign ecchmatrix[4][32] = 1;
   assign ecchmatrix[5][32] = 0;
   assign ecchmatrix[6][32] = 0;
   assign ecchmatrix[7][32] = 1;
   assign ecchmatrix[0][33] = 0;
   assign ecchmatrix[1][33] = 1;
   assign ecchmatrix[2][33] = 0;
   assign ecchmatrix[3][33] = 0;
   assign ecchmatrix[4][33] = 0;
   assign ecchmatrix[5][33] = 1;
   assign ecchmatrix[6][33] = 1;
   assign ecchmatrix[7][33] = 0;
   assign ecchmatrix[0][34] = 0;
   assign ecchmatrix[1][34] = 1;
   assign ecchmatrix[2][34] = 0;
   assign ecchmatrix[3][34] = 0;
   assign ecchmatrix[4][34] = 0;
   assign ecchmatrix[5][34] = 1;
   assign ecchmatrix[6][34] = 0;
   assign ecchmatrix[7][34] = 1;
   assign ecchmatrix[0][35] = 0;
   assign ecchmatrix[1][35] = 1;
   assign ecchmatrix[2][35] = 0;
   assign ecchmatrix[3][35] = 0;
   assign ecchmatrix[4][35] = 0;
   assign ecchmatrix[5][35] = 0;
   assign ecchmatrix[6][35] = 1;
   assign ecchmatrix[7][35] = 1;
   assign ecchmatrix[0][36] = 0;
   assign ecchmatrix[1][36] = 0;
   assign ecchmatrix[2][36] = 1;
   assign ecchmatrix[3][36] = 1;
   assign ecchmatrix[4][36] = 1;
   assign ecchmatrix[5][36] = 0;
   assign ecchmatrix[6][36] = 0;
   assign ecchmatrix[7][36] = 0;
   assign ecchmatrix[0][37] = 0;
   assign ecchmatrix[1][37] = 0;
   assign ecchmatrix[2][37] = 1;
   assign ecchmatrix[3][37] = 1;
   assign ecchmatrix[4][37] = 0;
   assign ecchmatrix[5][37] = 1;
   assign ecchmatrix[6][37] = 0;
   assign ecchmatrix[7][37] = 0;
   assign ecchmatrix[0][38] = 0;
   assign ecchmatrix[1][38] = 0;
   assign ecchmatrix[2][38] = 1;
   assign ecchmatrix[3][38] = 1;
   assign ecchmatrix[4][38] = 0;
   assign ecchmatrix[5][38] = 0;
   assign ecchmatrix[6][38] = 1;
   assign ecchmatrix[7][38] = 0;
   assign ecchmatrix[0][39] = 0;
   assign ecchmatrix[1][39] = 0;
   assign ecchmatrix[2][39] = 1;
   assign ecchmatrix[3][39] = 1;
   assign ecchmatrix[4][39] = 0;
   assign ecchmatrix[5][39] = 0;
   assign ecchmatrix[6][39] = 0;
   assign ecchmatrix[7][39] = 1;
   assign ecchmatrix[0][40] = 0;
   assign ecchmatrix[1][40] = 0;
   assign ecchmatrix[2][40] = 1;
   assign ecchmatrix[3][40] = 0;
   assign ecchmatrix[4][40] = 1;
   assign ecchmatrix[5][40] = 1;
   assign ecchmatrix[6][40] = 0;
   assign ecchmatrix[7][40] = 0;
   assign ecchmatrix[0][41] = 0;
   assign ecchmatrix[1][41] = 0;
   assign ecchmatrix[2][41] = 1;
   assign ecchmatrix[3][41] = 0;
   assign ecchmatrix[4][41] = 1;
   assign ecchmatrix[5][41] = 0;
   assign ecchmatrix[6][41] = 1;
   assign ecchmatrix[7][41] = 0;
   assign ecchmatrix[0][42] = 0;
   assign ecchmatrix[1][42] = 0;
   assign ecchmatrix[2][42] = 1;
   assign ecchmatrix[3][42] = 0;
   assign ecchmatrix[4][42] = 1;
   assign ecchmatrix[5][42] = 0;
   assign ecchmatrix[6][42] = 0;
   assign ecchmatrix[7][42] = 1;
   assign ecchmatrix[0][43] = 0;
   assign ecchmatrix[1][43] = 0;
   assign ecchmatrix[2][43] = 1;
   assign ecchmatrix[3][43] = 0;
   assign ecchmatrix[4][43] = 0;
   assign ecchmatrix[5][43] = 1;
   assign ecchmatrix[6][43] = 1;
   assign ecchmatrix[7][43] = 0;
   assign ecchmatrix[0][44] = 0;
   assign ecchmatrix[1][44] = 0;
   assign ecchmatrix[2][44] = 1;
   assign ecchmatrix[3][44] = 0;
   assign ecchmatrix[4][44] = 0;
   assign ecchmatrix[5][44] = 1;
   assign ecchmatrix[6][44] = 0;
   assign ecchmatrix[7][44] = 1;
   assign ecchmatrix[0][45] = 0;
   assign ecchmatrix[1][45] = 0;
   assign ecchmatrix[2][45] = 1;
   assign ecchmatrix[3][45] = 0;
   assign ecchmatrix[4][45] = 0;
   assign ecchmatrix[5][45] = 0;
   assign ecchmatrix[6][45] = 1;
   assign ecchmatrix[7][45] = 1;
   assign ecchmatrix[0][46] = 0;
   assign ecchmatrix[1][46] = 0;
   assign ecchmatrix[2][46] = 0;
   assign ecchmatrix[3][46] = 1;
   assign ecchmatrix[4][46] = 1;
   assign ecchmatrix[5][46] = 1;
   assign ecchmatrix[6][46] = 0;
   assign ecchmatrix[7][46] = 0;
   assign ecchmatrix[0][47] = 0;
   assign ecchmatrix[1][47] = 0;
   assign ecchmatrix[2][47] = 0;
   assign ecchmatrix[3][47] = 1;
   assign ecchmatrix[4][47] = 1;
   assign ecchmatrix[5][47] = 0;
   assign ecchmatrix[6][47] = 1;
   assign ecchmatrix[7][47] = 0;
   assign ecchmatrix[0][48] = 0;
   assign ecchmatrix[1][48] = 0;
   assign ecchmatrix[2][48] = 0;
   assign ecchmatrix[3][48] = 1;
   assign ecchmatrix[4][48] = 1;
   assign ecchmatrix[5][48] = 0;
   assign ecchmatrix[6][48] = 0;
   assign ecchmatrix[7][48] = 1;
   assign ecchmatrix[0][49] = 0;
   assign ecchmatrix[1][49] = 0;
   assign ecchmatrix[2][49] = 0;
   assign ecchmatrix[3][49] = 1;
   assign ecchmatrix[4][49] = 0;
   assign ecchmatrix[5][49] = 1;
   assign ecchmatrix[6][49] = 1;
   assign ecchmatrix[7][49] = 0;
   assign ecchmatrix[0][50] = 0;
   assign ecchmatrix[1][50] = 0;
   assign ecchmatrix[2][50] = 0;
   assign ecchmatrix[3][50] = 1;
   assign ecchmatrix[4][50] = 0;
   assign ecchmatrix[5][50] = 1;
   assign ecchmatrix[6][50] = 0;
   assign ecchmatrix[7][50] = 1;
   assign ecchmatrix[0][51] = 0;
   assign ecchmatrix[1][51] = 0;
   assign ecchmatrix[2][51] = 0;
   assign ecchmatrix[3][51] = 1;
   assign ecchmatrix[4][51] = 0;
   assign ecchmatrix[5][51] = 0;
   assign ecchmatrix[6][51] = 1;
   assign ecchmatrix[7][51] = 1;
   assign ecchmatrix[0][52] = 0;
   assign ecchmatrix[1][52] = 0;
   assign ecchmatrix[2][52] = 0;
   assign ecchmatrix[3][52] = 0;
   assign ecchmatrix[4][52] = 1;
   assign ecchmatrix[5][52] = 1;
   assign ecchmatrix[6][52] = 1;
   assign ecchmatrix[7][52] = 0;
   assign ecchmatrix[0][53] = 0;
   assign ecchmatrix[1][53] = 0;
   assign ecchmatrix[2][53] = 0;
   assign ecchmatrix[3][53] = 0;
   assign ecchmatrix[4][53] = 1;
   assign ecchmatrix[5][53] = 1;
   assign ecchmatrix[6][53] = 0;
   assign ecchmatrix[7][53] = 1;
   assign ecchmatrix[0][54] = 0;
   assign ecchmatrix[1][54] = 0;
   assign ecchmatrix[2][54] = 0;
   assign ecchmatrix[3][54] = 0;
   assign ecchmatrix[4][54] = 1;
   assign ecchmatrix[5][54] = 0;
   assign ecchmatrix[6][54] = 1;
   assign ecchmatrix[7][54] = 1;
   assign ecchmatrix[0][55] = 0;
   assign ecchmatrix[1][55] = 0;
   assign ecchmatrix[2][55] = 0;
   assign ecchmatrix[3][55] = 0;
   assign ecchmatrix[4][55] = 0;
   assign ecchmatrix[5][55] = 1;
   assign ecchmatrix[6][55] = 1;
   assign ecchmatrix[7][55] = 1;
   assign ecchmatrix[0][56] = 1;
   assign ecchmatrix[1][56] = 1;
   assign ecchmatrix[2][56] = 1;
   assign ecchmatrix[3][56] = 1;
   assign ecchmatrix[4][56] = 1;
   assign ecchmatrix[5][56] = 0;
   assign ecchmatrix[6][56] = 0;
   assign ecchmatrix[7][56] = 0;
   assign ecchmatrix[0][57] = 1;
   assign ecchmatrix[1][57] = 1;
   assign ecchmatrix[2][57] = 1;
   assign ecchmatrix[3][57] = 1;
   assign ecchmatrix[4][57] = 0;
   assign ecchmatrix[5][57] = 1;
   assign ecchmatrix[6][57] = 0;
   assign ecchmatrix[7][57] = 0;
   assign ecchmatrix[0][58] = 1;
   assign ecchmatrix[1][58] = 1;
   assign ecchmatrix[2][58] = 1;
   assign ecchmatrix[3][58] = 1;
   assign ecchmatrix[4][58] = 0;
   assign ecchmatrix[5][58] = 0;
   assign ecchmatrix[6][58] = 1;
   assign ecchmatrix[7][58] = 0;
   assign ecchmatrix[0][59] = 1;
   assign ecchmatrix[1][59] = 1;
   assign ecchmatrix[2][59] = 1;
   assign ecchmatrix[3][59] = 1;
   assign ecchmatrix[4][59] = 0;
   assign ecchmatrix[5][59] = 0;
   assign ecchmatrix[6][59] = 0;
   assign ecchmatrix[7][59] = 1;
   assign ecchmatrix[0][60] = 1;
   assign ecchmatrix[1][60] = 1;
   assign ecchmatrix[2][60] = 1;
   assign ecchmatrix[3][60] = 0;
   assign ecchmatrix[4][60] = 1;
   assign ecchmatrix[5][60] = 1;
   assign ecchmatrix[6][60] = 0;
   assign ecchmatrix[7][60] = 0;
   assign ecchmatrix[0][61] = 1;
   assign ecchmatrix[1][61] = 1;
   assign ecchmatrix[2][61] = 1;
   assign ecchmatrix[3][61] = 0;
   assign ecchmatrix[4][61] = 1;
   assign ecchmatrix[5][61] = 0;
   assign ecchmatrix[6][61] = 1;
   assign ecchmatrix[7][61] = 0;
   assign ecchmatrix[0][62] = 1;
   assign ecchmatrix[1][62] = 1;
   assign ecchmatrix[2][62] = 1;
   assign ecchmatrix[3][62] = 0;
   assign ecchmatrix[4][62] = 1;
   assign ecchmatrix[5][62] = 0;
   assign ecchmatrix[6][62] = 0;
   assign ecchmatrix[7][62] = 1;
   assign ecchmatrix[0][63] = 1;
   assign ecchmatrix[1][63] = 1;
   assign ecchmatrix[2][63] = 1;
   assign ecchmatrix[3][63] = 0;
   assign ecchmatrix[4][63] = 0;
   assign ecchmatrix[5][63] = 1;
   assign ecchmatrix[6][63] = 1;
   assign ecchmatrix[7][63] = 0;
   assign ecchmatrix[0][64] = 1;
   assign ecchmatrix[1][64] = 1;
   assign ecchmatrix[2][64] = 1;
   assign ecchmatrix[3][64] = 0;
   assign ecchmatrix[4][64] = 0;
   assign ecchmatrix[5][64] = 1;
   assign ecchmatrix[6][64] = 0;
   assign ecchmatrix[7][64] = 1;
   assign ecchmatrix[0][65] = 1;
   assign ecchmatrix[1][65] = 1;
   assign ecchmatrix[2][65] = 1;
   assign ecchmatrix[3][65] = 0;
   assign ecchmatrix[4][65] = 0;
   assign ecchmatrix[5][65] = 0;
   assign ecchmatrix[6][65] = 1;
   assign ecchmatrix[7][65] = 1;
   assign ecchmatrix[0][66] = 1;
   assign ecchmatrix[1][66] = 1;
   assign ecchmatrix[2][66] = 0;
   assign ecchmatrix[3][66] = 1;
   assign ecchmatrix[4][66] = 1;
   assign ecchmatrix[5][66] = 1;
   assign ecchmatrix[6][66] = 0;
   assign ecchmatrix[7][66] = 0;
   assign ecchmatrix[0][67] = 1;
   assign ecchmatrix[1][67] = 1;
   assign ecchmatrix[2][67] = 0;
   assign ecchmatrix[3][67] = 1;
   assign ecchmatrix[4][67] = 1;
   assign ecchmatrix[5][67] = 0;
   assign ecchmatrix[6][67] = 1;
   assign ecchmatrix[7][67] = 0;
   assign ecchmatrix[0][68] = 1;
   assign ecchmatrix[1][68] = 1;
   assign ecchmatrix[2][68] = 0;
   assign ecchmatrix[3][68] = 1;
   assign ecchmatrix[4][68] = 1;
   assign ecchmatrix[5][68] = 0;
   assign ecchmatrix[6][68] = 0;
   assign ecchmatrix[7][68] = 1;
   assign ecchmatrix[0][69] = 1;
   assign ecchmatrix[1][69] = 1;
   assign ecchmatrix[2][69] = 0;
   assign ecchmatrix[3][69] = 1;
   assign ecchmatrix[4][69] = 0;
   assign ecchmatrix[5][69] = 1;
   assign ecchmatrix[6][69] = 1;
   assign ecchmatrix[7][69] = 0;
   assign ecchmatrix[0][70] = 1;
   assign ecchmatrix[1][70] = 1;
   assign ecchmatrix[2][70] = 0;
   assign ecchmatrix[3][70] = 1;
   assign ecchmatrix[4][70] = 0;
   assign ecchmatrix[5][70] = 1;
   assign ecchmatrix[6][70] = 0;
   assign ecchmatrix[7][70] = 1;
   assign ecchmatrix[0][71] = 1;
   assign ecchmatrix[1][71] = 1;
   assign ecchmatrix[2][71] = 0;
   assign ecchmatrix[3][71] = 1;
   assign ecchmatrix[4][71] = 0;
   assign ecchmatrix[5][71] = 0;
   assign ecchmatrix[6][71] = 1;
   assign ecchmatrix[7][71] = 1;
   assign ecchmatrix[0][72] = 1;
   assign ecchmatrix[1][72] = 1;
   assign ecchmatrix[2][72] = 0;
   assign ecchmatrix[3][72] = 0;
   assign ecchmatrix[4][72] = 1;
   assign ecchmatrix[5][72] = 1;
   assign ecchmatrix[6][72] = 1;
   assign ecchmatrix[7][72] = 0;
   assign ecchmatrix[0][73] = 1;
   assign ecchmatrix[1][73] = 1;
   assign ecchmatrix[2][73] = 0;
   assign ecchmatrix[3][73] = 0;
   assign ecchmatrix[4][73] = 1;
   assign ecchmatrix[5][73] = 1;
   assign ecchmatrix[6][73] = 0;
   assign ecchmatrix[7][73] = 1;
   assign ecchmatrix[0][74] = 1;
   assign ecchmatrix[1][74] = 1;
   assign ecchmatrix[2][74] = 0;
   assign ecchmatrix[3][74] = 0;
   assign ecchmatrix[4][74] = 1;
   assign ecchmatrix[5][74] = 0;
   assign ecchmatrix[6][74] = 1;
   assign ecchmatrix[7][74] = 1;
   assign ecchmatrix[0][75] = 1;
   assign ecchmatrix[1][75] = 1;
   assign ecchmatrix[2][75] = 0;
   assign ecchmatrix[3][75] = 0;
   assign ecchmatrix[4][75] = 0;
   assign ecchmatrix[5][75] = 1;
   assign ecchmatrix[6][75] = 1;
   assign ecchmatrix[7][75] = 1;
   assign ecchmatrix[0][76] = 1;
   assign ecchmatrix[1][76] = 0;
   assign ecchmatrix[2][76] = 1;
   assign ecchmatrix[3][76] = 1;
   assign ecchmatrix[4][76] = 1;
   assign ecchmatrix[5][76] = 1;
   assign ecchmatrix[6][76] = 0;
   assign ecchmatrix[7][76] = 0;
   assign ecchmatrix[0][77] = 1;
   assign ecchmatrix[1][77] = 0;
   assign ecchmatrix[2][77] = 1;
   assign ecchmatrix[3][77] = 1;
   assign ecchmatrix[4][77] = 1;
   assign ecchmatrix[5][77] = 0;
   assign ecchmatrix[6][77] = 1;
   assign ecchmatrix[7][77] = 0;
   assign ecchmatrix[0][78] = 1;
   assign ecchmatrix[1][78] = 0;
   assign ecchmatrix[2][78] = 1;
   assign ecchmatrix[3][78] = 1;
   assign ecchmatrix[4][78] = 1;
   assign ecchmatrix[5][78] = 0;
   assign ecchmatrix[6][78] = 0;
   assign ecchmatrix[7][78] = 1;
   assign ecchmatrix[0][79] = 1;
   assign ecchmatrix[1][79] = 0;
   assign ecchmatrix[2][79] = 1;
   assign ecchmatrix[3][79] = 1;
   assign ecchmatrix[4][79] = 0;
   assign ecchmatrix[5][79] = 1;
   assign ecchmatrix[6][79] = 1;
   assign ecchmatrix[7][79] = 0;
   assign ecchmatrix[0][80] = 1;
   assign ecchmatrix[1][80] = 0;
   assign ecchmatrix[2][80] = 1;
   assign ecchmatrix[3][80] = 1;
   assign ecchmatrix[4][80] = 0;
   assign ecchmatrix[5][80] = 1;
   assign ecchmatrix[6][80] = 0;
   assign ecchmatrix[7][80] = 1;
   assign ecchmatrix[0][81] = 1;
   assign ecchmatrix[1][81] = 0;
   assign ecchmatrix[2][81] = 1;
   assign ecchmatrix[3][81] = 1;
   assign ecchmatrix[4][81] = 0;
   assign ecchmatrix[5][81] = 0;
   assign ecchmatrix[6][81] = 1;
   assign ecchmatrix[7][81] = 1;
   assign ecchmatrix[0][82] = 1;
   assign ecchmatrix[1][82] = 0;
   assign ecchmatrix[2][82] = 1;
   assign ecchmatrix[3][82] = 0;
   assign ecchmatrix[4][82] = 1;
   assign ecchmatrix[5][82] = 1;
   assign ecchmatrix[6][82] = 1;
   assign ecchmatrix[7][82] = 0;
   assign ecchmatrix[0][83] = 1;
   assign ecchmatrix[1][83] = 0;
   assign ecchmatrix[2][83] = 1;
   assign ecchmatrix[3][83] = 0;
   assign ecchmatrix[4][83] = 1;
   assign ecchmatrix[5][83] = 1;
   assign ecchmatrix[6][83] = 0;
   assign ecchmatrix[7][83] = 1;
   assign ecchmatrix[0][84] = 1;
   assign ecchmatrix[1][84] = 0;
   assign ecchmatrix[2][84] = 1;
   assign ecchmatrix[3][84] = 0;
   assign ecchmatrix[4][84] = 1;
   assign ecchmatrix[5][84] = 0;
   assign ecchmatrix[6][84] = 1;
   assign ecchmatrix[7][84] = 1;
   assign ecchmatrix[0][85] = 1;
   assign ecchmatrix[1][85] = 0;
   assign ecchmatrix[2][85] = 1;
   assign ecchmatrix[3][85] = 0;
   assign ecchmatrix[4][85] = 0;
   assign ecchmatrix[5][85] = 1;
   assign ecchmatrix[6][85] = 1;
   assign ecchmatrix[7][85] = 1;
   assign ecchmatrix[0][86] = 1;
   assign ecchmatrix[1][86] = 0;
   assign ecchmatrix[2][86] = 0;
   assign ecchmatrix[3][86] = 1;
   assign ecchmatrix[4][86] = 1;
   assign ecchmatrix[5][86] = 1;
   assign ecchmatrix[6][86] = 1;
   assign ecchmatrix[7][86] = 0;
   assign ecchmatrix[0][87] = 1;
   assign ecchmatrix[1][87] = 0;
   assign ecchmatrix[2][87] = 0;
   assign ecchmatrix[3][87] = 1;
   assign ecchmatrix[4][87] = 1;
   assign ecchmatrix[5][87] = 1;
   assign ecchmatrix[6][87] = 0;
   assign ecchmatrix[7][87] = 1;
   assign ecchmatrix[0][88] = 1;
   assign ecchmatrix[1][88] = 0;
   assign ecchmatrix[2][88] = 0;
   assign ecchmatrix[3][88] = 1;
   assign ecchmatrix[4][88] = 1;
   assign ecchmatrix[5][88] = 0;
   assign ecchmatrix[6][88] = 1;
   assign ecchmatrix[7][88] = 1;
   assign ecchmatrix[0][89] = 1;
   assign ecchmatrix[1][89] = 0;
   assign ecchmatrix[2][89] = 0;
   assign ecchmatrix[3][89] = 1;
   assign ecchmatrix[4][89] = 0;
   assign ecchmatrix[5][89] = 1;
   assign ecchmatrix[6][89] = 1;
   assign ecchmatrix[7][89] = 1;
   assign ecchmatrix[0][90] = 1;
   assign ecchmatrix[1][90] = 0;
   assign ecchmatrix[2][90] = 0;
   assign ecchmatrix[3][90] = 0;
   assign ecchmatrix[4][90] = 1;
   assign ecchmatrix[5][90] = 1;
   assign ecchmatrix[6][90] = 1;
   assign ecchmatrix[7][90] = 1;
   assign ecchmatrix[0][91] = 0;
   assign ecchmatrix[1][91] = 1;
   assign ecchmatrix[2][91] = 1;
   assign ecchmatrix[3][91] = 1;
   assign ecchmatrix[4][91] = 1;
   assign ecchmatrix[5][91] = 1;
   assign ecchmatrix[6][91] = 0;
   assign ecchmatrix[7][91] = 0;
   assign ecchmatrix[0][92] = 0;
   assign ecchmatrix[1][92] = 1;
   assign ecchmatrix[2][92] = 1;
   assign ecchmatrix[3][92] = 1;
   assign ecchmatrix[4][92] = 1;
   assign ecchmatrix[5][92] = 0;
   assign ecchmatrix[6][92] = 1;
   assign ecchmatrix[7][92] = 0;
   assign ecchmatrix[0][93] = 0;
   assign ecchmatrix[1][93] = 1;
   assign ecchmatrix[2][93] = 1;
   assign ecchmatrix[3][93] = 1;
   assign ecchmatrix[4][93] = 1;
   assign ecchmatrix[5][93] = 0;
   assign ecchmatrix[6][93] = 0;
   assign ecchmatrix[7][93] = 1;
   assign ecchmatrix[0][94] = 0;
   assign ecchmatrix[1][94] = 1;
   assign ecchmatrix[2][94] = 1;
   assign ecchmatrix[3][94] = 1;
   assign ecchmatrix[4][94] = 0;
   assign ecchmatrix[5][94] = 1;
   assign ecchmatrix[6][94] = 1;
   assign ecchmatrix[7][94] = 0;
   assign ecchmatrix[0][95] = 0;
   assign ecchmatrix[1][95] = 1;
   assign ecchmatrix[2][95] = 1;
   assign ecchmatrix[3][95] = 1;
   assign ecchmatrix[4][95] = 0;
   assign ecchmatrix[5][95] = 1;
   assign ecchmatrix[6][95] = 0;
   assign ecchmatrix[7][95] = 1;
   assign ecchmatrix[0][96] = 0;
   assign ecchmatrix[1][96] = 1;
   assign ecchmatrix[2][96] = 1;
   assign ecchmatrix[3][96] = 1;
   assign ecchmatrix[4][96] = 0;
   assign ecchmatrix[5][96] = 0;
   assign ecchmatrix[6][96] = 1;
   assign ecchmatrix[7][96] = 1;
   assign ecchmatrix[0][97] = 0;
   assign ecchmatrix[1][97] = 1;
   assign ecchmatrix[2][97] = 1;
   assign ecchmatrix[3][97] = 0;
   assign ecchmatrix[4][97] = 1;
   assign ecchmatrix[5][97] = 1;
   assign ecchmatrix[6][97] = 1;
   assign ecchmatrix[7][97] = 0;
   assign ecchmatrix[0][98] = 0;
   assign ecchmatrix[1][98] = 1;
   assign ecchmatrix[2][98] = 1;
   assign ecchmatrix[3][98] = 0;
   assign ecchmatrix[4][98] = 1;
   assign ecchmatrix[5][98] = 1;
   assign ecchmatrix[6][98] = 0;
   assign ecchmatrix[7][98] = 1;
   assign ecchmatrix[0][99] = 0;
   assign ecchmatrix[1][99] = 1;
   assign ecchmatrix[2][99] = 1;
   assign ecchmatrix[3][99] = 0;
   assign ecchmatrix[4][99] = 1;
   assign ecchmatrix[5][99] = 0;
   assign ecchmatrix[6][99] = 1;
   assign ecchmatrix[7][99] = 1;
   assign ecchmatrix[0][100] = 0;
   assign ecchmatrix[1][100] = 1;
   assign ecchmatrix[2][100] = 1;
   assign ecchmatrix[3][100] = 0;
   assign ecchmatrix[4][100] = 0;
   assign ecchmatrix[5][100] = 1;
   assign ecchmatrix[6][100] = 1;
   assign ecchmatrix[7][100] = 1;
   assign ecchmatrix[0][101] = 0;
   assign ecchmatrix[1][101] = 1;
   assign ecchmatrix[2][101] = 0;
   assign ecchmatrix[3][101] = 1;
   assign ecchmatrix[4][101] = 1;
   assign ecchmatrix[5][101] = 1;
   assign ecchmatrix[6][101] = 1;
   assign ecchmatrix[7][101] = 0;
   assign ecchmatrix[0][102] = 0;
   assign ecchmatrix[1][102] = 1;
   assign ecchmatrix[2][102] = 0;
   assign ecchmatrix[3][102] = 1;
   assign ecchmatrix[4][102] = 1;
   assign ecchmatrix[5][102] = 1;
   assign ecchmatrix[6][102] = 0;
   assign ecchmatrix[7][102] = 1;
   assign ecchmatrix[0][103] = 0;
   assign ecchmatrix[1][103] = 1;
   assign ecchmatrix[2][103] = 0;
   assign ecchmatrix[3][103] = 1;
   assign ecchmatrix[4][103] = 1;
   assign ecchmatrix[5][103] = 0;
   assign ecchmatrix[6][103] = 1;
   assign ecchmatrix[7][103] = 1;
   assign ecchmatrix[0][104] = 0;
   assign ecchmatrix[1][104] = 1;
   assign ecchmatrix[2][104] = 0;
   assign ecchmatrix[3][104] = 1;
   assign ecchmatrix[4][104] = 0;
   assign ecchmatrix[5][104] = 1;
   assign ecchmatrix[6][104] = 1;
   assign ecchmatrix[7][104] = 1;
   assign ecchmatrix[0][105] = 0;
   assign ecchmatrix[1][105] = 1;
   assign ecchmatrix[2][105] = 0;
   assign ecchmatrix[3][105] = 0;
   assign ecchmatrix[4][105] = 1;
   assign ecchmatrix[5][105] = 1;
   assign ecchmatrix[6][105] = 1;
   assign ecchmatrix[7][105] = 1;
   assign ecchmatrix[0][106] = 0;
   assign ecchmatrix[1][106] = 0;
   assign ecchmatrix[2][106] = 1;
   assign ecchmatrix[3][106] = 1;
   assign ecchmatrix[4][106] = 1;
   assign ecchmatrix[5][106] = 1;
   assign ecchmatrix[6][106] = 1;
   assign ecchmatrix[7][106] = 0;
   assign ecchmatrix[0][107] = 0;
   assign ecchmatrix[1][107] = 0;
   assign ecchmatrix[2][107] = 1;
   assign ecchmatrix[3][107] = 1;
   assign ecchmatrix[4][107] = 1;
   assign ecchmatrix[5][107] = 1;
   assign ecchmatrix[6][107] = 0;
   assign ecchmatrix[7][107] = 1;
   assign ecchmatrix[0][108] = 0;
   assign ecchmatrix[1][108] = 0;
   assign ecchmatrix[2][108] = 1;
   assign ecchmatrix[3][108] = 1;
   assign ecchmatrix[4][108] = 1;
   assign ecchmatrix[5][108] = 0;
   assign ecchmatrix[6][108] = 1;
   assign ecchmatrix[7][108] = 1;
   assign ecchmatrix[0][109] = 0;
   assign ecchmatrix[1][109] = 0;
   assign ecchmatrix[2][109] = 1;
   assign ecchmatrix[3][109] = 1;
   assign ecchmatrix[4][109] = 0;
   assign ecchmatrix[5][109] = 1;
   assign ecchmatrix[6][109] = 1;
   assign ecchmatrix[7][109] = 1;
   assign ecchmatrix[0][110] = 0;
   assign ecchmatrix[1][110] = 0;
   assign ecchmatrix[2][110] = 1;
   assign ecchmatrix[3][110] = 0;
   assign ecchmatrix[4][110] = 1;
   assign ecchmatrix[5][110] = 1;
   assign ecchmatrix[6][110] = 1;
   assign ecchmatrix[7][110] = 1;
   assign ecchmatrix[0][111] = 0;
   assign ecchmatrix[1][111] = 0;
   assign ecchmatrix[2][111] = 0;
   assign ecchmatrix[3][111] = 1;
   assign ecchmatrix[4][111] = 1;
   assign ecchmatrix[5][111] = 1;
   assign ecchmatrix[6][111] = 1;
   assign ecchmatrix[7][111] = 1;
   assign ecchmatrix[0][112] = 1;
   assign ecchmatrix[1][112] = 1;
   assign ecchmatrix[2][112] = 1;
   assign ecchmatrix[3][112] = 1;
   assign ecchmatrix[4][112] = 1;
   assign ecchmatrix[5][112] = 1;
   assign ecchmatrix[6][112] = 1;
   assign ecchmatrix[7][112] = 0;
   assign ecchmatrix[0][113] = 1;
   assign ecchmatrix[1][113] = 1;
   assign ecchmatrix[2][113] = 1;
   assign ecchmatrix[3][113] = 1;
   assign ecchmatrix[4][113] = 1;
   assign ecchmatrix[5][113] = 1;
   assign ecchmatrix[6][113] = 0;
   assign ecchmatrix[7][113] = 1;
   assign ecchmatrix[0][114] = 1;
   assign ecchmatrix[1][114] = 1;
   assign ecchmatrix[2][114] = 1;
   assign ecchmatrix[3][114] = 1;
   assign ecchmatrix[4][114] = 1;
   assign ecchmatrix[5][114] = 0;
   assign ecchmatrix[6][114] = 1;
   assign ecchmatrix[7][114] = 1;
   assign ecchmatrix[0][115] = 1;
   assign ecchmatrix[1][115] = 1;
   assign ecchmatrix[2][115] = 1;
   assign ecchmatrix[3][115] = 1;
   assign ecchmatrix[4][115] = 0;
   assign ecchmatrix[5][115] = 1;
   assign ecchmatrix[6][115] = 1;
   assign ecchmatrix[7][115] = 1;
   assign ecchmatrix[0][116] = 1;
   assign ecchmatrix[1][116] = 1;
   assign ecchmatrix[2][116] = 1;
   assign ecchmatrix[3][116] = 0;
   assign ecchmatrix[4][116] = 1;
   assign ecchmatrix[5][116] = 1;
   assign ecchmatrix[6][116] = 1;
   assign ecchmatrix[7][116] = 1;
   assign ecchmatrix[0][117] = 1;
   assign ecchmatrix[1][117] = 1;
   assign ecchmatrix[2][117] = 0;
   assign ecchmatrix[3][117] = 1;
   assign ecchmatrix[4][117] = 1;
   assign ecchmatrix[5][117] = 1;
   assign ecchmatrix[6][117] = 1;
   assign ecchmatrix[7][117] = 1;
   assign ecchmatrix[0][118] = 1;
   assign ecchmatrix[1][118] = 0;
   assign ecchmatrix[2][118] = 1;
   assign ecchmatrix[3][118] = 1;
   assign ecchmatrix[4][118] = 1;
   assign ecchmatrix[5][118] = 1;
   assign ecchmatrix[6][118] = 1;
   assign ecchmatrix[7][118] = 1;
   assign ecchmatrix[0][119] = 0;
   assign ecchmatrix[1][119] = 1;
   assign ecchmatrix[2][119] = 1;
   assign ecchmatrix[3][119] = 1;
   assign ecchmatrix[4][119] = 1;
   assign ecchmatrix[5][119] = 1;
   assign ecchmatrix[6][119] = 1;
   assign ecchmatrix[7][119] = 1;
   assign ecchmatrix[0][120] = 1;
   assign ecchmatrix[1][120] = 0;
   assign ecchmatrix[2][120] = 0;
   assign ecchmatrix[3][120] = 0;
   assign ecchmatrix[4][120] = 0;
   assign ecchmatrix[5][120] = 0;
   assign ecchmatrix[6][120] = 0;
   assign ecchmatrix[7][120] = 0;
   assign ecchmatrix[0][121] = 0;
   assign ecchmatrix[1][121] = 1;
   assign ecchmatrix[2][121] = 0;
   assign ecchmatrix[3][121] = 0;
   assign ecchmatrix[4][121] = 0;
   assign ecchmatrix[5][121] = 0;
   assign ecchmatrix[6][121] = 0;
   assign ecchmatrix[7][121] = 0;
   assign ecchmatrix[0][122] = 0;
   assign ecchmatrix[1][122] = 0;
   assign ecchmatrix[2][122] = 1;
   assign ecchmatrix[3][122] = 0;
   assign ecchmatrix[4][122] = 0;
   assign ecchmatrix[5][122] = 0;
   assign ecchmatrix[6][122] = 0;
   assign ecchmatrix[7][122] = 0;
   assign ecchmatrix[0][123] = 0;
   assign ecchmatrix[1][123] = 0;
   assign ecchmatrix[2][123] = 0;
   assign ecchmatrix[3][123] = 1;
   assign ecchmatrix[4][123] = 0;
   assign ecchmatrix[5][123] = 0;
   assign ecchmatrix[6][123] = 0;
   assign ecchmatrix[7][123] = 0;
   assign ecchmatrix[0][124] = 0;
   assign ecchmatrix[1][124] = 0;
   assign ecchmatrix[2][124] = 0;
   assign ecchmatrix[3][124] = 0;
   assign ecchmatrix[4][124] = 1;
   assign ecchmatrix[5][124] = 0;
   assign ecchmatrix[6][124] = 0;
   assign ecchmatrix[7][124] = 0;
   assign ecchmatrix[0][125] = 0;
   assign ecchmatrix[1][125] = 0;
   assign ecchmatrix[2][125] = 0;
   assign ecchmatrix[3][125] = 0;
   assign ecchmatrix[4][125] = 0;
   assign ecchmatrix[5][125] = 1;
   assign ecchmatrix[6][125] = 0;
   assign ecchmatrix[7][125] = 0;
   assign ecchmatrix[0][126] = 0;
   assign ecchmatrix[1][126] = 0;
   assign ecchmatrix[2][126] = 0;
   assign ecchmatrix[3][126] = 0;
   assign ecchmatrix[4][126] = 0;
   assign ecchmatrix[5][126] = 0;
   assign ecchmatrix[6][126] = 1;
   assign ecchmatrix[7][126] = 0;
   assign ecchmatrix[0][127] = 0;
   assign ecchmatrix[1][127] = 0;
   assign ecchmatrix[2][127] = 0;
   assign ecchmatrix[3][127] = 0;
   assign ecchmatrix[4][127] = 0;
   assign ecchmatrix[5][127] = 0;
   assign ecchmatrix[6][127] = 0;
   assign ecchmatrix[7][127] = 1;


  assign sbits_wire[7] = (^(ecchmatrix[7]&din)) ^ eccin[7] ;
  assign sbits_wire[6] = (^(ecchmatrix[6]&din)) ^ eccin[6] ;
  assign sbits_wire[5] = (^(ecchmatrix[5]&din)) ^ eccin[5] ;
  assign sbits_wire[4] = (^(ecchmatrix[4]&din)) ^ eccin[4] ;
  assign sbits_wire[3] = (^(ecchmatrix[3]&din)) ^ eccin[3] ;
  assign sbits_wire[2] = (^(ecchmatrix[2]&din)) ^ eccin[2] ;
  assign sbits_wire[1] = (^(ecchmatrix[1]&din)) ^ eccin[1] ;
  assign sbits_wire[0] = (^(ecchmatrix[0]&din)) ^ eccin[0] ;

  wire [ECCWIDTH-1:0]    sbits;
  wire [ECCDWIDTH-1:0]	din_f1;
  generate if(FLOPECC1) begin
	reg [ECCWIDTH-1:0]    sbits_reg;
	reg [ECCDWIDTH-1:0]	din_f1_reg;
	always @(posedge clk) begin
		sbits_reg <= sbits_wire;
		din_f1_reg <= din;
	end
	assign sbits = sbits_reg;
	assign din_f1 = din_f1_reg;
  end else begin
	assign sbits = sbits_wire;
	assign din_f1 = din;
  end
  endgenerate
  
  assign biterr_wire[127] = ~(
         ecchmatrix[7][127]^sbits[7] |
         ecchmatrix[6][127]^sbits[6] |
         ecchmatrix[5][127]^sbits[5] |
         ecchmatrix[4][127]^sbits[4] |
         ecchmatrix[3][127]^sbits[3] |
         ecchmatrix[2][127]^sbits[2] |
         ecchmatrix[1][127]^sbits[1] |
         ecchmatrix[0][127]^sbits[0]);
  assign biterr_wire[126] = ~(
         ecchmatrix[7][126]^sbits[7] |
         ecchmatrix[6][126]^sbits[6] |
         ecchmatrix[5][126]^sbits[5] |
         ecchmatrix[4][126]^sbits[4] |
         ecchmatrix[3][126]^sbits[3] |
         ecchmatrix[2][126]^sbits[2] |
         ecchmatrix[1][126]^sbits[1] |
         ecchmatrix[0][126]^sbits[0]);
  assign biterr_wire[125] = ~(
         ecchmatrix[7][125]^sbits[7] |
         ecchmatrix[6][125]^sbits[6] |
         ecchmatrix[5][125]^sbits[5] |
         ecchmatrix[4][125]^sbits[4] |
         ecchmatrix[3][125]^sbits[3] |
         ecchmatrix[2][125]^sbits[2] |
         ecchmatrix[1][125]^sbits[1] |
         ecchmatrix[0][125]^sbits[0]);
  assign biterr_wire[124] = ~(
         ecchmatrix[7][124]^sbits[7] |
         ecchmatrix[6][124]^sbits[6] |
         ecchmatrix[5][124]^sbits[5] |
         ecchmatrix[4][124]^sbits[4] |
         ecchmatrix[3][124]^sbits[3] |
         ecchmatrix[2][124]^sbits[2] |
         ecchmatrix[1][124]^sbits[1] |
         ecchmatrix[0][124]^sbits[0]);
  assign biterr_wire[123] = ~(
         ecchmatrix[7][123]^sbits[7] |
         ecchmatrix[6][123]^sbits[6] |
         ecchmatrix[5][123]^sbits[5] |
         ecchmatrix[4][123]^sbits[4] |
         ecchmatrix[3][123]^sbits[3] |
         ecchmatrix[2][123]^sbits[2] |
         ecchmatrix[1][123]^sbits[1] |
         ecchmatrix[0][123]^sbits[0]);
  assign biterr_wire[122] = ~(
         ecchmatrix[7][122]^sbits[7] |
         ecchmatrix[6][122]^sbits[6] |
         ecchmatrix[5][122]^sbits[5] |
         ecchmatrix[4][122]^sbits[4] |
         ecchmatrix[3][122]^sbits[3] |
         ecchmatrix[2][122]^sbits[2] |
         ecchmatrix[1][122]^sbits[1] |
         ecchmatrix[0][122]^sbits[0]);
  assign biterr_wire[121] = ~(
         ecchmatrix[7][121]^sbits[7] |
         ecchmatrix[6][121]^sbits[6] |
         ecchmatrix[5][121]^sbits[5] |
         ecchmatrix[4][121]^sbits[4] |
         ecchmatrix[3][121]^sbits[3] |
         ecchmatrix[2][121]^sbits[2] |
         ecchmatrix[1][121]^sbits[1] |
         ecchmatrix[0][121]^sbits[0]);
  assign biterr_wire[120] = ~(
         ecchmatrix[7][120]^sbits[7] |
         ecchmatrix[6][120]^sbits[6] |
         ecchmatrix[5][120]^sbits[5] |
         ecchmatrix[4][120]^sbits[4] |
         ecchmatrix[3][120]^sbits[3] |
         ecchmatrix[2][120]^sbits[2] |
         ecchmatrix[1][120]^sbits[1] |
         ecchmatrix[0][120]^sbits[0]);
  assign biterr_wire[119] = ~(
         ecchmatrix[7][119]^sbits[7] |
         ecchmatrix[6][119]^sbits[6] |
         ecchmatrix[5][119]^sbits[5] |
         ecchmatrix[4][119]^sbits[4] |
         ecchmatrix[3][119]^sbits[3] |
         ecchmatrix[2][119]^sbits[2] |
         ecchmatrix[1][119]^sbits[1] |
         ecchmatrix[0][119]^sbits[0]);
  assign biterr_wire[118] = ~(
         ecchmatrix[7][118]^sbits[7] |
         ecchmatrix[6][118]^sbits[6] |
         ecchmatrix[5][118]^sbits[5] |
         ecchmatrix[4][118]^sbits[4] |
         ecchmatrix[3][118]^sbits[3] |
         ecchmatrix[2][118]^sbits[2] |
         ecchmatrix[1][118]^sbits[1] |
         ecchmatrix[0][118]^sbits[0]);
  assign biterr_wire[117] = ~(
         ecchmatrix[7][117]^sbits[7] |
         ecchmatrix[6][117]^sbits[6] |
         ecchmatrix[5][117]^sbits[5] |
         ecchmatrix[4][117]^sbits[4] |
         ecchmatrix[3][117]^sbits[3] |
         ecchmatrix[2][117]^sbits[2] |
         ecchmatrix[1][117]^sbits[1] |
         ecchmatrix[0][117]^sbits[0]);
  assign biterr_wire[116] = ~(
         ecchmatrix[7][116]^sbits[7] |
         ecchmatrix[6][116]^sbits[6] |
         ecchmatrix[5][116]^sbits[5] |
         ecchmatrix[4][116]^sbits[4] |
         ecchmatrix[3][116]^sbits[3] |
         ecchmatrix[2][116]^sbits[2] |
         ecchmatrix[1][116]^sbits[1] |
         ecchmatrix[0][116]^sbits[0]);
  assign biterr_wire[115] = ~(
         ecchmatrix[7][115]^sbits[7] |
         ecchmatrix[6][115]^sbits[6] |
         ecchmatrix[5][115]^sbits[5] |
         ecchmatrix[4][115]^sbits[4] |
         ecchmatrix[3][115]^sbits[3] |
         ecchmatrix[2][115]^sbits[2] |
         ecchmatrix[1][115]^sbits[1] |
         ecchmatrix[0][115]^sbits[0]);
  assign biterr_wire[114] = ~(
         ecchmatrix[7][114]^sbits[7] |
         ecchmatrix[6][114]^sbits[6] |
         ecchmatrix[5][114]^sbits[5] |
         ecchmatrix[4][114]^sbits[4] |
         ecchmatrix[3][114]^sbits[3] |
         ecchmatrix[2][114]^sbits[2] |
         ecchmatrix[1][114]^sbits[1] |
         ecchmatrix[0][114]^sbits[0]);
  assign biterr_wire[113] = ~(
         ecchmatrix[7][113]^sbits[7] |
         ecchmatrix[6][113]^sbits[6] |
         ecchmatrix[5][113]^sbits[5] |
         ecchmatrix[4][113]^sbits[4] |
         ecchmatrix[3][113]^sbits[3] |
         ecchmatrix[2][113]^sbits[2] |
         ecchmatrix[1][113]^sbits[1] |
         ecchmatrix[0][113]^sbits[0]);
  assign biterr_wire[112] = ~(
         ecchmatrix[7][112]^sbits[7] |
         ecchmatrix[6][112]^sbits[6] |
         ecchmatrix[5][112]^sbits[5] |
         ecchmatrix[4][112]^sbits[4] |
         ecchmatrix[3][112]^sbits[3] |
         ecchmatrix[2][112]^sbits[2] |
         ecchmatrix[1][112]^sbits[1] |
         ecchmatrix[0][112]^sbits[0]);
  assign biterr_wire[111] = ~(
         ecchmatrix[7][111]^sbits[7] |
         ecchmatrix[6][111]^sbits[6] |
         ecchmatrix[5][111]^sbits[5] |
         ecchmatrix[4][111]^sbits[4] |
         ecchmatrix[3][111]^sbits[3] |
         ecchmatrix[2][111]^sbits[2] |
         ecchmatrix[1][111]^sbits[1] |
         ecchmatrix[0][111]^sbits[0]);
  assign biterr_wire[110] = ~(
         ecchmatrix[7][110]^sbits[7] |
         ecchmatrix[6][110]^sbits[6] |
         ecchmatrix[5][110]^sbits[5] |
         ecchmatrix[4][110]^sbits[4] |
         ecchmatrix[3][110]^sbits[3] |
         ecchmatrix[2][110]^sbits[2] |
         ecchmatrix[1][110]^sbits[1] |
         ecchmatrix[0][110]^sbits[0]);
  assign biterr_wire[109] = ~(
         ecchmatrix[7][109]^sbits[7] |
         ecchmatrix[6][109]^sbits[6] |
         ecchmatrix[5][109]^sbits[5] |
         ecchmatrix[4][109]^sbits[4] |
         ecchmatrix[3][109]^sbits[3] |
         ecchmatrix[2][109]^sbits[2] |
         ecchmatrix[1][109]^sbits[1] |
         ecchmatrix[0][109]^sbits[0]);
  assign biterr_wire[108] = ~(
         ecchmatrix[7][108]^sbits[7] |
         ecchmatrix[6][108]^sbits[6] |
         ecchmatrix[5][108]^sbits[5] |
         ecchmatrix[4][108]^sbits[4] |
         ecchmatrix[3][108]^sbits[3] |
         ecchmatrix[2][108]^sbits[2] |
         ecchmatrix[1][108]^sbits[1] |
         ecchmatrix[0][108]^sbits[0]);
  assign biterr_wire[107] = ~(
         ecchmatrix[7][107]^sbits[7] |
         ecchmatrix[6][107]^sbits[6] |
         ecchmatrix[5][107]^sbits[5] |
         ecchmatrix[4][107]^sbits[4] |
         ecchmatrix[3][107]^sbits[3] |
         ecchmatrix[2][107]^sbits[2] |
         ecchmatrix[1][107]^sbits[1] |
         ecchmatrix[0][107]^sbits[0]);
  assign biterr_wire[106] = ~(
         ecchmatrix[7][106]^sbits[7] |
         ecchmatrix[6][106]^sbits[6] |
         ecchmatrix[5][106]^sbits[5] |
         ecchmatrix[4][106]^sbits[4] |
         ecchmatrix[3][106]^sbits[3] |
         ecchmatrix[2][106]^sbits[2] |
         ecchmatrix[1][106]^sbits[1] |
         ecchmatrix[0][106]^sbits[0]);
  assign biterr_wire[105] = ~(
         ecchmatrix[7][105]^sbits[7] |
         ecchmatrix[6][105]^sbits[6] |
         ecchmatrix[5][105]^sbits[5] |
         ecchmatrix[4][105]^sbits[4] |
         ecchmatrix[3][105]^sbits[3] |
         ecchmatrix[2][105]^sbits[2] |
         ecchmatrix[1][105]^sbits[1] |
         ecchmatrix[0][105]^sbits[0]);
  assign biterr_wire[104] = ~(
         ecchmatrix[7][104]^sbits[7] |
         ecchmatrix[6][104]^sbits[6] |
         ecchmatrix[5][104]^sbits[5] |
         ecchmatrix[4][104]^sbits[4] |
         ecchmatrix[3][104]^sbits[3] |
         ecchmatrix[2][104]^sbits[2] |
         ecchmatrix[1][104]^sbits[1] |
         ecchmatrix[0][104]^sbits[0]);
  assign biterr_wire[103] = ~(
         ecchmatrix[7][103]^sbits[7] |
         ecchmatrix[6][103]^sbits[6] |
         ecchmatrix[5][103]^sbits[5] |
         ecchmatrix[4][103]^sbits[4] |
         ecchmatrix[3][103]^sbits[3] |
         ecchmatrix[2][103]^sbits[2] |
         ecchmatrix[1][103]^sbits[1] |
         ecchmatrix[0][103]^sbits[0]);
  assign biterr_wire[102] = ~(
         ecchmatrix[7][102]^sbits[7] |
         ecchmatrix[6][102]^sbits[6] |
         ecchmatrix[5][102]^sbits[5] |
         ecchmatrix[4][102]^sbits[4] |
         ecchmatrix[3][102]^sbits[3] |
         ecchmatrix[2][102]^sbits[2] |
         ecchmatrix[1][102]^sbits[1] |
         ecchmatrix[0][102]^sbits[0]);
  assign biterr_wire[101] = ~(
         ecchmatrix[7][101]^sbits[7] |
         ecchmatrix[6][101]^sbits[6] |
         ecchmatrix[5][101]^sbits[5] |
         ecchmatrix[4][101]^sbits[4] |
         ecchmatrix[3][101]^sbits[3] |
         ecchmatrix[2][101]^sbits[2] |
         ecchmatrix[1][101]^sbits[1] |
         ecchmatrix[0][101]^sbits[0]);
  assign biterr_wire[100] = ~(
         ecchmatrix[7][100]^sbits[7] |
         ecchmatrix[6][100]^sbits[6] |
         ecchmatrix[5][100]^sbits[5] |
         ecchmatrix[4][100]^sbits[4] |
         ecchmatrix[3][100]^sbits[3] |
         ecchmatrix[2][100]^sbits[2] |
         ecchmatrix[1][100]^sbits[1] |
         ecchmatrix[0][100]^sbits[0]);
  assign biterr_wire[99] = ~(
         ecchmatrix[7][99]^sbits[7] |
         ecchmatrix[6][99]^sbits[6] |
         ecchmatrix[5][99]^sbits[5] |
         ecchmatrix[4][99]^sbits[4] |
         ecchmatrix[3][99]^sbits[3] |
         ecchmatrix[2][99]^sbits[2] |
         ecchmatrix[1][99]^sbits[1] |
         ecchmatrix[0][99]^sbits[0]);
  assign biterr_wire[98] = ~(
         ecchmatrix[7][98]^sbits[7] |
         ecchmatrix[6][98]^sbits[6] |
         ecchmatrix[5][98]^sbits[5] |
         ecchmatrix[4][98]^sbits[4] |
         ecchmatrix[3][98]^sbits[3] |
         ecchmatrix[2][98]^sbits[2] |
         ecchmatrix[1][98]^sbits[1] |
         ecchmatrix[0][98]^sbits[0]);
  assign biterr_wire[97] = ~(
         ecchmatrix[7][97]^sbits[7] |
         ecchmatrix[6][97]^sbits[6] |
         ecchmatrix[5][97]^sbits[5] |
         ecchmatrix[4][97]^sbits[4] |
         ecchmatrix[3][97]^sbits[3] |
         ecchmatrix[2][97]^sbits[2] |
         ecchmatrix[1][97]^sbits[1] |
         ecchmatrix[0][97]^sbits[0]);
  assign biterr_wire[96] = ~(
         ecchmatrix[7][96]^sbits[7] |
         ecchmatrix[6][96]^sbits[6] |
         ecchmatrix[5][96]^sbits[5] |
         ecchmatrix[4][96]^sbits[4] |
         ecchmatrix[3][96]^sbits[3] |
         ecchmatrix[2][96]^sbits[2] |
         ecchmatrix[1][96]^sbits[1] |
         ecchmatrix[0][96]^sbits[0]);
  assign biterr_wire[95] = ~(
         ecchmatrix[7][95]^sbits[7] |
         ecchmatrix[6][95]^sbits[6] |
         ecchmatrix[5][95]^sbits[5] |
         ecchmatrix[4][95]^sbits[4] |
         ecchmatrix[3][95]^sbits[3] |
         ecchmatrix[2][95]^sbits[2] |
         ecchmatrix[1][95]^sbits[1] |
         ecchmatrix[0][95]^sbits[0]);
  assign biterr_wire[94] = ~(
         ecchmatrix[7][94]^sbits[7] |
         ecchmatrix[6][94]^sbits[6] |
         ecchmatrix[5][94]^sbits[5] |
         ecchmatrix[4][94]^sbits[4] |
         ecchmatrix[3][94]^sbits[3] |
         ecchmatrix[2][94]^sbits[2] |
         ecchmatrix[1][94]^sbits[1] |
         ecchmatrix[0][94]^sbits[0]);
  assign biterr_wire[93] = ~(
         ecchmatrix[7][93]^sbits[7] |
         ecchmatrix[6][93]^sbits[6] |
         ecchmatrix[5][93]^sbits[5] |
         ecchmatrix[4][93]^sbits[4] |
         ecchmatrix[3][93]^sbits[3] |
         ecchmatrix[2][93]^sbits[2] |
         ecchmatrix[1][93]^sbits[1] |
         ecchmatrix[0][93]^sbits[0]);
  assign biterr_wire[92] = ~(
         ecchmatrix[7][92]^sbits[7] |
         ecchmatrix[6][92]^sbits[6] |
         ecchmatrix[5][92]^sbits[5] |
         ecchmatrix[4][92]^sbits[4] |
         ecchmatrix[3][92]^sbits[3] |
         ecchmatrix[2][92]^sbits[2] |
         ecchmatrix[1][92]^sbits[1] |
         ecchmatrix[0][92]^sbits[0]);
  assign biterr_wire[91] = ~(
         ecchmatrix[7][91]^sbits[7] |
         ecchmatrix[6][91]^sbits[6] |
         ecchmatrix[5][91]^sbits[5] |
         ecchmatrix[4][91]^sbits[4] |
         ecchmatrix[3][91]^sbits[3] |
         ecchmatrix[2][91]^sbits[2] |
         ecchmatrix[1][91]^sbits[1] |
         ecchmatrix[0][91]^sbits[0]);
  assign biterr_wire[90] = ~(
         ecchmatrix[7][90]^sbits[7] |
         ecchmatrix[6][90]^sbits[6] |
         ecchmatrix[5][90]^sbits[5] |
         ecchmatrix[4][90]^sbits[4] |
         ecchmatrix[3][90]^sbits[3] |
         ecchmatrix[2][90]^sbits[2] |
         ecchmatrix[1][90]^sbits[1] |
         ecchmatrix[0][90]^sbits[0]);
  assign biterr_wire[89] = ~(
         ecchmatrix[7][89]^sbits[7] |
         ecchmatrix[6][89]^sbits[6] |
         ecchmatrix[5][89]^sbits[5] |
         ecchmatrix[4][89]^sbits[4] |
         ecchmatrix[3][89]^sbits[3] |
         ecchmatrix[2][89]^sbits[2] |
         ecchmatrix[1][89]^sbits[1] |
         ecchmatrix[0][89]^sbits[0]);
  assign biterr_wire[88] = ~(
         ecchmatrix[7][88]^sbits[7] |
         ecchmatrix[6][88]^sbits[6] |
         ecchmatrix[5][88]^sbits[5] |
         ecchmatrix[4][88]^sbits[4] |
         ecchmatrix[3][88]^sbits[3] |
         ecchmatrix[2][88]^sbits[2] |
         ecchmatrix[1][88]^sbits[1] |
         ecchmatrix[0][88]^sbits[0]);
  assign biterr_wire[87] = ~(
         ecchmatrix[7][87]^sbits[7] |
         ecchmatrix[6][87]^sbits[6] |
         ecchmatrix[5][87]^sbits[5] |
         ecchmatrix[4][87]^sbits[4] |
         ecchmatrix[3][87]^sbits[3] |
         ecchmatrix[2][87]^sbits[2] |
         ecchmatrix[1][87]^sbits[1] |
         ecchmatrix[0][87]^sbits[0]);
  assign biterr_wire[86] = ~(
         ecchmatrix[7][86]^sbits[7] |
         ecchmatrix[6][86]^sbits[6] |
         ecchmatrix[5][86]^sbits[5] |
         ecchmatrix[4][86]^sbits[4] |
         ecchmatrix[3][86]^sbits[3] |
         ecchmatrix[2][86]^sbits[2] |
         ecchmatrix[1][86]^sbits[1] |
         ecchmatrix[0][86]^sbits[0]);
  assign biterr_wire[85] = ~(
         ecchmatrix[7][85]^sbits[7] |
         ecchmatrix[6][85]^sbits[6] |
         ecchmatrix[5][85]^sbits[5] |
         ecchmatrix[4][85]^sbits[4] |
         ecchmatrix[3][85]^sbits[3] |
         ecchmatrix[2][85]^sbits[2] |
         ecchmatrix[1][85]^sbits[1] |
         ecchmatrix[0][85]^sbits[0]);
  assign biterr_wire[84] = ~(
         ecchmatrix[7][84]^sbits[7] |
         ecchmatrix[6][84]^sbits[6] |
         ecchmatrix[5][84]^sbits[5] |
         ecchmatrix[4][84]^sbits[4] |
         ecchmatrix[3][84]^sbits[3] |
         ecchmatrix[2][84]^sbits[2] |
         ecchmatrix[1][84]^sbits[1] |
         ecchmatrix[0][84]^sbits[0]);
  assign biterr_wire[83] = ~(
         ecchmatrix[7][83]^sbits[7] |
         ecchmatrix[6][83]^sbits[6] |
         ecchmatrix[5][83]^sbits[5] |
         ecchmatrix[4][83]^sbits[4] |
         ecchmatrix[3][83]^sbits[3] |
         ecchmatrix[2][83]^sbits[2] |
         ecchmatrix[1][83]^sbits[1] |
         ecchmatrix[0][83]^sbits[0]);
  assign biterr_wire[82] = ~(
         ecchmatrix[7][82]^sbits[7] |
         ecchmatrix[6][82]^sbits[6] |
         ecchmatrix[5][82]^sbits[5] |
         ecchmatrix[4][82]^sbits[4] |
         ecchmatrix[3][82]^sbits[3] |
         ecchmatrix[2][82]^sbits[2] |
         ecchmatrix[1][82]^sbits[1] |
         ecchmatrix[0][82]^sbits[0]);
  assign biterr_wire[81] = ~(
         ecchmatrix[7][81]^sbits[7] |
         ecchmatrix[6][81]^sbits[6] |
         ecchmatrix[5][81]^sbits[5] |
         ecchmatrix[4][81]^sbits[4] |
         ecchmatrix[3][81]^sbits[3] |
         ecchmatrix[2][81]^sbits[2] |
         ecchmatrix[1][81]^sbits[1] |
         ecchmatrix[0][81]^sbits[0]);
  assign biterr_wire[80] = ~(
         ecchmatrix[7][80]^sbits[7] |
         ecchmatrix[6][80]^sbits[6] |
         ecchmatrix[5][80]^sbits[5] |
         ecchmatrix[4][80]^sbits[4] |
         ecchmatrix[3][80]^sbits[3] |
         ecchmatrix[2][80]^sbits[2] |
         ecchmatrix[1][80]^sbits[1] |
         ecchmatrix[0][80]^sbits[0]);
  assign biterr_wire[79] = ~(
         ecchmatrix[7][79]^sbits[7] |
         ecchmatrix[6][79]^sbits[6] |
         ecchmatrix[5][79]^sbits[5] |
         ecchmatrix[4][79]^sbits[4] |
         ecchmatrix[3][79]^sbits[3] |
         ecchmatrix[2][79]^sbits[2] |
         ecchmatrix[1][79]^sbits[1] |
         ecchmatrix[0][79]^sbits[0]);
  assign biterr_wire[78] = ~(
         ecchmatrix[7][78]^sbits[7] |
         ecchmatrix[6][78]^sbits[6] |
         ecchmatrix[5][78]^sbits[5] |
         ecchmatrix[4][78]^sbits[4] |
         ecchmatrix[3][78]^sbits[3] |
         ecchmatrix[2][78]^sbits[2] |
         ecchmatrix[1][78]^sbits[1] |
         ecchmatrix[0][78]^sbits[0]);
  assign biterr_wire[77] = ~(
         ecchmatrix[7][77]^sbits[7] |
         ecchmatrix[6][77]^sbits[6] |
         ecchmatrix[5][77]^sbits[5] |
         ecchmatrix[4][77]^sbits[4] |
         ecchmatrix[3][77]^sbits[3] |
         ecchmatrix[2][77]^sbits[2] |
         ecchmatrix[1][77]^sbits[1] |
         ecchmatrix[0][77]^sbits[0]);
  assign biterr_wire[76] = ~(
         ecchmatrix[7][76]^sbits[7] |
         ecchmatrix[6][76]^sbits[6] |
         ecchmatrix[5][76]^sbits[5] |
         ecchmatrix[4][76]^sbits[4] |
         ecchmatrix[3][76]^sbits[3] |
         ecchmatrix[2][76]^sbits[2] |
         ecchmatrix[1][76]^sbits[1] |
         ecchmatrix[0][76]^sbits[0]);
  assign biterr_wire[75] = ~(
         ecchmatrix[7][75]^sbits[7] |
         ecchmatrix[6][75]^sbits[6] |
         ecchmatrix[5][75]^sbits[5] |
         ecchmatrix[4][75]^sbits[4] |
         ecchmatrix[3][75]^sbits[3] |
         ecchmatrix[2][75]^sbits[2] |
         ecchmatrix[1][75]^sbits[1] |
         ecchmatrix[0][75]^sbits[0]);
  assign biterr_wire[74] = ~(
         ecchmatrix[7][74]^sbits[7] |
         ecchmatrix[6][74]^sbits[6] |
         ecchmatrix[5][74]^sbits[5] |
         ecchmatrix[4][74]^sbits[4] |
         ecchmatrix[3][74]^sbits[3] |
         ecchmatrix[2][74]^sbits[2] |
         ecchmatrix[1][74]^sbits[1] |
         ecchmatrix[0][74]^sbits[0]);
  assign biterr_wire[73] = ~(
         ecchmatrix[7][73]^sbits[7] |
         ecchmatrix[6][73]^sbits[6] |
         ecchmatrix[5][73]^sbits[5] |
         ecchmatrix[4][73]^sbits[4] |
         ecchmatrix[3][73]^sbits[3] |
         ecchmatrix[2][73]^sbits[2] |
         ecchmatrix[1][73]^sbits[1] |
         ecchmatrix[0][73]^sbits[0]);
  assign biterr_wire[72] = ~(
         ecchmatrix[7][72]^sbits[7] |
         ecchmatrix[6][72]^sbits[6] |
         ecchmatrix[5][72]^sbits[5] |
         ecchmatrix[4][72]^sbits[4] |
         ecchmatrix[3][72]^sbits[3] |
         ecchmatrix[2][72]^sbits[2] |
         ecchmatrix[1][72]^sbits[1] |
         ecchmatrix[0][72]^sbits[0]);
  assign biterr_wire[71] = ~(
         ecchmatrix[7][71]^sbits[7] |
         ecchmatrix[6][71]^sbits[6] |
         ecchmatrix[5][71]^sbits[5] |
         ecchmatrix[4][71]^sbits[4] |
         ecchmatrix[3][71]^sbits[3] |
         ecchmatrix[2][71]^sbits[2] |
         ecchmatrix[1][71]^sbits[1] |
         ecchmatrix[0][71]^sbits[0]);
  assign biterr_wire[70] = ~(
         ecchmatrix[7][70]^sbits[7] |
         ecchmatrix[6][70]^sbits[6] |
         ecchmatrix[5][70]^sbits[5] |
         ecchmatrix[4][70]^sbits[4] |
         ecchmatrix[3][70]^sbits[3] |
         ecchmatrix[2][70]^sbits[2] |
         ecchmatrix[1][70]^sbits[1] |
         ecchmatrix[0][70]^sbits[0]);
  assign biterr_wire[69] = ~(
         ecchmatrix[7][69]^sbits[7] |
         ecchmatrix[6][69]^sbits[6] |
         ecchmatrix[5][69]^sbits[5] |
         ecchmatrix[4][69]^sbits[4] |
         ecchmatrix[3][69]^sbits[3] |
         ecchmatrix[2][69]^sbits[2] |
         ecchmatrix[1][69]^sbits[1] |
         ecchmatrix[0][69]^sbits[0]);
  assign biterr_wire[68] = ~(
         ecchmatrix[7][68]^sbits[7] |
         ecchmatrix[6][68]^sbits[6] |
         ecchmatrix[5][68]^sbits[5] |
         ecchmatrix[4][68]^sbits[4] |
         ecchmatrix[3][68]^sbits[3] |
         ecchmatrix[2][68]^sbits[2] |
         ecchmatrix[1][68]^sbits[1] |
         ecchmatrix[0][68]^sbits[0]);
  assign biterr_wire[67] = ~(
         ecchmatrix[7][67]^sbits[7] |
         ecchmatrix[6][67]^sbits[6] |
         ecchmatrix[5][67]^sbits[5] |
         ecchmatrix[4][67]^sbits[4] |
         ecchmatrix[3][67]^sbits[3] |
         ecchmatrix[2][67]^sbits[2] |
         ecchmatrix[1][67]^sbits[1] |
         ecchmatrix[0][67]^sbits[0]);
  assign biterr_wire[66] = ~(
         ecchmatrix[7][66]^sbits[7] |
         ecchmatrix[6][66]^sbits[6] |
         ecchmatrix[5][66]^sbits[5] |
         ecchmatrix[4][66]^sbits[4] |
         ecchmatrix[3][66]^sbits[3] |
         ecchmatrix[2][66]^sbits[2] |
         ecchmatrix[1][66]^sbits[1] |
         ecchmatrix[0][66]^sbits[0]);
  assign biterr_wire[65] = ~(
         ecchmatrix[7][65]^sbits[7] |
         ecchmatrix[6][65]^sbits[6] |
         ecchmatrix[5][65]^sbits[5] |
         ecchmatrix[4][65]^sbits[4] |
         ecchmatrix[3][65]^sbits[3] |
         ecchmatrix[2][65]^sbits[2] |
         ecchmatrix[1][65]^sbits[1] |
         ecchmatrix[0][65]^sbits[0]);
  assign biterr_wire[64] = ~(
         ecchmatrix[7][64]^sbits[7] |
         ecchmatrix[6][64]^sbits[6] |
         ecchmatrix[5][64]^sbits[5] |
         ecchmatrix[4][64]^sbits[4] |
         ecchmatrix[3][64]^sbits[3] |
         ecchmatrix[2][64]^sbits[2] |
         ecchmatrix[1][64]^sbits[1] |
         ecchmatrix[0][64]^sbits[0]);
  assign biterr_wire[63] = ~(
         ecchmatrix[7][63]^sbits[7] |
         ecchmatrix[6][63]^sbits[6] |
         ecchmatrix[5][63]^sbits[5] |
         ecchmatrix[4][63]^sbits[4] |
         ecchmatrix[3][63]^sbits[3] |
         ecchmatrix[2][63]^sbits[2] |
         ecchmatrix[1][63]^sbits[1] |
         ecchmatrix[0][63]^sbits[0]);
  assign biterr_wire[62] = ~(
         ecchmatrix[7][62]^sbits[7] |
         ecchmatrix[6][62]^sbits[6] |
         ecchmatrix[5][62]^sbits[5] |
         ecchmatrix[4][62]^sbits[4] |
         ecchmatrix[3][62]^sbits[3] |
         ecchmatrix[2][62]^sbits[2] |
         ecchmatrix[1][62]^sbits[1] |
         ecchmatrix[0][62]^sbits[0]);
  assign biterr_wire[61] = ~(
         ecchmatrix[7][61]^sbits[7] |
         ecchmatrix[6][61]^sbits[6] |
         ecchmatrix[5][61]^sbits[5] |
         ecchmatrix[4][61]^sbits[4] |
         ecchmatrix[3][61]^sbits[3] |
         ecchmatrix[2][61]^sbits[2] |
         ecchmatrix[1][61]^sbits[1] |
         ecchmatrix[0][61]^sbits[0]);
  assign biterr_wire[60] = ~(
         ecchmatrix[7][60]^sbits[7] |
         ecchmatrix[6][60]^sbits[6] |
         ecchmatrix[5][60]^sbits[5] |
         ecchmatrix[4][60]^sbits[4] |
         ecchmatrix[3][60]^sbits[3] |
         ecchmatrix[2][60]^sbits[2] |
         ecchmatrix[1][60]^sbits[1] |
         ecchmatrix[0][60]^sbits[0]);
  assign biterr_wire[59] = ~(
         ecchmatrix[7][59]^sbits[7] |
         ecchmatrix[6][59]^sbits[6] |
         ecchmatrix[5][59]^sbits[5] |
         ecchmatrix[4][59]^sbits[4] |
         ecchmatrix[3][59]^sbits[3] |
         ecchmatrix[2][59]^sbits[2] |
         ecchmatrix[1][59]^sbits[1] |
         ecchmatrix[0][59]^sbits[0]);
  assign biterr_wire[58] = ~(
         ecchmatrix[7][58]^sbits[7] |
         ecchmatrix[6][58]^sbits[6] |
         ecchmatrix[5][58]^sbits[5] |
         ecchmatrix[4][58]^sbits[4] |
         ecchmatrix[3][58]^sbits[3] |
         ecchmatrix[2][58]^sbits[2] |
         ecchmatrix[1][58]^sbits[1] |
         ecchmatrix[0][58]^sbits[0]);
  assign biterr_wire[57] = ~(
         ecchmatrix[7][57]^sbits[7] |
         ecchmatrix[6][57]^sbits[6] |
         ecchmatrix[5][57]^sbits[5] |
         ecchmatrix[4][57]^sbits[4] |
         ecchmatrix[3][57]^sbits[3] |
         ecchmatrix[2][57]^sbits[2] |
         ecchmatrix[1][57]^sbits[1] |
         ecchmatrix[0][57]^sbits[0]);
  assign biterr_wire[56] = ~(
         ecchmatrix[7][56]^sbits[7] |
         ecchmatrix[6][56]^sbits[6] |
         ecchmatrix[5][56]^sbits[5] |
         ecchmatrix[4][56]^sbits[4] |
         ecchmatrix[3][56]^sbits[3] |
         ecchmatrix[2][56]^sbits[2] |
         ecchmatrix[1][56]^sbits[1] |
         ecchmatrix[0][56]^sbits[0]);
  assign biterr_wire[55] = ~(
         ecchmatrix[7][55]^sbits[7] |
         ecchmatrix[6][55]^sbits[6] |
         ecchmatrix[5][55]^sbits[5] |
         ecchmatrix[4][55]^sbits[4] |
         ecchmatrix[3][55]^sbits[3] |
         ecchmatrix[2][55]^sbits[2] |
         ecchmatrix[1][55]^sbits[1] |
         ecchmatrix[0][55]^sbits[0]);
  assign biterr_wire[54] = ~(
         ecchmatrix[7][54]^sbits[7] |
         ecchmatrix[6][54]^sbits[6] |
         ecchmatrix[5][54]^sbits[5] |
         ecchmatrix[4][54]^sbits[4] |
         ecchmatrix[3][54]^sbits[3] |
         ecchmatrix[2][54]^sbits[2] |
         ecchmatrix[1][54]^sbits[1] |
         ecchmatrix[0][54]^sbits[0]);
  assign biterr_wire[53] = ~(
         ecchmatrix[7][53]^sbits[7] |
         ecchmatrix[6][53]^sbits[6] |
         ecchmatrix[5][53]^sbits[5] |
         ecchmatrix[4][53]^sbits[4] |
         ecchmatrix[3][53]^sbits[3] |
         ecchmatrix[2][53]^sbits[2] |
         ecchmatrix[1][53]^sbits[1] |
         ecchmatrix[0][53]^sbits[0]);
  assign biterr_wire[52] = ~(
         ecchmatrix[7][52]^sbits[7] |
         ecchmatrix[6][52]^sbits[6] |
         ecchmatrix[5][52]^sbits[5] |
         ecchmatrix[4][52]^sbits[4] |
         ecchmatrix[3][52]^sbits[3] |
         ecchmatrix[2][52]^sbits[2] |
         ecchmatrix[1][52]^sbits[1] |
         ecchmatrix[0][52]^sbits[0]);
  assign biterr_wire[51] = ~(
         ecchmatrix[7][51]^sbits[7] |
         ecchmatrix[6][51]^sbits[6] |
         ecchmatrix[5][51]^sbits[5] |
         ecchmatrix[4][51]^sbits[4] |
         ecchmatrix[3][51]^sbits[3] |
         ecchmatrix[2][51]^sbits[2] |
         ecchmatrix[1][51]^sbits[1] |
         ecchmatrix[0][51]^sbits[0]);
  assign biterr_wire[50] = ~(
         ecchmatrix[7][50]^sbits[7] |
         ecchmatrix[6][50]^sbits[6] |
         ecchmatrix[5][50]^sbits[5] |
         ecchmatrix[4][50]^sbits[4] |
         ecchmatrix[3][50]^sbits[3] |
         ecchmatrix[2][50]^sbits[2] |
         ecchmatrix[1][50]^sbits[1] |
         ecchmatrix[0][50]^sbits[0]);
  assign biterr_wire[49] = ~(
         ecchmatrix[7][49]^sbits[7] |
         ecchmatrix[6][49]^sbits[6] |
         ecchmatrix[5][49]^sbits[5] |
         ecchmatrix[4][49]^sbits[4] |
         ecchmatrix[3][49]^sbits[3] |
         ecchmatrix[2][49]^sbits[2] |
         ecchmatrix[1][49]^sbits[1] |
         ecchmatrix[0][49]^sbits[0]);
  assign biterr_wire[48] = ~(
         ecchmatrix[7][48]^sbits[7] |
         ecchmatrix[6][48]^sbits[6] |
         ecchmatrix[5][48]^sbits[5] |
         ecchmatrix[4][48]^sbits[4] |
         ecchmatrix[3][48]^sbits[3] |
         ecchmatrix[2][48]^sbits[2] |
         ecchmatrix[1][48]^sbits[1] |
         ecchmatrix[0][48]^sbits[0]);
  assign biterr_wire[47] = ~(
         ecchmatrix[7][47]^sbits[7] |
         ecchmatrix[6][47]^sbits[6] |
         ecchmatrix[5][47]^sbits[5] |
         ecchmatrix[4][47]^sbits[4] |
         ecchmatrix[3][47]^sbits[3] |
         ecchmatrix[2][47]^sbits[2] |
         ecchmatrix[1][47]^sbits[1] |
         ecchmatrix[0][47]^sbits[0]);
  assign biterr_wire[46] = ~(
         ecchmatrix[7][46]^sbits[7] |
         ecchmatrix[6][46]^sbits[6] |
         ecchmatrix[5][46]^sbits[5] |
         ecchmatrix[4][46]^sbits[4] |
         ecchmatrix[3][46]^sbits[3] |
         ecchmatrix[2][46]^sbits[2] |
         ecchmatrix[1][46]^sbits[1] |
         ecchmatrix[0][46]^sbits[0]);
  assign biterr_wire[45] = ~(
         ecchmatrix[7][45]^sbits[7] |
         ecchmatrix[6][45]^sbits[6] |
         ecchmatrix[5][45]^sbits[5] |
         ecchmatrix[4][45]^sbits[4] |
         ecchmatrix[3][45]^sbits[3] |
         ecchmatrix[2][45]^sbits[2] |
         ecchmatrix[1][45]^sbits[1] |
         ecchmatrix[0][45]^sbits[0]);
  assign biterr_wire[44] = ~(
         ecchmatrix[7][44]^sbits[7] |
         ecchmatrix[6][44]^sbits[6] |
         ecchmatrix[5][44]^sbits[5] |
         ecchmatrix[4][44]^sbits[4] |
         ecchmatrix[3][44]^sbits[3] |
         ecchmatrix[2][44]^sbits[2] |
         ecchmatrix[1][44]^sbits[1] |
         ecchmatrix[0][44]^sbits[0]);
  assign biterr_wire[43] = ~(
         ecchmatrix[7][43]^sbits[7] |
         ecchmatrix[6][43]^sbits[6] |
         ecchmatrix[5][43]^sbits[5] |
         ecchmatrix[4][43]^sbits[4] |
         ecchmatrix[3][43]^sbits[3] |
         ecchmatrix[2][43]^sbits[2] |
         ecchmatrix[1][43]^sbits[1] |
         ecchmatrix[0][43]^sbits[0]);
  assign biterr_wire[42] = ~(
         ecchmatrix[7][42]^sbits[7] |
         ecchmatrix[6][42]^sbits[6] |
         ecchmatrix[5][42]^sbits[5] |
         ecchmatrix[4][42]^sbits[4] |
         ecchmatrix[3][42]^sbits[3] |
         ecchmatrix[2][42]^sbits[2] |
         ecchmatrix[1][42]^sbits[1] |
         ecchmatrix[0][42]^sbits[0]);
  assign biterr_wire[41] = ~(
         ecchmatrix[7][41]^sbits[7] |
         ecchmatrix[6][41]^sbits[6] |
         ecchmatrix[5][41]^sbits[5] |
         ecchmatrix[4][41]^sbits[4] |
         ecchmatrix[3][41]^sbits[3] |
         ecchmatrix[2][41]^sbits[2] |
         ecchmatrix[1][41]^sbits[1] |
         ecchmatrix[0][41]^sbits[0]);
  assign biterr_wire[40] = ~(
         ecchmatrix[7][40]^sbits[7] |
         ecchmatrix[6][40]^sbits[6] |
         ecchmatrix[5][40]^sbits[5] |
         ecchmatrix[4][40]^sbits[4] |
         ecchmatrix[3][40]^sbits[3] |
         ecchmatrix[2][40]^sbits[2] |
         ecchmatrix[1][40]^sbits[1] |
         ecchmatrix[0][40]^sbits[0]);
  assign biterr_wire[39] = ~(
         ecchmatrix[7][39]^sbits[7] |
         ecchmatrix[6][39]^sbits[6] |
         ecchmatrix[5][39]^sbits[5] |
         ecchmatrix[4][39]^sbits[4] |
         ecchmatrix[3][39]^sbits[3] |
         ecchmatrix[2][39]^sbits[2] |
         ecchmatrix[1][39]^sbits[1] |
         ecchmatrix[0][39]^sbits[0]);
  assign biterr_wire[38] = ~(
         ecchmatrix[7][38]^sbits[7] |
         ecchmatrix[6][38]^sbits[6] |
         ecchmatrix[5][38]^sbits[5] |
         ecchmatrix[4][38]^sbits[4] |
         ecchmatrix[3][38]^sbits[3] |
         ecchmatrix[2][38]^sbits[2] |
         ecchmatrix[1][38]^sbits[1] |
         ecchmatrix[0][38]^sbits[0]);
  assign biterr_wire[37] = ~(
         ecchmatrix[7][37]^sbits[7] |
         ecchmatrix[6][37]^sbits[6] |
         ecchmatrix[5][37]^sbits[5] |
         ecchmatrix[4][37]^sbits[4] |
         ecchmatrix[3][37]^sbits[3] |
         ecchmatrix[2][37]^sbits[2] |
         ecchmatrix[1][37]^sbits[1] |
         ecchmatrix[0][37]^sbits[0]);
  assign biterr_wire[36] = ~(
         ecchmatrix[7][36]^sbits[7] |
         ecchmatrix[6][36]^sbits[6] |
         ecchmatrix[5][36]^sbits[5] |
         ecchmatrix[4][36]^sbits[4] |
         ecchmatrix[3][36]^sbits[3] |
         ecchmatrix[2][36]^sbits[2] |
         ecchmatrix[1][36]^sbits[1] |
         ecchmatrix[0][36]^sbits[0]);
  assign biterr_wire[35] = ~(
         ecchmatrix[7][35]^sbits[7] |
         ecchmatrix[6][35]^sbits[6] |
         ecchmatrix[5][35]^sbits[5] |
         ecchmatrix[4][35]^sbits[4] |
         ecchmatrix[3][35]^sbits[3] |
         ecchmatrix[2][35]^sbits[2] |
         ecchmatrix[1][35]^sbits[1] |
         ecchmatrix[0][35]^sbits[0]);
  assign biterr_wire[34] = ~(
         ecchmatrix[7][34]^sbits[7] |
         ecchmatrix[6][34]^sbits[6] |
         ecchmatrix[5][34]^sbits[5] |
         ecchmatrix[4][34]^sbits[4] |
         ecchmatrix[3][34]^sbits[3] |
         ecchmatrix[2][34]^sbits[2] |
         ecchmatrix[1][34]^sbits[1] |
         ecchmatrix[0][34]^sbits[0]);
  assign biterr_wire[33] = ~(
         ecchmatrix[7][33]^sbits[7] |
         ecchmatrix[6][33]^sbits[6] |
         ecchmatrix[5][33]^sbits[5] |
         ecchmatrix[4][33]^sbits[4] |
         ecchmatrix[3][33]^sbits[3] |
         ecchmatrix[2][33]^sbits[2] |
         ecchmatrix[1][33]^sbits[1] |
         ecchmatrix[0][33]^sbits[0]);
  assign biterr_wire[32] = ~(
         ecchmatrix[7][32]^sbits[7] |
         ecchmatrix[6][32]^sbits[6] |
         ecchmatrix[5][32]^sbits[5] |
         ecchmatrix[4][32]^sbits[4] |
         ecchmatrix[3][32]^sbits[3] |
         ecchmatrix[2][32]^sbits[2] |
         ecchmatrix[1][32]^sbits[1] |
         ecchmatrix[0][32]^sbits[0]);
  assign biterr_wire[31] = ~(
         ecchmatrix[7][31]^sbits[7] |
         ecchmatrix[6][31]^sbits[6] |
         ecchmatrix[5][31]^sbits[5] |
         ecchmatrix[4][31]^sbits[4] |
         ecchmatrix[3][31]^sbits[3] |
         ecchmatrix[2][31]^sbits[2] |
         ecchmatrix[1][31]^sbits[1] |
         ecchmatrix[0][31]^sbits[0]);
  assign biterr_wire[30] = ~(
         ecchmatrix[7][30]^sbits[7] |
         ecchmatrix[6][30]^sbits[6] |
         ecchmatrix[5][30]^sbits[5] |
         ecchmatrix[4][30]^sbits[4] |
         ecchmatrix[3][30]^sbits[3] |
         ecchmatrix[2][30]^sbits[2] |
         ecchmatrix[1][30]^sbits[1] |
         ecchmatrix[0][30]^sbits[0]);
  assign biterr_wire[29] = ~(
         ecchmatrix[7][29]^sbits[7] |
         ecchmatrix[6][29]^sbits[6] |
         ecchmatrix[5][29]^sbits[5] |
         ecchmatrix[4][29]^sbits[4] |
         ecchmatrix[3][29]^sbits[3] |
         ecchmatrix[2][29]^sbits[2] |
         ecchmatrix[1][29]^sbits[1] |
         ecchmatrix[0][29]^sbits[0]);
  assign biterr_wire[28] = ~(
         ecchmatrix[7][28]^sbits[7] |
         ecchmatrix[6][28]^sbits[6] |
         ecchmatrix[5][28]^sbits[5] |
         ecchmatrix[4][28]^sbits[4] |
         ecchmatrix[3][28]^sbits[3] |
         ecchmatrix[2][28]^sbits[2] |
         ecchmatrix[1][28]^sbits[1] |
         ecchmatrix[0][28]^sbits[0]);
  assign biterr_wire[27] = ~(
         ecchmatrix[7][27]^sbits[7] |
         ecchmatrix[6][27]^sbits[6] |
         ecchmatrix[5][27]^sbits[5] |
         ecchmatrix[4][27]^sbits[4] |
         ecchmatrix[3][27]^sbits[3] |
         ecchmatrix[2][27]^sbits[2] |
         ecchmatrix[1][27]^sbits[1] |
         ecchmatrix[0][27]^sbits[0]);
  assign biterr_wire[26] = ~(
         ecchmatrix[7][26]^sbits[7] |
         ecchmatrix[6][26]^sbits[6] |
         ecchmatrix[5][26]^sbits[5] |
         ecchmatrix[4][26]^sbits[4] |
         ecchmatrix[3][26]^sbits[3] |
         ecchmatrix[2][26]^sbits[2] |
         ecchmatrix[1][26]^sbits[1] |
         ecchmatrix[0][26]^sbits[0]);
  assign biterr_wire[25] = ~(
         ecchmatrix[7][25]^sbits[7] |
         ecchmatrix[6][25]^sbits[6] |
         ecchmatrix[5][25]^sbits[5] |
         ecchmatrix[4][25]^sbits[4] |
         ecchmatrix[3][25]^sbits[3] |
         ecchmatrix[2][25]^sbits[2] |
         ecchmatrix[1][25]^sbits[1] |
         ecchmatrix[0][25]^sbits[0]);
  assign biterr_wire[24] = ~(
         ecchmatrix[7][24]^sbits[7] |
         ecchmatrix[6][24]^sbits[6] |
         ecchmatrix[5][24]^sbits[5] |
         ecchmatrix[4][24]^sbits[4] |
         ecchmatrix[3][24]^sbits[3] |
         ecchmatrix[2][24]^sbits[2] |
         ecchmatrix[1][24]^sbits[1] |
         ecchmatrix[0][24]^sbits[0]);
  assign biterr_wire[23] = ~(
         ecchmatrix[7][23]^sbits[7] |
         ecchmatrix[6][23]^sbits[6] |
         ecchmatrix[5][23]^sbits[5] |
         ecchmatrix[4][23]^sbits[4] |
         ecchmatrix[3][23]^sbits[3] |
         ecchmatrix[2][23]^sbits[2] |
         ecchmatrix[1][23]^sbits[1] |
         ecchmatrix[0][23]^sbits[0]);
  assign biterr_wire[22] = ~(
         ecchmatrix[7][22]^sbits[7] |
         ecchmatrix[6][22]^sbits[6] |
         ecchmatrix[5][22]^sbits[5] |
         ecchmatrix[4][22]^sbits[4] |
         ecchmatrix[3][22]^sbits[3] |
         ecchmatrix[2][22]^sbits[2] |
         ecchmatrix[1][22]^sbits[1] |
         ecchmatrix[0][22]^sbits[0]);
  assign biterr_wire[21] = ~(
         ecchmatrix[7][21]^sbits[7] |
         ecchmatrix[6][21]^sbits[6] |
         ecchmatrix[5][21]^sbits[5] |
         ecchmatrix[4][21]^sbits[4] |
         ecchmatrix[3][21]^sbits[3] |
         ecchmatrix[2][21]^sbits[2] |
         ecchmatrix[1][21]^sbits[1] |
         ecchmatrix[0][21]^sbits[0]);
  assign biterr_wire[20] = ~(
         ecchmatrix[7][20]^sbits[7] |
         ecchmatrix[6][20]^sbits[6] |
         ecchmatrix[5][20]^sbits[5] |
         ecchmatrix[4][20]^sbits[4] |
         ecchmatrix[3][20]^sbits[3] |
         ecchmatrix[2][20]^sbits[2] |
         ecchmatrix[1][20]^sbits[1] |
         ecchmatrix[0][20]^sbits[0]);
  assign biterr_wire[19] = ~(
         ecchmatrix[7][19]^sbits[7] |
         ecchmatrix[6][19]^sbits[6] |
         ecchmatrix[5][19]^sbits[5] |
         ecchmatrix[4][19]^sbits[4] |
         ecchmatrix[3][19]^sbits[3] |
         ecchmatrix[2][19]^sbits[2] |
         ecchmatrix[1][19]^sbits[1] |
         ecchmatrix[0][19]^sbits[0]);
  assign biterr_wire[18] = ~(
         ecchmatrix[7][18]^sbits[7] |
         ecchmatrix[6][18]^sbits[6] |
         ecchmatrix[5][18]^sbits[5] |
         ecchmatrix[4][18]^sbits[4] |
         ecchmatrix[3][18]^sbits[3] |
         ecchmatrix[2][18]^sbits[2] |
         ecchmatrix[1][18]^sbits[1] |
         ecchmatrix[0][18]^sbits[0]);
  assign biterr_wire[17] = ~(
         ecchmatrix[7][17]^sbits[7] |
         ecchmatrix[6][17]^sbits[6] |
         ecchmatrix[5][17]^sbits[5] |
         ecchmatrix[4][17]^sbits[4] |
         ecchmatrix[3][17]^sbits[3] |
         ecchmatrix[2][17]^sbits[2] |
         ecchmatrix[1][17]^sbits[1] |
         ecchmatrix[0][17]^sbits[0]);
  assign biterr_wire[16] = ~(
         ecchmatrix[7][16]^sbits[7] |
         ecchmatrix[6][16]^sbits[6] |
         ecchmatrix[5][16]^sbits[5] |
         ecchmatrix[4][16]^sbits[4] |
         ecchmatrix[3][16]^sbits[3] |
         ecchmatrix[2][16]^sbits[2] |
         ecchmatrix[1][16]^sbits[1] |
         ecchmatrix[0][16]^sbits[0]);
  assign biterr_wire[15] = ~(
         ecchmatrix[7][15]^sbits[7] |
         ecchmatrix[6][15]^sbits[6] |
         ecchmatrix[5][15]^sbits[5] |
         ecchmatrix[4][15]^sbits[4] |
         ecchmatrix[3][15]^sbits[3] |
         ecchmatrix[2][15]^sbits[2] |
         ecchmatrix[1][15]^sbits[1] |
         ecchmatrix[0][15]^sbits[0]);
  assign biterr_wire[14] = ~(
         ecchmatrix[7][14]^sbits[7] |
         ecchmatrix[6][14]^sbits[6] |
         ecchmatrix[5][14]^sbits[5] |
         ecchmatrix[4][14]^sbits[4] |
         ecchmatrix[3][14]^sbits[3] |
         ecchmatrix[2][14]^sbits[2] |
         ecchmatrix[1][14]^sbits[1] |
         ecchmatrix[0][14]^sbits[0]);
  assign biterr_wire[13] = ~(
         ecchmatrix[7][13]^sbits[7] |
         ecchmatrix[6][13]^sbits[6] |
         ecchmatrix[5][13]^sbits[5] |
         ecchmatrix[4][13]^sbits[4] |
         ecchmatrix[3][13]^sbits[3] |
         ecchmatrix[2][13]^sbits[2] |
         ecchmatrix[1][13]^sbits[1] |
         ecchmatrix[0][13]^sbits[0]);
  assign biterr_wire[12] = ~(
         ecchmatrix[7][12]^sbits[7] |
         ecchmatrix[6][12]^sbits[6] |
         ecchmatrix[5][12]^sbits[5] |
         ecchmatrix[4][12]^sbits[4] |
         ecchmatrix[3][12]^sbits[3] |
         ecchmatrix[2][12]^sbits[2] |
         ecchmatrix[1][12]^sbits[1] |
         ecchmatrix[0][12]^sbits[0]);
  assign biterr_wire[11] = ~(
         ecchmatrix[7][11]^sbits[7] |
         ecchmatrix[6][11]^sbits[6] |
         ecchmatrix[5][11]^sbits[5] |
         ecchmatrix[4][11]^sbits[4] |
         ecchmatrix[3][11]^sbits[3] |
         ecchmatrix[2][11]^sbits[2] |
         ecchmatrix[1][11]^sbits[1] |
         ecchmatrix[0][11]^sbits[0]);
  assign biterr_wire[10] = ~(
         ecchmatrix[7][10]^sbits[7] |
         ecchmatrix[6][10]^sbits[6] |
         ecchmatrix[5][10]^sbits[5] |
         ecchmatrix[4][10]^sbits[4] |
         ecchmatrix[3][10]^sbits[3] |
         ecchmatrix[2][10]^sbits[2] |
         ecchmatrix[1][10]^sbits[1] |
         ecchmatrix[0][10]^sbits[0]);
  assign biterr_wire[9] = ~(
         ecchmatrix[7][9]^sbits[7] |
         ecchmatrix[6][9]^sbits[6] |
         ecchmatrix[5][9]^sbits[5] |
         ecchmatrix[4][9]^sbits[4] |
         ecchmatrix[3][9]^sbits[3] |
         ecchmatrix[2][9]^sbits[2] |
         ecchmatrix[1][9]^sbits[1] |
         ecchmatrix[0][9]^sbits[0]);
  assign biterr_wire[8] = ~(
         ecchmatrix[7][8]^sbits[7] |
         ecchmatrix[6][8]^sbits[6] |
         ecchmatrix[5][8]^sbits[5] |
         ecchmatrix[4][8]^sbits[4] |
         ecchmatrix[3][8]^sbits[3] |
         ecchmatrix[2][8]^sbits[2] |
         ecchmatrix[1][8]^sbits[1] |
         ecchmatrix[0][8]^sbits[0]);
  assign biterr_wire[7] = ~(
         ecchmatrix[7][7]^sbits[7] |
         ecchmatrix[6][7]^sbits[6] |
         ecchmatrix[5][7]^sbits[5] |
         ecchmatrix[4][7]^sbits[4] |
         ecchmatrix[3][7]^sbits[3] |
         ecchmatrix[2][7]^sbits[2] |
         ecchmatrix[1][7]^sbits[1] |
         ecchmatrix[0][7]^sbits[0]);
  assign biterr_wire[6] = ~(
         ecchmatrix[7][6]^sbits[7] |
         ecchmatrix[6][6]^sbits[6] |
         ecchmatrix[5][6]^sbits[5] |
         ecchmatrix[4][6]^sbits[4] |
         ecchmatrix[3][6]^sbits[3] |
         ecchmatrix[2][6]^sbits[2] |
         ecchmatrix[1][6]^sbits[1] |
         ecchmatrix[0][6]^sbits[0]);
  assign biterr_wire[5] = ~(
         ecchmatrix[7][5]^sbits[7] |
         ecchmatrix[6][5]^sbits[6] |
         ecchmatrix[5][5]^sbits[5] |
         ecchmatrix[4][5]^sbits[4] |
         ecchmatrix[3][5]^sbits[3] |
         ecchmatrix[2][5]^sbits[2] |
         ecchmatrix[1][5]^sbits[1] |
         ecchmatrix[0][5]^sbits[0]);
  assign biterr_wire[4] = ~(
         ecchmatrix[7][4]^sbits[7] |
         ecchmatrix[6][4]^sbits[6] |
         ecchmatrix[5][4]^sbits[5] |
         ecchmatrix[4][4]^sbits[4] |
         ecchmatrix[3][4]^sbits[3] |
         ecchmatrix[2][4]^sbits[2] |
         ecchmatrix[1][4]^sbits[1] |
         ecchmatrix[0][4]^sbits[0]);
  assign biterr_wire[3] = ~(
         ecchmatrix[7][3]^sbits[7] |
         ecchmatrix[6][3]^sbits[6] |
         ecchmatrix[5][3]^sbits[5] |
         ecchmatrix[4][3]^sbits[4] |
         ecchmatrix[3][3]^sbits[3] |
         ecchmatrix[2][3]^sbits[2] |
         ecchmatrix[1][3]^sbits[1] |
         ecchmatrix[0][3]^sbits[0]);
  assign biterr_wire[2] = ~(
         ecchmatrix[7][2]^sbits[7] |
         ecchmatrix[6][2]^sbits[6] |
         ecchmatrix[5][2]^sbits[5] |
         ecchmatrix[4][2]^sbits[4] |
         ecchmatrix[3][2]^sbits[3] |
         ecchmatrix[2][2]^sbits[2] |
         ecchmatrix[1][2]^sbits[1] |
         ecchmatrix[0][2]^sbits[0]);
  assign biterr_wire[1] = ~(
         ecchmatrix[7][1]^sbits[7] |
         ecchmatrix[6][1]^sbits[6] |
         ecchmatrix[5][1]^sbits[5] |
         ecchmatrix[4][1]^sbits[4] |
         ecchmatrix[3][1]^sbits[3] |
         ecchmatrix[2][1]^sbits[2] |
         ecchmatrix[1][1]^sbits[1] |
         ecchmatrix[0][1]^sbits[0]);
  assign biterr_wire[0] = ~(
         ecchmatrix[7][0]^sbits[7] |
         ecchmatrix[6][0]^sbits[6] |
         ecchmatrix[5][0]^sbits[5] |
         ecchmatrix[4][0]^sbits[4] |
         ecchmatrix[3][0]^sbits[3] |
         ecchmatrix[2][0]^sbits[2] |
         ecchmatrix[1][0]^sbits[1] |
         ecchmatrix[0][0]^sbits[0]);

  wire [ECCDWIDTH+ECCWIDTH-1:0]   biterr;
  wire [ECCDWIDTH-1:0]	din_f2;
  wire [ECCWIDTH-1:0]   sbits_f2;
  generate if(FLOPECC2) begin
	reg [ECCDWIDTH+ECCWIDTH-1:0]   biterr_reg;
	reg [ECCDWIDTH-1:0]	din_f2_reg;
	reg [ECCWIDTH-1:0] sbits_f2_reg;
	always @(posedge clk) begin
		biterr_reg <= biterr_wire;
		din_f2_reg <= din_f1;
		sbits_f2_reg <= sbits;
	end
	assign biterr = biterr_reg;
	assign din_f2 = din_f2_reg;
	assign sbits_f2 = sbits_f2_reg;
  end else begin
	assign biterr = biterr_wire;
	assign din_f2 = din_f1;
	assign sbits_f2 = sbits;
  end
  endgenerate
		 
 assign  dout    = din_f2 ^ biterr;
 assign  sec_err = |biterr;
 assign  ded_err = |sbits_f2 & ~|biterr;

endmodule

module ecc_check_247 #(parameter FLOPECC1=0, parameter FLOPECC2=0) (din,  eccin, dout, sec_err, ded_err, clk, rst);

  localparam ECCDWIDTH = 247;
  localparam ECCWIDTH  = 9;
  
  input [ECCDWIDTH-1:0]            din;  
  input [ECCWIDTH-1:0]             eccin;

  output [ECCDWIDTH-1:0]           dout;  
  output                           sec_err; // asserted if a single error is detected/corrected
  output                           ded_err; // asserted if two errors are detected

  input                            clk;
  input                            rst;

  wire       sec_err;
  wire       ded_err;
  wire [ECCDWIDTH-1:0]      dout;
  
  wire [ECCDWIDTH+ECCWIDTH-1:0]   ecchmatrix [0:ECCWIDTH-1];
  wire [ECCWIDTH-1:0]    sbits_wire;

  wire [ECCDWIDTH+ECCWIDTH-1:0]   biterr_wire;

// Generate the H Matrix in Perl

   assign ecchmatrix[0][0] = 1;
   assign ecchmatrix[1][0] = 1;
   assign ecchmatrix[2][0] = 1;
   assign ecchmatrix[3][0] = 0;
   assign ecchmatrix[4][0] = 0;
   assign ecchmatrix[5][0] = 0;
   assign ecchmatrix[6][0] = 0;
   assign ecchmatrix[7][0] = 0;
   assign ecchmatrix[8][0] = 0;
   assign ecchmatrix[0][1] = 1;
   assign ecchmatrix[1][1] = 1;
   assign ecchmatrix[2][1] = 0;
   assign ecchmatrix[3][1] = 1;
   assign ecchmatrix[4][1] = 0;
   assign ecchmatrix[5][1] = 0;
   assign ecchmatrix[6][1] = 0;
   assign ecchmatrix[7][1] = 0;
   assign ecchmatrix[8][1] = 0;
   assign ecchmatrix[0][2] = 1;
   assign ecchmatrix[1][2] = 1;
   assign ecchmatrix[2][2] = 0;
   assign ecchmatrix[3][2] = 0;
   assign ecchmatrix[4][2] = 1;
   assign ecchmatrix[5][2] = 0;
   assign ecchmatrix[6][2] = 0;
   assign ecchmatrix[7][2] = 0;
   assign ecchmatrix[8][2] = 0;
   assign ecchmatrix[0][3] = 1;
   assign ecchmatrix[1][3] = 1;
   assign ecchmatrix[2][3] = 0;
   assign ecchmatrix[3][3] = 0;
   assign ecchmatrix[4][3] = 0;
   assign ecchmatrix[5][3] = 1;
   assign ecchmatrix[6][3] = 0;
   assign ecchmatrix[7][3] = 0;
   assign ecchmatrix[8][3] = 0;
   assign ecchmatrix[0][4] = 1;
   assign ecchmatrix[1][4] = 1;
   assign ecchmatrix[2][4] = 0;
   assign ecchmatrix[3][4] = 0;
   assign ecchmatrix[4][4] = 0;
   assign ecchmatrix[5][4] = 0;
   assign ecchmatrix[6][4] = 1;
   assign ecchmatrix[7][4] = 0;
   assign ecchmatrix[8][4] = 0;
   assign ecchmatrix[0][5] = 1;
   assign ecchmatrix[1][5] = 1;
   assign ecchmatrix[2][5] = 0;
   assign ecchmatrix[3][5] = 0;
   assign ecchmatrix[4][5] = 0;
   assign ecchmatrix[5][5] = 0;
   assign ecchmatrix[6][5] = 0;
   assign ecchmatrix[7][5] = 1;
   assign ecchmatrix[8][5] = 0;
   assign ecchmatrix[0][6] = 1;
   assign ecchmatrix[1][6] = 1;
   assign ecchmatrix[2][6] = 0;
   assign ecchmatrix[3][6] = 0;
   assign ecchmatrix[4][6] = 0;
   assign ecchmatrix[5][6] = 0;
   assign ecchmatrix[6][6] = 0;
   assign ecchmatrix[7][6] = 0;
   assign ecchmatrix[8][6] = 1;
   assign ecchmatrix[0][7] = 1;
   assign ecchmatrix[1][7] = 0;
   assign ecchmatrix[2][7] = 1;
   assign ecchmatrix[3][7] = 1;
   assign ecchmatrix[4][7] = 0;
   assign ecchmatrix[5][7] = 0;
   assign ecchmatrix[6][7] = 0;
   assign ecchmatrix[7][7] = 0;
   assign ecchmatrix[8][7] = 0;
   assign ecchmatrix[0][8] = 1;
   assign ecchmatrix[1][8] = 0;
   assign ecchmatrix[2][8] = 1;
   assign ecchmatrix[3][8] = 0;
   assign ecchmatrix[4][8] = 1;
   assign ecchmatrix[5][8] = 0;
   assign ecchmatrix[6][8] = 0;
   assign ecchmatrix[7][8] = 0;
   assign ecchmatrix[8][8] = 0;
   assign ecchmatrix[0][9] = 1;
   assign ecchmatrix[1][9] = 0;
   assign ecchmatrix[2][9] = 1;
   assign ecchmatrix[3][9] = 0;
   assign ecchmatrix[4][9] = 0;
   assign ecchmatrix[5][9] = 1;
   assign ecchmatrix[6][9] = 0;
   assign ecchmatrix[7][9] = 0;
   assign ecchmatrix[8][9] = 0;
   assign ecchmatrix[0][10] = 1;
   assign ecchmatrix[1][10] = 0;
   assign ecchmatrix[2][10] = 1;
   assign ecchmatrix[3][10] = 0;
   assign ecchmatrix[4][10] = 0;
   assign ecchmatrix[5][10] = 0;
   assign ecchmatrix[6][10] = 1;
   assign ecchmatrix[7][10] = 0;
   assign ecchmatrix[8][10] = 0;
   assign ecchmatrix[0][11] = 1;
   assign ecchmatrix[1][11] = 0;
   assign ecchmatrix[2][11] = 1;
   assign ecchmatrix[3][11] = 0;
   assign ecchmatrix[4][11] = 0;
   assign ecchmatrix[5][11] = 0;
   assign ecchmatrix[6][11] = 0;
   assign ecchmatrix[7][11] = 1;
   assign ecchmatrix[8][11] = 0;
   assign ecchmatrix[0][12] = 1;
   assign ecchmatrix[1][12] = 0;
   assign ecchmatrix[2][12] = 1;
   assign ecchmatrix[3][12] = 0;
   assign ecchmatrix[4][12] = 0;
   assign ecchmatrix[5][12] = 0;
   assign ecchmatrix[6][12] = 0;
   assign ecchmatrix[7][12] = 0;
   assign ecchmatrix[8][12] = 1;
   assign ecchmatrix[0][13] = 1;
   assign ecchmatrix[1][13] = 0;
   assign ecchmatrix[2][13] = 0;
   assign ecchmatrix[3][13] = 1;
   assign ecchmatrix[4][13] = 1;
   assign ecchmatrix[5][13] = 0;
   assign ecchmatrix[6][13] = 0;
   assign ecchmatrix[7][13] = 0;
   assign ecchmatrix[8][13] = 0;
   assign ecchmatrix[0][14] = 1;
   assign ecchmatrix[1][14] = 0;
   assign ecchmatrix[2][14] = 0;
   assign ecchmatrix[3][14] = 1;
   assign ecchmatrix[4][14] = 0;
   assign ecchmatrix[5][14] = 1;
   assign ecchmatrix[6][14] = 0;
   assign ecchmatrix[7][14] = 0;
   assign ecchmatrix[8][14] = 0;
   assign ecchmatrix[0][15] = 1;
   assign ecchmatrix[1][15] = 0;
   assign ecchmatrix[2][15] = 0;
   assign ecchmatrix[3][15] = 1;
   assign ecchmatrix[4][15] = 0;
   assign ecchmatrix[5][15] = 0;
   assign ecchmatrix[6][15] = 1;
   assign ecchmatrix[7][15] = 0;
   assign ecchmatrix[8][15] = 0;
   assign ecchmatrix[0][16] = 1;
   assign ecchmatrix[1][16] = 0;
   assign ecchmatrix[2][16] = 0;
   assign ecchmatrix[3][16] = 1;
   assign ecchmatrix[4][16] = 0;
   assign ecchmatrix[5][16] = 0;
   assign ecchmatrix[6][16] = 0;
   assign ecchmatrix[7][16] = 1;
   assign ecchmatrix[8][16] = 0;
   assign ecchmatrix[0][17] = 1;
   assign ecchmatrix[1][17] = 0;
   assign ecchmatrix[2][17] = 0;
   assign ecchmatrix[3][17] = 1;
   assign ecchmatrix[4][17] = 0;
   assign ecchmatrix[5][17] = 0;
   assign ecchmatrix[6][17] = 0;
   assign ecchmatrix[7][17] = 0;
   assign ecchmatrix[8][17] = 1;
   assign ecchmatrix[0][18] = 1;
   assign ecchmatrix[1][18] = 0;
   assign ecchmatrix[2][18] = 0;
   assign ecchmatrix[3][18] = 0;
   assign ecchmatrix[4][18] = 1;
   assign ecchmatrix[5][18] = 1;
   assign ecchmatrix[6][18] = 0;
   assign ecchmatrix[7][18] = 0;
   assign ecchmatrix[8][18] = 0;
   assign ecchmatrix[0][19] = 1;
   assign ecchmatrix[1][19] = 0;
   assign ecchmatrix[2][19] = 0;
   assign ecchmatrix[3][19] = 0;
   assign ecchmatrix[4][19] = 1;
   assign ecchmatrix[5][19] = 0;
   assign ecchmatrix[6][19] = 1;
   assign ecchmatrix[7][19] = 0;
   assign ecchmatrix[8][19] = 0;
   assign ecchmatrix[0][20] = 1;
   assign ecchmatrix[1][20] = 0;
   assign ecchmatrix[2][20] = 0;
   assign ecchmatrix[3][20] = 0;
   assign ecchmatrix[4][20] = 1;
   assign ecchmatrix[5][20] = 0;
   assign ecchmatrix[6][20] = 0;
   assign ecchmatrix[7][20] = 1;
   assign ecchmatrix[8][20] = 0;
   assign ecchmatrix[0][21] = 1;
   assign ecchmatrix[1][21] = 0;
   assign ecchmatrix[2][21] = 0;
   assign ecchmatrix[3][21] = 0;
   assign ecchmatrix[4][21] = 1;
   assign ecchmatrix[5][21] = 0;
   assign ecchmatrix[6][21] = 0;
   assign ecchmatrix[7][21] = 0;
   assign ecchmatrix[8][21] = 1;
   assign ecchmatrix[0][22] = 1;
   assign ecchmatrix[1][22] = 0;
   assign ecchmatrix[2][22] = 0;
   assign ecchmatrix[3][22] = 0;
   assign ecchmatrix[4][22] = 0;
   assign ecchmatrix[5][22] = 1;
   assign ecchmatrix[6][22] = 1;
   assign ecchmatrix[7][22] = 0;
   assign ecchmatrix[8][22] = 0;
   assign ecchmatrix[0][23] = 1;
   assign ecchmatrix[1][23] = 0;
   assign ecchmatrix[2][23] = 0;
   assign ecchmatrix[3][23] = 0;
   assign ecchmatrix[4][23] = 0;
   assign ecchmatrix[5][23] = 1;
   assign ecchmatrix[6][23] = 0;
   assign ecchmatrix[7][23] = 1;
   assign ecchmatrix[8][23] = 0;
   assign ecchmatrix[0][24] = 1;
   assign ecchmatrix[1][24] = 0;
   assign ecchmatrix[2][24] = 0;
   assign ecchmatrix[3][24] = 0;
   assign ecchmatrix[4][24] = 0;
   assign ecchmatrix[5][24] = 1;
   assign ecchmatrix[6][24] = 0;
   assign ecchmatrix[7][24] = 0;
   assign ecchmatrix[8][24] = 1;
   assign ecchmatrix[0][25] = 1;
   assign ecchmatrix[1][25] = 0;
   assign ecchmatrix[2][25] = 0;
   assign ecchmatrix[3][25] = 0;
   assign ecchmatrix[4][25] = 0;
   assign ecchmatrix[5][25] = 0;
   assign ecchmatrix[6][25] = 1;
   assign ecchmatrix[7][25] = 1;
   assign ecchmatrix[8][25] = 0;
   assign ecchmatrix[0][26] = 1;
   assign ecchmatrix[1][26] = 0;
   assign ecchmatrix[2][26] = 0;
   assign ecchmatrix[3][26] = 0;
   assign ecchmatrix[4][26] = 0;
   assign ecchmatrix[5][26] = 0;
   assign ecchmatrix[6][26] = 1;
   assign ecchmatrix[7][26] = 0;
   assign ecchmatrix[8][26] = 1;
   assign ecchmatrix[0][27] = 1;
   assign ecchmatrix[1][27] = 0;
   assign ecchmatrix[2][27] = 0;
   assign ecchmatrix[3][27] = 0;
   assign ecchmatrix[4][27] = 0;
   assign ecchmatrix[5][27] = 0;
   assign ecchmatrix[6][27] = 0;
   assign ecchmatrix[7][27] = 1;
   assign ecchmatrix[8][27] = 1;
   assign ecchmatrix[0][28] = 0;
   assign ecchmatrix[1][28] = 1;
   assign ecchmatrix[2][28] = 1;
   assign ecchmatrix[3][28] = 1;
   assign ecchmatrix[4][28] = 0;
   assign ecchmatrix[5][28] = 0;
   assign ecchmatrix[6][28] = 0;
   assign ecchmatrix[7][28] = 0;
   assign ecchmatrix[8][28] = 0;
   assign ecchmatrix[0][29] = 0;
   assign ecchmatrix[1][29] = 1;
   assign ecchmatrix[2][29] = 1;
   assign ecchmatrix[3][29] = 0;
   assign ecchmatrix[4][29] = 1;
   assign ecchmatrix[5][29] = 0;
   assign ecchmatrix[6][29] = 0;
   assign ecchmatrix[7][29] = 0;
   assign ecchmatrix[8][29] = 0;
   assign ecchmatrix[0][30] = 0;
   assign ecchmatrix[1][30] = 1;
   assign ecchmatrix[2][30] = 1;
   assign ecchmatrix[3][30] = 0;
   assign ecchmatrix[4][30] = 0;
   assign ecchmatrix[5][30] = 1;
   assign ecchmatrix[6][30] = 0;
   assign ecchmatrix[7][30] = 0;
   assign ecchmatrix[8][30] = 0;
   assign ecchmatrix[0][31] = 0;
   assign ecchmatrix[1][31] = 1;
   assign ecchmatrix[2][31] = 1;
   assign ecchmatrix[3][31] = 0;
   assign ecchmatrix[4][31] = 0;
   assign ecchmatrix[5][31] = 0;
   assign ecchmatrix[6][31] = 1;
   assign ecchmatrix[7][31] = 0;
   assign ecchmatrix[8][31] = 0;
   assign ecchmatrix[0][32] = 0;
   assign ecchmatrix[1][32] = 1;
   assign ecchmatrix[2][32] = 1;
   assign ecchmatrix[3][32] = 0;
   assign ecchmatrix[4][32] = 0;
   assign ecchmatrix[5][32] = 0;
   assign ecchmatrix[6][32] = 0;
   assign ecchmatrix[7][32] = 1;
   assign ecchmatrix[8][32] = 0;
   assign ecchmatrix[0][33] = 0;
   assign ecchmatrix[1][33] = 1;
   assign ecchmatrix[2][33] = 1;
   assign ecchmatrix[3][33] = 0;
   assign ecchmatrix[4][33] = 0;
   assign ecchmatrix[5][33] = 0;
   assign ecchmatrix[6][33] = 0;
   assign ecchmatrix[7][33] = 0;
   assign ecchmatrix[8][33] = 1;
   assign ecchmatrix[0][34] = 0;
   assign ecchmatrix[1][34] = 1;
   assign ecchmatrix[2][34] = 0;
   assign ecchmatrix[3][34] = 1;
   assign ecchmatrix[4][34] = 1;
   assign ecchmatrix[5][34] = 0;
   assign ecchmatrix[6][34] = 0;
   assign ecchmatrix[7][34] = 0;
   assign ecchmatrix[8][34] = 0;
   assign ecchmatrix[0][35] = 0;
   assign ecchmatrix[1][35] = 1;
   assign ecchmatrix[2][35] = 0;
   assign ecchmatrix[3][35] = 1;
   assign ecchmatrix[4][35] = 0;
   assign ecchmatrix[5][35] = 1;
   assign ecchmatrix[6][35] = 0;
   assign ecchmatrix[7][35] = 0;
   assign ecchmatrix[8][35] = 0;
   assign ecchmatrix[0][36] = 0;
   assign ecchmatrix[1][36] = 1;
   assign ecchmatrix[2][36] = 0;
   assign ecchmatrix[3][36] = 1;
   assign ecchmatrix[4][36] = 0;
   assign ecchmatrix[5][36] = 0;
   assign ecchmatrix[6][36] = 1;
   assign ecchmatrix[7][36] = 0;
   assign ecchmatrix[8][36] = 0;
   assign ecchmatrix[0][37] = 0;
   assign ecchmatrix[1][37] = 1;
   assign ecchmatrix[2][37] = 0;
   assign ecchmatrix[3][37] = 1;
   assign ecchmatrix[4][37] = 0;
   assign ecchmatrix[5][37] = 0;
   assign ecchmatrix[6][37] = 0;
   assign ecchmatrix[7][37] = 1;
   assign ecchmatrix[8][37] = 0;
   assign ecchmatrix[0][38] = 0;
   assign ecchmatrix[1][38] = 1;
   assign ecchmatrix[2][38] = 0;
   assign ecchmatrix[3][38] = 1;
   assign ecchmatrix[4][38] = 0;
   assign ecchmatrix[5][38] = 0;
   assign ecchmatrix[6][38] = 0;
   assign ecchmatrix[7][38] = 0;
   assign ecchmatrix[8][38] = 1;
   assign ecchmatrix[0][39] = 0;
   assign ecchmatrix[1][39] = 1;
   assign ecchmatrix[2][39] = 0;
   assign ecchmatrix[3][39] = 0;
   assign ecchmatrix[4][39] = 1;
   assign ecchmatrix[5][39] = 1;
   assign ecchmatrix[6][39] = 0;
   assign ecchmatrix[7][39] = 0;
   assign ecchmatrix[8][39] = 0;
   assign ecchmatrix[0][40] = 0;
   assign ecchmatrix[1][40] = 1;
   assign ecchmatrix[2][40] = 0;
   assign ecchmatrix[3][40] = 0;
   assign ecchmatrix[4][40] = 1;
   assign ecchmatrix[5][40] = 0;
   assign ecchmatrix[6][40] = 1;
   assign ecchmatrix[7][40] = 0;
   assign ecchmatrix[8][40] = 0;
   assign ecchmatrix[0][41] = 0;
   assign ecchmatrix[1][41] = 1;
   assign ecchmatrix[2][41] = 0;
   assign ecchmatrix[3][41] = 0;
   assign ecchmatrix[4][41] = 1;
   assign ecchmatrix[5][41] = 0;
   assign ecchmatrix[6][41] = 0;
   assign ecchmatrix[7][41] = 1;
   assign ecchmatrix[8][41] = 0;
   assign ecchmatrix[0][42] = 0;
   assign ecchmatrix[1][42] = 1;
   assign ecchmatrix[2][42] = 0;
   assign ecchmatrix[3][42] = 0;
   assign ecchmatrix[4][42] = 1;
   assign ecchmatrix[5][42] = 0;
   assign ecchmatrix[6][42] = 0;
   assign ecchmatrix[7][42] = 0;
   assign ecchmatrix[8][42] = 1;
   assign ecchmatrix[0][43] = 0;
   assign ecchmatrix[1][43] = 1;
   assign ecchmatrix[2][43] = 0;
   assign ecchmatrix[3][43] = 0;
   assign ecchmatrix[4][43] = 0;
   assign ecchmatrix[5][43] = 1;
   assign ecchmatrix[6][43] = 1;
   assign ecchmatrix[7][43] = 0;
   assign ecchmatrix[8][43] = 0;
   assign ecchmatrix[0][44] = 0;
   assign ecchmatrix[1][44] = 1;
   assign ecchmatrix[2][44] = 0;
   assign ecchmatrix[3][44] = 0;
   assign ecchmatrix[4][44] = 0;
   assign ecchmatrix[5][44] = 1;
   assign ecchmatrix[6][44] = 0;
   assign ecchmatrix[7][44] = 1;
   assign ecchmatrix[8][44] = 0;
   assign ecchmatrix[0][45] = 0;
   assign ecchmatrix[1][45] = 1;
   assign ecchmatrix[2][45] = 0;
   assign ecchmatrix[3][45] = 0;
   assign ecchmatrix[4][45] = 0;
   assign ecchmatrix[5][45] = 1;
   assign ecchmatrix[6][45] = 0;
   assign ecchmatrix[7][45] = 0;
   assign ecchmatrix[8][45] = 1;
   assign ecchmatrix[0][46] = 0;
   assign ecchmatrix[1][46] = 1;
   assign ecchmatrix[2][46] = 0;
   assign ecchmatrix[3][46] = 0;
   assign ecchmatrix[4][46] = 0;
   assign ecchmatrix[5][46] = 0;
   assign ecchmatrix[6][46] = 1;
   assign ecchmatrix[7][46] = 1;
   assign ecchmatrix[8][46] = 0;
   assign ecchmatrix[0][47] = 0;
   assign ecchmatrix[1][47] = 1;
   assign ecchmatrix[2][47] = 0;
   assign ecchmatrix[3][47] = 0;
   assign ecchmatrix[4][47] = 0;
   assign ecchmatrix[5][47] = 0;
   assign ecchmatrix[6][47] = 1;
   assign ecchmatrix[7][47] = 0;
   assign ecchmatrix[8][47] = 1;
   assign ecchmatrix[0][48] = 0;
   assign ecchmatrix[1][48] = 1;
   assign ecchmatrix[2][48] = 0;
   assign ecchmatrix[3][48] = 0;
   assign ecchmatrix[4][48] = 0;
   assign ecchmatrix[5][48] = 0;
   assign ecchmatrix[6][48] = 0;
   assign ecchmatrix[7][48] = 1;
   assign ecchmatrix[8][48] = 1;
   assign ecchmatrix[0][49] = 0;
   assign ecchmatrix[1][49] = 0;
   assign ecchmatrix[2][49] = 1;
   assign ecchmatrix[3][49] = 1;
   assign ecchmatrix[4][49] = 1;
   assign ecchmatrix[5][49] = 0;
   assign ecchmatrix[6][49] = 0;
   assign ecchmatrix[7][49] = 0;
   assign ecchmatrix[8][49] = 0;
   assign ecchmatrix[0][50] = 0;
   assign ecchmatrix[1][50] = 0;
   assign ecchmatrix[2][50] = 1;
   assign ecchmatrix[3][50] = 1;
   assign ecchmatrix[4][50] = 0;
   assign ecchmatrix[5][50] = 1;
   assign ecchmatrix[6][50] = 0;
   assign ecchmatrix[7][50] = 0;
   assign ecchmatrix[8][50] = 0;
   assign ecchmatrix[0][51] = 0;
   assign ecchmatrix[1][51] = 0;
   assign ecchmatrix[2][51] = 1;
   assign ecchmatrix[3][51] = 1;
   assign ecchmatrix[4][51] = 0;
   assign ecchmatrix[5][51] = 0;
   assign ecchmatrix[6][51] = 1;
   assign ecchmatrix[7][51] = 0;
   assign ecchmatrix[8][51] = 0;
   assign ecchmatrix[0][52] = 0;
   assign ecchmatrix[1][52] = 0;
   assign ecchmatrix[2][52] = 1;
   assign ecchmatrix[3][52] = 1;
   assign ecchmatrix[4][52] = 0;
   assign ecchmatrix[5][52] = 0;
   assign ecchmatrix[6][52] = 0;
   assign ecchmatrix[7][52] = 1;
   assign ecchmatrix[8][52] = 0;
   assign ecchmatrix[0][53] = 0;
   assign ecchmatrix[1][53] = 0;
   assign ecchmatrix[2][53] = 1;
   assign ecchmatrix[3][53] = 1;
   assign ecchmatrix[4][53] = 0;
   assign ecchmatrix[5][53] = 0;
   assign ecchmatrix[6][53] = 0;
   assign ecchmatrix[7][53] = 0;
   assign ecchmatrix[8][53] = 1;
   assign ecchmatrix[0][54] = 0;
   assign ecchmatrix[1][54] = 0;
   assign ecchmatrix[2][54] = 1;
   assign ecchmatrix[3][54] = 0;
   assign ecchmatrix[4][54] = 1;
   assign ecchmatrix[5][54] = 1;
   assign ecchmatrix[6][54] = 0;
   assign ecchmatrix[7][54] = 0;
   assign ecchmatrix[8][54] = 0;
   assign ecchmatrix[0][55] = 0;
   assign ecchmatrix[1][55] = 0;
   assign ecchmatrix[2][55] = 1;
   assign ecchmatrix[3][55] = 0;
   assign ecchmatrix[4][55] = 1;
   assign ecchmatrix[5][55] = 0;
   assign ecchmatrix[6][55] = 1;
   assign ecchmatrix[7][55] = 0;
   assign ecchmatrix[8][55] = 0;
   assign ecchmatrix[0][56] = 0;
   assign ecchmatrix[1][56] = 0;
   assign ecchmatrix[2][56] = 1;
   assign ecchmatrix[3][56] = 0;
   assign ecchmatrix[4][56] = 1;
   assign ecchmatrix[5][56] = 0;
   assign ecchmatrix[6][56] = 0;
   assign ecchmatrix[7][56] = 1;
   assign ecchmatrix[8][56] = 0;
   assign ecchmatrix[0][57] = 0;
   assign ecchmatrix[1][57] = 0;
   assign ecchmatrix[2][57] = 1;
   assign ecchmatrix[3][57] = 0;
   assign ecchmatrix[4][57] = 1;
   assign ecchmatrix[5][57] = 0;
   assign ecchmatrix[6][57] = 0;
   assign ecchmatrix[7][57] = 0;
   assign ecchmatrix[8][57] = 1;
   assign ecchmatrix[0][58] = 0;
   assign ecchmatrix[1][58] = 0;
   assign ecchmatrix[2][58] = 1;
   assign ecchmatrix[3][58] = 0;
   assign ecchmatrix[4][58] = 0;
   assign ecchmatrix[5][58] = 1;
   assign ecchmatrix[6][58] = 1;
   assign ecchmatrix[7][58] = 0;
   assign ecchmatrix[8][58] = 0;
   assign ecchmatrix[0][59] = 0;
   assign ecchmatrix[1][59] = 0;
   assign ecchmatrix[2][59] = 1;
   assign ecchmatrix[3][59] = 0;
   assign ecchmatrix[4][59] = 0;
   assign ecchmatrix[5][59] = 1;
   assign ecchmatrix[6][59] = 0;
   assign ecchmatrix[7][59] = 1;
   assign ecchmatrix[8][59] = 0;
   assign ecchmatrix[0][60] = 0;
   assign ecchmatrix[1][60] = 0;
   assign ecchmatrix[2][60] = 1;
   assign ecchmatrix[3][60] = 0;
   assign ecchmatrix[4][60] = 0;
   assign ecchmatrix[5][60] = 1;
   assign ecchmatrix[6][60] = 0;
   assign ecchmatrix[7][60] = 0;
   assign ecchmatrix[8][60] = 1;
   assign ecchmatrix[0][61] = 0;
   assign ecchmatrix[1][61] = 0;
   assign ecchmatrix[2][61] = 1;
   assign ecchmatrix[3][61] = 0;
   assign ecchmatrix[4][61] = 0;
   assign ecchmatrix[5][61] = 0;
   assign ecchmatrix[6][61] = 1;
   assign ecchmatrix[7][61] = 1;
   assign ecchmatrix[8][61] = 0;
   assign ecchmatrix[0][62] = 0;
   assign ecchmatrix[1][62] = 0;
   assign ecchmatrix[2][62] = 1;
   assign ecchmatrix[3][62] = 0;
   assign ecchmatrix[4][62] = 0;
   assign ecchmatrix[5][62] = 0;
   assign ecchmatrix[6][62] = 1;
   assign ecchmatrix[7][62] = 0;
   assign ecchmatrix[8][62] = 1;
   assign ecchmatrix[0][63] = 0;
   assign ecchmatrix[1][63] = 0;
   assign ecchmatrix[2][63] = 1;
   assign ecchmatrix[3][63] = 0;
   assign ecchmatrix[4][63] = 0;
   assign ecchmatrix[5][63] = 0;
   assign ecchmatrix[6][63] = 0;
   assign ecchmatrix[7][63] = 1;
   assign ecchmatrix[8][63] = 1;
   assign ecchmatrix[0][64] = 0;
   assign ecchmatrix[1][64] = 0;
   assign ecchmatrix[2][64] = 0;
   assign ecchmatrix[3][64] = 1;
   assign ecchmatrix[4][64] = 1;
   assign ecchmatrix[5][64] = 1;
   assign ecchmatrix[6][64] = 0;
   assign ecchmatrix[7][64] = 0;
   assign ecchmatrix[8][64] = 0;
   assign ecchmatrix[0][65] = 0;
   assign ecchmatrix[1][65] = 0;
   assign ecchmatrix[2][65] = 0;
   assign ecchmatrix[3][65] = 1;
   assign ecchmatrix[4][65] = 1;
   assign ecchmatrix[5][65] = 0;
   assign ecchmatrix[6][65] = 1;
   assign ecchmatrix[7][65] = 0;
   assign ecchmatrix[8][65] = 0;
   assign ecchmatrix[0][66] = 0;
   assign ecchmatrix[1][66] = 0;
   assign ecchmatrix[2][66] = 0;
   assign ecchmatrix[3][66] = 1;
   assign ecchmatrix[4][66] = 1;
   assign ecchmatrix[5][66] = 0;
   assign ecchmatrix[6][66] = 0;
   assign ecchmatrix[7][66] = 1;
   assign ecchmatrix[8][66] = 0;
   assign ecchmatrix[0][67] = 0;
   assign ecchmatrix[1][67] = 0;
   assign ecchmatrix[2][67] = 0;
   assign ecchmatrix[3][67] = 1;
   assign ecchmatrix[4][67] = 1;
   assign ecchmatrix[5][67] = 0;
   assign ecchmatrix[6][67] = 0;
   assign ecchmatrix[7][67] = 0;
   assign ecchmatrix[8][67] = 1;
   assign ecchmatrix[0][68] = 0;
   assign ecchmatrix[1][68] = 0;
   assign ecchmatrix[2][68] = 0;
   assign ecchmatrix[3][68] = 1;
   assign ecchmatrix[4][68] = 0;
   assign ecchmatrix[5][68] = 1;
   assign ecchmatrix[6][68] = 1;
   assign ecchmatrix[7][68] = 0;
   assign ecchmatrix[8][68] = 0;
   assign ecchmatrix[0][69] = 0;
   assign ecchmatrix[1][69] = 0;
   assign ecchmatrix[2][69] = 0;
   assign ecchmatrix[3][69] = 1;
   assign ecchmatrix[4][69] = 0;
   assign ecchmatrix[5][69] = 1;
   assign ecchmatrix[6][69] = 0;
   assign ecchmatrix[7][69] = 1;
   assign ecchmatrix[8][69] = 0;
   assign ecchmatrix[0][70] = 0;
   assign ecchmatrix[1][70] = 0;
   assign ecchmatrix[2][70] = 0;
   assign ecchmatrix[3][70] = 1;
   assign ecchmatrix[4][70] = 0;
   assign ecchmatrix[5][70] = 1;
   assign ecchmatrix[6][70] = 0;
   assign ecchmatrix[7][70] = 0;
   assign ecchmatrix[8][70] = 1;
   assign ecchmatrix[0][71] = 0;
   assign ecchmatrix[1][71] = 0;
   assign ecchmatrix[2][71] = 0;
   assign ecchmatrix[3][71] = 1;
   assign ecchmatrix[4][71] = 0;
   assign ecchmatrix[5][71] = 0;
   assign ecchmatrix[6][71] = 1;
   assign ecchmatrix[7][71] = 1;
   assign ecchmatrix[8][71] = 0;
   assign ecchmatrix[0][72] = 0;
   assign ecchmatrix[1][72] = 0;
   assign ecchmatrix[2][72] = 0;
   assign ecchmatrix[3][72] = 1;
   assign ecchmatrix[4][72] = 0;
   assign ecchmatrix[5][72] = 0;
   assign ecchmatrix[6][72] = 1;
   assign ecchmatrix[7][72] = 0;
   assign ecchmatrix[8][72] = 1;
   assign ecchmatrix[0][73] = 0;
   assign ecchmatrix[1][73] = 0;
   assign ecchmatrix[2][73] = 0;
   assign ecchmatrix[3][73] = 1;
   assign ecchmatrix[4][73] = 0;
   assign ecchmatrix[5][73] = 0;
   assign ecchmatrix[6][73] = 0;
   assign ecchmatrix[7][73] = 1;
   assign ecchmatrix[8][73] = 1;
   assign ecchmatrix[0][74] = 0;
   assign ecchmatrix[1][74] = 0;
   assign ecchmatrix[2][74] = 0;
   assign ecchmatrix[3][74] = 0;
   assign ecchmatrix[4][74] = 1;
   assign ecchmatrix[5][74] = 1;
   assign ecchmatrix[6][74] = 1;
   assign ecchmatrix[7][74] = 0;
   assign ecchmatrix[8][74] = 0;
   assign ecchmatrix[0][75] = 0;
   assign ecchmatrix[1][75] = 0;
   assign ecchmatrix[2][75] = 0;
   assign ecchmatrix[3][75] = 0;
   assign ecchmatrix[4][75] = 1;
   assign ecchmatrix[5][75] = 1;
   assign ecchmatrix[6][75] = 0;
   assign ecchmatrix[7][75] = 1;
   assign ecchmatrix[8][75] = 0;
   assign ecchmatrix[0][76] = 0;
   assign ecchmatrix[1][76] = 0;
   assign ecchmatrix[2][76] = 0;
   assign ecchmatrix[3][76] = 0;
   assign ecchmatrix[4][76] = 1;
   assign ecchmatrix[5][76] = 1;
   assign ecchmatrix[6][76] = 0;
   assign ecchmatrix[7][76] = 0;
   assign ecchmatrix[8][76] = 1;
   assign ecchmatrix[0][77] = 0;
   assign ecchmatrix[1][77] = 0;
   assign ecchmatrix[2][77] = 0;
   assign ecchmatrix[3][77] = 0;
   assign ecchmatrix[4][77] = 1;
   assign ecchmatrix[5][77] = 0;
   assign ecchmatrix[6][77] = 1;
   assign ecchmatrix[7][77] = 1;
   assign ecchmatrix[8][77] = 0;
   assign ecchmatrix[0][78] = 0;
   assign ecchmatrix[1][78] = 0;
   assign ecchmatrix[2][78] = 0;
   assign ecchmatrix[3][78] = 0;
   assign ecchmatrix[4][78] = 1;
   assign ecchmatrix[5][78] = 0;
   assign ecchmatrix[6][78] = 1;
   assign ecchmatrix[7][78] = 0;
   assign ecchmatrix[8][78] = 1;
   assign ecchmatrix[0][79] = 0;
   assign ecchmatrix[1][79] = 0;
   assign ecchmatrix[2][79] = 0;
   assign ecchmatrix[3][79] = 0;
   assign ecchmatrix[4][79] = 1;
   assign ecchmatrix[5][79] = 0;
   assign ecchmatrix[6][79] = 0;
   assign ecchmatrix[7][79] = 1;
   assign ecchmatrix[8][79] = 1;
   assign ecchmatrix[0][80] = 0;
   assign ecchmatrix[1][80] = 0;
   assign ecchmatrix[2][80] = 0;
   assign ecchmatrix[3][80] = 0;
   assign ecchmatrix[4][80] = 0;
   assign ecchmatrix[5][80] = 1;
   assign ecchmatrix[6][80] = 1;
   assign ecchmatrix[7][80] = 1;
   assign ecchmatrix[8][80] = 0;
   assign ecchmatrix[0][81] = 0;
   assign ecchmatrix[1][81] = 0;
   assign ecchmatrix[2][81] = 0;
   assign ecchmatrix[3][81] = 0;
   assign ecchmatrix[4][81] = 0;
   assign ecchmatrix[5][81] = 1;
   assign ecchmatrix[6][81] = 1;
   assign ecchmatrix[7][81] = 0;
   assign ecchmatrix[8][81] = 1;
   assign ecchmatrix[0][82] = 0;
   assign ecchmatrix[1][82] = 0;
   assign ecchmatrix[2][82] = 0;
   assign ecchmatrix[3][82] = 0;
   assign ecchmatrix[4][82] = 0;
   assign ecchmatrix[5][82] = 1;
   assign ecchmatrix[6][82] = 0;
   assign ecchmatrix[7][82] = 1;
   assign ecchmatrix[8][82] = 1;
   assign ecchmatrix[0][83] = 0;
   assign ecchmatrix[1][83] = 0;
   assign ecchmatrix[2][83] = 0;
   assign ecchmatrix[3][83] = 0;
   assign ecchmatrix[4][83] = 0;
   assign ecchmatrix[5][83] = 0;
   assign ecchmatrix[6][83] = 1;
   assign ecchmatrix[7][83] = 1;
   assign ecchmatrix[8][83] = 1;
   assign ecchmatrix[0][84] = 1;
   assign ecchmatrix[1][84] = 1;
   assign ecchmatrix[2][84] = 1;
   assign ecchmatrix[3][84] = 1;
   assign ecchmatrix[4][84] = 1;
   assign ecchmatrix[5][84] = 0;
   assign ecchmatrix[6][84] = 0;
   assign ecchmatrix[7][84] = 0;
   assign ecchmatrix[8][84] = 0;
   assign ecchmatrix[0][85] = 1;
   assign ecchmatrix[1][85] = 1;
   assign ecchmatrix[2][85] = 1;
   assign ecchmatrix[3][85] = 1;
   assign ecchmatrix[4][85] = 0;
   assign ecchmatrix[5][85] = 1;
   assign ecchmatrix[6][85] = 0;
   assign ecchmatrix[7][85] = 0;
   assign ecchmatrix[8][85] = 0;
   assign ecchmatrix[0][86] = 1;
   assign ecchmatrix[1][86] = 1;
   assign ecchmatrix[2][86] = 1;
   assign ecchmatrix[3][86] = 1;
   assign ecchmatrix[4][86] = 0;
   assign ecchmatrix[5][86] = 0;
   assign ecchmatrix[6][86] = 1;
   assign ecchmatrix[7][86] = 0;
   assign ecchmatrix[8][86] = 0;
   assign ecchmatrix[0][87] = 1;
   assign ecchmatrix[1][87] = 1;
   assign ecchmatrix[2][87] = 1;
   assign ecchmatrix[3][87] = 1;
   assign ecchmatrix[4][87] = 0;
   assign ecchmatrix[5][87] = 0;
   assign ecchmatrix[6][87] = 0;
   assign ecchmatrix[7][87] = 1;
   assign ecchmatrix[8][87] = 0;
   assign ecchmatrix[0][88] = 1;
   assign ecchmatrix[1][88] = 1;
   assign ecchmatrix[2][88] = 1;
   assign ecchmatrix[3][88] = 1;
   assign ecchmatrix[4][88] = 0;
   assign ecchmatrix[5][88] = 0;
   assign ecchmatrix[6][88] = 0;
   assign ecchmatrix[7][88] = 0;
   assign ecchmatrix[8][88] = 1;
   assign ecchmatrix[0][89] = 1;
   assign ecchmatrix[1][89] = 1;
   assign ecchmatrix[2][89] = 1;
   assign ecchmatrix[3][89] = 0;
   assign ecchmatrix[4][89] = 1;
   assign ecchmatrix[5][89] = 1;
   assign ecchmatrix[6][89] = 0;
   assign ecchmatrix[7][89] = 0;
   assign ecchmatrix[8][89] = 0;
   assign ecchmatrix[0][90] = 1;
   assign ecchmatrix[1][90] = 1;
   assign ecchmatrix[2][90] = 1;
   assign ecchmatrix[3][90] = 0;
   assign ecchmatrix[4][90] = 1;
   assign ecchmatrix[5][90] = 0;
   assign ecchmatrix[6][90] = 1;
   assign ecchmatrix[7][90] = 0;
   assign ecchmatrix[8][90] = 0;
   assign ecchmatrix[0][91] = 1;
   assign ecchmatrix[1][91] = 1;
   assign ecchmatrix[2][91] = 1;
   assign ecchmatrix[3][91] = 0;
   assign ecchmatrix[4][91] = 1;
   assign ecchmatrix[5][91] = 0;
   assign ecchmatrix[6][91] = 0;
   assign ecchmatrix[7][91] = 1;
   assign ecchmatrix[8][91] = 0;
   assign ecchmatrix[0][92] = 1;
   assign ecchmatrix[1][92] = 1;
   assign ecchmatrix[2][92] = 1;
   assign ecchmatrix[3][92] = 0;
   assign ecchmatrix[4][92] = 1;
   assign ecchmatrix[5][92] = 0;
   assign ecchmatrix[6][92] = 0;
   assign ecchmatrix[7][92] = 0;
   assign ecchmatrix[8][92] = 1;
   assign ecchmatrix[0][93] = 1;
   assign ecchmatrix[1][93] = 1;
   assign ecchmatrix[2][93] = 1;
   assign ecchmatrix[3][93] = 0;
   assign ecchmatrix[4][93] = 0;
   assign ecchmatrix[5][93] = 1;
   assign ecchmatrix[6][93] = 1;
   assign ecchmatrix[7][93] = 0;
   assign ecchmatrix[8][93] = 0;
   assign ecchmatrix[0][94] = 1;
   assign ecchmatrix[1][94] = 1;
   assign ecchmatrix[2][94] = 1;
   assign ecchmatrix[3][94] = 0;
   assign ecchmatrix[4][94] = 0;
   assign ecchmatrix[5][94] = 1;
   assign ecchmatrix[6][94] = 0;
   assign ecchmatrix[7][94] = 1;
   assign ecchmatrix[8][94] = 0;
   assign ecchmatrix[0][95] = 1;
   assign ecchmatrix[1][95] = 1;
   assign ecchmatrix[2][95] = 1;
   assign ecchmatrix[3][95] = 0;
   assign ecchmatrix[4][95] = 0;
   assign ecchmatrix[5][95] = 1;
   assign ecchmatrix[6][95] = 0;
   assign ecchmatrix[7][95] = 0;
   assign ecchmatrix[8][95] = 1;
   assign ecchmatrix[0][96] = 1;
   assign ecchmatrix[1][96] = 1;
   assign ecchmatrix[2][96] = 1;
   assign ecchmatrix[3][96] = 0;
   assign ecchmatrix[4][96] = 0;
   assign ecchmatrix[5][96] = 0;
   assign ecchmatrix[6][96] = 1;
   assign ecchmatrix[7][96] = 1;
   assign ecchmatrix[8][96] = 0;
   assign ecchmatrix[0][97] = 1;
   assign ecchmatrix[1][97] = 1;
   assign ecchmatrix[2][97] = 1;
   assign ecchmatrix[3][97] = 0;
   assign ecchmatrix[4][97] = 0;
   assign ecchmatrix[5][97] = 0;
   assign ecchmatrix[6][97] = 1;
   assign ecchmatrix[7][97] = 0;
   assign ecchmatrix[8][97] = 1;
   assign ecchmatrix[0][98] = 1;
   assign ecchmatrix[1][98] = 1;
   assign ecchmatrix[2][98] = 1;
   assign ecchmatrix[3][98] = 0;
   assign ecchmatrix[4][98] = 0;
   assign ecchmatrix[5][98] = 0;
   assign ecchmatrix[6][98] = 0;
   assign ecchmatrix[7][98] = 1;
   assign ecchmatrix[8][98] = 1;
   assign ecchmatrix[0][99] = 1;
   assign ecchmatrix[1][99] = 1;
   assign ecchmatrix[2][99] = 0;
   assign ecchmatrix[3][99] = 1;
   assign ecchmatrix[4][99] = 1;
   assign ecchmatrix[5][99] = 1;
   assign ecchmatrix[6][99] = 0;
   assign ecchmatrix[7][99] = 0;
   assign ecchmatrix[8][99] = 0;
   assign ecchmatrix[0][100] = 1;
   assign ecchmatrix[1][100] = 1;
   assign ecchmatrix[2][100] = 0;
   assign ecchmatrix[3][100] = 1;
   assign ecchmatrix[4][100] = 1;
   assign ecchmatrix[5][100] = 0;
   assign ecchmatrix[6][100] = 1;
   assign ecchmatrix[7][100] = 0;
   assign ecchmatrix[8][100] = 0;
   assign ecchmatrix[0][101] = 1;
   assign ecchmatrix[1][101] = 1;
   assign ecchmatrix[2][101] = 0;
   assign ecchmatrix[3][101] = 1;
   assign ecchmatrix[4][101] = 1;
   assign ecchmatrix[5][101] = 0;
   assign ecchmatrix[6][101] = 0;
   assign ecchmatrix[7][101] = 1;
   assign ecchmatrix[8][101] = 0;
   assign ecchmatrix[0][102] = 1;
   assign ecchmatrix[1][102] = 1;
   assign ecchmatrix[2][102] = 0;
   assign ecchmatrix[3][102] = 1;
   assign ecchmatrix[4][102] = 1;
   assign ecchmatrix[5][102] = 0;
   assign ecchmatrix[6][102] = 0;
   assign ecchmatrix[7][102] = 0;
   assign ecchmatrix[8][102] = 1;
   assign ecchmatrix[0][103] = 1;
   assign ecchmatrix[1][103] = 1;
   assign ecchmatrix[2][103] = 0;
   assign ecchmatrix[3][103] = 1;
   assign ecchmatrix[4][103] = 0;
   assign ecchmatrix[5][103] = 1;
   assign ecchmatrix[6][103] = 1;
   assign ecchmatrix[7][103] = 0;
   assign ecchmatrix[8][103] = 0;
   assign ecchmatrix[0][104] = 1;
   assign ecchmatrix[1][104] = 1;
   assign ecchmatrix[2][104] = 0;
   assign ecchmatrix[3][104] = 1;
   assign ecchmatrix[4][104] = 0;
   assign ecchmatrix[5][104] = 1;
   assign ecchmatrix[6][104] = 0;
   assign ecchmatrix[7][104] = 1;
   assign ecchmatrix[8][104] = 0;
   assign ecchmatrix[0][105] = 1;
   assign ecchmatrix[1][105] = 1;
   assign ecchmatrix[2][105] = 0;
   assign ecchmatrix[3][105] = 1;
   assign ecchmatrix[4][105] = 0;
   assign ecchmatrix[5][105] = 1;
   assign ecchmatrix[6][105] = 0;
   assign ecchmatrix[7][105] = 0;
   assign ecchmatrix[8][105] = 1;
   assign ecchmatrix[0][106] = 1;
   assign ecchmatrix[1][106] = 1;
   assign ecchmatrix[2][106] = 0;
   assign ecchmatrix[3][106] = 1;
   assign ecchmatrix[4][106] = 0;
   assign ecchmatrix[5][106] = 0;
   assign ecchmatrix[6][106] = 1;
   assign ecchmatrix[7][106] = 1;
   assign ecchmatrix[8][106] = 0;
   assign ecchmatrix[0][107] = 1;
   assign ecchmatrix[1][107] = 1;
   assign ecchmatrix[2][107] = 0;
   assign ecchmatrix[3][107] = 1;
   assign ecchmatrix[4][107] = 0;
   assign ecchmatrix[5][107] = 0;
   assign ecchmatrix[6][107] = 1;
   assign ecchmatrix[7][107] = 0;
   assign ecchmatrix[8][107] = 1;
   assign ecchmatrix[0][108] = 1;
   assign ecchmatrix[1][108] = 1;
   assign ecchmatrix[2][108] = 0;
   assign ecchmatrix[3][108] = 1;
   assign ecchmatrix[4][108] = 0;
   assign ecchmatrix[5][108] = 0;
   assign ecchmatrix[6][108] = 0;
   assign ecchmatrix[7][108] = 1;
   assign ecchmatrix[8][108] = 1;
   assign ecchmatrix[0][109] = 1;
   assign ecchmatrix[1][109] = 1;
   assign ecchmatrix[2][109] = 0;
   assign ecchmatrix[3][109] = 0;
   assign ecchmatrix[4][109] = 1;
   assign ecchmatrix[5][109] = 1;
   assign ecchmatrix[6][109] = 1;
   assign ecchmatrix[7][109] = 0;
   assign ecchmatrix[8][109] = 0;
   assign ecchmatrix[0][110] = 1;
   assign ecchmatrix[1][110] = 1;
   assign ecchmatrix[2][110] = 0;
   assign ecchmatrix[3][110] = 0;
   assign ecchmatrix[4][110] = 1;
   assign ecchmatrix[5][110] = 1;
   assign ecchmatrix[6][110] = 0;
   assign ecchmatrix[7][110] = 1;
   assign ecchmatrix[8][110] = 0;
   assign ecchmatrix[0][111] = 1;
   assign ecchmatrix[1][111] = 1;
   assign ecchmatrix[2][111] = 0;
   assign ecchmatrix[3][111] = 0;
   assign ecchmatrix[4][111] = 1;
   assign ecchmatrix[5][111] = 1;
   assign ecchmatrix[6][111] = 0;
   assign ecchmatrix[7][111] = 0;
   assign ecchmatrix[8][111] = 1;
   assign ecchmatrix[0][112] = 1;
   assign ecchmatrix[1][112] = 1;
   assign ecchmatrix[2][112] = 0;
   assign ecchmatrix[3][112] = 0;
   assign ecchmatrix[4][112] = 1;
   assign ecchmatrix[5][112] = 0;
   assign ecchmatrix[6][112] = 1;
   assign ecchmatrix[7][112] = 1;
   assign ecchmatrix[8][112] = 0;
   assign ecchmatrix[0][113] = 1;
   assign ecchmatrix[1][113] = 1;
   assign ecchmatrix[2][113] = 0;
   assign ecchmatrix[3][113] = 0;
   assign ecchmatrix[4][113] = 1;
   assign ecchmatrix[5][113] = 0;
   assign ecchmatrix[6][113] = 1;
   assign ecchmatrix[7][113] = 0;
   assign ecchmatrix[8][113] = 1;
   assign ecchmatrix[0][114] = 1;
   assign ecchmatrix[1][114] = 1;
   assign ecchmatrix[2][114] = 0;
   assign ecchmatrix[3][114] = 0;
   assign ecchmatrix[4][114] = 1;
   assign ecchmatrix[5][114] = 0;
   assign ecchmatrix[6][114] = 0;
   assign ecchmatrix[7][114] = 1;
   assign ecchmatrix[8][114] = 1;
   assign ecchmatrix[0][115] = 1;
   assign ecchmatrix[1][115] = 1;
   assign ecchmatrix[2][115] = 0;
   assign ecchmatrix[3][115] = 0;
   assign ecchmatrix[4][115] = 0;
   assign ecchmatrix[5][115] = 1;
   assign ecchmatrix[6][115] = 1;
   assign ecchmatrix[7][115] = 1;
   assign ecchmatrix[8][115] = 0;
   assign ecchmatrix[0][116] = 1;
   assign ecchmatrix[1][116] = 1;
   assign ecchmatrix[2][116] = 0;
   assign ecchmatrix[3][116] = 0;
   assign ecchmatrix[4][116] = 0;
   assign ecchmatrix[5][116] = 1;
   assign ecchmatrix[6][116] = 1;
   assign ecchmatrix[7][116] = 0;
   assign ecchmatrix[8][116] = 1;
   assign ecchmatrix[0][117] = 1;
   assign ecchmatrix[1][117] = 1;
   assign ecchmatrix[2][117] = 0;
   assign ecchmatrix[3][117] = 0;
   assign ecchmatrix[4][117] = 0;
   assign ecchmatrix[5][117] = 1;
   assign ecchmatrix[6][117] = 0;
   assign ecchmatrix[7][117] = 1;
   assign ecchmatrix[8][117] = 1;
   assign ecchmatrix[0][118] = 1;
   assign ecchmatrix[1][118] = 1;
   assign ecchmatrix[2][118] = 0;
   assign ecchmatrix[3][118] = 0;
   assign ecchmatrix[4][118] = 0;
   assign ecchmatrix[5][118] = 0;
   assign ecchmatrix[6][118] = 1;
   assign ecchmatrix[7][118] = 1;
   assign ecchmatrix[8][118] = 1;
   assign ecchmatrix[0][119] = 1;
   assign ecchmatrix[1][119] = 0;
   assign ecchmatrix[2][119] = 1;
   assign ecchmatrix[3][119] = 1;
   assign ecchmatrix[4][119] = 1;
   assign ecchmatrix[5][119] = 1;
   assign ecchmatrix[6][119] = 0;
   assign ecchmatrix[7][119] = 0;
   assign ecchmatrix[8][119] = 0;
   assign ecchmatrix[0][120] = 1;
   assign ecchmatrix[1][120] = 0;
   assign ecchmatrix[2][120] = 1;
   assign ecchmatrix[3][120] = 1;
   assign ecchmatrix[4][120] = 1;
   assign ecchmatrix[5][120] = 0;
   assign ecchmatrix[6][120] = 1;
   assign ecchmatrix[7][120] = 0;
   assign ecchmatrix[8][120] = 0;
   assign ecchmatrix[0][121] = 1;
   assign ecchmatrix[1][121] = 0;
   assign ecchmatrix[2][121] = 1;
   assign ecchmatrix[3][121] = 1;
   assign ecchmatrix[4][121] = 1;
   assign ecchmatrix[5][121] = 0;
   assign ecchmatrix[6][121] = 0;
   assign ecchmatrix[7][121] = 1;
   assign ecchmatrix[8][121] = 0;
   assign ecchmatrix[0][122] = 1;
   assign ecchmatrix[1][122] = 0;
   assign ecchmatrix[2][122] = 1;
   assign ecchmatrix[3][122] = 1;
   assign ecchmatrix[4][122] = 1;
   assign ecchmatrix[5][122] = 0;
   assign ecchmatrix[6][122] = 0;
   assign ecchmatrix[7][122] = 0;
   assign ecchmatrix[8][122] = 1;
   assign ecchmatrix[0][123] = 1;
   assign ecchmatrix[1][123] = 0;
   assign ecchmatrix[2][123] = 1;
   assign ecchmatrix[3][123] = 1;
   assign ecchmatrix[4][123] = 0;
   assign ecchmatrix[5][123] = 1;
   assign ecchmatrix[6][123] = 1;
   assign ecchmatrix[7][123] = 0;
   assign ecchmatrix[8][123] = 0;
   assign ecchmatrix[0][124] = 1;
   assign ecchmatrix[1][124] = 0;
   assign ecchmatrix[2][124] = 1;
   assign ecchmatrix[3][124] = 1;
   assign ecchmatrix[4][124] = 0;
   assign ecchmatrix[5][124] = 1;
   assign ecchmatrix[6][124] = 0;
   assign ecchmatrix[7][124] = 1;
   assign ecchmatrix[8][124] = 0;
   assign ecchmatrix[0][125] = 1;
   assign ecchmatrix[1][125] = 0;
   assign ecchmatrix[2][125] = 1;
   assign ecchmatrix[3][125] = 1;
   assign ecchmatrix[4][125] = 0;
   assign ecchmatrix[5][125] = 1;
   assign ecchmatrix[6][125] = 0;
   assign ecchmatrix[7][125] = 0;
   assign ecchmatrix[8][125] = 1;
   assign ecchmatrix[0][126] = 1;
   assign ecchmatrix[1][126] = 0;
   assign ecchmatrix[2][126] = 1;
   assign ecchmatrix[3][126] = 1;
   assign ecchmatrix[4][126] = 0;
   assign ecchmatrix[5][126] = 0;
   assign ecchmatrix[6][126] = 1;
   assign ecchmatrix[7][126] = 1;
   assign ecchmatrix[8][126] = 0;
   assign ecchmatrix[0][127] = 1;
   assign ecchmatrix[1][127] = 0;
   assign ecchmatrix[2][127] = 1;
   assign ecchmatrix[3][127] = 1;
   assign ecchmatrix[4][127] = 0;
   assign ecchmatrix[5][127] = 0;
   assign ecchmatrix[6][127] = 1;
   assign ecchmatrix[7][127] = 0;
   assign ecchmatrix[8][127] = 1;
   assign ecchmatrix[0][128] = 1;
   assign ecchmatrix[1][128] = 0;
   assign ecchmatrix[2][128] = 1;
   assign ecchmatrix[3][128] = 1;
   assign ecchmatrix[4][128] = 0;
   assign ecchmatrix[5][128] = 0;
   assign ecchmatrix[6][128] = 0;
   assign ecchmatrix[7][128] = 1;
   assign ecchmatrix[8][128] = 1;
   assign ecchmatrix[0][129] = 1;
   assign ecchmatrix[1][129] = 0;
   assign ecchmatrix[2][129] = 1;
   assign ecchmatrix[3][129] = 0;
   assign ecchmatrix[4][129] = 1;
   assign ecchmatrix[5][129] = 1;
   assign ecchmatrix[6][129] = 1;
   assign ecchmatrix[7][129] = 0;
   assign ecchmatrix[8][129] = 0;
   assign ecchmatrix[0][130] = 1;
   assign ecchmatrix[1][130] = 0;
   assign ecchmatrix[2][130] = 1;
   assign ecchmatrix[3][130] = 0;
   assign ecchmatrix[4][130] = 1;
   assign ecchmatrix[5][130] = 1;
   assign ecchmatrix[6][130] = 0;
   assign ecchmatrix[7][130] = 1;
   assign ecchmatrix[8][130] = 0;
   assign ecchmatrix[0][131] = 1;
   assign ecchmatrix[1][131] = 0;
   assign ecchmatrix[2][131] = 1;
   assign ecchmatrix[3][131] = 0;
   assign ecchmatrix[4][131] = 1;
   assign ecchmatrix[5][131] = 1;
   assign ecchmatrix[6][131] = 0;
   assign ecchmatrix[7][131] = 0;
   assign ecchmatrix[8][131] = 1;
   assign ecchmatrix[0][132] = 1;
   assign ecchmatrix[1][132] = 0;
   assign ecchmatrix[2][132] = 1;
   assign ecchmatrix[3][132] = 0;
   assign ecchmatrix[4][132] = 1;
   assign ecchmatrix[5][132] = 0;
   assign ecchmatrix[6][132] = 1;
   assign ecchmatrix[7][132] = 1;
   assign ecchmatrix[8][132] = 0;
   assign ecchmatrix[0][133] = 1;
   assign ecchmatrix[1][133] = 0;
   assign ecchmatrix[2][133] = 1;
   assign ecchmatrix[3][133] = 0;
   assign ecchmatrix[4][133] = 1;
   assign ecchmatrix[5][133] = 0;
   assign ecchmatrix[6][133] = 1;
   assign ecchmatrix[7][133] = 0;
   assign ecchmatrix[8][133] = 1;
   assign ecchmatrix[0][134] = 1;
   assign ecchmatrix[1][134] = 0;
   assign ecchmatrix[2][134] = 1;
   assign ecchmatrix[3][134] = 0;
   assign ecchmatrix[4][134] = 1;
   assign ecchmatrix[5][134] = 0;
   assign ecchmatrix[6][134] = 0;
   assign ecchmatrix[7][134] = 1;
   assign ecchmatrix[8][134] = 1;
   assign ecchmatrix[0][135] = 1;
   assign ecchmatrix[1][135] = 0;
   assign ecchmatrix[2][135] = 1;
   assign ecchmatrix[3][135] = 0;
   assign ecchmatrix[4][135] = 0;
   assign ecchmatrix[5][135] = 1;
   assign ecchmatrix[6][135] = 1;
   assign ecchmatrix[7][135] = 1;
   assign ecchmatrix[8][135] = 0;
   assign ecchmatrix[0][136] = 1;
   assign ecchmatrix[1][136] = 0;
   assign ecchmatrix[2][136] = 1;
   assign ecchmatrix[3][136] = 0;
   assign ecchmatrix[4][136] = 0;
   assign ecchmatrix[5][136] = 1;
   assign ecchmatrix[6][136] = 1;
   assign ecchmatrix[7][136] = 0;
   assign ecchmatrix[8][136] = 1;
   assign ecchmatrix[0][137] = 1;
   assign ecchmatrix[1][137] = 0;
   assign ecchmatrix[2][137] = 1;
   assign ecchmatrix[3][137] = 0;
   assign ecchmatrix[4][137] = 0;
   assign ecchmatrix[5][137] = 1;
   assign ecchmatrix[6][137] = 0;
   assign ecchmatrix[7][137] = 1;
   assign ecchmatrix[8][137] = 1;
   assign ecchmatrix[0][138] = 1;
   assign ecchmatrix[1][138] = 0;
   assign ecchmatrix[2][138] = 1;
   assign ecchmatrix[3][138] = 0;
   assign ecchmatrix[4][138] = 0;
   assign ecchmatrix[5][138] = 0;
   assign ecchmatrix[6][138] = 1;
   assign ecchmatrix[7][138] = 1;
   assign ecchmatrix[8][138] = 1;
   assign ecchmatrix[0][139] = 1;
   assign ecchmatrix[1][139] = 0;
   assign ecchmatrix[2][139] = 0;
   assign ecchmatrix[3][139] = 1;
   assign ecchmatrix[4][139] = 1;
   assign ecchmatrix[5][139] = 1;
   assign ecchmatrix[6][139] = 1;
   assign ecchmatrix[7][139] = 0;
   assign ecchmatrix[8][139] = 0;
   assign ecchmatrix[0][140] = 1;
   assign ecchmatrix[1][140] = 0;
   assign ecchmatrix[2][140] = 0;
   assign ecchmatrix[3][140] = 1;
   assign ecchmatrix[4][140] = 1;
   assign ecchmatrix[5][140] = 1;
   assign ecchmatrix[6][140] = 0;
   assign ecchmatrix[7][140] = 1;
   assign ecchmatrix[8][140] = 0;
   assign ecchmatrix[0][141] = 1;
   assign ecchmatrix[1][141] = 0;
   assign ecchmatrix[2][141] = 0;
   assign ecchmatrix[3][141] = 1;
   assign ecchmatrix[4][141] = 1;
   assign ecchmatrix[5][141] = 1;
   assign ecchmatrix[6][141] = 0;
   assign ecchmatrix[7][141] = 0;
   assign ecchmatrix[8][141] = 1;
   assign ecchmatrix[0][142] = 1;
   assign ecchmatrix[1][142] = 0;
   assign ecchmatrix[2][142] = 0;
   assign ecchmatrix[3][142] = 1;
   assign ecchmatrix[4][142] = 1;
   assign ecchmatrix[5][142] = 0;
   assign ecchmatrix[6][142] = 1;
   assign ecchmatrix[7][142] = 1;
   assign ecchmatrix[8][142] = 0;
   assign ecchmatrix[0][143] = 1;
   assign ecchmatrix[1][143] = 0;
   assign ecchmatrix[2][143] = 0;
   assign ecchmatrix[3][143] = 1;
   assign ecchmatrix[4][143] = 1;
   assign ecchmatrix[5][143] = 0;
   assign ecchmatrix[6][143] = 1;
   assign ecchmatrix[7][143] = 0;
   assign ecchmatrix[8][143] = 1;
   assign ecchmatrix[0][144] = 1;
   assign ecchmatrix[1][144] = 0;
   assign ecchmatrix[2][144] = 0;
   assign ecchmatrix[3][144] = 1;
   assign ecchmatrix[4][144] = 1;
   assign ecchmatrix[5][144] = 0;
   assign ecchmatrix[6][144] = 0;
   assign ecchmatrix[7][144] = 1;
   assign ecchmatrix[8][144] = 1;
   assign ecchmatrix[0][145] = 1;
   assign ecchmatrix[1][145] = 0;
   assign ecchmatrix[2][145] = 0;
   assign ecchmatrix[3][145] = 1;
   assign ecchmatrix[4][145] = 0;
   assign ecchmatrix[5][145] = 1;
   assign ecchmatrix[6][145] = 1;
   assign ecchmatrix[7][145] = 1;
   assign ecchmatrix[8][145] = 0;
   assign ecchmatrix[0][146] = 1;
   assign ecchmatrix[1][146] = 0;
   assign ecchmatrix[2][146] = 0;
   assign ecchmatrix[3][146] = 1;
   assign ecchmatrix[4][146] = 0;
   assign ecchmatrix[5][146] = 1;
   assign ecchmatrix[6][146] = 1;
   assign ecchmatrix[7][146] = 0;
   assign ecchmatrix[8][146] = 1;
   assign ecchmatrix[0][147] = 1;
   assign ecchmatrix[1][147] = 0;
   assign ecchmatrix[2][147] = 0;
   assign ecchmatrix[3][147] = 1;
   assign ecchmatrix[4][147] = 0;
   assign ecchmatrix[5][147] = 1;
   assign ecchmatrix[6][147] = 0;
   assign ecchmatrix[7][147] = 1;
   assign ecchmatrix[8][147] = 1;
   assign ecchmatrix[0][148] = 1;
   assign ecchmatrix[1][148] = 0;
   assign ecchmatrix[2][148] = 0;
   assign ecchmatrix[3][148] = 1;
   assign ecchmatrix[4][148] = 0;
   assign ecchmatrix[5][148] = 0;
   assign ecchmatrix[6][148] = 1;
   assign ecchmatrix[7][148] = 1;
   assign ecchmatrix[8][148] = 1;
   assign ecchmatrix[0][149] = 1;
   assign ecchmatrix[1][149] = 0;
   assign ecchmatrix[2][149] = 0;
   assign ecchmatrix[3][149] = 0;
   assign ecchmatrix[4][149] = 1;
   assign ecchmatrix[5][149] = 1;
   assign ecchmatrix[6][149] = 1;
   assign ecchmatrix[7][149] = 1;
   assign ecchmatrix[8][149] = 0;
   assign ecchmatrix[0][150] = 1;
   assign ecchmatrix[1][150] = 0;
   assign ecchmatrix[2][150] = 0;
   assign ecchmatrix[3][150] = 0;
   assign ecchmatrix[4][150] = 1;
   assign ecchmatrix[5][150] = 1;
   assign ecchmatrix[6][150] = 1;
   assign ecchmatrix[7][150] = 0;
   assign ecchmatrix[8][150] = 1;
   assign ecchmatrix[0][151] = 1;
   assign ecchmatrix[1][151] = 0;
   assign ecchmatrix[2][151] = 0;
   assign ecchmatrix[3][151] = 0;
   assign ecchmatrix[4][151] = 1;
   assign ecchmatrix[5][151] = 1;
   assign ecchmatrix[6][151] = 0;
   assign ecchmatrix[7][151] = 1;
   assign ecchmatrix[8][151] = 1;
   assign ecchmatrix[0][152] = 1;
   assign ecchmatrix[1][152] = 0;
   assign ecchmatrix[2][152] = 0;
   assign ecchmatrix[3][152] = 0;
   assign ecchmatrix[4][152] = 1;
   assign ecchmatrix[5][152] = 0;
   assign ecchmatrix[6][152] = 1;
   assign ecchmatrix[7][152] = 1;
   assign ecchmatrix[8][152] = 1;
   assign ecchmatrix[0][153] = 1;
   assign ecchmatrix[1][153] = 0;
   assign ecchmatrix[2][153] = 0;
   assign ecchmatrix[3][153] = 0;
   assign ecchmatrix[4][153] = 0;
   assign ecchmatrix[5][153] = 1;
   assign ecchmatrix[6][153] = 1;
   assign ecchmatrix[7][153] = 1;
   assign ecchmatrix[8][153] = 1;
   assign ecchmatrix[0][154] = 0;
   assign ecchmatrix[1][154] = 1;
   assign ecchmatrix[2][154] = 1;
   assign ecchmatrix[3][154] = 1;
   assign ecchmatrix[4][154] = 1;
   assign ecchmatrix[5][154] = 1;
   assign ecchmatrix[6][154] = 0;
   assign ecchmatrix[7][154] = 0;
   assign ecchmatrix[8][154] = 0;
   assign ecchmatrix[0][155] = 0;
   assign ecchmatrix[1][155] = 1;
   assign ecchmatrix[2][155] = 1;
   assign ecchmatrix[3][155] = 1;
   assign ecchmatrix[4][155] = 1;
   assign ecchmatrix[5][155] = 0;
   assign ecchmatrix[6][155] = 1;
   assign ecchmatrix[7][155] = 0;
   assign ecchmatrix[8][155] = 0;
   assign ecchmatrix[0][156] = 0;
   assign ecchmatrix[1][156] = 1;
   assign ecchmatrix[2][156] = 1;
   assign ecchmatrix[3][156] = 1;
   assign ecchmatrix[4][156] = 1;
   assign ecchmatrix[5][156] = 0;
   assign ecchmatrix[6][156] = 0;
   assign ecchmatrix[7][156] = 1;
   assign ecchmatrix[8][156] = 0;
   assign ecchmatrix[0][157] = 0;
   assign ecchmatrix[1][157] = 1;
   assign ecchmatrix[2][157] = 1;
   assign ecchmatrix[3][157] = 1;
   assign ecchmatrix[4][157] = 1;
   assign ecchmatrix[5][157] = 0;
   assign ecchmatrix[6][157] = 0;
   assign ecchmatrix[7][157] = 0;
   assign ecchmatrix[8][157] = 1;
   assign ecchmatrix[0][158] = 0;
   assign ecchmatrix[1][158] = 1;
   assign ecchmatrix[2][158] = 1;
   assign ecchmatrix[3][158] = 1;
   assign ecchmatrix[4][158] = 0;
   assign ecchmatrix[5][158] = 1;
   assign ecchmatrix[6][158] = 1;
   assign ecchmatrix[7][158] = 0;
   assign ecchmatrix[8][158] = 0;
   assign ecchmatrix[0][159] = 0;
   assign ecchmatrix[1][159] = 1;
   assign ecchmatrix[2][159] = 1;
   assign ecchmatrix[3][159] = 1;
   assign ecchmatrix[4][159] = 0;
   assign ecchmatrix[5][159] = 1;
   assign ecchmatrix[6][159] = 0;
   assign ecchmatrix[7][159] = 1;
   assign ecchmatrix[8][159] = 0;
   assign ecchmatrix[0][160] = 0;
   assign ecchmatrix[1][160] = 1;
   assign ecchmatrix[2][160] = 1;
   assign ecchmatrix[3][160] = 1;
   assign ecchmatrix[4][160] = 0;
   assign ecchmatrix[5][160] = 1;
   assign ecchmatrix[6][160] = 0;
   assign ecchmatrix[7][160] = 0;
   assign ecchmatrix[8][160] = 1;
   assign ecchmatrix[0][161] = 0;
   assign ecchmatrix[1][161] = 1;
   assign ecchmatrix[2][161] = 1;
   assign ecchmatrix[3][161] = 1;
   assign ecchmatrix[4][161] = 0;
   assign ecchmatrix[5][161] = 0;
   assign ecchmatrix[6][161] = 1;
   assign ecchmatrix[7][161] = 1;
   assign ecchmatrix[8][161] = 0;
   assign ecchmatrix[0][162] = 0;
   assign ecchmatrix[1][162] = 1;
   assign ecchmatrix[2][162] = 1;
   assign ecchmatrix[3][162] = 1;
   assign ecchmatrix[4][162] = 0;
   assign ecchmatrix[5][162] = 0;
   assign ecchmatrix[6][162] = 1;
   assign ecchmatrix[7][162] = 0;
   assign ecchmatrix[8][162] = 1;
   assign ecchmatrix[0][163] = 0;
   assign ecchmatrix[1][163] = 1;
   assign ecchmatrix[2][163] = 1;
   assign ecchmatrix[3][163] = 1;
   assign ecchmatrix[4][163] = 0;
   assign ecchmatrix[5][163] = 0;
   assign ecchmatrix[6][163] = 0;
   assign ecchmatrix[7][163] = 1;
   assign ecchmatrix[8][163] = 1;
   assign ecchmatrix[0][164] = 0;
   assign ecchmatrix[1][164] = 1;
   assign ecchmatrix[2][164] = 1;
   assign ecchmatrix[3][164] = 0;
   assign ecchmatrix[4][164] = 1;
   assign ecchmatrix[5][164] = 1;
   assign ecchmatrix[6][164] = 1;
   assign ecchmatrix[7][164] = 0;
   assign ecchmatrix[8][164] = 0;
   assign ecchmatrix[0][165] = 0;
   assign ecchmatrix[1][165] = 1;
   assign ecchmatrix[2][165] = 1;
   assign ecchmatrix[3][165] = 0;
   assign ecchmatrix[4][165] = 1;
   assign ecchmatrix[5][165] = 1;
   assign ecchmatrix[6][165] = 0;
   assign ecchmatrix[7][165] = 1;
   assign ecchmatrix[8][165] = 0;
   assign ecchmatrix[0][166] = 0;
   assign ecchmatrix[1][166] = 1;
   assign ecchmatrix[2][166] = 1;
   assign ecchmatrix[3][166] = 0;
   assign ecchmatrix[4][166] = 1;
   assign ecchmatrix[5][166] = 1;
   assign ecchmatrix[6][166] = 0;
   assign ecchmatrix[7][166] = 0;
   assign ecchmatrix[8][166] = 1;
   assign ecchmatrix[0][167] = 0;
   assign ecchmatrix[1][167] = 1;
   assign ecchmatrix[2][167] = 1;
   assign ecchmatrix[3][167] = 0;
   assign ecchmatrix[4][167] = 1;
   assign ecchmatrix[5][167] = 0;
   assign ecchmatrix[6][167] = 1;
   assign ecchmatrix[7][167] = 1;
   assign ecchmatrix[8][167] = 0;
   assign ecchmatrix[0][168] = 0;
   assign ecchmatrix[1][168] = 1;
   assign ecchmatrix[2][168] = 1;
   assign ecchmatrix[3][168] = 0;
   assign ecchmatrix[4][168] = 1;
   assign ecchmatrix[5][168] = 0;
   assign ecchmatrix[6][168] = 1;
   assign ecchmatrix[7][168] = 0;
   assign ecchmatrix[8][168] = 1;
   assign ecchmatrix[0][169] = 0;
   assign ecchmatrix[1][169] = 1;
   assign ecchmatrix[2][169] = 1;
   assign ecchmatrix[3][169] = 0;
   assign ecchmatrix[4][169] = 1;
   assign ecchmatrix[5][169] = 0;
   assign ecchmatrix[6][169] = 0;
   assign ecchmatrix[7][169] = 1;
   assign ecchmatrix[8][169] = 1;
   assign ecchmatrix[0][170] = 0;
   assign ecchmatrix[1][170] = 1;
   assign ecchmatrix[2][170] = 1;
   assign ecchmatrix[3][170] = 0;
   assign ecchmatrix[4][170] = 0;
   assign ecchmatrix[5][170] = 1;
   assign ecchmatrix[6][170] = 1;
   assign ecchmatrix[7][170] = 1;
   assign ecchmatrix[8][170] = 0;
   assign ecchmatrix[0][171] = 0;
   assign ecchmatrix[1][171] = 1;
   assign ecchmatrix[2][171] = 1;
   assign ecchmatrix[3][171] = 0;
   assign ecchmatrix[4][171] = 0;
   assign ecchmatrix[5][171] = 1;
   assign ecchmatrix[6][171] = 1;
   assign ecchmatrix[7][171] = 0;
   assign ecchmatrix[8][171] = 1;
   assign ecchmatrix[0][172] = 0;
   assign ecchmatrix[1][172] = 1;
   assign ecchmatrix[2][172] = 1;
   assign ecchmatrix[3][172] = 0;
   assign ecchmatrix[4][172] = 0;
   assign ecchmatrix[5][172] = 1;
   assign ecchmatrix[6][172] = 0;
   assign ecchmatrix[7][172] = 1;
   assign ecchmatrix[8][172] = 1;
   assign ecchmatrix[0][173] = 0;
   assign ecchmatrix[1][173] = 1;
   assign ecchmatrix[2][173] = 1;
   assign ecchmatrix[3][173] = 0;
   assign ecchmatrix[4][173] = 0;
   assign ecchmatrix[5][173] = 0;
   assign ecchmatrix[6][173] = 1;
   assign ecchmatrix[7][173] = 1;
   assign ecchmatrix[8][173] = 1;
   assign ecchmatrix[0][174] = 0;
   assign ecchmatrix[1][174] = 1;
   assign ecchmatrix[2][174] = 0;
   assign ecchmatrix[3][174] = 1;
   assign ecchmatrix[4][174] = 1;
   assign ecchmatrix[5][174] = 1;
   assign ecchmatrix[6][174] = 1;
   assign ecchmatrix[7][174] = 0;
   assign ecchmatrix[8][174] = 0;
   assign ecchmatrix[0][175] = 0;
   assign ecchmatrix[1][175] = 1;
   assign ecchmatrix[2][175] = 0;
   assign ecchmatrix[3][175] = 1;
   assign ecchmatrix[4][175] = 1;
   assign ecchmatrix[5][175] = 1;
   assign ecchmatrix[6][175] = 0;
   assign ecchmatrix[7][175] = 1;
   assign ecchmatrix[8][175] = 0;
   assign ecchmatrix[0][176] = 0;
   assign ecchmatrix[1][176] = 1;
   assign ecchmatrix[2][176] = 0;
   assign ecchmatrix[3][176] = 1;
   assign ecchmatrix[4][176] = 1;
   assign ecchmatrix[5][176] = 1;
   assign ecchmatrix[6][176] = 0;
   assign ecchmatrix[7][176] = 0;
   assign ecchmatrix[8][176] = 1;
   assign ecchmatrix[0][177] = 0;
   assign ecchmatrix[1][177] = 1;
   assign ecchmatrix[2][177] = 0;
   assign ecchmatrix[3][177] = 1;
   assign ecchmatrix[4][177] = 1;
   assign ecchmatrix[5][177] = 0;
   assign ecchmatrix[6][177] = 1;
   assign ecchmatrix[7][177] = 1;
   assign ecchmatrix[8][177] = 0;
   assign ecchmatrix[0][178] = 0;
   assign ecchmatrix[1][178] = 1;
   assign ecchmatrix[2][178] = 0;
   assign ecchmatrix[3][178] = 1;
   assign ecchmatrix[4][178] = 1;
   assign ecchmatrix[5][178] = 0;
   assign ecchmatrix[6][178] = 1;
   assign ecchmatrix[7][178] = 0;
   assign ecchmatrix[8][178] = 1;
   assign ecchmatrix[0][179] = 0;
   assign ecchmatrix[1][179] = 1;
   assign ecchmatrix[2][179] = 0;
   assign ecchmatrix[3][179] = 1;
   assign ecchmatrix[4][179] = 1;
   assign ecchmatrix[5][179] = 0;
   assign ecchmatrix[6][179] = 0;
   assign ecchmatrix[7][179] = 1;
   assign ecchmatrix[8][179] = 1;
   assign ecchmatrix[0][180] = 0;
   assign ecchmatrix[1][180] = 1;
   assign ecchmatrix[2][180] = 0;
   assign ecchmatrix[3][180] = 1;
   assign ecchmatrix[4][180] = 0;
   assign ecchmatrix[5][180] = 1;
   assign ecchmatrix[6][180] = 1;
   assign ecchmatrix[7][180] = 1;
   assign ecchmatrix[8][180] = 0;
   assign ecchmatrix[0][181] = 0;
   assign ecchmatrix[1][181] = 1;
   assign ecchmatrix[2][181] = 0;
   assign ecchmatrix[3][181] = 1;
   assign ecchmatrix[4][181] = 0;
   assign ecchmatrix[5][181] = 1;
   assign ecchmatrix[6][181] = 1;
   assign ecchmatrix[7][181] = 0;
   assign ecchmatrix[8][181] = 1;
   assign ecchmatrix[0][182] = 0;
   assign ecchmatrix[1][182] = 1;
   assign ecchmatrix[2][182] = 0;
   assign ecchmatrix[3][182] = 1;
   assign ecchmatrix[4][182] = 0;
   assign ecchmatrix[5][182] = 1;
   assign ecchmatrix[6][182] = 0;
   assign ecchmatrix[7][182] = 1;
   assign ecchmatrix[8][182] = 1;
   assign ecchmatrix[0][183] = 0;
   assign ecchmatrix[1][183] = 1;
   assign ecchmatrix[2][183] = 0;
   assign ecchmatrix[3][183] = 1;
   assign ecchmatrix[4][183] = 0;
   assign ecchmatrix[5][183] = 0;
   assign ecchmatrix[6][183] = 1;
   assign ecchmatrix[7][183] = 1;
   assign ecchmatrix[8][183] = 1;
   assign ecchmatrix[0][184] = 0;
   assign ecchmatrix[1][184] = 1;
   assign ecchmatrix[2][184] = 0;
   assign ecchmatrix[3][184] = 0;
   assign ecchmatrix[4][184] = 1;
   assign ecchmatrix[5][184] = 1;
   assign ecchmatrix[6][184] = 1;
   assign ecchmatrix[7][184] = 1;
   assign ecchmatrix[8][184] = 0;
   assign ecchmatrix[0][185] = 0;
   assign ecchmatrix[1][185] = 1;
   assign ecchmatrix[2][185] = 0;
   assign ecchmatrix[3][185] = 0;
   assign ecchmatrix[4][185] = 1;
   assign ecchmatrix[5][185] = 1;
   assign ecchmatrix[6][185] = 1;
   assign ecchmatrix[7][185] = 0;
   assign ecchmatrix[8][185] = 1;
   assign ecchmatrix[0][186] = 0;
   assign ecchmatrix[1][186] = 1;
   assign ecchmatrix[2][186] = 0;
   assign ecchmatrix[3][186] = 0;
   assign ecchmatrix[4][186] = 1;
   assign ecchmatrix[5][186] = 1;
   assign ecchmatrix[6][186] = 0;
   assign ecchmatrix[7][186] = 1;
   assign ecchmatrix[8][186] = 1;
   assign ecchmatrix[0][187] = 0;
   assign ecchmatrix[1][187] = 1;
   assign ecchmatrix[2][187] = 0;
   assign ecchmatrix[3][187] = 0;
   assign ecchmatrix[4][187] = 1;
   assign ecchmatrix[5][187] = 0;
   assign ecchmatrix[6][187] = 1;
   assign ecchmatrix[7][187] = 1;
   assign ecchmatrix[8][187] = 1;
   assign ecchmatrix[0][188] = 0;
   assign ecchmatrix[1][188] = 1;
   assign ecchmatrix[2][188] = 0;
   assign ecchmatrix[3][188] = 0;
   assign ecchmatrix[4][188] = 0;
   assign ecchmatrix[5][188] = 1;
   assign ecchmatrix[6][188] = 1;
   assign ecchmatrix[7][188] = 1;
   assign ecchmatrix[8][188] = 1;
   assign ecchmatrix[0][189] = 0;
   assign ecchmatrix[1][189] = 0;
   assign ecchmatrix[2][189] = 1;
   assign ecchmatrix[3][189] = 1;
   assign ecchmatrix[4][189] = 1;
   assign ecchmatrix[5][189] = 1;
   assign ecchmatrix[6][189] = 1;
   assign ecchmatrix[7][189] = 0;
   assign ecchmatrix[8][189] = 0;
   assign ecchmatrix[0][190] = 0;
   assign ecchmatrix[1][190] = 0;
   assign ecchmatrix[2][190] = 1;
   assign ecchmatrix[3][190] = 1;
   assign ecchmatrix[4][190] = 1;
   assign ecchmatrix[5][190] = 1;
   assign ecchmatrix[6][190] = 0;
   assign ecchmatrix[7][190] = 1;
   assign ecchmatrix[8][190] = 0;
   assign ecchmatrix[0][191] = 0;
   assign ecchmatrix[1][191] = 0;
   assign ecchmatrix[2][191] = 1;
   assign ecchmatrix[3][191] = 1;
   assign ecchmatrix[4][191] = 1;
   assign ecchmatrix[5][191] = 1;
   assign ecchmatrix[6][191] = 0;
   assign ecchmatrix[7][191] = 0;
   assign ecchmatrix[8][191] = 1;
   assign ecchmatrix[0][192] = 0;
   assign ecchmatrix[1][192] = 0;
   assign ecchmatrix[2][192] = 1;
   assign ecchmatrix[3][192] = 1;
   assign ecchmatrix[4][192] = 1;
   assign ecchmatrix[5][192] = 0;
   assign ecchmatrix[6][192] = 1;
   assign ecchmatrix[7][192] = 1;
   assign ecchmatrix[8][192] = 0;
   assign ecchmatrix[0][193] = 0;
   assign ecchmatrix[1][193] = 0;
   assign ecchmatrix[2][193] = 1;
   assign ecchmatrix[3][193] = 1;
   assign ecchmatrix[4][193] = 1;
   assign ecchmatrix[5][193] = 0;
   assign ecchmatrix[6][193] = 1;
   assign ecchmatrix[7][193] = 0;
   assign ecchmatrix[8][193] = 1;
   assign ecchmatrix[0][194] = 0;
   assign ecchmatrix[1][194] = 0;
   assign ecchmatrix[2][194] = 1;
   assign ecchmatrix[3][194] = 1;
   assign ecchmatrix[4][194] = 1;
   assign ecchmatrix[5][194] = 0;
   assign ecchmatrix[6][194] = 0;
   assign ecchmatrix[7][194] = 1;
   assign ecchmatrix[8][194] = 1;
   assign ecchmatrix[0][195] = 0;
   assign ecchmatrix[1][195] = 0;
   assign ecchmatrix[2][195] = 1;
   assign ecchmatrix[3][195] = 1;
   assign ecchmatrix[4][195] = 0;
   assign ecchmatrix[5][195] = 1;
   assign ecchmatrix[6][195] = 1;
   assign ecchmatrix[7][195] = 1;
   assign ecchmatrix[8][195] = 0;
   assign ecchmatrix[0][196] = 0;
   assign ecchmatrix[1][196] = 0;
   assign ecchmatrix[2][196] = 1;
   assign ecchmatrix[3][196] = 1;
   assign ecchmatrix[4][196] = 0;
   assign ecchmatrix[5][196] = 1;
   assign ecchmatrix[6][196] = 1;
   assign ecchmatrix[7][196] = 0;
   assign ecchmatrix[8][196] = 1;
   assign ecchmatrix[0][197] = 0;
   assign ecchmatrix[1][197] = 0;
   assign ecchmatrix[2][197] = 1;
   assign ecchmatrix[3][197] = 1;
   assign ecchmatrix[4][197] = 0;
   assign ecchmatrix[5][197] = 1;
   assign ecchmatrix[6][197] = 0;
   assign ecchmatrix[7][197] = 1;
   assign ecchmatrix[8][197] = 1;
   assign ecchmatrix[0][198] = 0;
   assign ecchmatrix[1][198] = 0;
   assign ecchmatrix[2][198] = 1;
   assign ecchmatrix[3][198] = 1;
   assign ecchmatrix[4][198] = 0;
   assign ecchmatrix[5][198] = 0;
   assign ecchmatrix[6][198] = 1;
   assign ecchmatrix[7][198] = 1;
   assign ecchmatrix[8][198] = 1;
   assign ecchmatrix[0][199] = 0;
   assign ecchmatrix[1][199] = 0;
   assign ecchmatrix[2][199] = 1;
   assign ecchmatrix[3][199] = 0;
   assign ecchmatrix[4][199] = 1;
   assign ecchmatrix[5][199] = 1;
   assign ecchmatrix[6][199] = 1;
   assign ecchmatrix[7][199] = 1;
   assign ecchmatrix[8][199] = 0;
   assign ecchmatrix[0][200] = 0;
   assign ecchmatrix[1][200] = 0;
   assign ecchmatrix[2][200] = 1;
   assign ecchmatrix[3][200] = 0;
   assign ecchmatrix[4][200] = 1;
   assign ecchmatrix[5][200] = 1;
   assign ecchmatrix[6][200] = 1;
   assign ecchmatrix[7][200] = 0;
   assign ecchmatrix[8][200] = 1;
   assign ecchmatrix[0][201] = 0;
   assign ecchmatrix[1][201] = 0;
   assign ecchmatrix[2][201] = 1;
   assign ecchmatrix[3][201] = 0;
   assign ecchmatrix[4][201] = 1;
   assign ecchmatrix[5][201] = 1;
   assign ecchmatrix[6][201] = 0;
   assign ecchmatrix[7][201] = 1;
   assign ecchmatrix[8][201] = 1;
   assign ecchmatrix[0][202] = 0;
   assign ecchmatrix[1][202] = 0;
   assign ecchmatrix[2][202] = 1;
   assign ecchmatrix[3][202] = 0;
   assign ecchmatrix[4][202] = 1;
   assign ecchmatrix[5][202] = 0;
   assign ecchmatrix[6][202] = 1;
   assign ecchmatrix[7][202] = 1;
   assign ecchmatrix[8][202] = 1;
   assign ecchmatrix[0][203] = 0;
   assign ecchmatrix[1][203] = 0;
   assign ecchmatrix[2][203] = 1;
   assign ecchmatrix[3][203] = 0;
   assign ecchmatrix[4][203] = 0;
   assign ecchmatrix[5][203] = 1;
   assign ecchmatrix[6][203] = 1;
   assign ecchmatrix[7][203] = 1;
   assign ecchmatrix[8][203] = 1;
   assign ecchmatrix[0][204] = 0;
   assign ecchmatrix[1][204] = 0;
   assign ecchmatrix[2][204] = 0;
   assign ecchmatrix[3][204] = 1;
   assign ecchmatrix[4][204] = 1;
   assign ecchmatrix[5][204] = 1;
   assign ecchmatrix[6][204] = 1;
   assign ecchmatrix[7][204] = 1;
   assign ecchmatrix[8][204] = 0;
   assign ecchmatrix[0][205] = 0;
   assign ecchmatrix[1][205] = 0;
   assign ecchmatrix[2][205] = 0;
   assign ecchmatrix[3][205] = 1;
   assign ecchmatrix[4][205] = 1;
   assign ecchmatrix[5][205] = 1;
   assign ecchmatrix[6][205] = 1;
   assign ecchmatrix[7][205] = 0;
   assign ecchmatrix[8][205] = 1;
   assign ecchmatrix[0][206] = 0;
   assign ecchmatrix[1][206] = 0;
   assign ecchmatrix[2][206] = 0;
   assign ecchmatrix[3][206] = 1;
   assign ecchmatrix[4][206] = 1;
   assign ecchmatrix[5][206] = 1;
   assign ecchmatrix[6][206] = 0;
   assign ecchmatrix[7][206] = 1;
   assign ecchmatrix[8][206] = 1;
   assign ecchmatrix[0][207] = 0;
   assign ecchmatrix[1][207] = 0;
   assign ecchmatrix[2][207] = 0;
   assign ecchmatrix[3][207] = 1;
   assign ecchmatrix[4][207] = 1;
   assign ecchmatrix[5][207] = 0;
   assign ecchmatrix[6][207] = 1;
   assign ecchmatrix[7][207] = 1;
   assign ecchmatrix[8][207] = 1;
   assign ecchmatrix[0][208] = 0;
   assign ecchmatrix[1][208] = 0;
   assign ecchmatrix[2][208] = 0;
   assign ecchmatrix[3][208] = 1;
   assign ecchmatrix[4][208] = 0;
   assign ecchmatrix[5][208] = 1;
   assign ecchmatrix[6][208] = 1;
   assign ecchmatrix[7][208] = 1;
   assign ecchmatrix[8][208] = 1;
   assign ecchmatrix[0][209] = 0;
   assign ecchmatrix[1][209] = 0;
   assign ecchmatrix[2][209] = 0;
   assign ecchmatrix[3][209] = 0;
   assign ecchmatrix[4][209] = 1;
   assign ecchmatrix[5][209] = 1;
   assign ecchmatrix[6][209] = 1;
   assign ecchmatrix[7][209] = 1;
   assign ecchmatrix[8][209] = 1;
   assign ecchmatrix[0][210] = 1;
   assign ecchmatrix[1][210] = 1;
   assign ecchmatrix[2][210] = 1;
   assign ecchmatrix[3][210] = 1;
   assign ecchmatrix[4][210] = 1;
   assign ecchmatrix[5][210] = 1;
   assign ecchmatrix[6][210] = 1;
   assign ecchmatrix[7][210] = 0;
   assign ecchmatrix[8][210] = 0;
   assign ecchmatrix[0][211] = 1;
   assign ecchmatrix[1][211] = 1;
   assign ecchmatrix[2][211] = 1;
   assign ecchmatrix[3][211] = 1;
   assign ecchmatrix[4][211] = 1;
   assign ecchmatrix[5][211] = 1;
   assign ecchmatrix[6][211] = 0;
   assign ecchmatrix[7][211] = 1;
   assign ecchmatrix[8][211] = 0;
   assign ecchmatrix[0][212] = 1;
   assign ecchmatrix[1][212] = 1;
   assign ecchmatrix[2][212] = 1;
   assign ecchmatrix[3][212] = 1;
   assign ecchmatrix[4][212] = 1;
   assign ecchmatrix[5][212] = 1;
   assign ecchmatrix[6][212] = 0;
   assign ecchmatrix[7][212] = 0;
   assign ecchmatrix[8][212] = 1;
   assign ecchmatrix[0][213] = 1;
   assign ecchmatrix[1][213] = 1;
   assign ecchmatrix[2][213] = 1;
   assign ecchmatrix[3][213] = 1;
   assign ecchmatrix[4][213] = 1;
   assign ecchmatrix[5][213] = 0;
   assign ecchmatrix[6][213] = 1;
   assign ecchmatrix[7][213] = 1;
   assign ecchmatrix[8][213] = 0;
   assign ecchmatrix[0][214] = 1;
   assign ecchmatrix[1][214] = 1;
   assign ecchmatrix[2][214] = 1;
   assign ecchmatrix[3][214] = 1;
   assign ecchmatrix[4][214] = 1;
   assign ecchmatrix[5][214] = 0;
   assign ecchmatrix[6][214] = 1;
   assign ecchmatrix[7][214] = 0;
   assign ecchmatrix[8][214] = 1;
   assign ecchmatrix[0][215] = 1;
   assign ecchmatrix[1][215] = 1;
   assign ecchmatrix[2][215] = 1;
   assign ecchmatrix[3][215] = 1;
   assign ecchmatrix[4][215] = 1;
   assign ecchmatrix[5][215] = 0;
   assign ecchmatrix[6][215] = 0;
   assign ecchmatrix[7][215] = 1;
   assign ecchmatrix[8][215] = 1;
   assign ecchmatrix[0][216] = 1;
   assign ecchmatrix[1][216] = 1;
   assign ecchmatrix[2][216] = 1;
   assign ecchmatrix[3][216] = 1;
   assign ecchmatrix[4][216] = 0;
   assign ecchmatrix[5][216] = 1;
   assign ecchmatrix[6][216] = 1;
   assign ecchmatrix[7][216] = 1;
   assign ecchmatrix[8][216] = 0;
   assign ecchmatrix[0][217] = 1;
   assign ecchmatrix[1][217] = 1;
   assign ecchmatrix[2][217] = 1;
   assign ecchmatrix[3][217] = 1;
   assign ecchmatrix[4][217] = 0;
   assign ecchmatrix[5][217] = 1;
   assign ecchmatrix[6][217] = 1;
   assign ecchmatrix[7][217] = 0;
   assign ecchmatrix[8][217] = 1;
   assign ecchmatrix[0][218] = 1;
   assign ecchmatrix[1][218] = 1;
   assign ecchmatrix[2][218] = 1;
   assign ecchmatrix[3][218] = 1;
   assign ecchmatrix[4][218] = 0;
   assign ecchmatrix[5][218] = 1;
   assign ecchmatrix[6][218] = 0;
   assign ecchmatrix[7][218] = 1;
   assign ecchmatrix[8][218] = 1;
   assign ecchmatrix[0][219] = 1;
   assign ecchmatrix[1][219] = 1;
   assign ecchmatrix[2][219] = 1;
   assign ecchmatrix[3][219] = 1;
   assign ecchmatrix[4][219] = 0;
   assign ecchmatrix[5][219] = 0;
   assign ecchmatrix[6][219] = 1;
   assign ecchmatrix[7][219] = 1;
   assign ecchmatrix[8][219] = 1;
   assign ecchmatrix[0][220] = 1;
   assign ecchmatrix[1][220] = 1;
   assign ecchmatrix[2][220] = 1;
   assign ecchmatrix[3][220] = 0;
   assign ecchmatrix[4][220] = 1;
   assign ecchmatrix[5][220] = 1;
   assign ecchmatrix[6][220] = 1;
   assign ecchmatrix[7][220] = 1;
   assign ecchmatrix[8][220] = 0;
   assign ecchmatrix[0][221] = 1;
   assign ecchmatrix[1][221] = 1;
   assign ecchmatrix[2][221] = 1;
   assign ecchmatrix[3][221] = 0;
   assign ecchmatrix[4][221] = 1;
   assign ecchmatrix[5][221] = 1;
   assign ecchmatrix[6][221] = 1;
   assign ecchmatrix[7][221] = 0;
   assign ecchmatrix[8][221] = 1;
   assign ecchmatrix[0][222] = 1;
   assign ecchmatrix[1][222] = 1;
   assign ecchmatrix[2][222] = 1;
   assign ecchmatrix[3][222] = 0;
   assign ecchmatrix[4][222] = 1;
   assign ecchmatrix[5][222] = 1;
   assign ecchmatrix[6][222] = 0;
   assign ecchmatrix[7][222] = 1;
   assign ecchmatrix[8][222] = 1;
   assign ecchmatrix[0][223] = 1;
   assign ecchmatrix[1][223] = 1;
   assign ecchmatrix[2][223] = 1;
   assign ecchmatrix[3][223] = 0;
   assign ecchmatrix[4][223] = 1;
   assign ecchmatrix[5][223] = 0;
   assign ecchmatrix[6][223] = 1;
   assign ecchmatrix[7][223] = 1;
   assign ecchmatrix[8][223] = 1;
   assign ecchmatrix[0][224] = 1;
   assign ecchmatrix[1][224] = 1;
   assign ecchmatrix[2][224] = 1;
   assign ecchmatrix[3][224] = 0;
   assign ecchmatrix[4][224] = 0;
   assign ecchmatrix[5][224] = 1;
   assign ecchmatrix[6][224] = 1;
   assign ecchmatrix[7][224] = 1;
   assign ecchmatrix[8][224] = 1;
   assign ecchmatrix[0][225] = 1;
   assign ecchmatrix[1][225] = 1;
   assign ecchmatrix[2][225] = 0;
   assign ecchmatrix[3][225] = 1;
   assign ecchmatrix[4][225] = 1;
   assign ecchmatrix[5][225] = 1;
   assign ecchmatrix[6][225] = 1;
   assign ecchmatrix[7][225] = 1;
   assign ecchmatrix[8][225] = 0;
   assign ecchmatrix[0][226] = 1;
   assign ecchmatrix[1][226] = 1;
   assign ecchmatrix[2][226] = 0;
   assign ecchmatrix[3][226] = 1;
   assign ecchmatrix[4][226] = 1;
   assign ecchmatrix[5][226] = 1;
   assign ecchmatrix[6][226] = 1;
   assign ecchmatrix[7][226] = 0;
   assign ecchmatrix[8][226] = 1;
   assign ecchmatrix[0][227] = 1;
   assign ecchmatrix[1][227] = 1;
   assign ecchmatrix[2][227] = 0;
   assign ecchmatrix[3][227] = 1;
   assign ecchmatrix[4][227] = 1;
   assign ecchmatrix[5][227] = 1;
   assign ecchmatrix[6][227] = 0;
   assign ecchmatrix[7][227] = 1;
   assign ecchmatrix[8][227] = 1;
   assign ecchmatrix[0][228] = 1;
   assign ecchmatrix[1][228] = 1;
   assign ecchmatrix[2][228] = 0;
   assign ecchmatrix[3][228] = 1;
   assign ecchmatrix[4][228] = 1;
   assign ecchmatrix[5][228] = 0;
   assign ecchmatrix[6][228] = 1;
   assign ecchmatrix[7][228] = 1;
   assign ecchmatrix[8][228] = 1;
   assign ecchmatrix[0][229] = 1;
   assign ecchmatrix[1][229] = 1;
   assign ecchmatrix[2][229] = 0;
   assign ecchmatrix[3][229] = 1;
   assign ecchmatrix[4][229] = 0;
   assign ecchmatrix[5][229] = 1;
   assign ecchmatrix[6][229] = 1;
   assign ecchmatrix[7][229] = 1;
   assign ecchmatrix[8][229] = 1;
   assign ecchmatrix[0][230] = 1;
   assign ecchmatrix[1][230] = 1;
   assign ecchmatrix[2][230] = 0;
   assign ecchmatrix[3][230] = 0;
   assign ecchmatrix[4][230] = 1;
   assign ecchmatrix[5][230] = 1;
   assign ecchmatrix[6][230] = 1;
   assign ecchmatrix[7][230] = 1;
   assign ecchmatrix[8][230] = 1;
   assign ecchmatrix[0][231] = 1;
   assign ecchmatrix[1][231] = 0;
   assign ecchmatrix[2][231] = 1;
   assign ecchmatrix[3][231] = 1;
   assign ecchmatrix[4][231] = 1;
   assign ecchmatrix[5][231] = 1;
   assign ecchmatrix[6][231] = 1;
   assign ecchmatrix[7][231] = 1;
   assign ecchmatrix[8][231] = 0;
   assign ecchmatrix[0][232] = 1;
   assign ecchmatrix[1][232] = 0;
   assign ecchmatrix[2][232] = 1;
   assign ecchmatrix[3][232] = 1;
   assign ecchmatrix[4][232] = 1;
   assign ecchmatrix[5][232] = 1;
   assign ecchmatrix[6][232] = 1;
   assign ecchmatrix[7][232] = 0;
   assign ecchmatrix[8][232] = 1;
   assign ecchmatrix[0][233] = 1;
   assign ecchmatrix[1][233] = 0;
   assign ecchmatrix[2][233] = 1;
   assign ecchmatrix[3][233] = 1;
   assign ecchmatrix[4][233] = 1;
   assign ecchmatrix[5][233] = 1;
   assign ecchmatrix[6][233] = 0;
   assign ecchmatrix[7][233] = 1;
   assign ecchmatrix[8][233] = 1;
   assign ecchmatrix[0][234] = 1;
   assign ecchmatrix[1][234] = 0;
   assign ecchmatrix[2][234] = 1;
   assign ecchmatrix[3][234] = 1;
   assign ecchmatrix[4][234] = 1;
   assign ecchmatrix[5][234] = 0;
   assign ecchmatrix[6][234] = 1;
   assign ecchmatrix[7][234] = 1;
   assign ecchmatrix[8][234] = 1;
   assign ecchmatrix[0][235] = 1;
   assign ecchmatrix[1][235] = 0;
   assign ecchmatrix[2][235] = 1;
   assign ecchmatrix[3][235] = 1;
   assign ecchmatrix[4][235] = 0;
   assign ecchmatrix[5][235] = 1;
   assign ecchmatrix[6][235] = 1;
   assign ecchmatrix[7][235] = 1;
   assign ecchmatrix[8][235] = 1;
   assign ecchmatrix[0][236] = 1;
   assign ecchmatrix[1][236] = 0;
   assign ecchmatrix[2][236] = 1;
   assign ecchmatrix[3][236] = 0;
   assign ecchmatrix[4][236] = 1;
   assign ecchmatrix[5][236] = 1;
   assign ecchmatrix[6][236] = 1;
   assign ecchmatrix[7][236] = 1;
   assign ecchmatrix[8][236] = 1;
   assign ecchmatrix[0][237] = 1;
   assign ecchmatrix[1][237] = 0;
   assign ecchmatrix[2][237] = 0;
   assign ecchmatrix[3][237] = 1;
   assign ecchmatrix[4][237] = 1;
   assign ecchmatrix[5][237] = 1;
   assign ecchmatrix[6][237] = 1;
   assign ecchmatrix[7][237] = 1;
   assign ecchmatrix[8][237] = 1;
   assign ecchmatrix[0][238] = 0;
   assign ecchmatrix[1][238] = 1;
   assign ecchmatrix[2][238] = 1;
   assign ecchmatrix[3][238] = 1;
   assign ecchmatrix[4][238] = 1;
   assign ecchmatrix[5][238] = 1;
   assign ecchmatrix[6][238] = 1;
   assign ecchmatrix[7][238] = 1;
   assign ecchmatrix[8][238] = 0;
   assign ecchmatrix[0][239] = 0;
   assign ecchmatrix[1][239] = 1;
   assign ecchmatrix[2][239] = 1;
   assign ecchmatrix[3][239] = 1;
   assign ecchmatrix[4][239] = 1;
   assign ecchmatrix[5][239] = 1;
   assign ecchmatrix[6][239] = 1;
   assign ecchmatrix[7][239] = 0;
   assign ecchmatrix[8][239] = 1;
   assign ecchmatrix[0][240] = 0;
   assign ecchmatrix[1][240] = 1;
   assign ecchmatrix[2][240] = 1;
   assign ecchmatrix[3][240] = 1;
   assign ecchmatrix[4][240] = 1;
   assign ecchmatrix[5][240] = 1;
   assign ecchmatrix[6][240] = 0;
   assign ecchmatrix[7][240] = 1;
   assign ecchmatrix[8][240] = 1;
   assign ecchmatrix[0][241] = 0;
   assign ecchmatrix[1][241] = 1;
   assign ecchmatrix[2][241] = 1;
   assign ecchmatrix[3][241] = 1;
   assign ecchmatrix[4][241] = 1;
   assign ecchmatrix[5][241] = 0;
   assign ecchmatrix[6][241] = 1;
   assign ecchmatrix[7][241] = 1;
   assign ecchmatrix[8][241] = 1;
   assign ecchmatrix[0][242] = 0;
   assign ecchmatrix[1][242] = 1;
   assign ecchmatrix[2][242] = 1;
   assign ecchmatrix[3][242] = 1;
   assign ecchmatrix[4][242] = 0;
   assign ecchmatrix[5][242] = 1;
   assign ecchmatrix[6][242] = 1;
   assign ecchmatrix[7][242] = 1;
   assign ecchmatrix[8][242] = 1;
   assign ecchmatrix[0][243] = 0;
   assign ecchmatrix[1][243] = 1;
   assign ecchmatrix[2][243] = 1;
   assign ecchmatrix[3][243] = 0;
   assign ecchmatrix[4][243] = 1;
   assign ecchmatrix[5][243] = 1;
   assign ecchmatrix[6][243] = 1;
   assign ecchmatrix[7][243] = 1;
   assign ecchmatrix[8][243] = 1;
   assign ecchmatrix[0][244] = 0;
   assign ecchmatrix[1][244] = 1;
   assign ecchmatrix[2][244] = 0;
   assign ecchmatrix[3][244] = 1;
   assign ecchmatrix[4][244] = 1;
   assign ecchmatrix[5][244] = 1;
   assign ecchmatrix[6][244] = 1;
   assign ecchmatrix[7][244] = 1;
   assign ecchmatrix[8][244] = 1;
   assign ecchmatrix[0][245] = 0;
   assign ecchmatrix[1][245] = 0;
   assign ecchmatrix[2][245] = 1;
   assign ecchmatrix[3][245] = 1;
   assign ecchmatrix[4][245] = 1;
   assign ecchmatrix[5][245] = 1;
   assign ecchmatrix[6][245] = 1;
   assign ecchmatrix[7][245] = 1;
   assign ecchmatrix[8][245] = 1;
   assign ecchmatrix[0][246] = 1;
   assign ecchmatrix[1][246] = 1;
   assign ecchmatrix[2][246] = 1;
   assign ecchmatrix[3][246] = 1;
   assign ecchmatrix[4][246] = 1;
   assign ecchmatrix[5][246] = 1;
   assign ecchmatrix[6][246] = 1;
   assign ecchmatrix[7][246] = 1;
   assign ecchmatrix[8][246] = 1;
   assign ecchmatrix[0][247] = 1;
   assign ecchmatrix[1][247] = 0;
   assign ecchmatrix[2][247] = 0;
   assign ecchmatrix[3][247] = 0;
   assign ecchmatrix[4][247] = 0;
   assign ecchmatrix[5][247] = 0;
   assign ecchmatrix[6][247] = 0;
   assign ecchmatrix[7][247] = 0;
   assign ecchmatrix[8][247] = 0;
   assign ecchmatrix[0][248] = 0;
   assign ecchmatrix[1][248] = 1;
   assign ecchmatrix[2][248] = 0;
   assign ecchmatrix[3][248] = 0;
   assign ecchmatrix[4][248] = 0;
   assign ecchmatrix[5][248] = 0;
   assign ecchmatrix[6][248] = 0;
   assign ecchmatrix[7][248] = 0;
   assign ecchmatrix[8][248] = 0;
   assign ecchmatrix[0][249] = 0;
   assign ecchmatrix[1][249] = 0;
   assign ecchmatrix[2][249] = 1;
   assign ecchmatrix[3][249] = 0;
   assign ecchmatrix[4][249] = 0;
   assign ecchmatrix[5][249] = 0;
   assign ecchmatrix[6][249] = 0;
   assign ecchmatrix[7][249] = 0;
   assign ecchmatrix[8][249] = 0;
   assign ecchmatrix[0][250] = 0;
   assign ecchmatrix[1][250] = 0;
   assign ecchmatrix[2][250] = 0;
   assign ecchmatrix[3][250] = 1;
   assign ecchmatrix[4][250] = 0;
   assign ecchmatrix[5][250] = 0;
   assign ecchmatrix[6][250] = 0;
   assign ecchmatrix[7][250] = 0;
   assign ecchmatrix[8][250] = 0;
   assign ecchmatrix[0][251] = 0;
   assign ecchmatrix[1][251] = 0;
   assign ecchmatrix[2][251] = 0;
   assign ecchmatrix[3][251] = 0;
   assign ecchmatrix[4][251] = 1;
   assign ecchmatrix[5][251] = 0;
   assign ecchmatrix[6][251] = 0;
   assign ecchmatrix[7][251] = 0;
   assign ecchmatrix[8][251] = 0;
   assign ecchmatrix[0][252] = 0;
   assign ecchmatrix[1][252] = 0;
   assign ecchmatrix[2][252] = 0;
   assign ecchmatrix[3][252] = 0;
   assign ecchmatrix[4][252] = 0;
   assign ecchmatrix[5][252] = 1;
   assign ecchmatrix[6][252] = 0;
   assign ecchmatrix[7][252] = 0;
   assign ecchmatrix[8][252] = 0;
   assign ecchmatrix[0][253] = 0;
   assign ecchmatrix[1][253] = 0;
   assign ecchmatrix[2][253] = 0;
   assign ecchmatrix[3][253] = 0;
   assign ecchmatrix[4][253] = 0;
   assign ecchmatrix[5][253] = 0;
   assign ecchmatrix[6][253] = 1;
   assign ecchmatrix[7][253] = 0;
   assign ecchmatrix[8][253] = 0;
   assign ecchmatrix[0][254] = 0;
   assign ecchmatrix[1][254] = 0;
   assign ecchmatrix[2][254] = 0;
   assign ecchmatrix[3][254] = 0;
   assign ecchmatrix[4][254] = 0;
   assign ecchmatrix[5][254] = 0;
   assign ecchmatrix[6][254] = 0;
   assign ecchmatrix[7][254] = 1;
   assign ecchmatrix[8][254] = 0;
   assign ecchmatrix[0][255] = 0;
   assign ecchmatrix[1][255] = 0;
   assign ecchmatrix[2][255] = 0;
   assign ecchmatrix[3][255] = 0;
   assign ecchmatrix[4][255] = 0;
   assign ecchmatrix[5][255] = 0;
   assign ecchmatrix[6][255] = 0;
   assign ecchmatrix[7][255] = 0;
   assign ecchmatrix[8][255] = 1;


  assign sbits_wire[8] = (^(ecchmatrix[8]&din)) ^ eccin[8] ;
  assign sbits_wire[7] = (^(ecchmatrix[7]&din)) ^ eccin[7] ;
  assign sbits_wire[6] = (^(ecchmatrix[6]&din)) ^ eccin[6] ;
  assign sbits_wire[5] = (^(ecchmatrix[5]&din)) ^ eccin[5] ;
  assign sbits_wire[4] = (^(ecchmatrix[4]&din)) ^ eccin[4] ;
  assign sbits_wire[3] = (^(ecchmatrix[3]&din)) ^ eccin[3] ;
  assign sbits_wire[2] = (^(ecchmatrix[2]&din)) ^ eccin[2] ;
  assign sbits_wire[1] = (^(ecchmatrix[1]&din)) ^ eccin[1] ;
  assign sbits_wire[0] = (^(ecchmatrix[0]&din)) ^ eccin[0] ;

  wire [ECCWIDTH-1:0]    sbits;
  wire [ECCDWIDTH-1:0]	din_f1;
  generate if(FLOPECC1) begin
	reg [ECCWIDTH-1:0]    sbits_reg;
	reg [ECCDWIDTH-1:0]	din_f1_reg;
	always @(posedge clk) begin
		sbits_reg <= sbits_wire;
		din_f1_reg <= din;
	end
	assign sbits = sbits_reg;
	assign din_f1 = din_f1_reg;
  end else begin
	assign sbits = sbits_wire;
	assign din_f1 = din;
  end
  endgenerate
  
  assign biterr_wire[255] = ~(
         ecchmatrix[8][255]^sbits[8] |
         ecchmatrix[7][255]^sbits[7] |
         ecchmatrix[6][255]^sbits[6] |
         ecchmatrix[5][255]^sbits[5] |
         ecchmatrix[4][255]^sbits[4] |
         ecchmatrix[3][255]^sbits[3] |
         ecchmatrix[2][255]^sbits[2] |
         ecchmatrix[1][255]^sbits[1] |
         ecchmatrix[0][255]^sbits[0]);
  assign biterr_wire[254] = ~(
         ecchmatrix[8][254]^sbits[8] |
         ecchmatrix[7][254]^sbits[7] |
         ecchmatrix[6][254]^sbits[6] |
         ecchmatrix[5][254]^sbits[5] |
         ecchmatrix[4][254]^sbits[4] |
         ecchmatrix[3][254]^sbits[3] |
         ecchmatrix[2][254]^sbits[2] |
         ecchmatrix[1][254]^sbits[1] |
         ecchmatrix[0][254]^sbits[0]);
  assign biterr_wire[253] = ~(
         ecchmatrix[8][253]^sbits[8] |
         ecchmatrix[7][253]^sbits[7] |
         ecchmatrix[6][253]^sbits[6] |
         ecchmatrix[5][253]^sbits[5] |
         ecchmatrix[4][253]^sbits[4] |
         ecchmatrix[3][253]^sbits[3] |
         ecchmatrix[2][253]^sbits[2] |
         ecchmatrix[1][253]^sbits[1] |
         ecchmatrix[0][253]^sbits[0]);
  assign biterr_wire[252] = ~(
         ecchmatrix[8][252]^sbits[8] |
         ecchmatrix[7][252]^sbits[7] |
         ecchmatrix[6][252]^sbits[6] |
         ecchmatrix[5][252]^sbits[5] |
         ecchmatrix[4][252]^sbits[4] |
         ecchmatrix[3][252]^sbits[3] |
         ecchmatrix[2][252]^sbits[2] |
         ecchmatrix[1][252]^sbits[1] |
         ecchmatrix[0][252]^sbits[0]);
  assign biterr_wire[251] = ~(
         ecchmatrix[8][251]^sbits[8] |
         ecchmatrix[7][251]^sbits[7] |
         ecchmatrix[6][251]^sbits[6] |
         ecchmatrix[5][251]^sbits[5] |
         ecchmatrix[4][251]^sbits[4] |
         ecchmatrix[3][251]^sbits[3] |
         ecchmatrix[2][251]^sbits[2] |
         ecchmatrix[1][251]^sbits[1] |
         ecchmatrix[0][251]^sbits[0]);
  assign biterr_wire[250] = ~(
         ecchmatrix[8][250]^sbits[8] |
         ecchmatrix[7][250]^sbits[7] |
         ecchmatrix[6][250]^sbits[6] |
         ecchmatrix[5][250]^sbits[5] |
         ecchmatrix[4][250]^sbits[4] |
         ecchmatrix[3][250]^sbits[3] |
         ecchmatrix[2][250]^sbits[2] |
         ecchmatrix[1][250]^sbits[1] |
         ecchmatrix[0][250]^sbits[0]);
  assign biterr_wire[249] = ~(
         ecchmatrix[8][249]^sbits[8] |
         ecchmatrix[7][249]^sbits[7] |
         ecchmatrix[6][249]^sbits[6] |
         ecchmatrix[5][249]^sbits[5] |
         ecchmatrix[4][249]^sbits[4] |
         ecchmatrix[3][249]^sbits[3] |
         ecchmatrix[2][249]^sbits[2] |
         ecchmatrix[1][249]^sbits[1] |
         ecchmatrix[0][249]^sbits[0]);
  assign biterr_wire[248] = ~(
         ecchmatrix[8][248]^sbits[8] |
         ecchmatrix[7][248]^sbits[7] |
         ecchmatrix[6][248]^sbits[6] |
         ecchmatrix[5][248]^sbits[5] |
         ecchmatrix[4][248]^sbits[4] |
         ecchmatrix[3][248]^sbits[3] |
         ecchmatrix[2][248]^sbits[2] |
         ecchmatrix[1][248]^sbits[1] |
         ecchmatrix[0][248]^sbits[0]);
  assign biterr_wire[247] = ~(
         ecchmatrix[8][247]^sbits[8] |
         ecchmatrix[7][247]^sbits[7] |
         ecchmatrix[6][247]^sbits[6] |
         ecchmatrix[5][247]^sbits[5] |
         ecchmatrix[4][247]^sbits[4] |
         ecchmatrix[3][247]^sbits[3] |
         ecchmatrix[2][247]^sbits[2] |
         ecchmatrix[1][247]^sbits[1] |
         ecchmatrix[0][247]^sbits[0]);
  assign biterr_wire[246] = ~(
         ecchmatrix[8][246]^sbits[8] |
         ecchmatrix[7][246]^sbits[7] |
         ecchmatrix[6][246]^sbits[6] |
         ecchmatrix[5][246]^sbits[5] |
         ecchmatrix[4][246]^sbits[4] |
         ecchmatrix[3][246]^sbits[3] |
         ecchmatrix[2][246]^sbits[2] |
         ecchmatrix[1][246]^sbits[1] |
         ecchmatrix[0][246]^sbits[0]);
  assign biterr_wire[245] = ~(
         ecchmatrix[8][245]^sbits[8] |
         ecchmatrix[7][245]^sbits[7] |
         ecchmatrix[6][245]^sbits[6] |
         ecchmatrix[5][245]^sbits[5] |
         ecchmatrix[4][245]^sbits[4] |
         ecchmatrix[3][245]^sbits[3] |
         ecchmatrix[2][245]^sbits[2] |
         ecchmatrix[1][245]^sbits[1] |
         ecchmatrix[0][245]^sbits[0]);
  assign biterr_wire[244] = ~(
         ecchmatrix[8][244]^sbits[8] |
         ecchmatrix[7][244]^sbits[7] |
         ecchmatrix[6][244]^sbits[6] |
         ecchmatrix[5][244]^sbits[5] |
         ecchmatrix[4][244]^sbits[4] |
         ecchmatrix[3][244]^sbits[3] |
         ecchmatrix[2][244]^sbits[2] |
         ecchmatrix[1][244]^sbits[1] |
         ecchmatrix[0][244]^sbits[0]);
  assign biterr_wire[243] = ~(
         ecchmatrix[8][243]^sbits[8] |
         ecchmatrix[7][243]^sbits[7] |
         ecchmatrix[6][243]^sbits[6] |
         ecchmatrix[5][243]^sbits[5] |
         ecchmatrix[4][243]^sbits[4] |
         ecchmatrix[3][243]^sbits[3] |
         ecchmatrix[2][243]^sbits[2] |
         ecchmatrix[1][243]^sbits[1] |
         ecchmatrix[0][243]^sbits[0]);
  assign biterr_wire[242] = ~(
         ecchmatrix[8][242]^sbits[8] |
         ecchmatrix[7][242]^sbits[7] |
         ecchmatrix[6][242]^sbits[6] |
         ecchmatrix[5][242]^sbits[5] |
         ecchmatrix[4][242]^sbits[4] |
         ecchmatrix[3][242]^sbits[3] |
         ecchmatrix[2][242]^sbits[2] |
         ecchmatrix[1][242]^sbits[1] |
         ecchmatrix[0][242]^sbits[0]);
  assign biterr_wire[241] = ~(
         ecchmatrix[8][241]^sbits[8] |
         ecchmatrix[7][241]^sbits[7] |
         ecchmatrix[6][241]^sbits[6] |
         ecchmatrix[5][241]^sbits[5] |
         ecchmatrix[4][241]^sbits[4] |
         ecchmatrix[3][241]^sbits[3] |
         ecchmatrix[2][241]^sbits[2] |
         ecchmatrix[1][241]^sbits[1] |
         ecchmatrix[0][241]^sbits[0]);
  assign biterr_wire[240] = ~(
         ecchmatrix[8][240]^sbits[8] |
         ecchmatrix[7][240]^sbits[7] |
         ecchmatrix[6][240]^sbits[6] |
         ecchmatrix[5][240]^sbits[5] |
         ecchmatrix[4][240]^sbits[4] |
         ecchmatrix[3][240]^sbits[3] |
         ecchmatrix[2][240]^sbits[2] |
         ecchmatrix[1][240]^sbits[1] |
         ecchmatrix[0][240]^sbits[0]);
  assign biterr_wire[239] = ~(
         ecchmatrix[8][239]^sbits[8] |
         ecchmatrix[7][239]^sbits[7] |
         ecchmatrix[6][239]^sbits[6] |
         ecchmatrix[5][239]^sbits[5] |
         ecchmatrix[4][239]^sbits[4] |
         ecchmatrix[3][239]^sbits[3] |
         ecchmatrix[2][239]^sbits[2] |
         ecchmatrix[1][239]^sbits[1] |
         ecchmatrix[0][239]^sbits[0]);
  assign biterr_wire[238] = ~(
         ecchmatrix[8][238]^sbits[8] |
         ecchmatrix[7][238]^sbits[7] |
         ecchmatrix[6][238]^sbits[6] |
         ecchmatrix[5][238]^sbits[5] |
         ecchmatrix[4][238]^sbits[4] |
         ecchmatrix[3][238]^sbits[3] |
         ecchmatrix[2][238]^sbits[2] |
         ecchmatrix[1][238]^sbits[1] |
         ecchmatrix[0][238]^sbits[0]);
  assign biterr_wire[237] = ~(
         ecchmatrix[8][237]^sbits[8] |
         ecchmatrix[7][237]^sbits[7] |
         ecchmatrix[6][237]^sbits[6] |
         ecchmatrix[5][237]^sbits[5] |
         ecchmatrix[4][237]^sbits[4] |
         ecchmatrix[3][237]^sbits[3] |
         ecchmatrix[2][237]^sbits[2] |
         ecchmatrix[1][237]^sbits[1] |
         ecchmatrix[0][237]^sbits[0]);
  assign biterr_wire[236] = ~(
         ecchmatrix[8][236]^sbits[8] |
         ecchmatrix[7][236]^sbits[7] |
         ecchmatrix[6][236]^sbits[6] |
         ecchmatrix[5][236]^sbits[5] |
         ecchmatrix[4][236]^sbits[4] |
         ecchmatrix[3][236]^sbits[3] |
         ecchmatrix[2][236]^sbits[2] |
         ecchmatrix[1][236]^sbits[1] |
         ecchmatrix[0][236]^sbits[0]);
  assign biterr_wire[235] = ~(
         ecchmatrix[8][235]^sbits[8] |
         ecchmatrix[7][235]^sbits[7] |
         ecchmatrix[6][235]^sbits[6] |
         ecchmatrix[5][235]^sbits[5] |
         ecchmatrix[4][235]^sbits[4] |
         ecchmatrix[3][235]^sbits[3] |
         ecchmatrix[2][235]^sbits[2] |
         ecchmatrix[1][235]^sbits[1] |
         ecchmatrix[0][235]^sbits[0]);
  assign biterr_wire[234] = ~(
         ecchmatrix[8][234]^sbits[8] |
         ecchmatrix[7][234]^sbits[7] |
         ecchmatrix[6][234]^sbits[6] |
         ecchmatrix[5][234]^sbits[5] |
         ecchmatrix[4][234]^sbits[4] |
         ecchmatrix[3][234]^sbits[3] |
         ecchmatrix[2][234]^sbits[2] |
         ecchmatrix[1][234]^sbits[1] |
         ecchmatrix[0][234]^sbits[0]);
  assign biterr_wire[233] = ~(
         ecchmatrix[8][233]^sbits[8] |
         ecchmatrix[7][233]^sbits[7] |
         ecchmatrix[6][233]^sbits[6] |
         ecchmatrix[5][233]^sbits[5] |
         ecchmatrix[4][233]^sbits[4] |
         ecchmatrix[3][233]^sbits[3] |
         ecchmatrix[2][233]^sbits[2] |
         ecchmatrix[1][233]^sbits[1] |
         ecchmatrix[0][233]^sbits[0]);
  assign biterr_wire[232] = ~(
         ecchmatrix[8][232]^sbits[8] |
         ecchmatrix[7][232]^sbits[7] |
         ecchmatrix[6][232]^sbits[6] |
         ecchmatrix[5][232]^sbits[5] |
         ecchmatrix[4][232]^sbits[4] |
         ecchmatrix[3][232]^sbits[3] |
         ecchmatrix[2][232]^sbits[2] |
         ecchmatrix[1][232]^sbits[1] |
         ecchmatrix[0][232]^sbits[0]);
  assign biterr_wire[231] = ~(
         ecchmatrix[8][231]^sbits[8] |
         ecchmatrix[7][231]^sbits[7] |
         ecchmatrix[6][231]^sbits[6] |
         ecchmatrix[5][231]^sbits[5] |
         ecchmatrix[4][231]^sbits[4] |
         ecchmatrix[3][231]^sbits[3] |
         ecchmatrix[2][231]^sbits[2] |
         ecchmatrix[1][231]^sbits[1] |
         ecchmatrix[0][231]^sbits[0]);
  assign biterr_wire[230] = ~(
         ecchmatrix[8][230]^sbits[8] |
         ecchmatrix[7][230]^sbits[7] |
         ecchmatrix[6][230]^sbits[6] |
         ecchmatrix[5][230]^sbits[5] |
         ecchmatrix[4][230]^sbits[4] |
         ecchmatrix[3][230]^sbits[3] |
         ecchmatrix[2][230]^sbits[2] |
         ecchmatrix[1][230]^sbits[1] |
         ecchmatrix[0][230]^sbits[0]);
  assign biterr_wire[229] = ~(
         ecchmatrix[8][229]^sbits[8] |
         ecchmatrix[7][229]^sbits[7] |
         ecchmatrix[6][229]^sbits[6] |
         ecchmatrix[5][229]^sbits[5] |
         ecchmatrix[4][229]^sbits[4] |
         ecchmatrix[3][229]^sbits[3] |
         ecchmatrix[2][229]^sbits[2] |
         ecchmatrix[1][229]^sbits[1] |
         ecchmatrix[0][229]^sbits[0]);
  assign biterr_wire[228] = ~(
         ecchmatrix[8][228]^sbits[8] |
         ecchmatrix[7][228]^sbits[7] |
         ecchmatrix[6][228]^sbits[6] |
         ecchmatrix[5][228]^sbits[5] |
         ecchmatrix[4][228]^sbits[4] |
         ecchmatrix[3][228]^sbits[3] |
         ecchmatrix[2][228]^sbits[2] |
         ecchmatrix[1][228]^sbits[1] |
         ecchmatrix[0][228]^sbits[0]);
  assign biterr_wire[227] = ~(
         ecchmatrix[8][227]^sbits[8] |
         ecchmatrix[7][227]^sbits[7] |
         ecchmatrix[6][227]^sbits[6] |
         ecchmatrix[5][227]^sbits[5] |
         ecchmatrix[4][227]^sbits[4] |
         ecchmatrix[3][227]^sbits[3] |
         ecchmatrix[2][227]^sbits[2] |
         ecchmatrix[1][227]^sbits[1] |
         ecchmatrix[0][227]^sbits[0]);
  assign biterr_wire[226] = ~(
         ecchmatrix[8][226]^sbits[8] |
         ecchmatrix[7][226]^sbits[7] |
         ecchmatrix[6][226]^sbits[6] |
         ecchmatrix[5][226]^sbits[5] |
         ecchmatrix[4][226]^sbits[4] |
         ecchmatrix[3][226]^sbits[3] |
         ecchmatrix[2][226]^sbits[2] |
         ecchmatrix[1][226]^sbits[1] |
         ecchmatrix[0][226]^sbits[0]);
  assign biterr_wire[225] = ~(
         ecchmatrix[8][225]^sbits[8] |
         ecchmatrix[7][225]^sbits[7] |
         ecchmatrix[6][225]^sbits[6] |
         ecchmatrix[5][225]^sbits[5] |
         ecchmatrix[4][225]^sbits[4] |
         ecchmatrix[3][225]^sbits[3] |
         ecchmatrix[2][225]^sbits[2] |
         ecchmatrix[1][225]^sbits[1] |
         ecchmatrix[0][225]^sbits[0]);
  assign biterr_wire[224] = ~(
         ecchmatrix[8][224]^sbits[8] |
         ecchmatrix[7][224]^sbits[7] |
         ecchmatrix[6][224]^sbits[6] |
         ecchmatrix[5][224]^sbits[5] |
         ecchmatrix[4][224]^sbits[4] |
         ecchmatrix[3][224]^sbits[3] |
         ecchmatrix[2][224]^sbits[2] |
         ecchmatrix[1][224]^sbits[1] |
         ecchmatrix[0][224]^sbits[0]);
  assign biterr_wire[223] = ~(
         ecchmatrix[8][223]^sbits[8] |
         ecchmatrix[7][223]^sbits[7] |
         ecchmatrix[6][223]^sbits[6] |
         ecchmatrix[5][223]^sbits[5] |
         ecchmatrix[4][223]^sbits[4] |
         ecchmatrix[3][223]^sbits[3] |
         ecchmatrix[2][223]^sbits[2] |
         ecchmatrix[1][223]^sbits[1] |
         ecchmatrix[0][223]^sbits[0]);
  assign biterr_wire[222] = ~(
         ecchmatrix[8][222]^sbits[8] |
         ecchmatrix[7][222]^sbits[7] |
         ecchmatrix[6][222]^sbits[6] |
         ecchmatrix[5][222]^sbits[5] |
         ecchmatrix[4][222]^sbits[4] |
         ecchmatrix[3][222]^sbits[3] |
         ecchmatrix[2][222]^sbits[2] |
         ecchmatrix[1][222]^sbits[1] |
         ecchmatrix[0][222]^sbits[0]);
  assign biterr_wire[221] = ~(
         ecchmatrix[8][221]^sbits[8] |
         ecchmatrix[7][221]^sbits[7] |
         ecchmatrix[6][221]^sbits[6] |
         ecchmatrix[5][221]^sbits[5] |
         ecchmatrix[4][221]^sbits[4] |
         ecchmatrix[3][221]^sbits[3] |
         ecchmatrix[2][221]^sbits[2] |
         ecchmatrix[1][221]^sbits[1] |
         ecchmatrix[0][221]^sbits[0]);
  assign biterr_wire[220] = ~(
         ecchmatrix[8][220]^sbits[8] |
         ecchmatrix[7][220]^sbits[7] |
         ecchmatrix[6][220]^sbits[6] |
         ecchmatrix[5][220]^sbits[5] |
         ecchmatrix[4][220]^sbits[4] |
         ecchmatrix[3][220]^sbits[3] |
         ecchmatrix[2][220]^sbits[2] |
         ecchmatrix[1][220]^sbits[1] |
         ecchmatrix[0][220]^sbits[0]);
  assign biterr_wire[219] = ~(
         ecchmatrix[8][219]^sbits[8] |
         ecchmatrix[7][219]^sbits[7] |
         ecchmatrix[6][219]^sbits[6] |
         ecchmatrix[5][219]^sbits[5] |
         ecchmatrix[4][219]^sbits[4] |
         ecchmatrix[3][219]^sbits[3] |
         ecchmatrix[2][219]^sbits[2] |
         ecchmatrix[1][219]^sbits[1] |
         ecchmatrix[0][219]^sbits[0]);
  assign biterr_wire[218] = ~(
         ecchmatrix[8][218]^sbits[8] |
         ecchmatrix[7][218]^sbits[7] |
         ecchmatrix[6][218]^sbits[6] |
         ecchmatrix[5][218]^sbits[5] |
         ecchmatrix[4][218]^sbits[4] |
         ecchmatrix[3][218]^sbits[3] |
         ecchmatrix[2][218]^sbits[2] |
         ecchmatrix[1][218]^sbits[1] |
         ecchmatrix[0][218]^sbits[0]);
  assign biterr_wire[217] = ~(
         ecchmatrix[8][217]^sbits[8] |
         ecchmatrix[7][217]^sbits[7] |
         ecchmatrix[6][217]^sbits[6] |
         ecchmatrix[5][217]^sbits[5] |
         ecchmatrix[4][217]^sbits[4] |
         ecchmatrix[3][217]^sbits[3] |
         ecchmatrix[2][217]^sbits[2] |
         ecchmatrix[1][217]^sbits[1] |
         ecchmatrix[0][217]^sbits[0]);
  assign biterr_wire[216] = ~(
         ecchmatrix[8][216]^sbits[8] |
         ecchmatrix[7][216]^sbits[7] |
         ecchmatrix[6][216]^sbits[6] |
         ecchmatrix[5][216]^sbits[5] |
         ecchmatrix[4][216]^sbits[4] |
         ecchmatrix[3][216]^sbits[3] |
         ecchmatrix[2][216]^sbits[2] |
         ecchmatrix[1][216]^sbits[1] |
         ecchmatrix[0][216]^sbits[0]);
  assign biterr_wire[215] = ~(
         ecchmatrix[8][215]^sbits[8] |
         ecchmatrix[7][215]^sbits[7] |
         ecchmatrix[6][215]^sbits[6] |
         ecchmatrix[5][215]^sbits[5] |
         ecchmatrix[4][215]^sbits[4] |
         ecchmatrix[3][215]^sbits[3] |
         ecchmatrix[2][215]^sbits[2] |
         ecchmatrix[1][215]^sbits[1] |
         ecchmatrix[0][215]^sbits[0]);
  assign biterr_wire[214] = ~(
         ecchmatrix[8][214]^sbits[8] |
         ecchmatrix[7][214]^sbits[7] |
         ecchmatrix[6][214]^sbits[6] |
         ecchmatrix[5][214]^sbits[5] |
         ecchmatrix[4][214]^sbits[4] |
         ecchmatrix[3][214]^sbits[3] |
         ecchmatrix[2][214]^sbits[2] |
         ecchmatrix[1][214]^sbits[1] |
         ecchmatrix[0][214]^sbits[0]);
  assign biterr_wire[213] = ~(
         ecchmatrix[8][213]^sbits[8] |
         ecchmatrix[7][213]^sbits[7] |
         ecchmatrix[6][213]^sbits[6] |
         ecchmatrix[5][213]^sbits[5] |
         ecchmatrix[4][213]^sbits[4] |
         ecchmatrix[3][213]^sbits[3] |
         ecchmatrix[2][213]^sbits[2] |
         ecchmatrix[1][213]^sbits[1] |
         ecchmatrix[0][213]^sbits[0]);
  assign biterr_wire[212] = ~(
         ecchmatrix[8][212]^sbits[8] |
         ecchmatrix[7][212]^sbits[7] |
         ecchmatrix[6][212]^sbits[6] |
         ecchmatrix[5][212]^sbits[5] |
         ecchmatrix[4][212]^sbits[4] |
         ecchmatrix[3][212]^sbits[3] |
         ecchmatrix[2][212]^sbits[2] |
         ecchmatrix[1][212]^sbits[1] |
         ecchmatrix[0][212]^sbits[0]);
  assign biterr_wire[211] = ~(
         ecchmatrix[8][211]^sbits[8] |
         ecchmatrix[7][211]^sbits[7] |
         ecchmatrix[6][211]^sbits[6] |
         ecchmatrix[5][211]^sbits[5] |
         ecchmatrix[4][211]^sbits[4] |
         ecchmatrix[3][211]^sbits[3] |
         ecchmatrix[2][211]^sbits[2] |
         ecchmatrix[1][211]^sbits[1] |
         ecchmatrix[0][211]^sbits[0]);
  assign biterr_wire[210] = ~(
         ecchmatrix[8][210]^sbits[8] |
         ecchmatrix[7][210]^sbits[7] |
         ecchmatrix[6][210]^sbits[6] |
         ecchmatrix[5][210]^sbits[5] |
         ecchmatrix[4][210]^sbits[4] |
         ecchmatrix[3][210]^sbits[3] |
         ecchmatrix[2][210]^sbits[2] |
         ecchmatrix[1][210]^sbits[1] |
         ecchmatrix[0][210]^sbits[0]);
  assign biterr_wire[209] = ~(
         ecchmatrix[8][209]^sbits[8] |
         ecchmatrix[7][209]^sbits[7] |
         ecchmatrix[6][209]^sbits[6] |
         ecchmatrix[5][209]^sbits[5] |
         ecchmatrix[4][209]^sbits[4] |
         ecchmatrix[3][209]^sbits[3] |
         ecchmatrix[2][209]^sbits[2] |
         ecchmatrix[1][209]^sbits[1] |
         ecchmatrix[0][209]^sbits[0]);
  assign biterr_wire[208] = ~(
         ecchmatrix[8][208]^sbits[8] |
         ecchmatrix[7][208]^sbits[7] |
         ecchmatrix[6][208]^sbits[6] |
         ecchmatrix[5][208]^sbits[5] |
         ecchmatrix[4][208]^sbits[4] |
         ecchmatrix[3][208]^sbits[3] |
         ecchmatrix[2][208]^sbits[2] |
         ecchmatrix[1][208]^sbits[1] |
         ecchmatrix[0][208]^sbits[0]);
  assign biterr_wire[207] = ~(
         ecchmatrix[8][207]^sbits[8] |
         ecchmatrix[7][207]^sbits[7] |
         ecchmatrix[6][207]^sbits[6] |
         ecchmatrix[5][207]^sbits[5] |
         ecchmatrix[4][207]^sbits[4] |
         ecchmatrix[3][207]^sbits[3] |
         ecchmatrix[2][207]^sbits[2] |
         ecchmatrix[1][207]^sbits[1] |
         ecchmatrix[0][207]^sbits[0]);
  assign biterr_wire[206] = ~(
         ecchmatrix[8][206]^sbits[8] |
         ecchmatrix[7][206]^sbits[7] |
         ecchmatrix[6][206]^sbits[6] |
         ecchmatrix[5][206]^sbits[5] |
         ecchmatrix[4][206]^sbits[4] |
         ecchmatrix[3][206]^sbits[3] |
         ecchmatrix[2][206]^sbits[2] |
         ecchmatrix[1][206]^sbits[1] |
         ecchmatrix[0][206]^sbits[0]);
  assign biterr_wire[205] = ~(
         ecchmatrix[8][205]^sbits[8] |
         ecchmatrix[7][205]^sbits[7] |
         ecchmatrix[6][205]^sbits[6] |
         ecchmatrix[5][205]^sbits[5] |
         ecchmatrix[4][205]^sbits[4] |
         ecchmatrix[3][205]^sbits[3] |
         ecchmatrix[2][205]^sbits[2] |
         ecchmatrix[1][205]^sbits[1] |
         ecchmatrix[0][205]^sbits[0]);
  assign biterr_wire[204] = ~(
         ecchmatrix[8][204]^sbits[8] |
         ecchmatrix[7][204]^sbits[7] |
         ecchmatrix[6][204]^sbits[6] |
         ecchmatrix[5][204]^sbits[5] |
         ecchmatrix[4][204]^sbits[4] |
         ecchmatrix[3][204]^sbits[3] |
         ecchmatrix[2][204]^sbits[2] |
         ecchmatrix[1][204]^sbits[1] |
         ecchmatrix[0][204]^sbits[0]);
  assign biterr_wire[203] = ~(
         ecchmatrix[8][203]^sbits[8] |
         ecchmatrix[7][203]^sbits[7] |
         ecchmatrix[6][203]^sbits[6] |
         ecchmatrix[5][203]^sbits[5] |
         ecchmatrix[4][203]^sbits[4] |
         ecchmatrix[3][203]^sbits[3] |
         ecchmatrix[2][203]^sbits[2] |
         ecchmatrix[1][203]^sbits[1] |
         ecchmatrix[0][203]^sbits[0]);
  assign biterr_wire[202] = ~(
         ecchmatrix[8][202]^sbits[8] |
         ecchmatrix[7][202]^sbits[7] |
         ecchmatrix[6][202]^sbits[6] |
         ecchmatrix[5][202]^sbits[5] |
         ecchmatrix[4][202]^sbits[4] |
         ecchmatrix[3][202]^sbits[3] |
         ecchmatrix[2][202]^sbits[2] |
         ecchmatrix[1][202]^sbits[1] |
         ecchmatrix[0][202]^sbits[0]);
  assign biterr_wire[201] = ~(
         ecchmatrix[8][201]^sbits[8] |
         ecchmatrix[7][201]^sbits[7] |
         ecchmatrix[6][201]^sbits[6] |
         ecchmatrix[5][201]^sbits[5] |
         ecchmatrix[4][201]^sbits[4] |
         ecchmatrix[3][201]^sbits[3] |
         ecchmatrix[2][201]^sbits[2] |
         ecchmatrix[1][201]^sbits[1] |
         ecchmatrix[0][201]^sbits[0]);
  assign biterr_wire[200] = ~(
         ecchmatrix[8][200]^sbits[8] |
         ecchmatrix[7][200]^sbits[7] |
         ecchmatrix[6][200]^sbits[6] |
         ecchmatrix[5][200]^sbits[5] |
         ecchmatrix[4][200]^sbits[4] |
         ecchmatrix[3][200]^sbits[3] |
         ecchmatrix[2][200]^sbits[2] |
         ecchmatrix[1][200]^sbits[1] |
         ecchmatrix[0][200]^sbits[0]);
  assign biterr_wire[199] = ~(
         ecchmatrix[8][199]^sbits[8] |
         ecchmatrix[7][199]^sbits[7] |
         ecchmatrix[6][199]^sbits[6] |
         ecchmatrix[5][199]^sbits[5] |
         ecchmatrix[4][199]^sbits[4] |
         ecchmatrix[3][199]^sbits[3] |
         ecchmatrix[2][199]^sbits[2] |
         ecchmatrix[1][199]^sbits[1] |
         ecchmatrix[0][199]^sbits[0]);
  assign biterr_wire[198] = ~(
         ecchmatrix[8][198]^sbits[8] |
         ecchmatrix[7][198]^sbits[7] |
         ecchmatrix[6][198]^sbits[6] |
         ecchmatrix[5][198]^sbits[5] |
         ecchmatrix[4][198]^sbits[4] |
         ecchmatrix[3][198]^sbits[3] |
         ecchmatrix[2][198]^sbits[2] |
         ecchmatrix[1][198]^sbits[1] |
         ecchmatrix[0][198]^sbits[0]);
  assign biterr_wire[197] = ~(
         ecchmatrix[8][197]^sbits[8] |
         ecchmatrix[7][197]^sbits[7] |
         ecchmatrix[6][197]^sbits[6] |
         ecchmatrix[5][197]^sbits[5] |
         ecchmatrix[4][197]^sbits[4] |
         ecchmatrix[3][197]^sbits[3] |
         ecchmatrix[2][197]^sbits[2] |
         ecchmatrix[1][197]^sbits[1] |
         ecchmatrix[0][197]^sbits[0]);
  assign biterr_wire[196] = ~(
         ecchmatrix[8][196]^sbits[8] |
         ecchmatrix[7][196]^sbits[7] |
         ecchmatrix[6][196]^sbits[6] |
         ecchmatrix[5][196]^sbits[5] |
         ecchmatrix[4][196]^sbits[4] |
         ecchmatrix[3][196]^sbits[3] |
         ecchmatrix[2][196]^sbits[2] |
         ecchmatrix[1][196]^sbits[1] |
         ecchmatrix[0][196]^sbits[0]);
  assign biterr_wire[195] = ~(
         ecchmatrix[8][195]^sbits[8] |
         ecchmatrix[7][195]^sbits[7] |
         ecchmatrix[6][195]^sbits[6] |
         ecchmatrix[5][195]^sbits[5] |
         ecchmatrix[4][195]^sbits[4] |
         ecchmatrix[3][195]^sbits[3] |
         ecchmatrix[2][195]^sbits[2] |
         ecchmatrix[1][195]^sbits[1] |
         ecchmatrix[0][195]^sbits[0]);
  assign biterr_wire[194] = ~(
         ecchmatrix[8][194]^sbits[8] |
         ecchmatrix[7][194]^sbits[7] |
         ecchmatrix[6][194]^sbits[6] |
         ecchmatrix[5][194]^sbits[5] |
         ecchmatrix[4][194]^sbits[4] |
         ecchmatrix[3][194]^sbits[3] |
         ecchmatrix[2][194]^sbits[2] |
         ecchmatrix[1][194]^sbits[1] |
         ecchmatrix[0][194]^sbits[0]);
  assign biterr_wire[193] = ~(
         ecchmatrix[8][193]^sbits[8] |
         ecchmatrix[7][193]^sbits[7] |
         ecchmatrix[6][193]^sbits[6] |
         ecchmatrix[5][193]^sbits[5] |
         ecchmatrix[4][193]^sbits[4] |
         ecchmatrix[3][193]^sbits[3] |
         ecchmatrix[2][193]^sbits[2] |
         ecchmatrix[1][193]^sbits[1] |
         ecchmatrix[0][193]^sbits[0]);
  assign biterr_wire[192] = ~(
         ecchmatrix[8][192]^sbits[8] |
         ecchmatrix[7][192]^sbits[7] |
         ecchmatrix[6][192]^sbits[6] |
         ecchmatrix[5][192]^sbits[5] |
         ecchmatrix[4][192]^sbits[4] |
         ecchmatrix[3][192]^sbits[3] |
         ecchmatrix[2][192]^sbits[2] |
         ecchmatrix[1][192]^sbits[1] |
         ecchmatrix[0][192]^sbits[0]);
  assign biterr_wire[191] = ~(
         ecchmatrix[8][191]^sbits[8] |
         ecchmatrix[7][191]^sbits[7] |
         ecchmatrix[6][191]^sbits[6] |
         ecchmatrix[5][191]^sbits[5] |
         ecchmatrix[4][191]^sbits[4] |
         ecchmatrix[3][191]^sbits[3] |
         ecchmatrix[2][191]^sbits[2] |
         ecchmatrix[1][191]^sbits[1] |
         ecchmatrix[0][191]^sbits[0]);
  assign biterr_wire[190] = ~(
         ecchmatrix[8][190]^sbits[8] |
         ecchmatrix[7][190]^sbits[7] |
         ecchmatrix[6][190]^sbits[6] |
         ecchmatrix[5][190]^sbits[5] |
         ecchmatrix[4][190]^sbits[4] |
         ecchmatrix[3][190]^sbits[3] |
         ecchmatrix[2][190]^sbits[2] |
         ecchmatrix[1][190]^sbits[1] |
         ecchmatrix[0][190]^sbits[0]);
  assign biterr_wire[189] = ~(
         ecchmatrix[8][189]^sbits[8] |
         ecchmatrix[7][189]^sbits[7] |
         ecchmatrix[6][189]^sbits[6] |
         ecchmatrix[5][189]^sbits[5] |
         ecchmatrix[4][189]^sbits[4] |
         ecchmatrix[3][189]^sbits[3] |
         ecchmatrix[2][189]^sbits[2] |
         ecchmatrix[1][189]^sbits[1] |
         ecchmatrix[0][189]^sbits[0]);
  assign biterr_wire[188] = ~(
         ecchmatrix[8][188]^sbits[8] |
         ecchmatrix[7][188]^sbits[7] |
         ecchmatrix[6][188]^sbits[6] |
         ecchmatrix[5][188]^sbits[5] |
         ecchmatrix[4][188]^sbits[4] |
         ecchmatrix[3][188]^sbits[3] |
         ecchmatrix[2][188]^sbits[2] |
         ecchmatrix[1][188]^sbits[1] |
         ecchmatrix[0][188]^sbits[0]);
  assign biterr_wire[187] = ~(
         ecchmatrix[8][187]^sbits[8] |
         ecchmatrix[7][187]^sbits[7] |
         ecchmatrix[6][187]^sbits[6] |
         ecchmatrix[5][187]^sbits[5] |
         ecchmatrix[4][187]^sbits[4] |
         ecchmatrix[3][187]^sbits[3] |
         ecchmatrix[2][187]^sbits[2] |
         ecchmatrix[1][187]^sbits[1] |
         ecchmatrix[0][187]^sbits[0]);
  assign biterr_wire[186] = ~(
         ecchmatrix[8][186]^sbits[8] |
         ecchmatrix[7][186]^sbits[7] |
         ecchmatrix[6][186]^sbits[6] |
         ecchmatrix[5][186]^sbits[5] |
         ecchmatrix[4][186]^sbits[4] |
         ecchmatrix[3][186]^sbits[3] |
         ecchmatrix[2][186]^sbits[2] |
         ecchmatrix[1][186]^sbits[1] |
         ecchmatrix[0][186]^sbits[0]);
  assign biterr_wire[185] = ~(
         ecchmatrix[8][185]^sbits[8] |
         ecchmatrix[7][185]^sbits[7] |
         ecchmatrix[6][185]^sbits[6] |
         ecchmatrix[5][185]^sbits[5] |
         ecchmatrix[4][185]^sbits[4] |
         ecchmatrix[3][185]^sbits[3] |
         ecchmatrix[2][185]^sbits[2] |
         ecchmatrix[1][185]^sbits[1] |
         ecchmatrix[0][185]^sbits[0]);
  assign biterr_wire[184] = ~(
         ecchmatrix[8][184]^sbits[8] |
         ecchmatrix[7][184]^sbits[7] |
         ecchmatrix[6][184]^sbits[6] |
         ecchmatrix[5][184]^sbits[5] |
         ecchmatrix[4][184]^sbits[4] |
         ecchmatrix[3][184]^sbits[3] |
         ecchmatrix[2][184]^sbits[2] |
         ecchmatrix[1][184]^sbits[1] |
         ecchmatrix[0][184]^sbits[0]);
  assign biterr_wire[183] = ~(
         ecchmatrix[8][183]^sbits[8] |
         ecchmatrix[7][183]^sbits[7] |
         ecchmatrix[6][183]^sbits[6] |
         ecchmatrix[5][183]^sbits[5] |
         ecchmatrix[4][183]^sbits[4] |
         ecchmatrix[3][183]^sbits[3] |
         ecchmatrix[2][183]^sbits[2] |
         ecchmatrix[1][183]^sbits[1] |
         ecchmatrix[0][183]^sbits[0]);
  assign biterr_wire[182] = ~(
         ecchmatrix[8][182]^sbits[8] |
         ecchmatrix[7][182]^sbits[7] |
         ecchmatrix[6][182]^sbits[6] |
         ecchmatrix[5][182]^sbits[5] |
         ecchmatrix[4][182]^sbits[4] |
         ecchmatrix[3][182]^sbits[3] |
         ecchmatrix[2][182]^sbits[2] |
         ecchmatrix[1][182]^sbits[1] |
         ecchmatrix[0][182]^sbits[0]);
  assign biterr_wire[181] = ~(
         ecchmatrix[8][181]^sbits[8] |
         ecchmatrix[7][181]^sbits[7] |
         ecchmatrix[6][181]^sbits[6] |
         ecchmatrix[5][181]^sbits[5] |
         ecchmatrix[4][181]^sbits[4] |
         ecchmatrix[3][181]^sbits[3] |
         ecchmatrix[2][181]^sbits[2] |
         ecchmatrix[1][181]^sbits[1] |
         ecchmatrix[0][181]^sbits[0]);
  assign biterr_wire[180] = ~(
         ecchmatrix[8][180]^sbits[8] |
         ecchmatrix[7][180]^sbits[7] |
         ecchmatrix[6][180]^sbits[6] |
         ecchmatrix[5][180]^sbits[5] |
         ecchmatrix[4][180]^sbits[4] |
         ecchmatrix[3][180]^sbits[3] |
         ecchmatrix[2][180]^sbits[2] |
         ecchmatrix[1][180]^sbits[1] |
         ecchmatrix[0][180]^sbits[0]);
  assign biterr_wire[179] = ~(
         ecchmatrix[8][179]^sbits[8] |
         ecchmatrix[7][179]^sbits[7] |
         ecchmatrix[6][179]^sbits[6] |
         ecchmatrix[5][179]^sbits[5] |
         ecchmatrix[4][179]^sbits[4] |
         ecchmatrix[3][179]^sbits[3] |
         ecchmatrix[2][179]^sbits[2] |
         ecchmatrix[1][179]^sbits[1] |
         ecchmatrix[0][179]^sbits[0]);
  assign biterr_wire[178] = ~(
         ecchmatrix[8][178]^sbits[8] |
         ecchmatrix[7][178]^sbits[7] |
         ecchmatrix[6][178]^sbits[6] |
         ecchmatrix[5][178]^sbits[5] |
         ecchmatrix[4][178]^sbits[4] |
         ecchmatrix[3][178]^sbits[3] |
         ecchmatrix[2][178]^sbits[2] |
         ecchmatrix[1][178]^sbits[1] |
         ecchmatrix[0][178]^sbits[0]);
  assign biterr_wire[177] = ~(
         ecchmatrix[8][177]^sbits[8] |
         ecchmatrix[7][177]^sbits[7] |
         ecchmatrix[6][177]^sbits[6] |
         ecchmatrix[5][177]^sbits[5] |
         ecchmatrix[4][177]^sbits[4] |
         ecchmatrix[3][177]^sbits[3] |
         ecchmatrix[2][177]^sbits[2] |
         ecchmatrix[1][177]^sbits[1] |
         ecchmatrix[0][177]^sbits[0]);
  assign biterr_wire[176] = ~(
         ecchmatrix[8][176]^sbits[8] |
         ecchmatrix[7][176]^sbits[7] |
         ecchmatrix[6][176]^sbits[6] |
         ecchmatrix[5][176]^sbits[5] |
         ecchmatrix[4][176]^sbits[4] |
         ecchmatrix[3][176]^sbits[3] |
         ecchmatrix[2][176]^sbits[2] |
         ecchmatrix[1][176]^sbits[1] |
         ecchmatrix[0][176]^sbits[0]);
  assign biterr_wire[175] = ~(
         ecchmatrix[8][175]^sbits[8] |
         ecchmatrix[7][175]^sbits[7] |
         ecchmatrix[6][175]^sbits[6] |
         ecchmatrix[5][175]^sbits[5] |
         ecchmatrix[4][175]^sbits[4] |
         ecchmatrix[3][175]^sbits[3] |
         ecchmatrix[2][175]^sbits[2] |
         ecchmatrix[1][175]^sbits[1] |
         ecchmatrix[0][175]^sbits[0]);
  assign biterr_wire[174] = ~(
         ecchmatrix[8][174]^sbits[8] |
         ecchmatrix[7][174]^sbits[7] |
         ecchmatrix[6][174]^sbits[6] |
         ecchmatrix[5][174]^sbits[5] |
         ecchmatrix[4][174]^sbits[4] |
         ecchmatrix[3][174]^sbits[3] |
         ecchmatrix[2][174]^sbits[2] |
         ecchmatrix[1][174]^sbits[1] |
         ecchmatrix[0][174]^sbits[0]);
  assign biterr_wire[173] = ~(
         ecchmatrix[8][173]^sbits[8] |
         ecchmatrix[7][173]^sbits[7] |
         ecchmatrix[6][173]^sbits[6] |
         ecchmatrix[5][173]^sbits[5] |
         ecchmatrix[4][173]^sbits[4] |
         ecchmatrix[3][173]^sbits[3] |
         ecchmatrix[2][173]^sbits[2] |
         ecchmatrix[1][173]^sbits[1] |
         ecchmatrix[0][173]^sbits[0]);
  assign biterr_wire[172] = ~(
         ecchmatrix[8][172]^sbits[8] |
         ecchmatrix[7][172]^sbits[7] |
         ecchmatrix[6][172]^sbits[6] |
         ecchmatrix[5][172]^sbits[5] |
         ecchmatrix[4][172]^sbits[4] |
         ecchmatrix[3][172]^sbits[3] |
         ecchmatrix[2][172]^sbits[2] |
         ecchmatrix[1][172]^sbits[1] |
         ecchmatrix[0][172]^sbits[0]);
  assign biterr_wire[171] = ~(
         ecchmatrix[8][171]^sbits[8] |
         ecchmatrix[7][171]^sbits[7] |
         ecchmatrix[6][171]^sbits[6] |
         ecchmatrix[5][171]^sbits[5] |
         ecchmatrix[4][171]^sbits[4] |
         ecchmatrix[3][171]^sbits[3] |
         ecchmatrix[2][171]^sbits[2] |
         ecchmatrix[1][171]^sbits[1] |
         ecchmatrix[0][171]^sbits[0]);
  assign biterr_wire[170] = ~(
         ecchmatrix[8][170]^sbits[8] |
         ecchmatrix[7][170]^sbits[7] |
         ecchmatrix[6][170]^sbits[6] |
         ecchmatrix[5][170]^sbits[5] |
         ecchmatrix[4][170]^sbits[4] |
         ecchmatrix[3][170]^sbits[3] |
         ecchmatrix[2][170]^sbits[2] |
         ecchmatrix[1][170]^sbits[1] |
         ecchmatrix[0][170]^sbits[0]);
  assign biterr_wire[169] = ~(
         ecchmatrix[8][169]^sbits[8] |
         ecchmatrix[7][169]^sbits[7] |
         ecchmatrix[6][169]^sbits[6] |
         ecchmatrix[5][169]^sbits[5] |
         ecchmatrix[4][169]^sbits[4] |
         ecchmatrix[3][169]^sbits[3] |
         ecchmatrix[2][169]^sbits[2] |
         ecchmatrix[1][169]^sbits[1] |
         ecchmatrix[0][169]^sbits[0]);
  assign biterr_wire[168] = ~(
         ecchmatrix[8][168]^sbits[8] |
         ecchmatrix[7][168]^sbits[7] |
         ecchmatrix[6][168]^sbits[6] |
         ecchmatrix[5][168]^sbits[5] |
         ecchmatrix[4][168]^sbits[4] |
         ecchmatrix[3][168]^sbits[3] |
         ecchmatrix[2][168]^sbits[2] |
         ecchmatrix[1][168]^sbits[1] |
         ecchmatrix[0][168]^sbits[0]);
  assign biterr_wire[167] = ~(
         ecchmatrix[8][167]^sbits[8] |
         ecchmatrix[7][167]^sbits[7] |
         ecchmatrix[6][167]^sbits[6] |
         ecchmatrix[5][167]^sbits[5] |
         ecchmatrix[4][167]^sbits[4] |
         ecchmatrix[3][167]^sbits[3] |
         ecchmatrix[2][167]^sbits[2] |
         ecchmatrix[1][167]^sbits[1] |
         ecchmatrix[0][167]^sbits[0]);
  assign biterr_wire[166] = ~(
         ecchmatrix[8][166]^sbits[8] |
         ecchmatrix[7][166]^sbits[7] |
         ecchmatrix[6][166]^sbits[6] |
         ecchmatrix[5][166]^sbits[5] |
         ecchmatrix[4][166]^sbits[4] |
         ecchmatrix[3][166]^sbits[3] |
         ecchmatrix[2][166]^sbits[2] |
         ecchmatrix[1][166]^sbits[1] |
         ecchmatrix[0][166]^sbits[0]);
  assign biterr_wire[165] = ~(
         ecchmatrix[8][165]^sbits[8] |
         ecchmatrix[7][165]^sbits[7] |
         ecchmatrix[6][165]^sbits[6] |
         ecchmatrix[5][165]^sbits[5] |
         ecchmatrix[4][165]^sbits[4] |
         ecchmatrix[3][165]^sbits[3] |
         ecchmatrix[2][165]^sbits[2] |
         ecchmatrix[1][165]^sbits[1] |
         ecchmatrix[0][165]^sbits[0]);
  assign biterr_wire[164] = ~(
         ecchmatrix[8][164]^sbits[8] |
         ecchmatrix[7][164]^sbits[7] |
         ecchmatrix[6][164]^sbits[6] |
         ecchmatrix[5][164]^sbits[5] |
         ecchmatrix[4][164]^sbits[4] |
         ecchmatrix[3][164]^sbits[3] |
         ecchmatrix[2][164]^sbits[2] |
         ecchmatrix[1][164]^sbits[1] |
         ecchmatrix[0][164]^sbits[0]);
  assign biterr_wire[163] = ~(
         ecchmatrix[8][163]^sbits[8] |
         ecchmatrix[7][163]^sbits[7] |
         ecchmatrix[6][163]^sbits[6] |
         ecchmatrix[5][163]^sbits[5] |
         ecchmatrix[4][163]^sbits[4] |
         ecchmatrix[3][163]^sbits[3] |
         ecchmatrix[2][163]^sbits[2] |
         ecchmatrix[1][163]^sbits[1] |
         ecchmatrix[0][163]^sbits[0]);
  assign biterr_wire[162] = ~(
         ecchmatrix[8][162]^sbits[8] |
         ecchmatrix[7][162]^sbits[7] |
         ecchmatrix[6][162]^sbits[6] |
         ecchmatrix[5][162]^sbits[5] |
         ecchmatrix[4][162]^sbits[4] |
         ecchmatrix[3][162]^sbits[3] |
         ecchmatrix[2][162]^sbits[2] |
         ecchmatrix[1][162]^sbits[1] |
         ecchmatrix[0][162]^sbits[0]);
  assign biterr_wire[161] = ~(
         ecchmatrix[8][161]^sbits[8] |
         ecchmatrix[7][161]^sbits[7] |
         ecchmatrix[6][161]^sbits[6] |
         ecchmatrix[5][161]^sbits[5] |
         ecchmatrix[4][161]^sbits[4] |
         ecchmatrix[3][161]^sbits[3] |
         ecchmatrix[2][161]^sbits[2] |
         ecchmatrix[1][161]^sbits[1] |
         ecchmatrix[0][161]^sbits[0]);
  assign biterr_wire[160] = ~(
         ecchmatrix[8][160]^sbits[8] |
         ecchmatrix[7][160]^sbits[7] |
         ecchmatrix[6][160]^sbits[6] |
         ecchmatrix[5][160]^sbits[5] |
         ecchmatrix[4][160]^sbits[4] |
         ecchmatrix[3][160]^sbits[3] |
         ecchmatrix[2][160]^sbits[2] |
         ecchmatrix[1][160]^sbits[1] |
         ecchmatrix[0][160]^sbits[0]);
  assign biterr_wire[159] = ~(
         ecchmatrix[8][159]^sbits[8] |
         ecchmatrix[7][159]^sbits[7] |
         ecchmatrix[6][159]^sbits[6] |
         ecchmatrix[5][159]^sbits[5] |
         ecchmatrix[4][159]^sbits[4] |
         ecchmatrix[3][159]^sbits[3] |
         ecchmatrix[2][159]^sbits[2] |
         ecchmatrix[1][159]^sbits[1] |
         ecchmatrix[0][159]^sbits[0]);
  assign biterr_wire[158] = ~(
         ecchmatrix[8][158]^sbits[8] |
         ecchmatrix[7][158]^sbits[7] |
         ecchmatrix[6][158]^sbits[6] |
         ecchmatrix[5][158]^sbits[5] |
         ecchmatrix[4][158]^sbits[4] |
         ecchmatrix[3][158]^sbits[3] |
         ecchmatrix[2][158]^sbits[2] |
         ecchmatrix[1][158]^sbits[1] |
         ecchmatrix[0][158]^sbits[0]);
  assign biterr_wire[157] = ~(
         ecchmatrix[8][157]^sbits[8] |
         ecchmatrix[7][157]^sbits[7] |
         ecchmatrix[6][157]^sbits[6] |
         ecchmatrix[5][157]^sbits[5] |
         ecchmatrix[4][157]^sbits[4] |
         ecchmatrix[3][157]^sbits[3] |
         ecchmatrix[2][157]^sbits[2] |
         ecchmatrix[1][157]^sbits[1] |
         ecchmatrix[0][157]^sbits[0]);
  assign biterr_wire[156] = ~(
         ecchmatrix[8][156]^sbits[8] |
         ecchmatrix[7][156]^sbits[7] |
         ecchmatrix[6][156]^sbits[6] |
         ecchmatrix[5][156]^sbits[5] |
         ecchmatrix[4][156]^sbits[4] |
         ecchmatrix[3][156]^sbits[3] |
         ecchmatrix[2][156]^sbits[2] |
         ecchmatrix[1][156]^sbits[1] |
         ecchmatrix[0][156]^sbits[0]);
  assign biterr_wire[155] = ~(
         ecchmatrix[8][155]^sbits[8] |
         ecchmatrix[7][155]^sbits[7] |
         ecchmatrix[6][155]^sbits[6] |
         ecchmatrix[5][155]^sbits[5] |
         ecchmatrix[4][155]^sbits[4] |
         ecchmatrix[3][155]^sbits[3] |
         ecchmatrix[2][155]^sbits[2] |
         ecchmatrix[1][155]^sbits[1] |
         ecchmatrix[0][155]^sbits[0]);
  assign biterr_wire[154] = ~(
         ecchmatrix[8][154]^sbits[8] |
         ecchmatrix[7][154]^sbits[7] |
         ecchmatrix[6][154]^sbits[6] |
         ecchmatrix[5][154]^sbits[5] |
         ecchmatrix[4][154]^sbits[4] |
         ecchmatrix[3][154]^sbits[3] |
         ecchmatrix[2][154]^sbits[2] |
         ecchmatrix[1][154]^sbits[1] |
         ecchmatrix[0][154]^sbits[0]);
  assign biterr_wire[153] = ~(
         ecchmatrix[8][153]^sbits[8] |
         ecchmatrix[7][153]^sbits[7] |
         ecchmatrix[6][153]^sbits[6] |
         ecchmatrix[5][153]^sbits[5] |
         ecchmatrix[4][153]^sbits[4] |
         ecchmatrix[3][153]^sbits[3] |
         ecchmatrix[2][153]^sbits[2] |
         ecchmatrix[1][153]^sbits[1] |
         ecchmatrix[0][153]^sbits[0]);
  assign biterr_wire[152] = ~(
         ecchmatrix[8][152]^sbits[8] |
         ecchmatrix[7][152]^sbits[7] |
         ecchmatrix[6][152]^sbits[6] |
         ecchmatrix[5][152]^sbits[5] |
         ecchmatrix[4][152]^sbits[4] |
         ecchmatrix[3][152]^sbits[3] |
         ecchmatrix[2][152]^sbits[2] |
         ecchmatrix[1][152]^sbits[1] |
         ecchmatrix[0][152]^sbits[0]);
  assign biterr_wire[151] = ~(
         ecchmatrix[8][151]^sbits[8] |
         ecchmatrix[7][151]^sbits[7] |
         ecchmatrix[6][151]^sbits[6] |
         ecchmatrix[5][151]^sbits[5] |
         ecchmatrix[4][151]^sbits[4] |
         ecchmatrix[3][151]^sbits[3] |
         ecchmatrix[2][151]^sbits[2] |
         ecchmatrix[1][151]^sbits[1] |
         ecchmatrix[0][151]^sbits[0]);
  assign biterr_wire[150] = ~(
         ecchmatrix[8][150]^sbits[8] |
         ecchmatrix[7][150]^sbits[7] |
         ecchmatrix[6][150]^sbits[6] |
         ecchmatrix[5][150]^sbits[5] |
         ecchmatrix[4][150]^sbits[4] |
         ecchmatrix[3][150]^sbits[3] |
         ecchmatrix[2][150]^sbits[2] |
         ecchmatrix[1][150]^sbits[1] |
         ecchmatrix[0][150]^sbits[0]);
  assign biterr_wire[149] = ~(
         ecchmatrix[8][149]^sbits[8] |
         ecchmatrix[7][149]^sbits[7] |
         ecchmatrix[6][149]^sbits[6] |
         ecchmatrix[5][149]^sbits[5] |
         ecchmatrix[4][149]^sbits[4] |
         ecchmatrix[3][149]^sbits[3] |
         ecchmatrix[2][149]^sbits[2] |
         ecchmatrix[1][149]^sbits[1] |
         ecchmatrix[0][149]^sbits[0]);
  assign biterr_wire[148] = ~(
         ecchmatrix[8][148]^sbits[8] |
         ecchmatrix[7][148]^sbits[7] |
         ecchmatrix[6][148]^sbits[6] |
         ecchmatrix[5][148]^sbits[5] |
         ecchmatrix[4][148]^sbits[4] |
         ecchmatrix[3][148]^sbits[3] |
         ecchmatrix[2][148]^sbits[2] |
         ecchmatrix[1][148]^sbits[1] |
         ecchmatrix[0][148]^sbits[0]);
  assign biterr_wire[147] = ~(
         ecchmatrix[8][147]^sbits[8] |
         ecchmatrix[7][147]^sbits[7] |
         ecchmatrix[6][147]^sbits[6] |
         ecchmatrix[5][147]^sbits[5] |
         ecchmatrix[4][147]^sbits[4] |
         ecchmatrix[3][147]^sbits[3] |
         ecchmatrix[2][147]^sbits[2] |
         ecchmatrix[1][147]^sbits[1] |
         ecchmatrix[0][147]^sbits[0]);
  assign biterr_wire[146] = ~(
         ecchmatrix[8][146]^sbits[8] |
         ecchmatrix[7][146]^sbits[7] |
         ecchmatrix[6][146]^sbits[6] |
         ecchmatrix[5][146]^sbits[5] |
         ecchmatrix[4][146]^sbits[4] |
         ecchmatrix[3][146]^sbits[3] |
         ecchmatrix[2][146]^sbits[2] |
         ecchmatrix[1][146]^sbits[1] |
         ecchmatrix[0][146]^sbits[0]);
  assign biterr_wire[145] = ~(
         ecchmatrix[8][145]^sbits[8] |
         ecchmatrix[7][145]^sbits[7] |
         ecchmatrix[6][145]^sbits[6] |
         ecchmatrix[5][145]^sbits[5] |
         ecchmatrix[4][145]^sbits[4] |
         ecchmatrix[3][145]^sbits[3] |
         ecchmatrix[2][145]^sbits[2] |
         ecchmatrix[1][145]^sbits[1] |
         ecchmatrix[0][145]^sbits[0]);
  assign biterr_wire[144] = ~(
         ecchmatrix[8][144]^sbits[8] |
         ecchmatrix[7][144]^sbits[7] |
         ecchmatrix[6][144]^sbits[6] |
         ecchmatrix[5][144]^sbits[5] |
         ecchmatrix[4][144]^sbits[4] |
         ecchmatrix[3][144]^sbits[3] |
         ecchmatrix[2][144]^sbits[2] |
         ecchmatrix[1][144]^sbits[1] |
         ecchmatrix[0][144]^sbits[0]);
  assign biterr_wire[143] = ~(
         ecchmatrix[8][143]^sbits[8] |
         ecchmatrix[7][143]^sbits[7] |
         ecchmatrix[6][143]^sbits[6] |
         ecchmatrix[5][143]^sbits[5] |
         ecchmatrix[4][143]^sbits[4] |
         ecchmatrix[3][143]^sbits[3] |
         ecchmatrix[2][143]^sbits[2] |
         ecchmatrix[1][143]^sbits[1] |
         ecchmatrix[0][143]^sbits[0]);
  assign biterr_wire[142] = ~(
         ecchmatrix[8][142]^sbits[8] |
         ecchmatrix[7][142]^sbits[7] |
         ecchmatrix[6][142]^sbits[6] |
         ecchmatrix[5][142]^sbits[5] |
         ecchmatrix[4][142]^sbits[4] |
         ecchmatrix[3][142]^sbits[3] |
         ecchmatrix[2][142]^sbits[2] |
         ecchmatrix[1][142]^sbits[1] |
         ecchmatrix[0][142]^sbits[0]);
  assign biterr_wire[141] = ~(
         ecchmatrix[8][141]^sbits[8] |
         ecchmatrix[7][141]^sbits[7] |
         ecchmatrix[6][141]^sbits[6] |
         ecchmatrix[5][141]^sbits[5] |
         ecchmatrix[4][141]^sbits[4] |
         ecchmatrix[3][141]^sbits[3] |
         ecchmatrix[2][141]^sbits[2] |
         ecchmatrix[1][141]^sbits[1] |
         ecchmatrix[0][141]^sbits[0]);
  assign biterr_wire[140] = ~(
         ecchmatrix[8][140]^sbits[8] |
         ecchmatrix[7][140]^sbits[7] |
         ecchmatrix[6][140]^sbits[6] |
         ecchmatrix[5][140]^sbits[5] |
         ecchmatrix[4][140]^sbits[4] |
         ecchmatrix[3][140]^sbits[3] |
         ecchmatrix[2][140]^sbits[2] |
         ecchmatrix[1][140]^sbits[1] |
         ecchmatrix[0][140]^sbits[0]);
  assign biterr_wire[139] = ~(
         ecchmatrix[8][139]^sbits[8] |
         ecchmatrix[7][139]^sbits[7] |
         ecchmatrix[6][139]^sbits[6] |
         ecchmatrix[5][139]^sbits[5] |
         ecchmatrix[4][139]^sbits[4] |
         ecchmatrix[3][139]^sbits[3] |
         ecchmatrix[2][139]^sbits[2] |
         ecchmatrix[1][139]^sbits[1] |
         ecchmatrix[0][139]^sbits[0]);
  assign biterr_wire[138] = ~(
         ecchmatrix[8][138]^sbits[8] |
         ecchmatrix[7][138]^sbits[7] |
         ecchmatrix[6][138]^sbits[6] |
         ecchmatrix[5][138]^sbits[5] |
         ecchmatrix[4][138]^sbits[4] |
         ecchmatrix[3][138]^sbits[3] |
         ecchmatrix[2][138]^sbits[2] |
         ecchmatrix[1][138]^sbits[1] |
         ecchmatrix[0][138]^sbits[0]);
  assign biterr_wire[137] = ~(
         ecchmatrix[8][137]^sbits[8] |
         ecchmatrix[7][137]^sbits[7] |
         ecchmatrix[6][137]^sbits[6] |
         ecchmatrix[5][137]^sbits[5] |
         ecchmatrix[4][137]^sbits[4] |
         ecchmatrix[3][137]^sbits[3] |
         ecchmatrix[2][137]^sbits[2] |
         ecchmatrix[1][137]^sbits[1] |
         ecchmatrix[0][137]^sbits[0]);
  assign biterr_wire[136] = ~(
         ecchmatrix[8][136]^sbits[8] |
         ecchmatrix[7][136]^sbits[7] |
         ecchmatrix[6][136]^sbits[6] |
         ecchmatrix[5][136]^sbits[5] |
         ecchmatrix[4][136]^sbits[4] |
         ecchmatrix[3][136]^sbits[3] |
         ecchmatrix[2][136]^sbits[2] |
         ecchmatrix[1][136]^sbits[1] |
         ecchmatrix[0][136]^sbits[0]);
  assign biterr_wire[135] = ~(
         ecchmatrix[8][135]^sbits[8] |
         ecchmatrix[7][135]^sbits[7] |
         ecchmatrix[6][135]^sbits[6] |
         ecchmatrix[5][135]^sbits[5] |
         ecchmatrix[4][135]^sbits[4] |
         ecchmatrix[3][135]^sbits[3] |
         ecchmatrix[2][135]^sbits[2] |
         ecchmatrix[1][135]^sbits[1] |
         ecchmatrix[0][135]^sbits[0]);
  assign biterr_wire[134] = ~(
         ecchmatrix[8][134]^sbits[8] |
         ecchmatrix[7][134]^sbits[7] |
         ecchmatrix[6][134]^sbits[6] |
         ecchmatrix[5][134]^sbits[5] |
         ecchmatrix[4][134]^sbits[4] |
         ecchmatrix[3][134]^sbits[3] |
         ecchmatrix[2][134]^sbits[2] |
         ecchmatrix[1][134]^sbits[1] |
         ecchmatrix[0][134]^sbits[0]);
  assign biterr_wire[133] = ~(
         ecchmatrix[8][133]^sbits[8] |
         ecchmatrix[7][133]^sbits[7] |
         ecchmatrix[6][133]^sbits[6] |
         ecchmatrix[5][133]^sbits[5] |
         ecchmatrix[4][133]^sbits[4] |
         ecchmatrix[3][133]^sbits[3] |
         ecchmatrix[2][133]^sbits[2] |
         ecchmatrix[1][133]^sbits[1] |
         ecchmatrix[0][133]^sbits[0]);
  assign biterr_wire[132] = ~(
         ecchmatrix[8][132]^sbits[8] |
         ecchmatrix[7][132]^sbits[7] |
         ecchmatrix[6][132]^sbits[6] |
         ecchmatrix[5][132]^sbits[5] |
         ecchmatrix[4][132]^sbits[4] |
         ecchmatrix[3][132]^sbits[3] |
         ecchmatrix[2][132]^sbits[2] |
         ecchmatrix[1][132]^sbits[1] |
         ecchmatrix[0][132]^sbits[0]);
  assign biterr_wire[131] = ~(
         ecchmatrix[8][131]^sbits[8] |
         ecchmatrix[7][131]^sbits[7] |
         ecchmatrix[6][131]^sbits[6] |
         ecchmatrix[5][131]^sbits[5] |
         ecchmatrix[4][131]^sbits[4] |
         ecchmatrix[3][131]^sbits[3] |
         ecchmatrix[2][131]^sbits[2] |
         ecchmatrix[1][131]^sbits[1] |
         ecchmatrix[0][131]^sbits[0]);
  assign biterr_wire[130] = ~(
         ecchmatrix[8][130]^sbits[8] |
         ecchmatrix[7][130]^sbits[7] |
         ecchmatrix[6][130]^sbits[6] |
         ecchmatrix[5][130]^sbits[5] |
         ecchmatrix[4][130]^sbits[4] |
         ecchmatrix[3][130]^sbits[3] |
         ecchmatrix[2][130]^sbits[2] |
         ecchmatrix[1][130]^sbits[1] |
         ecchmatrix[0][130]^sbits[0]);
  assign biterr_wire[129] = ~(
         ecchmatrix[8][129]^sbits[8] |
         ecchmatrix[7][129]^sbits[7] |
         ecchmatrix[6][129]^sbits[6] |
         ecchmatrix[5][129]^sbits[5] |
         ecchmatrix[4][129]^sbits[4] |
         ecchmatrix[3][129]^sbits[3] |
         ecchmatrix[2][129]^sbits[2] |
         ecchmatrix[1][129]^sbits[1] |
         ecchmatrix[0][129]^sbits[0]);
  assign biterr_wire[128] = ~(
         ecchmatrix[8][128]^sbits[8] |
         ecchmatrix[7][128]^sbits[7] |
         ecchmatrix[6][128]^sbits[6] |
         ecchmatrix[5][128]^sbits[5] |
         ecchmatrix[4][128]^sbits[4] |
         ecchmatrix[3][128]^sbits[3] |
         ecchmatrix[2][128]^sbits[2] |
         ecchmatrix[1][128]^sbits[1] |
         ecchmatrix[0][128]^sbits[0]);
  assign biterr_wire[127] = ~(
         ecchmatrix[8][127]^sbits[8] |
         ecchmatrix[7][127]^sbits[7] |
         ecchmatrix[6][127]^sbits[6] |
         ecchmatrix[5][127]^sbits[5] |
         ecchmatrix[4][127]^sbits[4] |
         ecchmatrix[3][127]^sbits[3] |
         ecchmatrix[2][127]^sbits[2] |
         ecchmatrix[1][127]^sbits[1] |
         ecchmatrix[0][127]^sbits[0]);
  assign biterr_wire[126] = ~(
         ecchmatrix[8][126]^sbits[8] |
         ecchmatrix[7][126]^sbits[7] |
         ecchmatrix[6][126]^sbits[6] |
         ecchmatrix[5][126]^sbits[5] |
         ecchmatrix[4][126]^sbits[4] |
         ecchmatrix[3][126]^sbits[3] |
         ecchmatrix[2][126]^sbits[2] |
         ecchmatrix[1][126]^sbits[1] |
         ecchmatrix[0][126]^sbits[0]);
  assign biterr_wire[125] = ~(
         ecchmatrix[8][125]^sbits[8] |
         ecchmatrix[7][125]^sbits[7] |
         ecchmatrix[6][125]^sbits[6] |
         ecchmatrix[5][125]^sbits[5] |
         ecchmatrix[4][125]^sbits[4] |
         ecchmatrix[3][125]^sbits[3] |
         ecchmatrix[2][125]^sbits[2] |
         ecchmatrix[1][125]^sbits[1] |
         ecchmatrix[0][125]^sbits[0]);
  assign biterr_wire[124] = ~(
         ecchmatrix[8][124]^sbits[8] |
         ecchmatrix[7][124]^sbits[7] |
         ecchmatrix[6][124]^sbits[6] |
         ecchmatrix[5][124]^sbits[5] |
         ecchmatrix[4][124]^sbits[4] |
         ecchmatrix[3][124]^sbits[3] |
         ecchmatrix[2][124]^sbits[2] |
         ecchmatrix[1][124]^sbits[1] |
         ecchmatrix[0][124]^sbits[0]);
  assign biterr_wire[123] = ~(
         ecchmatrix[8][123]^sbits[8] |
         ecchmatrix[7][123]^sbits[7] |
         ecchmatrix[6][123]^sbits[6] |
         ecchmatrix[5][123]^sbits[5] |
         ecchmatrix[4][123]^sbits[4] |
         ecchmatrix[3][123]^sbits[3] |
         ecchmatrix[2][123]^sbits[2] |
         ecchmatrix[1][123]^sbits[1] |
         ecchmatrix[0][123]^sbits[0]);
  assign biterr_wire[122] = ~(
         ecchmatrix[8][122]^sbits[8] |
         ecchmatrix[7][122]^sbits[7] |
         ecchmatrix[6][122]^sbits[6] |
         ecchmatrix[5][122]^sbits[5] |
         ecchmatrix[4][122]^sbits[4] |
         ecchmatrix[3][122]^sbits[3] |
         ecchmatrix[2][122]^sbits[2] |
         ecchmatrix[1][122]^sbits[1] |
         ecchmatrix[0][122]^sbits[0]);
  assign biterr_wire[121] = ~(
         ecchmatrix[8][121]^sbits[8] |
         ecchmatrix[7][121]^sbits[7] |
         ecchmatrix[6][121]^sbits[6] |
         ecchmatrix[5][121]^sbits[5] |
         ecchmatrix[4][121]^sbits[4] |
         ecchmatrix[3][121]^sbits[3] |
         ecchmatrix[2][121]^sbits[2] |
         ecchmatrix[1][121]^sbits[1] |
         ecchmatrix[0][121]^sbits[0]);
  assign biterr_wire[120] = ~(
         ecchmatrix[8][120]^sbits[8] |
         ecchmatrix[7][120]^sbits[7] |
         ecchmatrix[6][120]^sbits[6] |
         ecchmatrix[5][120]^sbits[5] |
         ecchmatrix[4][120]^sbits[4] |
         ecchmatrix[3][120]^sbits[3] |
         ecchmatrix[2][120]^sbits[2] |
         ecchmatrix[1][120]^sbits[1] |
         ecchmatrix[0][120]^sbits[0]);
  assign biterr_wire[119] = ~(
         ecchmatrix[8][119]^sbits[8] |
         ecchmatrix[7][119]^sbits[7] |
         ecchmatrix[6][119]^sbits[6] |
         ecchmatrix[5][119]^sbits[5] |
         ecchmatrix[4][119]^sbits[4] |
         ecchmatrix[3][119]^sbits[3] |
         ecchmatrix[2][119]^sbits[2] |
         ecchmatrix[1][119]^sbits[1] |
         ecchmatrix[0][119]^sbits[0]);
  assign biterr_wire[118] = ~(
         ecchmatrix[8][118]^sbits[8] |
         ecchmatrix[7][118]^sbits[7] |
         ecchmatrix[6][118]^sbits[6] |
         ecchmatrix[5][118]^sbits[5] |
         ecchmatrix[4][118]^sbits[4] |
         ecchmatrix[3][118]^sbits[3] |
         ecchmatrix[2][118]^sbits[2] |
         ecchmatrix[1][118]^sbits[1] |
         ecchmatrix[0][118]^sbits[0]);
  assign biterr_wire[117] = ~(
         ecchmatrix[8][117]^sbits[8] |
         ecchmatrix[7][117]^sbits[7] |
         ecchmatrix[6][117]^sbits[6] |
         ecchmatrix[5][117]^sbits[5] |
         ecchmatrix[4][117]^sbits[4] |
         ecchmatrix[3][117]^sbits[3] |
         ecchmatrix[2][117]^sbits[2] |
         ecchmatrix[1][117]^sbits[1] |
         ecchmatrix[0][117]^sbits[0]);
  assign biterr_wire[116] = ~(
         ecchmatrix[8][116]^sbits[8] |
         ecchmatrix[7][116]^sbits[7] |
         ecchmatrix[6][116]^sbits[6] |
         ecchmatrix[5][116]^sbits[5] |
         ecchmatrix[4][116]^sbits[4] |
         ecchmatrix[3][116]^sbits[3] |
         ecchmatrix[2][116]^sbits[2] |
         ecchmatrix[1][116]^sbits[1] |
         ecchmatrix[0][116]^sbits[0]);
  assign biterr_wire[115] = ~(
         ecchmatrix[8][115]^sbits[8] |
         ecchmatrix[7][115]^sbits[7] |
         ecchmatrix[6][115]^sbits[6] |
         ecchmatrix[5][115]^sbits[5] |
         ecchmatrix[4][115]^sbits[4] |
         ecchmatrix[3][115]^sbits[3] |
         ecchmatrix[2][115]^sbits[2] |
         ecchmatrix[1][115]^sbits[1] |
         ecchmatrix[0][115]^sbits[0]);
  assign biterr_wire[114] = ~(
         ecchmatrix[8][114]^sbits[8] |
         ecchmatrix[7][114]^sbits[7] |
         ecchmatrix[6][114]^sbits[6] |
         ecchmatrix[5][114]^sbits[5] |
         ecchmatrix[4][114]^sbits[4] |
         ecchmatrix[3][114]^sbits[3] |
         ecchmatrix[2][114]^sbits[2] |
         ecchmatrix[1][114]^sbits[1] |
         ecchmatrix[0][114]^sbits[0]);
  assign biterr_wire[113] = ~(
         ecchmatrix[8][113]^sbits[8] |
         ecchmatrix[7][113]^sbits[7] |
         ecchmatrix[6][113]^sbits[6] |
         ecchmatrix[5][113]^sbits[5] |
         ecchmatrix[4][113]^sbits[4] |
         ecchmatrix[3][113]^sbits[3] |
         ecchmatrix[2][113]^sbits[2] |
         ecchmatrix[1][113]^sbits[1] |
         ecchmatrix[0][113]^sbits[0]);
  assign biterr_wire[112] = ~(
         ecchmatrix[8][112]^sbits[8] |
         ecchmatrix[7][112]^sbits[7] |
         ecchmatrix[6][112]^sbits[6] |
         ecchmatrix[5][112]^sbits[5] |
         ecchmatrix[4][112]^sbits[4] |
         ecchmatrix[3][112]^sbits[3] |
         ecchmatrix[2][112]^sbits[2] |
         ecchmatrix[1][112]^sbits[1] |
         ecchmatrix[0][112]^sbits[0]);
  assign biterr_wire[111] = ~(
         ecchmatrix[8][111]^sbits[8] |
         ecchmatrix[7][111]^sbits[7] |
         ecchmatrix[6][111]^sbits[6] |
         ecchmatrix[5][111]^sbits[5] |
         ecchmatrix[4][111]^sbits[4] |
         ecchmatrix[3][111]^sbits[3] |
         ecchmatrix[2][111]^sbits[2] |
         ecchmatrix[1][111]^sbits[1] |
         ecchmatrix[0][111]^sbits[0]);
  assign biterr_wire[110] = ~(
         ecchmatrix[8][110]^sbits[8] |
         ecchmatrix[7][110]^sbits[7] |
         ecchmatrix[6][110]^sbits[6] |
         ecchmatrix[5][110]^sbits[5] |
         ecchmatrix[4][110]^sbits[4] |
         ecchmatrix[3][110]^sbits[3] |
         ecchmatrix[2][110]^sbits[2] |
         ecchmatrix[1][110]^sbits[1] |
         ecchmatrix[0][110]^sbits[0]);
  assign biterr_wire[109] = ~(
         ecchmatrix[8][109]^sbits[8] |
         ecchmatrix[7][109]^sbits[7] |
         ecchmatrix[6][109]^sbits[6] |
         ecchmatrix[5][109]^sbits[5] |
         ecchmatrix[4][109]^sbits[4] |
         ecchmatrix[3][109]^sbits[3] |
         ecchmatrix[2][109]^sbits[2] |
         ecchmatrix[1][109]^sbits[1] |
         ecchmatrix[0][109]^sbits[0]);
  assign biterr_wire[108] = ~(
         ecchmatrix[8][108]^sbits[8] |
         ecchmatrix[7][108]^sbits[7] |
         ecchmatrix[6][108]^sbits[6] |
         ecchmatrix[5][108]^sbits[5] |
         ecchmatrix[4][108]^sbits[4] |
         ecchmatrix[3][108]^sbits[3] |
         ecchmatrix[2][108]^sbits[2] |
         ecchmatrix[1][108]^sbits[1] |
         ecchmatrix[0][108]^sbits[0]);
  assign biterr_wire[107] = ~(
         ecchmatrix[8][107]^sbits[8] |
         ecchmatrix[7][107]^sbits[7] |
         ecchmatrix[6][107]^sbits[6] |
         ecchmatrix[5][107]^sbits[5] |
         ecchmatrix[4][107]^sbits[4] |
         ecchmatrix[3][107]^sbits[3] |
         ecchmatrix[2][107]^sbits[2] |
         ecchmatrix[1][107]^sbits[1] |
         ecchmatrix[0][107]^sbits[0]);
  assign biterr_wire[106] = ~(
         ecchmatrix[8][106]^sbits[8] |
         ecchmatrix[7][106]^sbits[7] |
         ecchmatrix[6][106]^sbits[6] |
         ecchmatrix[5][106]^sbits[5] |
         ecchmatrix[4][106]^sbits[4] |
         ecchmatrix[3][106]^sbits[3] |
         ecchmatrix[2][106]^sbits[2] |
         ecchmatrix[1][106]^sbits[1] |
         ecchmatrix[0][106]^sbits[0]);
  assign biterr_wire[105] = ~(
         ecchmatrix[8][105]^sbits[8] |
         ecchmatrix[7][105]^sbits[7] |
         ecchmatrix[6][105]^sbits[6] |
         ecchmatrix[5][105]^sbits[5] |
         ecchmatrix[4][105]^sbits[4] |
         ecchmatrix[3][105]^sbits[3] |
         ecchmatrix[2][105]^sbits[2] |
         ecchmatrix[1][105]^sbits[1] |
         ecchmatrix[0][105]^sbits[0]);
  assign biterr_wire[104] = ~(
         ecchmatrix[8][104]^sbits[8] |
         ecchmatrix[7][104]^sbits[7] |
         ecchmatrix[6][104]^sbits[6] |
         ecchmatrix[5][104]^sbits[5] |
         ecchmatrix[4][104]^sbits[4] |
         ecchmatrix[3][104]^sbits[3] |
         ecchmatrix[2][104]^sbits[2] |
         ecchmatrix[1][104]^sbits[1] |
         ecchmatrix[0][104]^sbits[0]);
  assign biterr_wire[103] = ~(
         ecchmatrix[8][103]^sbits[8] |
         ecchmatrix[7][103]^sbits[7] |
         ecchmatrix[6][103]^sbits[6] |
         ecchmatrix[5][103]^sbits[5] |
         ecchmatrix[4][103]^sbits[4] |
         ecchmatrix[3][103]^sbits[3] |
         ecchmatrix[2][103]^sbits[2] |
         ecchmatrix[1][103]^sbits[1] |
         ecchmatrix[0][103]^sbits[0]);
  assign biterr_wire[102] = ~(
         ecchmatrix[8][102]^sbits[8] |
         ecchmatrix[7][102]^sbits[7] |
         ecchmatrix[6][102]^sbits[6] |
         ecchmatrix[5][102]^sbits[5] |
         ecchmatrix[4][102]^sbits[4] |
         ecchmatrix[3][102]^sbits[3] |
         ecchmatrix[2][102]^sbits[2] |
         ecchmatrix[1][102]^sbits[1] |
         ecchmatrix[0][102]^sbits[0]);
  assign biterr_wire[101] = ~(
         ecchmatrix[8][101]^sbits[8] |
         ecchmatrix[7][101]^sbits[7] |
         ecchmatrix[6][101]^sbits[6] |
         ecchmatrix[5][101]^sbits[5] |
         ecchmatrix[4][101]^sbits[4] |
         ecchmatrix[3][101]^sbits[3] |
         ecchmatrix[2][101]^sbits[2] |
         ecchmatrix[1][101]^sbits[1] |
         ecchmatrix[0][101]^sbits[0]);
  assign biterr_wire[100] = ~(
         ecchmatrix[8][100]^sbits[8] |
         ecchmatrix[7][100]^sbits[7] |
         ecchmatrix[6][100]^sbits[6] |
         ecchmatrix[5][100]^sbits[5] |
         ecchmatrix[4][100]^sbits[4] |
         ecchmatrix[3][100]^sbits[3] |
         ecchmatrix[2][100]^sbits[2] |
         ecchmatrix[1][100]^sbits[1] |
         ecchmatrix[0][100]^sbits[0]);
  assign biterr_wire[99] = ~(
         ecchmatrix[8][99]^sbits[8] |
         ecchmatrix[7][99]^sbits[7] |
         ecchmatrix[6][99]^sbits[6] |
         ecchmatrix[5][99]^sbits[5] |
         ecchmatrix[4][99]^sbits[4] |
         ecchmatrix[3][99]^sbits[3] |
         ecchmatrix[2][99]^sbits[2] |
         ecchmatrix[1][99]^sbits[1] |
         ecchmatrix[0][99]^sbits[0]);
  assign biterr_wire[98] = ~(
         ecchmatrix[8][98]^sbits[8] |
         ecchmatrix[7][98]^sbits[7] |
         ecchmatrix[6][98]^sbits[6] |
         ecchmatrix[5][98]^sbits[5] |
         ecchmatrix[4][98]^sbits[4] |
         ecchmatrix[3][98]^sbits[3] |
         ecchmatrix[2][98]^sbits[2] |
         ecchmatrix[1][98]^sbits[1] |
         ecchmatrix[0][98]^sbits[0]);
  assign biterr_wire[97] = ~(
         ecchmatrix[8][97]^sbits[8] |
         ecchmatrix[7][97]^sbits[7] |
         ecchmatrix[6][97]^sbits[6] |
         ecchmatrix[5][97]^sbits[5] |
         ecchmatrix[4][97]^sbits[4] |
         ecchmatrix[3][97]^sbits[3] |
         ecchmatrix[2][97]^sbits[2] |
         ecchmatrix[1][97]^sbits[1] |
         ecchmatrix[0][97]^sbits[0]);
  assign biterr_wire[96] = ~(
         ecchmatrix[8][96]^sbits[8] |
         ecchmatrix[7][96]^sbits[7] |
         ecchmatrix[6][96]^sbits[6] |
         ecchmatrix[5][96]^sbits[5] |
         ecchmatrix[4][96]^sbits[4] |
         ecchmatrix[3][96]^sbits[3] |
         ecchmatrix[2][96]^sbits[2] |
         ecchmatrix[1][96]^sbits[1] |
         ecchmatrix[0][96]^sbits[0]);
  assign biterr_wire[95] = ~(
         ecchmatrix[8][95]^sbits[8] |
         ecchmatrix[7][95]^sbits[7] |
         ecchmatrix[6][95]^sbits[6] |
         ecchmatrix[5][95]^sbits[5] |
         ecchmatrix[4][95]^sbits[4] |
         ecchmatrix[3][95]^sbits[3] |
         ecchmatrix[2][95]^sbits[2] |
         ecchmatrix[1][95]^sbits[1] |
         ecchmatrix[0][95]^sbits[0]);
  assign biterr_wire[94] = ~(
         ecchmatrix[8][94]^sbits[8] |
         ecchmatrix[7][94]^sbits[7] |
         ecchmatrix[6][94]^sbits[6] |
         ecchmatrix[5][94]^sbits[5] |
         ecchmatrix[4][94]^sbits[4] |
         ecchmatrix[3][94]^sbits[3] |
         ecchmatrix[2][94]^sbits[2] |
         ecchmatrix[1][94]^sbits[1] |
         ecchmatrix[0][94]^sbits[0]);
  assign biterr_wire[93] = ~(
         ecchmatrix[8][93]^sbits[8] |
         ecchmatrix[7][93]^sbits[7] |
         ecchmatrix[6][93]^sbits[6] |
         ecchmatrix[5][93]^sbits[5] |
         ecchmatrix[4][93]^sbits[4] |
         ecchmatrix[3][93]^sbits[3] |
         ecchmatrix[2][93]^sbits[2] |
         ecchmatrix[1][93]^sbits[1] |
         ecchmatrix[0][93]^sbits[0]);
  assign biterr_wire[92] = ~(
         ecchmatrix[8][92]^sbits[8] |
         ecchmatrix[7][92]^sbits[7] |
         ecchmatrix[6][92]^sbits[6] |
         ecchmatrix[5][92]^sbits[5] |
         ecchmatrix[4][92]^sbits[4] |
         ecchmatrix[3][92]^sbits[3] |
         ecchmatrix[2][92]^sbits[2] |
         ecchmatrix[1][92]^sbits[1] |
         ecchmatrix[0][92]^sbits[0]);
  assign biterr_wire[91] = ~(
         ecchmatrix[8][91]^sbits[8] |
         ecchmatrix[7][91]^sbits[7] |
         ecchmatrix[6][91]^sbits[6] |
         ecchmatrix[5][91]^sbits[5] |
         ecchmatrix[4][91]^sbits[4] |
         ecchmatrix[3][91]^sbits[3] |
         ecchmatrix[2][91]^sbits[2] |
         ecchmatrix[1][91]^sbits[1] |
         ecchmatrix[0][91]^sbits[0]);
  assign biterr_wire[90] = ~(
         ecchmatrix[8][90]^sbits[8] |
         ecchmatrix[7][90]^sbits[7] |
         ecchmatrix[6][90]^sbits[6] |
         ecchmatrix[5][90]^sbits[5] |
         ecchmatrix[4][90]^sbits[4] |
         ecchmatrix[3][90]^sbits[3] |
         ecchmatrix[2][90]^sbits[2] |
         ecchmatrix[1][90]^sbits[1] |
         ecchmatrix[0][90]^sbits[0]);
  assign biterr_wire[89] = ~(
         ecchmatrix[8][89]^sbits[8] |
         ecchmatrix[7][89]^sbits[7] |
         ecchmatrix[6][89]^sbits[6] |
         ecchmatrix[5][89]^sbits[5] |
         ecchmatrix[4][89]^sbits[4] |
         ecchmatrix[3][89]^sbits[3] |
         ecchmatrix[2][89]^sbits[2] |
         ecchmatrix[1][89]^sbits[1] |
         ecchmatrix[0][89]^sbits[0]);
  assign biterr_wire[88] = ~(
         ecchmatrix[8][88]^sbits[8] |
         ecchmatrix[7][88]^sbits[7] |
         ecchmatrix[6][88]^sbits[6] |
         ecchmatrix[5][88]^sbits[5] |
         ecchmatrix[4][88]^sbits[4] |
         ecchmatrix[3][88]^sbits[3] |
         ecchmatrix[2][88]^sbits[2] |
         ecchmatrix[1][88]^sbits[1] |
         ecchmatrix[0][88]^sbits[0]);
  assign biterr_wire[87] = ~(
         ecchmatrix[8][87]^sbits[8] |
         ecchmatrix[7][87]^sbits[7] |
         ecchmatrix[6][87]^sbits[6] |
         ecchmatrix[5][87]^sbits[5] |
         ecchmatrix[4][87]^sbits[4] |
         ecchmatrix[3][87]^sbits[3] |
         ecchmatrix[2][87]^sbits[2] |
         ecchmatrix[1][87]^sbits[1] |
         ecchmatrix[0][87]^sbits[0]);
  assign biterr_wire[86] = ~(
         ecchmatrix[8][86]^sbits[8] |
         ecchmatrix[7][86]^sbits[7] |
         ecchmatrix[6][86]^sbits[6] |
         ecchmatrix[5][86]^sbits[5] |
         ecchmatrix[4][86]^sbits[4] |
         ecchmatrix[3][86]^sbits[3] |
         ecchmatrix[2][86]^sbits[2] |
         ecchmatrix[1][86]^sbits[1] |
         ecchmatrix[0][86]^sbits[0]);
  assign biterr_wire[85] = ~(
         ecchmatrix[8][85]^sbits[8] |
         ecchmatrix[7][85]^sbits[7] |
         ecchmatrix[6][85]^sbits[6] |
         ecchmatrix[5][85]^sbits[5] |
         ecchmatrix[4][85]^sbits[4] |
         ecchmatrix[3][85]^sbits[3] |
         ecchmatrix[2][85]^sbits[2] |
         ecchmatrix[1][85]^sbits[1] |
         ecchmatrix[0][85]^sbits[0]);
  assign biterr_wire[84] = ~(
         ecchmatrix[8][84]^sbits[8] |
         ecchmatrix[7][84]^sbits[7] |
         ecchmatrix[6][84]^sbits[6] |
         ecchmatrix[5][84]^sbits[5] |
         ecchmatrix[4][84]^sbits[4] |
         ecchmatrix[3][84]^sbits[3] |
         ecchmatrix[2][84]^sbits[2] |
         ecchmatrix[1][84]^sbits[1] |
         ecchmatrix[0][84]^sbits[0]);
  assign biterr_wire[83] = ~(
         ecchmatrix[8][83]^sbits[8] |
         ecchmatrix[7][83]^sbits[7] |
         ecchmatrix[6][83]^sbits[6] |
         ecchmatrix[5][83]^sbits[5] |
         ecchmatrix[4][83]^sbits[4] |
         ecchmatrix[3][83]^sbits[3] |
         ecchmatrix[2][83]^sbits[2] |
         ecchmatrix[1][83]^sbits[1] |
         ecchmatrix[0][83]^sbits[0]);
  assign biterr_wire[82] = ~(
         ecchmatrix[8][82]^sbits[8] |
         ecchmatrix[7][82]^sbits[7] |
         ecchmatrix[6][82]^sbits[6] |
         ecchmatrix[5][82]^sbits[5] |
         ecchmatrix[4][82]^sbits[4] |
         ecchmatrix[3][82]^sbits[3] |
         ecchmatrix[2][82]^sbits[2] |
         ecchmatrix[1][82]^sbits[1] |
         ecchmatrix[0][82]^sbits[0]);
  assign biterr_wire[81] = ~(
         ecchmatrix[8][81]^sbits[8] |
         ecchmatrix[7][81]^sbits[7] |
         ecchmatrix[6][81]^sbits[6] |
         ecchmatrix[5][81]^sbits[5] |
         ecchmatrix[4][81]^sbits[4] |
         ecchmatrix[3][81]^sbits[3] |
         ecchmatrix[2][81]^sbits[2] |
         ecchmatrix[1][81]^sbits[1] |
         ecchmatrix[0][81]^sbits[0]);
  assign biterr_wire[80] = ~(
         ecchmatrix[8][80]^sbits[8] |
         ecchmatrix[7][80]^sbits[7] |
         ecchmatrix[6][80]^sbits[6] |
         ecchmatrix[5][80]^sbits[5] |
         ecchmatrix[4][80]^sbits[4] |
         ecchmatrix[3][80]^sbits[3] |
         ecchmatrix[2][80]^sbits[2] |
         ecchmatrix[1][80]^sbits[1] |
         ecchmatrix[0][80]^sbits[0]);
  assign biterr_wire[79] = ~(
         ecchmatrix[8][79]^sbits[8] |
         ecchmatrix[7][79]^sbits[7] |
         ecchmatrix[6][79]^sbits[6] |
         ecchmatrix[5][79]^sbits[5] |
         ecchmatrix[4][79]^sbits[4] |
         ecchmatrix[3][79]^sbits[3] |
         ecchmatrix[2][79]^sbits[2] |
         ecchmatrix[1][79]^sbits[1] |
         ecchmatrix[0][79]^sbits[0]);
  assign biterr_wire[78] = ~(
         ecchmatrix[8][78]^sbits[8] |
         ecchmatrix[7][78]^sbits[7] |
         ecchmatrix[6][78]^sbits[6] |
         ecchmatrix[5][78]^sbits[5] |
         ecchmatrix[4][78]^sbits[4] |
         ecchmatrix[3][78]^sbits[3] |
         ecchmatrix[2][78]^sbits[2] |
         ecchmatrix[1][78]^sbits[1] |
         ecchmatrix[0][78]^sbits[0]);
  assign biterr_wire[77] = ~(
         ecchmatrix[8][77]^sbits[8] |
         ecchmatrix[7][77]^sbits[7] |
         ecchmatrix[6][77]^sbits[6] |
         ecchmatrix[5][77]^sbits[5] |
         ecchmatrix[4][77]^sbits[4] |
         ecchmatrix[3][77]^sbits[3] |
         ecchmatrix[2][77]^sbits[2] |
         ecchmatrix[1][77]^sbits[1] |
         ecchmatrix[0][77]^sbits[0]);
  assign biterr_wire[76] = ~(
         ecchmatrix[8][76]^sbits[8] |
         ecchmatrix[7][76]^sbits[7] |
         ecchmatrix[6][76]^sbits[6] |
         ecchmatrix[5][76]^sbits[5] |
         ecchmatrix[4][76]^sbits[4] |
         ecchmatrix[3][76]^sbits[3] |
         ecchmatrix[2][76]^sbits[2] |
         ecchmatrix[1][76]^sbits[1] |
         ecchmatrix[0][76]^sbits[0]);
  assign biterr_wire[75] = ~(
         ecchmatrix[8][75]^sbits[8] |
         ecchmatrix[7][75]^sbits[7] |
         ecchmatrix[6][75]^sbits[6] |
         ecchmatrix[5][75]^sbits[5] |
         ecchmatrix[4][75]^sbits[4] |
         ecchmatrix[3][75]^sbits[3] |
         ecchmatrix[2][75]^sbits[2] |
         ecchmatrix[1][75]^sbits[1] |
         ecchmatrix[0][75]^sbits[0]);
  assign biterr_wire[74] = ~(
         ecchmatrix[8][74]^sbits[8] |
         ecchmatrix[7][74]^sbits[7] |
         ecchmatrix[6][74]^sbits[6] |
         ecchmatrix[5][74]^sbits[5] |
         ecchmatrix[4][74]^sbits[4] |
         ecchmatrix[3][74]^sbits[3] |
         ecchmatrix[2][74]^sbits[2] |
         ecchmatrix[1][74]^sbits[1] |
         ecchmatrix[0][74]^sbits[0]);
  assign biterr_wire[73] = ~(
         ecchmatrix[8][73]^sbits[8] |
         ecchmatrix[7][73]^sbits[7] |
         ecchmatrix[6][73]^sbits[6] |
         ecchmatrix[5][73]^sbits[5] |
         ecchmatrix[4][73]^sbits[4] |
         ecchmatrix[3][73]^sbits[3] |
         ecchmatrix[2][73]^sbits[2] |
         ecchmatrix[1][73]^sbits[1] |
         ecchmatrix[0][73]^sbits[0]);
  assign biterr_wire[72] = ~(
         ecchmatrix[8][72]^sbits[8] |
         ecchmatrix[7][72]^sbits[7] |
         ecchmatrix[6][72]^sbits[6] |
         ecchmatrix[5][72]^sbits[5] |
         ecchmatrix[4][72]^sbits[4] |
         ecchmatrix[3][72]^sbits[3] |
         ecchmatrix[2][72]^sbits[2] |
         ecchmatrix[1][72]^sbits[1] |
         ecchmatrix[0][72]^sbits[0]);
  assign biterr_wire[71] = ~(
         ecchmatrix[8][71]^sbits[8] |
         ecchmatrix[7][71]^sbits[7] |
         ecchmatrix[6][71]^sbits[6] |
         ecchmatrix[5][71]^sbits[5] |
         ecchmatrix[4][71]^sbits[4] |
         ecchmatrix[3][71]^sbits[3] |
         ecchmatrix[2][71]^sbits[2] |
         ecchmatrix[1][71]^sbits[1] |
         ecchmatrix[0][71]^sbits[0]);
  assign biterr_wire[70] = ~(
         ecchmatrix[8][70]^sbits[8] |
         ecchmatrix[7][70]^sbits[7] |
         ecchmatrix[6][70]^sbits[6] |
         ecchmatrix[5][70]^sbits[5] |
         ecchmatrix[4][70]^sbits[4] |
         ecchmatrix[3][70]^sbits[3] |
         ecchmatrix[2][70]^sbits[2] |
         ecchmatrix[1][70]^sbits[1] |
         ecchmatrix[0][70]^sbits[0]);
  assign biterr_wire[69] = ~(
         ecchmatrix[8][69]^sbits[8] |
         ecchmatrix[7][69]^sbits[7] |
         ecchmatrix[6][69]^sbits[6] |
         ecchmatrix[5][69]^sbits[5] |
         ecchmatrix[4][69]^sbits[4] |
         ecchmatrix[3][69]^sbits[3] |
         ecchmatrix[2][69]^sbits[2] |
         ecchmatrix[1][69]^sbits[1] |
         ecchmatrix[0][69]^sbits[0]);
  assign biterr_wire[68] = ~(
         ecchmatrix[8][68]^sbits[8] |
         ecchmatrix[7][68]^sbits[7] |
         ecchmatrix[6][68]^sbits[6] |
         ecchmatrix[5][68]^sbits[5] |
         ecchmatrix[4][68]^sbits[4] |
         ecchmatrix[3][68]^sbits[3] |
         ecchmatrix[2][68]^sbits[2] |
         ecchmatrix[1][68]^sbits[1] |
         ecchmatrix[0][68]^sbits[0]);
  assign biterr_wire[67] = ~(
         ecchmatrix[8][67]^sbits[8] |
         ecchmatrix[7][67]^sbits[7] |
         ecchmatrix[6][67]^sbits[6] |
         ecchmatrix[5][67]^sbits[5] |
         ecchmatrix[4][67]^sbits[4] |
         ecchmatrix[3][67]^sbits[3] |
         ecchmatrix[2][67]^sbits[2] |
         ecchmatrix[1][67]^sbits[1] |
         ecchmatrix[0][67]^sbits[0]);
  assign biterr_wire[66] = ~(
         ecchmatrix[8][66]^sbits[8] |
         ecchmatrix[7][66]^sbits[7] |
         ecchmatrix[6][66]^sbits[6] |
         ecchmatrix[5][66]^sbits[5] |
         ecchmatrix[4][66]^sbits[4] |
         ecchmatrix[3][66]^sbits[3] |
         ecchmatrix[2][66]^sbits[2] |
         ecchmatrix[1][66]^sbits[1] |
         ecchmatrix[0][66]^sbits[0]);
  assign biterr_wire[65] = ~(
         ecchmatrix[8][65]^sbits[8] |
         ecchmatrix[7][65]^sbits[7] |
         ecchmatrix[6][65]^sbits[6] |
         ecchmatrix[5][65]^sbits[5] |
         ecchmatrix[4][65]^sbits[4] |
         ecchmatrix[3][65]^sbits[3] |
         ecchmatrix[2][65]^sbits[2] |
         ecchmatrix[1][65]^sbits[1] |
         ecchmatrix[0][65]^sbits[0]);
  assign biterr_wire[64] = ~(
         ecchmatrix[8][64]^sbits[8] |
         ecchmatrix[7][64]^sbits[7] |
         ecchmatrix[6][64]^sbits[6] |
         ecchmatrix[5][64]^sbits[5] |
         ecchmatrix[4][64]^sbits[4] |
         ecchmatrix[3][64]^sbits[3] |
         ecchmatrix[2][64]^sbits[2] |
         ecchmatrix[1][64]^sbits[1] |
         ecchmatrix[0][64]^sbits[0]);
  assign biterr_wire[63] = ~(
         ecchmatrix[8][63]^sbits[8] |
         ecchmatrix[7][63]^sbits[7] |
         ecchmatrix[6][63]^sbits[6] |
         ecchmatrix[5][63]^sbits[5] |
         ecchmatrix[4][63]^sbits[4] |
         ecchmatrix[3][63]^sbits[3] |
         ecchmatrix[2][63]^sbits[2] |
         ecchmatrix[1][63]^sbits[1] |
         ecchmatrix[0][63]^sbits[0]);
  assign biterr_wire[62] = ~(
         ecchmatrix[8][62]^sbits[8] |
         ecchmatrix[7][62]^sbits[7] |
         ecchmatrix[6][62]^sbits[6] |
         ecchmatrix[5][62]^sbits[5] |
         ecchmatrix[4][62]^sbits[4] |
         ecchmatrix[3][62]^sbits[3] |
         ecchmatrix[2][62]^sbits[2] |
         ecchmatrix[1][62]^sbits[1] |
         ecchmatrix[0][62]^sbits[0]);
  assign biterr_wire[61] = ~(
         ecchmatrix[8][61]^sbits[8] |
         ecchmatrix[7][61]^sbits[7] |
         ecchmatrix[6][61]^sbits[6] |
         ecchmatrix[5][61]^sbits[5] |
         ecchmatrix[4][61]^sbits[4] |
         ecchmatrix[3][61]^sbits[3] |
         ecchmatrix[2][61]^sbits[2] |
         ecchmatrix[1][61]^sbits[1] |
         ecchmatrix[0][61]^sbits[0]);
  assign biterr_wire[60] = ~(
         ecchmatrix[8][60]^sbits[8] |
         ecchmatrix[7][60]^sbits[7] |
         ecchmatrix[6][60]^sbits[6] |
         ecchmatrix[5][60]^sbits[5] |
         ecchmatrix[4][60]^sbits[4] |
         ecchmatrix[3][60]^sbits[3] |
         ecchmatrix[2][60]^sbits[2] |
         ecchmatrix[1][60]^sbits[1] |
         ecchmatrix[0][60]^sbits[0]);
  assign biterr_wire[59] = ~(
         ecchmatrix[8][59]^sbits[8] |
         ecchmatrix[7][59]^sbits[7] |
         ecchmatrix[6][59]^sbits[6] |
         ecchmatrix[5][59]^sbits[5] |
         ecchmatrix[4][59]^sbits[4] |
         ecchmatrix[3][59]^sbits[3] |
         ecchmatrix[2][59]^sbits[2] |
         ecchmatrix[1][59]^sbits[1] |
         ecchmatrix[0][59]^sbits[0]);
  assign biterr_wire[58] = ~(
         ecchmatrix[8][58]^sbits[8] |
         ecchmatrix[7][58]^sbits[7] |
         ecchmatrix[6][58]^sbits[6] |
         ecchmatrix[5][58]^sbits[5] |
         ecchmatrix[4][58]^sbits[4] |
         ecchmatrix[3][58]^sbits[3] |
         ecchmatrix[2][58]^sbits[2] |
         ecchmatrix[1][58]^sbits[1] |
         ecchmatrix[0][58]^sbits[0]);
  assign biterr_wire[57] = ~(
         ecchmatrix[8][57]^sbits[8] |
         ecchmatrix[7][57]^sbits[7] |
         ecchmatrix[6][57]^sbits[6] |
         ecchmatrix[5][57]^sbits[5] |
         ecchmatrix[4][57]^sbits[4] |
         ecchmatrix[3][57]^sbits[3] |
         ecchmatrix[2][57]^sbits[2] |
         ecchmatrix[1][57]^sbits[1] |
         ecchmatrix[0][57]^sbits[0]);
  assign biterr_wire[56] = ~(
         ecchmatrix[8][56]^sbits[8] |
         ecchmatrix[7][56]^sbits[7] |
         ecchmatrix[6][56]^sbits[6] |
         ecchmatrix[5][56]^sbits[5] |
         ecchmatrix[4][56]^sbits[4] |
         ecchmatrix[3][56]^sbits[3] |
         ecchmatrix[2][56]^sbits[2] |
         ecchmatrix[1][56]^sbits[1] |
         ecchmatrix[0][56]^sbits[0]);
  assign biterr_wire[55] = ~(
         ecchmatrix[8][55]^sbits[8] |
         ecchmatrix[7][55]^sbits[7] |
         ecchmatrix[6][55]^sbits[6] |
         ecchmatrix[5][55]^sbits[5] |
         ecchmatrix[4][55]^sbits[4] |
         ecchmatrix[3][55]^sbits[3] |
         ecchmatrix[2][55]^sbits[2] |
         ecchmatrix[1][55]^sbits[1] |
         ecchmatrix[0][55]^sbits[0]);
  assign biterr_wire[54] = ~(
         ecchmatrix[8][54]^sbits[8] |
         ecchmatrix[7][54]^sbits[7] |
         ecchmatrix[6][54]^sbits[6] |
         ecchmatrix[5][54]^sbits[5] |
         ecchmatrix[4][54]^sbits[4] |
         ecchmatrix[3][54]^sbits[3] |
         ecchmatrix[2][54]^sbits[2] |
         ecchmatrix[1][54]^sbits[1] |
         ecchmatrix[0][54]^sbits[0]);
  assign biterr_wire[53] = ~(
         ecchmatrix[8][53]^sbits[8] |
         ecchmatrix[7][53]^sbits[7] |
         ecchmatrix[6][53]^sbits[6] |
         ecchmatrix[5][53]^sbits[5] |
         ecchmatrix[4][53]^sbits[4] |
         ecchmatrix[3][53]^sbits[3] |
         ecchmatrix[2][53]^sbits[2] |
         ecchmatrix[1][53]^sbits[1] |
         ecchmatrix[0][53]^sbits[0]);
  assign biterr_wire[52] = ~(
         ecchmatrix[8][52]^sbits[8] |
         ecchmatrix[7][52]^sbits[7] |
         ecchmatrix[6][52]^sbits[6] |
         ecchmatrix[5][52]^sbits[5] |
         ecchmatrix[4][52]^sbits[4] |
         ecchmatrix[3][52]^sbits[3] |
         ecchmatrix[2][52]^sbits[2] |
         ecchmatrix[1][52]^sbits[1] |
         ecchmatrix[0][52]^sbits[0]);
  assign biterr_wire[51] = ~(
         ecchmatrix[8][51]^sbits[8] |
         ecchmatrix[7][51]^sbits[7] |
         ecchmatrix[6][51]^sbits[6] |
         ecchmatrix[5][51]^sbits[5] |
         ecchmatrix[4][51]^sbits[4] |
         ecchmatrix[3][51]^sbits[3] |
         ecchmatrix[2][51]^sbits[2] |
         ecchmatrix[1][51]^sbits[1] |
         ecchmatrix[0][51]^sbits[0]);
  assign biterr_wire[50] = ~(
         ecchmatrix[8][50]^sbits[8] |
         ecchmatrix[7][50]^sbits[7] |
         ecchmatrix[6][50]^sbits[6] |
         ecchmatrix[5][50]^sbits[5] |
         ecchmatrix[4][50]^sbits[4] |
         ecchmatrix[3][50]^sbits[3] |
         ecchmatrix[2][50]^sbits[2] |
         ecchmatrix[1][50]^sbits[1] |
         ecchmatrix[0][50]^sbits[0]);
  assign biterr_wire[49] = ~(
         ecchmatrix[8][49]^sbits[8] |
         ecchmatrix[7][49]^sbits[7] |
         ecchmatrix[6][49]^sbits[6] |
         ecchmatrix[5][49]^sbits[5] |
         ecchmatrix[4][49]^sbits[4] |
         ecchmatrix[3][49]^sbits[3] |
         ecchmatrix[2][49]^sbits[2] |
         ecchmatrix[1][49]^sbits[1] |
         ecchmatrix[0][49]^sbits[0]);
  assign biterr_wire[48] = ~(
         ecchmatrix[8][48]^sbits[8] |
         ecchmatrix[7][48]^sbits[7] |
         ecchmatrix[6][48]^sbits[6] |
         ecchmatrix[5][48]^sbits[5] |
         ecchmatrix[4][48]^sbits[4] |
         ecchmatrix[3][48]^sbits[3] |
         ecchmatrix[2][48]^sbits[2] |
         ecchmatrix[1][48]^sbits[1] |
         ecchmatrix[0][48]^sbits[0]);
  assign biterr_wire[47] = ~(
         ecchmatrix[8][47]^sbits[8] |
         ecchmatrix[7][47]^sbits[7] |
         ecchmatrix[6][47]^sbits[6] |
         ecchmatrix[5][47]^sbits[5] |
         ecchmatrix[4][47]^sbits[4] |
         ecchmatrix[3][47]^sbits[3] |
         ecchmatrix[2][47]^sbits[2] |
         ecchmatrix[1][47]^sbits[1] |
         ecchmatrix[0][47]^sbits[0]);
  assign biterr_wire[46] = ~(
         ecchmatrix[8][46]^sbits[8] |
         ecchmatrix[7][46]^sbits[7] |
         ecchmatrix[6][46]^sbits[6] |
         ecchmatrix[5][46]^sbits[5] |
         ecchmatrix[4][46]^sbits[4] |
         ecchmatrix[3][46]^sbits[3] |
         ecchmatrix[2][46]^sbits[2] |
         ecchmatrix[1][46]^sbits[1] |
         ecchmatrix[0][46]^sbits[0]);
  assign biterr_wire[45] = ~(
         ecchmatrix[8][45]^sbits[8] |
         ecchmatrix[7][45]^sbits[7] |
         ecchmatrix[6][45]^sbits[6] |
         ecchmatrix[5][45]^sbits[5] |
         ecchmatrix[4][45]^sbits[4] |
         ecchmatrix[3][45]^sbits[3] |
         ecchmatrix[2][45]^sbits[2] |
         ecchmatrix[1][45]^sbits[1] |
         ecchmatrix[0][45]^sbits[0]);
  assign biterr_wire[44] = ~(
         ecchmatrix[8][44]^sbits[8] |
         ecchmatrix[7][44]^sbits[7] |
         ecchmatrix[6][44]^sbits[6] |
         ecchmatrix[5][44]^sbits[5] |
         ecchmatrix[4][44]^sbits[4] |
         ecchmatrix[3][44]^sbits[3] |
         ecchmatrix[2][44]^sbits[2] |
         ecchmatrix[1][44]^sbits[1] |
         ecchmatrix[0][44]^sbits[0]);
  assign biterr_wire[43] = ~(
         ecchmatrix[8][43]^sbits[8] |
         ecchmatrix[7][43]^sbits[7] |
         ecchmatrix[6][43]^sbits[6] |
         ecchmatrix[5][43]^sbits[5] |
         ecchmatrix[4][43]^sbits[4] |
         ecchmatrix[3][43]^sbits[3] |
         ecchmatrix[2][43]^sbits[2] |
         ecchmatrix[1][43]^sbits[1] |
         ecchmatrix[0][43]^sbits[0]);
  assign biterr_wire[42] = ~(
         ecchmatrix[8][42]^sbits[8] |
         ecchmatrix[7][42]^sbits[7] |
         ecchmatrix[6][42]^sbits[6] |
         ecchmatrix[5][42]^sbits[5] |
         ecchmatrix[4][42]^sbits[4] |
         ecchmatrix[3][42]^sbits[3] |
         ecchmatrix[2][42]^sbits[2] |
         ecchmatrix[1][42]^sbits[1] |
         ecchmatrix[0][42]^sbits[0]);
  assign biterr_wire[41] = ~(
         ecchmatrix[8][41]^sbits[8] |
         ecchmatrix[7][41]^sbits[7] |
         ecchmatrix[6][41]^sbits[6] |
         ecchmatrix[5][41]^sbits[5] |
         ecchmatrix[4][41]^sbits[4] |
         ecchmatrix[3][41]^sbits[3] |
         ecchmatrix[2][41]^sbits[2] |
         ecchmatrix[1][41]^sbits[1] |
         ecchmatrix[0][41]^sbits[0]);
  assign biterr_wire[40] = ~(
         ecchmatrix[8][40]^sbits[8] |
         ecchmatrix[7][40]^sbits[7] |
         ecchmatrix[6][40]^sbits[6] |
         ecchmatrix[5][40]^sbits[5] |
         ecchmatrix[4][40]^sbits[4] |
         ecchmatrix[3][40]^sbits[3] |
         ecchmatrix[2][40]^sbits[2] |
         ecchmatrix[1][40]^sbits[1] |
         ecchmatrix[0][40]^sbits[0]);
  assign biterr_wire[39] = ~(
         ecchmatrix[8][39]^sbits[8] |
         ecchmatrix[7][39]^sbits[7] |
         ecchmatrix[6][39]^sbits[6] |
         ecchmatrix[5][39]^sbits[5] |
         ecchmatrix[4][39]^sbits[4] |
         ecchmatrix[3][39]^sbits[3] |
         ecchmatrix[2][39]^sbits[2] |
         ecchmatrix[1][39]^sbits[1] |
         ecchmatrix[0][39]^sbits[0]);
  assign biterr_wire[38] = ~(
         ecchmatrix[8][38]^sbits[8] |
         ecchmatrix[7][38]^sbits[7] |
         ecchmatrix[6][38]^sbits[6] |
         ecchmatrix[5][38]^sbits[5] |
         ecchmatrix[4][38]^sbits[4] |
         ecchmatrix[3][38]^sbits[3] |
         ecchmatrix[2][38]^sbits[2] |
         ecchmatrix[1][38]^sbits[1] |
         ecchmatrix[0][38]^sbits[0]);
  assign biterr_wire[37] = ~(
         ecchmatrix[8][37]^sbits[8] |
         ecchmatrix[7][37]^sbits[7] |
         ecchmatrix[6][37]^sbits[6] |
         ecchmatrix[5][37]^sbits[5] |
         ecchmatrix[4][37]^sbits[4] |
         ecchmatrix[3][37]^sbits[3] |
         ecchmatrix[2][37]^sbits[2] |
         ecchmatrix[1][37]^sbits[1] |
         ecchmatrix[0][37]^sbits[0]);
  assign biterr_wire[36] = ~(
         ecchmatrix[8][36]^sbits[8] |
         ecchmatrix[7][36]^sbits[7] |
         ecchmatrix[6][36]^sbits[6] |
         ecchmatrix[5][36]^sbits[5] |
         ecchmatrix[4][36]^sbits[4] |
         ecchmatrix[3][36]^sbits[3] |
         ecchmatrix[2][36]^sbits[2] |
         ecchmatrix[1][36]^sbits[1] |
         ecchmatrix[0][36]^sbits[0]);
  assign biterr_wire[35] = ~(
         ecchmatrix[8][35]^sbits[8] |
         ecchmatrix[7][35]^sbits[7] |
         ecchmatrix[6][35]^sbits[6] |
         ecchmatrix[5][35]^sbits[5] |
         ecchmatrix[4][35]^sbits[4] |
         ecchmatrix[3][35]^sbits[3] |
         ecchmatrix[2][35]^sbits[2] |
         ecchmatrix[1][35]^sbits[1] |
         ecchmatrix[0][35]^sbits[0]);
  assign biterr_wire[34] = ~(
         ecchmatrix[8][34]^sbits[8] |
         ecchmatrix[7][34]^sbits[7] |
         ecchmatrix[6][34]^sbits[6] |
         ecchmatrix[5][34]^sbits[5] |
         ecchmatrix[4][34]^sbits[4] |
         ecchmatrix[3][34]^sbits[3] |
         ecchmatrix[2][34]^sbits[2] |
         ecchmatrix[1][34]^sbits[1] |
         ecchmatrix[0][34]^sbits[0]);
  assign biterr_wire[33] = ~(
         ecchmatrix[8][33]^sbits[8] |
         ecchmatrix[7][33]^sbits[7] |
         ecchmatrix[6][33]^sbits[6] |
         ecchmatrix[5][33]^sbits[5] |
         ecchmatrix[4][33]^sbits[4] |
         ecchmatrix[3][33]^sbits[3] |
         ecchmatrix[2][33]^sbits[2] |
         ecchmatrix[1][33]^sbits[1] |
         ecchmatrix[0][33]^sbits[0]);
  assign biterr_wire[32] = ~(
         ecchmatrix[8][32]^sbits[8] |
         ecchmatrix[7][32]^sbits[7] |
         ecchmatrix[6][32]^sbits[6] |
         ecchmatrix[5][32]^sbits[5] |
         ecchmatrix[4][32]^sbits[4] |
         ecchmatrix[3][32]^sbits[3] |
         ecchmatrix[2][32]^sbits[2] |
         ecchmatrix[1][32]^sbits[1] |
         ecchmatrix[0][32]^sbits[0]);
  assign biterr_wire[31] = ~(
         ecchmatrix[8][31]^sbits[8] |
         ecchmatrix[7][31]^sbits[7] |
         ecchmatrix[6][31]^sbits[6] |
         ecchmatrix[5][31]^sbits[5] |
         ecchmatrix[4][31]^sbits[4] |
         ecchmatrix[3][31]^sbits[3] |
         ecchmatrix[2][31]^sbits[2] |
         ecchmatrix[1][31]^sbits[1] |
         ecchmatrix[0][31]^sbits[0]);
  assign biterr_wire[30] = ~(
         ecchmatrix[8][30]^sbits[8] |
         ecchmatrix[7][30]^sbits[7] |
         ecchmatrix[6][30]^sbits[6] |
         ecchmatrix[5][30]^sbits[5] |
         ecchmatrix[4][30]^sbits[4] |
         ecchmatrix[3][30]^sbits[3] |
         ecchmatrix[2][30]^sbits[2] |
         ecchmatrix[1][30]^sbits[1] |
         ecchmatrix[0][30]^sbits[0]);
  assign biterr_wire[29] = ~(
         ecchmatrix[8][29]^sbits[8] |
         ecchmatrix[7][29]^sbits[7] |
         ecchmatrix[6][29]^sbits[6] |
         ecchmatrix[5][29]^sbits[5] |
         ecchmatrix[4][29]^sbits[4] |
         ecchmatrix[3][29]^sbits[3] |
         ecchmatrix[2][29]^sbits[2] |
         ecchmatrix[1][29]^sbits[1] |
         ecchmatrix[0][29]^sbits[0]);
  assign biterr_wire[28] = ~(
         ecchmatrix[8][28]^sbits[8] |
         ecchmatrix[7][28]^sbits[7] |
         ecchmatrix[6][28]^sbits[6] |
         ecchmatrix[5][28]^sbits[5] |
         ecchmatrix[4][28]^sbits[4] |
         ecchmatrix[3][28]^sbits[3] |
         ecchmatrix[2][28]^sbits[2] |
         ecchmatrix[1][28]^sbits[1] |
         ecchmatrix[0][28]^sbits[0]);
  assign biterr_wire[27] = ~(
         ecchmatrix[8][27]^sbits[8] |
         ecchmatrix[7][27]^sbits[7] |
         ecchmatrix[6][27]^sbits[6] |
         ecchmatrix[5][27]^sbits[5] |
         ecchmatrix[4][27]^sbits[4] |
         ecchmatrix[3][27]^sbits[3] |
         ecchmatrix[2][27]^sbits[2] |
         ecchmatrix[1][27]^sbits[1] |
         ecchmatrix[0][27]^sbits[0]);
  assign biterr_wire[26] = ~(
         ecchmatrix[8][26]^sbits[8] |
         ecchmatrix[7][26]^sbits[7] |
         ecchmatrix[6][26]^sbits[6] |
         ecchmatrix[5][26]^sbits[5] |
         ecchmatrix[4][26]^sbits[4] |
         ecchmatrix[3][26]^sbits[3] |
         ecchmatrix[2][26]^sbits[2] |
         ecchmatrix[1][26]^sbits[1] |
         ecchmatrix[0][26]^sbits[0]);
  assign biterr_wire[25] = ~(
         ecchmatrix[8][25]^sbits[8] |
         ecchmatrix[7][25]^sbits[7] |
         ecchmatrix[6][25]^sbits[6] |
         ecchmatrix[5][25]^sbits[5] |
         ecchmatrix[4][25]^sbits[4] |
         ecchmatrix[3][25]^sbits[3] |
         ecchmatrix[2][25]^sbits[2] |
         ecchmatrix[1][25]^sbits[1] |
         ecchmatrix[0][25]^sbits[0]);
  assign biterr_wire[24] = ~(
         ecchmatrix[8][24]^sbits[8] |
         ecchmatrix[7][24]^sbits[7] |
         ecchmatrix[6][24]^sbits[6] |
         ecchmatrix[5][24]^sbits[5] |
         ecchmatrix[4][24]^sbits[4] |
         ecchmatrix[3][24]^sbits[3] |
         ecchmatrix[2][24]^sbits[2] |
         ecchmatrix[1][24]^sbits[1] |
         ecchmatrix[0][24]^sbits[0]);
  assign biterr_wire[23] = ~(
         ecchmatrix[8][23]^sbits[8] |
         ecchmatrix[7][23]^sbits[7] |
         ecchmatrix[6][23]^sbits[6] |
         ecchmatrix[5][23]^sbits[5] |
         ecchmatrix[4][23]^sbits[4] |
         ecchmatrix[3][23]^sbits[3] |
         ecchmatrix[2][23]^sbits[2] |
         ecchmatrix[1][23]^sbits[1] |
         ecchmatrix[0][23]^sbits[0]);
  assign biterr_wire[22] = ~(
         ecchmatrix[8][22]^sbits[8] |
         ecchmatrix[7][22]^sbits[7] |
         ecchmatrix[6][22]^sbits[6] |
         ecchmatrix[5][22]^sbits[5] |
         ecchmatrix[4][22]^sbits[4] |
         ecchmatrix[3][22]^sbits[3] |
         ecchmatrix[2][22]^sbits[2] |
         ecchmatrix[1][22]^sbits[1] |
         ecchmatrix[0][22]^sbits[0]);
  assign biterr_wire[21] = ~(
         ecchmatrix[8][21]^sbits[8] |
         ecchmatrix[7][21]^sbits[7] |
         ecchmatrix[6][21]^sbits[6] |
         ecchmatrix[5][21]^sbits[5] |
         ecchmatrix[4][21]^sbits[4] |
         ecchmatrix[3][21]^sbits[3] |
         ecchmatrix[2][21]^sbits[2] |
         ecchmatrix[1][21]^sbits[1] |
         ecchmatrix[0][21]^sbits[0]);
  assign biterr_wire[20] = ~(
         ecchmatrix[8][20]^sbits[8] |
         ecchmatrix[7][20]^sbits[7] |
         ecchmatrix[6][20]^sbits[6] |
         ecchmatrix[5][20]^sbits[5] |
         ecchmatrix[4][20]^sbits[4] |
         ecchmatrix[3][20]^sbits[3] |
         ecchmatrix[2][20]^sbits[2] |
         ecchmatrix[1][20]^sbits[1] |
         ecchmatrix[0][20]^sbits[0]);
  assign biterr_wire[19] = ~(
         ecchmatrix[8][19]^sbits[8] |
         ecchmatrix[7][19]^sbits[7] |
         ecchmatrix[6][19]^sbits[6] |
         ecchmatrix[5][19]^sbits[5] |
         ecchmatrix[4][19]^sbits[4] |
         ecchmatrix[3][19]^sbits[3] |
         ecchmatrix[2][19]^sbits[2] |
         ecchmatrix[1][19]^sbits[1] |
         ecchmatrix[0][19]^sbits[0]);
  assign biterr_wire[18] = ~(
         ecchmatrix[8][18]^sbits[8] |
         ecchmatrix[7][18]^sbits[7] |
         ecchmatrix[6][18]^sbits[6] |
         ecchmatrix[5][18]^sbits[5] |
         ecchmatrix[4][18]^sbits[4] |
         ecchmatrix[3][18]^sbits[3] |
         ecchmatrix[2][18]^sbits[2] |
         ecchmatrix[1][18]^sbits[1] |
         ecchmatrix[0][18]^sbits[0]);
  assign biterr_wire[17] = ~(
         ecchmatrix[8][17]^sbits[8] |
         ecchmatrix[7][17]^sbits[7] |
         ecchmatrix[6][17]^sbits[6] |
         ecchmatrix[5][17]^sbits[5] |
         ecchmatrix[4][17]^sbits[4] |
         ecchmatrix[3][17]^sbits[3] |
         ecchmatrix[2][17]^sbits[2] |
         ecchmatrix[1][17]^sbits[1] |
         ecchmatrix[0][17]^sbits[0]);
  assign biterr_wire[16] = ~(
         ecchmatrix[8][16]^sbits[8] |
         ecchmatrix[7][16]^sbits[7] |
         ecchmatrix[6][16]^sbits[6] |
         ecchmatrix[5][16]^sbits[5] |
         ecchmatrix[4][16]^sbits[4] |
         ecchmatrix[3][16]^sbits[3] |
         ecchmatrix[2][16]^sbits[2] |
         ecchmatrix[1][16]^sbits[1] |
         ecchmatrix[0][16]^sbits[0]);
  assign biterr_wire[15] = ~(
         ecchmatrix[8][15]^sbits[8] |
         ecchmatrix[7][15]^sbits[7] |
         ecchmatrix[6][15]^sbits[6] |
         ecchmatrix[5][15]^sbits[5] |
         ecchmatrix[4][15]^sbits[4] |
         ecchmatrix[3][15]^sbits[3] |
         ecchmatrix[2][15]^sbits[2] |
         ecchmatrix[1][15]^sbits[1] |
         ecchmatrix[0][15]^sbits[0]);
  assign biterr_wire[14] = ~(
         ecchmatrix[8][14]^sbits[8] |
         ecchmatrix[7][14]^sbits[7] |
         ecchmatrix[6][14]^sbits[6] |
         ecchmatrix[5][14]^sbits[5] |
         ecchmatrix[4][14]^sbits[4] |
         ecchmatrix[3][14]^sbits[3] |
         ecchmatrix[2][14]^sbits[2] |
         ecchmatrix[1][14]^sbits[1] |
         ecchmatrix[0][14]^sbits[0]);
  assign biterr_wire[13] = ~(
         ecchmatrix[8][13]^sbits[8] |
         ecchmatrix[7][13]^sbits[7] |
         ecchmatrix[6][13]^sbits[6] |
         ecchmatrix[5][13]^sbits[5] |
         ecchmatrix[4][13]^sbits[4] |
         ecchmatrix[3][13]^sbits[3] |
         ecchmatrix[2][13]^sbits[2] |
         ecchmatrix[1][13]^sbits[1] |
         ecchmatrix[0][13]^sbits[0]);
  assign biterr_wire[12] = ~(
         ecchmatrix[8][12]^sbits[8] |
         ecchmatrix[7][12]^sbits[7] |
         ecchmatrix[6][12]^sbits[6] |
         ecchmatrix[5][12]^sbits[5] |
         ecchmatrix[4][12]^sbits[4] |
         ecchmatrix[3][12]^sbits[3] |
         ecchmatrix[2][12]^sbits[2] |
         ecchmatrix[1][12]^sbits[1] |
         ecchmatrix[0][12]^sbits[0]);
  assign biterr_wire[11] = ~(
         ecchmatrix[8][11]^sbits[8] |
         ecchmatrix[7][11]^sbits[7] |
         ecchmatrix[6][11]^sbits[6] |
         ecchmatrix[5][11]^sbits[5] |
         ecchmatrix[4][11]^sbits[4] |
         ecchmatrix[3][11]^sbits[3] |
         ecchmatrix[2][11]^sbits[2] |
         ecchmatrix[1][11]^sbits[1] |
         ecchmatrix[0][11]^sbits[0]);
  assign biterr_wire[10] = ~(
         ecchmatrix[8][10]^sbits[8] |
         ecchmatrix[7][10]^sbits[7] |
         ecchmatrix[6][10]^sbits[6] |
         ecchmatrix[5][10]^sbits[5] |
         ecchmatrix[4][10]^sbits[4] |
         ecchmatrix[3][10]^sbits[3] |
         ecchmatrix[2][10]^sbits[2] |
         ecchmatrix[1][10]^sbits[1] |
         ecchmatrix[0][10]^sbits[0]);
  assign biterr_wire[9] = ~(
         ecchmatrix[8][9]^sbits[8] |
         ecchmatrix[7][9]^sbits[7] |
         ecchmatrix[6][9]^sbits[6] |
         ecchmatrix[5][9]^sbits[5] |
         ecchmatrix[4][9]^sbits[4] |
         ecchmatrix[3][9]^sbits[3] |
         ecchmatrix[2][9]^sbits[2] |
         ecchmatrix[1][9]^sbits[1] |
         ecchmatrix[0][9]^sbits[0]);
  assign biterr_wire[8] = ~(
         ecchmatrix[8][8]^sbits[8] |
         ecchmatrix[7][8]^sbits[7] |
         ecchmatrix[6][8]^sbits[6] |
         ecchmatrix[5][8]^sbits[5] |
         ecchmatrix[4][8]^sbits[4] |
         ecchmatrix[3][8]^sbits[3] |
         ecchmatrix[2][8]^sbits[2] |
         ecchmatrix[1][8]^sbits[1] |
         ecchmatrix[0][8]^sbits[0]);
  assign biterr_wire[7] = ~(
         ecchmatrix[8][7]^sbits[8] |
         ecchmatrix[7][7]^sbits[7] |
         ecchmatrix[6][7]^sbits[6] |
         ecchmatrix[5][7]^sbits[5] |
         ecchmatrix[4][7]^sbits[4] |
         ecchmatrix[3][7]^sbits[3] |
         ecchmatrix[2][7]^sbits[2] |
         ecchmatrix[1][7]^sbits[1] |
         ecchmatrix[0][7]^sbits[0]);
  assign biterr_wire[6] = ~(
         ecchmatrix[8][6]^sbits[8] |
         ecchmatrix[7][6]^sbits[7] |
         ecchmatrix[6][6]^sbits[6] |
         ecchmatrix[5][6]^sbits[5] |
         ecchmatrix[4][6]^sbits[4] |
         ecchmatrix[3][6]^sbits[3] |
         ecchmatrix[2][6]^sbits[2] |
         ecchmatrix[1][6]^sbits[1] |
         ecchmatrix[0][6]^sbits[0]);
  assign biterr_wire[5] = ~(
         ecchmatrix[8][5]^sbits[8] |
         ecchmatrix[7][5]^sbits[7] |
         ecchmatrix[6][5]^sbits[6] |
         ecchmatrix[5][5]^sbits[5] |
         ecchmatrix[4][5]^sbits[4] |
         ecchmatrix[3][5]^sbits[3] |
         ecchmatrix[2][5]^sbits[2] |
         ecchmatrix[1][5]^sbits[1] |
         ecchmatrix[0][5]^sbits[0]);
  assign biterr_wire[4] = ~(
         ecchmatrix[8][4]^sbits[8] |
         ecchmatrix[7][4]^sbits[7] |
         ecchmatrix[6][4]^sbits[6] |
         ecchmatrix[5][4]^sbits[5] |
         ecchmatrix[4][4]^sbits[4] |
         ecchmatrix[3][4]^sbits[3] |
         ecchmatrix[2][4]^sbits[2] |
         ecchmatrix[1][4]^sbits[1] |
         ecchmatrix[0][4]^sbits[0]);
  assign biterr_wire[3] = ~(
         ecchmatrix[8][3]^sbits[8] |
         ecchmatrix[7][3]^sbits[7] |
         ecchmatrix[6][3]^sbits[6] |
         ecchmatrix[5][3]^sbits[5] |
         ecchmatrix[4][3]^sbits[4] |
         ecchmatrix[3][3]^sbits[3] |
         ecchmatrix[2][3]^sbits[2] |
         ecchmatrix[1][3]^sbits[1] |
         ecchmatrix[0][3]^sbits[0]);
  assign biterr_wire[2] = ~(
         ecchmatrix[8][2]^sbits[8] |
         ecchmatrix[7][2]^sbits[7] |
         ecchmatrix[6][2]^sbits[6] |
         ecchmatrix[5][2]^sbits[5] |
         ecchmatrix[4][2]^sbits[4] |
         ecchmatrix[3][2]^sbits[3] |
         ecchmatrix[2][2]^sbits[2] |
         ecchmatrix[1][2]^sbits[1] |
         ecchmatrix[0][2]^sbits[0]);
  assign biterr_wire[1] = ~(
         ecchmatrix[8][1]^sbits[8] |
         ecchmatrix[7][1]^sbits[7] |
         ecchmatrix[6][1]^sbits[6] |
         ecchmatrix[5][1]^sbits[5] |
         ecchmatrix[4][1]^sbits[4] |
         ecchmatrix[3][1]^sbits[3] |
         ecchmatrix[2][1]^sbits[2] |
         ecchmatrix[1][1]^sbits[1] |
         ecchmatrix[0][1]^sbits[0]);
  assign biterr_wire[0] = ~(
         ecchmatrix[8][0]^sbits[8] |
         ecchmatrix[7][0]^sbits[7] |
         ecchmatrix[6][0]^sbits[6] |
         ecchmatrix[5][0]^sbits[5] |
         ecchmatrix[4][0]^sbits[4] |
         ecchmatrix[3][0]^sbits[3] |
         ecchmatrix[2][0]^sbits[2] |
         ecchmatrix[1][0]^sbits[1] |
         ecchmatrix[0][0]^sbits[0]);

  wire [ECCDWIDTH+ECCWIDTH-1:0]   biterr;
  wire [ECCDWIDTH-1:0]	din_f2;
  wire [ECCWIDTH-1:0]   sbits_f2;
  generate if(FLOPECC2) begin
	reg [ECCDWIDTH+ECCWIDTH-1:0]   biterr_reg;
	reg [ECCDWIDTH-1:0]	din_f2_reg;
	reg [ECCWIDTH-1:0] sbits_f2_reg;
	always @(posedge clk) begin
		biterr_reg <= biterr_wire;
		din_f2_reg <= din_f1;
		sbits_f2_reg <= sbits;
	end
	assign biterr = biterr_reg;
	assign din_f2 = din_f2_reg;
	assign sbits_f2 = sbits_f2_reg;
  end else begin
	assign biterr = biterr_wire;
	assign din_f2 = din_f1;
	assign sbits_f2 = sbits;
  end
  endgenerate
		 
 assign  dout    = din_f2 ^ biterr;
 assign  sec_err = |biterr;
 assign  ded_err = |sbits_f2 & ~|biterr;

endmodule

module ecc_check_502 #(parameter FLOPECC1=0, parameter FLOPECC2=0) (din,  eccin, dout, sec_err, ded_err, clk, rst);

  localparam ECCDWIDTH = 502;
  localparam ECCWIDTH  = 10;
  
  input [ECCDWIDTH-1:0]            din;  
  input [ECCWIDTH-1:0]             eccin;

  output [ECCDWIDTH-1:0]           dout;  
  output                           sec_err; // asserted if a single error is detected/corrected
  output                           ded_err; // asserted if two errors are detected

  input                            clk;
  input                            rst;

  wire       sec_err;
  wire       ded_err;
  wire [ECCDWIDTH-1:0]      dout;
  
  wire [ECCDWIDTH+ECCWIDTH-1:0]   ecchmatrix [0:ECCWIDTH-1];
  wire [ECCWIDTH-1:0]    sbits_wire;

  wire [ECCDWIDTH+ECCWIDTH-1:0]   biterr_wire;

// Generate the H Matrix in Perl

   assign ecchmatrix[0][0] = 1;
   assign ecchmatrix[1][0] = 1;
   assign ecchmatrix[2][0] = 1;
   assign ecchmatrix[3][0] = 0;
   assign ecchmatrix[4][0] = 0;
   assign ecchmatrix[5][0] = 0;
   assign ecchmatrix[6][0] = 0;
   assign ecchmatrix[7][0] = 0;
   assign ecchmatrix[8][0] = 0;
   assign ecchmatrix[9][0] = 0;
   assign ecchmatrix[0][1] = 1;
   assign ecchmatrix[1][1] = 1;
   assign ecchmatrix[2][1] = 0;
   assign ecchmatrix[3][1] = 1;
   assign ecchmatrix[4][1] = 0;
   assign ecchmatrix[5][1] = 0;
   assign ecchmatrix[6][1] = 0;
   assign ecchmatrix[7][1] = 0;
   assign ecchmatrix[8][1] = 0;
   assign ecchmatrix[9][1] = 0;
   assign ecchmatrix[0][2] = 1;
   assign ecchmatrix[1][2] = 1;
   assign ecchmatrix[2][2] = 0;
   assign ecchmatrix[3][2] = 0;
   assign ecchmatrix[4][2] = 1;
   assign ecchmatrix[5][2] = 0;
   assign ecchmatrix[6][2] = 0;
   assign ecchmatrix[7][2] = 0;
   assign ecchmatrix[8][2] = 0;
   assign ecchmatrix[9][2] = 0;
   assign ecchmatrix[0][3] = 1;
   assign ecchmatrix[1][3] = 1;
   assign ecchmatrix[2][3] = 0;
   assign ecchmatrix[3][3] = 0;
   assign ecchmatrix[4][3] = 0;
   assign ecchmatrix[5][3] = 1;
   assign ecchmatrix[6][3] = 0;
   assign ecchmatrix[7][3] = 0;
   assign ecchmatrix[8][3] = 0;
   assign ecchmatrix[9][3] = 0;
   assign ecchmatrix[0][4] = 1;
   assign ecchmatrix[1][4] = 1;
   assign ecchmatrix[2][4] = 0;
   assign ecchmatrix[3][4] = 0;
   assign ecchmatrix[4][4] = 0;
   assign ecchmatrix[5][4] = 0;
   assign ecchmatrix[6][4] = 1;
   assign ecchmatrix[7][4] = 0;
   assign ecchmatrix[8][4] = 0;
   assign ecchmatrix[9][4] = 0;
   assign ecchmatrix[0][5] = 1;
   assign ecchmatrix[1][5] = 1;
   assign ecchmatrix[2][5] = 0;
   assign ecchmatrix[3][5] = 0;
   assign ecchmatrix[4][5] = 0;
   assign ecchmatrix[5][5] = 0;
   assign ecchmatrix[6][5] = 0;
   assign ecchmatrix[7][5] = 1;
   assign ecchmatrix[8][5] = 0;
   assign ecchmatrix[9][5] = 0;
   assign ecchmatrix[0][6] = 1;
   assign ecchmatrix[1][6] = 1;
   assign ecchmatrix[2][6] = 0;
   assign ecchmatrix[3][6] = 0;
   assign ecchmatrix[4][6] = 0;
   assign ecchmatrix[5][6] = 0;
   assign ecchmatrix[6][6] = 0;
   assign ecchmatrix[7][6] = 0;
   assign ecchmatrix[8][6] = 1;
   assign ecchmatrix[9][6] = 0;
   assign ecchmatrix[0][7] = 1;
   assign ecchmatrix[1][7] = 1;
   assign ecchmatrix[2][7] = 0;
   assign ecchmatrix[3][7] = 0;
   assign ecchmatrix[4][7] = 0;
   assign ecchmatrix[5][7] = 0;
   assign ecchmatrix[6][7] = 0;
   assign ecchmatrix[7][7] = 0;
   assign ecchmatrix[8][7] = 0;
   assign ecchmatrix[9][7] = 1;
   assign ecchmatrix[0][8] = 1;
   assign ecchmatrix[1][8] = 0;
   assign ecchmatrix[2][8] = 1;
   assign ecchmatrix[3][8] = 1;
   assign ecchmatrix[4][8] = 0;
   assign ecchmatrix[5][8] = 0;
   assign ecchmatrix[6][8] = 0;
   assign ecchmatrix[7][8] = 0;
   assign ecchmatrix[8][8] = 0;
   assign ecchmatrix[9][8] = 0;
   assign ecchmatrix[0][9] = 1;
   assign ecchmatrix[1][9] = 0;
   assign ecchmatrix[2][9] = 1;
   assign ecchmatrix[3][9] = 0;
   assign ecchmatrix[4][9] = 1;
   assign ecchmatrix[5][9] = 0;
   assign ecchmatrix[6][9] = 0;
   assign ecchmatrix[7][9] = 0;
   assign ecchmatrix[8][9] = 0;
   assign ecchmatrix[9][9] = 0;
   assign ecchmatrix[0][10] = 1;
   assign ecchmatrix[1][10] = 0;
   assign ecchmatrix[2][10] = 1;
   assign ecchmatrix[3][10] = 0;
   assign ecchmatrix[4][10] = 0;
   assign ecchmatrix[5][10] = 1;
   assign ecchmatrix[6][10] = 0;
   assign ecchmatrix[7][10] = 0;
   assign ecchmatrix[8][10] = 0;
   assign ecchmatrix[9][10] = 0;
   assign ecchmatrix[0][11] = 1;
   assign ecchmatrix[1][11] = 0;
   assign ecchmatrix[2][11] = 1;
   assign ecchmatrix[3][11] = 0;
   assign ecchmatrix[4][11] = 0;
   assign ecchmatrix[5][11] = 0;
   assign ecchmatrix[6][11] = 1;
   assign ecchmatrix[7][11] = 0;
   assign ecchmatrix[8][11] = 0;
   assign ecchmatrix[9][11] = 0;
   assign ecchmatrix[0][12] = 1;
   assign ecchmatrix[1][12] = 0;
   assign ecchmatrix[2][12] = 1;
   assign ecchmatrix[3][12] = 0;
   assign ecchmatrix[4][12] = 0;
   assign ecchmatrix[5][12] = 0;
   assign ecchmatrix[6][12] = 0;
   assign ecchmatrix[7][12] = 1;
   assign ecchmatrix[8][12] = 0;
   assign ecchmatrix[9][12] = 0;
   assign ecchmatrix[0][13] = 1;
   assign ecchmatrix[1][13] = 0;
   assign ecchmatrix[2][13] = 1;
   assign ecchmatrix[3][13] = 0;
   assign ecchmatrix[4][13] = 0;
   assign ecchmatrix[5][13] = 0;
   assign ecchmatrix[6][13] = 0;
   assign ecchmatrix[7][13] = 0;
   assign ecchmatrix[8][13] = 1;
   assign ecchmatrix[9][13] = 0;
   assign ecchmatrix[0][14] = 1;
   assign ecchmatrix[1][14] = 0;
   assign ecchmatrix[2][14] = 1;
   assign ecchmatrix[3][14] = 0;
   assign ecchmatrix[4][14] = 0;
   assign ecchmatrix[5][14] = 0;
   assign ecchmatrix[6][14] = 0;
   assign ecchmatrix[7][14] = 0;
   assign ecchmatrix[8][14] = 0;
   assign ecchmatrix[9][14] = 1;
   assign ecchmatrix[0][15] = 1;
   assign ecchmatrix[1][15] = 0;
   assign ecchmatrix[2][15] = 0;
   assign ecchmatrix[3][15] = 1;
   assign ecchmatrix[4][15] = 1;
   assign ecchmatrix[5][15] = 0;
   assign ecchmatrix[6][15] = 0;
   assign ecchmatrix[7][15] = 0;
   assign ecchmatrix[8][15] = 0;
   assign ecchmatrix[9][15] = 0;
   assign ecchmatrix[0][16] = 1;
   assign ecchmatrix[1][16] = 0;
   assign ecchmatrix[2][16] = 0;
   assign ecchmatrix[3][16] = 1;
   assign ecchmatrix[4][16] = 0;
   assign ecchmatrix[5][16] = 1;
   assign ecchmatrix[6][16] = 0;
   assign ecchmatrix[7][16] = 0;
   assign ecchmatrix[8][16] = 0;
   assign ecchmatrix[9][16] = 0;
   assign ecchmatrix[0][17] = 1;
   assign ecchmatrix[1][17] = 0;
   assign ecchmatrix[2][17] = 0;
   assign ecchmatrix[3][17] = 1;
   assign ecchmatrix[4][17] = 0;
   assign ecchmatrix[5][17] = 0;
   assign ecchmatrix[6][17] = 1;
   assign ecchmatrix[7][17] = 0;
   assign ecchmatrix[8][17] = 0;
   assign ecchmatrix[9][17] = 0;
   assign ecchmatrix[0][18] = 1;
   assign ecchmatrix[1][18] = 0;
   assign ecchmatrix[2][18] = 0;
   assign ecchmatrix[3][18] = 1;
   assign ecchmatrix[4][18] = 0;
   assign ecchmatrix[5][18] = 0;
   assign ecchmatrix[6][18] = 0;
   assign ecchmatrix[7][18] = 1;
   assign ecchmatrix[8][18] = 0;
   assign ecchmatrix[9][18] = 0;
   assign ecchmatrix[0][19] = 1;
   assign ecchmatrix[1][19] = 0;
   assign ecchmatrix[2][19] = 0;
   assign ecchmatrix[3][19] = 1;
   assign ecchmatrix[4][19] = 0;
   assign ecchmatrix[5][19] = 0;
   assign ecchmatrix[6][19] = 0;
   assign ecchmatrix[7][19] = 0;
   assign ecchmatrix[8][19] = 1;
   assign ecchmatrix[9][19] = 0;
   assign ecchmatrix[0][20] = 1;
   assign ecchmatrix[1][20] = 0;
   assign ecchmatrix[2][20] = 0;
   assign ecchmatrix[3][20] = 1;
   assign ecchmatrix[4][20] = 0;
   assign ecchmatrix[5][20] = 0;
   assign ecchmatrix[6][20] = 0;
   assign ecchmatrix[7][20] = 0;
   assign ecchmatrix[8][20] = 0;
   assign ecchmatrix[9][20] = 1;
   assign ecchmatrix[0][21] = 1;
   assign ecchmatrix[1][21] = 0;
   assign ecchmatrix[2][21] = 0;
   assign ecchmatrix[3][21] = 0;
   assign ecchmatrix[4][21] = 1;
   assign ecchmatrix[5][21] = 1;
   assign ecchmatrix[6][21] = 0;
   assign ecchmatrix[7][21] = 0;
   assign ecchmatrix[8][21] = 0;
   assign ecchmatrix[9][21] = 0;
   assign ecchmatrix[0][22] = 1;
   assign ecchmatrix[1][22] = 0;
   assign ecchmatrix[2][22] = 0;
   assign ecchmatrix[3][22] = 0;
   assign ecchmatrix[4][22] = 1;
   assign ecchmatrix[5][22] = 0;
   assign ecchmatrix[6][22] = 1;
   assign ecchmatrix[7][22] = 0;
   assign ecchmatrix[8][22] = 0;
   assign ecchmatrix[9][22] = 0;
   assign ecchmatrix[0][23] = 1;
   assign ecchmatrix[1][23] = 0;
   assign ecchmatrix[2][23] = 0;
   assign ecchmatrix[3][23] = 0;
   assign ecchmatrix[4][23] = 1;
   assign ecchmatrix[5][23] = 0;
   assign ecchmatrix[6][23] = 0;
   assign ecchmatrix[7][23] = 1;
   assign ecchmatrix[8][23] = 0;
   assign ecchmatrix[9][23] = 0;
   assign ecchmatrix[0][24] = 1;
   assign ecchmatrix[1][24] = 0;
   assign ecchmatrix[2][24] = 0;
   assign ecchmatrix[3][24] = 0;
   assign ecchmatrix[4][24] = 1;
   assign ecchmatrix[5][24] = 0;
   assign ecchmatrix[6][24] = 0;
   assign ecchmatrix[7][24] = 0;
   assign ecchmatrix[8][24] = 1;
   assign ecchmatrix[9][24] = 0;
   assign ecchmatrix[0][25] = 1;
   assign ecchmatrix[1][25] = 0;
   assign ecchmatrix[2][25] = 0;
   assign ecchmatrix[3][25] = 0;
   assign ecchmatrix[4][25] = 1;
   assign ecchmatrix[5][25] = 0;
   assign ecchmatrix[6][25] = 0;
   assign ecchmatrix[7][25] = 0;
   assign ecchmatrix[8][25] = 0;
   assign ecchmatrix[9][25] = 1;
   assign ecchmatrix[0][26] = 1;
   assign ecchmatrix[1][26] = 0;
   assign ecchmatrix[2][26] = 0;
   assign ecchmatrix[3][26] = 0;
   assign ecchmatrix[4][26] = 0;
   assign ecchmatrix[5][26] = 1;
   assign ecchmatrix[6][26] = 1;
   assign ecchmatrix[7][26] = 0;
   assign ecchmatrix[8][26] = 0;
   assign ecchmatrix[9][26] = 0;
   assign ecchmatrix[0][27] = 1;
   assign ecchmatrix[1][27] = 0;
   assign ecchmatrix[2][27] = 0;
   assign ecchmatrix[3][27] = 0;
   assign ecchmatrix[4][27] = 0;
   assign ecchmatrix[5][27] = 1;
   assign ecchmatrix[6][27] = 0;
   assign ecchmatrix[7][27] = 1;
   assign ecchmatrix[8][27] = 0;
   assign ecchmatrix[9][27] = 0;
   assign ecchmatrix[0][28] = 1;
   assign ecchmatrix[1][28] = 0;
   assign ecchmatrix[2][28] = 0;
   assign ecchmatrix[3][28] = 0;
   assign ecchmatrix[4][28] = 0;
   assign ecchmatrix[5][28] = 1;
   assign ecchmatrix[6][28] = 0;
   assign ecchmatrix[7][28] = 0;
   assign ecchmatrix[8][28] = 1;
   assign ecchmatrix[9][28] = 0;
   assign ecchmatrix[0][29] = 1;
   assign ecchmatrix[1][29] = 0;
   assign ecchmatrix[2][29] = 0;
   assign ecchmatrix[3][29] = 0;
   assign ecchmatrix[4][29] = 0;
   assign ecchmatrix[5][29] = 1;
   assign ecchmatrix[6][29] = 0;
   assign ecchmatrix[7][29] = 0;
   assign ecchmatrix[8][29] = 0;
   assign ecchmatrix[9][29] = 1;
   assign ecchmatrix[0][30] = 1;
   assign ecchmatrix[1][30] = 0;
   assign ecchmatrix[2][30] = 0;
   assign ecchmatrix[3][30] = 0;
   assign ecchmatrix[4][30] = 0;
   assign ecchmatrix[5][30] = 0;
   assign ecchmatrix[6][30] = 1;
   assign ecchmatrix[7][30] = 1;
   assign ecchmatrix[8][30] = 0;
   assign ecchmatrix[9][30] = 0;
   assign ecchmatrix[0][31] = 1;
   assign ecchmatrix[1][31] = 0;
   assign ecchmatrix[2][31] = 0;
   assign ecchmatrix[3][31] = 0;
   assign ecchmatrix[4][31] = 0;
   assign ecchmatrix[5][31] = 0;
   assign ecchmatrix[6][31] = 1;
   assign ecchmatrix[7][31] = 0;
   assign ecchmatrix[8][31] = 1;
   assign ecchmatrix[9][31] = 0;
   assign ecchmatrix[0][32] = 1;
   assign ecchmatrix[1][32] = 0;
   assign ecchmatrix[2][32] = 0;
   assign ecchmatrix[3][32] = 0;
   assign ecchmatrix[4][32] = 0;
   assign ecchmatrix[5][32] = 0;
   assign ecchmatrix[6][32] = 1;
   assign ecchmatrix[7][32] = 0;
   assign ecchmatrix[8][32] = 0;
   assign ecchmatrix[9][32] = 1;
   assign ecchmatrix[0][33] = 1;
   assign ecchmatrix[1][33] = 0;
   assign ecchmatrix[2][33] = 0;
   assign ecchmatrix[3][33] = 0;
   assign ecchmatrix[4][33] = 0;
   assign ecchmatrix[5][33] = 0;
   assign ecchmatrix[6][33] = 0;
   assign ecchmatrix[7][33] = 1;
   assign ecchmatrix[8][33] = 1;
   assign ecchmatrix[9][33] = 0;
   assign ecchmatrix[0][34] = 1;
   assign ecchmatrix[1][34] = 0;
   assign ecchmatrix[2][34] = 0;
   assign ecchmatrix[3][34] = 0;
   assign ecchmatrix[4][34] = 0;
   assign ecchmatrix[5][34] = 0;
   assign ecchmatrix[6][34] = 0;
   assign ecchmatrix[7][34] = 1;
   assign ecchmatrix[8][34] = 0;
   assign ecchmatrix[9][34] = 1;
   assign ecchmatrix[0][35] = 1;
   assign ecchmatrix[1][35] = 0;
   assign ecchmatrix[2][35] = 0;
   assign ecchmatrix[3][35] = 0;
   assign ecchmatrix[4][35] = 0;
   assign ecchmatrix[5][35] = 0;
   assign ecchmatrix[6][35] = 0;
   assign ecchmatrix[7][35] = 0;
   assign ecchmatrix[8][35] = 1;
   assign ecchmatrix[9][35] = 1;
   assign ecchmatrix[0][36] = 0;
   assign ecchmatrix[1][36] = 1;
   assign ecchmatrix[2][36] = 1;
   assign ecchmatrix[3][36] = 1;
   assign ecchmatrix[4][36] = 0;
   assign ecchmatrix[5][36] = 0;
   assign ecchmatrix[6][36] = 0;
   assign ecchmatrix[7][36] = 0;
   assign ecchmatrix[8][36] = 0;
   assign ecchmatrix[9][36] = 0;
   assign ecchmatrix[0][37] = 0;
   assign ecchmatrix[1][37] = 1;
   assign ecchmatrix[2][37] = 1;
   assign ecchmatrix[3][37] = 0;
   assign ecchmatrix[4][37] = 1;
   assign ecchmatrix[5][37] = 0;
   assign ecchmatrix[6][37] = 0;
   assign ecchmatrix[7][37] = 0;
   assign ecchmatrix[8][37] = 0;
   assign ecchmatrix[9][37] = 0;
   assign ecchmatrix[0][38] = 0;
   assign ecchmatrix[1][38] = 1;
   assign ecchmatrix[2][38] = 1;
   assign ecchmatrix[3][38] = 0;
   assign ecchmatrix[4][38] = 0;
   assign ecchmatrix[5][38] = 1;
   assign ecchmatrix[6][38] = 0;
   assign ecchmatrix[7][38] = 0;
   assign ecchmatrix[8][38] = 0;
   assign ecchmatrix[9][38] = 0;
   assign ecchmatrix[0][39] = 0;
   assign ecchmatrix[1][39] = 1;
   assign ecchmatrix[2][39] = 1;
   assign ecchmatrix[3][39] = 0;
   assign ecchmatrix[4][39] = 0;
   assign ecchmatrix[5][39] = 0;
   assign ecchmatrix[6][39] = 1;
   assign ecchmatrix[7][39] = 0;
   assign ecchmatrix[8][39] = 0;
   assign ecchmatrix[9][39] = 0;
   assign ecchmatrix[0][40] = 0;
   assign ecchmatrix[1][40] = 1;
   assign ecchmatrix[2][40] = 1;
   assign ecchmatrix[3][40] = 0;
   assign ecchmatrix[4][40] = 0;
   assign ecchmatrix[5][40] = 0;
   assign ecchmatrix[6][40] = 0;
   assign ecchmatrix[7][40] = 1;
   assign ecchmatrix[8][40] = 0;
   assign ecchmatrix[9][40] = 0;
   assign ecchmatrix[0][41] = 0;
   assign ecchmatrix[1][41] = 1;
   assign ecchmatrix[2][41] = 1;
   assign ecchmatrix[3][41] = 0;
   assign ecchmatrix[4][41] = 0;
   assign ecchmatrix[5][41] = 0;
   assign ecchmatrix[6][41] = 0;
   assign ecchmatrix[7][41] = 0;
   assign ecchmatrix[8][41] = 1;
   assign ecchmatrix[9][41] = 0;
   assign ecchmatrix[0][42] = 0;
   assign ecchmatrix[1][42] = 1;
   assign ecchmatrix[2][42] = 1;
   assign ecchmatrix[3][42] = 0;
   assign ecchmatrix[4][42] = 0;
   assign ecchmatrix[5][42] = 0;
   assign ecchmatrix[6][42] = 0;
   assign ecchmatrix[7][42] = 0;
   assign ecchmatrix[8][42] = 0;
   assign ecchmatrix[9][42] = 1;
   assign ecchmatrix[0][43] = 0;
   assign ecchmatrix[1][43] = 1;
   assign ecchmatrix[2][43] = 0;
   assign ecchmatrix[3][43] = 1;
   assign ecchmatrix[4][43] = 1;
   assign ecchmatrix[5][43] = 0;
   assign ecchmatrix[6][43] = 0;
   assign ecchmatrix[7][43] = 0;
   assign ecchmatrix[8][43] = 0;
   assign ecchmatrix[9][43] = 0;
   assign ecchmatrix[0][44] = 0;
   assign ecchmatrix[1][44] = 1;
   assign ecchmatrix[2][44] = 0;
   assign ecchmatrix[3][44] = 1;
   assign ecchmatrix[4][44] = 0;
   assign ecchmatrix[5][44] = 1;
   assign ecchmatrix[6][44] = 0;
   assign ecchmatrix[7][44] = 0;
   assign ecchmatrix[8][44] = 0;
   assign ecchmatrix[9][44] = 0;
   assign ecchmatrix[0][45] = 0;
   assign ecchmatrix[1][45] = 1;
   assign ecchmatrix[2][45] = 0;
   assign ecchmatrix[3][45] = 1;
   assign ecchmatrix[4][45] = 0;
   assign ecchmatrix[5][45] = 0;
   assign ecchmatrix[6][45] = 1;
   assign ecchmatrix[7][45] = 0;
   assign ecchmatrix[8][45] = 0;
   assign ecchmatrix[9][45] = 0;
   assign ecchmatrix[0][46] = 0;
   assign ecchmatrix[1][46] = 1;
   assign ecchmatrix[2][46] = 0;
   assign ecchmatrix[3][46] = 1;
   assign ecchmatrix[4][46] = 0;
   assign ecchmatrix[5][46] = 0;
   assign ecchmatrix[6][46] = 0;
   assign ecchmatrix[7][46] = 1;
   assign ecchmatrix[8][46] = 0;
   assign ecchmatrix[9][46] = 0;
   assign ecchmatrix[0][47] = 0;
   assign ecchmatrix[1][47] = 1;
   assign ecchmatrix[2][47] = 0;
   assign ecchmatrix[3][47] = 1;
   assign ecchmatrix[4][47] = 0;
   assign ecchmatrix[5][47] = 0;
   assign ecchmatrix[6][47] = 0;
   assign ecchmatrix[7][47] = 0;
   assign ecchmatrix[8][47] = 1;
   assign ecchmatrix[9][47] = 0;
   assign ecchmatrix[0][48] = 0;
   assign ecchmatrix[1][48] = 1;
   assign ecchmatrix[2][48] = 0;
   assign ecchmatrix[3][48] = 1;
   assign ecchmatrix[4][48] = 0;
   assign ecchmatrix[5][48] = 0;
   assign ecchmatrix[6][48] = 0;
   assign ecchmatrix[7][48] = 0;
   assign ecchmatrix[8][48] = 0;
   assign ecchmatrix[9][48] = 1;
   assign ecchmatrix[0][49] = 0;
   assign ecchmatrix[1][49] = 1;
   assign ecchmatrix[2][49] = 0;
   assign ecchmatrix[3][49] = 0;
   assign ecchmatrix[4][49] = 1;
   assign ecchmatrix[5][49] = 1;
   assign ecchmatrix[6][49] = 0;
   assign ecchmatrix[7][49] = 0;
   assign ecchmatrix[8][49] = 0;
   assign ecchmatrix[9][49] = 0;
   assign ecchmatrix[0][50] = 0;
   assign ecchmatrix[1][50] = 1;
   assign ecchmatrix[2][50] = 0;
   assign ecchmatrix[3][50] = 0;
   assign ecchmatrix[4][50] = 1;
   assign ecchmatrix[5][50] = 0;
   assign ecchmatrix[6][50] = 1;
   assign ecchmatrix[7][50] = 0;
   assign ecchmatrix[8][50] = 0;
   assign ecchmatrix[9][50] = 0;
   assign ecchmatrix[0][51] = 0;
   assign ecchmatrix[1][51] = 1;
   assign ecchmatrix[2][51] = 0;
   assign ecchmatrix[3][51] = 0;
   assign ecchmatrix[4][51] = 1;
   assign ecchmatrix[5][51] = 0;
   assign ecchmatrix[6][51] = 0;
   assign ecchmatrix[7][51] = 1;
   assign ecchmatrix[8][51] = 0;
   assign ecchmatrix[9][51] = 0;
   assign ecchmatrix[0][52] = 0;
   assign ecchmatrix[1][52] = 1;
   assign ecchmatrix[2][52] = 0;
   assign ecchmatrix[3][52] = 0;
   assign ecchmatrix[4][52] = 1;
   assign ecchmatrix[5][52] = 0;
   assign ecchmatrix[6][52] = 0;
   assign ecchmatrix[7][52] = 0;
   assign ecchmatrix[8][52] = 1;
   assign ecchmatrix[9][52] = 0;
   assign ecchmatrix[0][53] = 0;
   assign ecchmatrix[1][53] = 1;
   assign ecchmatrix[2][53] = 0;
   assign ecchmatrix[3][53] = 0;
   assign ecchmatrix[4][53] = 1;
   assign ecchmatrix[5][53] = 0;
   assign ecchmatrix[6][53] = 0;
   assign ecchmatrix[7][53] = 0;
   assign ecchmatrix[8][53] = 0;
   assign ecchmatrix[9][53] = 1;
   assign ecchmatrix[0][54] = 0;
   assign ecchmatrix[1][54] = 1;
   assign ecchmatrix[2][54] = 0;
   assign ecchmatrix[3][54] = 0;
   assign ecchmatrix[4][54] = 0;
   assign ecchmatrix[5][54] = 1;
   assign ecchmatrix[6][54] = 1;
   assign ecchmatrix[7][54] = 0;
   assign ecchmatrix[8][54] = 0;
   assign ecchmatrix[9][54] = 0;
   assign ecchmatrix[0][55] = 0;
   assign ecchmatrix[1][55] = 1;
   assign ecchmatrix[2][55] = 0;
   assign ecchmatrix[3][55] = 0;
   assign ecchmatrix[4][55] = 0;
   assign ecchmatrix[5][55] = 1;
   assign ecchmatrix[6][55] = 0;
   assign ecchmatrix[7][55] = 1;
   assign ecchmatrix[8][55] = 0;
   assign ecchmatrix[9][55] = 0;
   assign ecchmatrix[0][56] = 0;
   assign ecchmatrix[1][56] = 1;
   assign ecchmatrix[2][56] = 0;
   assign ecchmatrix[3][56] = 0;
   assign ecchmatrix[4][56] = 0;
   assign ecchmatrix[5][56] = 1;
   assign ecchmatrix[6][56] = 0;
   assign ecchmatrix[7][56] = 0;
   assign ecchmatrix[8][56] = 1;
   assign ecchmatrix[9][56] = 0;
   assign ecchmatrix[0][57] = 0;
   assign ecchmatrix[1][57] = 1;
   assign ecchmatrix[2][57] = 0;
   assign ecchmatrix[3][57] = 0;
   assign ecchmatrix[4][57] = 0;
   assign ecchmatrix[5][57] = 1;
   assign ecchmatrix[6][57] = 0;
   assign ecchmatrix[7][57] = 0;
   assign ecchmatrix[8][57] = 0;
   assign ecchmatrix[9][57] = 1;
   assign ecchmatrix[0][58] = 0;
   assign ecchmatrix[1][58] = 1;
   assign ecchmatrix[2][58] = 0;
   assign ecchmatrix[3][58] = 0;
   assign ecchmatrix[4][58] = 0;
   assign ecchmatrix[5][58] = 0;
   assign ecchmatrix[6][58] = 1;
   assign ecchmatrix[7][58] = 1;
   assign ecchmatrix[8][58] = 0;
   assign ecchmatrix[9][58] = 0;
   assign ecchmatrix[0][59] = 0;
   assign ecchmatrix[1][59] = 1;
   assign ecchmatrix[2][59] = 0;
   assign ecchmatrix[3][59] = 0;
   assign ecchmatrix[4][59] = 0;
   assign ecchmatrix[5][59] = 0;
   assign ecchmatrix[6][59] = 1;
   assign ecchmatrix[7][59] = 0;
   assign ecchmatrix[8][59] = 1;
   assign ecchmatrix[9][59] = 0;
   assign ecchmatrix[0][60] = 0;
   assign ecchmatrix[1][60] = 1;
   assign ecchmatrix[2][60] = 0;
   assign ecchmatrix[3][60] = 0;
   assign ecchmatrix[4][60] = 0;
   assign ecchmatrix[5][60] = 0;
   assign ecchmatrix[6][60] = 1;
   assign ecchmatrix[7][60] = 0;
   assign ecchmatrix[8][60] = 0;
   assign ecchmatrix[9][60] = 1;
   assign ecchmatrix[0][61] = 0;
   assign ecchmatrix[1][61] = 1;
   assign ecchmatrix[2][61] = 0;
   assign ecchmatrix[3][61] = 0;
   assign ecchmatrix[4][61] = 0;
   assign ecchmatrix[5][61] = 0;
   assign ecchmatrix[6][61] = 0;
   assign ecchmatrix[7][61] = 1;
   assign ecchmatrix[8][61] = 1;
   assign ecchmatrix[9][61] = 0;
   assign ecchmatrix[0][62] = 0;
   assign ecchmatrix[1][62] = 1;
   assign ecchmatrix[2][62] = 0;
   assign ecchmatrix[3][62] = 0;
   assign ecchmatrix[4][62] = 0;
   assign ecchmatrix[5][62] = 0;
   assign ecchmatrix[6][62] = 0;
   assign ecchmatrix[7][62] = 1;
   assign ecchmatrix[8][62] = 0;
   assign ecchmatrix[9][62] = 1;
   assign ecchmatrix[0][63] = 0;
   assign ecchmatrix[1][63] = 1;
   assign ecchmatrix[2][63] = 0;
   assign ecchmatrix[3][63] = 0;
   assign ecchmatrix[4][63] = 0;
   assign ecchmatrix[5][63] = 0;
   assign ecchmatrix[6][63] = 0;
   assign ecchmatrix[7][63] = 0;
   assign ecchmatrix[8][63] = 1;
   assign ecchmatrix[9][63] = 1;
   assign ecchmatrix[0][64] = 0;
   assign ecchmatrix[1][64] = 0;
   assign ecchmatrix[2][64] = 1;
   assign ecchmatrix[3][64] = 1;
   assign ecchmatrix[4][64] = 1;
   assign ecchmatrix[5][64] = 0;
   assign ecchmatrix[6][64] = 0;
   assign ecchmatrix[7][64] = 0;
   assign ecchmatrix[8][64] = 0;
   assign ecchmatrix[9][64] = 0;
   assign ecchmatrix[0][65] = 0;
   assign ecchmatrix[1][65] = 0;
   assign ecchmatrix[2][65] = 1;
   assign ecchmatrix[3][65] = 1;
   assign ecchmatrix[4][65] = 0;
   assign ecchmatrix[5][65] = 1;
   assign ecchmatrix[6][65] = 0;
   assign ecchmatrix[7][65] = 0;
   assign ecchmatrix[8][65] = 0;
   assign ecchmatrix[9][65] = 0;
   assign ecchmatrix[0][66] = 0;
   assign ecchmatrix[1][66] = 0;
   assign ecchmatrix[2][66] = 1;
   assign ecchmatrix[3][66] = 1;
   assign ecchmatrix[4][66] = 0;
   assign ecchmatrix[5][66] = 0;
   assign ecchmatrix[6][66] = 1;
   assign ecchmatrix[7][66] = 0;
   assign ecchmatrix[8][66] = 0;
   assign ecchmatrix[9][66] = 0;
   assign ecchmatrix[0][67] = 0;
   assign ecchmatrix[1][67] = 0;
   assign ecchmatrix[2][67] = 1;
   assign ecchmatrix[3][67] = 1;
   assign ecchmatrix[4][67] = 0;
   assign ecchmatrix[5][67] = 0;
   assign ecchmatrix[6][67] = 0;
   assign ecchmatrix[7][67] = 1;
   assign ecchmatrix[8][67] = 0;
   assign ecchmatrix[9][67] = 0;
   assign ecchmatrix[0][68] = 0;
   assign ecchmatrix[1][68] = 0;
   assign ecchmatrix[2][68] = 1;
   assign ecchmatrix[3][68] = 1;
   assign ecchmatrix[4][68] = 0;
   assign ecchmatrix[5][68] = 0;
   assign ecchmatrix[6][68] = 0;
   assign ecchmatrix[7][68] = 0;
   assign ecchmatrix[8][68] = 1;
   assign ecchmatrix[9][68] = 0;
   assign ecchmatrix[0][69] = 0;
   assign ecchmatrix[1][69] = 0;
   assign ecchmatrix[2][69] = 1;
   assign ecchmatrix[3][69] = 1;
   assign ecchmatrix[4][69] = 0;
   assign ecchmatrix[5][69] = 0;
   assign ecchmatrix[6][69] = 0;
   assign ecchmatrix[7][69] = 0;
   assign ecchmatrix[8][69] = 0;
   assign ecchmatrix[9][69] = 1;
   assign ecchmatrix[0][70] = 0;
   assign ecchmatrix[1][70] = 0;
   assign ecchmatrix[2][70] = 1;
   assign ecchmatrix[3][70] = 0;
   assign ecchmatrix[4][70] = 1;
   assign ecchmatrix[5][70] = 1;
   assign ecchmatrix[6][70] = 0;
   assign ecchmatrix[7][70] = 0;
   assign ecchmatrix[8][70] = 0;
   assign ecchmatrix[9][70] = 0;
   assign ecchmatrix[0][71] = 0;
   assign ecchmatrix[1][71] = 0;
   assign ecchmatrix[2][71] = 1;
   assign ecchmatrix[3][71] = 0;
   assign ecchmatrix[4][71] = 1;
   assign ecchmatrix[5][71] = 0;
   assign ecchmatrix[6][71] = 1;
   assign ecchmatrix[7][71] = 0;
   assign ecchmatrix[8][71] = 0;
   assign ecchmatrix[9][71] = 0;
   assign ecchmatrix[0][72] = 0;
   assign ecchmatrix[1][72] = 0;
   assign ecchmatrix[2][72] = 1;
   assign ecchmatrix[3][72] = 0;
   assign ecchmatrix[4][72] = 1;
   assign ecchmatrix[5][72] = 0;
   assign ecchmatrix[6][72] = 0;
   assign ecchmatrix[7][72] = 1;
   assign ecchmatrix[8][72] = 0;
   assign ecchmatrix[9][72] = 0;
   assign ecchmatrix[0][73] = 0;
   assign ecchmatrix[1][73] = 0;
   assign ecchmatrix[2][73] = 1;
   assign ecchmatrix[3][73] = 0;
   assign ecchmatrix[4][73] = 1;
   assign ecchmatrix[5][73] = 0;
   assign ecchmatrix[6][73] = 0;
   assign ecchmatrix[7][73] = 0;
   assign ecchmatrix[8][73] = 1;
   assign ecchmatrix[9][73] = 0;
   assign ecchmatrix[0][74] = 0;
   assign ecchmatrix[1][74] = 0;
   assign ecchmatrix[2][74] = 1;
   assign ecchmatrix[3][74] = 0;
   assign ecchmatrix[4][74] = 1;
   assign ecchmatrix[5][74] = 0;
   assign ecchmatrix[6][74] = 0;
   assign ecchmatrix[7][74] = 0;
   assign ecchmatrix[8][74] = 0;
   assign ecchmatrix[9][74] = 1;
   assign ecchmatrix[0][75] = 0;
   assign ecchmatrix[1][75] = 0;
   assign ecchmatrix[2][75] = 1;
   assign ecchmatrix[3][75] = 0;
   assign ecchmatrix[4][75] = 0;
   assign ecchmatrix[5][75] = 1;
   assign ecchmatrix[6][75] = 1;
   assign ecchmatrix[7][75] = 0;
   assign ecchmatrix[8][75] = 0;
   assign ecchmatrix[9][75] = 0;
   assign ecchmatrix[0][76] = 0;
   assign ecchmatrix[1][76] = 0;
   assign ecchmatrix[2][76] = 1;
   assign ecchmatrix[3][76] = 0;
   assign ecchmatrix[4][76] = 0;
   assign ecchmatrix[5][76] = 1;
   assign ecchmatrix[6][76] = 0;
   assign ecchmatrix[7][76] = 1;
   assign ecchmatrix[8][76] = 0;
   assign ecchmatrix[9][76] = 0;
   assign ecchmatrix[0][77] = 0;
   assign ecchmatrix[1][77] = 0;
   assign ecchmatrix[2][77] = 1;
   assign ecchmatrix[3][77] = 0;
   assign ecchmatrix[4][77] = 0;
   assign ecchmatrix[5][77] = 1;
   assign ecchmatrix[6][77] = 0;
   assign ecchmatrix[7][77] = 0;
   assign ecchmatrix[8][77] = 1;
   assign ecchmatrix[9][77] = 0;
   assign ecchmatrix[0][78] = 0;
   assign ecchmatrix[1][78] = 0;
   assign ecchmatrix[2][78] = 1;
   assign ecchmatrix[3][78] = 0;
   assign ecchmatrix[4][78] = 0;
   assign ecchmatrix[5][78] = 1;
   assign ecchmatrix[6][78] = 0;
   assign ecchmatrix[7][78] = 0;
   assign ecchmatrix[8][78] = 0;
   assign ecchmatrix[9][78] = 1;
   assign ecchmatrix[0][79] = 0;
   assign ecchmatrix[1][79] = 0;
   assign ecchmatrix[2][79] = 1;
   assign ecchmatrix[3][79] = 0;
   assign ecchmatrix[4][79] = 0;
   assign ecchmatrix[5][79] = 0;
   assign ecchmatrix[6][79] = 1;
   assign ecchmatrix[7][79] = 1;
   assign ecchmatrix[8][79] = 0;
   assign ecchmatrix[9][79] = 0;
   assign ecchmatrix[0][80] = 0;
   assign ecchmatrix[1][80] = 0;
   assign ecchmatrix[2][80] = 1;
   assign ecchmatrix[3][80] = 0;
   assign ecchmatrix[4][80] = 0;
   assign ecchmatrix[5][80] = 0;
   assign ecchmatrix[6][80] = 1;
   assign ecchmatrix[7][80] = 0;
   assign ecchmatrix[8][80] = 1;
   assign ecchmatrix[9][80] = 0;
   assign ecchmatrix[0][81] = 0;
   assign ecchmatrix[1][81] = 0;
   assign ecchmatrix[2][81] = 1;
   assign ecchmatrix[3][81] = 0;
   assign ecchmatrix[4][81] = 0;
   assign ecchmatrix[5][81] = 0;
   assign ecchmatrix[6][81] = 1;
   assign ecchmatrix[7][81] = 0;
   assign ecchmatrix[8][81] = 0;
   assign ecchmatrix[9][81] = 1;
   assign ecchmatrix[0][82] = 0;
   assign ecchmatrix[1][82] = 0;
   assign ecchmatrix[2][82] = 1;
   assign ecchmatrix[3][82] = 0;
   assign ecchmatrix[4][82] = 0;
   assign ecchmatrix[5][82] = 0;
   assign ecchmatrix[6][82] = 0;
   assign ecchmatrix[7][82] = 1;
   assign ecchmatrix[8][82] = 1;
   assign ecchmatrix[9][82] = 0;
   assign ecchmatrix[0][83] = 0;
   assign ecchmatrix[1][83] = 0;
   assign ecchmatrix[2][83] = 1;
   assign ecchmatrix[3][83] = 0;
   assign ecchmatrix[4][83] = 0;
   assign ecchmatrix[5][83] = 0;
   assign ecchmatrix[6][83] = 0;
   assign ecchmatrix[7][83] = 1;
   assign ecchmatrix[8][83] = 0;
   assign ecchmatrix[9][83] = 1;
   assign ecchmatrix[0][84] = 0;
   assign ecchmatrix[1][84] = 0;
   assign ecchmatrix[2][84] = 1;
   assign ecchmatrix[3][84] = 0;
   assign ecchmatrix[4][84] = 0;
   assign ecchmatrix[5][84] = 0;
   assign ecchmatrix[6][84] = 0;
   assign ecchmatrix[7][84] = 0;
   assign ecchmatrix[8][84] = 1;
   assign ecchmatrix[9][84] = 1;
   assign ecchmatrix[0][85] = 0;
   assign ecchmatrix[1][85] = 0;
   assign ecchmatrix[2][85] = 0;
   assign ecchmatrix[3][85] = 1;
   assign ecchmatrix[4][85] = 1;
   assign ecchmatrix[5][85] = 1;
   assign ecchmatrix[6][85] = 0;
   assign ecchmatrix[7][85] = 0;
   assign ecchmatrix[8][85] = 0;
   assign ecchmatrix[9][85] = 0;
   assign ecchmatrix[0][86] = 0;
   assign ecchmatrix[1][86] = 0;
   assign ecchmatrix[2][86] = 0;
   assign ecchmatrix[3][86] = 1;
   assign ecchmatrix[4][86] = 1;
   assign ecchmatrix[5][86] = 0;
   assign ecchmatrix[6][86] = 1;
   assign ecchmatrix[7][86] = 0;
   assign ecchmatrix[8][86] = 0;
   assign ecchmatrix[9][86] = 0;
   assign ecchmatrix[0][87] = 0;
   assign ecchmatrix[1][87] = 0;
   assign ecchmatrix[2][87] = 0;
   assign ecchmatrix[3][87] = 1;
   assign ecchmatrix[4][87] = 1;
   assign ecchmatrix[5][87] = 0;
   assign ecchmatrix[6][87] = 0;
   assign ecchmatrix[7][87] = 1;
   assign ecchmatrix[8][87] = 0;
   assign ecchmatrix[9][87] = 0;
   assign ecchmatrix[0][88] = 0;
   assign ecchmatrix[1][88] = 0;
   assign ecchmatrix[2][88] = 0;
   assign ecchmatrix[3][88] = 1;
   assign ecchmatrix[4][88] = 1;
   assign ecchmatrix[5][88] = 0;
   assign ecchmatrix[6][88] = 0;
   assign ecchmatrix[7][88] = 0;
   assign ecchmatrix[8][88] = 1;
   assign ecchmatrix[9][88] = 0;
   assign ecchmatrix[0][89] = 0;
   assign ecchmatrix[1][89] = 0;
   assign ecchmatrix[2][89] = 0;
   assign ecchmatrix[3][89] = 1;
   assign ecchmatrix[4][89] = 1;
   assign ecchmatrix[5][89] = 0;
   assign ecchmatrix[6][89] = 0;
   assign ecchmatrix[7][89] = 0;
   assign ecchmatrix[8][89] = 0;
   assign ecchmatrix[9][89] = 1;
   assign ecchmatrix[0][90] = 0;
   assign ecchmatrix[1][90] = 0;
   assign ecchmatrix[2][90] = 0;
   assign ecchmatrix[3][90] = 1;
   assign ecchmatrix[4][90] = 0;
   assign ecchmatrix[5][90] = 1;
   assign ecchmatrix[6][90] = 1;
   assign ecchmatrix[7][90] = 0;
   assign ecchmatrix[8][90] = 0;
   assign ecchmatrix[9][90] = 0;
   assign ecchmatrix[0][91] = 0;
   assign ecchmatrix[1][91] = 0;
   assign ecchmatrix[2][91] = 0;
   assign ecchmatrix[3][91] = 1;
   assign ecchmatrix[4][91] = 0;
   assign ecchmatrix[5][91] = 1;
   assign ecchmatrix[6][91] = 0;
   assign ecchmatrix[7][91] = 1;
   assign ecchmatrix[8][91] = 0;
   assign ecchmatrix[9][91] = 0;
   assign ecchmatrix[0][92] = 0;
   assign ecchmatrix[1][92] = 0;
   assign ecchmatrix[2][92] = 0;
   assign ecchmatrix[3][92] = 1;
   assign ecchmatrix[4][92] = 0;
   assign ecchmatrix[5][92] = 1;
   assign ecchmatrix[6][92] = 0;
   assign ecchmatrix[7][92] = 0;
   assign ecchmatrix[8][92] = 1;
   assign ecchmatrix[9][92] = 0;
   assign ecchmatrix[0][93] = 0;
   assign ecchmatrix[1][93] = 0;
   assign ecchmatrix[2][93] = 0;
   assign ecchmatrix[3][93] = 1;
   assign ecchmatrix[4][93] = 0;
   assign ecchmatrix[5][93] = 1;
   assign ecchmatrix[6][93] = 0;
   assign ecchmatrix[7][93] = 0;
   assign ecchmatrix[8][93] = 0;
   assign ecchmatrix[9][93] = 1;
   assign ecchmatrix[0][94] = 0;
   assign ecchmatrix[1][94] = 0;
   assign ecchmatrix[2][94] = 0;
   assign ecchmatrix[3][94] = 1;
   assign ecchmatrix[4][94] = 0;
   assign ecchmatrix[5][94] = 0;
   assign ecchmatrix[6][94] = 1;
   assign ecchmatrix[7][94] = 1;
   assign ecchmatrix[8][94] = 0;
   assign ecchmatrix[9][94] = 0;
   assign ecchmatrix[0][95] = 0;
   assign ecchmatrix[1][95] = 0;
   assign ecchmatrix[2][95] = 0;
   assign ecchmatrix[3][95] = 1;
   assign ecchmatrix[4][95] = 0;
   assign ecchmatrix[5][95] = 0;
   assign ecchmatrix[6][95] = 1;
   assign ecchmatrix[7][95] = 0;
   assign ecchmatrix[8][95] = 1;
   assign ecchmatrix[9][95] = 0;
   assign ecchmatrix[0][96] = 0;
   assign ecchmatrix[1][96] = 0;
   assign ecchmatrix[2][96] = 0;
   assign ecchmatrix[3][96] = 1;
   assign ecchmatrix[4][96] = 0;
   assign ecchmatrix[5][96] = 0;
   assign ecchmatrix[6][96] = 1;
   assign ecchmatrix[7][96] = 0;
   assign ecchmatrix[8][96] = 0;
   assign ecchmatrix[9][96] = 1;
   assign ecchmatrix[0][97] = 0;
   assign ecchmatrix[1][97] = 0;
   assign ecchmatrix[2][97] = 0;
   assign ecchmatrix[3][97] = 1;
   assign ecchmatrix[4][97] = 0;
   assign ecchmatrix[5][97] = 0;
   assign ecchmatrix[6][97] = 0;
   assign ecchmatrix[7][97] = 1;
   assign ecchmatrix[8][97] = 1;
   assign ecchmatrix[9][97] = 0;
   assign ecchmatrix[0][98] = 0;
   assign ecchmatrix[1][98] = 0;
   assign ecchmatrix[2][98] = 0;
   assign ecchmatrix[3][98] = 1;
   assign ecchmatrix[4][98] = 0;
   assign ecchmatrix[5][98] = 0;
   assign ecchmatrix[6][98] = 0;
   assign ecchmatrix[7][98] = 1;
   assign ecchmatrix[8][98] = 0;
   assign ecchmatrix[9][98] = 1;
   assign ecchmatrix[0][99] = 0;
   assign ecchmatrix[1][99] = 0;
   assign ecchmatrix[2][99] = 0;
   assign ecchmatrix[3][99] = 1;
   assign ecchmatrix[4][99] = 0;
   assign ecchmatrix[5][99] = 0;
   assign ecchmatrix[6][99] = 0;
   assign ecchmatrix[7][99] = 0;
   assign ecchmatrix[8][99] = 1;
   assign ecchmatrix[9][99] = 1;
   assign ecchmatrix[0][100] = 0;
   assign ecchmatrix[1][100] = 0;
   assign ecchmatrix[2][100] = 0;
   assign ecchmatrix[3][100] = 0;
   assign ecchmatrix[4][100] = 1;
   assign ecchmatrix[5][100] = 1;
   assign ecchmatrix[6][100] = 1;
   assign ecchmatrix[7][100] = 0;
   assign ecchmatrix[8][100] = 0;
   assign ecchmatrix[9][100] = 0;
   assign ecchmatrix[0][101] = 0;
   assign ecchmatrix[1][101] = 0;
   assign ecchmatrix[2][101] = 0;
   assign ecchmatrix[3][101] = 0;
   assign ecchmatrix[4][101] = 1;
   assign ecchmatrix[5][101] = 1;
   assign ecchmatrix[6][101] = 0;
   assign ecchmatrix[7][101] = 1;
   assign ecchmatrix[8][101] = 0;
   assign ecchmatrix[9][101] = 0;
   assign ecchmatrix[0][102] = 0;
   assign ecchmatrix[1][102] = 0;
   assign ecchmatrix[2][102] = 0;
   assign ecchmatrix[3][102] = 0;
   assign ecchmatrix[4][102] = 1;
   assign ecchmatrix[5][102] = 1;
   assign ecchmatrix[6][102] = 0;
   assign ecchmatrix[7][102] = 0;
   assign ecchmatrix[8][102] = 1;
   assign ecchmatrix[9][102] = 0;
   assign ecchmatrix[0][103] = 0;
   assign ecchmatrix[1][103] = 0;
   assign ecchmatrix[2][103] = 0;
   assign ecchmatrix[3][103] = 0;
   assign ecchmatrix[4][103] = 1;
   assign ecchmatrix[5][103] = 1;
   assign ecchmatrix[6][103] = 0;
   assign ecchmatrix[7][103] = 0;
   assign ecchmatrix[8][103] = 0;
   assign ecchmatrix[9][103] = 1;
   assign ecchmatrix[0][104] = 0;
   assign ecchmatrix[1][104] = 0;
   assign ecchmatrix[2][104] = 0;
   assign ecchmatrix[3][104] = 0;
   assign ecchmatrix[4][104] = 1;
   assign ecchmatrix[5][104] = 0;
   assign ecchmatrix[6][104] = 1;
   assign ecchmatrix[7][104] = 1;
   assign ecchmatrix[8][104] = 0;
   assign ecchmatrix[9][104] = 0;
   assign ecchmatrix[0][105] = 0;
   assign ecchmatrix[1][105] = 0;
   assign ecchmatrix[2][105] = 0;
   assign ecchmatrix[3][105] = 0;
   assign ecchmatrix[4][105] = 1;
   assign ecchmatrix[5][105] = 0;
   assign ecchmatrix[6][105] = 1;
   assign ecchmatrix[7][105] = 0;
   assign ecchmatrix[8][105] = 1;
   assign ecchmatrix[9][105] = 0;
   assign ecchmatrix[0][106] = 0;
   assign ecchmatrix[1][106] = 0;
   assign ecchmatrix[2][106] = 0;
   assign ecchmatrix[3][106] = 0;
   assign ecchmatrix[4][106] = 1;
   assign ecchmatrix[5][106] = 0;
   assign ecchmatrix[6][106] = 1;
   assign ecchmatrix[7][106] = 0;
   assign ecchmatrix[8][106] = 0;
   assign ecchmatrix[9][106] = 1;
   assign ecchmatrix[0][107] = 0;
   assign ecchmatrix[1][107] = 0;
   assign ecchmatrix[2][107] = 0;
   assign ecchmatrix[3][107] = 0;
   assign ecchmatrix[4][107] = 1;
   assign ecchmatrix[5][107] = 0;
   assign ecchmatrix[6][107] = 0;
   assign ecchmatrix[7][107] = 1;
   assign ecchmatrix[8][107] = 1;
   assign ecchmatrix[9][107] = 0;
   assign ecchmatrix[0][108] = 0;
   assign ecchmatrix[1][108] = 0;
   assign ecchmatrix[2][108] = 0;
   assign ecchmatrix[3][108] = 0;
   assign ecchmatrix[4][108] = 1;
   assign ecchmatrix[5][108] = 0;
   assign ecchmatrix[6][108] = 0;
   assign ecchmatrix[7][108] = 1;
   assign ecchmatrix[8][108] = 0;
   assign ecchmatrix[9][108] = 1;
   assign ecchmatrix[0][109] = 0;
   assign ecchmatrix[1][109] = 0;
   assign ecchmatrix[2][109] = 0;
   assign ecchmatrix[3][109] = 0;
   assign ecchmatrix[4][109] = 1;
   assign ecchmatrix[5][109] = 0;
   assign ecchmatrix[6][109] = 0;
   assign ecchmatrix[7][109] = 0;
   assign ecchmatrix[8][109] = 1;
   assign ecchmatrix[9][109] = 1;
   assign ecchmatrix[0][110] = 0;
   assign ecchmatrix[1][110] = 0;
   assign ecchmatrix[2][110] = 0;
   assign ecchmatrix[3][110] = 0;
   assign ecchmatrix[4][110] = 0;
   assign ecchmatrix[5][110] = 1;
   assign ecchmatrix[6][110] = 1;
   assign ecchmatrix[7][110] = 1;
   assign ecchmatrix[8][110] = 0;
   assign ecchmatrix[9][110] = 0;
   assign ecchmatrix[0][111] = 0;
   assign ecchmatrix[1][111] = 0;
   assign ecchmatrix[2][111] = 0;
   assign ecchmatrix[3][111] = 0;
   assign ecchmatrix[4][111] = 0;
   assign ecchmatrix[5][111] = 1;
   assign ecchmatrix[6][111] = 1;
   assign ecchmatrix[7][111] = 0;
   assign ecchmatrix[8][111] = 1;
   assign ecchmatrix[9][111] = 0;
   assign ecchmatrix[0][112] = 0;
   assign ecchmatrix[1][112] = 0;
   assign ecchmatrix[2][112] = 0;
   assign ecchmatrix[3][112] = 0;
   assign ecchmatrix[4][112] = 0;
   assign ecchmatrix[5][112] = 1;
   assign ecchmatrix[6][112] = 1;
   assign ecchmatrix[7][112] = 0;
   assign ecchmatrix[8][112] = 0;
   assign ecchmatrix[9][112] = 1;
   assign ecchmatrix[0][113] = 0;
   assign ecchmatrix[1][113] = 0;
   assign ecchmatrix[2][113] = 0;
   assign ecchmatrix[3][113] = 0;
   assign ecchmatrix[4][113] = 0;
   assign ecchmatrix[5][113] = 1;
   assign ecchmatrix[6][113] = 0;
   assign ecchmatrix[7][113] = 1;
   assign ecchmatrix[8][113] = 1;
   assign ecchmatrix[9][113] = 0;
   assign ecchmatrix[0][114] = 0;
   assign ecchmatrix[1][114] = 0;
   assign ecchmatrix[2][114] = 0;
   assign ecchmatrix[3][114] = 0;
   assign ecchmatrix[4][114] = 0;
   assign ecchmatrix[5][114] = 1;
   assign ecchmatrix[6][114] = 0;
   assign ecchmatrix[7][114] = 1;
   assign ecchmatrix[8][114] = 0;
   assign ecchmatrix[9][114] = 1;
   assign ecchmatrix[0][115] = 0;
   assign ecchmatrix[1][115] = 0;
   assign ecchmatrix[2][115] = 0;
   assign ecchmatrix[3][115] = 0;
   assign ecchmatrix[4][115] = 0;
   assign ecchmatrix[5][115] = 1;
   assign ecchmatrix[6][115] = 0;
   assign ecchmatrix[7][115] = 0;
   assign ecchmatrix[8][115] = 1;
   assign ecchmatrix[9][115] = 1;
   assign ecchmatrix[0][116] = 0;
   assign ecchmatrix[1][116] = 0;
   assign ecchmatrix[2][116] = 0;
   assign ecchmatrix[3][116] = 0;
   assign ecchmatrix[4][116] = 0;
   assign ecchmatrix[5][116] = 0;
   assign ecchmatrix[6][116] = 1;
   assign ecchmatrix[7][116] = 1;
   assign ecchmatrix[8][116] = 1;
   assign ecchmatrix[9][116] = 0;
   assign ecchmatrix[0][117] = 0;
   assign ecchmatrix[1][117] = 0;
   assign ecchmatrix[2][117] = 0;
   assign ecchmatrix[3][117] = 0;
   assign ecchmatrix[4][117] = 0;
   assign ecchmatrix[5][117] = 0;
   assign ecchmatrix[6][117] = 1;
   assign ecchmatrix[7][117] = 1;
   assign ecchmatrix[8][117] = 0;
   assign ecchmatrix[9][117] = 1;
   assign ecchmatrix[0][118] = 0;
   assign ecchmatrix[1][118] = 0;
   assign ecchmatrix[2][118] = 0;
   assign ecchmatrix[3][118] = 0;
   assign ecchmatrix[4][118] = 0;
   assign ecchmatrix[5][118] = 0;
   assign ecchmatrix[6][118] = 1;
   assign ecchmatrix[7][118] = 0;
   assign ecchmatrix[8][118] = 1;
   assign ecchmatrix[9][118] = 1;
   assign ecchmatrix[0][119] = 0;
   assign ecchmatrix[1][119] = 0;
   assign ecchmatrix[2][119] = 0;
   assign ecchmatrix[3][119] = 0;
   assign ecchmatrix[4][119] = 0;
   assign ecchmatrix[5][119] = 0;
   assign ecchmatrix[6][119] = 0;
   assign ecchmatrix[7][119] = 1;
   assign ecchmatrix[8][119] = 1;
   assign ecchmatrix[9][119] = 1;
   assign ecchmatrix[0][120] = 1;
   assign ecchmatrix[1][120] = 1;
   assign ecchmatrix[2][120] = 1;
   assign ecchmatrix[3][120] = 1;
   assign ecchmatrix[4][120] = 1;
   assign ecchmatrix[5][120] = 0;
   assign ecchmatrix[6][120] = 0;
   assign ecchmatrix[7][120] = 0;
   assign ecchmatrix[8][120] = 0;
   assign ecchmatrix[9][120] = 0;
   assign ecchmatrix[0][121] = 1;
   assign ecchmatrix[1][121] = 1;
   assign ecchmatrix[2][121] = 1;
   assign ecchmatrix[3][121] = 1;
   assign ecchmatrix[4][121] = 0;
   assign ecchmatrix[5][121] = 1;
   assign ecchmatrix[6][121] = 0;
   assign ecchmatrix[7][121] = 0;
   assign ecchmatrix[8][121] = 0;
   assign ecchmatrix[9][121] = 0;
   assign ecchmatrix[0][122] = 1;
   assign ecchmatrix[1][122] = 1;
   assign ecchmatrix[2][122] = 1;
   assign ecchmatrix[3][122] = 1;
   assign ecchmatrix[4][122] = 0;
   assign ecchmatrix[5][122] = 0;
   assign ecchmatrix[6][122] = 1;
   assign ecchmatrix[7][122] = 0;
   assign ecchmatrix[8][122] = 0;
   assign ecchmatrix[9][122] = 0;
   assign ecchmatrix[0][123] = 1;
   assign ecchmatrix[1][123] = 1;
   assign ecchmatrix[2][123] = 1;
   assign ecchmatrix[3][123] = 1;
   assign ecchmatrix[4][123] = 0;
   assign ecchmatrix[5][123] = 0;
   assign ecchmatrix[6][123] = 0;
   assign ecchmatrix[7][123] = 1;
   assign ecchmatrix[8][123] = 0;
   assign ecchmatrix[9][123] = 0;
   assign ecchmatrix[0][124] = 1;
   assign ecchmatrix[1][124] = 1;
   assign ecchmatrix[2][124] = 1;
   assign ecchmatrix[3][124] = 1;
   assign ecchmatrix[4][124] = 0;
   assign ecchmatrix[5][124] = 0;
   assign ecchmatrix[6][124] = 0;
   assign ecchmatrix[7][124] = 0;
   assign ecchmatrix[8][124] = 1;
   assign ecchmatrix[9][124] = 0;
   assign ecchmatrix[0][125] = 1;
   assign ecchmatrix[1][125] = 1;
   assign ecchmatrix[2][125] = 1;
   assign ecchmatrix[3][125] = 1;
   assign ecchmatrix[4][125] = 0;
   assign ecchmatrix[5][125] = 0;
   assign ecchmatrix[6][125] = 0;
   assign ecchmatrix[7][125] = 0;
   assign ecchmatrix[8][125] = 0;
   assign ecchmatrix[9][125] = 1;
   assign ecchmatrix[0][126] = 1;
   assign ecchmatrix[1][126] = 1;
   assign ecchmatrix[2][126] = 1;
   assign ecchmatrix[3][126] = 0;
   assign ecchmatrix[4][126] = 1;
   assign ecchmatrix[5][126] = 1;
   assign ecchmatrix[6][126] = 0;
   assign ecchmatrix[7][126] = 0;
   assign ecchmatrix[8][126] = 0;
   assign ecchmatrix[9][126] = 0;
   assign ecchmatrix[0][127] = 1;
   assign ecchmatrix[1][127] = 1;
   assign ecchmatrix[2][127] = 1;
   assign ecchmatrix[3][127] = 0;
   assign ecchmatrix[4][127] = 1;
   assign ecchmatrix[5][127] = 0;
   assign ecchmatrix[6][127] = 1;
   assign ecchmatrix[7][127] = 0;
   assign ecchmatrix[8][127] = 0;
   assign ecchmatrix[9][127] = 0;
   assign ecchmatrix[0][128] = 1;
   assign ecchmatrix[1][128] = 1;
   assign ecchmatrix[2][128] = 1;
   assign ecchmatrix[3][128] = 0;
   assign ecchmatrix[4][128] = 1;
   assign ecchmatrix[5][128] = 0;
   assign ecchmatrix[6][128] = 0;
   assign ecchmatrix[7][128] = 1;
   assign ecchmatrix[8][128] = 0;
   assign ecchmatrix[9][128] = 0;
   assign ecchmatrix[0][129] = 1;
   assign ecchmatrix[1][129] = 1;
   assign ecchmatrix[2][129] = 1;
   assign ecchmatrix[3][129] = 0;
   assign ecchmatrix[4][129] = 1;
   assign ecchmatrix[5][129] = 0;
   assign ecchmatrix[6][129] = 0;
   assign ecchmatrix[7][129] = 0;
   assign ecchmatrix[8][129] = 1;
   assign ecchmatrix[9][129] = 0;
   assign ecchmatrix[0][130] = 1;
   assign ecchmatrix[1][130] = 1;
   assign ecchmatrix[2][130] = 1;
   assign ecchmatrix[3][130] = 0;
   assign ecchmatrix[4][130] = 1;
   assign ecchmatrix[5][130] = 0;
   assign ecchmatrix[6][130] = 0;
   assign ecchmatrix[7][130] = 0;
   assign ecchmatrix[8][130] = 0;
   assign ecchmatrix[9][130] = 1;
   assign ecchmatrix[0][131] = 1;
   assign ecchmatrix[1][131] = 1;
   assign ecchmatrix[2][131] = 1;
   assign ecchmatrix[3][131] = 0;
   assign ecchmatrix[4][131] = 0;
   assign ecchmatrix[5][131] = 1;
   assign ecchmatrix[6][131] = 1;
   assign ecchmatrix[7][131] = 0;
   assign ecchmatrix[8][131] = 0;
   assign ecchmatrix[9][131] = 0;
   assign ecchmatrix[0][132] = 1;
   assign ecchmatrix[1][132] = 1;
   assign ecchmatrix[2][132] = 1;
   assign ecchmatrix[3][132] = 0;
   assign ecchmatrix[4][132] = 0;
   assign ecchmatrix[5][132] = 1;
   assign ecchmatrix[6][132] = 0;
   assign ecchmatrix[7][132] = 1;
   assign ecchmatrix[8][132] = 0;
   assign ecchmatrix[9][132] = 0;
   assign ecchmatrix[0][133] = 1;
   assign ecchmatrix[1][133] = 1;
   assign ecchmatrix[2][133] = 1;
   assign ecchmatrix[3][133] = 0;
   assign ecchmatrix[4][133] = 0;
   assign ecchmatrix[5][133] = 1;
   assign ecchmatrix[6][133] = 0;
   assign ecchmatrix[7][133] = 0;
   assign ecchmatrix[8][133] = 1;
   assign ecchmatrix[9][133] = 0;
   assign ecchmatrix[0][134] = 1;
   assign ecchmatrix[1][134] = 1;
   assign ecchmatrix[2][134] = 1;
   assign ecchmatrix[3][134] = 0;
   assign ecchmatrix[4][134] = 0;
   assign ecchmatrix[5][134] = 1;
   assign ecchmatrix[6][134] = 0;
   assign ecchmatrix[7][134] = 0;
   assign ecchmatrix[8][134] = 0;
   assign ecchmatrix[9][134] = 1;
   assign ecchmatrix[0][135] = 1;
   assign ecchmatrix[1][135] = 1;
   assign ecchmatrix[2][135] = 1;
   assign ecchmatrix[3][135] = 0;
   assign ecchmatrix[4][135] = 0;
   assign ecchmatrix[5][135] = 0;
   assign ecchmatrix[6][135] = 1;
   assign ecchmatrix[7][135] = 1;
   assign ecchmatrix[8][135] = 0;
   assign ecchmatrix[9][135] = 0;
   assign ecchmatrix[0][136] = 1;
   assign ecchmatrix[1][136] = 1;
   assign ecchmatrix[2][136] = 1;
   assign ecchmatrix[3][136] = 0;
   assign ecchmatrix[4][136] = 0;
   assign ecchmatrix[5][136] = 0;
   assign ecchmatrix[6][136] = 1;
   assign ecchmatrix[7][136] = 0;
   assign ecchmatrix[8][136] = 1;
   assign ecchmatrix[9][136] = 0;
   assign ecchmatrix[0][137] = 1;
   assign ecchmatrix[1][137] = 1;
   assign ecchmatrix[2][137] = 1;
   assign ecchmatrix[3][137] = 0;
   assign ecchmatrix[4][137] = 0;
   assign ecchmatrix[5][137] = 0;
   assign ecchmatrix[6][137] = 1;
   assign ecchmatrix[7][137] = 0;
   assign ecchmatrix[8][137] = 0;
   assign ecchmatrix[9][137] = 1;
   assign ecchmatrix[0][138] = 1;
   assign ecchmatrix[1][138] = 1;
   assign ecchmatrix[2][138] = 1;
   assign ecchmatrix[3][138] = 0;
   assign ecchmatrix[4][138] = 0;
   assign ecchmatrix[5][138] = 0;
   assign ecchmatrix[6][138] = 0;
   assign ecchmatrix[7][138] = 1;
   assign ecchmatrix[8][138] = 1;
   assign ecchmatrix[9][138] = 0;
   assign ecchmatrix[0][139] = 1;
   assign ecchmatrix[1][139] = 1;
   assign ecchmatrix[2][139] = 1;
   assign ecchmatrix[3][139] = 0;
   assign ecchmatrix[4][139] = 0;
   assign ecchmatrix[5][139] = 0;
   assign ecchmatrix[6][139] = 0;
   assign ecchmatrix[7][139] = 1;
   assign ecchmatrix[8][139] = 0;
   assign ecchmatrix[9][139] = 1;
   assign ecchmatrix[0][140] = 1;
   assign ecchmatrix[1][140] = 1;
   assign ecchmatrix[2][140] = 1;
   assign ecchmatrix[3][140] = 0;
   assign ecchmatrix[4][140] = 0;
   assign ecchmatrix[5][140] = 0;
   assign ecchmatrix[6][140] = 0;
   assign ecchmatrix[7][140] = 0;
   assign ecchmatrix[8][140] = 1;
   assign ecchmatrix[9][140] = 1;
   assign ecchmatrix[0][141] = 1;
   assign ecchmatrix[1][141] = 1;
   assign ecchmatrix[2][141] = 0;
   assign ecchmatrix[3][141] = 1;
   assign ecchmatrix[4][141] = 1;
   assign ecchmatrix[5][141] = 1;
   assign ecchmatrix[6][141] = 0;
   assign ecchmatrix[7][141] = 0;
   assign ecchmatrix[8][141] = 0;
   assign ecchmatrix[9][141] = 0;
   assign ecchmatrix[0][142] = 1;
   assign ecchmatrix[1][142] = 1;
   assign ecchmatrix[2][142] = 0;
   assign ecchmatrix[3][142] = 1;
   assign ecchmatrix[4][142] = 1;
   assign ecchmatrix[5][142] = 0;
   assign ecchmatrix[6][142] = 1;
   assign ecchmatrix[7][142] = 0;
   assign ecchmatrix[8][142] = 0;
   assign ecchmatrix[9][142] = 0;
   assign ecchmatrix[0][143] = 1;
   assign ecchmatrix[1][143] = 1;
   assign ecchmatrix[2][143] = 0;
   assign ecchmatrix[3][143] = 1;
   assign ecchmatrix[4][143] = 1;
   assign ecchmatrix[5][143] = 0;
   assign ecchmatrix[6][143] = 0;
   assign ecchmatrix[7][143] = 1;
   assign ecchmatrix[8][143] = 0;
   assign ecchmatrix[9][143] = 0;
   assign ecchmatrix[0][144] = 1;
   assign ecchmatrix[1][144] = 1;
   assign ecchmatrix[2][144] = 0;
   assign ecchmatrix[3][144] = 1;
   assign ecchmatrix[4][144] = 1;
   assign ecchmatrix[5][144] = 0;
   assign ecchmatrix[6][144] = 0;
   assign ecchmatrix[7][144] = 0;
   assign ecchmatrix[8][144] = 1;
   assign ecchmatrix[9][144] = 0;
   assign ecchmatrix[0][145] = 1;
   assign ecchmatrix[1][145] = 1;
   assign ecchmatrix[2][145] = 0;
   assign ecchmatrix[3][145] = 1;
   assign ecchmatrix[4][145] = 1;
   assign ecchmatrix[5][145] = 0;
   assign ecchmatrix[6][145] = 0;
   assign ecchmatrix[7][145] = 0;
   assign ecchmatrix[8][145] = 0;
   assign ecchmatrix[9][145] = 1;
   assign ecchmatrix[0][146] = 1;
   assign ecchmatrix[1][146] = 1;
   assign ecchmatrix[2][146] = 0;
   assign ecchmatrix[3][146] = 1;
   assign ecchmatrix[4][146] = 0;
   assign ecchmatrix[5][146] = 1;
   assign ecchmatrix[6][146] = 1;
   assign ecchmatrix[7][146] = 0;
   assign ecchmatrix[8][146] = 0;
   assign ecchmatrix[9][146] = 0;
   assign ecchmatrix[0][147] = 1;
   assign ecchmatrix[1][147] = 1;
   assign ecchmatrix[2][147] = 0;
   assign ecchmatrix[3][147] = 1;
   assign ecchmatrix[4][147] = 0;
   assign ecchmatrix[5][147] = 1;
   assign ecchmatrix[6][147] = 0;
   assign ecchmatrix[7][147] = 1;
   assign ecchmatrix[8][147] = 0;
   assign ecchmatrix[9][147] = 0;
   assign ecchmatrix[0][148] = 1;
   assign ecchmatrix[1][148] = 1;
   assign ecchmatrix[2][148] = 0;
   assign ecchmatrix[3][148] = 1;
   assign ecchmatrix[4][148] = 0;
   assign ecchmatrix[5][148] = 1;
   assign ecchmatrix[6][148] = 0;
   assign ecchmatrix[7][148] = 0;
   assign ecchmatrix[8][148] = 1;
   assign ecchmatrix[9][148] = 0;
   assign ecchmatrix[0][149] = 1;
   assign ecchmatrix[1][149] = 1;
   assign ecchmatrix[2][149] = 0;
   assign ecchmatrix[3][149] = 1;
   assign ecchmatrix[4][149] = 0;
   assign ecchmatrix[5][149] = 1;
   assign ecchmatrix[6][149] = 0;
   assign ecchmatrix[7][149] = 0;
   assign ecchmatrix[8][149] = 0;
   assign ecchmatrix[9][149] = 1;
   assign ecchmatrix[0][150] = 1;
   assign ecchmatrix[1][150] = 1;
   assign ecchmatrix[2][150] = 0;
   assign ecchmatrix[3][150] = 1;
   assign ecchmatrix[4][150] = 0;
   assign ecchmatrix[5][150] = 0;
   assign ecchmatrix[6][150] = 1;
   assign ecchmatrix[7][150] = 1;
   assign ecchmatrix[8][150] = 0;
   assign ecchmatrix[9][150] = 0;
   assign ecchmatrix[0][151] = 1;
   assign ecchmatrix[1][151] = 1;
   assign ecchmatrix[2][151] = 0;
   assign ecchmatrix[3][151] = 1;
   assign ecchmatrix[4][151] = 0;
   assign ecchmatrix[5][151] = 0;
   assign ecchmatrix[6][151] = 1;
   assign ecchmatrix[7][151] = 0;
   assign ecchmatrix[8][151] = 1;
   assign ecchmatrix[9][151] = 0;
   assign ecchmatrix[0][152] = 1;
   assign ecchmatrix[1][152] = 1;
   assign ecchmatrix[2][152] = 0;
   assign ecchmatrix[3][152] = 1;
   assign ecchmatrix[4][152] = 0;
   assign ecchmatrix[5][152] = 0;
   assign ecchmatrix[6][152] = 1;
   assign ecchmatrix[7][152] = 0;
   assign ecchmatrix[8][152] = 0;
   assign ecchmatrix[9][152] = 1;
   assign ecchmatrix[0][153] = 1;
   assign ecchmatrix[1][153] = 1;
   assign ecchmatrix[2][153] = 0;
   assign ecchmatrix[3][153] = 1;
   assign ecchmatrix[4][153] = 0;
   assign ecchmatrix[5][153] = 0;
   assign ecchmatrix[6][153] = 0;
   assign ecchmatrix[7][153] = 1;
   assign ecchmatrix[8][153] = 1;
   assign ecchmatrix[9][153] = 0;
   assign ecchmatrix[0][154] = 1;
   assign ecchmatrix[1][154] = 1;
   assign ecchmatrix[2][154] = 0;
   assign ecchmatrix[3][154] = 1;
   assign ecchmatrix[4][154] = 0;
   assign ecchmatrix[5][154] = 0;
   assign ecchmatrix[6][154] = 0;
   assign ecchmatrix[7][154] = 1;
   assign ecchmatrix[8][154] = 0;
   assign ecchmatrix[9][154] = 1;
   assign ecchmatrix[0][155] = 1;
   assign ecchmatrix[1][155] = 1;
   assign ecchmatrix[2][155] = 0;
   assign ecchmatrix[3][155] = 1;
   assign ecchmatrix[4][155] = 0;
   assign ecchmatrix[5][155] = 0;
   assign ecchmatrix[6][155] = 0;
   assign ecchmatrix[7][155] = 0;
   assign ecchmatrix[8][155] = 1;
   assign ecchmatrix[9][155] = 1;
   assign ecchmatrix[0][156] = 1;
   assign ecchmatrix[1][156] = 1;
   assign ecchmatrix[2][156] = 0;
   assign ecchmatrix[3][156] = 0;
   assign ecchmatrix[4][156] = 1;
   assign ecchmatrix[5][156] = 1;
   assign ecchmatrix[6][156] = 1;
   assign ecchmatrix[7][156] = 0;
   assign ecchmatrix[8][156] = 0;
   assign ecchmatrix[9][156] = 0;
   assign ecchmatrix[0][157] = 1;
   assign ecchmatrix[1][157] = 1;
   assign ecchmatrix[2][157] = 0;
   assign ecchmatrix[3][157] = 0;
   assign ecchmatrix[4][157] = 1;
   assign ecchmatrix[5][157] = 1;
   assign ecchmatrix[6][157] = 0;
   assign ecchmatrix[7][157] = 1;
   assign ecchmatrix[8][157] = 0;
   assign ecchmatrix[9][157] = 0;
   assign ecchmatrix[0][158] = 1;
   assign ecchmatrix[1][158] = 1;
   assign ecchmatrix[2][158] = 0;
   assign ecchmatrix[3][158] = 0;
   assign ecchmatrix[4][158] = 1;
   assign ecchmatrix[5][158] = 1;
   assign ecchmatrix[6][158] = 0;
   assign ecchmatrix[7][158] = 0;
   assign ecchmatrix[8][158] = 1;
   assign ecchmatrix[9][158] = 0;
   assign ecchmatrix[0][159] = 1;
   assign ecchmatrix[1][159] = 1;
   assign ecchmatrix[2][159] = 0;
   assign ecchmatrix[3][159] = 0;
   assign ecchmatrix[4][159] = 1;
   assign ecchmatrix[5][159] = 1;
   assign ecchmatrix[6][159] = 0;
   assign ecchmatrix[7][159] = 0;
   assign ecchmatrix[8][159] = 0;
   assign ecchmatrix[9][159] = 1;
   assign ecchmatrix[0][160] = 1;
   assign ecchmatrix[1][160] = 1;
   assign ecchmatrix[2][160] = 0;
   assign ecchmatrix[3][160] = 0;
   assign ecchmatrix[4][160] = 1;
   assign ecchmatrix[5][160] = 0;
   assign ecchmatrix[6][160] = 1;
   assign ecchmatrix[7][160] = 1;
   assign ecchmatrix[8][160] = 0;
   assign ecchmatrix[9][160] = 0;
   assign ecchmatrix[0][161] = 1;
   assign ecchmatrix[1][161] = 1;
   assign ecchmatrix[2][161] = 0;
   assign ecchmatrix[3][161] = 0;
   assign ecchmatrix[4][161] = 1;
   assign ecchmatrix[5][161] = 0;
   assign ecchmatrix[6][161] = 1;
   assign ecchmatrix[7][161] = 0;
   assign ecchmatrix[8][161] = 1;
   assign ecchmatrix[9][161] = 0;
   assign ecchmatrix[0][162] = 1;
   assign ecchmatrix[1][162] = 1;
   assign ecchmatrix[2][162] = 0;
   assign ecchmatrix[3][162] = 0;
   assign ecchmatrix[4][162] = 1;
   assign ecchmatrix[5][162] = 0;
   assign ecchmatrix[6][162] = 1;
   assign ecchmatrix[7][162] = 0;
   assign ecchmatrix[8][162] = 0;
   assign ecchmatrix[9][162] = 1;
   assign ecchmatrix[0][163] = 1;
   assign ecchmatrix[1][163] = 1;
   assign ecchmatrix[2][163] = 0;
   assign ecchmatrix[3][163] = 0;
   assign ecchmatrix[4][163] = 1;
   assign ecchmatrix[5][163] = 0;
   assign ecchmatrix[6][163] = 0;
   assign ecchmatrix[7][163] = 1;
   assign ecchmatrix[8][163] = 1;
   assign ecchmatrix[9][163] = 0;
   assign ecchmatrix[0][164] = 1;
   assign ecchmatrix[1][164] = 1;
   assign ecchmatrix[2][164] = 0;
   assign ecchmatrix[3][164] = 0;
   assign ecchmatrix[4][164] = 1;
   assign ecchmatrix[5][164] = 0;
   assign ecchmatrix[6][164] = 0;
   assign ecchmatrix[7][164] = 1;
   assign ecchmatrix[8][164] = 0;
   assign ecchmatrix[9][164] = 1;
   assign ecchmatrix[0][165] = 1;
   assign ecchmatrix[1][165] = 1;
   assign ecchmatrix[2][165] = 0;
   assign ecchmatrix[3][165] = 0;
   assign ecchmatrix[4][165] = 1;
   assign ecchmatrix[5][165] = 0;
   assign ecchmatrix[6][165] = 0;
   assign ecchmatrix[7][165] = 0;
   assign ecchmatrix[8][165] = 1;
   assign ecchmatrix[9][165] = 1;
   assign ecchmatrix[0][166] = 1;
   assign ecchmatrix[1][166] = 1;
   assign ecchmatrix[2][166] = 0;
   assign ecchmatrix[3][166] = 0;
   assign ecchmatrix[4][166] = 0;
   assign ecchmatrix[5][166] = 1;
   assign ecchmatrix[6][166] = 1;
   assign ecchmatrix[7][166] = 1;
   assign ecchmatrix[8][166] = 0;
   assign ecchmatrix[9][166] = 0;
   assign ecchmatrix[0][167] = 1;
   assign ecchmatrix[1][167] = 1;
   assign ecchmatrix[2][167] = 0;
   assign ecchmatrix[3][167] = 0;
   assign ecchmatrix[4][167] = 0;
   assign ecchmatrix[5][167] = 1;
   assign ecchmatrix[6][167] = 1;
   assign ecchmatrix[7][167] = 0;
   assign ecchmatrix[8][167] = 1;
   assign ecchmatrix[9][167] = 0;
   assign ecchmatrix[0][168] = 1;
   assign ecchmatrix[1][168] = 1;
   assign ecchmatrix[2][168] = 0;
   assign ecchmatrix[3][168] = 0;
   assign ecchmatrix[4][168] = 0;
   assign ecchmatrix[5][168] = 1;
   assign ecchmatrix[6][168] = 1;
   assign ecchmatrix[7][168] = 0;
   assign ecchmatrix[8][168] = 0;
   assign ecchmatrix[9][168] = 1;
   assign ecchmatrix[0][169] = 1;
   assign ecchmatrix[1][169] = 1;
   assign ecchmatrix[2][169] = 0;
   assign ecchmatrix[3][169] = 0;
   assign ecchmatrix[4][169] = 0;
   assign ecchmatrix[5][169] = 1;
   assign ecchmatrix[6][169] = 0;
   assign ecchmatrix[7][169] = 1;
   assign ecchmatrix[8][169] = 1;
   assign ecchmatrix[9][169] = 0;
   assign ecchmatrix[0][170] = 1;
   assign ecchmatrix[1][170] = 1;
   assign ecchmatrix[2][170] = 0;
   assign ecchmatrix[3][170] = 0;
   assign ecchmatrix[4][170] = 0;
   assign ecchmatrix[5][170] = 1;
   assign ecchmatrix[6][170] = 0;
   assign ecchmatrix[7][170] = 1;
   assign ecchmatrix[8][170] = 0;
   assign ecchmatrix[9][170] = 1;
   assign ecchmatrix[0][171] = 1;
   assign ecchmatrix[1][171] = 1;
   assign ecchmatrix[2][171] = 0;
   assign ecchmatrix[3][171] = 0;
   assign ecchmatrix[4][171] = 0;
   assign ecchmatrix[5][171] = 1;
   assign ecchmatrix[6][171] = 0;
   assign ecchmatrix[7][171] = 0;
   assign ecchmatrix[8][171] = 1;
   assign ecchmatrix[9][171] = 1;
   assign ecchmatrix[0][172] = 1;
   assign ecchmatrix[1][172] = 1;
   assign ecchmatrix[2][172] = 0;
   assign ecchmatrix[3][172] = 0;
   assign ecchmatrix[4][172] = 0;
   assign ecchmatrix[5][172] = 0;
   assign ecchmatrix[6][172] = 1;
   assign ecchmatrix[7][172] = 1;
   assign ecchmatrix[8][172] = 1;
   assign ecchmatrix[9][172] = 0;
   assign ecchmatrix[0][173] = 1;
   assign ecchmatrix[1][173] = 1;
   assign ecchmatrix[2][173] = 0;
   assign ecchmatrix[3][173] = 0;
   assign ecchmatrix[4][173] = 0;
   assign ecchmatrix[5][173] = 0;
   assign ecchmatrix[6][173] = 1;
   assign ecchmatrix[7][173] = 1;
   assign ecchmatrix[8][173] = 0;
   assign ecchmatrix[9][173] = 1;
   assign ecchmatrix[0][174] = 1;
   assign ecchmatrix[1][174] = 1;
   assign ecchmatrix[2][174] = 0;
   assign ecchmatrix[3][174] = 0;
   assign ecchmatrix[4][174] = 0;
   assign ecchmatrix[5][174] = 0;
   assign ecchmatrix[6][174] = 1;
   assign ecchmatrix[7][174] = 0;
   assign ecchmatrix[8][174] = 1;
   assign ecchmatrix[9][174] = 1;
   assign ecchmatrix[0][175] = 1;
   assign ecchmatrix[1][175] = 1;
   assign ecchmatrix[2][175] = 0;
   assign ecchmatrix[3][175] = 0;
   assign ecchmatrix[4][175] = 0;
   assign ecchmatrix[5][175] = 0;
   assign ecchmatrix[6][175] = 0;
   assign ecchmatrix[7][175] = 1;
   assign ecchmatrix[8][175] = 1;
   assign ecchmatrix[9][175] = 1;
   assign ecchmatrix[0][176] = 1;
   assign ecchmatrix[1][176] = 0;
   assign ecchmatrix[2][176] = 1;
   assign ecchmatrix[3][176] = 1;
   assign ecchmatrix[4][176] = 1;
   assign ecchmatrix[5][176] = 1;
   assign ecchmatrix[6][176] = 0;
   assign ecchmatrix[7][176] = 0;
   assign ecchmatrix[8][176] = 0;
   assign ecchmatrix[9][176] = 0;
   assign ecchmatrix[0][177] = 1;
   assign ecchmatrix[1][177] = 0;
   assign ecchmatrix[2][177] = 1;
   assign ecchmatrix[3][177] = 1;
   assign ecchmatrix[4][177] = 1;
   assign ecchmatrix[5][177] = 0;
   assign ecchmatrix[6][177] = 1;
   assign ecchmatrix[7][177] = 0;
   assign ecchmatrix[8][177] = 0;
   assign ecchmatrix[9][177] = 0;
   assign ecchmatrix[0][178] = 1;
   assign ecchmatrix[1][178] = 0;
   assign ecchmatrix[2][178] = 1;
   assign ecchmatrix[3][178] = 1;
   assign ecchmatrix[4][178] = 1;
   assign ecchmatrix[5][178] = 0;
   assign ecchmatrix[6][178] = 0;
   assign ecchmatrix[7][178] = 1;
   assign ecchmatrix[8][178] = 0;
   assign ecchmatrix[9][178] = 0;
   assign ecchmatrix[0][179] = 1;
   assign ecchmatrix[1][179] = 0;
   assign ecchmatrix[2][179] = 1;
   assign ecchmatrix[3][179] = 1;
   assign ecchmatrix[4][179] = 1;
   assign ecchmatrix[5][179] = 0;
   assign ecchmatrix[6][179] = 0;
   assign ecchmatrix[7][179] = 0;
   assign ecchmatrix[8][179] = 1;
   assign ecchmatrix[9][179] = 0;
   assign ecchmatrix[0][180] = 1;
   assign ecchmatrix[1][180] = 0;
   assign ecchmatrix[2][180] = 1;
   assign ecchmatrix[3][180] = 1;
   assign ecchmatrix[4][180] = 1;
   assign ecchmatrix[5][180] = 0;
   assign ecchmatrix[6][180] = 0;
   assign ecchmatrix[7][180] = 0;
   assign ecchmatrix[8][180] = 0;
   assign ecchmatrix[9][180] = 1;
   assign ecchmatrix[0][181] = 1;
   assign ecchmatrix[1][181] = 0;
   assign ecchmatrix[2][181] = 1;
   assign ecchmatrix[3][181] = 1;
   assign ecchmatrix[4][181] = 0;
   assign ecchmatrix[5][181] = 1;
   assign ecchmatrix[6][181] = 1;
   assign ecchmatrix[7][181] = 0;
   assign ecchmatrix[8][181] = 0;
   assign ecchmatrix[9][181] = 0;
   assign ecchmatrix[0][182] = 1;
   assign ecchmatrix[1][182] = 0;
   assign ecchmatrix[2][182] = 1;
   assign ecchmatrix[3][182] = 1;
   assign ecchmatrix[4][182] = 0;
   assign ecchmatrix[5][182] = 1;
   assign ecchmatrix[6][182] = 0;
   assign ecchmatrix[7][182] = 1;
   assign ecchmatrix[8][182] = 0;
   assign ecchmatrix[9][182] = 0;
   assign ecchmatrix[0][183] = 1;
   assign ecchmatrix[1][183] = 0;
   assign ecchmatrix[2][183] = 1;
   assign ecchmatrix[3][183] = 1;
   assign ecchmatrix[4][183] = 0;
   assign ecchmatrix[5][183] = 1;
   assign ecchmatrix[6][183] = 0;
   assign ecchmatrix[7][183] = 0;
   assign ecchmatrix[8][183] = 1;
   assign ecchmatrix[9][183] = 0;
   assign ecchmatrix[0][184] = 1;
   assign ecchmatrix[1][184] = 0;
   assign ecchmatrix[2][184] = 1;
   assign ecchmatrix[3][184] = 1;
   assign ecchmatrix[4][184] = 0;
   assign ecchmatrix[5][184] = 1;
   assign ecchmatrix[6][184] = 0;
   assign ecchmatrix[7][184] = 0;
   assign ecchmatrix[8][184] = 0;
   assign ecchmatrix[9][184] = 1;
   assign ecchmatrix[0][185] = 1;
   assign ecchmatrix[1][185] = 0;
   assign ecchmatrix[2][185] = 1;
   assign ecchmatrix[3][185] = 1;
   assign ecchmatrix[4][185] = 0;
   assign ecchmatrix[5][185] = 0;
   assign ecchmatrix[6][185] = 1;
   assign ecchmatrix[7][185] = 1;
   assign ecchmatrix[8][185] = 0;
   assign ecchmatrix[9][185] = 0;
   assign ecchmatrix[0][186] = 1;
   assign ecchmatrix[1][186] = 0;
   assign ecchmatrix[2][186] = 1;
   assign ecchmatrix[3][186] = 1;
   assign ecchmatrix[4][186] = 0;
   assign ecchmatrix[5][186] = 0;
   assign ecchmatrix[6][186] = 1;
   assign ecchmatrix[7][186] = 0;
   assign ecchmatrix[8][186] = 1;
   assign ecchmatrix[9][186] = 0;
   assign ecchmatrix[0][187] = 1;
   assign ecchmatrix[1][187] = 0;
   assign ecchmatrix[2][187] = 1;
   assign ecchmatrix[3][187] = 1;
   assign ecchmatrix[4][187] = 0;
   assign ecchmatrix[5][187] = 0;
   assign ecchmatrix[6][187] = 1;
   assign ecchmatrix[7][187] = 0;
   assign ecchmatrix[8][187] = 0;
   assign ecchmatrix[9][187] = 1;
   assign ecchmatrix[0][188] = 1;
   assign ecchmatrix[1][188] = 0;
   assign ecchmatrix[2][188] = 1;
   assign ecchmatrix[3][188] = 1;
   assign ecchmatrix[4][188] = 0;
   assign ecchmatrix[5][188] = 0;
   assign ecchmatrix[6][188] = 0;
   assign ecchmatrix[7][188] = 1;
   assign ecchmatrix[8][188] = 1;
   assign ecchmatrix[9][188] = 0;
   assign ecchmatrix[0][189] = 1;
   assign ecchmatrix[1][189] = 0;
   assign ecchmatrix[2][189] = 1;
   assign ecchmatrix[3][189] = 1;
   assign ecchmatrix[4][189] = 0;
   assign ecchmatrix[5][189] = 0;
   assign ecchmatrix[6][189] = 0;
   assign ecchmatrix[7][189] = 1;
   assign ecchmatrix[8][189] = 0;
   assign ecchmatrix[9][189] = 1;
   assign ecchmatrix[0][190] = 1;
   assign ecchmatrix[1][190] = 0;
   assign ecchmatrix[2][190] = 1;
   assign ecchmatrix[3][190] = 1;
   assign ecchmatrix[4][190] = 0;
   assign ecchmatrix[5][190] = 0;
   assign ecchmatrix[6][190] = 0;
   assign ecchmatrix[7][190] = 0;
   assign ecchmatrix[8][190] = 1;
   assign ecchmatrix[9][190] = 1;
   assign ecchmatrix[0][191] = 1;
   assign ecchmatrix[1][191] = 0;
   assign ecchmatrix[2][191] = 1;
   assign ecchmatrix[3][191] = 0;
   assign ecchmatrix[4][191] = 1;
   assign ecchmatrix[5][191] = 1;
   assign ecchmatrix[6][191] = 1;
   assign ecchmatrix[7][191] = 0;
   assign ecchmatrix[8][191] = 0;
   assign ecchmatrix[9][191] = 0;
   assign ecchmatrix[0][192] = 1;
   assign ecchmatrix[1][192] = 0;
   assign ecchmatrix[2][192] = 1;
   assign ecchmatrix[3][192] = 0;
   assign ecchmatrix[4][192] = 1;
   assign ecchmatrix[5][192] = 1;
   assign ecchmatrix[6][192] = 0;
   assign ecchmatrix[7][192] = 1;
   assign ecchmatrix[8][192] = 0;
   assign ecchmatrix[9][192] = 0;
   assign ecchmatrix[0][193] = 1;
   assign ecchmatrix[1][193] = 0;
   assign ecchmatrix[2][193] = 1;
   assign ecchmatrix[3][193] = 0;
   assign ecchmatrix[4][193] = 1;
   assign ecchmatrix[5][193] = 1;
   assign ecchmatrix[6][193] = 0;
   assign ecchmatrix[7][193] = 0;
   assign ecchmatrix[8][193] = 1;
   assign ecchmatrix[9][193] = 0;
   assign ecchmatrix[0][194] = 1;
   assign ecchmatrix[1][194] = 0;
   assign ecchmatrix[2][194] = 1;
   assign ecchmatrix[3][194] = 0;
   assign ecchmatrix[4][194] = 1;
   assign ecchmatrix[5][194] = 1;
   assign ecchmatrix[6][194] = 0;
   assign ecchmatrix[7][194] = 0;
   assign ecchmatrix[8][194] = 0;
   assign ecchmatrix[9][194] = 1;
   assign ecchmatrix[0][195] = 1;
   assign ecchmatrix[1][195] = 0;
   assign ecchmatrix[2][195] = 1;
   assign ecchmatrix[3][195] = 0;
   assign ecchmatrix[4][195] = 1;
   assign ecchmatrix[5][195] = 0;
   assign ecchmatrix[6][195] = 1;
   assign ecchmatrix[7][195] = 1;
   assign ecchmatrix[8][195] = 0;
   assign ecchmatrix[9][195] = 0;
   assign ecchmatrix[0][196] = 1;
   assign ecchmatrix[1][196] = 0;
   assign ecchmatrix[2][196] = 1;
   assign ecchmatrix[3][196] = 0;
   assign ecchmatrix[4][196] = 1;
   assign ecchmatrix[5][196] = 0;
   assign ecchmatrix[6][196] = 1;
   assign ecchmatrix[7][196] = 0;
   assign ecchmatrix[8][196] = 1;
   assign ecchmatrix[9][196] = 0;
   assign ecchmatrix[0][197] = 1;
   assign ecchmatrix[1][197] = 0;
   assign ecchmatrix[2][197] = 1;
   assign ecchmatrix[3][197] = 0;
   assign ecchmatrix[4][197] = 1;
   assign ecchmatrix[5][197] = 0;
   assign ecchmatrix[6][197] = 1;
   assign ecchmatrix[7][197] = 0;
   assign ecchmatrix[8][197] = 0;
   assign ecchmatrix[9][197] = 1;
   assign ecchmatrix[0][198] = 1;
   assign ecchmatrix[1][198] = 0;
   assign ecchmatrix[2][198] = 1;
   assign ecchmatrix[3][198] = 0;
   assign ecchmatrix[4][198] = 1;
   assign ecchmatrix[5][198] = 0;
   assign ecchmatrix[6][198] = 0;
   assign ecchmatrix[7][198] = 1;
   assign ecchmatrix[8][198] = 1;
   assign ecchmatrix[9][198] = 0;
   assign ecchmatrix[0][199] = 1;
   assign ecchmatrix[1][199] = 0;
   assign ecchmatrix[2][199] = 1;
   assign ecchmatrix[3][199] = 0;
   assign ecchmatrix[4][199] = 1;
   assign ecchmatrix[5][199] = 0;
   assign ecchmatrix[6][199] = 0;
   assign ecchmatrix[7][199] = 1;
   assign ecchmatrix[8][199] = 0;
   assign ecchmatrix[9][199] = 1;
   assign ecchmatrix[0][200] = 1;
   assign ecchmatrix[1][200] = 0;
   assign ecchmatrix[2][200] = 1;
   assign ecchmatrix[3][200] = 0;
   assign ecchmatrix[4][200] = 1;
   assign ecchmatrix[5][200] = 0;
   assign ecchmatrix[6][200] = 0;
   assign ecchmatrix[7][200] = 0;
   assign ecchmatrix[8][200] = 1;
   assign ecchmatrix[9][200] = 1;
   assign ecchmatrix[0][201] = 1;
   assign ecchmatrix[1][201] = 0;
   assign ecchmatrix[2][201] = 1;
   assign ecchmatrix[3][201] = 0;
   assign ecchmatrix[4][201] = 0;
   assign ecchmatrix[5][201] = 1;
   assign ecchmatrix[6][201] = 1;
   assign ecchmatrix[7][201] = 1;
   assign ecchmatrix[8][201] = 0;
   assign ecchmatrix[9][201] = 0;
   assign ecchmatrix[0][202] = 1;
   assign ecchmatrix[1][202] = 0;
   assign ecchmatrix[2][202] = 1;
   assign ecchmatrix[3][202] = 0;
   assign ecchmatrix[4][202] = 0;
   assign ecchmatrix[5][202] = 1;
   assign ecchmatrix[6][202] = 1;
   assign ecchmatrix[7][202] = 0;
   assign ecchmatrix[8][202] = 1;
   assign ecchmatrix[9][202] = 0;
   assign ecchmatrix[0][203] = 1;
   assign ecchmatrix[1][203] = 0;
   assign ecchmatrix[2][203] = 1;
   assign ecchmatrix[3][203] = 0;
   assign ecchmatrix[4][203] = 0;
   assign ecchmatrix[5][203] = 1;
   assign ecchmatrix[6][203] = 1;
   assign ecchmatrix[7][203] = 0;
   assign ecchmatrix[8][203] = 0;
   assign ecchmatrix[9][203] = 1;
   assign ecchmatrix[0][204] = 1;
   assign ecchmatrix[1][204] = 0;
   assign ecchmatrix[2][204] = 1;
   assign ecchmatrix[3][204] = 0;
   assign ecchmatrix[4][204] = 0;
   assign ecchmatrix[5][204] = 1;
   assign ecchmatrix[6][204] = 0;
   assign ecchmatrix[7][204] = 1;
   assign ecchmatrix[8][204] = 1;
   assign ecchmatrix[9][204] = 0;
   assign ecchmatrix[0][205] = 1;
   assign ecchmatrix[1][205] = 0;
   assign ecchmatrix[2][205] = 1;
   assign ecchmatrix[3][205] = 0;
   assign ecchmatrix[4][205] = 0;
   assign ecchmatrix[5][205] = 1;
   assign ecchmatrix[6][205] = 0;
   assign ecchmatrix[7][205] = 1;
   assign ecchmatrix[8][205] = 0;
   assign ecchmatrix[9][205] = 1;
   assign ecchmatrix[0][206] = 1;
   assign ecchmatrix[1][206] = 0;
   assign ecchmatrix[2][206] = 1;
   assign ecchmatrix[3][206] = 0;
   assign ecchmatrix[4][206] = 0;
   assign ecchmatrix[5][206] = 1;
   assign ecchmatrix[6][206] = 0;
   assign ecchmatrix[7][206] = 0;
   assign ecchmatrix[8][206] = 1;
   assign ecchmatrix[9][206] = 1;
   assign ecchmatrix[0][207] = 1;
   assign ecchmatrix[1][207] = 0;
   assign ecchmatrix[2][207] = 1;
   assign ecchmatrix[3][207] = 0;
   assign ecchmatrix[4][207] = 0;
   assign ecchmatrix[5][207] = 0;
   assign ecchmatrix[6][207] = 1;
   assign ecchmatrix[7][207] = 1;
   assign ecchmatrix[8][207] = 1;
   assign ecchmatrix[9][207] = 0;
   assign ecchmatrix[0][208] = 1;
   assign ecchmatrix[1][208] = 0;
   assign ecchmatrix[2][208] = 1;
   assign ecchmatrix[3][208] = 0;
   assign ecchmatrix[4][208] = 0;
   assign ecchmatrix[5][208] = 0;
   assign ecchmatrix[6][208] = 1;
   assign ecchmatrix[7][208] = 1;
   assign ecchmatrix[8][208] = 0;
   assign ecchmatrix[9][208] = 1;
   assign ecchmatrix[0][209] = 1;
   assign ecchmatrix[1][209] = 0;
   assign ecchmatrix[2][209] = 1;
   assign ecchmatrix[3][209] = 0;
   assign ecchmatrix[4][209] = 0;
   assign ecchmatrix[5][209] = 0;
   assign ecchmatrix[6][209] = 1;
   assign ecchmatrix[7][209] = 0;
   assign ecchmatrix[8][209] = 1;
   assign ecchmatrix[9][209] = 1;
   assign ecchmatrix[0][210] = 1;
   assign ecchmatrix[1][210] = 0;
   assign ecchmatrix[2][210] = 1;
   assign ecchmatrix[3][210] = 0;
   assign ecchmatrix[4][210] = 0;
   assign ecchmatrix[5][210] = 0;
   assign ecchmatrix[6][210] = 0;
   assign ecchmatrix[7][210] = 1;
   assign ecchmatrix[8][210] = 1;
   assign ecchmatrix[9][210] = 1;
   assign ecchmatrix[0][211] = 1;
   assign ecchmatrix[1][211] = 0;
   assign ecchmatrix[2][211] = 0;
   assign ecchmatrix[3][211] = 1;
   assign ecchmatrix[4][211] = 1;
   assign ecchmatrix[5][211] = 1;
   assign ecchmatrix[6][211] = 1;
   assign ecchmatrix[7][211] = 0;
   assign ecchmatrix[8][211] = 0;
   assign ecchmatrix[9][211] = 0;
   assign ecchmatrix[0][212] = 1;
   assign ecchmatrix[1][212] = 0;
   assign ecchmatrix[2][212] = 0;
   assign ecchmatrix[3][212] = 1;
   assign ecchmatrix[4][212] = 1;
   assign ecchmatrix[5][212] = 1;
   assign ecchmatrix[6][212] = 0;
   assign ecchmatrix[7][212] = 1;
   assign ecchmatrix[8][212] = 0;
   assign ecchmatrix[9][212] = 0;
   assign ecchmatrix[0][213] = 1;
   assign ecchmatrix[1][213] = 0;
   assign ecchmatrix[2][213] = 0;
   assign ecchmatrix[3][213] = 1;
   assign ecchmatrix[4][213] = 1;
   assign ecchmatrix[5][213] = 1;
   assign ecchmatrix[6][213] = 0;
   assign ecchmatrix[7][213] = 0;
   assign ecchmatrix[8][213] = 1;
   assign ecchmatrix[9][213] = 0;
   assign ecchmatrix[0][214] = 1;
   assign ecchmatrix[1][214] = 0;
   assign ecchmatrix[2][214] = 0;
   assign ecchmatrix[3][214] = 1;
   assign ecchmatrix[4][214] = 1;
   assign ecchmatrix[5][214] = 1;
   assign ecchmatrix[6][214] = 0;
   assign ecchmatrix[7][214] = 0;
   assign ecchmatrix[8][214] = 0;
   assign ecchmatrix[9][214] = 1;
   assign ecchmatrix[0][215] = 1;
   assign ecchmatrix[1][215] = 0;
   assign ecchmatrix[2][215] = 0;
   assign ecchmatrix[3][215] = 1;
   assign ecchmatrix[4][215] = 1;
   assign ecchmatrix[5][215] = 0;
   assign ecchmatrix[6][215] = 1;
   assign ecchmatrix[7][215] = 1;
   assign ecchmatrix[8][215] = 0;
   assign ecchmatrix[9][215] = 0;
   assign ecchmatrix[0][216] = 1;
   assign ecchmatrix[1][216] = 0;
   assign ecchmatrix[2][216] = 0;
   assign ecchmatrix[3][216] = 1;
   assign ecchmatrix[4][216] = 1;
   assign ecchmatrix[5][216] = 0;
   assign ecchmatrix[6][216] = 1;
   assign ecchmatrix[7][216] = 0;
   assign ecchmatrix[8][216] = 1;
   assign ecchmatrix[9][216] = 0;
   assign ecchmatrix[0][217] = 1;
   assign ecchmatrix[1][217] = 0;
   assign ecchmatrix[2][217] = 0;
   assign ecchmatrix[3][217] = 1;
   assign ecchmatrix[4][217] = 1;
   assign ecchmatrix[5][217] = 0;
   assign ecchmatrix[6][217] = 1;
   assign ecchmatrix[7][217] = 0;
   assign ecchmatrix[8][217] = 0;
   assign ecchmatrix[9][217] = 1;
   assign ecchmatrix[0][218] = 1;
   assign ecchmatrix[1][218] = 0;
   assign ecchmatrix[2][218] = 0;
   assign ecchmatrix[3][218] = 1;
   assign ecchmatrix[4][218] = 1;
   assign ecchmatrix[5][218] = 0;
   assign ecchmatrix[6][218] = 0;
   assign ecchmatrix[7][218] = 1;
   assign ecchmatrix[8][218] = 1;
   assign ecchmatrix[9][218] = 0;
   assign ecchmatrix[0][219] = 1;
   assign ecchmatrix[1][219] = 0;
   assign ecchmatrix[2][219] = 0;
   assign ecchmatrix[3][219] = 1;
   assign ecchmatrix[4][219] = 1;
   assign ecchmatrix[5][219] = 0;
   assign ecchmatrix[6][219] = 0;
   assign ecchmatrix[7][219] = 1;
   assign ecchmatrix[8][219] = 0;
   assign ecchmatrix[9][219] = 1;
   assign ecchmatrix[0][220] = 1;
   assign ecchmatrix[1][220] = 0;
   assign ecchmatrix[2][220] = 0;
   assign ecchmatrix[3][220] = 1;
   assign ecchmatrix[4][220] = 1;
   assign ecchmatrix[5][220] = 0;
   assign ecchmatrix[6][220] = 0;
   assign ecchmatrix[7][220] = 0;
   assign ecchmatrix[8][220] = 1;
   assign ecchmatrix[9][220] = 1;
   assign ecchmatrix[0][221] = 1;
   assign ecchmatrix[1][221] = 0;
   assign ecchmatrix[2][221] = 0;
   assign ecchmatrix[3][221] = 1;
   assign ecchmatrix[4][221] = 0;
   assign ecchmatrix[5][221] = 1;
   assign ecchmatrix[6][221] = 1;
   assign ecchmatrix[7][221] = 1;
   assign ecchmatrix[8][221] = 0;
   assign ecchmatrix[9][221] = 0;
   assign ecchmatrix[0][222] = 1;
   assign ecchmatrix[1][222] = 0;
   assign ecchmatrix[2][222] = 0;
   assign ecchmatrix[3][222] = 1;
   assign ecchmatrix[4][222] = 0;
   assign ecchmatrix[5][222] = 1;
   assign ecchmatrix[6][222] = 1;
   assign ecchmatrix[7][222] = 0;
   assign ecchmatrix[8][222] = 1;
   assign ecchmatrix[9][222] = 0;
   assign ecchmatrix[0][223] = 1;
   assign ecchmatrix[1][223] = 0;
   assign ecchmatrix[2][223] = 0;
   assign ecchmatrix[3][223] = 1;
   assign ecchmatrix[4][223] = 0;
   assign ecchmatrix[5][223] = 1;
   assign ecchmatrix[6][223] = 1;
   assign ecchmatrix[7][223] = 0;
   assign ecchmatrix[8][223] = 0;
   assign ecchmatrix[9][223] = 1;
   assign ecchmatrix[0][224] = 1;
   assign ecchmatrix[1][224] = 0;
   assign ecchmatrix[2][224] = 0;
   assign ecchmatrix[3][224] = 1;
   assign ecchmatrix[4][224] = 0;
   assign ecchmatrix[5][224] = 1;
   assign ecchmatrix[6][224] = 0;
   assign ecchmatrix[7][224] = 1;
   assign ecchmatrix[8][224] = 1;
   assign ecchmatrix[9][224] = 0;
   assign ecchmatrix[0][225] = 1;
   assign ecchmatrix[1][225] = 0;
   assign ecchmatrix[2][225] = 0;
   assign ecchmatrix[3][225] = 1;
   assign ecchmatrix[4][225] = 0;
   assign ecchmatrix[5][225] = 1;
   assign ecchmatrix[6][225] = 0;
   assign ecchmatrix[7][225] = 1;
   assign ecchmatrix[8][225] = 0;
   assign ecchmatrix[9][225] = 1;
   assign ecchmatrix[0][226] = 1;
   assign ecchmatrix[1][226] = 0;
   assign ecchmatrix[2][226] = 0;
   assign ecchmatrix[3][226] = 1;
   assign ecchmatrix[4][226] = 0;
   assign ecchmatrix[5][226] = 1;
   assign ecchmatrix[6][226] = 0;
   assign ecchmatrix[7][226] = 0;
   assign ecchmatrix[8][226] = 1;
   assign ecchmatrix[9][226] = 1;
   assign ecchmatrix[0][227] = 1;
   assign ecchmatrix[1][227] = 0;
   assign ecchmatrix[2][227] = 0;
   assign ecchmatrix[3][227] = 1;
   assign ecchmatrix[4][227] = 0;
   assign ecchmatrix[5][227] = 0;
   assign ecchmatrix[6][227] = 1;
   assign ecchmatrix[7][227] = 1;
   assign ecchmatrix[8][227] = 1;
   assign ecchmatrix[9][227] = 0;
   assign ecchmatrix[0][228] = 1;
   assign ecchmatrix[1][228] = 0;
   assign ecchmatrix[2][228] = 0;
   assign ecchmatrix[3][228] = 1;
   assign ecchmatrix[4][228] = 0;
   assign ecchmatrix[5][228] = 0;
   assign ecchmatrix[6][228] = 1;
   assign ecchmatrix[7][228] = 1;
   assign ecchmatrix[8][228] = 0;
   assign ecchmatrix[9][228] = 1;
   assign ecchmatrix[0][229] = 1;
   assign ecchmatrix[1][229] = 0;
   assign ecchmatrix[2][229] = 0;
   assign ecchmatrix[3][229] = 1;
   assign ecchmatrix[4][229] = 0;
   assign ecchmatrix[5][229] = 0;
   assign ecchmatrix[6][229] = 1;
   assign ecchmatrix[7][229] = 0;
   assign ecchmatrix[8][229] = 1;
   assign ecchmatrix[9][229] = 1;
   assign ecchmatrix[0][230] = 1;
   assign ecchmatrix[1][230] = 0;
   assign ecchmatrix[2][230] = 0;
   assign ecchmatrix[3][230] = 1;
   assign ecchmatrix[4][230] = 0;
   assign ecchmatrix[5][230] = 0;
   assign ecchmatrix[6][230] = 0;
   assign ecchmatrix[7][230] = 1;
   assign ecchmatrix[8][230] = 1;
   assign ecchmatrix[9][230] = 1;
   assign ecchmatrix[0][231] = 1;
   assign ecchmatrix[1][231] = 0;
   assign ecchmatrix[2][231] = 0;
   assign ecchmatrix[3][231] = 0;
   assign ecchmatrix[4][231] = 1;
   assign ecchmatrix[5][231] = 1;
   assign ecchmatrix[6][231] = 1;
   assign ecchmatrix[7][231] = 1;
   assign ecchmatrix[8][231] = 0;
   assign ecchmatrix[9][231] = 0;
   assign ecchmatrix[0][232] = 1;
   assign ecchmatrix[1][232] = 0;
   assign ecchmatrix[2][232] = 0;
   assign ecchmatrix[3][232] = 0;
   assign ecchmatrix[4][232] = 1;
   assign ecchmatrix[5][232] = 1;
   assign ecchmatrix[6][232] = 1;
   assign ecchmatrix[7][232] = 0;
   assign ecchmatrix[8][232] = 1;
   assign ecchmatrix[9][232] = 0;
   assign ecchmatrix[0][233] = 1;
   assign ecchmatrix[1][233] = 0;
   assign ecchmatrix[2][233] = 0;
   assign ecchmatrix[3][233] = 0;
   assign ecchmatrix[4][233] = 1;
   assign ecchmatrix[5][233] = 1;
   assign ecchmatrix[6][233] = 1;
   assign ecchmatrix[7][233] = 0;
   assign ecchmatrix[8][233] = 0;
   assign ecchmatrix[9][233] = 1;
   assign ecchmatrix[0][234] = 1;
   assign ecchmatrix[1][234] = 0;
   assign ecchmatrix[2][234] = 0;
   assign ecchmatrix[3][234] = 0;
   assign ecchmatrix[4][234] = 1;
   assign ecchmatrix[5][234] = 1;
   assign ecchmatrix[6][234] = 0;
   assign ecchmatrix[7][234] = 1;
   assign ecchmatrix[8][234] = 1;
   assign ecchmatrix[9][234] = 0;
   assign ecchmatrix[0][235] = 1;
   assign ecchmatrix[1][235] = 0;
   assign ecchmatrix[2][235] = 0;
   assign ecchmatrix[3][235] = 0;
   assign ecchmatrix[4][235] = 1;
   assign ecchmatrix[5][235] = 1;
   assign ecchmatrix[6][235] = 0;
   assign ecchmatrix[7][235] = 1;
   assign ecchmatrix[8][235] = 0;
   assign ecchmatrix[9][235] = 1;
   assign ecchmatrix[0][236] = 1;
   assign ecchmatrix[1][236] = 0;
   assign ecchmatrix[2][236] = 0;
   assign ecchmatrix[3][236] = 0;
   assign ecchmatrix[4][236] = 1;
   assign ecchmatrix[5][236] = 1;
   assign ecchmatrix[6][236] = 0;
   assign ecchmatrix[7][236] = 0;
   assign ecchmatrix[8][236] = 1;
   assign ecchmatrix[9][236] = 1;
   assign ecchmatrix[0][237] = 1;
   assign ecchmatrix[1][237] = 0;
   assign ecchmatrix[2][237] = 0;
   assign ecchmatrix[3][237] = 0;
   assign ecchmatrix[4][237] = 1;
   assign ecchmatrix[5][237] = 0;
   assign ecchmatrix[6][237] = 1;
   assign ecchmatrix[7][237] = 1;
   assign ecchmatrix[8][237] = 1;
   assign ecchmatrix[9][237] = 0;
   assign ecchmatrix[0][238] = 1;
   assign ecchmatrix[1][238] = 0;
   assign ecchmatrix[2][238] = 0;
   assign ecchmatrix[3][238] = 0;
   assign ecchmatrix[4][238] = 1;
   assign ecchmatrix[5][238] = 0;
   assign ecchmatrix[6][238] = 1;
   assign ecchmatrix[7][238] = 1;
   assign ecchmatrix[8][238] = 0;
   assign ecchmatrix[9][238] = 1;
   assign ecchmatrix[0][239] = 1;
   assign ecchmatrix[1][239] = 0;
   assign ecchmatrix[2][239] = 0;
   assign ecchmatrix[3][239] = 0;
   assign ecchmatrix[4][239] = 1;
   assign ecchmatrix[5][239] = 0;
   assign ecchmatrix[6][239] = 1;
   assign ecchmatrix[7][239] = 0;
   assign ecchmatrix[8][239] = 1;
   assign ecchmatrix[9][239] = 1;
   assign ecchmatrix[0][240] = 1;
   assign ecchmatrix[1][240] = 0;
   assign ecchmatrix[2][240] = 0;
   assign ecchmatrix[3][240] = 0;
   assign ecchmatrix[4][240] = 1;
   assign ecchmatrix[5][240] = 0;
   assign ecchmatrix[6][240] = 0;
   assign ecchmatrix[7][240] = 1;
   assign ecchmatrix[8][240] = 1;
   assign ecchmatrix[9][240] = 1;
   assign ecchmatrix[0][241] = 1;
   assign ecchmatrix[1][241] = 0;
   assign ecchmatrix[2][241] = 0;
   assign ecchmatrix[3][241] = 0;
   assign ecchmatrix[4][241] = 0;
   assign ecchmatrix[5][241] = 1;
   assign ecchmatrix[6][241] = 1;
   assign ecchmatrix[7][241] = 1;
   assign ecchmatrix[8][241] = 1;
   assign ecchmatrix[9][241] = 0;
   assign ecchmatrix[0][242] = 1;
   assign ecchmatrix[1][242] = 0;
   assign ecchmatrix[2][242] = 0;
   assign ecchmatrix[3][242] = 0;
   assign ecchmatrix[4][242] = 0;
   assign ecchmatrix[5][242] = 1;
   assign ecchmatrix[6][242] = 1;
   assign ecchmatrix[7][242] = 1;
   assign ecchmatrix[8][242] = 0;
   assign ecchmatrix[9][242] = 1;
   assign ecchmatrix[0][243] = 1;
   assign ecchmatrix[1][243] = 0;
   assign ecchmatrix[2][243] = 0;
   assign ecchmatrix[3][243] = 0;
   assign ecchmatrix[4][243] = 0;
   assign ecchmatrix[5][243] = 1;
   assign ecchmatrix[6][243] = 1;
   assign ecchmatrix[7][243] = 0;
   assign ecchmatrix[8][243] = 1;
   assign ecchmatrix[9][243] = 1;
   assign ecchmatrix[0][244] = 1;
   assign ecchmatrix[1][244] = 0;
   assign ecchmatrix[2][244] = 0;
   assign ecchmatrix[3][244] = 0;
   assign ecchmatrix[4][244] = 0;
   assign ecchmatrix[5][244] = 1;
   assign ecchmatrix[6][244] = 0;
   assign ecchmatrix[7][244] = 1;
   assign ecchmatrix[8][244] = 1;
   assign ecchmatrix[9][244] = 1;
   assign ecchmatrix[0][245] = 1;
   assign ecchmatrix[1][245] = 0;
   assign ecchmatrix[2][245] = 0;
   assign ecchmatrix[3][245] = 0;
   assign ecchmatrix[4][245] = 0;
   assign ecchmatrix[5][245] = 0;
   assign ecchmatrix[6][245] = 1;
   assign ecchmatrix[7][245] = 1;
   assign ecchmatrix[8][245] = 1;
   assign ecchmatrix[9][245] = 1;
   assign ecchmatrix[0][246] = 0;
   assign ecchmatrix[1][246] = 1;
   assign ecchmatrix[2][246] = 1;
   assign ecchmatrix[3][246] = 1;
   assign ecchmatrix[4][246] = 1;
   assign ecchmatrix[5][246] = 1;
   assign ecchmatrix[6][246] = 0;
   assign ecchmatrix[7][246] = 0;
   assign ecchmatrix[8][246] = 0;
   assign ecchmatrix[9][246] = 0;
   assign ecchmatrix[0][247] = 0;
   assign ecchmatrix[1][247] = 1;
   assign ecchmatrix[2][247] = 1;
   assign ecchmatrix[3][247] = 1;
   assign ecchmatrix[4][247] = 1;
   assign ecchmatrix[5][247] = 0;
   assign ecchmatrix[6][247] = 1;
   assign ecchmatrix[7][247] = 0;
   assign ecchmatrix[8][247] = 0;
   assign ecchmatrix[9][247] = 0;
   assign ecchmatrix[0][248] = 0;
   assign ecchmatrix[1][248] = 1;
   assign ecchmatrix[2][248] = 1;
   assign ecchmatrix[3][248] = 1;
   assign ecchmatrix[4][248] = 1;
   assign ecchmatrix[5][248] = 0;
   assign ecchmatrix[6][248] = 0;
   assign ecchmatrix[7][248] = 1;
   assign ecchmatrix[8][248] = 0;
   assign ecchmatrix[9][248] = 0;
   assign ecchmatrix[0][249] = 0;
   assign ecchmatrix[1][249] = 1;
   assign ecchmatrix[2][249] = 1;
   assign ecchmatrix[3][249] = 1;
   assign ecchmatrix[4][249] = 1;
   assign ecchmatrix[5][249] = 0;
   assign ecchmatrix[6][249] = 0;
   assign ecchmatrix[7][249] = 0;
   assign ecchmatrix[8][249] = 1;
   assign ecchmatrix[9][249] = 0;
   assign ecchmatrix[0][250] = 0;
   assign ecchmatrix[1][250] = 1;
   assign ecchmatrix[2][250] = 1;
   assign ecchmatrix[3][250] = 1;
   assign ecchmatrix[4][250] = 1;
   assign ecchmatrix[5][250] = 0;
   assign ecchmatrix[6][250] = 0;
   assign ecchmatrix[7][250] = 0;
   assign ecchmatrix[8][250] = 0;
   assign ecchmatrix[9][250] = 1;
   assign ecchmatrix[0][251] = 0;
   assign ecchmatrix[1][251] = 1;
   assign ecchmatrix[2][251] = 1;
   assign ecchmatrix[3][251] = 1;
   assign ecchmatrix[4][251] = 0;
   assign ecchmatrix[5][251] = 1;
   assign ecchmatrix[6][251] = 1;
   assign ecchmatrix[7][251] = 0;
   assign ecchmatrix[8][251] = 0;
   assign ecchmatrix[9][251] = 0;
   assign ecchmatrix[0][252] = 0;
   assign ecchmatrix[1][252] = 1;
   assign ecchmatrix[2][252] = 1;
   assign ecchmatrix[3][252] = 1;
   assign ecchmatrix[4][252] = 0;
   assign ecchmatrix[5][252] = 1;
   assign ecchmatrix[6][252] = 0;
   assign ecchmatrix[7][252] = 1;
   assign ecchmatrix[8][252] = 0;
   assign ecchmatrix[9][252] = 0;
   assign ecchmatrix[0][253] = 0;
   assign ecchmatrix[1][253] = 1;
   assign ecchmatrix[2][253] = 1;
   assign ecchmatrix[3][253] = 1;
   assign ecchmatrix[4][253] = 0;
   assign ecchmatrix[5][253] = 1;
   assign ecchmatrix[6][253] = 0;
   assign ecchmatrix[7][253] = 0;
   assign ecchmatrix[8][253] = 1;
   assign ecchmatrix[9][253] = 0;
   assign ecchmatrix[0][254] = 0;
   assign ecchmatrix[1][254] = 1;
   assign ecchmatrix[2][254] = 1;
   assign ecchmatrix[3][254] = 1;
   assign ecchmatrix[4][254] = 0;
   assign ecchmatrix[5][254] = 1;
   assign ecchmatrix[6][254] = 0;
   assign ecchmatrix[7][254] = 0;
   assign ecchmatrix[8][254] = 0;
   assign ecchmatrix[9][254] = 1;
   assign ecchmatrix[0][255] = 0;
   assign ecchmatrix[1][255] = 1;
   assign ecchmatrix[2][255] = 1;
   assign ecchmatrix[3][255] = 1;
   assign ecchmatrix[4][255] = 0;
   assign ecchmatrix[5][255] = 0;
   assign ecchmatrix[6][255] = 1;
   assign ecchmatrix[7][255] = 1;
   assign ecchmatrix[8][255] = 0;
   assign ecchmatrix[9][255] = 0;
   assign ecchmatrix[0][256] = 0;
   assign ecchmatrix[1][256] = 1;
   assign ecchmatrix[2][256] = 1;
   assign ecchmatrix[3][256] = 1;
   assign ecchmatrix[4][256] = 0;
   assign ecchmatrix[5][256] = 0;
   assign ecchmatrix[6][256] = 1;
   assign ecchmatrix[7][256] = 0;
   assign ecchmatrix[8][256] = 1;
   assign ecchmatrix[9][256] = 0;
   assign ecchmatrix[0][257] = 0;
   assign ecchmatrix[1][257] = 1;
   assign ecchmatrix[2][257] = 1;
   assign ecchmatrix[3][257] = 1;
   assign ecchmatrix[4][257] = 0;
   assign ecchmatrix[5][257] = 0;
   assign ecchmatrix[6][257] = 1;
   assign ecchmatrix[7][257] = 0;
   assign ecchmatrix[8][257] = 0;
   assign ecchmatrix[9][257] = 1;
   assign ecchmatrix[0][258] = 0;
   assign ecchmatrix[1][258] = 1;
   assign ecchmatrix[2][258] = 1;
   assign ecchmatrix[3][258] = 1;
   assign ecchmatrix[4][258] = 0;
   assign ecchmatrix[5][258] = 0;
   assign ecchmatrix[6][258] = 0;
   assign ecchmatrix[7][258] = 1;
   assign ecchmatrix[8][258] = 1;
   assign ecchmatrix[9][258] = 0;
   assign ecchmatrix[0][259] = 0;
   assign ecchmatrix[1][259] = 1;
   assign ecchmatrix[2][259] = 1;
   assign ecchmatrix[3][259] = 1;
   assign ecchmatrix[4][259] = 0;
   assign ecchmatrix[5][259] = 0;
   assign ecchmatrix[6][259] = 0;
   assign ecchmatrix[7][259] = 1;
   assign ecchmatrix[8][259] = 0;
   assign ecchmatrix[9][259] = 1;
   assign ecchmatrix[0][260] = 0;
   assign ecchmatrix[1][260] = 1;
   assign ecchmatrix[2][260] = 1;
   assign ecchmatrix[3][260] = 1;
   assign ecchmatrix[4][260] = 0;
   assign ecchmatrix[5][260] = 0;
   assign ecchmatrix[6][260] = 0;
   assign ecchmatrix[7][260] = 0;
   assign ecchmatrix[8][260] = 1;
   assign ecchmatrix[9][260] = 1;
   assign ecchmatrix[0][261] = 0;
   assign ecchmatrix[1][261] = 1;
   assign ecchmatrix[2][261] = 1;
   assign ecchmatrix[3][261] = 0;
   assign ecchmatrix[4][261] = 1;
   assign ecchmatrix[5][261] = 1;
   assign ecchmatrix[6][261] = 1;
   assign ecchmatrix[7][261] = 0;
   assign ecchmatrix[8][261] = 0;
   assign ecchmatrix[9][261] = 0;
   assign ecchmatrix[0][262] = 0;
   assign ecchmatrix[1][262] = 1;
   assign ecchmatrix[2][262] = 1;
   assign ecchmatrix[3][262] = 0;
   assign ecchmatrix[4][262] = 1;
   assign ecchmatrix[5][262] = 1;
   assign ecchmatrix[6][262] = 0;
   assign ecchmatrix[7][262] = 1;
   assign ecchmatrix[8][262] = 0;
   assign ecchmatrix[9][262] = 0;
   assign ecchmatrix[0][263] = 0;
   assign ecchmatrix[1][263] = 1;
   assign ecchmatrix[2][263] = 1;
   assign ecchmatrix[3][263] = 0;
   assign ecchmatrix[4][263] = 1;
   assign ecchmatrix[5][263] = 1;
   assign ecchmatrix[6][263] = 0;
   assign ecchmatrix[7][263] = 0;
   assign ecchmatrix[8][263] = 1;
   assign ecchmatrix[9][263] = 0;
   assign ecchmatrix[0][264] = 0;
   assign ecchmatrix[1][264] = 1;
   assign ecchmatrix[2][264] = 1;
   assign ecchmatrix[3][264] = 0;
   assign ecchmatrix[4][264] = 1;
   assign ecchmatrix[5][264] = 1;
   assign ecchmatrix[6][264] = 0;
   assign ecchmatrix[7][264] = 0;
   assign ecchmatrix[8][264] = 0;
   assign ecchmatrix[9][264] = 1;
   assign ecchmatrix[0][265] = 0;
   assign ecchmatrix[1][265] = 1;
   assign ecchmatrix[2][265] = 1;
   assign ecchmatrix[3][265] = 0;
   assign ecchmatrix[4][265] = 1;
   assign ecchmatrix[5][265] = 0;
   assign ecchmatrix[6][265] = 1;
   assign ecchmatrix[7][265] = 1;
   assign ecchmatrix[8][265] = 0;
   assign ecchmatrix[9][265] = 0;
   assign ecchmatrix[0][266] = 0;
   assign ecchmatrix[1][266] = 1;
   assign ecchmatrix[2][266] = 1;
   assign ecchmatrix[3][266] = 0;
   assign ecchmatrix[4][266] = 1;
   assign ecchmatrix[5][266] = 0;
   assign ecchmatrix[6][266] = 1;
   assign ecchmatrix[7][266] = 0;
   assign ecchmatrix[8][266] = 1;
   assign ecchmatrix[9][266] = 0;
   assign ecchmatrix[0][267] = 0;
   assign ecchmatrix[1][267] = 1;
   assign ecchmatrix[2][267] = 1;
   assign ecchmatrix[3][267] = 0;
   assign ecchmatrix[4][267] = 1;
   assign ecchmatrix[5][267] = 0;
   assign ecchmatrix[6][267] = 1;
   assign ecchmatrix[7][267] = 0;
   assign ecchmatrix[8][267] = 0;
   assign ecchmatrix[9][267] = 1;
   assign ecchmatrix[0][268] = 0;
   assign ecchmatrix[1][268] = 1;
   assign ecchmatrix[2][268] = 1;
   assign ecchmatrix[3][268] = 0;
   assign ecchmatrix[4][268] = 1;
   assign ecchmatrix[5][268] = 0;
   assign ecchmatrix[6][268] = 0;
   assign ecchmatrix[7][268] = 1;
   assign ecchmatrix[8][268] = 1;
   assign ecchmatrix[9][268] = 0;
   assign ecchmatrix[0][269] = 0;
   assign ecchmatrix[1][269] = 1;
   assign ecchmatrix[2][269] = 1;
   assign ecchmatrix[3][269] = 0;
   assign ecchmatrix[4][269] = 1;
   assign ecchmatrix[5][269] = 0;
   assign ecchmatrix[6][269] = 0;
   assign ecchmatrix[7][269] = 1;
   assign ecchmatrix[8][269] = 0;
   assign ecchmatrix[9][269] = 1;
   assign ecchmatrix[0][270] = 0;
   assign ecchmatrix[1][270] = 1;
   assign ecchmatrix[2][270] = 1;
   assign ecchmatrix[3][270] = 0;
   assign ecchmatrix[4][270] = 1;
   assign ecchmatrix[5][270] = 0;
   assign ecchmatrix[6][270] = 0;
   assign ecchmatrix[7][270] = 0;
   assign ecchmatrix[8][270] = 1;
   assign ecchmatrix[9][270] = 1;
   assign ecchmatrix[0][271] = 0;
   assign ecchmatrix[1][271] = 1;
   assign ecchmatrix[2][271] = 1;
   assign ecchmatrix[3][271] = 0;
   assign ecchmatrix[4][271] = 0;
   assign ecchmatrix[5][271] = 1;
   assign ecchmatrix[6][271] = 1;
   assign ecchmatrix[7][271] = 1;
   assign ecchmatrix[8][271] = 0;
   assign ecchmatrix[9][271] = 0;
   assign ecchmatrix[0][272] = 0;
   assign ecchmatrix[1][272] = 1;
   assign ecchmatrix[2][272] = 1;
   assign ecchmatrix[3][272] = 0;
   assign ecchmatrix[4][272] = 0;
   assign ecchmatrix[5][272] = 1;
   assign ecchmatrix[6][272] = 1;
   assign ecchmatrix[7][272] = 0;
   assign ecchmatrix[8][272] = 1;
   assign ecchmatrix[9][272] = 0;
   assign ecchmatrix[0][273] = 0;
   assign ecchmatrix[1][273] = 1;
   assign ecchmatrix[2][273] = 1;
   assign ecchmatrix[3][273] = 0;
   assign ecchmatrix[4][273] = 0;
   assign ecchmatrix[5][273] = 1;
   assign ecchmatrix[6][273] = 1;
   assign ecchmatrix[7][273] = 0;
   assign ecchmatrix[8][273] = 0;
   assign ecchmatrix[9][273] = 1;
   assign ecchmatrix[0][274] = 0;
   assign ecchmatrix[1][274] = 1;
   assign ecchmatrix[2][274] = 1;
   assign ecchmatrix[3][274] = 0;
   assign ecchmatrix[4][274] = 0;
   assign ecchmatrix[5][274] = 1;
   assign ecchmatrix[6][274] = 0;
   assign ecchmatrix[7][274] = 1;
   assign ecchmatrix[8][274] = 1;
   assign ecchmatrix[9][274] = 0;
   assign ecchmatrix[0][275] = 0;
   assign ecchmatrix[1][275] = 1;
   assign ecchmatrix[2][275] = 1;
   assign ecchmatrix[3][275] = 0;
   assign ecchmatrix[4][275] = 0;
   assign ecchmatrix[5][275] = 1;
   assign ecchmatrix[6][275] = 0;
   assign ecchmatrix[7][275] = 1;
   assign ecchmatrix[8][275] = 0;
   assign ecchmatrix[9][275] = 1;
   assign ecchmatrix[0][276] = 0;
   assign ecchmatrix[1][276] = 1;
   assign ecchmatrix[2][276] = 1;
   assign ecchmatrix[3][276] = 0;
   assign ecchmatrix[4][276] = 0;
   assign ecchmatrix[5][276] = 1;
   assign ecchmatrix[6][276] = 0;
   assign ecchmatrix[7][276] = 0;
   assign ecchmatrix[8][276] = 1;
   assign ecchmatrix[9][276] = 1;
   assign ecchmatrix[0][277] = 0;
   assign ecchmatrix[1][277] = 1;
   assign ecchmatrix[2][277] = 1;
   assign ecchmatrix[3][277] = 0;
   assign ecchmatrix[4][277] = 0;
   assign ecchmatrix[5][277] = 0;
   assign ecchmatrix[6][277] = 1;
   assign ecchmatrix[7][277] = 1;
   assign ecchmatrix[8][277] = 1;
   assign ecchmatrix[9][277] = 0;
   assign ecchmatrix[0][278] = 0;
   assign ecchmatrix[1][278] = 1;
   assign ecchmatrix[2][278] = 1;
   assign ecchmatrix[3][278] = 0;
   assign ecchmatrix[4][278] = 0;
   assign ecchmatrix[5][278] = 0;
   assign ecchmatrix[6][278] = 1;
   assign ecchmatrix[7][278] = 1;
   assign ecchmatrix[8][278] = 0;
   assign ecchmatrix[9][278] = 1;
   assign ecchmatrix[0][279] = 0;
   assign ecchmatrix[1][279] = 1;
   assign ecchmatrix[2][279] = 1;
   assign ecchmatrix[3][279] = 0;
   assign ecchmatrix[4][279] = 0;
   assign ecchmatrix[5][279] = 0;
   assign ecchmatrix[6][279] = 1;
   assign ecchmatrix[7][279] = 0;
   assign ecchmatrix[8][279] = 1;
   assign ecchmatrix[9][279] = 1;
   assign ecchmatrix[0][280] = 0;
   assign ecchmatrix[1][280] = 1;
   assign ecchmatrix[2][280] = 1;
   assign ecchmatrix[3][280] = 0;
   assign ecchmatrix[4][280] = 0;
   assign ecchmatrix[5][280] = 0;
   assign ecchmatrix[6][280] = 0;
   assign ecchmatrix[7][280] = 1;
   assign ecchmatrix[8][280] = 1;
   assign ecchmatrix[9][280] = 1;
   assign ecchmatrix[0][281] = 0;
   assign ecchmatrix[1][281] = 1;
   assign ecchmatrix[2][281] = 0;
   assign ecchmatrix[3][281] = 1;
   assign ecchmatrix[4][281] = 1;
   assign ecchmatrix[5][281] = 1;
   assign ecchmatrix[6][281] = 1;
   assign ecchmatrix[7][281] = 0;
   assign ecchmatrix[8][281] = 0;
   assign ecchmatrix[9][281] = 0;
   assign ecchmatrix[0][282] = 0;
   assign ecchmatrix[1][282] = 1;
   assign ecchmatrix[2][282] = 0;
   assign ecchmatrix[3][282] = 1;
   assign ecchmatrix[4][282] = 1;
   assign ecchmatrix[5][282] = 1;
   assign ecchmatrix[6][282] = 0;
   assign ecchmatrix[7][282] = 1;
   assign ecchmatrix[8][282] = 0;
   assign ecchmatrix[9][282] = 0;
   assign ecchmatrix[0][283] = 0;
   assign ecchmatrix[1][283] = 1;
   assign ecchmatrix[2][283] = 0;
   assign ecchmatrix[3][283] = 1;
   assign ecchmatrix[4][283] = 1;
   assign ecchmatrix[5][283] = 1;
   assign ecchmatrix[6][283] = 0;
   assign ecchmatrix[7][283] = 0;
   assign ecchmatrix[8][283] = 1;
   assign ecchmatrix[9][283] = 0;
   assign ecchmatrix[0][284] = 0;
   assign ecchmatrix[1][284] = 1;
   assign ecchmatrix[2][284] = 0;
   assign ecchmatrix[3][284] = 1;
   assign ecchmatrix[4][284] = 1;
   assign ecchmatrix[5][284] = 1;
   assign ecchmatrix[6][284] = 0;
   assign ecchmatrix[7][284] = 0;
   assign ecchmatrix[8][284] = 0;
   assign ecchmatrix[9][284] = 1;
   assign ecchmatrix[0][285] = 0;
   assign ecchmatrix[1][285] = 1;
   assign ecchmatrix[2][285] = 0;
   assign ecchmatrix[3][285] = 1;
   assign ecchmatrix[4][285] = 1;
   assign ecchmatrix[5][285] = 0;
   assign ecchmatrix[6][285] = 1;
   assign ecchmatrix[7][285] = 1;
   assign ecchmatrix[8][285] = 0;
   assign ecchmatrix[9][285] = 0;
   assign ecchmatrix[0][286] = 0;
   assign ecchmatrix[1][286] = 1;
   assign ecchmatrix[2][286] = 0;
   assign ecchmatrix[3][286] = 1;
   assign ecchmatrix[4][286] = 1;
   assign ecchmatrix[5][286] = 0;
   assign ecchmatrix[6][286] = 1;
   assign ecchmatrix[7][286] = 0;
   assign ecchmatrix[8][286] = 1;
   assign ecchmatrix[9][286] = 0;
   assign ecchmatrix[0][287] = 0;
   assign ecchmatrix[1][287] = 1;
   assign ecchmatrix[2][287] = 0;
   assign ecchmatrix[3][287] = 1;
   assign ecchmatrix[4][287] = 1;
   assign ecchmatrix[5][287] = 0;
   assign ecchmatrix[6][287] = 1;
   assign ecchmatrix[7][287] = 0;
   assign ecchmatrix[8][287] = 0;
   assign ecchmatrix[9][287] = 1;
   assign ecchmatrix[0][288] = 0;
   assign ecchmatrix[1][288] = 1;
   assign ecchmatrix[2][288] = 0;
   assign ecchmatrix[3][288] = 1;
   assign ecchmatrix[4][288] = 1;
   assign ecchmatrix[5][288] = 0;
   assign ecchmatrix[6][288] = 0;
   assign ecchmatrix[7][288] = 1;
   assign ecchmatrix[8][288] = 1;
   assign ecchmatrix[9][288] = 0;
   assign ecchmatrix[0][289] = 0;
   assign ecchmatrix[1][289] = 1;
   assign ecchmatrix[2][289] = 0;
   assign ecchmatrix[3][289] = 1;
   assign ecchmatrix[4][289] = 1;
   assign ecchmatrix[5][289] = 0;
   assign ecchmatrix[6][289] = 0;
   assign ecchmatrix[7][289] = 1;
   assign ecchmatrix[8][289] = 0;
   assign ecchmatrix[9][289] = 1;
   assign ecchmatrix[0][290] = 0;
   assign ecchmatrix[1][290] = 1;
   assign ecchmatrix[2][290] = 0;
   assign ecchmatrix[3][290] = 1;
   assign ecchmatrix[4][290] = 1;
   assign ecchmatrix[5][290] = 0;
   assign ecchmatrix[6][290] = 0;
   assign ecchmatrix[7][290] = 0;
   assign ecchmatrix[8][290] = 1;
   assign ecchmatrix[9][290] = 1;
   assign ecchmatrix[0][291] = 0;
   assign ecchmatrix[1][291] = 1;
   assign ecchmatrix[2][291] = 0;
   assign ecchmatrix[3][291] = 1;
   assign ecchmatrix[4][291] = 0;
   assign ecchmatrix[5][291] = 1;
   assign ecchmatrix[6][291] = 1;
   assign ecchmatrix[7][291] = 1;
   assign ecchmatrix[8][291] = 0;
   assign ecchmatrix[9][291] = 0;
   assign ecchmatrix[0][292] = 0;
   assign ecchmatrix[1][292] = 1;
   assign ecchmatrix[2][292] = 0;
   assign ecchmatrix[3][292] = 1;
   assign ecchmatrix[4][292] = 0;
   assign ecchmatrix[5][292] = 1;
   assign ecchmatrix[6][292] = 1;
   assign ecchmatrix[7][292] = 0;
   assign ecchmatrix[8][292] = 1;
   assign ecchmatrix[9][292] = 0;
   assign ecchmatrix[0][293] = 0;
   assign ecchmatrix[1][293] = 1;
   assign ecchmatrix[2][293] = 0;
   assign ecchmatrix[3][293] = 1;
   assign ecchmatrix[4][293] = 0;
   assign ecchmatrix[5][293] = 1;
   assign ecchmatrix[6][293] = 1;
   assign ecchmatrix[7][293] = 0;
   assign ecchmatrix[8][293] = 0;
   assign ecchmatrix[9][293] = 1;
   assign ecchmatrix[0][294] = 0;
   assign ecchmatrix[1][294] = 1;
   assign ecchmatrix[2][294] = 0;
   assign ecchmatrix[3][294] = 1;
   assign ecchmatrix[4][294] = 0;
   assign ecchmatrix[5][294] = 1;
   assign ecchmatrix[6][294] = 0;
   assign ecchmatrix[7][294] = 1;
   assign ecchmatrix[8][294] = 1;
   assign ecchmatrix[9][294] = 0;
   assign ecchmatrix[0][295] = 0;
   assign ecchmatrix[1][295] = 1;
   assign ecchmatrix[2][295] = 0;
   assign ecchmatrix[3][295] = 1;
   assign ecchmatrix[4][295] = 0;
   assign ecchmatrix[5][295] = 1;
   assign ecchmatrix[6][295] = 0;
   assign ecchmatrix[7][295] = 1;
   assign ecchmatrix[8][295] = 0;
   assign ecchmatrix[9][295] = 1;
   assign ecchmatrix[0][296] = 0;
   assign ecchmatrix[1][296] = 1;
   assign ecchmatrix[2][296] = 0;
   assign ecchmatrix[3][296] = 1;
   assign ecchmatrix[4][296] = 0;
   assign ecchmatrix[5][296] = 1;
   assign ecchmatrix[6][296] = 0;
   assign ecchmatrix[7][296] = 0;
   assign ecchmatrix[8][296] = 1;
   assign ecchmatrix[9][296] = 1;
   assign ecchmatrix[0][297] = 0;
   assign ecchmatrix[1][297] = 1;
   assign ecchmatrix[2][297] = 0;
   assign ecchmatrix[3][297] = 1;
   assign ecchmatrix[4][297] = 0;
   assign ecchmatrix[5][297] = 0;
   assign ecchmatrix[6][297] = 1;
   assign ecchmatrix[7][297] = 1;
   assign ecchmatrix[8][297] = 1;
   assign ecchmatrix[9][297] = 0;
   assign ecchmatrix[0][298] = 0;
   assign ecchmatrix[1][298] = 1;
   assign ecchmatrix[2][298] = 0;
   assign ecchmatrix[3][298] = 1;
   assign ecchmatrix[4][298] = 0;
   assign ecchmatrix[5][298] = 0;
   assign ecchmatrix[6][298] = 1;
   assign ecchmatrix[7][298] = 1;
   assign ecchmatrix[8][298] = 0;
   assign ecchmatrix[9][298] = 1;
   assign ecchmatrix[0][299] = 0;
   assign ecchmatrix[1][299] = 1;
   assign ecchmatrix[2][299] = 0;
   assign ecchmatrix[3][299] = 1;
   assign ecchmatrix[4][299] = 0;
   assign ecchmatrix[5][299] = 0;
   assign ecchmatrix[6][299] = 1;
   assign ecchmatrix[7][299] = 0;
   assign ecchmatrix[8][299] = 1;
   assign ecchmatrix[9][299] = 1;
   assign ecchmatrix[0][300] = 0;
   assign ecchmatrix[1][300] = 1;
   assign ecchmatrix[2][300] = 0;
   assign ecchmatrix[3][300] = 1;
   assign ecchmatrix[4][300] = 0;
   assign ecchmatrix[5][300] = 0;
   assign ecchmatrix[6][300] = 0;
   assign ecchmatrix[7][300] = 1;
   assign ecchmatrix[8][300] = 1;
   assign ecchmatrix[9][300] = 1;
   assign ecchmatrix[0][301] = 0;
   assign ecchmatrix[1][301] = 1;
   assign ecchmatrix[2][301] = 0;
   assign ecchmatrix[3][301] = 0;
   assign ecchmatrix[4][301] = 1;
   assign ecchmatrix[5][301] = 1;
   assign ecchmatrix[6][301] = 1;
   assign ecchmatrix[7][301] = 1;
   assign ecchmatrix[8][301] = 0;
   assign ecchmatrix[9][301] = 0;
   assign ecchmatrix[0][302] = 0;
   assign ecchmatrix[1][302] = 1;
   assign ecchmatrix[2][302] = 0;
   assign ecchmatrix[3][302] = 0;
   assign ecchmatrix[4][302] = 1;
   assign ecchmatrix[5][302] = 1;
   assign ecchmatrix[6][302] = 1;
   assign ecchmatrix[7][302] = 0;
   assign ecchmatrix[8][302] = 1;
   assign ecchmatrix[9][302] = 0;
   assign ecchmatrix[0][303] = 0;
   assign ecchmatrix[1][303] = 1;
   assign ecchmatrix[2][303] = 0;
   assign ecchmatrix[3][303] = 0;
   assign ecchmatrix[4][303] = 1;
   assign ecchmatrix[5][303] = 1;
   assign ecchmatrix[6][303] = 1;
   assign ecchmatrix[7][303] = 0;
   assign ecchmatrix[8][303] = 0;
   assign ecchmatrix[9][303] = 1;
   assign ecchmatrix[0][304] = 0;
   assign ecchmatrix[1][304] = 1;
   assign ecchmatrix[2][304] = 0;
   assign ecchmatrix[3][304] = 0;
   assign ecchmatrix[4][304] = 1;
   assign ecchmatrix[5][304] = 1;
   assign ecchmatrix[6][304] = 0;
   assign ecchmatrix[7][304] = 1;
   assign ecchmatrix[8][304] = 1;
   assign ecchmatrix[9][304] = 0;
   assign ecchmatrix[0][305] = 0;
   assign ecchmatrix[1][305] = 1;
   assign ecchmatrix[2][305] = 0;
   assign ecchmatrix[3][305] = 0;
   assign ecchmatrix[4][305] = 1;
   assign ecchmatrix[5][305] = 1;
   assign ecchmatrix[6][305] = 0;
   assign ecchmatrix[7][305] = 1;
   assign ecchmatrix[8][305] = 0;
   assign ecchmatrix[9][305] = 1;
   assign ecchmatrix[0][306] = 0;
   assign ecchmatrix[1][306] = 1;
   assign ecchmatrix[2][306] = 0;
   assign ecchmatrix[3][306] = 0;
   assign ecchmatrix[4][306] = 1;
   assign ecchmatrix[5][306] = 1;
   assign ecchmatrix[6][306] = 0;
   assign ecchmatrix[7][306] = 0;
   assign ecchmatrix[8][306] = 1;
   assign ecchmatrix[9][306] = 1;
   assign ecchmatrix[0][307] = 0;
   assign ecchmatrix[1][307] = 1;
   assign ecchmatrix[2][307] = 0;
   assign ecchmatrix[3][307] = 0;
   assign ecchmatrix[4][307] = 1;
   assign ecchmatrix[5][307] = 0;
   assign ecchmatrix[6][307] = 1;
   assign ecchmatrix[7][307] = 1;
   assign ecchmatrix[8][307] = 1;
   assign ecchmatrix[9][307] = 0;
   assign ecchmatrix[0][308] = 0;
   assign ecchmatrix[1][308] = 1;
   assign ecchmatrix[2][308] = 0;
   assign ecchmatrix[3][308] = 0;
   assign ecchmatrix[4][308] = 1;
   assign ecchmatrix[5][308] = 0;
   assign ecchmatrix[6][308] = 1;
   assign ecchmatrix[7][308] = 1;
   assign ecchmatrix[8][308] = 0;
   assign ecchmatrix[9][308] = 1;
   assign ecchmatrix[0][309] = 0;
   assign ecchmatrix[1][309] = 1;
   assign ecchmatrix[2][309] = 0;
   assign ecchmatrix[3][309] = 0;
   assign ecchmatrix[4][309] = 1;
   assign ecchmatrix[5][309] = 0;
   assign ecchmatrix[6][309] = 1;
   assign ecchmatrix[7][309] = 0;
   assign ecchmatrix[8][309] = 1;
   assign ecchmatrix[9][309] = 1;
   assign ecchmatrix[0][310] = 0;
   assign ecchmatrix[1][310] = 1;
   assign ecchmatrix[2][310] = 0;
   assign ecchmatrix[3][310] = 0;
   assign ecchmatrix[4][310] = 1;
   assign ecchmatrix[5][310] = 0;
   assign ecchmatrix[6][310] = 0;
   assign ecchmatrix[7][310] = 1;
   assign ecchmatrix[8][310] = 1;
   assign ecchmatrix[9][310] = 1;
   assign ecchmatrix[0][311] = 0;
   assign ecchmatrix[1][311] = 1;
   assign ecchmatrix[2][311] = 0;
   assign ecchmatrix[3][311] = 0;
   assign ecchmatrix[4][311] = 0;
   assign ecchmatrix[5][311] = 1;
   assign ecchmatrix[6][311] = 1;
   assign ecchmatrix[7][311] = 1;
   assign ecchmatrix[8][311] = 1;
   assign ecchmatrix[9][311] = 0;
   assign ecchmatrix[0][312] = 0;
   assign ecchmatrix[1][312] = 1;
   assign ecchmatrix[2][312] = 0;
   assign ecchmatrix[3][312] = 0;
   assign ecchmatrix[4][312] = 0;
   assign ecchmatrix[5][312] = 1;
   assign ecchmatrix[6][312] = 1;
   assign ecchmatrix[7][312] = 1;
   assign ecchmatrix[8][312] = 0;
   assign ecchmatrix[9][312] = 1;
   assign ecchmatrix[0][313] = 0;
   assign ecchmatrix[1][313] = 1;
   assign ecchmatrix[2][313] = 0;
   assign ecchmatrix[3][313] = 0;
   assign ecchmatrix[4][313] = 0;
   assign ecchmatrix[5][313] = 1;
   assign ecchmatrix[6][313] = 1;
   assign ecchmatrix[7][313] = 0;
   assign ecchmatrix[8][313] = 1;
   assign ecchmatrix[9][313] = 1;
   assign ecchmatrix[0][314] = 0;
   assign ecchmatrix[1][314] = 1;
   assign ecchmatrix[2][314] = 0;
   assign ecchmatrix[3][314] = 0;
   assign ecchmatrix[4][314] = 0;
   assign ecchmatrix[5][314] = 1;
   assign ecchmatrix[6][314] = 0;
   assign ecchmatrix[7][314] = 1;
   assign ecchmatrix[8][314] = 1;
   assign ecchmatrix[9][314] = 1;
   assign ecchmatrix[0][315] = 0;
   assign ecchmatrix[1][315] = 1;
   assign ecchmatrix[2][315] = 0;
   assign ecchmatrix[3][315] = 0;
   assign ecchmatrix[4][315] = 0;
   assign ecchmatrix[5][315] = 0;
   assign ecchmatrix[6][315] = 1;
   assign ecchmatrix[7][315] = 1;
   assign ecchmatrix[8][315] = 1;
   assign ecchmatrix[9][315] = 1;
   assign ecchmatrix[0][316] = 0;
   assign ecchmatrix[1][316] = 0;
   assign ecchmatrix[2][316] = 1;
   assign ecchmatrix[3][316] = 1;
   assign ecchmatrix[4][316] = 1;
   assign ecchmatrix[5][316] = 1;
   assign ecchmatrix[6][316] = 1;
   assign ecchmatrix[7][316] = 0;
   assign ecchmatrix[8][316] = 0;
   assign ecchmatrix[9][316] = 0;
   assign ecchmatrix[0][317] = 0;
   assign ecchmatrix[1][317] = 0;
   assign ecchmatrix[2][317] = 1;
   assign ecchmatrix[3][317] = 1;
   assign ecchmatrix[4][317] = 1;
   assign ecchmatrix[5][317] = 1;
   assign ecchmatrix[6][317] = 0;
   assign ecchmatrix[7][317] = 1;
   assign ecchmatrix[8][317] = 0;
   assign ecchmatrix[9][317] = 0;
   assign ecchmatrix[0][318] = 0;
   assign ecchmatrix[1][318] = 0;
   assign ecchmatrix[2][318] = 1;
   assign ecchmatrix[3][318] = 1;
   assign ecchmatrix[4][318] = 1;
   assign ecchmatrix[5][318] = 1;
   assign ecchmatrix[6][318] = 0;
   assign ecchmatrix[7][318] = 0;
   assign ecchmatrix[8][318] = 1;
   assign ecchmatrix[9][318] = 0;
   assign ecchmatrix[0][319] = 0;
   assign ecchmatrix[1][319] = 0;
   assign ecchmatrix[2][319] = 1;
   assign ecchmatrix[3][319] = 1;
   assign ecchmatrix[4][319] = 1;
   assign ecchmatrix[5][319] = 1;
   assign ecchmatrix[6][319] = 0;
   assign ecchmatrix[7][319] = 0;
   assign ecchmatrix[8][319] = 0;
   assign ecchmatrix[9][319] = 1;
   assign ecchmatrix[0][320] = 0;
   assign ecchmatrix[1][320] = 0;
   assign ecchmatrix[2][320] = 1;
   assign ecchmatrix[3][320] = 1;
   assign ecchmatrix[4][320] = 1;
   assign ecchmatrix[5][320] = 0;
   assign ecchmatrix[6][320] = 1;
   assign ecchmatrix[7][320] = 1;
   assign ecchmatrix[8][320] = 0;
   assign ecchmatrix[9][320] = 0;
   assign ecchmatrix[0][321] = 0;
   assign ecchmatrix[1][321] = 0;
   assign ecchmatrix[2][321] = 1;
   assign ecchmatrix[3][321] = 1;
   assign ecchmatrix[4][321] = 1;
   assign ecchmatrix[5][321] = 0;
   assign ecchmatrix[6][321] = 1;
   assign ecchmatrix[7][321] = 0;
   assign ecchmatrix[8][321] = 1;
   assign ecchmatrix[9][321] = 0;
   assign ecchmatrix[0][322] = 0;
   assign ecchmatrix[1][322] = 0;
   assign ecchmatrix[2][322] = 1;
   assign ecchmatrix[3][322] = 1;
   assign ecchmatrix[4][322] = 1;
   assign ecchmatrix[5][322] = 0;
   assign ecchmatrix[6][322] = 1;
   assign ecchmatrix[7][322] = 0;
   assign ecchmatrix[8][322] = 0;
   assign ecchmatrix[9][322] = 1;
   assign ecchmatrix[0][323] = 0;
   assign ecchmatrix[1][323] = 0;
   assign ecchmatrix[2][323] = 1;
   assign ecchmatrix[3][323] = 1;
   assign ecchmatrix[4][323] = 1;
   assign ecchmatrix[5][323] = 0;
   assign ecchmatrix[6][323] = 0;
   assign ecchmatrix[7][323] = 1;
   assign ecchmatrix[8][323] = 1;
   assign ecchmatrix[9][323] = 0;
   assign ecchmatrix[0][324] = 0;
   assign ecchmatrix[1][324] = 0;
   assign ecchmatrix[2][324] = 1;
   assign ecchmatrix[3][324] = 1;
   assign ecchmatrix[4][324] = 1;
   assign ecchmatrix[5][324] = 0;
   assign ecchmatrix[6][324] = 0;
   assign ecchmatrix[7][324] = 1;
   assign ecchmatrix[8][324] = 0;
   assign ecchmatrix[9][324] = 1;
   assign ecchmatrix[0][325] = 0;
   assign ecchmatrix[1][325] = 0;
   assign ecchmatrix[2][325] = 1;
   assign ecchmatrix[3][325] = 1;
   assign ecchmatrix[4][325] = 1;
   assign ecchmatrix[5][325] = 0;
   assign ecchmatrix[6][325] = 0;
   assign ecchmatrix[7][325] = 0;
   assign ecchmatrix[8][325] = 1;
   assign ecchmatrix[9][325] = 1;
   assign ecchmatrix[0][326] = 0;
   assign ecchmatrix[1][326] = 0;
   assign ecchmatrix[2][326] = 1;
   assign ecchmatrix[3][326] = 1;
   assign ecchmatrix[4][326] = 0;
   assign ecchmatrix[5][326] = 1;
   assign ecchmatrix[6][326] = 1;
   assign ecchmatrix[7][326] = 1;
   assign ecchmatrix[8][326] = 0;
   assign ecchmatrix[9][326] = 0;
   assign ecchmatrix[0][327] = 0;
   assign ecchmatrix[1][327] = 0;
   assign ecchmatrix[2][327] = 1;
   assign ecchmatrix[3][327] = 1;
   assign ecchmatrix[4][327] = 0;
   assign ecchmatrix[5][327] = 1;
   assign ecchmatrix[6][327] = 1;
   assign ecchmatrix[7][327] = 0;
   assign ecchmatrix[8][327] = 1;
   assign ecchmatrix[9][327] = 0;
   assign ecchmatrix[0][328] = 0;
   assign ecchmatrix[1][328] = 0;
   assign ecchmatrix[2][328] = 1;
   assign ecchmatrix[3][328] = 1;
   assign ecchmatrix[4][328] = 0;
   assign ecchmatrix[5][328] = 1;
   assign ecchmatrix[6][328] = 1;
   assign ecchmatrix[7][328] = 0;
   assign ecchmatrix[8][328] = 0;
   assign ecchmatrix[9][328] = 1;
   assign ecchmatrix[0][329] = 0;
   assign ecchmatrix[1][329] = 0;
   assign ecchmatrix[2][329] = 1;
   assign ecchmatrix[3][329] = 1;
   assign ecchmatrix[4][329] = 0;
   assign ecchmatrix[5][329] = 1;
   assign ecchmatrix[6][329] = 0;
   assign ecchmatrix[7][329] = 1;
   assign ecchmatrix[8][329] = 1;
   assign ecchmatrix[9][329] = 0;
   assign ecchmatrix[0][330] = 0;
   assign ecchmatrix[1][330] = 0;
   assign ecchmatrix[2][330] = 1;
   assign ecchmatrix[3][330] = 1;
   assign ecchmatrix[4][330] = 0;
   assign ecchmatrix[5][330] = 1;
   assign ecchmatrix[6][330] = 0;
   assign ecchmatrix[7][330] = 1;
   assign ecchmatrix[8][330] = 0;
   assign ecchmatrix[9][330] = 1;
   assign ecchmatrix[0][331] = 0;
   assign ecchmatrix[1][331] = 0;
   assign ecchmatrix[2][331] = 1;
   assign ecchmatrix[3][331] = 1;
   assign ecchmatrix[4][331] = 0;
   assign ecchmatrix[5][331] = 1;
   assign ecchmatrix[6][331] = 0;
   assign ecchmatrix[7][331] = 0;
   assign ecchmatrix[8][331] = 1;
   assign ecchmatrix[9][331] = 1;
   assign ecchmatrix[0][332] = 0;
   assign ecchmatrix[1][332] = 0;
   assign ecchmatrix[2][332] = 1;
   assign ecchmatrix[3][332] = 1;
   assign ecchmatrix[4][332] = 0;
   assign ecchmatrix[5][332] = 0;
   assign ecchmatrix[6][332] = 1;
   assign ecchmatrix[7][332] = 1;
   assign ecchmatrix[8][332] = 1;
   assign ecchmatrix[9][332] = 0;
   assign ecchmatrix[0][333] = 0;
   assign ecchmatrix[1][333] = 0;
   assign ecchmatrix[2][333] = 1;
   assign ecchmatrix[3][333] = 1;
   assign ecchmatrix[4][333] = 0;
   assign ecchmatrix[5][333] = 0;
   assign ecchmatrix[6][333] = 1;
   assign ecchmatrix[7][333] = 1;
   assign ecchmatrix[8][333] = 0;
   assign ecchmatrix[9][333] = 1;
   assign ecchmatrix[0][334] = 0;
   assign ecchmatrix[1][334] = 0;
   assign ecchmatrix[2][334] = 1;
   assign ecchmatrix[3][334] = 1;
   assign ecchmatrix[4][334] = 0;
   assign ecchmatrix[5][334] = 0;
   assign ecchmatrix[6][334] = 1;
   assign ecchmatrix[7][334] = 0;
   assign ecchmatrix[8][334] = 1;
   assign ecchmatrix[9][334] = 1;
   assign ecchmatrix[0][335] = 0;
   assign ecchmatrix[1][335] = 0;
   assign ecchmatrix[2][335] = 1;
   assign ecchmatrix[3][335] = 1;
   assign ecchmatrix[4][335] = 0;
   assign ecchmatrix[5][335] = 0;
   assign ecchmatrix[6][335] = 0;
   assign ecchmatrix[7][335] = 1;
   assign ecchmatrix[8][335] = 1;
   assign ecchmatrix[9][335] = 1;
   assign ecchmatrix[0][336] = 0;
   assign ecchmatrix[1][336] = 0;
   assign ecchmatrix[2][336] = 1;
   assign ecchmatrix[3][336] = 0;
   assign ecchmatrix[4][336] = 1;
   assign ecchmatrix[5][336] = 1;
   assign ecchmatrix[6][336] = 1;
   assign ecchmatrix[7][336] = 1;
   assign ecchmatrix[8][336] = 0;
   assign ecchmatrix[9][336] = 0;
   assign ecchmatrix[0][337] = 0;
   assign ecchmatrix[1][337] = 0;
   assign ecchmatrix[2][337] = 1;
   assign ecchmatrix[3][337] = 0;
   assign ecchmatrix[4][337] = 1;
   assign ecchmatrix[5][337] = 1;
   assign ecchmatrix[6][337] = 1;
   assign ecchmatrix[7][337] = 0;
   assign ecchmatrix[8][337] = 1;
   assign ecchmatrix[9][337] = 0;
   assign ecchmatrix[0][338] = 0;
   assign ecchmatrix[1][338] = 0;
   assign ecchmatrix[2][338] = 1;
   assign ecchmatrix[3][338] = 0;
   assign ecchmatrix[4][338] = 1;
   assign ecchmatrix[5][338] = 1;
   assign ecchmatrix[6][338] = 1;
   assign ecchmatrix[7][338] = 0;
   assign ecchmatrix[8][338] = 0;
   assign ecchmatrix[9][338] = 1;
   assign ecchmatrix[0][339] = 0;
   assign ecchmatrix[1][339] = 0;
   assign ecchmatrix[2][339] = 1;
   assign ecchmatrix[3][339] = 0;
   assign ecchmatrix[4][339] = 1;
   assign ecchmatrix[5][339] = 1;
   assign ecchmatrix[6][339] = 0;
   assign ecchmatrix[7][339] = 1;
   assign ecchmatrix[8][339] = 1;
   assign ecchmatrix[9][339] = 0;
   assign ecchmatrix[0][340] = 0;
   assign ecchmatrix[1][340] = 0;
   assign ecchmatrix[2][340] = 1;
   assign ecchmatrix[3][340] = 0;
   assign ecchmatrix[4][340] = 1;
   assign ecchmatrix[5][340] = 1;
   assign ecchmatrix[6][340] = 0;
   assign ecchmatrix[7][340] = 1;
   assign ecchmatrix[8][340] = 0;
   assign ecchmatrix[9][340] = 1;
   assign ecchmatrix[0][341] = 0;
   assign ecchmatrix[1][341] = 0;
   assign ecchmatrix[2][341] = 1;
   assign ecchmatrix[3][341] = 0;
   assign ecchmatrix[4][341] = 1;
   assign ecchmatrix[5][341] = 1;
   assign ecchmatrix[6][341] = 0;
   assign ecchmatrix[7][341] = 0;
   assign ecchmatrix[8][341] = 1;
   assign ecchmatrix[9][341] = 1;
   assign ecchmatrix[0][342] = 0;
   assign ecchmatrix[1][342] = 0;
   assign ecchmatrix[2][342] = 1;
   assign ecchmatrix[3][342] = 0;
   assign ecchmatrix[4][342] = 1;
   assign ecchmatrix[5][342] = 0;
   assign ecchmatrix[6][342] = 1;
   assign ecchmatrix[7][342] = 1;
   assign ecchmatrix[8][342] = 1;
   assign ecchmatrix[9][342] = 0;
   assign ecchmatrix[0][343] = 0;
   assign ecchmatrix[1][343] = 0;
   assign ecchmatrix[2][343] = 1;
   assign ecchmatrix[3][343] = 0;
   assign ecchmatrix[4][343] = 1;
   assign ecchmatrix[5][343] = 0;
   assign ecchmatrix[6][343] = 1;
   assign ecchmatrix[7][343] = 1;
   assign ecchmatrix[8][343] = 0;
   assign ecchmatrix[9][343] = 1;
   assign ecchmatrix[0][344] = 0;
   assign ecchmatrix[1][344] = 0;
   assign ecchmatrix[2][344] = 1;
   assign ecchmatrix[3][344] = 0;
   assign ecchmatrix[4][344] = 1;
   assign ecchmatrix[5][344] = 0;
   assign ecchmatrix[6][344] = 1;
   assign ecchmatrix[7][344] = 0;
   assign ecchmatrix[8][344] = 1;
   assign ecchmatrix[9][344] = 1;
   assign ecchmatrix[0][345] = 0;
   assign ecchmatrix[1][345] = 0;
   assign ecchmatrix[2][345] = 1;
   assign ecchmatrix[3][345] = 0;
   assign ecchmatrix[4][345] = 1;
   assign ecchmatrix[5][345] = 0;
   assign ecchmatrix[6][345] = 0;
   assign ecchmatrix[7][345] = 1;
   assign ecchmatrix[8][345] = 1;
   assign ecchmatrix[9][345] = 1;
   assign ecchmatrix[0][346] = 0;
   assign ecchmatrix[1][346] = 0;
   assign ecchmatrix[2][346] = 1;
   assign ecchmatrix[3][346] = 0;
   assign ecchmatrix[4][346] = 0;
   assign ecchmatrix[5][346] = 1;
   assign ecchmatrix[6][346] = 1;
   assign ecchmatrix[7][346] = 1;
   assign ecchmatrix[8][346] = 1;
   assign ecchmatrix[9][346] = 0;
   assign ecchmatrix[0][347] = 0;
   assign ecchmatrix[1][347] = 0;
   assign ecchmatrix[2][347] = 1;
   assign ecchmatrix[3][347] = 0;
   assign ecchmatrix[4][347] = 0;
   assign ecchmatrix[5][347] = 1;
   assign ecchmatrix[6][347] = 1;
   assign ecchmatrix[7][347] = 1;
   assign ecchmatrix[8][347] = 0;
   assign ecchmatrix[9][347] = 1;
   assign ecchmatrix[0][348] = 0;
   assign ecchmatrix[1][348] = 0;
   assign ecchmatrix[2][348] = 1;
   assign ecchmatrix[3][348] = 0;
   assign ecchmatrix[4][348] = 0;
   assign ecchmatrix[5][348] = 1;
   assign ecchmatrix[6][348] = 1;
   assign ecchmatrix[7][348] = 0;
   assign ecchmatrix[8][348] = 1;
   assign ecchmatrix[9][348] = 1;
   assign ecchmatrix[0][349] = 0;
   assign ecchmatrix[1][349] = 0;
   assign ecchmatrix[2][349] = 1;
   assign ecchmatrix[3][349] = 0;
   assign ecchmatrix[4][349] = 0;
   assign ecchmatrix[5][349] = 1;
   assign ecchmatrix[6][349] = 0;
   assign ecchmatrix[7][349] = 1;
   assign ecchmatrix[8][349] = 1;
   assign ecchmatrix[9][349] = 1;
   assign ecchmatrix[0][350] = 0;
   assign ecchmatrix[1][350] = 0;
   assign ecchmatrix[2][350] = 1;
   assign ecchmatrix[3][350] = 0;
   assign ecchmatrix[4][350] = 0;
   assign ecchmatrix[5][350] = 0;
   assign ecchmatrix[6][350] = 1;
   assign ecchmatrix[7][350] = 1;
   assign ecchmatrix[8][350] = 1;
   assign ecchmatrix[9][350] = 1;
   assign ecchmatrix[0][351] = 0;
   assign ecchmatrix[1][351] = 0;
   assign ecchmatrix[2][351] = 0;
   assign ecchmatrix[3][351] = 1;
   assign ecchmatrix[4][351] = 1;
   assign ecchmatrix[5][351] = 1;
   assign ecchmatrix[6][351] = 1;
   assign ecchmatrix[7][351] = 1;
   assign ecchmatrix[8][351] = 0;
   assign ecchmatrix[9][351] = 0;
   assign ecchmatrix[0][352] = 0;
   assign ecchmatrix[1][352] = 0;
   assign ecchmatrix[2][352] = 0;
   assign ecchmatrix[3][352] = 1;
   assign ecchmatrix[4][352] = 1;
   assign ecchmatrix[5][352] = 1;
   assign ecchmatrix[6][352] = 1;
   assign ecchmatrix[7][352] = 0;
   assign ecchmatrix[8][352] = 1;
   assign ecchmatrix[9][352] = 0;
   assign ecchmatrix[0][353] = 0;
   assign ecchmatrix[1][353] = 0;
   assign ecchmatrix[2][353] = 0;
   assign ecchmatrix[3][353] = 1;
   assign ecchmatrix[4][353] = 1;
   assign ecchmatrix[5][353] = 1;
   assign ecchmatrix[6][353] = 1;
   assign ecchmatrix[7][353] = 0;
   assign ecchmatrix[8][353] = 0;
   assign ecchmatrix[9][353] = 1;
   assign ecchmatrix[0][354] = 0;
   assign ecchmatrix[1][354] = 0;
   assign ecchmatrix[2][354] = 0;
   assign ecchmatrix[3][354] = 1;
   assign ecchmatrix[4][354] = 1;
   assign ecchmatrix[5][354] = 1;
   assign ecchmatrix[6][354] = 0;
   assign ecchmatrix[7][354] = 1;
   assign ecchmatrix[8][354] = 1;
   assign ecchmatrix[9][354] = 0;
   assign ecchmatrix[0][355] = 0;
   assign ecchmatrix[1][355] = 0;
   assign ecchmatrix[2][355] = 0;
   assign ecchmatrix[3][355] = 1;
   assign ecchmatrix[4][355] = 1;
   assign ecchmatrix[5][355] = 1;
   assign ecchmatrix[6][355] = 0;
   assign ecchmatrix[7][355] = 1;
   assign ecchmatrix[8][355] = 0;
   assign ecchmatrix[9][355] = 1;
   assign ecchmatrix[0][356] = 0;
   assign ecchmatrix[1][356] = 0;
   assign ecchmatrix[2][356] = 0;
   assign ecchmatrix[3][356] = 1;
   assign ecchmatrix[4][356] = 1;
   assign ecchmatrix[5][356] = 1;
   assign ecchmatrix[6][356] = 0;
   assign ecchmatrix[7][356] = 0;
   assign ecchmatrix[8][356] = 1;
   assign ecchmatrix[9][356] = 1;
   assign ecchmatrix[0][357] = 0;
   assign ecchmatrix[1][357] = 0;
   assign ecchmatrix[2][357] = 0;
   assign ecchmatrix[3][357] = 1;
   assign ecchmatrix[4][357] = 1;
   assign ecchmatrix[5][357] = 0;
   assign ecchmatrix[6][357] = 1;
   assign ecchmatrix[7][357] = 1;
   assign ecchmatrix[8][357] = 1;
   assign ecchmatrix[9][357] = 0;
   assign ecchmatrix[0][358] = 0;
   assign ecchmatrix[1][358] = 0;
   assign ecchmatrix[2][358] = 0;
   assign ecchmatrix[3][358] = 1;
   assign ecchmatrix[4][358] = 1;
   assign ecchmatrix[5][358] = 0;
   assign ecchmatrix[6][358] = 1;
   assign ecchmatrix[7][358] = 1;
   assign ecchmatrix[8][358] = 0;
   assign ecchmatrix[9][358] = 1;
   assign ecchmatrix[0][359] = 0;
   assign ecchmatrix[1][359] = 0;
   assign ecchmatrix[2][359] = 0;
   assign ecchmatrix[3][359] = 1;
   assign ecchmatrix[4][359] = 1;
   assign ecchmatrix[5][359] = 0;
   assign ecchmatrix[6][359] = 1;
   assign ecchmatrix[7][359] = 0;
   assign ecchmatrix[8][359] = 1;
   assign ecchmatrix[9][359] = 1;
   assign ecchmatrix[0][360] = 0;
   assign ecchmatrix[1][360] = 0;
   assign ecchmatrix[2][360] = 0;
   assign ecchmatrix[3][360] = 1;
   assign ecchmatrix[4][360] = 1;
   assign ecchmatrix[5][360] = 0;
   assign ecchmatrix[6][360] = 0;
   assign ecchmatrix[7][360] = 1;
   assign ecchmatrix[8][360] = 1;
   assign ecchmatrix[9][360] = 1;
   assign ecchmatrix[0][361] = 0;
   assign ecchmatrix[1][361] = 0;
   assign ecchmatrix[2][361] = 0;
   assign ecchmatrix[3][361] = 1;
   assign ecchmatrix[4][361] = 0;
   assign ecchmatrix[5][361] = 1;
   assign ecchmatrix[6][361] = 1;
   assign ecchmatrix[7][361] = 1;
   assign ecchmatrix[8][361] = 1;
   assign ecchmatrix[9][361] = 0;
   assign ecchmatrix[0][362] = 0;
   assign ecchmatrix[1][362] = 0;
   assign ecchmatrix[2][362] = 0;
   assign ecchmatrix[3][362] = 1;
   assign ecchmatrix[4][362] = 0;
   assign ecchmatrix[5][362] = 1;
   assign ecchmatrix[6][362] = 1;
   assign ecchmatrix[7][362] = 1;
   assign ecchmatrix[8][362] = 0;
   assign ecchmatrix[9][362] = 1;
   assign ecchmatrix[0][363] = 0;
   assign ecchmatrix[1][363] = 0;
   assign ecchmatrix[2][363] = 0;
   assign ecchmatrix[3][363] = 1;
   assign ecchmatrix[4][363] = 0;
   assign ecchmatrix[5][363] = 1;
   assign ecchmatrix[6][363] = 1;
   assign ecchmatrix[7][363] = 0;
   assign ecchmatrix[8][363] = 1;
   assign ecchmatrix[9][363] = 1;
   assign ecchmatrix[0][364] = 0;
   assign ecchmatrix[1][364] = 0;
   assign ecchmatrix[2][364] = 0;
   assign ecchmatrix[3][364] = 1;
   assign ecchmatrix[4][364] = 0;
   assign ecchmatrix[5][364] = 1;
   assign ecchmatrix[6][364] = 0;
   assign ecchmatrix[7][364] = 1;
   assign ecchmatrix[8][364] = 1;
   assign ecchmatrix[9][364] = 1;
   assign ecchmatrix[0][365] = 0;
   assign ecchmatrix[1][365] = 0;
   assign ecchmatrix[2][365] = 0;
   assign ecchmatrix[3][365] = 1;
   assign ecchmatrix[4][365] = 0;
   assign ecchmatrix[5][365] = 0;
   assign ecchmatrix[6][365] = 1;
   assign ecchmatrix[7][365] = 1;
   assign ecchmatrix[8][365] = 1;
   assign ecchmatrix[9][365] = 1;
   assign ecchmatrix[0][366] = 0;
   assign ecchmatrix[1][366] = 0;
   assign ecchmatrix[2][366] = 0;
   assign ecchmatrix[3][366] = 0;
   assign ecchmatrix[4][366] = 1;
   assign ecchmatrix[5][366] = 1;
   assign ecchmatrix[6][366] = 1;
   assign ecchmatrix[7][366] = 1;
   assign ecchmatrix[8][366] = 1;
   assign ecchmatrix[9][366] = 0;
   assign ecchmatrix[0][367] = 0;
   assign ecchmatrix[1][367] = 0;
   assign ecchmatrix[2][367] = 0;
   assign ecchmatrix[3][367] = 0;
   assign ecchmatrix[4][367] = 1;
   assign ecchmatrix[5][367] = 1;
   assign ecchmatrix[6][367] = 1;
   assign ecchmatrix[7][367] = 1;
   assign ecchmatrix[8][367] = 0;
   assign ecchmatrix[9][367] = 1;
   assign ecchmatrix[0][368] = 0;
   assign ecchmatrix[1][368] = 0;
   assign ecchmatrix[2][368] = 0;
   assign ecchmatrix[3][368] = 0;
   assign ecchmatrix[4][368] = 1;
   assign ecchmatrix[5][368] = 1;
   assign ecchmatrix[6][368] = 1;
   assign ecchmatrix[7][368] = 0;
   assign ecchmatrix[8][368] = 1;
   assign ecchmatrix[9][368] = 1;
   assign ecchmatrix[0][369] = 0;
   assign ecchmatrix[1][369] = 0;
   assign ecchmatrix[2][369] = 0;
   assign ecchmatrix[3][369] = 0;
   assign ecchmatrix[4][369] = 1;
   assign ecchmatrix[5][369] = 1;
   assign ecchmatrix[6][369] = 0;
   assign ecchmatrix[7][369] = 1;
   assign ecchmatrix[8][369] = 1;
   assign ecchmatrix[9][369] = 1;
   assign ecchmatrix[0][370] = 0;
   assign ecchmatrix[1][370] = 0;
   assign ecchmatrix[2][370] = 0;
   assign ecchmatrix[3][370] = 0;
   assign ecchmatrix[4][370] = 1;
   assign ecchmatrix[5][370] = 0;
   assign ecchmatrix[6][370] = 1;
   assign ecchmatrix[7][370] = 1;
   assign ecchmatrix[8][370] = 1;
   assign ecchmatrix[9][370] = 1;
   assign ecchmatrix[0][371] = 0;
   assign ecchmatrix[1][371] = 0;
   assign ecchmatrix[2][371] = 0;
   assign ecchmatrix[3][371] = 0;
   assign ecchmatrix[4][371] = 0;
   assign ecchmatrix[5][371] = 1;
   assign ecchmatrix[6][371] = 1;
   assign ecchmatrix[7][371] = 1;
   assign ecchmatrix[8][371] = 1;
   assign ecchmatrix[9][371] = 1;
   assign ecchmatrix[0][372] = 1;
   assign ecchmatrix[1][372] = 1;
   assign ecchmatrix[2][372] = 1;
   assign ecchmatrix[3][372] = 1;
   assign ecchmatrix[4][372] = 1;
   assign ecchmatrix[5][372] = 1;
   assign ecchmatrix[6][372] = 1;
   assign ecchmatrix[7][372] = 0;
   assign ecchmatrix[8][372] = 0;
   assign ecchmatrix[9][372] = 0;
   assign ecchmatrix[0][373] = 1;
   assign ecchmatrix[1][373] = 1;
   assign ecchmatrix[2][373] = 1;
   assign ecchmatrix[3][373] = 1;
   assign ecchmatrix[4][373] = 1;
   assign ecchmatrix[5][373] = 1;
   assign ecchmatrix[6][373] = 0;
   assign ecchmatrix[7][373] = 1;
   assign ecchmatrix[8][373] = 0;
   assign ecchmatrix[9][373] = 0;
   assign ecchmatrix[0][374] = 1;
   assign ecchmatrix[1][374] = 1;
   assign ecchmatrix[2][374] = 1;
   assign ecchmatrix[3][374] = 1;
   assign ecchmatrix[4][374] = 1;
   assign ecchmatrix[5][374] = 1;
   assign ecchmatrix[6][374] = 0;
   assign ecchmatrix[7][374] = 0;
   assign ecchmatrix[8][374] = 1;
   assign ecchmatrix[9][374] = 0;
   assign ecchmatrix[0][375] = 1;
   assign ecchmatrix[1][375] = 1;
   assign ecchmatrix[2][375] = 1;
   assign ecchmatrix[3][375] = 1;
   assign ecchmatrix[4][375] = 1;
   assign ecchmatrix[5][375] = 1;
   assign ecchmatrix[6][375] = 0;
   assign ecchmatrix[7][375] = 0;
   assign ecchmatrix[8][375] = 0;
   assign ecchmatrix[9][375] = 1;
   assign ecchmatrix[0][376] = 1;
   assign ecchmatrix[1][376] = 1;
   assign ecchmatrix[2][376] = 1;
   assign ecchmatrix[3][376] = 1;
   assign ecchmatrix[4][376] = 1;
   assign ecchmatrix[5][376] = 0;
   assign ecchmatrix[6][376] = 1;
   assign ecchmatrix[7][376] = 1;
   assign ecchmatrix[8][376] = 0;
   assign ecchmatrix[9][376] = 0;
   assign ecchmatrix[0][377] = 1;
   assign ecchmatrix[1][377] = 1;
   assign ecchmatrix[2][377] = 1;
   assign ecchmatrix[3][377] = 1;
   assign ecchmatrix[4][377] = 1;
   assign ecchmatrix[5][377] = 0;
   assign ecchmatrix[6][377] = 1;
   assign ecchmatrix[7][377] = 0;
   assign ecchmatrix[8][377] = 1;
   assign ecchmatrix[9][377] = 0;
   assign ecchmatrix[0][378] = 1;
   assign ecchmatrix[1][378] = 1;
   assign ecchmatrix[2][378] = 1;
   assign ecchmatrix[3][378] = 1;
   assign ecchmatrix[4][378] = 1;
   assign ecchmatrix[5][378] = 0;
   assign ecchmatrix[6][378] = 1;
   assign ecchmatrix[7][378] = 0;
   assign ecchmatrix[8][378] = 0;
   assign ecchmatrix[9][378] = 1;
   assign ecchmatrix[0][379] = 1;
   assign ecchmatrix[1][379] = 1;
   assign ecchmatrix[2][379] = 1;
   assign ecchmatrix[3][379] = 1;
   assign ecchmatrix[4][379] = 1;
   assign ecchmatrix[5][379] = 0;
   assign ecchmatrix[6][379] = 0;
   assign ecchmatrix[7][379] = 1;
   assign ecchmatrix[8][379] = 1;
   assign ecchmatrix[9][379] = 0;
   assign ecchmatrix[0][380] = 1;
   assign ecchmatrix[1][380] = 1;
   assign ecchmatrix[2][380] = 1;
   assign ecchmatrix[3][380] = 1;
   assign ecchmatrix[4][380] = 1;
   assign ecchmatrix[5][380] = 0;
   assign ecchmatrix[6][380] = 0;
   assign ecchmatrix[7][380] = 1;
   assign ecchmatrix[8][380] = 0;
   assign ecchmatrix[9][380] = 1;
   assign ecchmatrix[0][381] = 1;
   assign ecchmatrix[1][381] = 1;
   assign ecchmatrix[2][381] = 1;
   assign ecchmatrix[3][381] = 1;
   assign ecchmatrix[4][381] = 1;
   assign ecchmatrix[5][381] = 0;
   assign ecchmatrix[6][381] = 0;
   assign ecchmatrix[7][381] = 0;
   assign ecchmatrix[8][381] = 1;
   assign ecchmatrix[9][381] = 1;
   assign ecchmatrix[0][382] = 1;
   assign ecchmatrix[1][382] = 1;
   assign ecchmatrix[2][382] = 1;
   assign ecchmatrix[3][382] = 1;
   assign ecchmatrix[4][382] = 0;
   assign ecchmatrix[5][382] = 1;
   assign ecchmatrix[6][382] = 1;
   assign ecchmatrix[7][382] = 1;
   assign ecchmatrix[8][382] = 0;
   assign ecchmatrix[9][382] = 0;
   assign ecchmatrix[0][383] = 1;
   assign ecchmatrix[1][383] = 1;
   assign ecchmatrix[2][383] = 1;
   assign ecchmatrix[3][383] = 1;
   assign ecchmatrix[4][383] = 0;
   assign ecchmatrix[5][383] = 1;
   assign ecchmatrix[6][383] = 1;
   assign ecchmatrix[7][383] = 0;
   assign ecchmatrix[8][383] = 1;
   assign ecchmatrix[9][383] = 0;
   assign ecchmatrix[0][384] = 1;
   assign ecchmatrix[1][384] = 1;
   assign ecchmatrix[2][384] = 1;
   assign ecchmatrix[3][384] = 1;
   assign ecchmatrix[4][384] = 0;
   assign ecchmatrix[5][384] = 1;
   assign ecchmatrix[6][384] = 1;
   assign ecchmatrix[7][384] = 0;
   assign ecchmatrix[8][384] = 0;
   assign ecchmatrix[9][384] = 1;
   assign ecchmatrix[0][385] = 1;
   assign ecchmatrix[1][385] = 1;
   assign ecchmatrix[2][385] = 1;
   assign ecchmatrix[3][385] = 1;
   assign ecchmatrix[4][385] = 0;
   assign ecchmatrix[5][385] = 1;
   assign ecchmatrix[6][385] = 0;
   assign ecchmatrix[7][385] = 1;
   assign ecchmatrix[8][385] = 1;
   assign ecchmatrix[9][385] = 0;
   assign ecchmatrix[0][386] = 1;
   assign ecchmatrix[1][386] = 1;
   assign ecchmatrix[2][386] = 1;
   assign ecchmatrix[3][386] = 1;
   assign ecchmatrix[4][386] = 0;
   assign ecchmatrix[5][386] = 1;
   assign ecchmatrix[6][386] = 0;
   assign ecchmatrix[7][386] = 1;
   assign ecchmatrix[8][386] = 0;
   assign ecchmatrix[9][386] = 1;
   assign ecchmatrix[0][387] = 1;
   assign ecchmatrix[1][387] = 1;
   assign ecchmatrix[2][387] = 1;
   assign ecchmatrix[3][387] = 1;
   assign ecchmatrix[4][387] = 0;
   assign ecchmatrix[5][387] = 1;
   assign ecchmatrix[6][387] = 0;
   assign ecchmatrix[7][387] = 0;
   assign ecchmatrix[8][387] = 1;
   assign ecchmatrix[9][387] = 1;
   assign ecchmatrix[0][388] = 1;
   assign ecchmatrix[1][388] = 1;
   assign ecchmatrix[2][388] = 1;
   assign ecchmatrix[3][388] = 1;
   assign ecchmatrix[4][388] = 0;
   assign ecchmatrix[5][388] = 0;
   assign ecchmatrix[6][388] = 1;
   assign ecchmatrix[7][388] = 1;
   assign ecchmatrix[8][388] = 1;
   assign ecchmatrix[9][388] = 0;
   assign ecchmatrix[0][389] = 1;
   assign ecchmatrix[1][389] = 1;
   assign ecchmatrix[2][389] = 1;
   assign ecchmatrix[3][389] = 1;
   assign ecchmatrix[4][389] = 0;
   assign ecchmatrix[5][389] = 0;
   assign ecchmatrix[6][389] = 1;
   assign ecchmatrix[7][389] = 1;
   assign ecchmatrix[8][389] = 0;
   assign ecchmatrix[9][389] = 1;
   assign ecchmatrix[0][390] = 1;
   assign ecchmatrix[1][390] = 1;
   assign ecchmatrix[2][390] = 1;
   assign ecchmatrix[3][390] = 1;
   assign ecchmatrix[4][390] = 0;
   assign ecchmatrix[5][390] = 0;
   assign ecchmatrix[6][390] = 1;
   assign ecchmatrix[7][390] = 0;
   assign ecchmatrix[8][390] = 1;
   assign ecchmatrix[9][390] = 1;
   assign ecchmatrix[0][391] = 1;
   assign ecchmatrix[1][391] = 1;
   assign ecchmatrix[2][391] = 1;
   assign ecchmatrix[3][391] = 1;
   assign ecchmatrix[4][391] = 0;
   assign ecchmatrix[5][391] = 0;
   assign ecchmatrix[6][391] = 0;
   assign ecchmatrix[7][391] = 1;
   assign ecchmatrix[8][391] = 1;
   assign ecchmatrix[9][391] = 1;
   assign ecchmatrix[0][392] = 1;
   assign ecchmatrix[1][392] = 1;
   assign ecchmatrix[2][392] = 1;
   assign ecchmatrix[3][392] = 0;
   assign ecchmatrix[4][392] = 1;
   assign ecchmatrix[5][392] = 1;
   assign ecchmatrix[6][392] = 1;
   assign ecchmatrix[7][392] = 1;
   assign ecchmatrix[8][392] = 0;
   assign ecchmatrix[9][392] = 0;
   assign ecchmatrix[0][393] = 1;
   assign ecchmatrix[1][393] = 1;
   assign ecchmatrix[2][393] = 1;
   assign ecchmatrix[3][393] = 0;
   assign ecchmatrix[4][393] = 1;
   assign ecchmatrix[5][393] = 1;
   assign ecchmatrix[6][393] = 1;
   assign ecchmatrix[7][393] = 0;
   assign ecchmatrix[8][393] = 1;
   assign ecchmatrix[9][393] = 0;
   assign ecchmatrix[0][394] = 1;
   assign ecchmatrix[1][394] = 1;
   assign ecchmatrix[2][394] = 1;
   assign ecchmatrix[3][394] = 0;
   assign ecchmatrix[4][394] = 1;
   assign ecchmatrix[5][394] = 1;
   assign ecchmatrix[6][394] = 1;
   assign ecchmatrix[7][394] = 0;
   assign ecchmatrix[8][394] = 0;
   assign ecchmatrix[9][394] = 1;
   assign ecchmatrix[0][395] = 1;
   assign ecchmatrix[1][395] = 1;
   assign ecchmatrix[2][395] = 1;
   assign ecchmatrix[3][395] = 0;
   assign ecchmatrix[4][395] = 1;
   assign ecchmatrix[5][395] = 1;
   assign ecchmatrix[6][395] = 0;
   assign ecchmatrix[7][395] = 1;
   assign ecchmatrix[8][395] = 1;
   assign ecchmatrix[9][395] = 0;
   assign ecchmatrix[0][396] = 1;
   assign ecchmatrix[1][396] = 1;
   assign ecchmatrix[2][396] = 1;
   assign ecchmatrix[3][396] = 0;
   assign ecchmatrix[4][396] = 1;
   assign ecchmatrix[5][396] = 1;
   assign ecchmatrix[6][396] = 0;
   assign ecchmatrix[7][396] = 1;
   assign ecchmatrix[8][396] = 0;
   assign ecchmatrix[9][396] = 1;
   assign ecchmatrix[0][397] = 1;
   assign ecchmatrix[1][397] = 1;
   assign ecchmatrix[2][397] = 1;
   assign ecchmatrix[3][397] = 0;
   assign ecchmatrix[4][397] = 1;
   assign ecchmatrix[5][397] = 1;
   assign ecchmatrix[6][397] = 0;
   assign ecchmatrix[7][397] = 0;
   assign ecchmatrix[8][397] = 1;
   assign ecchmatrix[9][397] = 1;
   assign ecchmatrix[0][398] = 1;
   assign ecchmatrix[1][398] = 1;
   assign ecchmatrix[2][398] = 1;
   assign ecchmatrix[3][398] = 0;
   assign ecchmatrix[4][398] = 1;
   assign ecchmatrix[5][398] = 0;
   assign ecchmatrix[6][398] = 1;
   assign ecchmatrix[7][398] = 1;
   assign ecchmatrix[8][398] = 1;
   assign ecchmatrix[9][398] = 0;
   assign ecchmatrix[0][399] = 1;
   assign ecchmatrix[1][399] = 1;
   assign ecchmatrix[2][399] = 1;
   assign ecchmatrix[3][399] = 0;
   assign ecchmatrix[4][399] = 1;
   assign ecchmatrix[5][399] = 0;
   assign ecchmatrix[6][399] = 1;
   assign ecchmatrix[7][399] = 1;
   assign ecchmatrix[8][399] = 0;
   assign ecchmatrix[9][399] = 1;
   assign ecchmatrix[0][400] = 1;
   assign ecchmatrix[1][400] = 1;
   assign ecchmatrix[2][400] = 1;
   assign ecchmatrix[3][400] = 0;
   assign ecchmatrix[4][400] = 1;
   assign ecchmatrix[5][400] = 0;
   assign ecchmatrix[6][400] = 1;
   assign ecchmatrix[7][400] = 0;
   assign ecchmatrix[8][400] = 1;
   assign ecchmatrix[9][400] = 1;
   assign ecchmatrix[0][401] = 1;
   assign ecchmatrix[1][401] = 1;
   assign ecchmatrix[2][401] = 1;
   assign ecchmatrix[3][401] = 0;
   assign ecchmatrix[4][401] = 1;
   assign ecchmatrix[5][401] = 0;
   assign ecchmatrix[6][401] = 0;
   assign ecchmatrix[7][401] = 1;
   assign ecchmatrix[8][401] = 1;
   assign ecchmatrix[9][401] = 1;
   assign ecchmatrix[0][402] = 1;
   assign ecchmatrix[1][402] = 1;
   assign ecchmatrix[2][402] = 1;
   assign ecchmatrix[3][402] = 0;
   assign ecchmatrix[4][402] = 0;
   assign ecchmatrix[5][402] = 1;
   assign ecchmatrix[6][402] = 1;
   assign ecchmatrix[7][402] = 1;
   assign ecchmatrix[8][402] = 1;
   assign ecchmatrix[9][402] = 0;
   assign ecchmatrix[0][403] = 1;
   assign ecchmatrix[1][403] = 1;
   assign ecchmatrix[2][403] = 1;
   assign ecchmatrix[3][403] = 0;
   assign ecchmatrix[4][403] = 0;
   assign ecchmatrix[5][403] = 1;
   assign ecchmatrix[6][403] = 1;
   assign ecchmatrix[7][403] = 1;
   assign ecchmatrix[8][403] = 0;
   assign ecchmatrix[9][403] = 1;
   assign ecchmatrix[0][404] = 1;
   assign ecchmatrix[1][404] = 1;
   assign ecchmatrix[2][404] = 1;
   assign ecchmatrix[3][404] = 0;
   assign ecchmatrix[4][404] = 0;
   assign ecchmatrix[5][404] = 1;
   assign ecchmatrix[6][404] = 1;
   assign ecchmatrix[7][404] = 0;
   assign ecchmatrix[8][404] = 1;
   assign ecchmatrix[9][404] = 1;
   assign ecchmatrix[0][405] = 1;
   assign ecchmatrix[1][405] = 1;
   assign ecchmatrix[2][405] = 1;
   assign ecchmatrix[3][405] = 0;
   assign ecchmatrix[4][405] = 0;
   assign ecchmatrix[5][405] = 1;
   assign ecchmatrix[6][405] = 0;
   assign ecchmatrix[7][405] = 1;
   assign ecchmatrix[8][405] = 1;
   assign ecchmatrix[9][405] = 1;
   assign ecchmatrix[0][406] = 1;
   assign ecchmatrix[1][406] = 1;
   assign ecchmatrix[2][406] = 1;
   assign ecchmatrix[3][406] = 0;
   assign ecchmatrix[4][406] = 0;
   assign ecchmatrix[5][406] = 0;
   assign ecchmatrix[6][406] = 1;
   assign ecchmatrix[7][406] = 1;
   assign ecchmatrix[8][406] = 1;
   assign ecchmatrix[9][406] = 1;
   assign ecchmatrix[0][407] = 1;
   assign ecchmatrix[1][407] = 1;
   assign ecchmatrix[2][407] = 0;
   assign ecchmatrix[3][407] = 1;
   assign ecchmatrix[4][407] = 1;
   assign ecchmatrix[5][407] = 1;
   assign ecchmatrix[6][407] = 1;
   assign ecchmatrix[7][407] = 1;
   assign ecchmatrix[8][407] = 0;
   assign ecchmatrix[9][407] = 0;
   assign ecchmatrix[0][408] = 1;
   assign ecchmatrix[1][408] = 1;
   assign ecchmatrix[2][408] = 0;
   assign ecchmatrix[3][408] = 1;
   assign ecchmatrix[4][408] = 1;
   assign ecchmatrix[5][408] = 1;
   assign ecchmatrix[6][408] = 1;
   assign ecchmatrix[7][408] = 0;
   assign ecchmatrix[8][408] = 1;
   assign ecchmatrix[9][408] = 0;
   assign ecchmatrix[0][409] = 1;
   assign ecchmatrix[1][409] = 1;
   assign ecchmatrix[2][409] = 0;
   assign ecchmatrix[3][409] = 1;
   assign ecchmatrix[4][409] = 1;
   assign ecchmatrix[5][409] = 1;
   assign ecchmatrix[6][409] = 1;
   assign ecchmatrix[7][409] = 0;
   assign ecchmatrix[8][409] = 0;
   assign ecchmatrix[9][409] = 1;
   assign ecchmatrix[0][410] = 1;
   assign ecchmatrix[1][410] = 1;
   assign ecchmatrix[2][410] = 0;
   assign ecchmatrix[3][410] = 1;
   assign ecchmatrix[4][410] = 1;
   assign ecchmatrix[5][410] = 1;
   assign ecchmatrix[6][410] = 0;
   assign ecchmatrix[7][410] = 1;
   assign ecchmatrix[8][410] = 1;
   assign ecchmatrix[9][410] = 0;
   assign ecchmatrix[0][411] = 1;
   assign ecchmatrix[1][411] = 1;
   assign ecchmatrix[2][411] = 0;
   assign ecchmatrix[3][411] = 1;
   assign ecchmatrix[4][411] = 1;
   assign ecchmatrix[5][411] = 1;
   assign ecchmatrix[6][411] = 0;
   assign ecchmatrix[7][411] = 1;
   assign ecchmatrix[8][411] = 0;
   assign ecchmatrix[9][411] = 1;
   assign ecchmatrix[0][412] = 1;
   assign ecchmatrix[1][412] = 1;
   assign ecchmatrix[2][412] = 0;
   assign ecchmatrix[3][412] = 1;
   assign ecchmatrix[4][412] = 1;
   assign ecchmatrix[5][412] = 1;
   assign ecchmatrix[6][412] = 0;
   assign ecchmatrix[7][412] = 0;
   assign ecchmatrix[8][412] = 1;
   assign ecchmatrix[9][412] = 1;
   assign ecchmatrix[0][413] = 1;
   assign ecchmatrix[1][413] = 1;
   assign ecchmatrix[2][413] = 0;
   assign ecchmatrix[3][413] = 1;
   assign ecchmatrix[4][413] = 1;
   assign ecchmatrix[5][413] = 0;
   assign ecchmatrix[6][413] = 1;
   assign ecchmatrix[7][413] = 1;
   assign ecchmatrix[8][413] = 1;
   assign ecchmatrix[9][413] = 0;
   assign ecchmatrix[0][414] = 1;
   assign ecchmatrix[1][414] = 1;
   assign ecchmatrix[2][414] = 0;
   assign ecchmatrix[3][414] = 1;
   assign ecchmatrix[4][414] = 1;
   assign ecchmatrix[5][414] = 0;
   assign ecchmatrix[6][414] = 1;
   assign ecchmatrix[7][414] = 1;
   assign ecchmatrix[8][414] = 0;
   assign ecchmatrix[9][414] = 1;
   assign ecchmatrix[0][415] = 1;
   assign ecchmatrix[1][415] = 1;
   assign ecchmatrix[2][415] = 0;
   assign ecchmatrix[3][415] = 1;
   assign ecchmatrix[4][415] = 1;
   assign ecchmatrix[5][415] = 0;
   assign ecchmatrix[6][415] = 1;
   assign ecchmatrix[7][415] = 0;
   assign ecchmatrix[8][415] = 1;
   assign ecchmatrix[9][415] = 1;
   assign ecchmatrix[0][416] = 1;
   assign ecchmatrix[1][416] = 1;
   assign ecchmatrix[2][416] = 0;
   assign ecchmatrix[3][416] = 1;
   assign ecchmatrix[4][416] = 1;
   assign ecchmatrix[5][416] = 0;
   assign ecchmatrix[6][416] = 0;
   assign ecchmatrix[7][416] = 1;
   assign ecchmatrix[8][416] = 1;
   assign ecchmatrix[9][416] = 1;
   assign ecchmatrix[0][417] = 1;
   assign ecchmatrix[1][417] = 1;
   assign ecchmatrix[2][417] = 0;
   assign ecchmatrix[3][417] = 1;
   assign ecchmatrix[4][417] = 0;
   assign ecchmatrix[5][417] = 1;
   assign ecchmatrix[6][417] = 1;
   assign ecchmatrix[7][417] = 1;
   assign ecchmatrix[8][417] = 1;
   assign ecchmatrix[9][417] = 0;
   assign ecchmatrix[0][418] = 1;
   assign ecchmatrix[1][418] = 1;
   assign ecchmatrix[2][418] = 0;
   assign ecchmatrix[3][418] = 1;
   assign ecchmatrix[4][418] = 0;
   assign ecchmatrix[5][418] = 1;
   assign ecchmatrix[6][418] = 1;
   assign ecchmatrix[7][418] = 1;
   assign ecchmatrix[8][418] = 0;
   assign ecchmatrix[9][418] = 1;
   assign ecchmatrix[0][419] = 1;
   assign ecchmatrix[1][419] = 1;
   assign ecchmatrix[2][419] = 0;
   assign ecchmatrix[3][419] = 1;
   assign ecchmatrix[4][419] = 0;
   assign ecchmatrix[5][419] = 1;
   assign ecchmatrix[6][419] = 1;
   assign ecchmatrix[7][419] = 0;
   assign ecchmatrix[8][419] = 1;
   assign ecchmatrix[9][419] = 1;
   assign ecchmatrix[0][420] = 1;
   assign ecchmatrix[1][420] = 1;
   assign ecchmatrix[2][420] = 0;
   assign ecchmatrix[3][420] = 1;
   assign ecchmatrix[4][420] = 0;
   assign ecchmatrix[5][420] = 1;
   assign ecchmatrix[6][420] = 0;
   assign ecchmatrix[7][420] = 1;
   assign ecchmatrix[8][420] = 1;
   assign ecchmatrix[9][420] = 1;
   assign ecchmatrix[0][421] = 1;
   assign ecchmatrix[1][421] = 1;
   assign ecchmatrix[2][421] = 0;
   assign ecchmatrix[3][421] = 1;
   assign ecchmatrix[4][421] = 0;
   assign ecchmatrix[5][421] = 0;
   assign ecchmatrix[6][421] = 1;
   assign ecchmatrix[7][421] = 1;
   assign ecchmatrix[8][421] = 1;
   assign ecchmatrix[9][421] = 1;
   assign ecchmatrix[0][422] = 1;
   assign ecchmatrix[1][422] = 1;
   assign ecchmatrix[2][422] = 0;
   assign ecchmatrix[3][422] = 0;
   assign ecchmatrix[4][422] = 1;
   assign ecchmatrix[5][422] = 1;
   assign ecchmatrix[6][422] = 1;
   assign ecchmatrix[7][422] = 1;
   assign ecchmatrix[8][422] = 1;
   assign ecchmatrix[9][422] = 0;
   assign ecchmatrix[0][423] = 1;
   assign ecchmatrix[1][423] = 1;
   assign ecchmatrix[2][423] = 0;
   assign ecchmatrix[3][423] = 0;
   assign ecchmatrix[4][423] = 1;
   assign ecchmatrix[5][423] = 1;
   assign ecchmatrix[6][423] = 1;
   assign ecchmatrix[7][423] = 1;
   assign ecchmatrix[8][423] = 0;
   assign ecchmatrix[9][423] = 1;
   assign ecchmatrix[0][424] = 1;
   assign ecchmatrix[1][424] = 1;
   assign ecchmatrix[2][424] = 0;
   assign ecchmatrix[3][424] = 0;
   assign ecchmatrix[4][424] = 1;
   assign ecchmatrix[5][424] = 1;
   assign ecchmatrix[6][424] = 1;
   assign ecchmatrix[7][424] = 0;
   assign ecchmatrix[8][424] = 1;
   assign ecchmatrix[9][424] = 1;
   assign ecchmatrix[0][425] = 1;
   assign ecchmatrix[1][425] = 1;
   assign ecchmatrix[2][425] = 0;
   assign ecchmatrix[3][425] = 0;
   assign ecchmatrix[4][425] = 1;
   assign ecchmatrix[5][425] = 1;
   assign ecchmatrix[6][425] = 0;
   assign ecchmatrix[7][425] = 1;
   assign ecchmatrix[8][425] = 1;
   assign ecchmatrix[9][425] = 1;
   assign ecchmatrix[0][426] = 1;
   assign ecchmatrix[1][426] = 1;
   assign ecchmatrix[2][426] = 0;
   assign ecchmatrix[3][426] = 0;
   assign ecchmatrix[4][426] = 1;
   assign ecchmatrix[5][426] = 0;
   assign ecchmatrix[6][426] = 1;
   assign ecchmatrix[7][426] = 1;
   assign ecchmatrix[8][426] = 1;
   assign ecchmatrix[9][426] = 1;
   assign ecchmatrix[0][427] = 1;
   assign ecchmatrix[1][427] = 1;
   assign ecchmatrix[2][427] = 0;
   assign ecchmatrix[3][427] = 0;
   assign ecchmatrix[4][427] = 0;
   assign ecchmatrix[5][427] = 1;
   assign ecchmatrix[6][427] = 1;
   assign ecchmatrix[7][427] = 1;
   assign ecchmatrix[8][427] = 1;
   assign ecchmatrix[9][427] = 1;
   assign ecchmatrix[0][428] = 1;
   assign ecchmatrix[1][428] = 0;
   assign ecchmatrix[2][428] = 1;
   assign ecchmatrix[3][428] = 1;
   assign ecchmatrix[4][428] = 1;
   assign ecchmatrix[5][428] = 1;
   assign ecchmatrix[6][428] = 1;
   assign ecchmatrix[7][428] = 1;
   assign ecchmatrix[8][428] = 0;
   assign ecchmatrix[9][428] = 0;
   assign ecchmatrix[0][429] = 1;
   assign ecchmatrix[1][429] = 0;
   assign ecchmatrix[2][429] = 1;
   assign ecchmatrix[3][429] = 1;
   assign ecchmatrix[4][429] = 1;
   assign ecchmatrix[5][429] = 1;
   assign ecchmatrix[6][429] = 1;
   assign ecchmatrix[7][429] = 0;
   assign ecchmatrix[8][429] = 1;
   assign ecchmatrix[9][429] = 0;
   assign ecchmatrix[0][430] = 1;
   assign ecchmatrix[1][430] = 0;
   assign ecchmatrix[2][430] = 1;
   assign ecchmatrix[3][430] = 1;
   assign ecchmatrix[4][430] = 1;
   assign ecchmatrix[5][430] = 1;
   assign ecchmatrix[6][430] = 1;
   assign ecchmatrix[7][430] = 0;
   assign ecchmatrix[8][430] = 0;
   assign ecchmatrix[9][430] = 1;
   assign ecchmatrix[0][431] = 1;
   assign ecchmatrix[1][431] = 0;
   assign ecchmatrix[2][431] = 1;
   assign ecchmatrix[3][431] = 1;
   assign ecchmatrix[4][431] = 1;
   assign ecchmatrix[5][431] = 1;
   assign ecchmatrix[6][431] = 0;
   assign ecchmatrix[7][431] = 1;
   assign ecchmatrix[8][431] = 1;
   assign ecchmatrix[9][431] = 0;
   assign ecchmatrix[0][432] = 1;
   assign ecchmatrix[1][432] = 0;
   assign ecchmatrix[2][432] = 1;
   assign ecchmatrix[3][432] = 1;
   assign ecchmatrix[4][432] = 1;
   assign ecchmatrix[5][432] = 1;
   assign ecchmatrix[6][432] = 0;
   assign ecchmatrix[7][432] = 1;
   assign ecchmatrix[8][432] = 0;
   assign ecchmatrix[9][432] = 1;
   assign ecchmatrix[0][433] = 1;
   assign ecchmatrix[1][433] = 0;
   assign ecchmatrix[2][433] = 1;
   assign ecchmatrix[3][433] = 1;
   assign ecchmatrix[4][433] = 1;
   assign ecchmatrix[5][433] = 1;
   assign ecchmatrix[6][433] = 0;
   assign ecchmatrix[7][433] = 0;
   assign ecchmatrix[8][433] = 1;
   assign ecchmatrix[9][433] = 1;
   assign ecchmatrix[0][434] = 1;
   assign ecchmatrix[1][434] = 0;
   assign ecchmatrix[2][434] = 1;
   assign ecchmatrix[3][434] = 1;
   assign ecchmatrix[4][434] = 1;
   assign ecchmatrix[5][434] = 0;
   assign ecchmatrix[6][434] = 1;
   assign ecchmatrix[7][434] = 1;
   assign ecchmatrix[8][434] = 1;
   assign ecchmatrix[9][434] = 0;
   assign ecchmatrix[0][435] = 1;
   assign ecchmatrix[1][435] = 0;
   assign ecchmatrix[2][435] = 1;
   assign ecchmatrix[3][435] = 1;
   assign ecchmatrix[4][435] = 1;
   assign ecchmatrix[5][435] = 0;
   assign ecchmatrix[6][435] = 1;
   assign ecchmatrix[7][435] = 1;
   assign ecchmatrix[8][435] = 0;
   assign ecchmatrix[9][435] = 1;
   assign ecchmatrix[0][436] = 1;
   assign ecchmatrix[1][436] = 0;
   assign ecchmatrix[2][436] = 1;
   assign ecchmatrix[3][436] = 1;
   assign ecchmatrix[4][436] = 1;
   assign ecchmatrix[5][436] = 0;
   assign ecchmatrix[6][436] = 1;
   assign ecchmatrix[7][436] = 0;
   assign ecchmatrix[8][436] = 1;
   assign ecchmatrix[9][436] = 1;
   assign ecchmatrix[0][437] = 1;
   assign ecchmatrix[1][437] = 0;
   assign ecchmatrix[2][437] = 1;
   assign ecchmatrix[3][437] = 1;
   assign ecchmatrix[4][437] = 1;
   assign ecchmatrix[5][437] = 0;
   assign ecchmatrix[6][437] = 0;
   assign ecchmatrix[7][437] = 1;
   assign ecchmatrix[8][437] = 1;
   assign ecchmatrix[9][437] = 1;
   assign ecchmatrix[0][438] = 1;
   assign ecchmatrix[1][438] = 0;
   assign ecchmatrix[2][438] = 1;
   assign ecchmatrix[3][438] = 1;
   assign ecchmatrix[4][438] = 0;
   assign ecchmatrix[5][438] = 1;
   assign ecchmatrix[6][438] = 1;
   assign ecchmatrix[7][438] = 1;
   assign ecchmatrix[8][438] = 1;
   assign ecchmatrix[9][438] = 0;
   assign ecchmatrix[0][439] = 1;
   assign ecchmatrix[1][439] = 0;
   assign ecchmatrix[2][439] = 1;
   assign ecchmatrix[3][439] = 1;
   assign ecchmatrix[4][439] = 0;
   assign ecchmatrix[5][439] = 1;
   assign ecchmatrix[6][439] = 1;
   assign ecchmatrix[7][439] = 1;
   assign ecchmatrix[8][439] = 0;
   assign ecchmatrix[9][439] = 1;
   assign ecchmatrix[0][440] = 1;
   assign ecchmatrix[1][440] = 0;
   assign ecchmatrix[2][440] = 1;
   assign ecchmatrix[3][440] = 1;
   assign ecchmatrix[4][440] = 0;
   assign ecchmatrix[5][440] = 1;
   assign ecchmatrix[6][440] = 1;
   assign ecchmatrix[7][440] = 0;
   assign ecchmatrix[8][440] = 1;
   assign ecchmatrix[9][440] = 1;
   assign ecchmatrix[0][441] = 1;
   assign ecchmatrix[1][441] = 0;
   assign ecchmatrix[2][441] = 1;
   assign ecchmatrix[3][441] = 1;
   assign ecchmatrix[4][441] = 0;
   assign ecchmatrix[5][441] = 1;
   assign ecchmatrix[6][441] = 0;
   assign ecchmatrix[7][441] = 1;
   assign ecchmatrix[8][441] = 1;
   assign ecchmatrix[9][441] = 1;
   assign ecchmatrix[0][442] = 1;
   assign ecchmatrix[1][442] = 0;
   assign ecchmatrix[2][442] = 1;
   assign ecchmatrix[3][442] = 1;
   assign ecchmatrix[4][442] = 0;
   assign ecchmatrix[5][442] = 0;
   assign ecchmatrix[6][442] = 1;
   assign ecchmatrix[7][442] = 1;
   assign ecchmatrix[8][442] = 1;
   assign ecchmatrix[9][442] = 1;
   assign ecchmatrix[0][443] = 1;
   assign ecchmatrix[1][443] = 0;
   assign ecchmatrix[2][443] = 1;
   assign ecchmatrix[3][443] = 0;
   assign ecchmatrix[4][443] = 1;
   assign ecchmatrix[5][443] = 1;
   assign ecchmatrix[6][443] = 1;
   assign ecchmatrix[7][443] = 1;
   assign ecchmatrix[8][443] = 1;
   assign ecchmatrix[9][443] = 0;
   assign ecchmatrix[0][444] = 1;
   assign ecchmatrix[1][444] = 0;
   assign ecchmatrix[2][444] = 1;
   assign ecchmatrix[3][444] = 0;
   assign ecchmatrix[4][444] = 1;
   assign ecchmatrix[5][444] = 1;
   assign ecchmatrix[6][444] = 1;
   assign ecchmatrix[7][444] = 1;
   assign ecchmatrix[8][444] = 0;
   assign ecchmatrix[9][444] = 1;
   assign ecchmatrix[0][445] = 1;
   assign ecchmatrix[1][445] = 0;
   assign ecchmatrix[2][445] = 1;
   assign ecchmatrix[3][445] = 0;
   assign ecchmatrix[4][445] = 1;
   assign ecchmatrix[5][445] = 1;
   assign ecchmatrix[6][445] = 1;
   assign ecchmatrix[7][445] = 0;
   assign ecchmatrix[8][445] = 1;
   assign ecchmatrix[9][445] = 1;
   assign ecchmatrix[0][446] = 1;
   assign ecchmatrix[1][446] = 0;
   assign ecchmatrix[2][446] = 1;
   assign ecchmatrix[3][446] = 0;
   assign ecchmatrix[4][446] = 1;
   assign ecchmatrix[5][446] = 1;
   assign ecchmatrix[6][446] = 0;
   assign ecchmatrix[7][446] = 1;
   assign ecchmatrix[8][446] = 1;
   assign ecchmatrix[9][446] = 1;
   assign ecchmatrix[0][447] = 1;
   assign ecchmatrix[1][447] = 0;
   assign ecchmatrix[2][447] = 1;
   assign ecchmatrix[3][447] = 0;
   assign ecchmatrix[4][447] = 1;
   assign ecchmatrix[5][447] = 0;
   assign ecchmatrix[6][447] = 1;
   assign ecchmatrix[7][447] = 1;
   assign ecchmatrix[8][447] = 1;
   assign ecchmatrix[9][447] = 1;
   assign ecchmatrix[0][448] = 1;
   assign ecchmatrix[1][448] = 0;
   assign ecchmatrix[2][448] = 1;
   assign ecchmatrix[3][448] = 0;
   assign ecchmatrix[4][448] = 0;
   assign ecchmatrix[5][448] = 1;
   assign ecchmatrix[6][448] = 1;
   assign ecchmatrix[7][448] = 1;
   assign ecchmatrix[8][448] = 1;
   assign ecchmatrix[9][448] = 1;
   assign ecchmatrix[0][449] = 1;
   assign ecchmatrix[1][449] = 0;
   assign ecchmatrix[2][449] = 0;
   assign ecchmatrix[3][449] = 1;
   assign ecchmatrix[4][449] = 1;
   assign ecchmatrix[5][449] = 1;
   assign ecchmatrix[6][449] = 1;
   assign ecchmatrix[7][449] = 1;
   assign ecchmatrix[8][449] = 1;
   assign ecchmatrix[9][449] = 0;
   assign ecchmatrix[0][450] = 1;
   assign ecchmatrix[1][450] = 0;
   assign ecchmatrix[2][450] = 0;
   assign ecchmatrix[3][450] = 1;
   assign ecchmatrix[4][450] = 1;
   assign ecchmatrix[5][450] = 1;
   assign ecchmatrix[6][450] = 1;
   assign ecchmatrix[7][450] = 1;
   assign ecchmatrix[8][450] = 0;
   assign ecchmatrix[9][450] = 1;
   assign ecchmatrix[0][451] = 1;
   assign ecchmatrix[1][451] = 0;
   assign ecchmatrix[2][451] = 0;
   assign ecchmatrix[3][451] = 1;
   assign ecchmatrix[4][451] = 1;
   assign ecchmatrix[5][451] = 1;
   assign ecchmatrix[6][451] = 1;
   assign ecchmatrix[7][451] = 0;
   assign ecchmatrix[8][451] = 1;
   assign ecchmatrix[9][451] = 1;
   assign ecchmatrix[0][452] = 1;
   assign ecchmatrix[1][452] = 0;
   assign ecchmatrix[2][452] = 0;
   assign ecchmatrix[3][452] = 1;
   assign ecchmatrix[4][452] = 1;
   assign ecchmatrix[5][452] = 1;
   assign ecchmatrix[6][452] = 0;
   assign ecchmatrix[7][452] = 1;
   assign ecchmatrix[8][452] = 1;
   assign ecchmatrix[9][452] = 1;
   assign ecchmatrix[0][453] = 1;
   assign ecchmatrix[1][453] = 0;
   assign ecchmatrix[2][453] = 0;
   assign ecchmatrix[3][453] = 1;
   assign ecchmatrix[4][453] = 1;
   assign ecchmatrix[5][453] = 0;
   assign ecchmatrix[6][453] = 1;
   assign ecchmatrix[7][453] = 1;
   assign ecchmatrix[8][453] = 1;
   assign ecchmatrix[9][453] = 1;
   assign ecchmatrix[0][454] = 1;
   assign ecchmatrix[1][454] = 0;
   assign ecchmatrix[2][454] = 0;
   assign ecchmatrix[3][454] = 1;
   assign ecchmatrix[4][454] = 0;
   assign ecchmatrix[5][454] = 1;
   assign ecchmatrix[6][454] = 1;
   assign ecchmatrix[7][454] = 1;
   assign ecchmatrix[8][454] = 1;
   assign ecchmatrix[9][454] = 1;
   assign ecchmatrix[0][455] = 1;
   assign ecchmatrix[1][455] = 0;
   assign ecchmatrix[2][455] = 0;
   assign ecchmatrix[3][455] = 0;
   assign ecchmatrix[4][455] = 1;
   assign ecchmatrix[5][455] = 1;
   assign ecchmatrix[6][455] = 1;
   assign ecchmatrix[7][455] = 1;
   assign ecchmatrix[8][455] = 1;
   assign ecchmatrix[9][455] = 1;
   assign ecchmatrix[0][456] = 0;
   assign ecchmatrix[1][456] = 1;
   assign ecchmatrix[2][456] = 1;
   assign ecchmatrix[3][456] = 1;
   assign ecchmatrix[4][456] = 1;
   assign ecchmatrix[5][456] = 1;
   assign ecchmatrix[6][456] = 1;
   assign ecchmatrix[7][456] = 1;
   assign ecchmatrix[8][456] = 0;
   assign ecchmatrix[9][456] = 0;
   assign ecchmatrix[0][457] = 0;
   assign ecchmatrix[1][457] = 1;
   assign ecchmatrix[2][457] = 1;
   assign ecchmatrix[3][457] = 1;
   assign ecchmatrix[4][457] = 1;
   assign ecchmatrix[5][457] = 1;
   assign ecchmatrix[6][457] = 1;
   assign ecchmatrix[7][457] = 0;
   assign ecchmatrix[8][457] = 1;
   assign ecchmatrix[9][457] = 0;
   assign ecchmatrix[0][458] = 0;
   assign ecchmatrix[1][458] = 1;
   assign ecchmatrix[2][458] = 1;
   assign ecchmatrix[3][458] = 1;
   assign ecchmatrix[4][458] = 1;
   assign ecchmatrix[5][458] = 1;
   assign ecchmatrix[6][458] = 1;
   assign ecchmatrix[7][458] = 0;
   assign ecchmatrix[8][458] = 0;
   assign ecchmatrix[9][458] = 1;
   assign ecchmatrix[0][459] = 0;
   assign ecchmatrix[1][459] = 1;
   assign ecchmatrix[2][459] = 1;
   assign ecchmatrix[3][459] = 1;
   assign ecchmatrix[4][459] = 1;
   assign ecchmatrix[5][459] = 1;
   assign ecchmatrix[6][459] = 0;
   assign ecchmatrix[7][459] = 1;
   assign ecchmatrix[8][459] = 1;
   assign ecchmatrix[9][459] = 0;
   assign ecchmatrix[0][460] = 0;
   assign ecchmatrix[1][460] = 1;
   assign ecchmatrix[2][460] = 1;
   assign ecchmatrix[3][460] = 1;
   assign ecchmatrix[4][460] = 1;
   assign ecchmatrix[5][460] = 1;
   assign ecchmatrix[6][460] = 0;
   assign ecchmatrix[7][460] = 1;
   assign ecchmatrix[8][460] = 0;
   assign ecchmatrix[9][460] = 1;
   assign ecchmatrix[0][461] = 0;
   assign ecchmatrix[1][461] = 1;
   assign ecchmatrix[2][461] = 1;
   assign ecchmatrix[3][461] = 1;
   assign ecchmatrix[4][461] = 1;
   assign ecchmatrix[5][461] = 1;
   assign ecchmatrix[6][461] = 0;
   assign ecchmatrix[7][461] = 0;
   assign ecchmatrix[8][461] = 1;
   assign ecchmatrix[9][461] = 1;
   assign ecchmatrix[0][462] = 0;
   assign ecchmatrix[1][462] = 1;
   assign ecchmatrix[2][462] = 1;
   assign ecchmatrix[3][462] = 1;
   assign ecchmatrix[4][462] = 1;
   assign ecchmatrix[5][462] = 0;
   assign ecchmatrix[6][462] = 1;
   assign ecchmatrix[7][462] = 1;
   assign ecchmatrix[8][462] = 1;
   assign ecchmatrix[9][462] = 0;
   assign ecchmatrix[0][463] = 0;
   assign ecchmatrix[1][463] = 1;
   assign ecchmatrix[2][463] = 1;
   assign ecchmatrix[3][463] = 1;
   assign ecchmatrix[4][463] = 1;
   assign ecchmatrix[5][463] = 0;
   assign ecchmatrix[6][463] = 1;
   assign ecchmatrix[7][463] = 1;
   assign ecchmatrix[8][463] = 0;
   assign ecchmatrix[9][463] = 1;
   assign ecchmatrix[0][464] = 0;
   assign ecchmatrix[1][464] = 1;
   assign ecchmatrix[2][464] = 1;
   assign ecchmatrix[3][464] = 1;
   assign ecchmatrix[4][464] = 1;
   assign ecchmatrix[5][464] = 0;
   assign ecchmatrix[6][464] = 1;
   assign ecchmatrix[7][464] = 0;
   assign ecchmatrix[8][464] = 1;
   assign ecchmatrix[9][464] = 1;
   assign ecchmatrix[0][465] = 0;
   assign ecchmatrix[1][465] = 1;
   assign ecchmatrix[2][465] = 1;
   assign ecchmatrix[3][465] = 1;
   assign ecchmatrix[4][465] = 1;
   assign ecchmatrix[5][465] = 0;
   assign ecchmatrix[6][465] = 0;
   assign ecchmatrix[7][465] = 1;
   assign ecchmatrix[8][465] = 1;
   assign ecchmatrix[9][465] = 1;
   assign ecchmatrix[0][466] = 0;
   assign ecchmatrix[1][466] = 1;
   assign ecchmatrix[2][466] = 1;
   assign ecchmatrix[3][466] = 1;
   assign ecchmatrix[4][466] = 0;
   assign ecchmatrix[5][466] = 1;
   assign ecchmatrix[6][466] = 1;
   assign ecchmatrix[7][466] = 1;
   assign ecchmatrix[8][466] = 1;
   assign ecchmatrix[9][466] = 0;
   assign ecchmatrix[0][467] = 0;
   assign ecchmatrix[1][467] = 1;
   assign ecchmatrix[2][467] = 1;
   assign ecchmatrix[3][467] = 1;
   assign ecchmatrix[4][467] = 0;
   assign ecchmatrix[5][467] = 1;
   assign ecchmatrix[6][467] = 1;
   assign ecchmatrix[7][467] = 1;
   assign ecchmatrix[8][467] = 0;
   assign ecchmatrix[9][467] = 1;
   assign ecchmatrix[0][468] = 0;
   assign ecchmatrix[1][468] = 1;
   assign ecchmatrix[2][468] = 1;
   assign ecchmatrix[3][468] = 1;
   assign ecchmatrix[4][468] = 0;
   assign ecchmatrix[5][468] = 1;
   assign ecchmatrix[6][468] = 1;
   assign ecchmatrix[7][468] = 0;
   assign ecchmatrix[8][468] = 1;
   assign ecchmatrix[9][468] = 1;
   assign ecchmatrix[0][469] = 0;
   assign ecchmatrix[1][469] = 1;
   assign ecchmatrix[2][469] = 1;
   assign ecchmatrix[3][469] = 1;
   assign ecchmatrix[4][469] = 0;
   assign ecchmatrix[5][469] = 1;
   assign ecchmatrix[6][469] = 0;
   assign ecchmatrix[7][469] = 1;
   assign ecchmatrix[8][469] = 1;
   assign ecchmatrix[9][469] = 1;
   assign ecchmatrix[0][470] = 0;
   assign ecchmatrix[1][470] = 1;
   assign ecchmatrix[2][470] = 1;
   assign ecchmatrix[3][470] = 1;
   assign ecchmatrix[4][470] = 0;
   assign ecchmatrix[5][470] = 0;
   assign ecchmatrix[6][470] = 1;
   assign ecchmatrix[7][470] = 1;
   assign ecchmatrix[8][470] = 1;
   assign ecchmatrix[9][470] = 1;
   assign ecchmatrix[0][471] = 0;
   assign ecchmatrix[1][471] = 1;
   assign ecchmatrix[2][471] = 1;
   assign ecchmatrix[3][471] = 0;
   assign ecchmatrix[4][471] = 1;
   assign ecchmatrix[5][471] = 1;
   assign ecchmatrix[6][471] = 1;
   assign ecchmatrix[7][471] = 1;
   assign ecchmatrix[8][471] = 1;
   assign ecchmatrix[9][471] = 0;
   assign ecchmatrix[0][472] = 0;
   assign ecchmatrix[1][472] = 1;
   assign ecchmatrix[2][472] = 1;
   assign ecchmatrix[3][472] = 0;
   assign ecchmatrix[4][472] = 1;
   assign ecchmatrix[5][472] = 1;
   assign ecchmatrix[6][472] = 1;
   assign ecchmatrix[7][472] = 1;
   assign ecchmatrix[8][472] = 0;
   assign ecchmatrix[9][472] = 1;
   assign ecchmatrix[0][473] = 0;
   assign ecchmatrix[1][473] = 1;
   assign ecchmatrix[2][473] = 1;
   assign ecchmatrix[3][473] = 0;
   assign ecchmatrix[4][473] = 1;
   assign ecchmatrix[5][473] = 1;
   assign ecchmatrix[6][473] = 1;
   assign ecchmatrix[7][473] = 0;
   assign ecchmatrix[8][473] = 1;
   assign ecchmatrix[9][473] = 1;
   assign ecchmatrix[0][474] = 0;
   assign ecchmatrix[1][474] = 1;
   assign ecchmatrix[2][474] = 1;
   assign ecchmatrix[3][474] = 0;
   assign ecchmatrix[4][474] = 1;
   assign ecchmatrix[5][474] = 1;
   assign ecchmatrix[6][474] = 0;
   assign ecchmatrix[7][474] = 1;
   assign ecchmatrix[8][474] = 1;
   assign ecchmatrix[9][474] = 1;
   assign ecchmatrix[0][475] = 0;
   assign ecchmatrix[1][475] = 1;
   assign ecchmatrix[2][475] = 1;
   assign ecchmatrix[3][475] = 0;
   assign ecchmatrix[4][475] = 1;
   assign ecchmatrix[5][475] = 0;
   assign ecchmatrix[6][475] = 1;
   assign ecchmatrix[7][475] = 1;
   assign ecchmatrix[8][475] = 1;
   assign ecchmatrix[9][475] = 1;
   assign ecchmatrix[0][476] = 0;
   assign ecchmatrix[1][476] = 1;
   assign ecchmatrix[2][476] = 1;
   assign ecchmatrix[3][476] = 0;
   assign ecchmatrix[4][476] = 0;
   assign ecchmatrix[5][476] = 1;
   assign ecchmatrix[6][476] = 1;
   assign ecchmatrix[7][476] = 1;
   assign ecchmatrix[8][476] = 1;
   assign ecchmatrix[9][476] = 1;
   assign ecchmatrix[0][477] = 0;
   assign ecchmatrix[1][477] = 1;
   assign ecchmatrix[2][477] = 0;
   assign ecchmatrix[3][477] = 1;
   assign ecchmatrix[4][477] = 1;
   assign ecchmatrix[5][477] = 1;
   assign ecchmatrix[6][477] = 1;
   assign ecchmatrix[7][477] = 1;
   assign ecchmatrix[8][477] = 1;
   assign ecchmatrix[9][477] = 0;
   assign ecchmatrix[0][478] = 0;
   assign ecchmatrix[1][478] = 1;
   assign ecchmatrix[2][478] = 0;
   assign ecchmatrix[3][478] = 1;
   assign ecchmatrix[4][478] = 1;
   assign ecchmatrix[5][478] = 1;
   assign ecchmatrix[6][478] = 1;
   assign ecchmatrix[7][478] = 1;
   assign ecchmatrix[8][478] = 0;
   assign ecchmatrix[9][478] = 1;
   assign ecchmatrix[0][479] = 0;
   assign ecchmatrix[1][479] = 1;
   assign ecchmatrix[2][479] = 0;
   assign ecchmatrix[3][479] = 1;
   assign ecchmatrix[4][479] = 1;
   assign ecchmatrix[5][479] = 1;
   assign ecchmatrix[6][479] = 1;
   assign ecchmatrix[7][479] = 0;
   assign ecchmatrix[8][479] = 1;
   assign ecchmatrix[9][479] = 1;
   assign ecchmatrix[0][480] = 0;
   assign ecchmatrix[1][480] = 1;
   assign ecchmatrix[2][480] = 0;
   assign ecchmatrix[3][480] = 1;
   assign ecchmatrix[4][480] = 1;
   assign ecchmatrix[5][480] = 1;
   assign ecchmatrix[6][480] = 0;
   assign ecchmatrix[7][480] = 1;
   assign ecchmatrix[8][480] = 1;
   assign ecchmatrix[9][480] = 1;
   assign ecchmatrix[0][481] = 0;
   assign ecchmatrix[1][481] = 1;
   assign ecchmatrix[2][481] = 0;
   assign ecchmatrix[3][481] = 1;
   assign ecchmatrix[4][481] = 1;
   assign ecchmatrix[5][481] = 0;
   assign ecchmatrix[6][481] = 1;
   assign ecchmatrix[7][481] = 1;
   assign ecchmatrix[8][481] = 1;
   assign ecchmatrix[9][481] = 1;
   assign ecchmatrix[0][482] = 0;
   assign ecchmatrix[1][482] = 1;
   assign ecchmatrix[2][482] = 0;
   assign ecchmatrix[3][482] = 1;
   assign ecchmatrix[4][482] = 0;
   assign ecchmatrix[5][482] = 1;
   assign ecchmatrix[6][482] = 1;
   assign ecchmatrix[7][482] = 1;
   assign ecchmatrix[8][482] = 1;
   assign ecchmatrix[9][482] = 1;
   assign ecchmatrix[0][483] = 0;
   assign ecchmatrix[1][483] = 1;
   assign ecchmatrix[2][483] = 0;
   assign ecchmatrix[3][483] = 0;
   assign ecchmatrix[4][483] = 1;
   assign ecchmatrix[5][483] = 1;
   assign ecchmatrix[6][483] = 1;
   assign ecchmatrix[7][483] = 1;
   assign ecchmatrix[8][483] = 1;
   assign ecchmatrix[9][483] = 1;
   assign ecchmatrix[0][484] = 0;
   assign ecchmatrix[1][484] = 0;
   assign ecchmatrix[2][484] = 1;
   assign ecchmatrix[3][484] = 1;
   assign ecchmatrix[4][484] = 1;
   assign ecchmatrix[5][484] = 1;
   assign ecchmatrix[6][484] = 1;
   assign ecchmatrix[7][484] = 1;
   assign ecchmatrix[8][484] = 1;
   assign ecchmatrix[9][484] = 0;
   assign ecchmatrix[0][485] = 0;
   assign ecchmatrix[1][485] = 0;
   assign ecchmatrix[2][485] = 1;
   assign ecchmatrix[3][485] = 1;
   assign ecchmatrix[4][485] = 1;
   assign ecchmatrix[5][485] = 1;
   assign ecchmatrix[6][485] = 1;
   assign ecchmatrix[7][485] = 1;
   assign ecchmatrix[8][485] = 0;
   assign ecchmatrix[9][485] = 1;
   assign ecchmatrix[0][486] = 0;
   assign ecchmatrix[1][486] = 0;
   assign ecchmatrix[2][486] = 1;
   assign ecchmatrix[3][486] = 1;
   assign ecchmatrix[4][486] = 1;
   assign ecchmatrix[5][486] = 1;
   assign ecchmatrix[6][486] = 1;
   assign ecchmatrix[7][486] = 0;
   assign ecchmatrix[8][486] = 1;
   assign ecchmatrix[9][486] = 1;
   assign ecchmatrix[0][487] = 0;
   assign ecchmatrix[1][487] = 0;
   assign ecchmatrix[2][487] = 1;
   assign ecchmatrix[3][487] = 1;
   assign ecchmatrix[4][487] = 1;
   assign ecchmatrix[5][487] = 1;
   assign ecchmatrix[6][487] = 0;
   assign ecchmatrix[7][487] = 1;
   assign ecchmatrix[8][487] = 1;
   assign ecchmatrix[9][487] = 1;
   assign ecchmatrix[0][488] = 0;
   assign ecchmatrix[1][488] = 0;
   assign ecchmatrix[2][488] = 1;
   assign ecchmatrix[3][488] = 1;
   assign ecchmatrix[4][488] = 1;
   assign ecchmatrix[5][488] = 0;
   assign ecchmatrix[6][488] = 1;
   assign ecchmatrix[7][488] = 1;
   assign ecchmatrix[8][488] = 1;
   assign ecchmatrix[9][488] = 1;
   assign ecchmatrix[0][489] = 0;
   assign ecchmatrix[1][489] = 0;
   assign ecchmatrix[2][489] = 1;
   assign ecchmatrix[3][489] = 1;
   assign ecchmatrix[4][489] = 0;
   assign ecchmatrix[5][489] = 1;
   assign ecchmatrix[6][489] = 1;
   assign ecchmatrix[7][489] = 1;
   assign ecchmatrix[8][489] = 1;
   assign ecchmatrix[9][489] = 1;
   assign ecchmatrix[0][490] = 0;
   assign ecchmatrix[1][490] = 0;
   assign ecchmatrix[2][490] = 1;
   assign ecchmatrix[3][490] = 0;
   assign ecchmatrix[4][490] = 1;
   assign ecchmatrix[5][490] = 1;
   assign ecchmatrix[6][490] = 1;
   assign ecchmatrix[7][490] = 1;
   assign ecchmatrix[8][490] = 1;
   assign ecchmatrix[9][490] = 1;
   assign ecchmatrix[0][491] = 0;
   assign ecchmatrix[1][491] = 0;
   assign ecchmatrix[2][491] = 0;
   assign ecchmatrix[3][491] = 1;
   assign ecchmatrix[4][491] = 1;
   assign ecchmatrix[5][491] = 1;
   assign ecchmatrix[6][491] = 1;
   assign ecchmatrix[7][491] = 1;
   assign ecchmatrix[8][491] = 1;
   assign ecchmatrix[9][491] = 1;
   assign ecchmatrix[0][492] = 1;
   assign ecchmatrix[1][492] = 1;
   assign ecchmatrix[2][492] = 1;
   assign ecchmatrix[3][492] = 1;
   assign ecchmatrix[4][492] = 1;
   assign ecchmatrix[5][492] = 1;
   assign ecchmatrix[6][492] = 1;
   assign ecchmatrix[7][492] = 1;
   assign ecchmatrix[8][492] = 1;
   assign ecchmatrix[9][492] = 0;
   assign ecchmatrix[0][493] = 1;
   assign ecchmatrix[1][493] = 1;
   assign ecchmatrix[2][493] = 1;
   assign ecchmatrix[3][493] = 1;
   assign ecchmatrix[4][493] = 1;
   assign ecchmatrix[5][493] = 1;
   assign ecchmatrix[6][493] = 1;
   assign ecchmatrix[7][493] = 1;
   assign ecchmatrix[8][493] = 0;
   assign ecchmatrix[9][493] = 1;
   assign ecchmatrix[0][494] = 1;
   assign ecchmatrix[1][494] = 1;
   assign ecchmatrix[2][494] = 1;
   assign ecchmatrix[3][494] = 1;
   assign ecchmatrix[4][494] = 1;
   assign ecchmatrix[5][494] = 1;
   assign ecchmatrix[6][494] = 1;
   assign ecchmatrix[7][494] = 0;
   assign ecchmatrix[8][494] = 1;
   assign ecchmatrix[9][494] = 1;
   assign ecchmatrix[0][495] = 1;
   assign ecchmatrix[1][495] = 1;
   assign ecchmatrix[2][495] = 1;
   assign ecchmatrix[3][495] = 1;
   assign ecchmatrix[4][495] = 1;
   assign ecchmatrix[5][495] = 1;
   assign ecchmatrix[6][495] = 0;
   assign ecchmatrix[7][495] = 1;
   assign ecchmatrix[8][495] = 1;
   assign ecchmatrix[9][495] = 1;
   assign ecchmatrix[0][496] = 1;
   assign ecchmatrix[1][496] = 1;
   assign ecchmatrix[2][496] = 1;
   assign ecchmatrix[3][496] = 1;
   assign ecchmatrix[4][496] = 1;
   assign ecchmatrix[5][496] = 0;
   assign ecchmatrix[6][496] = 1;
   assign ecchmatrix[7][496] = 1;
   assign ecchmatrix[8][496] = 1;
   assign ecchmatrix[9][496] = 1;
   assign ecchmatrix[0][497] = 1;
   assign ecchmatrix[1][497] = 1;
   assign ecchmatrix[2][497] = 1;
   assign ecchmatrix[3][497] = 1;
   assign ecchmatrix[4][497] = 0;
   assign ecchmatrix[5][497] = 1;
   assign ecchmatrix[6][497] = 1;
   assign ecchmatrix[7][497] = 1;
   assign ecchmatrix[8][497] = 1;
   assign ecchmatrix[9][497] = 1;
   assign ecchmatrix[0][498] = 1;
   assign ecchmatrix[1][498] = 1;
   assign ecchmatrix[2][498] = 1;
   assign ecchmatrix[3][498] = 0;
   assign ecchmatrix[4][498] = 1;
   assign ecchmatrix[5][498] = 1;
   assign ecchmatrix[6][498] = 1;
   assign ecchmatrix[7][498] = 1;
   assign ecchmatrix[8][498] = 1;
   assign ecchmatrix[9][498] = 1;
   assign ecchmatrix[0][499] = 1;
   assign ecchmatrix[1][499] = 1;
   assign ecchmatrix[2][499] = 0;
   assign ecchmatrix[3][499] = 1;
   assign ecchmatrix[4][499] = 1;
   assign ecchmatrix[5][499] = 1;
   assign ecchmatrix[6][499] = 1;
   assign ecchmatrix[7][499] = 1;
   assign ecchmatrix[8][499] = 1;
   assign ecchmatrix[9][499] = 1;
   assign ecchmatrix[0][500] = 1;
   assign ecchmatrix[1][500] = 0;
   assign ecchmatrix[2][500] = 1;
   assign ecchmatrix[3][500] = 1;
   assign ecchmatrix[4][500] = 1;
   assign ecchmatrix[5][500] = 1;
   assign ecchmatrix[6][500] = 1;
   assign ecchmatrix[7][500] = 1;
   assign ecchmatrix[8][500] = 1;
   assign ecchmatrix[9][500] = 1;
   assign ecchmatrix[0][501] = 0;
   assign ecchmatrix[1][501] = 1;
   assign ecchmatrix[2][501] = 1;
   assign ecchmatrix[3][501] = 1;
   assign ecchmatrix[4][501] = 1;
   assign ecchmatrix[5][501] = 1;
   assign ecchmatrix[6][501] = 1;
   assign ecchmatrix[7][501] = 1;
   assign ecchmatrix[8][501] = 1;
   assign ecchmatrix[9][501] = 1;
   assign ecchmatrix[0][502] = 1;
   assign ecchmatrix[1][502] = 0;
   assign ecchmatrix[2][502] = 0;
   assign ecchmatrix[3][502] = 0;
   assign ecchmatrix[4][502] = 0;
   assign ecchmatrix[5][502] = 0;
   assign ecchmatrix[6][502] = 0;
   assign ecchmatrix[7][502] = 0;
   assign ecchmatrix[8][502] = 0;
   assign ecchmatrix[9][502] = 0;
   assign ecchmatrix[0][503] = 0;
   assign ecchmatrix[1][503] = 1;
   assign ecchmatrix[2][503] = 0;
   assign ecchmatrix[3][503] = 0;
   assign ecchmatrix[4][503] = 0;
   assign ecchmatrix[5][503] = 0;
   assign ecchmatrix[6][503] = 0;
   assign ecchmatrix[7][503] = 0;
   assign ecchmatrix[8][503] = 0;
   assign ecchmatrix[9][503] = 0;
   assign ecchmatrix[0][504] = 0;
   assign ecchmatrix[1][504] = 0;
   assign ecchmatrix[2][504] = 1;
   assign ecchmatrix[3][504] = 0;
   assign ecchmatrix[4][504] = 0;
   assign ecchmatrix[5][504] = 0;
   assign ecchmatrix[6][504] = 0;
   assign ecchmatrix[7][504] = 0;
   assign ecchmatrix[8][504] = 0;
   assign ecchmatrix[9][504] = 0;
   assign ecchmatrix[0][505] = 0;
   assign ecchmatrix[1][505] = 0;
   assign ecchmatrix[2][505] = 0;
   assign ecchmatrix[3][505] = 1;
   assign ecchmatrix[4][505] = 0;
   assign ecchmatrix[5][505] = 0;
   assign ecchmatrix[6][505] = 0;
   assign ecchmatrix[7][505] = 0;
   assign ecchmatrix[8][505] = 0;
   assign ecchmatrix[9][505] = 0;
   assign ecchmatrix[0][506] = 0;
   assign ecchmatrix[1][506] = 0;
   assign ecchmatrix[2][506] = 0;
   assign ecchmatrix[3][506] = 0;
   assign ecchmatrix[4][506] = 1;
   assign ecchmatrix[5][506] = 0;
   assign ecchmatrix[6][506] = 0;
   assign ecchmatrix[7][506] = 0;
   assign ecchmatrix[8][506] = 0;
   assign ecchmatrix[9][506] = 0;
   assign ecchmatrix[0][507] = 0;
   assign ecchmatrix[1][507] = 0;
   assign ecchmatrix[2][507] = 0;
   assign ecchmatrix[3][507] = 0;
   assign ecchmatrix[4][507] = 0;
   assign ecchmatrix[5][507] = 1;
   assign ecchmatrix[6][507] = 0;
   assign ecchmatrix[7][507] = 0;
   assign ecchmatrix[8][507] = 0;
   assign ecchmatrix[9][507] = 0;
   assign ecchmatrix[0][508] = 0;
   assign ecchmatrix[1][508] = 0;
   assign ecchmatrix[2][508] = 0;
   assign ecchmatrix[3][508] = 0;
   assign ecchmatrix[4][508] = 0;
   assign ecchmatrix[5][508] = 0;
   assign ecchmatrix[6][508] = 1;
   assign ecchmatrix[7][508] = 0;
   assign ecchmatrix[8][508] = 0;
   assign ecchmatrix[9][508] = 0;
   assign ecchmatrix[0][509] = 0;
   assign ecchmatrix[1][509] = 0;
   assign ecchmatrix[2][509] = 0;
   assign ecchmatrix[3][509] = 0;
   assign ecchmatrix[4][509] = 0;
   assign ecchmatrix[5][509] = 0;
   assign ecchmatrix[6][509] = 0;
   assign ecchmatrix[7][509] = 1;
   assign ecchmatrix[8][509] = 0;
   assign ecchmatrix[9][509] = 0;
   assign ecchmatrix[0][510] = 0;
   assign ecchmatrix[1][510] = 0;
   assign ecchmatrix[2][510] = 0;
   assign ecchmatrix[3][510] = 0;
   assign ecchmatrix[4][510] = 0;
   assign ecchmatrix[5][510] = 0;
   assign ecchmatrix[6][510] = 0;
   assign ecchmatrix[7][510] = 0;
   assign ecchmatrix[8][510] = 1;
   assign ecchmatrix[9][510] = 0;
   assign ecchmatrix[0][511] = 0;
   assign ecchmatrix[1][511] = 0;
   assign ecchmatrix[2][511] = 0;
   assign ecchmatrix[3][511] = 0;
   assign ecchmatrix[4][511] = 0;
   assign ecchmatrix[5][511] = 0;
   assign ecchmatrix[6][511] = 0;
   assign ecchmatrix[7][511] = 0;
   assign ecchmatrix[8][511] = 0;
   assign ecchmatrix[9][511] = 1;


  assign sbits_wire[9] = (^(ecchmatrix[9]&din)) ^ eccin[9] ;
  assign sbits_wire[8] = (^(ecchmatrix[8]&din)) ^ eccin[8] ;
  assign sbits_wire[7] = (^(ecchmatrix[7]&din)) ^ eccin[7] ;
  assign sbits_wire[6] = (^(ecchmatrix[6]&din)) ^ eccin[6] ;
  assign sbits_wire[5] = (^(ecchmatrix[5]&din)) ^ eccin[5] ;
  assign sbits_wire[4] = (^(ecchmatrix[4]&din)) ^ eccin[4] ;
  assign sbits_wire[3] = (^(ecchmatrix[3]&din)) ^ eccin[3] ;
  assign sbits_wire[2] = (^(ecchmatrix[2]&din)) ^ eccin[2] ;
  assign sbits_wire[1] = (^(ecchmatrix[1]&din)) ^ eccin[1] ;
  assign sbits_wire[0] = (^(ecchmatrix[0]&din)) ^ eccin[0] ;

  wire [ECCWIDTH-1:0]    sbits;
  wire [ECCDWIDTH-1:0]	din_f1;
  generate if(FLOPECC1) begin
	reg [ECCWIDTH-1:0]    sbits_reg;
	reg [ECCDWIDTH-1:0]	din_f1_reg;
	always @(posedge clk) begin
		sbits_reg <= sbits_wire;
		din_f1_reg <= din;
	end
	assign sbits = sbits_reg;
	assign din_f1 = din_f1_reg;
  end else begin
	assign sbits = sbits_wire;
	assign din_f1 = din;
  end
  endgenerate
  
  assign biterr_wire[511] = ~(
         ecchmatrix[9][511]^sbits[9] |
         ecchmatrix[8][511]^sbits[8] |
         ecchmatrix[7][511]^sbits[7] |
         ecchmatrix[6][511]^sbits[6] |
         ecchmatrix[5][511]^sbits[5] |
         ecchmatrix[4][511]^sbits[4] |
         ecchmatrix[3][511]^sbits[3] |
         ecchmatrix[2][511]^sbits[2] |
         ecchmatrix[1][511]^sbits[1] |
         ecchmatrix[0][511]^sbits[0]);
  assign biterr_wire[510] = ~(
         ecchmatrix[9][510]^sbits[9] |
         ecchmatrix[8][510]^sbits[8] |
         ecchmatrix[7][510]^sbits[7] |
         ecchmatrix[6][510]^sbits[6] |
         ecchmatrix[5][510]^sbits[5] |
         ecchmatrix[4][510]^sbits[4] |
         ecchmatrix[3][510]^sbits[3] |
         ecchmatrix[2][510]^sbits[2] |
         ecchmatrix[1][510]^sbits[1] |
         ecchmatrix[0][510]^sbits[0]);
  assign biterr_wire[509] = ~(
         ecchmatrix[9][509]^sbits[9] |
         ecchmatrix[8][509]^sbits[8] |
         ecchmatrix[7][509]^sbits[7] |
         ecchmatrix[6][509]^sbits[6] |
         ecchmatrix[5][509]^sbits[5] |
         ecchmatrix[4][509]^sbits[4] |
         ecchmatrix[3][509]^sbits[3] |
         ecchmatrix[2][509]^sbits[2] |
         ecchmatrix[1][509]^sbits[1] |
         ecchmatrix[0][509]^sbits[0]);
  assign biterr_wire[508] = ~(
         ecchmatrix[9][508]^sbits[9] |
         ecchmatrix[8][508]^sbits[8] |
         ecchmatrix[7][508]^sbits[7] |
         ecchmatrix[6][508]^sbits[6] |
         ecchmatrix[5][508]^sbits[5] |
         ecchmatrix[4][508]^sbits[4] |
         ecchmatrix[3][508]^sbits[3] |
         ecchmatrix[2][508]^sbits[2] |
         ecchmatrix[1][508]^sbits[1] |
         ecchmatrix[0][508]^sbits[0]);
  assign biterr_wire[507] = ~(
         ecchmatrix[9][507]^sbits[9] |
         ecchmatrix[8][507]^sbits[8] |
         ecchmatrix[7][507]^sbits[7] |
         ecchmatrix[6][507]^sbits[6] |
         ecchmatrix[5][507]^sbits[5] |
         ecchmatrix[4][507]^sbits[4] |
         ecchmatrix[3][507]^sbits[3] |
         ecchmatrix[2][507]^sbits[2] |
         ecchmatrix[1][507]^sbits[1] |
         ecchmatrix[0][507]^sbits[0]);
  assign biterr_wire[506] = ~(
         ecchmatrix[9][506]^sbits[9] |
         ecchmatrix[8][506]^sbits[8] |
         ecchmatrix[7][506]^sbits[7] |
         ecchmatrix[6][506]^sbits[6] |
         ecchmatrix[5][506]^sbits[5] |
         ecchmatrix[4][506]^sbits[4] |
         ecchmatrix[3][506]^sbits[3] |
         ecchmatrix[2][506]^sbits[2] |
         ecchmatrix[1][506]^sbits[1] |
         ecchmatrix[0][506]^sbits[0]);
  assign biterr_wire[505] = ~(
         ecchmatrix[9][505]^sbits[9] |
         ecchmatrix[8][505]^sbits[8] |
         ecchmatrix[7][505]^sbits[7] |
         ecchmatrix[6][505]^sbits[6] |
         ecchmatrix[5][505]^sbits[5] |
         ecchmatrix[4][505]^sbits[4] |
         ecchmatrix[3][505]^sbits[3] |
         ecchmatrix[2][505]^sbits[2] |
         ecchmatrix[1][505]^sbits[1] |
         ecchmatrix[0][505]^sbits[0]);
  assign biterr_wire[504] = ~(
         ecchmatrix[9][504]^sbits[9] |
         ecchmatrix[8][504]^sbits[8] |
         ecchmatrix[7][504]^sbits[7] |
         ecchmatrix[6][504]^sbits[6] |
         ecchmatrix[5][504]^sbits[5] |
         ecchmatrix[4][504]^sbits[4] |
         ecchmatrix[3][504]^sbits[3] |
         ecchmatrix[2][504]^sbits[2] |
         ecchmatrix[1][504]^sbits[1] |
         ecchmatrix[0][504]^sbits[0]);
  assign biterr_wire[503] = ~(
         ecchmatrix[9][503]^sbits[9] |
         ecchmatrix[8][503]^sbits[8] |
         ecchmatrix[7][503]^sbits[7] |
         ecchmatrix[6][503]^sbits[6] |
         ecchmatrix[5][503]^sbits[5] |
         ecchmatrix[4][503]^sbits[4] |
         ecchmatrix[3][503]^sbits[3] |
         ecchmatrix[2][503]^sbits[2] |
         ecchmatrix[1][503]^sbits[1] |
         ecchmatrix[0][503]^sbits[0]);
  assign biterr_wire[502] = ~(
         ecchmatrix[9][502]^sbits[9] |
         ecchmatrix[8][502]^sbits[8] |
         ecchmatrix[7][502]^sbits[7] |
         ecchmatrix[6][502]^sbits[6] |
         ecchmatrix[5][502]^sbits[5] |
         ecchmatrix[4][502]^sbits[4] |
         ecchmatrix[3][502]^sbits[3] |
         ecchmatrix[2][502]^sbits[2] |
         ecchmatrix[1][502]^sbits[1] |
         ecchmatrix[0][502]^sbits[0]);
  assign biterr_wire[501] = ~(
         ecchmatrix[9][501]^sbits[9] |
         ecchmatrix[8][501]^sbits[8] |
         ecchmatrix[7][501]^sbits[7] |
         ecchmatrix[6][501]^sbits[6] |
         ecchmatrix[5][501]^sbits[5] |
         ecchmatrix[4][501]^sbits[4] |
         ecchmatrix[3][501]^sbits[3] |
         ecchmatrix[2][501]^sbits[2] |
         ecchmatrix[1][501]^sbits[1] |
         ecchmatrix[0][501]^sbits[0]);
  assign biterr_wire[500] = ~(
         ecchmatrix[9][500]^sbits[9] |
         ecchmatrix[8][500]^sbits[8] |
         ecchmatrix[7][500]^sbits[7] |
         ecchmatrix[6][500]^sbits[6] |
         ecchmatrix[5][500]^sbits[5] |
         ecchmatrix[4][500]^sbits[4] |
         ecchmatrix[3][500]^sbits[3] |
         ecchmatrix[2][500]^sbits[2] |
         ecchmatrix[1][500]^sbits[1] |
         ecchmatrix[0][500]^sbits[0]);
  assign biterr_wire[499] = ~(
         ecchmatrix[9][499]^sbits[9] |
         ecchmatrix[8][499]^sbits[8] |
         ecchmatrix[7][499]^sbits[7] |
         ecchmatrix[6][499]^sbits[6] |
         ecchmatrix[5][499]^sbits[5] |
         ecchmatrix[4][499]^sbits[4] |
         ecchmatrix[3][499]^sbits[3] |
         ecchmatrix[2][499]^sbits[2] |
         ecchmatrix[1][499]^sbits[1] |
         ecchmatrix[0][499]^sbits[0]);
  assign biterr_wire[498] = ~(
         ecchmatrix[9][498]^sbits[9] |
         ecchmatrix[8][498]^sbits[8] |
         ecchmatrix[7][498]^sbits[7] |
         ecchmatrix[6][498]^sbits[6] |
         ecchmatrix[5][498]^sbits[5] |
         ecchmatrix[4][498]^sbits[4] |
         ecchmatrix[3][498]^sbits[3] |
         ecchmatrix[2][498]^sbits[2] |
         ecchmatrix[1][498]^sbits[1] |
         ecchmatrix[0][498]^sbits[0]);
  assign biterr_wire[497] = ~(
         ecchmatrix[9][497]^sbits[9] |
         ecchmatrix[8][497]^sbits[8] |
         ecchmatrix[7][497]^sbits[7] |
         ecchmatrix[6][497]^sbits[6] |
         ecchmatrix[5][497]^sbits[5] |
         ecchmatrix[4][497]^sbits[4] |
         ecchmatrix[3][497]^sbits[3] |
         ecchmatrix[2][497]^sbits[2] |
         ecchmatrix[1][497]^sbits[1] |
         ecchmatrix[0][497]^sbits[0]);
  assign biterr_wire[496] = ~(
         ecchmatrix[9][496]^sbits[9] |
         ecchmatrix[8][496]^sbits[8] |
         ecchmatrix[7][496]^sbits[7] |
         ecchmatrix[6][496]^sbits[6] |
         ecchmatrix[5][496]^sbits[5] |
         ecchmatrix[4][496]^sbits[4] |
         ecchmatrix[3][496]^sbits[3] |
         ecchmatrix[2][496]^sbits[2] |
         ecchmatrix[1][496]^sbits[1] |
         ecchmatrix[0][496]^sbits[0]);
  assign biterr_wire[495] = ~(
         ecchmatrix[9][495]^sbits[9] |
         ecchmatrix[8][495]^sbits[8] |
         ecchmatrix[7][495]^sbits[7] |
         ecchmatrix[6][495]^sbits[6] |
         ecchmatrix[5][495]^sbits[5] |
         ecchmatrix[4][495]^sbits[4] |
         ecchmatrix[3][495]^sbits[3] |
         ecchmatrix[2][495]^sbits[2] |
         ecchmatrix[1][495]^sbits[1] |
         ecchmatrix[0][495]^sbits[0]);
  assign biterr_wire[494] = ~(
         ecchmatrix[9][494]^sbits[9] |
         ecchmatrix[8][494]^sbits[8] |
         ecchmatrix[7][494]^sbits[7] |
         ecchmatrix[6][494]^sbits[6] |
         ecchmatrix[5][494]^sbits[5] |
         ecchmatrix[4][494]^sbits[4] |
         ecchmatrix[3][494]^sbits[3] |
         ecchmatrix[2][494]^sbits[2] |
         ecchmatrix[1][494]^sbits[1] |
         ecchmatrix[0][494]^sbits[0]);
  assign biterr_wire[493] = ~(
         ecchmatrix[9][493]^sbits[9] |
         ecchmatrix[8][493]^sbits[8] |
         ecchmatrix[7][493]^sbits[7] |
         ecchmatrix[6][493]^sbits[6] |
         ecchmatrix[5][493]^sbits[5] |
         ecchmatrix[4][493]^sbits[4] |
         ecchmatrix[3][493]^sbits[3] |
         ecchmatrix[2][493]^sbits[2] |
         ecchmatrix[1][493]^sbits[1] |
         ecchmatrix[0][493]^sbits[0]);
  assign biterr_wire[492] = ~(
         ecchmatrix[9][492]^sbits[9] |
         ecchmatrix[8][492]^sbits[8] |
         ecchmatrix[7][492]^sbits[7] |
         ecchmatrix[6][492]^sbits[6] |
         ecchmatrix[5][492]^sbits[5] |
         ecchmatrix[4][492]^sbits[4] |
         ecchmatrix[3][492]^sbits[3] |
         ecchmatrix[2][492]^sbits[2] |
         ecchmatrix[1][492]^sbits[1] |
         ecchmatrix[0][492]^sbits[0]);
  assign biterr_wire[491] = ~(
         ecchmatrix[9][491]^sbits[9] |
         ecchmatrix[8][491]^sbits[8] |
         ecchmatrix[7][491]^sbits[7] |
         ecchmatrix[6][491]^sbits[6] |
         ecchmatrix[5][491]^sbits[5] |
         ecchmatrix[4][491]^sbits[4] |
         ecchmatrix[3][491]^sbits[3] |
         ecchmatrix[2][491]^sbits[2] |
         ecchmatrix[1][491]^sbits[1] |
         ecchmatrix[0][491]^sbits[0]);
  assign biterr_wire[490] = ~(
         ecchmatrix[9][490]^sbits[9] |
         ecchmatrix[8][490]^sbits[8] |
         ecchmatrix[7][490]^sbits[7] |
         ecchmatrix[6][490]^sbits[6] |
         ecchmatrix[5][490]^sbits[5] |
         ecchmatrix[4][490]^sbits[4] |
         ecchmatrix[3][490]^sbits[3] |
         ecchmatrix[2][490]^sbits[2] |
         ecchmatrix[1][490]^sbits[1] |
         ecchmatrix[0][490]^sbits[0]);
  assign biterr_wire[489] = ~(
         ecchmatrix[9][489]^sbits[9] |
         ecchmatrix[8][489]^sbits[8] |
         ecchmatrix[7][489]^sbits[7] |
         ecchmatrix[6][489]^sbits[6] |
         ecchmatrix[5][489]^sbits[5] |
         ecchmatrix[4][489]^sbits[4] |
         ecchmatrix[3][489]^sbits[3] |
         ecchmatrix[2][489]^sbits[2] |
         ecchmatrix[1][489]^sbits[1] |
         ecchmatrix[0][489]^sbits[0]);
  assign biterr_wire[488] = ~(
         ecchmatrix[9][488]^sbits[9] |
         ecchmatrix[8][488]^sbits[8] |
         ecchmatrix[7][488]^sbits[7] |
         ecchmatrix[6][488]^sbits[6] |
         ecchmatrix[5][488]^sbits[5] |
         ecchmatrix[4][488]^sbits[4] |
         ecchmatrix[3][488]^sbits[3] |
         ecchmatrix[2][488]^sbits[2] |
         ecchmatrix[1][488]^sbits[1] |
         ecchmatrix[0][488]^sbits[0]);
  assign biterr_wire[487] = ~(
         ecchmatrix[9][487]^sbits[9] |
         ecchmatrix[8][487]^sbits[8] |
         ecchmatrix[7][487]^sbits[7] |
         ecchmatrix[6][487]^sbits[6] |
         ecchmatrix[5][487]^sbits[5] |
         ecchmatrix[4][487]^sbits[4] |
         ecchmatrix[3][487]^sbits[3] |
         ecchmatrix[2][487]^sbits[2] |
         ecchmatrix[1][487]^sbits[1] |
         ecchmatrix[0][487]^sbits[0]);
  assign biterr_wire[486] = ~(
         ecchmatrix[9][486]^sbits[9] |
         ecchmatrix[8][486]^sbits[8] |
         ecchmatrix[7][486]^sbits[7] |
         ecchmatrix[6][486]^sbits[6] |
         ecchmatrix[5][486]^sbits[5] |
         ecchmatrix[4][486]^sbits[4] |
         ecchmatrix[3][486]^sbits[3] |
         ecchmatrix[2][486]^sbits[2] |
         ecchmatrix[1][486]^sbits[1] |
         ecchmatrix[0][486]^sbits[0]);
  assign biterr_wire[485] = ~(
         ecchmatrix[9][485]^sbits[9] |
         ecchmatrix[8][485]^sbits[8] |
         ecchmatrix[7][485]^sbits[7] |
         ecchmatrix[6][485]^sbits[6] |
         ecchmatrix[5][485]^sbits[5] |
         ecchmatrix[4][485]^sbits[4] |
         ecchmatrix[3][485]^sbits[3] |
         ecchmatrix[2][485]^sbits[2] |
         ecchmatrix[1][485]^sbits[1] |
         ecchmatrix[0][485]^sbits[0]);
  assign biterr_wire[484] = ~(
         ecchmatrix[9][484]^sbits[9] |
         ecchmatrix[8][484]^sbits[8] |
         ecchmatrix[7][484]^sbits[7] |
         ecchmatrix[6][484]^sbits[6] |
         ecchmatrix[5][484]^sbits[5] |
         ecchmatrix[4][484]^sbits[4] |
         ecchmatrix[3][484]^sbits[3] |
         ecchmatrix[2][484]^sbits[2] |
         ecchmatrix[1][484]^sbits[1] |
         ecchmatrix[0][484]^sbits[0]);
  assign biterr_wire[483] = ~(
         ecchmatrix[9][483]^sbits[9] |
         ecchmatrix[8][483]^sbits[8] |
         ecchmatrix[7][483]^sbits[7] |
         ecchmatrix[6][483]^sbits[6] |
         ecchmatrix[5][483]^sbits[5] |
         ecchmatrix[4][483]^sbits[4] |
         ecchmatrix[3][483]^sbits[3] |
         ecchmatrix[2][483]^sbits[2] |
         ecchmatrix[1][483]^sbits[1] |
         ecchmatrix[0][483]^sbits[0]);
  assign biterr_wire[482] = ~(
         ecchmatrix[9][482]^sbits[9] |
         ecchmatrix[8][482]^sbits[8] |
         ecchmatrix[7][482]^sbits[7] |
         ecchmatrix[6][482]^sbits[6] |
         ecchmatrix[5][482]^sbits[5] |
         ecchmatrix[4][482]^sbits[4] |
         ecchmatrix[3][482]^sbits[3] |
         ecchmatrix[2][482]^sbits[2] |
         ecchmatrix[1][482]^sbits[1] |
         ecchmatrix[0][482]^sbits[0]);
  assign biterr_wire[481] = ~(
         ecchmatrix[9][481]^sbits[9] |
         ecchmatrix[8][481]^sbits[8] |
         ecchmatrix[7][481]^sbits[7] |
         ecchmatrix[6][481]^sbits[6] |
         ecchmatrix[5][481]^sbits[5] |
         ecchmatrix[4][481]^sbits[4] |
         ecchmatrix[3][481]^sbits[3] |
         ecchmatrix[2][481]^sbits[2] |
         ecchmatrix[1][481]^sbits[1] |
         ecchmatrix[0][481]^sbits[0]);
  assign biterr_wire[480] = ~(
         ecchmatrix[9][480]^sbits[9] |
         ecchmatrix[8][480]^sbits[8] |
         ecchmatrix[7][480]^sbits[7] |
         ecchmatrix[6][480]^sbits[6] |
         ecchmatrix[5][480]^sbits[5] |
         ecchmatrix[4][480]^sbits[4] |
         ecchmatrix[3][480]^sbits[3] |
         ecchmatrix[2][480]^sbits[2] |
         ecchmatrix[1][480]^sbits[1] |
         ecchmatrix[0][480]^sbits[0]);
  assign biterr_wire[479] = ~(
         ecchmatrix[9][479]^sbits[9] |
         ecchmatrix[8][479]^sbits[8] |
         ecchmatrix[7][479]^sbits[7] |
         ecchmatrix[6][479]^sbits[6] |
         ecchmatrix[5][479]^sbits[5] |
         ecchmatrix[4][479]^sbits[4] |
         ecchmatrix[3][479]^sbits[3] |
         ecchmatrix[2][479]^sbits[2] |
         ecchmatrix[1][479]^sbits[1] |
         ecchmatrix[0][479]^sbits[0]);
  assign biterr_wire[478] = ~(
         ecchmatrix[9][478]^sbits[9] |
         ecchmatrix[8][478]^sbits[8] |
         ecchmatrix[7][478]^sbits[7] |
         ecchmatrix[6][478]^sbits[6] |
         ecchmatrix[5][478]^sbits[5] |
         ecchmatrix[4][478]^sbits[4] |
         ecchmatrix[3][478]^sbits[3] |
         ecchmatrix[2][478]^sbits[2] |
         ecchmatrix[1][478]^sbits[1] |
         ecchmatrix[0][478]^sbits[0]);
  assign biterr_wire[477] = ~(
         ecchmatrix[9][477]^sbits[9] |
         ecchmatrix[8][477]^sbits[8] |
         ecchmatrix[7][477]^sbits[7] |
         ecchmatrix[6][477]^sbits[6] |
         ecchmatrix[5][477]^sbits[5] |
         ecchmatrix[4][477]^sbits[4] |
         ecchmatrix[3][477]^sbits[3] |
         ecchmatrix[2][477]^sbits[2] |
         ecchmatrix[1][477]^sbits[1] |
         ecchmatrix[0][477]^sbits[0]);
  assign biterr_wire[476] = ~(
         ecchmatrix[9][476]^sbits[9] |
         ecchmatrix[8][476]^sbits[8] |
         ecchmatrix[7][476]^sbits[7] |
         ecchmatrix[6][476]^sbits[6] |
         ecchmatrix[5][476]^sbits[5] |
         ecchmatrix[4][476]^sbits[4] |
         ecchmatrix[3][476]^sbits[3] |
         ecchmatrix[2][476]^sbits[2] |
         ecchmatrix[1][476]^sbits[1] |
         ecchmatrix[0][476]^sbits[0]);
  assign biterr_wire[475] = ~(
         ecchmatrix[9][475]^sbits[9] |
         ecchmatrix[8][475]^sbits[8] |
         ecchmatrix[7][475]^sbits[7] |
         ecchmatrix[6][475]^sbits[6] |
         ecchmatrix[5][475]^sbits[5] |
         ecchmatrix[4][475]^sbits[4] |
         ecchmatrix[3][475]^sbits[3] |
         ecchmatrix[2][475]^sbits[2] |
         ecchmatrix[1][475]^sbits[1] |
         ecchmatrix[0][475]^sbits[0]);
  assign biterr_wire[474] = ~(
         ecchmatrix[9][474]^sbits[9] |
         ecchmatrix[8][474]^sbits[8] |
         ecchmatrix[7][474]^sbits[7] |
         ecchmatrix[6][474]^sbits[6] |
         ecchmatrix[5][474]^sbits[5] |
         ecchmatrix[4][474]^sbits[4] |
         ecchmatrix[3][474]^sbits[3] |
         ecchmatrix[2][474]^sbits[2] |
         ecchmatrix[1][474]^sbits[1] |
         ecchmatrix[0][474]^sbits[0]);
  assign biterr_wire[473] = ~(
         ecchmatrix[9][473]^sbits[9] |
         ecchmatrix[8][473]^sbits[8] |
         ecchmatrix[7][473]^sbits[7] |
         ecchmatrix[6][473]^sbits[6] |
         ecchmatrix[5][473]^sbits[5] |
         ecchmatrix[4][473]^sbits[4] |
         ecchmatrix[3][473]^sbits[3] |
         ecchmatrix[2][473]^sbits[2] |
         ecchmatrix[1][473]^sbits[1] |
         ecchmatrix[0][473]^sbits[0]);
  assign biterr_wire[472] = ~(
         ecchmatrix[9][472]^sbits[9] |
         ecchmatrix[8][472]^sbits[8] |
         ecchmatrix[7][472]^sbits[7] |
         ecchmatrix[6][472]^sbits[6] |
         ecchmatrix[5][472]^sbits[5] |
         ecchmatrix[4][472]^sbits[4] |
         ecchmatrix[3][472]^sbits[3] |
         ecchmatrix[2][472]^sbits[2] |
         ecchmatrix[1][472]^sbits[1] |
         ecchmatrix[0][472]^sbits[0]);
  assign biterr_wire[471] = ~(
         ecchmatrix[9][471]^sbits[9] |
         ecchmatrix[8][471]^sbits[8] |
         ecchmatrix[7][471]^sbits[7] |
         ecchmatrix[6][471]^sbits[6] |
         ecchmatrix[5][471]^sbits[5] |
         ecchmatrix[4][471]^sbits[4] |
         ecchmatrix[3][471]^sbits[3] |
         ecchmatrix[2][471]^sbits[2] |
         ecchmatrix[1][471]^sbits[1] |
         ecchmatrix[0][471]^sbits[0]);
  assign biterr_wire[470] = ~(
         ecchmatrix[9][470]^sbits[9] |
         ecchmatrix[8][470]^sbits[8] |
         ecchmatrix[7][470]^sbits[7] |
         ecchmatrix[6][470]^sbits[6] |
         ecchmatrix[5][470]^sbits[5] |
         ecchmatrix[4][470]^sbits[4] |
         ecchmatrix[3][470]^sbits[3] |
         ecchmatrix[2][470]^sbits[2] |
         ecchmatrix[1][470]^sbits[1] |
         ecchmatrix[0][470]^sbits[0]);
  assign biterr_wire[469] = ~(
         ecchmatrix[9][469]^sbits[9] |
         ecchmatrix[8][469]^sbits[8] |
         ecchmatrix[7][469]^sbits[7] |
         ecchmatrix[6][469]^sbits[6] |
         ecchmatrix[5][469]^sbits[5] |
         ecchmatrix[4][469]^sbits[4] |
         ecchmatrix[3][469]^sbits[3] |
         ecchmatrix[2][469]^sbits[2] |
         ecchmatrix[1][469]^sbits[1] |
         ecchmatrix[0][469]^sbits[0]);
  assign biterr_wire[468] = ~(
         ecchmatrix[9][468]^sbits[9] |
         ecchmatrix[8][468]^sbits[8] |
         ecchmatrix[7][468]^sbits[7] |
         ecchmatrix[6][468]^sbits[6] |
         ecchmatrix[5][468]^sbits[5] |
         ecchmatrix[4][468]^sbits[4] |
         ecchmatrix[3][468]^sbits[3] |
         ecchmatrix[2][468]^sbits[2] |
         ecchmatrix[1][468]^sbits[1] |
         ecchmatrix[0][468]^sbits[0]);
  assign biterr_wire[467] = ~(
         ecchmatrix[9][467]^sbits[9] |
         ecchmatrix[8][467]^sbits[8] |
         ecchmatrix[7][467]^sbits[7] |
         ecchmatrix[6][467]^sbits[6] |
         ecchmatrix[5][467]^sbits[5] |
         ecchmatrix[4][467]^sbits[4] |
         ecchmatrix[3][467]^sbits[3] |
         ecchmatrix[2][467]^sbits[2] |
         ecchmatrix[1][467]^sbits[1] |
         ecchmatrix[0][467]^sbits[0]);
  assign biterr_wire[466] = ~(
         ecchmatrix[9][466]^sbits[9] |
         ecchmatrix[8][466]^sbits[8] |
         ecchmatrix[7][466]^sbits[7] |
         ecchmatrix[6][466]^sbits[6] |
         ecchmatrix[5][466]^sbits[5] |
         ecchmatrix[4][466]^sbits[4] |
         ecchmatrix[3][466]^sbits[3] |
         ecchmatrix[2][466]^sbits[2] |
         ecchmatrix[1][466]^sbits[1] |
         ecchmatrix[0][466]^sbits[0]);
  assign biterr_wire[465] = ~(
         ecchmatrix[9][465]^sbits[9] |
         ecchmatrix[8][465]^sbits[8] |
         ecchmatrix[7][465]^sbits[7] |
         ecchmatrix[6][465]^sbits[6] |
         ecchmatrix[5][465]^sbits[5] |
         ecchmatrix[4][465]^sbits[4] |
         ecchmatrix[3][465]^sbits[3] |
         ecchmatrix[2][465]^sbits[2] |
         ecchmatrix[1][465]^sbits[1] |
         ecchmatrix[0][465]^sbits[0]);
  assign biterr_wire[464] = ~(
         ecchmatrix[9][464]^sbits[9] |
         ecchmatrix[8][464]^sbits[8] |
         ecchmatrix[7][464]^sbits[7] |
         ecchmatrix[6][464]^sbits[6] |
         ecchmatrix[5][464]^sbits[5] |
         ecchmatrix[4][464]^sbits[4] |
         ecchmatrix[3][464]^sbits[3] |
         ecchmatrix[2][464]^sbits[2] |
         ecchmatrix[1][464]^sbits[1] |
         ecchmatrix[0][464]^sbits[0]);
  assign biterr_wire[463] = ~(
         ecchmatrix[9][463]^sbits[9] |
         ecchmatrix[8][463]^sbits[8] |
         ecchmatrix[7][463]^sbits[7] |
         ecchmatrix[6][463]^sbits[6] |
         ecchmatrix[5][463]^sbits[5] |
         ecchmatrix[4][463]^sbits[4] |
         ecchmatrix[3][463]^sbits[3] |
         ecchmatrix[2][463]^sbits[2] |
         ecchmatrix[1][463]^sbits[1] |
         ecchmatrix[0][463]^sbits[0]);
  assign biterr_wire[462] = ~(
         ecchmatrix[9][462]^sbits[9] |
         ecchmatrix[8][462]^sbits[8] |
         ecchmatrix[7][462]^sbits[7] |
         ecchmatrix[6][462]^sbits[6] |
         ecchmatrix[5][462]^sbits[5] |
         ecchmatrix[4][462]^sbits[4] |
         ecchmatrix[3][462]^sbits[3] |
         ecchmatrix[2][462]^sbits[2] |
         ecchmatrix[1][462]^sbits[1] |
         ecchmatrix[0][462]^sbits[0]);
  assign biterr_wire[461] = ~(
         ecchmatrix[9][461]^sbits[9] |
         ecchmatrix[8][461]^sbits[8] |
         ecchmatrix[7][461]^sbits[7] |
         ecchmatrix[6][461]^sbits[6] |
         ecchmatrix[5][461]^sbits[5] |
         ecchmatrix[4][461]^sbits[4] |
         ecchmatrix[3][461]^sbits[3] |
         ecchmatrix[2][461]^sbits[2] |
         ecchmatrix[1][461]^sbits[1] |
         ecchmatrix[0][461]^sbits[0]);
  assign biterr_wire[460] = ~(
         ecchmatrix[9][460]^sbits[9] |
         ecchmatrix[8][460]^sbits[8] |
         ecchmatrix[7][460]^sbits[7] |
         ecchmatrix[6][460]^sbits[6] |
         ecchmatrix[5][460]^sbits[5] |
         ecchmatrix[4][460]^sbits[4] |
         ecchmatrix[3][460]^sbits[3] |
         ecchmatrix[2][460]^sbits[2] |
         ecchmatrix[1][460]^sbits[1] |
         ecchmatrix[0][460]^sbits[0]);
  assign biterr_wire[459] = ~(
         ecchmatrix[9][459]^sbits[9] |
         ecchmatrix[8][459]^sbits[8] |
         ecchmatrix[7][459]^sbits[7] |
         ecchmatrix[6][459]^sbits[6] |
         ecchmatrix[5][459]^sbits[5] |
         ecchmatrix[4][459]^sbits[4] |
         ecchmatrix[3][459]^sbits[3] |
         ecchmatrix[2][459]^sbits[2] |
         ecchmatrix[1][459]^sbits[1] |
         ecchmatrix[0][459]^sbits[0]);
  assign biterr_wire[458] = ~(
         ecchmatrix[9][458]^sbits[9] |
         ecchmatrix[8][458]^sbits[8] |
         ecchmatrix[7][458]^sbits[7] |
         ecchmatrix[6][458]^sbits[6] |
         ecchmatrix[5][458]^sbits[5] |
         ecchmatrix[4][458]^sbits[4] |
         ecchmatrix[3][458]^sbits[3] |
         ecchmatrix[2][458]^sbits[2] |
         ecchmatrix[1][458]^sbits[1] |
         ecchmatrix[0][458]^sbits[0]);
  assign biterr_wire[457] = ~(
         ecchmatrix[9][457]^sbits[9] |
         ecchmatrix[8][457]^sbits[8] |
         ecchmatrix[7][457]^sbits[7] |
         ecchmatrix[6][457]^sbits[6] |
         ecchmatrix[5][457]^sbits[5] |
         ecchmatrix[4][457]^sbits[4] |
         ecchmatrix[3][457]^sbits[3] |
         ecchmatrix[2][457]^sbits[2] |
         ecchmatrix[1][457]^sbits[1] |
         ecchmatrix[0][457]^sbits[0]);
  assign biterr_wire[456] = ~(
         ecchmatrix[9][456]^sbits[9] |
         ecchmatrix[8][456]^sbits[8] |
         ecchmatrix[7][456]^sbits[7] |
         ecchmatrix[6][456]^sbits[6] |
         ecchmatrix[5][456]^sbits[5] |
         ecchmatrix[4][456]^sbits[4] |
         ecchmatrix[3][456]^sbits[3] |
         ecchmatrix[2][456]^sbits[2] |
         ecchmatrix[1][456]^sbits[1] |
         ecchmatrix[0][456]^sbits[0]);
  assign biterr_wire[455] = ~(
         ecchmatrix[9][455]^sbits[9] |
         ecchmatrix[8][455]^sbits[8] |
         ecchmatrix[7][455]^sbits[7] |
         ecchmatrix[6][455]^sbits[6] |
         ecchmatrix[5][455]^sbits[5] |
         ecchmatrix[4][455]^sbits[4] |
         ecchmatrix[3][455]^sbits[3] |
         ecchmatrix[2][455]^sbits[2] |
         ecchmatrix[1][455]^sbits[1] |
         ecchmatrix[0][455]^sbits[0]);
  assign biterr_wire[454] = ~(
         ecchmatrix[9][454]^sbits[9] |
         ecchmatrix[8][454]^sbits[8] |
         ecchmatrix[7][454]^sbits[7] |
         ecchmatrix[6][454]^sbits[6] |
         ecchmatrix[5][454]^sbits[5] |
         ecchmatrix[4][454]^sbits[4] |
         ecchmatrix[3][454]^sbits[3] |
         ecchmatrix[2][454]^sbits[2] |
         ecchmatrix[1][454]^sbits[1] |
         ecchmatrix[0][454]^sbits[0]);
  assign biterr_wire[453] = ~(
         ecchmatrix[9][453]^sbits[9] |
         ecchmatrix[8][453]^sbits[8] |
         ecchmatrix[7][453]^sbits[7] |
         ecchmatrix[6][453]^sbits[6] |
         ecchmatrix[5][453]^sbits[5] |
         ecchmatrix[4][453]^sbits[4] |
         ecchmatrix[3][453]^sbits[3] |
         ecchmatrix[2][453]^sbits[2] |
         ecchmatrix[1][453]^sbits[1] |
         ecchmatrix[0][453]^sbits[0]);
  assign biterr_wire[452] = ~(
         ecchmatrix[9][452]^sbits[9] |
         ecchmatrix[8][452]^sbits[8] |
         ecchmatrix[7][452]^sbits[7] |
         ecchmatrix[6][452]^sbits[6] |
         ecchmatrix[5][452]^sbits[5] |
         ecchmatrix[4][452]^sbits[4] |
         ecchmatrix[3][452]^sbits[3] |
         ecchmatrix[2][452]^sbits[2] |
         ecchmatrix[1][452]^sbits[1] |
         ecchmatrix[0][452]^sbits[0]);
  assign biterr_wire[451] = ~(
         ecchmatrix[9][451]^sbits[9] |
         ecchmatrix[8][451]^sbits[8] |
         ecchmatrix[7][451]^sbits[7] |
         ecchmatrix[6][451]^sbits[6] |
         ecchmatrix[5][451]^sbits[5] |
         ecchmatrix[4][451]^sbits[4] |
         ecchmatrix[3][451]^sbits[3] |
         ecchmatrix[2][451]^sbits[2] |
         ecchmatrix[1][451]^sbits[1] |
         ecchmatrix[0][451]^sbits[0]);
  assign biterr_wire[450] = ~(
         ecchmatrix[9][450]^sbits[9] |
         ecchmatrix[8][450]^sbits[8] |
         ecchmatrix[7][450]^sbits[7] |
         ecchmatrix[6][450]^sbits[6] |
         ecchmatrix[5][450]^sbits[5] |
         ecchmatrix[4][450]^sbits[4] |
         ecchmatrix[3][450]^sbits[3] |
         ecchmatrix[2][450]^sbits[2] |
         ecchmatrix[1][450]^sbits[1] |
         ecchmatrix[0][450]^sbits[0]);
  assign biterr_wire[449] = ~(
         ecchmatrix[9][449]^sbits[9] |
         ecchmatrix[8][449]^sbits[8] |
         ecchmatrix[7][449]^sbits[7] |
         ecchmatrix[6][449]^sbits[6] |
         ecchmatrix[5][449]^sbits[5] |
         ecchmatrix[4][449]^sbits[4] |
         ecchmatrix[3][449]^sbits[3] |
         ecchmatrix[2][449]^sbits[2] |
         ecchmatrix[1][449]^sbits[1] |
         ecchmatrix[0][449]^sbits[0]);
  assign biterr_wire[448] = ~(
         ecchmatrix[9][448]^sbits[9] |
         ecchmatrix[8][448]^sbits[8] |
         ecchmatrix[7][448]^sbits[7] |
         ecchmatrix[6][448]^sbits[6] |
         ecchmatrix[5][448]^sbits[5] |
         ecchmatrix[4][448]^sbits[4] |
         ecchmatrix[3][448]^sbits[3] |
         ecchmatrix[2][448]^sbits[2] |
         ecchmatrix[1][448]^sbits[1] |
         ecchmatrix[0][448]^sbits[0]);
  assign biterr_wire[447] = ~(
         ecchmatrix[9][447]^sbits[9] |
         ecchmatrix[8][447]^sbits[8] |
         ecchmatrix[7][447]^sbits[7] |
         ecchmatrix[6][447]^sbits[6] |
         ecchmatrix[5][447]^sbits[5] |
         ecchmatrix[4][447]^sbits[4] |
         ecchmatrix[3][447]^sbits[3] |
         ecchmatrix[2][447]^sbits[2] |
         ecchmatrix[1][447]^sbits[1] |
         ecchmatrix[0][447]^sbits[0]);
  assign biterr_wire[446] = ~(
         ecchmatrix[9][446]^sbits[9] |
         ecchmatrix[8][446]^sbits[8] |
         ecchmatrix[7][446]^sbits[7] |
         ecchmatrix[6][446]^sbits[6] |
         ecchmatrix[5][446]^sbits[5] |
         ecchmatrix[4][446]^sbits[4] |
         ecchmatrix[3][446]^sbits[3] |
         ecchmatrix[2][446]^sbits[2] |
         ecchmatrix[1][446]^sbits[1] |
         ecchmatrix[0][446]^sbits[0]);
  assign biterr_wire[445] = ~(
         ecchmatrix[9][445]^sbits[9] |
         ecchmatrix[8][445]^sbits[8] |
         ecchmatrix[7][445]^sbits[7] |
         ecchmatrix[6][445]^sbits[6] |
         ecchmatrix[5][445]^sbits[5] |
         ecchmatrix[4][445]^sbits[4] |
         ecchmatrix[3][445]^sbits[3] |
         ecchmatrix[2][445]^sbits[2] |
         ecchmatrix[1][445]^sbits[1] |
         ecchmatrix[0][445]^sbits[0]);
  assign biterr_wire[444] = ~(
         ecchmatrix[9][444]^sbits[9] |
         ecchmatrix[8][444]^sbits[8] |
         ecchmatrix[7][444]^sbits[7] |
         ecchmatrix[6][444]^sbits[6] |
         ecchmatrix[5][444]^sbits[5] |
         ecchmatrix[4][444]^sbits[4] |
         ecchmatrix[3][444]^sbits[3] |
         ecchmatrix[2][444]^sbits[2] |
         ecchmatrix[1][444]^sbits[1] |
         ecchmatrix[0][444]^sbits[0]);
  assign biterr_wire[443] = ~(
         ecchmatrix[9][443]^sbits[9] |
         ecchmatrix[8][443]^sbits[8] |
         ecchmatrix[7][443]^sbits[7] |
         ecchmatrix[6][443]^sbits[6] |
         ecchmatrix[5][443]^sbits[5] |
         ecchmatrix[4][443]^sbits[4] |
         ecchmatrix[3][443]^sbits[3] |
         ecchmatrix[2][443]^sbits[2] |
         ecchmatrix[1][443]^sbits[1] |
         ecchmatrix[0][443]^sbits[0]);
  assign biterr_wire[442] = ~(
         ecchmatrix[9][442]^sbits[9] |
         ecchmatrix[8][442]^sbits[8] |
         ecchmatrix[7][442]^sbits[7] |
         ecchmatrix[6][442]^sbits[6] |
         ecchmatrix[5][442]^sbits[5] |
         ecchmatrix[4][442]^sbits[4] |
         ecchmatrix[3][442]^sbits[3] |
         ecchmatrix[2][442]^sbits[2] |
         ecchmatrix[1][442]^sbits[1] |
         ecchmatrix[0][442]^sbits[0]);
  assign biterr_wire[441] = ~(
         ecchmatrix[9][441]^sbits[9] |
         ecchmatrix[8][441]^sbits[8] |
         ecchmatrix[7][441]^sbits[7] |
         ecchmatrix[6][441]^sbits[6] |
         ecchmatrix[5][441]^sbits[5] |
         ecchmatrix[4][441]^sbits[4] |
         ecchmatrix[3][441]^sbits[3] |
         ecchmatrix[2][441]^sbits[2] |
         ecchmatrix[1][441]^sbits[1] |
         ecchmatrix[0][441]^sbits[0]);
  assign biterr_wire[440] = ~(
         ecchmatrix[9][440]^sbits[9] |
         ecchmatrix[8][440]^sbits[8] |
         ecchmatrix[7][440]^sbits[7] |
         ecchmatrix[6][440]^sbits[6] |
         ecchmatrix[5][440]^sbits[5] |
         ecchmatrix[4][440]^sbits[4] |
         ecchmatrix[3][440]^sbits[3] |
         ecchmatrix[2][440]^sbits[2] |
         ecchmatrix[1][440]^sbits[1] |
         ecchmatrix[0][440]^sbits[0]);
  assign biterr_wire[439] = ~(
         ecchmatrix[9][439]^sbits[9] |
         ecchmatrix[8][439]^sbits[8] |
         ecchmatrix[7][439]^sbits[7] |
         ecchmatrix[6][439]^sbits[6] |
         ecchmatrix[5][439]^sbits[5] |
         ecchmatrix[4][439]^sbits[4] |
         ecchmatrix[3][439]^sbits[3] |
         ecchmatrix[2][439]^sbits[2] |
         ecchmatrix[1][439]^sbits[1] |
         ecchmatrix[0][439]^sbits[0]);
  assign biterr_wire[438] = ~(
         ecchmatrix[9][438]^sbits[9] |
         ecchmatrix[8][438]^sbits[8] |
         ecchmatrix[7][438]^sbits[7] |
         ecchmatrix[6][438]^sbits[6] |
         ecchmatrix[5][438]^sbits[5] |
         ecchmatrix[4][438]^sbits[4] |
         ecchmatrix[3][438]^sbits[3] |
         ecchmatrix[2][438]^sbits[2] |
         ecchmatrix[1][438]^sbits[1] |
         ecchmatrix[0][438]^sbits[0]);
  assign biterr_wire[437] = ~(
         ecchmatrix[9][437]^sbits[9] |
         ecchmatrix[8][437]^sbits[8] |
         ecchmatrix[7][437]^sbits[7] |
         ecchmatrix[6][437]^sbits[6] |
         ecchmatrix[5][437]^sbits[5] |
         ecchmatrix[4][437]^sbits[4] |
         ecchmatrix[3][437]^sbits[3] |
         ecchmatrix[2][437]^sbits[2] |
         ecchmatrix[1][437]^sbits[1] |
         ecchmatrix[0][437]^sbits[0]);
  assign biterr_wire[436] = ~(
         ecchmatrix[9][436]^sbits[9] |
         ecchmatrix[8][436]^sbits[8] |
         ecchmatrix[7][436]^sbits[7] |
         ecchmatrix[6][436]^sbits[6] |
         ecchmatrix[5][436]^sbits[5] |
         ecchmatrix[4][436]^sbits[4] |
         ecchmatrix[3][436]^sbits[3] |
         ecchmatrix[2][436]^sbits[2] |
         ecchmatrix[1][436]^sbits[1] |
         ecchmatrix[0][436]^sbits[0]);
  assign biterr_wire[435] = ~(
         ecchmatrix[9][435]^sbits[9] |
         ecchmatrix[8][435]^sbits[8] |
         ecchmatrix[7][435]^sbits[7] |
         ecchmatrix[6][435]^sbits[6] |
         ecchmatrix[5][435]^sbits[5] |
         ecchmatrix[4][435]^sbits[4] |
         ecchmatrix[3][435]^sbits[3] |
         ecchmatrix[2][435]^sbits[2] |
         ecchmatrix[1][435]^sbits[1] |
         ecchmatrix[0][435]^sbits[0]);
  assign biterr_wire[434] = ~(
         ecchmatrix[9][434]^sbits[9] |
         ecchmatrix[8][434]^sbits[8] |
         ecchmatrix[7][434]^sbits[7] |
         ecchmatrix[6][434]^sbits[6] |
         ecchmatrix[5][434]^sbits[5] |
         ecchmatrix[4][434]^sbits[4] |
         ecchmatrix[3][434]^sbits[3] |
         ecchmatrix[2][434]^sbits[2] |
         ecchmatrix[1][434]^sbits[1] |
         ecchmatrix[0][434]^sbits[0]);
  assign biterr_wire[433] = ~(
         ecchmatrix[9][433]^sbits[9] |
         ecchmatrix[8][433]^sbits[8] |
         ecchmatrix[7][433]^sbits[7] |
         ecchmatrix[6][433]^sbits[6] |
         ecchmatrix[5][433]^sbits[5] |
         ecchmatrix[4][433]^sbits[4] |
         ecchmatrix[3][433]^sbits[3] |
         ecchmatrix[2][433]^sbits[2] |
         ecchmatrix[1][433]^sbits[1] |
         ecchmatrix[0][433]^sbits[0]);
  assign biterr_wire[432] = ~(
         ecchmatrix[9][432]^sbits[9] |
         ecchmatrix[8][432]^sbits[8] |
         ecchmatrix[7][432]^sbits[7] |
         ecchmatrix[6][432]^sbits[6] |
         ecchmatrix[5][432]^sbits[5] |
         ecchmatrix[4][432]^sbits[4] |
         ecchmatrix[3][432]^sbits[3] |
         ecchmatrix[2][432]^sbits[2] |
         ecchmatrix[1][432]^sbits[1] |
         ecchmatrix[0][432]^sbits[0]);
  assign biterr_wire[431] = ~(
         ecchmatrix[9][431]^sbits[9] |
         ecchmatrix[8][431]^sbits[8] |
         ecchmatrix[7][431]^sbits[7] |
         ecchmatrix[6][431]^sbits[6] |
         ecchmatrix[5][431]^sbits[5] |
         ecchmatrix[4][431]^sbits[4] |
         ecchmatrix[3][431]^sbits[3] |
         ecchmatrix[2][431]^sbits[2] |
         ecchmatrix[1][431]^sbits[1] |
         ecchmatrix[0][431]^sbits[0]);
  assign biterr_wire[430] = ~(
         ecchmatrix[9][430]^sbits[9] |
         ecchmatrix[8][430]^sbits[8] |
         ecchmatrix[7][430]^sbits[7] |
         ecchmatrix[6][430]^sbits[6] |
         ecchmatrix[5][430]^sbits[5] |
         ecchmatrix[4][430]^sbits[4] |
         ecchmatrix[3][430]^sbits[3] |
         ecchmatrix[2][430]^sbits[2] |
         ecchmatrix[1][430]^sbits[1] |
         ecchmatrix[0][430]^sbits[0]);
  assign biterr_wire[429] = ~(
         ecchmatrix[9][429]^sbits[9] |
         ecchmatrix[8][429]^sbits[8] |
         ecchmatrix[7][429]^sbits[7] |
         ecchmatrix[6][429]^sbits[6] |
         ecchmatrix[5][429]^sbits[5] |
         ecchmatrix[4][429]^sbits[4] |
         ecchmatrix[3][429]^sbits[3] |
         ecchmatrix[2][429]^sbits[2] |
         ecchmatrix[1][429]^sbits[1] |
         ecchmatrix[0][429]^sbits[0]);
  assign biterr_wire[428] = ~(
         ecchmatrix[9][428]^sbits[9] |
         ecchmatrix[8][428]^sbits[8] |
         ecchmatrix[7][428]^sbits[7] |
         ecchmatrix[6][428]^sbits[6] |
         ecchmatrix[5][428]^sbits[5] |
         ecchmatrix[4][428]^sbits[4] |
         ecchmatrix[3][428]^sbits[3] |
         ecchmatrix[2][428]^sbits[2] |
         ecchmatrix[1][428]^sbits[1] |
         ecchmatrix[0][428]^sbits[0]);
  assign biterr_wire[427] = ~(
         ecchmatrix[9][427]^sbits[9] |
         ecchmatrix[8][427]^sbits[8] |
         ecchmatrix[7][427]^sbits[7] |
         ecchmatrix[6][427]^sbits[6] |
         ecchmatrix[5][427]^sbits[5] |
         ecchmatrix[4][427]^sbits[4] |
         ecchmatrix[3][427]^sbits[3] |
         ecchmatrix[2][427]^sbits[2] |
         ecchmatrix[1][427]^sbits[1] |
         ecchmatrix[0][427]^sbits[0]);
  assign biterr_wire[426] = ~(
         ecchmatrix[9][426]^sbits[9] |
         ecchmatrix[8][426]^sbits[8] |
         ecchmatrix[7][426]^sbits[7] |
         ecchmatrix[6][426]^sbits[6] |
         ecchmatrix[5][426]^sbits[5] |
         ecchmatrix[4][426]^sbits[4] |
         ecchmatrix[3][426]^sbits[3] |
         ecchmatrix[2][426]^sbits[2] |
         ecchmatrix[1][426]^sbits[1] |
         ecchmatrix[0][426]^sbits[0]);
  assign biterr_wire[425] = ~(
         ecchmatrix[9][425]^sbits[9] |
         ecchmatrix[8][425]^sbits[8] |
         ecchmatrix[7][425]^sbits[7] |
         ecchmatrix[6][425]^sbits[6] |
         ecchmatrix[5][425]^sbits[5] |
         ecchmatrix[4][425]^sbits[4] |
         ecchmatrix[3][425]^sbits[3] |
         ecchmatrix[2][425]^sbits[2] |
         ecchmatrix[1][425]^sbits[1] |
         ecchmatrix[0][425]^sbits[0]);
  assign biterr_wire[424] = ~(
         ecchmatrix[9][424]^sbits[9] |
         ecchmatrix[8][424]^sbits[8] |
         ecchmatrix[7][424]^sbits[7] |
         ecchmatrix[6][424]^sbits[6] |
         ecchmatrix[5][424]^sbits[5] |
         ecchmatrix[4][424]^sbits[4] |
         ecchmatrix[3][424]^sbits[3] |
         ecchmatrix[2][424]^sbits[2] |
         ecchmatrix[1][424]^sbits[1] |
         ecchmatrix[0][424]^sbits[0]);
  assign biterr_wire[423] = ~(
         ecchmatrix[9][423]^sbits[9] |
         ecchmatrix[8][423]^sbits[8] |
         ecchmatrix[7][423]^sbits[7] |
         ecchmatrix[6][423]^sbits[6] |
         ecchmatrix[5][423]^sbits[5] |
         ecchmatrix[4][423]^sbits[4] |
         ecchmatrix[3][423]^sbits[3] |
         ecchmatrix[2][423]^sbits[2] |
         ecchmatrix[1][423]^sbits[1] |
         ecchmatrix[0][423]^sbits[0]);
  assign biterr_wire[422] = ~(
         ecchmatrix[9][422]^sbits[9] |
         ecchmatrix[8][422]^sbits[8] |
         ecchmatrix[7][422]^sbits[7] |
         ecchmatrix[6][422]^sbits[6] |
         ecchmatrix[5][422]^sbits[5] |
         ecchmatrix[4][422]^sbits[4] |
         ecchmatrix[3][422]^sbits[3] |
         ecchmatrix[2][422]^sbits[2] |
         ecchmatrix[1][422]^sbits[1] |
         ecchmatrix[0][422]^sbits[0]);
  assign biterr_wire[421] = ~(
         ecchmatrix[9][421]^sbits[9] |
         ecchmatrix[8][421]^sbits[8] |
         ecchmatrix[7][421]^sbits[7] |
         ecchmatrix[6][421]^sbits[6] |
         ecchmatrix[5][421]^sbits[5] |
         ecchmatrix[4][421]^sbits[4] |
         ecchmatrix[3][421]^sbits[3] |
         ecchmatrix[2][421]^sbits[2] |
         ecchmatrix[1][421]^sbits[1] |
         ecchmatrix[0][421]^sbits[0]);
  assign biterr_wire[420] = ~(
         ecchmatrix[9][420]^sbits[9] |
         ecchmatrix[8][420]^sbits[8] |
         ecchmatrix[7][420]^sbits[7] |
         ecchmatrix[6][420]^sbits[6] |
         ecchmatrix[5][420]^sbits[5] |
         ecchmatrix[4][420]^sbits[4] |
         ecchmatrix[3][420]^sbits[3] |
         ecchmatrix[2][420]^sbits[2] |
         ecchmatrix[1][420]^sbits[1] |
         ecchmatrix[0][420]^sbits[0]);
  assign biterr_wire[419] = ~(
         ecchmatrix[9][419]^sbits[9] |
         ecchmatrix[8][419]^sbits[8] |
         ecchmatrix[7][419]^sbits[7] |
         ecchmatrix[6][419]^sbits[6] |
         ecchmatrix[5][419]^sbits[5] |
         ecchmatrix[4][419]^sbits[4] |
         ecchmatrix[3][419]^sbits[3] |
         ecchmatrix[2][419]^sbits[2] |
         ecchmatrix[1][419]^sbits[1] |
         ecchmatrix[0][419]^sbits[0]);
  assign biterr_wire[418] = ~(
         ecchmatrix[9][418]^sbits[9] |
         ecchmatrix[8][418]^sbits[8] |
         ecchmatrix[7][418]^sbits[7] |
         ecchmatrix[6][418]^sbits[6] |
         ecchmatrix[5][418]^sbits[5] |
         ecchmatrix[4][418]^sbits[4] |
         ecchmatrix[3][418]^sbits[3] |
         ecchmatrix[2][418]^sbits[2] |
         ecchmatrix[1][418]^sbits[1] |
         ecchmatrix[0][418]^sbits[0]);
  assign biterr_wire[417] = ~(
         ecchmatrix[9][417]^sbits[9] |
         ecchmatrix[8][417]^sbits[8] |
         ecchmatrix[7][417]^sbits[7] |
         ecchmatrix[6][417]^sbits[6] |
         ecchmatrix[5][417]^sbits[5] |
         ecchmatrix[4][417]^sbits[4] |
         ecchmatrix[3][417]^sbits[3] |
         ecchmatrix[2][417]^sbits[2] |
         ecchmatrix[1][417]^sbits[1] |
         ecchmatrix[0][417]^sbits[0]);
  assign biterr_wire[416] = ~(
         ecchmatrix[9][416]^sbits[9] |
         ecchmatrix[8][416]^sbits[8] |
         ecchmatrix[7][416]^sbits[7] |
         ecchmatrix[6][416]^sbits[6] |
         ecchmatrix[5][416]^sbits[5] |
         ecchmatrix[4][416]^sbits[4] |
         ecchmatrix[3][416]^sbits[3] |
         ecchmatrix[2][416]^sbits[2] |
         ecchmatrix[1][416]^sbits[1] |
         ecchmatrix[0][416]^sbits[0]);
  assign biterr_wire[415] = ~(
         ecchmatrix[9][415]^sbits[9] |
         ecchmatrix[8][415]^sbits[8] |
         ecchmatrix[7][415]^sbits[7] |
         ecchmatrix[6][415]^sbits[6] |
         ecchmatrix[5][415]^sbits[5] |
         ecchmatrix[4][415]^sbits[4] |
         ecchmatrix[3][415]^sbits[3] |
         ecchmatrix[2][415]^sbits[2] |
         ecchmatrix[1][415]^sbits[1] |
         ecchmatrix[0][415]^sbits[0]);
  assign biterr_wire[414] = ~(
         ecchmatrix[9][414]^sbits[9] |
         ecchmatrix[8][414]^sbits[8] |
         ecchmatrix[7][414]^sbits[7] |
         ecchmatrix[6][414]^sbits[6] |
         ecchmatrix[5][414]^sbits[5] |
         ecchmatrix[4][414]^sbits[4] |
         ecchmatrix[3][414]^sbits[3] |
         ecchmatrix[2][414]^sbits[2] |
         ecchmatrix[1][414]^sbits[1] |
         ecchmatrix[0][414]^sbits[0]);
  assign biterr_wire[413] = ~(
         ecchmatrix[9][413]^sbits[9] |
         ecchmatrix[8][413]^sbits[8] |
         ecchmatrix[7][413]^sbits[7] |
         ecchmatrix[6][413]^sbits[6] |
         ecchmatrix[5][413]^sbits[5] |
         ecchmatrix[4][413]^sbits[4] |
         ecchmatrix[3][413]^sbits[3] |
         ecchmatrix[2][413]^sbits[2] |
         ecchmatrix[1][413]^sbits[1] |
         ecchmatrix[0][413]^sbits[0]);
  assign biterr_wire[412] = ~(
         ecchmatrix[9][412]^sbits[9] |
         ecchmatrix[8][412]^sbits[8] |
         ecchmatrix[7][412]^sbits[7] |
         ecchmatrix[6][412]^sbits[6] |
         ecchmatrix[5][412]^sbits[5] |
         ecchmatrix[4][412]^sbits[4] |
         ecchmatrix[3][412]^sbits[3] |
         ecchmatrix[2][412]^sbits[2] |
         ecchmatrix[1][412]^sbits[1] |
         ecchmatrix[0][412]^sbits[0]);
  assign biterr_wire[411] = ~(
         ecchmatrix[9][411]^sbits[9] |
         ecchmatrix[8][411]^sbits[8] |
         ecchmatrix[7][411]^sbits[7] |
         ecchmatrix[6][411]^sbits[6] |
         ecchmatrix[5][411]^sbits[5] |
         ecchmatrix[4][411]^sbits[4] |
         ecchmatrix[3][411]^sbits[3] |
         ecchmatrix[2][411]^sbits[2] |
         ecchmatrix[1][411]^sbits[1] |
         ecchmatrix[0][411]^sbits[0]);
  assign biterr_wire[410] = ~(
         ecchmatrix[9][410]^sbits[9] |
         ecchmatrix[8][410]^sbits[8] |
         ecchmatrix[7][410]^sbits[7] |
         ecchmatrix[6][410]^sbits[6] |
         ecchmatrix[5][410]^sbits[5] |
         ecchmatrix[4][410]^sbits[4] |
         ecchmatrix[3][410]^sbits[3] |
         ecchmatrix[2][410]^sbits[2] |
         ecchmatrix[1][410]^sbits[1] |
         ecchmatrix[0][410]^sbits[0]);
  assign biterr_wire[409] = ~(
         ecchmatrix[9][409]^sbits[9] |
         ecchmatrix[8][409]^sbits[8] |
         ecchmatrix[7][409]^sbits[7] |
         ecchmatrix[6][409]^sbits[6] |
         ecchmatrix[5][409]^sbits[5] |
         ecchmatrix[4][409]^sbits[4] |
         ecchmatrix[3][409]^sbits[3] |
         ecchmatrix[2][409]^sbits[2] |
         ecchmatrix[1][409]^sbits[1] |
         ecchmatrix[0][409]^sbits[0]);
  assign biterr_wire[408] = ~(
         ecchmatrix[9][408]^sbits[9] |
         ecchmatrix[8][408]^sbits[8] |
         ecchmatrix[7][408]^sbits[7] |
         ecchmatrix[6][408]^sbits[6] |
         ecchmatrix[5][408]^sbits[5] |
         ecchmatrix[4][408]^sbits[4] |
         ecchmatrix[3][408]^sbits[3] |
         ecchmatrix[2][408]^sbits[2] |
         ecchmatrix[1][408]^sbits[1] |
         ecchmatrix[0][408]^sbits[0]);
  assign biterr_wire[407] = ~(
         ecchmatrix[9][407]^sbits[9] |
         ecchmatrix[8][407]^sbits[8] |
         ecchmatrix[7][407]^sbits[7] |
         ecchmatrix[6][407]^sbits[6] |
         ecchmatrix[5][407]^sbits[5] |
         ecchmatrix[4][407]^sbits[4] |
         ecchmatrix[3][407]^sbits[3] |
         ecchmatrix[2][407]^sbits[2] |
         ecchmatrix[1][407]^sbits[1] |
         ecchmatrix[0][407]^sbits[0]);
  assign biterr_wire[406] = ~(
         ecchmatrix[9][406]^sbits[9] |
         ecchmatrix[8][406]^sbits[8] |
         ecchmatrix[7][406]^sbits[7] |
         ecchmatrix[6][406]^sbits[6] |
         ecchmatrix[5][406]^sbits[5] |
         ecchmatrix[4][406]^sbits[4] |
         ecchmatrix[3][406]^sbits[3] |
         ecchmatrix[2][406]^sbits[2] |
         ecchmatrix[1][406]^sbits[1] |
         ecchmatrix[0][406]^sbits[0]);
  assign biterr_wire[405] = ~(
         ecchmatrix[9][405]^sbits[9] |
         ecchmatrix[8][405]^sbits[8] |
         ecchmatrix[7][405]^sbits[7] |
         ecchmatrix[6][405]^sbits[6] |
         ecchmatrix[5][405]^sbits[5] |
         ecchmatrix[4][405]^sbits[4] |
         ecchmatrix[3][405]^sbits[3] |
         ecchmatrix[2][405]^sbits[2] |
         ecchmatrix[1][405]^sbits[1] |
         ecchmatrix[0][405]^sbits[0]);
  assign biterr_wire[404] = ~(
         ecchmatrix[9][404]^sbits[9] |
         ecchmatrix[8][404]^sbits[8] |
         ecchmatrix[7][404]^sbits[7] |
         ecchmatrix[6][404]^sbits[6] |
         ecchmatrix[5][404]^sbits[5] |
         ecchmatrix[4][404]^sbits[4] |
         ecchmatrix[3][404]^sbits[3] |
         ecchmatrix[2][404]^sbits[2] |
         ecchmatrix[1][404]^sbits[1] |
         ecchmatrix[0][404]^sbits[0]);
  assign biterr_wire[403] = ~(
         ecchmatrix[9][403]^sbits[9] |
         ecchmatrix[8][403]^sbits[8] |
         ecchmatrix[7][403]^sbits[7] |
         ecchmatrix[6][403]^sbits[6] |
         ecchmatrix[5][403]^sbits[5] |
         ecchmatrix[4][403]^sbits[4] |
         ecchmatrix[3][403]^sbits[3] |
         ecchmatrix[2][403]^sbits[2] |
         ecchmatrix[1][403]^sbits[1] |
         ecchmatrix[0][403]^sbits[0]);
  assign biterr_wire[402] = ~(
         ecchmatrix[9][402]^sbits[9] |
         ecchmatrix[8][402]^sbits[8] |
         ecchmatrix[7][402]^sbits[7] |
         ecchmatrix[6][402]^sbits[6] |
         ecchmatrix[5][402]^sbits[5] |
         ecchmatrix[4][402]^sbits[4] |
         ecchmatrix[3][402]^sbits[3] |
         ecchmatrix[2][402]^sbits[2] |
         ecchmatrix[1][402]^sbits[1] |
         ecchmatrix[0][402]^sbits[0]);
  assign biterr_wire[401] = ~(
         ecchmatrix[9][401]^sbits[9] |
         ecchmatrix[8][401]^sbits[8] |
         ecchmatrix[7][401]^sbits[7] |
         ecchmatrix[6][401]^sbits[6] |
         ecchmatrix[5][401]^sbits[5] |
         ecchmatrix[4][401]^sbits[4] |
         ecchmatrix[3][401]^sbits[3] |
         ecchmatrix[2][401]^sbits[2] |
         ecchmatrix[1][401]^sbits[1] |
         ecchmatrix[0][401]^sbits[0]);
  assign biterr_wire[400] = ~(
         ecchmatrix[9][400]^sbits[9] |
         ecchmatrix[8][400]^sbits[8] |
         ecchmatrix[7][400]^sbits[7] |
         ecchmatrix[6][400]^sbits[6] |
         ecchmatrix[5][400]^sbits[5] |
         ecchmatrix[4][400]^sbits[4] |
         ecchmatrix[3][400]^sbits[3] |
         ecchmatrix[2][400]^sbits[2] |
         ecchmatrix[1][400]^sbits[1] |
         ecchmatrix[0][400]^sbits[0]);
  assign biterr_wire[399] = ~(
         ecchmatrix[9][399]^sbits[9] |
         ecchmatrix[8][399]^sbits[8] |
         ecchmatrix[7][399]^sbits[7] |
         ecchmatrix[6][399]^sbits[6] |
         ecchmatrix[5][399]^sbits[5] |
         ecchmatrix[4][399]^sbits[4] |
         ecchmatrix[3][399]^sbits[3] |
         ecchmatrix[2][399]^sbits[2] |
         ecchmatrix[1][399]^sbits[1] |
         ecchmatrix[0][399]^sbits[0]);
  assign biterr_wire[398] = ~(
         ecchmatrix[9][398]^sbits[9] |
         ecchmatrix[8][398]^sbits[8] |
         ecchmatrix[7][398]^sbits[7] |
         ecchmatrix[6][398]^sbits[6] |
         ecchmatrix[5][398]^sbits[5] |
         ecchmatrix[4][398]^sbits[4] |
         ecchmatrix[3][398]^sbits[3] |
         ecchmatrix[2][398]^sbits[2] |
         ecchmatrix[1][398]^sbits[1] |
         ecchmatrix[0][398]^sbits[0]);
  assign biterr_wire[397] = ~(
         ecchmatrix[9][397]^sbits[9] |
         ecchmatrix[8][397]^sbits[8] |
         ecchmatrix[7][397]^sbits[7] |
         ecchmatrix[6][397]^sbits[6] |
         ecchmatrix[5][397]^sbits[5] |
         ecchmatrix[4][397]^sbits[4] |
         ecchmatrix[3][397]^sbits[3] |
         ecchmatrix[2][397]^sbits[2] |
         ecchmatrix[1][397]^sbits[1] |
         ecchmatrix[0][397]^sbits[0]);
  assign biterr_wire[396] = ~(
         ecchmatrix[9][396]^sbits[9] |
         ecchmatrix[8][396]^sbits[8] |
         ecchmatrix[7][396]^sbits[7] |
         ecchmatrix[6][396]^sbits[6] |
         ecchmatrix[5][396]^sbits[5] |
         ecchmatrix[4][396]^sbits[4] |
         ecchmatrix[3][396]^sbits[3] |
         ecchmatrix[2][396]^sbits[2] |
         ecchmatrix[1][396]^sbits[1] |
         ecchmatrix[0][396]^sbits[0]);
  assign biterr_wire[395] = ~(
         ecchmatrix[9][395]^sbits[9] |
         ecchmatrix[8][395]^sbits[8] |
         ecchmatrix[7][395]^sbits[7] |
         ecchmatrix[6][395]^sbits[6] |
         ecchmatrix[5][395]^sbits[5] |
         ecchmatrix[4][395]^sbits[4] |
         ecchmatrix[3][395]^sbits[3] |
         ecchmatrix[2][395]^sbits[2] |
         ecchmatrix[1][395]^sbits[1] |
         ecchmatrix[0][395]^sbits[0]);
  assign biterr_wire[394] = ~(
         ecchmatrix[9][394]^sbits[9] |
         ecchmatrix[8][394]^sbits[8] |
         ecchmatrix[7][394]^sbits[7] |
         ecchmatrix[6][394]^sbits[6] |
         ecchmatrix[5][394]^sbits[5] |
         ecchmatrix[4][394]^sbits[4] |
         ecchmatrix[3][394]^sbits[3] |
         ecchmatrix[2][394]^sbits[2] |
         ecchmatrix[1][394]^sbits[1] |
         ecchmatrix[0][394]^sbits[0]);
  assign biterr_wire[393] = ~(
         ecchmatrix[9][393]^sbits[9] |
         ecchmatrix[8][393]^sbits[8] |
         ecchmatrix[7][393]^sbits[7] |
         ecchmatrix[6][393]^sbits[6] |
         ecchmatrix[5][393]^sbits[5] |
         ecchmatrix[4][393]^sbits[4] |
         ecchmatrix[3][393]^sbits[3] |
         ecchmatrix[2][393]^sbits[2] |
         ecchmatrix[1][393]^sbits[1] |
         ecchmatrix[0][393]^sbits[0]);
  assign biterr_wire[392] = ~(
         ecchmatrix[9][392]^sbits[9] |
         ecchmatrix[8][392]^sbits[8] |
         ecchmatrix[7][392]^sbits[7] |
         ecchmatrix[6][392]^sbits[6] |
         ecchmatrix[5][392]^sbits[5] |
         ecchmatrix[4][392]^sbits[4] |
         ecchmatrix[3][392]^sbits[3] |
         ecchmatrix[2][392]^sbits[2] |
         ecchmatrix[1][392]^sbits[1] |
         ecchmatrix[0][392]^sbits[0]);
  assign biterr_wire[391] = ~(
         ecchmatrix[9][391]^sbits[9] |
         ecchmatrix[8][391]^sbits[8] |
         ecchmatrix[7][391]^sbits[7] |
         ecchmatrix[6][391]^sbits[6] |
         ecchmatrix[5][391]^sbits[5] |
         ecchmatrix[4][391]^sbits[4] |
         ecchmatrix[3][391]^sbits[3] |
         ecchmatrix[2][391]^sbits[2] |
         ecchmatrix[1][391]^sbits[1] |
         ecchmatrix[0][391]^sbits[0]);
  assign biterr_wire[390] = ~(
         ecchmatrix[9][390]^sbits[9] |
         ecchmatrix[8][390]^sbits[8] |
         ecchmatrix[7][390]^sbits[7] |
         ecchmatrix[6][390]^sbits[6] |
         ecchmatrix[5][390]^sbits[5] |
         ecchmatrix[4][390]^sbits[4] |
         ecchmatrix[3][390]^sbits[3] |
         ecchmatrix[2][390]^sbits[2] |
         ecchmatrix[1][390]^sbits[1] |
         ecchmatrix[0][390]^sbits[0]);
  assign biterr_wire[389] = ~(
         ecchmatrix[9][389]^sbits[9] |
         ecchmatrix[8][389]^sbits[8] |
         ecchmatrix[7][389]^sbits[7] |
         ecchmatrix[6][389]^sbits[6] |
         ecchmatrix[5][389]^sbits[5] |
         ecchmatrix[4][389]^sbits[4] |
         ecchmatrix[3][389]^sbits[3] |
         ecchmatrix[2][389]^sbits[2] |
         ecchmatrix[1][389]^sbits[1] |
         ecchmatrix[0][389]^sbits[0]);
  assign biterr_wire[388] = ~(
         ecchmatrix[9][388]^sbits[9] |
         ecchmatrix[8][388]^sbits[8] |
         ecchmatrix[7][388]^sbits[7] |
         ecchmatrix[6][388]^sbits[6] |
         ecchmatrix[5][388]^sbits[5] |
         ecchmatrix[4][388]^sbits[4] |
         ecchmatrix[3][388]^sbits[3] |
         ecchmatrix[2][388]^sbits[2] |
         ecchmatrix[1][388]^sbits[1] |
         ecchmatrix[0][388]^sbits[0]);
  assign biterr_wire[387] = ~(
         ecchmatrix[9][387]^sbits[9] |
         ecchmatrix[8][387]^sbits[8] |
         ecchmatrix[7][387]^sbits[7] |
         ecchmatrix[6][387]^sbits[6] |
         ecchmatrix[5][387]^sbits[5] |
         ecchmatrix[4][387]^sbits[4] |
         ecchmatrix[3][387]^sbits[3] |
         ecchmatrix[2][387]^sbits[2] |
         ecchmatrix[1][387]^sbits[1] |
         ecchmatrix[0][387]^sbits[0]);
  assign biterr_wire[386] = ~(
         ecchmatrix[9][386]^sbits[9] |
         ecchmatrix[8][386]^sbits[8] |
         ecchmatrix[7][386]^sbits[7] |
         ecchmatrix[6][386]^sbits[6] |
         ecchmatrix[5][386]^sbits[5] |
         ecchmatrix[4][386]^sbits[4] |
         ecchmatrix[3][386]^sbits[3] |
         ecchmatrix[2][386]^sbits[2] |
         ecchmatrix[1][386]^sbits[1] |
         ecchmatrix[0][386]^sbits[0]);
  assign biterr_wire[385] = ~(
         ecchmatrix[9][385]^sbits[9] |
         ecchmatrix[8][385]^sbits[8] |
         ecchmatrix[7][385]^sbits[7] |
         ecchmatrix[6][385]^sbits[6] |
         ecchmatrix[5][385]^sbits[5] |
         ecchmatrix[4][385]^sbits[4] |
         ecchmatrix[3][385]^sbits[3] |
         ecchmatrix[2][385]^sbits[2] |
         ecchmatrix[1][385]^sbits[1] |
         ecchmatrix[0][385]^sbits[0]);
  assign biterr_wire[384] = ~(
         ecchmatrix[9][384]^sbits[9] |
         ecchmatrix[8][384]^sbits[8] |
         ecchmatrix[7][384]^sbits[7] |
         ecchmatrix[6][384]^sbits[6] |
         ecchmatrix[5][384]^sbits[5] |
         ecchmatrix[4][384]^sbits[4] |
         ecchmatrix[3][384]^sbits[3] |
         ecchmatrix[2][384]^sbits[2] |
         ecchmatrix[1][384]^sbits[1] |
         ecchmatrix[0][384]^sbits[0]);
  assign biterr_wire[383] = ~(
         ecchmatrix[9][383]^sbits[9] |
         ecchmatrix[8][383]^sbits[8] |
         ecchmatrix[7][383]^sbits[7] |
         ecchmatrix[6][383]^sbits[6] |
         ecchmatrix[5][383]^sbits[5] |
         ecchmatrix[4][383]^sbits[4] |
         ecchmatrix[3][383]^sbits[3] |
         ecchmatrix[2][383]^sbits[2] |
         ecchmatrix[1][383]^sbits[1] |
         ecchmatrix[0][383]^sbits[0]);
  assign biterr_wire[382] = ~(
         ecchmatrix[9][382]^sbits[9] |
         ecchmatrix[8][382]^sbits[8] |
         ecchmatrix[7][382]^sbits[7] |
         ecchmatrix[6][382]^sbits[6] |
         ecchmatrix[5][382]^sbits[5] |
         ecchmatrix[4][382]^sbits[4] |
         ecchmatrix[3][382]^sbits[3] |
         ecchmatrix[2][382]^sbits[2] |
         ecchmatrix[1][382]^sbits[1] |
         ecchmatrix[0][382]^sbits[0]);
  assign biterr_wire[381] = ~(
         ecchmatrix[9][381]^sbits[9] |
         ecchmatrix[8][381]^sbits[8] |
         ecchmatrix[7][381]^sbits[7] |
         ecchmatrix[6][381]^sbits[6] |
         ecchmatrix[5][381]^sbits[5] |
         ecchmatrix[4][381]^sbits[4] |
         ecchmatrix[3][381]^sbits[3] |
         ecchmatrix[2][381]^sbits[2] |
         ecchmatrix[1][381]^sbits[1] |
         ecchmatrix[0][381]^sbits[0]);
  assign biterr_wire[380] = ~(
         ecchmatrix[9][380]^sbits[9] |
         ecchmatrix[8][380]^sbits[8] |
         ecchmatrix[7][380]^sbits[7] |
         ecchmatrix[6][380]^sbits[6] |
         ecchmatrix[5][380]^sbits[5] |
         ecchmatrix[4][380]^sbits[4] |
         ecchmatrix[3][380]^sbits[3] |
         ecchmatrix[2][380]^sbits[2] |
         ecchmatrix[1][380]^sbits[1] |
         ecchmatrix[0][380]^sbits[0]);
  assign biterr_wire[379] = ~(
         ecchmatrix[9][379]^sbits[9] |
         ecchmatrix[8][379]^sbits[8] |
         ecchmatrix[7][379]^sbits[7] |
         ecchmatrix[6][379]^sbits[6] |
         ecchmatrix[5][379]^sbits[5] |
         ecchmatrix[4][379]^sbits[4] |
         ecchmatrix[3][379]^sbits[3] |
         ecchmatrix[2][379]^sbits[2] |
         ecchmatrix[1][379]^sbits[1] |
         ecchmatrix[0][379]^sbits[0]);
  assign biterr_wire[378] = ~(
         ecchmatrix[9][378]^sbits[9] |
         ecchmatrix[8][378]^sbits[8] |
         ecchmatrix[7][378]^sbits[7] |
         ecchmatrix[6][378]^sbits[6] |
         ecchmatrix[5][378]^sbits[5] |
         ecchmatrix[4][378]^sbits[4] |
         ecchmatrix[3][378]^sbits[3] |
         ecchmatrix[2][378]^sbits[2] |
         ecchmatrix[1][378]^sbits[1] |
         ecchmatrix[0][378]^sbits[0]);
  assign biterr_wire[377] = ~(
         ecchmatrix[9][377]^sbits[9] |
         ecchmatrix[8][377]^sbits[8] |
         ecchmatrix[7][377]^sbits[7] |
         ecchmatrix[6][377]^sbits[6] |
         ecchmatrix[5][377]^sbits[5] |
         ecchmatrix[4][377]^sbits[4] |
         ecchmatrix[3][377]^sbits[3] |
         ecchmatrix[2][377]^sbits[2] |
         ecchmatrix[1][377]^sbits[1] |
         ecchmatrix[0][377]^sbits[0]);
  assign biterr_wire[376] = ~(
         ecchmatrix[9][376]^sbits[9] |
         ecchmatrix[8][376]^sbits[8] |
         ecchmatrix[7][376]^sbits[7] |
         ecchmatrix[6][376]^sbits[6] |
         ecchmatrix[5][376]^sbits[5] |
         ecchmatrix[4][376]^sbits[4] |
         ecchmatrix[3][376]^sbits[3] |
         ecchmatrix[2][376]^sbits[2] |
         ecchmatrix[1][376]^sbits[1] |
         ecchmatrix[0][376]^sbits[0]);
  assign biterr_wire[375] = ~(
         ecchmatrix[9][375]^sbits[9] |
         ecchmatrix[8][375]^sbits[8] |
         ecchmatrix[7][375]^sbits[7] |
         ecchmatrix[6][375]^sbits[6] |
         ecchmatrix[5][375]^sbits[5] |
         ecchmatrix[4][375]^sbits[4] |
         ecchmatrix[3][375]^sbits[3] |
         ecchmatrix[2][375]^sbits[2] |
         ecchmatrix[1][375]^sbits[1] |
         ecchmatrix[0][375]^sbits[0]);
  assign biterr_wire[374] = ~(
         ecchmatrix[9][374]^sbits[9] |
         ecchmatrix[8][374]^sbits[8] |
         ecchmatrix[7][374]^sbits[7] |
         ecchmatrix[6][374]^sbits[6] |
         ecchmatrix[5][374]^sbits[5] |
         ecchmatrix[4][374]^sbits[4] |
         ecchmatrix[3][374]^sbits[3] |
         ecchmatrix[2][374]^sbits[2] |
         ecchmatrix[1][374]^sbits[1] |
         ecchmatrix[0][374]^sbits[0]);
  assign biterr_wire[373] = ~(
         ecchmatrix[9][373]^sbits[9] |
         ecchmatrix[8][373]^sbits[8] |
         ecchmatrix[7][373]^sbits[7] |
         ecchmatrix[6][373]^sbits[6] |
         ecchmatrix[5][373]^sbits[5] |
         ecchmatrix[4][373]^sbits[4] |
         ecchmatrix[3][373]^sbits[3] |
         ecchmatrix[2][373]^sbits[2] |
         ecchmatrix[1][373]^sbits[1] |
         ecchmatrix[0][373]^sbits[0]);
  assign biterr_wire[372] = ~(
         ecchmatrix[9][372]^sbits[9] |
         ecchmatrix[8][372]^sbits[8] |
         ecchmatrix[7][372]^sbits[7] |
         ecchmatrix[6][372]^sbits[6] |
         ecchmatrix[5][372]^sbits[5] |
         ecchmatrix[4][372]^sbits[4] |
         ecchmatrix[3][372]^sbits[3] |
         ecchmatrix[2][372]^sbits[2] |
         ecchmatrix[1][372]^sbits[1] |
         ecchmatrix[0][372]^sbits[0]);
  assign biterr_wire[371] = ~(
         ecchmatrix[9][371]^sbits[9] |
         ecchmatrix[8][371]^sbits[8] |
         ecchmatrix[7][371]^sbits[7] |
         ecchmatrix[6][371]^sbits[6] |
         ecchmatrix[5][371]^sbits[5] |
         ecchmatrix[4][371]^sbits[4] |
         ecchmatrix[3][371]^sbits[3] |
         ecchmatrix[2][371]^sbits[2] |
         ecchmatrix[1][371]^sbits[1] |
         ecchmatrix[0][371]^sbits[0]);
  assign biterr_wire[370] = ~(
         ecchmatrix[9][370]^sbits[9] |
         ecchmatrix[8][370]^sbits[8] |
         ecchmatrix[7][370]^sbits[7] |
         ecchmatrix[6][370]^sbits[6] |
         ecchmatrix[5][370]^sbits[5] |
         ecchmatrix[4][370]^sbits[4] |
         ecchmatrix[3][370]^sbits[3] |
         ecchmatrix[2][370]^sbits[2] |
         ecchmatrix[1][370]^sbits[1] |
         ecchmatrix[0][370]^sbits[0]);
  assign biterr_wire[369] = ~(
         ecchmatrix[9][369]^sbits[9] |
         ecchmatrix[8][369]^sbits[8] |
         ecchmatrix[7][369]^sbits[7] |
         ecchmatrix[6][369]^sbits[6] |
         ecchmatrix[5][369]^sbits[5] |
         ecchmatrix[4][369]^sbits[4] |
         ecchmatrix[3][369]^sbits[3] |
         ecchmatrix[2][369]^sbits[2] |
         ecchmatrix[1][369]^sbits[1] |
         ecchmatrix[0][369]^sbits[0]);
  assign biterr_wire[368] = ~(
         ecchmatrix[9][368]^sbits[9] |
         ecchmatrix[8][368]^sbits[8] |
         ecchmatrix[7][368]^sbits[7] |
         ecchmatrix[6][368]^sbits[6] |
         ecchmatrix[5][368]^sbits[5] |
         ecchmatrix[4][368]^sbits[4] |
         ecchmatrix[3][368]^sbits[3] |
         ecchmatrix[2][368]^sbits[2] |
         ecchmatrix[1][368]^sbits[1] |
         ecchmatrix[0][368]^sbits[0]);
  assign biterr_wire[367] = ~(
         ecchmatrix[9][367]^sbits[9] |
         ecchmatrix[8][367]^sbits[8] |
         ecchmatrix[7][367]^sbits[7] |
         ecchmatrix[6][367]^sbits[6] |
         ecchmatrix[5][367]^sbits[5] |
         ecchmatrix[4][367]^sbits[4] |
         ecchmatrix[3][367]^sbits[3] |
         ecchmatrix[2][367]^sbits[2] |
         ecchmatrix[1][367]^sbits[1] |
         ecchmatrix[0][367]^sbits[0]);
  assign biterr_wire[366] = ~(
         ecchmatrix[9][366]^sbits[9] |
         ecchmatrix[8][366]^sbits[8] |
         ecchmatrix[7][366]^sbits[7] |
         ecchmatrix[6][366]^sbits[6] |
         ecchmatrix[5][366]^sbits[5] |
         ecchmatrix[4][366]^sbits[4] |
         ecchmatrix[3][366]^sbits[3] |
         ecchmatrix[2][366]^sbits[2] |
         ecchmatrix[1][366]^sbits[1] |
         ecchmatrix[0][366]^sbits[0]);
  assign biterr_wire[365] = ~(
         ecchmatrix[9][365]^sbits[9] |
         ecchmatrix[8][365]^sbits[8] |
         ecchmatrix[7][365]^sbits[7] |
         ecchmatrix[6][365]^sbits[6] |
         ecchmatrix[5][365]^sbits[5] |
         ecchmatrix[4][365]^sbits[4] |
         ecchmatrix[3][365]^sbits[3] |
         ecchmatrix[2][365]^sbits[2] |
         ecchmatrix[1][365]^sbits[1] |
         ecchmatrix[0][365]^sbits[0]);
  assign biterr_wire[364] = ~(
         ecchmatrix[9][364]^sbits[9] |
         ecchmatrix[8][364]^sbits[8] |
         ecchmatrix[7][364]^sbits[7] |
         ecchmatrix[6][364]^sbits[6] |
         ecchmatrix[5][364]^sbits[5] |
         ecchmatrix[4][364]^sbits[4] |
         ecchmatrix[3][364]^sbits[3] |
         ecchmatrix[2][364]^sbits[2] |
         ecchmatrix[1][364]^sbits[1] |
         ecchmatrix[0][364]^sbits[0]);
  assign biterr_wire[363] = ~(
         ecchmatrix[9][363]^sbits[9] |
         ecchmatrix[8][363]^sbits[8] |
         ecchmatrix[7][363]^sbits[7] |
         ecchmatrix[6][363]^sbits[6] |
         ecchmatrix[5][363]^sbits[5] |
         ecchmatrix[4][363]^sbits[4] |
         ecchmatrix[3][363]^sbits[3] |
         ecchmatrix[2][363]^sbits[2] |
         ecchmatrix[1][363]^sbits[1] |
         ecchmatrix[0][363]^sbits[0]);
  assign biterr_wire[362] = ~(
         ecchmatrix[9][362]^sbits[9] |
         ecchmatrix[8][362]^sbits[8] |
         ecchmatrix[7][362]^sbits[7] |
         ecchmatrix[6][362]^sbits[6] |
         ecchmatrix[5][362]^sbits[5] |
         ecchmatrix[4][362]^sbits[4] |
         ecchmatrix[3][362]^sbits[3] |
         ecchmatrix[2][362]^sbits[2] |
         ecchmatrix[1][362]^sbits[1] |
         ecchmatrix[0][362]^sbits[0]);
  assign biterr_wire[361] = ~(
         ecchmatrix[9][361]^sbits[9] |
         ecchmatrix[8][361]^sbits[8] |
         ecchmatrix[7][361]^sbits[7] |
         ecchmatrix[6][361]^sbits[6] |
         ecchmatrix[5][361]^sbits[5] |
         ecchmatrix[4][361]^sbits[4] |
         ecchmatrix[3][361]^sbits[3] |
         ecchmatrix[2][361]^sbits[2] |
         ecchmatrix[1][361]^sbits[1] |
         ecchmatrix[0][361]^sbits[0]);
  assign biterr_wire[360] = ~(
         ecchmatrix[9][360]^sbits[9] |
         ecchmatrix[8][360]^sbits[8] |
         ecchmatrix[7][360]^sbits[7] |
         ecchmatrix[6][360]^sbits[6] |
         ecchmatrix[5][360]^sbits[5] |
         ecchmatrix[4][360]^sbits[4] |
         ecchmatrix[3][360]^sbits[3] |
         ecchmatrix[2][360]^sbits[2] |
         ecchmatrix[1][360]^sbits[1] |
         ecchmatrix[0][360]^sbits[0]);
  assign biterr_wire[359] = ~(
         ecchmatrix[9][359]^sbits[9] |
         ecchmatrix[8][359]^sbits[8] |
         ecchmatrix[7][359]^sbits[7] |
         ecchmatrix[6][359]^sbits[6] |
         ecchmatrix[5][359]^sbits[5] |
         ecchmatrix[4][359]^sbits[4] |
         ecchmatrix[3][359]^sbits[3] |
         ecchmatrix[2][359]^sbits[2] |
         ecchmatrix[1][359]^sbits[1] |
         ecchmatrix[0][359]^sbits[0]);
  assign biterr_wire[358] = ~(
         ecchmatrix[9][358]^sbits[9] |
         ecchmatrix[8][358]^sbits[8] |
         ecchmatrix[7][358]^sbits[7] |
         ecchmatrix[6][358]^sbits[6] |
         ecchmatrix[5][358]^sbits[5] |
         ecchmatrix[4][358]^sbits[4] |
         ecchmatrix[3][358]^sbits[3] |
         ecchmatrix[2][358]^sbits[2] |
         ecchmatrix[1][358]^sbits[1] |
         ecchmatrix[0][358]^sbits[0]);
  assign biterr_wire[357] = ~(
         ecchmatrix[9][357]^sbits[9] |
         ecchmatrix[8][357]^sbits[8] |
         ecchmatrix[7][357]^sbits[7] |
         ecchmatrix[6][357]^sbits[6] |
         ecchmatrix[5][357]^sbits[5] |
         ecchmatrix[4][357]^sbits[4] |
         ecchmatrix[3][357]^sbits[3] |
         ecchmatrix[2][357]^sbits[2] |
         ecchmatrix[1][357]^sbits[1] |
         ecchmatrix[0][357]^sbits[0]);
  assign biterr_wire[356] = ~(
         ecchmatrix[9][356]^sbits[9] |
         ecchmatrix[8][356]^sbits[8] |
         ecchmatrix[7][356]^sbits[7] |
         ecchmatrix[6][356]^sbits[6] |
         ecchmatrix[5][356]^sbits[5] |
         ecchmatrix[4][356]^sbits[4] |
         ecchmatrix[3][356]^sbits[3] |
         ecchmatrix[2][356]^sbits[2] |
         ecchmatrix[1][356]^sbits[1] |
         ecchmatrix[0][356]^sbits[0]);
  assign biterr_wire[355] = ~(
         ecchmatrix[9][355]^sbits[9] |
         ecchmatrix[8][355]^sbits[8] |
         ecchmatrix[7][355]^sbits[7] |
         ecchmatrix[6][355]^sbits[6] |
         ecchmatrix[5][355]^sbits[5] |
         ecchmatrix[4][355]^sbits[4] |
         ecchmatrix[3][355]^sbits[3] |
         ecchmatrix[2][355]^sbits[2] |
         ecchmatrix[1][355]^sbits[1] |
         ecchmatrix[0][355]^sbits[0]);
  assign biterr_wire[354] = ~(
         ecchmatrix[9][354]^sbits[9] |
         ecchmatrix[8][354]^sbits[8] |
         ecchmatrix[7][354]^sbits[7] |
         ecchmatrix[6][354]^sbits[6] |
         ecchmatrix[5][354]^sbits[5] |
         ecchmatrix[4][354]^sbits[4] |
         ecchmatrix[3][354]^sbits[3] |
         ecchmatrix[2][354]^sbits[2] |
         ecchmatrix[1][354]^sbits[1] |
         ecchmatrix[0][354]^sbits[0]);
  assign biterr_wire[353] = ~(
         ecchmatrix[9][353]^sbits[9] |
         ecchmatrix[8][353]^sbits[8] |
         ecchmatrix[7][353]^sbits[7] |
         ecchmatrix[6][353]^sbits[6] |
         ecchmatrix[5][353]^sbits[5] |
         ecchmatrix[4][353]^sbits[4] |
         ecchmatrix[3][353]^sbits[3] |
         ecchmatrix[2][353]^sbits[2] |
         ecchmatrix[1][353]^sbits[1] |
         ecchmatrix[0][353]^sbits[0]);
  assign biterr_wire[352] = ~(
         ecchmatrix[9][352]^sbits[9] |
         ecchmatrix[8][352]^sbits[8] |
         ecchmatrix[7][352]^sbits[7] |
         ecchmatrix[6][352]^sbits[6] |
         ecchmatrix[5][352]^sbits[5] |
         ecchmatrix[4][352]^sbits[4] |
         ecchmatrix[3][352]^sbits[3] |
         ecchmatrix[2][352]^sbits[2] |
         ecchmatrix[1][352]^sbits[1] |
         ecchmatrix[0][352]^sbits[0]);
  assign biterr_wire[351] = ~(
         ecchmatrix[9][351]^sbits[9] |
         ecchmatrix[8][351]^sbits[8] |
         ecchmatrix[7][351]^sbits[7] |
         ecchmatrix[6][351]^sbits[6] |
         ecchmatrix[5][351]^sbits[5] |
         ecchmatrix[4][351]^sbits[4] |
         ecchmatrix[3][351]^sbits[3] |
         ecchmatrix[2][351]^sbits[2] |
         ecchmatrix[1][351]^sbits[1] |
         ecchmatrix[0][351]^sbits[0]);
  assign biterr_wire[350] = ~(
         ecchmatrix[9][350]^sbits[9] |
         ecchmatrix[8][350]^sbits[8] |
         ecchmatrix[7][350]^sbits[7] |
         ecchmatrix[6][350]^sbits[6] |
         ecchmatrix[5][350]^sbits[5] |
         ecchmatrix[4][350]^sbits[4] |
         ecchmatrix[3][350]^sbits[3] |
         ecchmatrix[2][350]^sbits[2] |
         ecchmatrix[1][350]^sbits[1] |
         ecchmatrix[0][350]^sbits[0]);
  assign biterr_wire[349] = ~(
         ecchmatrix[9][349]^sbits[9] |
         ecchmatrix[8][349]^sbits[8] |
         ecchmatrix[7][349]^sbits[7] |
         ecchmatrix[6][349]^sbits[6] |
         ecchmatrix[5][349]^sbits[5] |
         ecchmatrix[4][349]^sbits[4] |
         ecchmatrix[3][349]^sbits[3] |
         ecchmatrix[2][349]^sbits[2] |
         ecchmatrix[1][349]^sbits[1] |
         ecchmatrix[0][349]^sbits[0]);
  assign biterr_wire[348] = ~(
         ecchmatrix[9][348]^sbits[9] |
         ecchmatrix[8][348]^sbits[8] |
         ecchmatrix[7][348]^sbits[7] |
         ecchmatrix[6][348]^sbits[6] |
         ecchmatrix[5][348]^sbits[5] |
         ecchmatrix[4][348]^sbits[4] |
         ecchmatrix[3][348]^sbits[3] |
         ecchmatrix[2][348]^sbits[2] |
         ecchmatrix[1][348]^sbits[1] |
         ecchmatrix[0][348]^sbits[0]);
  assign biterr_wire[347] = ~(
         ecchmatrix[9][347]^sbits[9] |
         ecchmatrix[8][347]^sbits[8] |
         ecchmatrix[7][347]^sbits[7] |
         ecchmatrix[6][347]^sbits[6] |
         ecchmatrix[5][347]^sbits[5] |
         ecchmatrix[4][347]^sbits[4] |
         ecchmatrix[3][347]^sbits[3] |
         ecchmatrix[2][347]^sbits[2] |
         ecchmatrix[1][347]^sbits[1] |
         ecchmatrix[0][347]^sbits[0]);
  assign biterr_wire[346] = ~(
         ecchmatrix[9][346]^sbits[9] |
         ecchmatrix[8][346]^sbits[8] |
         ecchmatrix[7][346]^sbits[7] |
         ecchmatrix[6][346]^sbits[6] |
         ecchmatrix[5][346]^sbits[5] |
         ecchmatrix[4][346]^sbits[4] |
         ecchmatrix[3][346]^sbits[3] |
         ecchmatrix[2][346]^sbits[2] |
         ecchmatrix[1][346]^sbits[1] |
         ecchmatrix[0][346]^sbits[0]);
  assign biterr_wire[345] = ~(
         ecchmatrix[9][345]^sbits[9] |
         ecchmatrix[8][345]^sbits[8] |
         ecchmatrix[7][345]^sbits[7] |
         ecchmatrix[6][345]^sbits[6] |
         ecchmatrix[5][345]^sbits[5] |
         ecchmatrix[4][345]^sbits[4] |
         ecchmatrix[3][345]^sbits[3] |
         ecchmatrix[2][345]^sbits[2] |
         ecchmatrix[1][345]^sbits[1] |
         ecchmatrix[0][345]^sbits[0]);
  assign biterr_wire[344] = ~(
         ecchmatrix[9][344]^sbits[9] |
         ecchmatrix[8][344]^sbits[8] |
         ecchmatrix[7][344]^sbits[7] |
         ecchmatrix[6][344]^sbits[6] |
         ecchmatrix[5][344]^sbits[5] |
         ecchmatrix[4][344]^sbits[4] |
         ecchmatrix[3][344]^sbits[3] |
         ecchmatrix[2][344]^sbits[2] |
         ecchmatrix[1][344]^sbits[1] |
         ecchmatrix[0][344]^sbits[0]);
  assign biterr_wire[343] = ~(
         ecchmatrix[9][343]^sbits[9] |
         ecchmatrix[8][343]^sbits[8] |
         ecchmatrix[7][343]^sbits[7] |
         ecchmatrix[6][343]^sbits[6] |
         ecchmatrix[5][343]^sbits[5] |
         ecchmatrix[4][343]^sbits[4] |
         ecchmatrix[3][343]^sbits[3] |
         ecchmatrix[2][343]^sbits[2] |
         ecchmatrix[1][343]^sbits[1] |
         ecchmatrix[0][343]^sbits[0]);
  assign biterr_wire[342] = ~(
         ecchmatrix[9][342]^sbits[9] |
         ecchmatrix[8][342]^sbits[8] |
         ecchmatrix[7][342]^sbits[7] |
         ecchmatrix[6][342]^sbits[6] |
         ecchmatrix[5][342]^sbits[5] |
         ecchmatrix[4][342]^sbits[4] |
         ecchmatrix[3][342]^sbits[3] |
         ecchmatrix[2][342]^sbits[2] |
         ecchmatrix[1][342]^sbits[1] |
         ecchmatrix[0][342]^sbits[0]);
  assign biterr_wire[341] = ~(
         ecchmatrix[9][341]^sbits[9] |
         ecchmatrix[8][341]^sbits[8] |
         ecchmatrix[7][341]^sbits[7] |
         ecchmatrix[6][341]^sbits[6] |
         ecchmatrix[5][341]^sbits[5] |
         ecchmatrix[4][341]^sbits[4] |
         ecchmatrix[3][341]^sbits[3] |
         ecchmatrix[2][341]^sbits[2] |
         ecchmatrix[1][341]^sbits[1] |
         ecchmatrix[0][341]^sbits[0]);
  assign biterr_wire[340] = ~(
         ecchmatrix[9][340]^sbits[9] |
         ecchmatrix[8][340]^sbits[8] |
         ecchmatrix[7][340]^sbits[7] |
         ecchmatrix[6][340]^sbits[6] |
         ecchmatrix[5][340]^sbits[5] |
         ecchmatrix[4][340]^sbits[4] |
         ecchmatrix[3][340]^sbits[3] |
         ecchmatrix[2][340]^sbits[2] |
         ecchmatrix[1][340]^sbits[1] |
         ecchmatrix[0][340]^sbits[0]);
  assign biterr_wire[339] = ~(
         ecchmatrix[9][339]^sbits[9] |
         ecchmatrix[8][339]^sbits[8] |
         ecchmatrix[7][339]^sbits[7] |
         ecchmatrix[6][339]^sbits[6] |
         ecchmatrix[5][339]^sbits[5] |
         ecchmatrix[4][339]^sbits[4] |
         ecchmatrix[3][339]^sbits[3] |
         ecchmatrix[2][339]^sbits[2] |
         ecchmatrix[1][339]^sbits[1] |
         ecchmatrix[0][339]^sbits[0]);
  assign biterr_wire[338] = ~(
         ecchmatrix[9][338]^sbits[9] |
         ecchmatrix[8][338]^sbits[8] |
         ecchmatrix[7][338]^sbits[7] |
         ecchmatrix[6][338]^sbits[6] |
         ecchmatrix[5][338]^sbits[5] |
         ecchmatrix[4][338]^sbits[4] |
         ecchmatrix[3][338]^sbits[3] |
         ecchmatrix[2][338]^sbits[2] |
         ecchmatrix[1][338]^sbits[1] |
         ecchmatrix[0][338]^sbits[0]);
  assign biterr_wire[337] = ~(
         ecchmatrix[9][337]^sbits[9] |
         ecchmatrix[8][337]^sbits[8] |
         ecchmatrix[7][337]^sbits[7] |
         ecchmatrix[6][337]^sbits[6] |
         ecchmatrix[5][337]^sbits[5] |
         ecchmatrix[4][337]^sbits[4] |
         ecchmatrix[3][337]^sbits[3] |
         ecchmatrix[2][337]^sbits[2] |
         ecchmatrix[1][337]^sbits[1] |
         ecchmatrix[0][337]^sbits[0]);
  assign biterr_wire[336] = ~(
         ecchmatrix[9][336]^sbits[9] |
         ecchmatrix[8][336]^sbits[8] |
         ecchmatrix[7][336]^sbits[7] |
         ecchmatrix[6][336]^sbits[6] |
         ecchmatrix[5][336]^sbits[5] |
         ecchmatrix[4][336]^sbits[4] |
         ecchmatrix[3][336]^sbits[3] |
         ecchmatrix[2][336]^sbits[2] |
         ecchmatrix[1][336]^sbits[1] |
         ecchmatrix[0][336]^sbits[0]);
  assign biterr_wire[335] = ~(
         ecchmatrix[9][335]^sbits[9] |
         ecchmatrix[8][335]^sbits[8] |
         ecchmatrix[7][335]^sbits[7] |
         ecchmatrix[6][335]^sbits[6] |
         ecchmatrix[5][335]^sbits[5] |
         ecchmatrix[4][335]^sbits[4] |
         ecchmatrix[3][335]^sbits[3] |
         ecchmatrix[2][335]^sbits[2] |
         ecchmatrix[1][335]^sbits[1] |
         ecchmatrix[0][335]^sbits[0]);
  assign biterr_wire[334] = ~(
         ecchmatrix[9][334]^sbits[9] |
         ecchmatrix[8][334]^sbits[8] |
         ecchmatrix[7][334]^sbits[7] |
         ecchmatrix[6][334]^sbits[6] |
         ecchmatrix[5][334]^sbits[5] |
         ecchmatrix[4][334]^sbits[4] |
         ecchmatrix[3][334]^sbits[3] |
         ecchmatrix[2][334]^sbits[2] |
         ecchmatrix[1][334]^sbits[1] |
         ecchmatrix[0][334]^sbits[0]);
  assign biterr_wire[333] = ~(
         ecchmatrix[9][333]^sbits[9] |
         ecchmatrix[8][333]^sbits[8] |
         ecchmatrix[7][333]^sbits[7] |
         ecchmatrix[6][333]^sbits[6] |
         ecchmatrix[5][333]^sbits[5] |
         ecchmatrix[4][333]^sbits[4] |
         ecchmatrix[3][333]^sbits[3] |
         ecchmatrix[2][333]^sbits[2] |
         ecchmatrix[1][333]^sbits[1] |
         ecchmatrix[0][333]^sbits[0]);
  assign biterr_wire[332] = ~(
         ecchmatrix[9][332]^sbits[9] |
         ecchmatrix[8][332]^sbits[8] |
         ecchmatrix[7][332]^sbits[7] |
         ecchmatrix[6][332]^sbits[6] |
         ecchmatrix[5][332]^sbits[5] |
         ecchmatrix[4][332]^sbits[4] |
         ecchmatrix[3][332]^sbits[3] |
         ecchmatrix[2][332]^sbits[2] |
         ecchmatrix[1][332]^sbits[1] |
         ecchmatrix[0][332]^sbits[0]);
  assign biterr_wire[331] = ~(
         ecchmatrix[9][331]^sbits[9] |
         ecchmatrix[8][331]^sbits[8] |
         ecchmatrix[7][331]^sbits[7] |
         ecchmatrix[6][331]^sbits[6] |
         ecchmatrix[5][331]^sbits[5] |
         ecchmatrix[4][331]^sbits[4] |
         ecchmatrix[3][331]^sbits[3] |
         ecchmatrix[2][331]^sbits[2] |
         ecchmatrix[1][331]^sbits[1] |
         ecchmatrix[0][331]^sbits[0]);
  assign biterr_wire[330] = ~(
         ecchmatrix[9][330]^sbits[9] |
         ecchmatrix[8][330]^sbits[8] |
         ecchmatrix[7][330]^sbits[7] |
         ecchmatrix[6][330]^sbits[6] |
         ecchmatrix[5][330]^sbits[5] |
         ecchmatrix[4][330]^sbits[4] |
         ecchmatrix[3][330]^sbits[3] |
         ecchmatrix[2][330]^sbits[2] |
         ecchmatrix[1][330]^sbits[1] |
         ecchmatrix[0][330]^sbits[0]);
  assign biterr_wire[329] = ~(
         ecchmatrix[9][329]^sbits[9] |
         ecchmatrix[8][329]^sbits[8] |
         ecchmatrix[7][329]^sbits[7] |
         ecchmatrix[6][329]^sbits[6] |
         ecchmatrix[5][329]^sbits[5] |
         ecchmatrix[4][329]^sbits[4] |
         ecchmatrix[3][329]^sbits[3] |
         ecchmatrix[2][329]^sbits[2] |
         ecchmatrix[1][329]^sbits[1] |
         ecchmatrix[0][329]^sbits[0]);
  assign biterr_wire[328] = ~(
         ecchmatrix[9][328]^sbits[9] |
         ecchmatrix[8][328]^sbits[8] |
         ecchmatrix[7][328]^sbits[7] |
         ecchmatrix[6][328]^sbits[6] |
         ecchmatrix[5][328]^sbits[5] |
         ecchmatrix[4][328]^sbits[4] |
         ecchmatrix[3][328]^sbits[3] |
         ecchmatrix[2][328]^sbits[2] |
         ecchmatrix[1][328]^sbits[1] |
         ecchmatrix[0][328]^sbits[0]);
  assign biterr_wire[327] = ~(
         ecchmatrix[9][327]^sbits[9] |
         ecchmatrix[8][327]^sbits[8] |
         ecchmatrix[7][327]^sbits[7] |
         ecchmatrix[6][327]^sbits[6] |
         ecchmatrix[5][327]^sbits[5] |
         ecchmatrix[4][327]^sbits[4] |
         ecchmatrix[3][327]^sbits[3] |
         ecchmatrix[2][327]^sbits[2] |
         ecchmatrix[1][327]^sbits[1] |
         ecchmatrix[0][327]^sbits[0]);
  assign biterr_wire[326] = ~(
         ecchmatrix[9][326]^sbits[9] |
         ecchmatrix[8][326]^sbits[8] |
         ecchmatrix[7][326]^sbits[7] |
         ecchmatrix[6][326]^sbits[6] |
         ecchmatrix[5][326]^sbits[5] |
         ecchmatrix[4][326]^sbits[4] |
         ecchmatrix[3][326]^sbits[3] |
         ecchmatrix[2][326]^sbits[2] |
         ecchmatrix[1][326]^sbits[1] |
         ecchmatrix[0][326]^sbits[0]);
  assign biterr_wire[325] = ~(
         ecchmatrix[9][325]^sbits[9] |
         ecchmatrix[8][325]^sbits[8] |
         ecchmatrix[7][325]^sbits[7] |
         ecchmatrix[6][325]^sbits[6] |
         ecchmatrix[5][325]^sbits[5] |
         ecchmatrix[4][325]^sbits[4] |
         ecchmatrix[3][325]^sbits[3] |
         ecchmatrix[2][325]^sbits[2] |
         ecchmatrix[1][325]^sbits[1] |
         ecchmatrix[0][325]^sbits[0]);
  assign biterr_wire[324] = ~(
         ecchmatrix[9][324]^sbits[9] |
         ecchmatrix[8][324]^sbits[8] |
         ecchmatrix[7][324]^sbits[7] |
         ecchmatrix[6][324]^sbits[6] |
         ecchmatrix[5][324]^sbits[5] |
         ecchmatrix[4][324]^sbits[4] |
         ecchmatrix[3][324]^sbits[3] |
         ecchmatrix[2][324]^sbits[2] |
         ecchmatrix[1][324]^sbits[1] |
         ecchmatrix[0][324]^sbits[0]);
  assign biterr_wire[323] = ~(
         ecchmatrix[9][323]^sbits[9] |
         ecchmatrix[8][323]^sbits[8] |
         ecchmatrix[7][323]^sbits[7] |
         ecchmatrix[6][323]^sbits[6] |
         ecchmatrix[5][323]^sbits[5] |
         ecchmatrix[4][323]^sbits[4] |
         ecchmatrix[3][323]^sbits[3] |
         ecchmatrix[2][323]^sbits[2] |
         ecchmatrix[1][323]^sbits[1] |
         ecchmatrix[0][323]^sbits[0]);
  assign biterr_wire[322] = ~(
         ecchmatrix[9][322]^sbits[9] |
         ecchmatrix[8][322]^sbits[8] |
         ecchmatrix[7][322]^sbits[7] |
         ecchmatrix[6][322]^sbits[6] |
         ecchmatrix[5][322]^sbits[5] |
         ecchmatrix[4][322]^sbits[4] |
         ecchmatrix[3][322]^sbits[3] |
         ecchmatrix[2][322]^sbits[2] |
         ecchmatrix[1][322]^sbits[1] |
         ecchmatrix[0][322]^sbits[0]);
  assign biterr_wire[321] = ~(
         ecchmatrix[9][321]^sbits[9] |
         ecchmatrix[8][321]^sbits[8] |
         ecchmatrix[7][321]^sbits[7] |
         ecchmatrix[6][321]^sbits[6] |
         ecchmatrix[5][321]^sbits[5] |
         ecchmatrix[4][321]^sbits[4] |
         ecchmatrix[3][321]^sbits[3] |
         ecchmatrix[2][321]^sbits[2] |
         ecchmatrix[1][321]^sbits[1] |
         ecchmatrix[0][321]^sbits[0]);
  assign biterr_wire[320] = ~(
         ecchmatrix[9][320]^sbits[9] |
         ecchmatrix[8][320]^sbits[8] |
         ecchmatrix[7][320]^sbits[7] |
         ecchmatrix[6][320]^sbits[6] |
         ecchmatrix[5][320]^sbits[5] |
         ecchmatrix[4][320]^sbits[4] |
         ecchmatrix[3][320]^sbits[3] |
         ecchmatrix[2][320]^sbits[2] |
         ecchmatrix[1][320]^sbits[1] |
         ecchmatrix[0][320]^sbits[0]);
  assign biterr_wire[319] = ~(
         ecchmatrix[9][319]^sbits[9] |
         ecchmatrix[8][319]^sbits[8] |
         ecchmatrix[7][319]^sbits[7] |
         ecchmatrix[6][319]^sbits[6] |
         ecchmatrix[5][319]^sbits[5] |
         ecchmatrix[4][319]^sbits[4] |
         ecchmatrix[3][319]^sbits[3] |
         ecchmatrix[2][319]^sbits[2] |
         ecchmatrix[1][319]^sbits[1] |
         ecchmatrix[0][319]^sbits[0]);
  assign biterr_wire[318] = ~(
         ecchmatrix[9][318]^sbits[9] |
         ecchmatrix[8][318]^sbits[8] |
         ecchmatrix[7][318]^sbits[7] |
         ecchmatrix[6][318]^sbits[6] |
         ecchmatrix[5][318]^sbits[5] |
         ecchmatrix[4][318]^sbits[4] |
         ecchmatrix[3][318]^sbits[3] |
         ecchmatrix[2][318]^sbits[2] |
         ecchmatrix[1][318]^sbits[1] |
         ecchmatrix[0][318]^sbits[0]);
  assign biterr_wire[317] = ~(
         ecchmatrix[9][317]^sbits[9] |
         ecchmatrix[8][317]^sbits[8] |
         ecchmatrix[7][317]^sbits[7] |
         ecchmatrix[6][317]^sbits[6] |
         ecchmatrix[5][317]^sbits[5] |
         ecchmatrix[4][317]^sbits[4] |
         ecchmatrix[3][317]^sbits[3] |
         ecchmatrix[2][317]^sbits[2] |
         ecchmatrix[1][317]^sbits[1] |
         ecchmatrix[0][317]^sbits[0]);
  assign biterr_wire[316] = ~(
         ecchmatrix[9][316]^sbits[9] |
         ecchmatrix[8][316]^sbits[8] |
         ecchmatrix[7][316]^sbits[7] |
         ecchmatrix[6][316]^sbits[6] |
         ecchmatrix[5][316]^sbits[5] |
         ecchmatrix[4][316]^sbits[4] |
         ecchmatrix[3][316]^sbits[3] |
         ecchmatrix[2][316]^sbits[2] |
         ecchmatrix[1][316]^sbits[1] |
         ecchmatrix[0][316]^sbits[0]);
  assign biterr_wire[315] = ~(
         ecchmatrix[9][315]^sbits[9] |
         ecchmatrix[8][315]^sbits[8] |
         ecchmatrix[7][315]^sbits[7] |
         ecchmatrix[6][315]^sbits[6] |
         ecchmatrix[5][315]^sbits[5] |
         ecchmatrix[4][315]^sbits[4] |
         ecchmatrix[3][315]^sbits[3] |
         ecchmatrix[2][315]^sbits[2] |
         ecchmatrix[1][315]^sbits[1] |
         ecchmatrix[0][315]^sbits[0]);
  assign biterr_wire[314] = ~(
         ecchmatrix[9][314]^sbits[9] |
         ecchmatrix[8][314]^sbits[8] |
         ecchmatrix[7][314]^sbits[7] |
         ecchmatrix[6][314]^sbits[6] |
         ecchmatrix[5][314]^sbits[5] |
         ecchmatrix[4][314]^sbits[4] |
         ecchmatrix[3][314]^sbits[3] |
         ecchmatrix[2][314]^sbits[2] |
         ecchmatrix[1][314]^sbits[1] |
         ecchmatrix[0][314]^sbits[0]);
  assign biterr_wire[313] = ~(
         ecchmatrix[9][313]^sbits[9] |
         ecchmatrix[8][313]^sbits[8] |
         ecchmatrix[7][313]^sbits[7] |
         ecchmatrix[6][313]^sbits[6] |
         ecchmatrix[5][313]^sbits[5] |
         ecchmatrix[4][313]^sbits[4] |
         ecchmatrix[3][313]^sbits[3] |
         ecchmatrix[2][313]^sbits[2] |
         ecchmatrix[1][313]^sbits[1] |
         ecchmatrix[0][313]^sbits[0]);
  assign biterr_wire[312] = ~(
         ecchmatrix[9][312]^sbits[9] |
         ecchmatrix[8][312]^sbits[8] |
         ecchmatrix[7][312]^sbits[7] |
         ecchmatrix[6][312]^sbits[6] |
         ecchmatrix[5][312]^sbits[5] |
         ecchmatrix[4][312]^sbits[4] |
         ecchmatrix[3][312]^sbits[3] |
         ecchmatrix[2][312]^sbits[2] |
         ecchmatrix[1][312]^sbits[1] |
         ecchmatrix[0][312]^sbits[0]);
  assign biterr_wire[311] = ~(
         ecchmatrix[9][311]^sbits[9] |
         ecchmatrix[8][311]^sbits[8] |
         ecchmatrix[7][311]^sbits[7] |
         ecchmatrix[6][311]^sbits[6] |
         ecchmatrix[5][311]^sbits[5] |
         ecchmatrix[4][311]^sbits[4] |
         ecchmatrix[3][311]^sbits[3] |
         ecchmatrix[2][311]^sbits[2] |
         ecchmatrix[1][311]^sbits[1] |
         ecchmatrix[0][311]^sbits[0]);
  assign biterr_wire[310] = ~(
         ecchmatrix[9][310]^sbits[9] |
         ecchmatrix[8][310]^sbits[8] |
         ecchmatrix[7][310]^sbits[7] |
         ecchmatrix[6][310]^sbits[6] |
         ecchmatrix[5][310]^sbits[5] |
         ecchmatrix[4][310]^sbits[4] |
         ecchmatrix[3][310]^sbits[3] |
         ecchmatrix[2][310]^sbits[2] |
         ecchmatrix[1][310]^sbits[1] |
         ecchmatrix[0][310]^sbits[0]);
  assign biterr_wire[309] = ~(
         ecchmatrix[9][309]^sbits[9] |
         ecchmatrix[8][309]^sbits[8] |
         ecchmatrix[7][309]^sbits[7] |
         ecchmatrix[6][309]^sbits[6] |
         ecchmatrix[5][309]^sbits[5] |
         ecchmatrix[4][309]^sbits[4] |
         ecchmatrix[3][309]^sbits[3] |
         ecchmatrix[2][309]^sbits[2] |
         ecchmatrix[1][309]^sbits[1] |
         ecchmatrix[0][309]^sbits[0]);
  assign biterr_wire[308] = ~(
         ecchmatrix[9][308]^sbits[9] |
         ecchmatrix[8][308]^sbits[8] |
         ecchmatrix[7][308]^sbits[7] |
         ecchmatrix[6][308]^sbits[6] |
         ecchmatrix[5][308]^sbits[5] |
         ecchmatrix[4][308]^sbits[4] |
         ecchmatrix[3][308]^sbits[3] |
         ecchmatrix[2][308]^sbits[2] |
         ecchmatrix[1][308]^sbits[1] |
         ecchmatrix[0][308]^sbits[0]);
  assign biterr_wire[307] = ~(
         ecchmatrix[9][307]^sbits[9] |
         ecchmatrix[8][307]^sbits[8] |
         ecchmatrix[7][307]^sbits[7] |
         ecchmatrix[6][307]^sbits[6] |
         ecchmatrix[5][307]^sbits[5] |
         ecchmatrix[4][307]^sbits[4] |
         ecchmatrix[3][307]^sbits[3] |
         ecchmatrix[2][307]^sbits[2] |
         ecchmatrix[1][307]^sbits[1] |
         ecchmatrix[0][307]^sbits[0]);
  assign biterr_wire[306] = ~(
         ecchmatrix[9][306]^sbits[9] |
         ecchmatrix[8][306]^sbits[8] |
         ecchmatrix[7][306]^sbits[7] |
         ecchmatrix[6][306]^sbits[6] |
         ecchmatrix[5][306]^sbits[5] |
         ecchmatrix[4][306]^sbits[4] |
         ecchmatrix[3][306]^sbits[3] |
         ecchmatrix[2][306]^sbits[2] |
         ecchmatrix[1][306]^sbits[1] |
         ecchmatrix[0][306]^sbits[0]);
  assign biterr_wire[305] = ~(
         ecchmatrix[9][305]^sbits[9] |
         ecchmatrix[8][305]^sbits[8] |
         ecchmatrix[7][305]^sbits[7] |
         ecchmatrix[6][305]^sbits[6] |
         ecchmatrix[5][305]^sbits[5] |
         ecchmatrix[4][305]^sbits[4] |
         ecchmatrix[3][305]^sbits[3] |
         ecchmatrix[2][305]^sbits[2] |
         ecchmatrix[1][305]^sbits[1] |
         ecchmatrix[0][305]^sbits[0]);
  assign biterr_wire[304] = ~(
         ecchmatrix[9][304]^sbits[9] |
         ecchmatrix[8][304]^sbits[8] |
         ecchmatrix[7][304]^sbits[7] |
         ecchmatrix[6][304]^sbits[6] |
         ecchmatrix[5][304]^sbits[5] |
         ecchmatrix[4][304]^sbits[4] |
         ecchmatrix[3][304]^sbits[3] |
         ecchmatrix[2][304]^sbits[2] |
         ecchmatrix[1][304]^sbits[1] |
         ecchmatrix[0][304]^sbits[0]);
  assign biterr_wire[303] = ~(
         ecchmatrix[9][303]^sbits[9] |
         ecchmatrix[8][303]^sbits[8] |
         ecchmatrix[7][303]^sbits[7] |
         ecchmatrix[6][303]^sbits[6] |
         ecchmatrix[5][303]^sbits[5] |
         ecchmatrix[4][303]^sbits[4] |
         ecchmatrix[3][303]^sbits[3] |
         ecchmatrix[2][303]^sbits[2] |
         ecchmatrix[1][303]^sbits[1] |
         ecchmatrix[0][303]^sbits[0]);
  assign biterr_wire[302] = ~(
         ecchmatrix[9][302]^sbits[9] |
         ecchmatrix[8][302]^sbits[8] |
         ecchmatrix[7][302]^sbits[7] |
         ecchmatrix[6][302]^sbits[6] |
         ecchmatrix[5][302]^sbits[5] |
         ecchmatrix[4][302]^sbits[4] |
         ecchmatrix[3][302]^sbits[3] |
         ecchmatrix[2][302]^sbits[2] |
         ecchmatrix[1][302]^sbits[1] |
         ecchmatrix[0][302]^sbits[0]);
  assign biterr_wire[301] = ~(
         ecchmatrix[9][301]^sbits[9] |
         ecchmatrix[8][301]^sbits[8] |
         ecchmatrix[7][301]^sbits[7] |
         ecchmatrix[6][301]^sbits[6] |
         ecchmatrix[5][301]^sbits[5] |
         ecchmatrix[4][301]^sbits[4] |
         ecchmatrix[3][301]^sbits[3] |
         ecchmatrix[2][301]^sbits[2] |
         ecchmatrix[1][301]^sbits[1] |
         ecchmatrix[0][301]^sbits[0]);
  assign biterr_wire[300] = ~(
         ecchmatrix[9][300]^sbits[9] |
         ecchmatrix[8][300]^sbits[8] |
         ecchmatrix[7][300]^sbits[7] |
         ecchmatrix[6][300]^sbits[6] |
         ecchmatrix[5][300]^sbits[5] |
         ecchmatrix[4][300]^sbits[4] |
         ecchmatrix[3][300]^sbits[3] |
         ecchmatrix[2][300]^sbits[2] |
         ecchmatrix[1][300]^sbits[1] |
         ecchmatrix[0][300]^sbits[0]);
  assign biterr_wire[299] = ~(
         ecchmatrix[9][299]^sbits[9] |
         ecchmatrix[8][299]^sbits[8] |
         ecchmatrix[7][299]^sbits[7] |
         ecchmatrix[6][299]^sbits[6] |
         ecchmatrix[5][299]^sbits[5] |
         ecchmatrix[4][299]^sbits[4] |
         ecchmatrix[3][299]^sbits[3] |
         ecchmatrix[2][299]^sbits[2] |
         ecchmatrix[1][299]^sbits[1] |
         ecchmatrix[0][299]^sbits[0]);
  assign biterr_wire[298] = ~(
         ecchmatrix[9][298]^sbits[9] |
         ecchmatrix[8][298]^sbits[8] |
         ecchmatrix[7][298]^sbits[7] |
         ecchmatrix[6][298]^sbits[6] |
         ecchmatrix[5][298]^sbits[5] |
         ecchmatrix[4][298]^sbits[4] |
         ecchmatrix[3][298]^sbits[3] |
         ecchmatrix[2][298]^sbits[2] |
         ecchmatrix[1][298]^sbits[1] |
         ecchmatrix[0][298]^sbits[0]);
  assign biterr_wire[297] = ~(
         ecchmatrix[9][297]^sbits[9] |
         ecchmatrix[8][297]^sbits[8] |
         ecchmatrix[7][297]^sbits[7] |
         ecchmatrix[6][297]^sbits[6] |
         ecchmatrix[5][297]^sbits[5] |
         ecchmatrix[4][297]^sbits[4] |
         ecchmatrix[3][297]^sbits[3] |
         ecchmatrix[2][297]^sbits[2] |
         ecchmatrix[1][297]^sbits[1] |
         ecchmatrix[0][297]^sbits[0]);
  assign biterr_wire[296] = ~(
         ecchmatrix[9][296]^sbits[9] |
         ecchmatrix[8][296]^sbits[8] |
         ecchmatrix[7][296]^sbits[7] |
         ecchmatrix[6][296]^sbits[6] |
         ecchmatrix[5][296]^sbits[5] |
         ecchmatrix[4][296]^sbits[4] |
         ecchmatrix[3][296]^sbits[3] |
         ecchmatrix[2][296]^sbits[2] |
         ecchmatrix[1][296]^sbits[1] |
         ecchmatrix[0][296]^sbits[0]);
  assign biterr_wire[295] = ~(
         ecchmatrix[9][295]^sbits[9] |
         ecchmatrix[8][295]^sbits[8] |
         ecchmatrix[7][295]^sbits[7] |
         ecchmatrix[6][295]^sbits[6] |
         ecchmatrix[5][295]^sbits[5] |
         ecchmatrix[4][295]^sbits[4] |
         ecchmatrix[3][295]^sbits[3] |
         ecchmatrix[2][295]^sbits[2] |
         ecchmatrix[1][295]^sbits[1] |
         ecchmatrix[0][295]^sbits[0]);
  assign biterr_wire[294] = ~(
         ecchmatrix[9][294]^sbits[9] |
         ecchmatrix[8][294]^sbits[8] |
         ecchmatrix[7][294]^sbits[7] |
         ecchmatrix[6][294]^sbits[6] |
         ecchmatrix[5][294]^sbits[5] |
         ecchmatrix[4][294]^sbits[4] |
         ecchmatrix[3][294]^sbits[3] |
         ecchmatrix[2][294]^sbits[2] |
         ecchmatrix[1][294]^sbits[1] |
         ecchmatrix[0][294]^sbits[0]);
  assign biterr_wire[293] = ~(
         ecchmatrix[9][293]^sbits[9] |
         ecchmatrix[8][293]^sbits[8] |
         ecchmatrix[7][293]^sbits[7] |
         ecchmatrix[6][293]^sbits[6] |
         ecchmatrix[5][293]^sbits[5] |
         ecchmatrix[4][293]^sbits[4] |
         ecchmatrix[3][293]^sbits[3] |
         ecchmatrix[2][293]^sbits[2] |
         ecchmatrix[1][293]^sbits[1] |
         ecchmatrix[0][293]^sbits[0]);
  assign biterr_wire[292] = ~(
         ecchmatrix[9][292]^sbits[9] |
         ecchmatrix[8][292]^sbits[8] |
         ecchmatrix[7][292]^sbits[7] |
         ecchmatrix[6][292]^sbits[6] |
         ecchmatrix[5][292]^sbits[5] |
         ecchmatrix[4][292]^sbits[4] |
         ecchmatrix[3][292]^sbits[3] |
         ecchmatrix[2][292]^sbits[2] |
         ecchmatrix[1][292]^sbits[1] |
         ecchmatrix[0][292]^sbits[0]);
  assign biterr_wire[291] = ~(
         ecchmatrix[9][291]^sbits[9] |
         ecchmatrix[8][291]^sbits[8] |
         ecchmatrix[7][291]^sbits[7] |
         ecchmatrix[6][291]^sbits[6] |
         ecchmatrix[5][291]^sbits[5] |
         ecchmatrix[4][291]^sbits[4] |
         ecchmatrix[3][291]^sbits[3] |
         ecchmatrix[2][291]^sbits[2] |
         ecchmatrix[1][291]^sbits[1] |
         ecchmatrix[0][291]^sbits[0]);
  assign biterr_wire[290] = ~(
         ecchmatrix[9][290]^sbits[9] |
         ecchmatrix[8][290]^sbits[8] |
         ecchmatrix[7][290]^sbits[7] |
         ecchmatrix[6][290]^sbits[6] |
         ecchmatrix[5][290]^sbits[5] |
         ecchmatrix[4][290]^sbits[4] |
         ecchmatrix[3][290]^sbits[3] |
         ecchmatrix[2][290]^sbits[2] |
         ecchmatrix[1][290]^sbits[1] |
         ecchmatrix[0][290]^sbits[0]);
  assign biterr_wire[289] = ~(
         ecchmatrix[9][289]^sbits[9] |
         ecchmatrix[8][289]^sbits[8] |
         ecchmatrix[7][289]^sbits[7] |
         ecchmatrix[6][289]^sbits[6] |
         ecchmatrix[5][289]^sbits[5] |
         ecchmatrix[4][289]^sbits[4] |
         ecchmatrix[3][289]^sbits[3] |
         ecchmatrix[2][289]^sbits[2] |
         ecchmatrix[1][289]^sbits[1] |
         ecchmatrix[0][289]^sbits[0]);
  assign biterr_wire[288] = ~(
         ecchmatrix[9][288]^sbits[9] |
         ecchmatrix[8][288]^sbits[8] |
         ecchmatrix[7][288]^sbits[7] |
         ecchmatrix[6][288]^sbits[6] |
         ecchmatrix[5][288]^sbits[5] |
         ecchmatrix[4][288]^sbits[4] |
         ecchmatrix[3][288]^sbits[3] |
         ecchmatrix[2][288]^sbits[2] |
         ecchmatrix[1][288]^sbits[1] |
         ecchmatrix[0][288]^sbits[0]);
  assign biterr_wire[287] = ~(
         ecchmatrix[9][287]^sbits[9] |
         ecchmatrix[8][287]^sbits[8] |
         ecchmatrix[7][287]^sbits[7] |
         ecchmatrix[6][287]^sbits[6] |
         ecchmatrix[5][287]^sbits[5] |
         ecchmatrix[4][287]^sbits[4] |
         ecchmatrix[3][287]^sbits[3] |
         ecchmatrix[2][287]^sbits[2] |
         ecchmatrix[1][287]^sbits[1] |
         ecchmatrix[0][287]^sbits[0]);
  assign biterr_wire[286] = ~(
         ecchmatrix[9][286]^sbits[9] |
         ecchmatrix[8][286]^sbits[8] |
         ecchmatrix[7][286]^sbits[7] |
         ecchmatrix[6][286]^sbits[6] |
         ecchmatrix[5][286]^sbits[5] |
         ecchmatrix[4][286]^sbits[4] |
         ecchmatrix[3][286]^sbits[3] |
         ecchmatrix[2][286]^sbits[2] |
         ecchmatrix[1][286]^sbits[1] |
         ecchmatrix[0][286]^sbits[0]);
  assign biterr_wire[285] = ~(
         ecchmatrix[9][285]^sbits[9] |
         ecchmatrix[8][285]^sbits[8] |
         ecchmatrix[7][285]^sbits[7] |
         ecchmatrix[6][285]^sbits[6] |
         ecchmatrix[5][285]^sbits[5] |
         ecchmatrix[4][285]^sbits[4] |
         ecchmatrix[3][285]^sbits[3] |
         ecchmatrix[2][285]^sbits[2] |
         ecchmatrix[1][285]^sbits[1] |
         ecchmatrix[0][285]^sbits[0]);
  assign biterr_wire[284] = ~(
         ecchmatrix[9][284]^sbits[9] |
         ecchmatrix[8][284]^sbits[8] |
         ecchmatrix[7][284]^sbits[7] |
         ecchmatrix[6][284]^sbits[6] |
         ecchmatrix[5][284]^sbits[5] |
         ecchmatrix[4][284]^sbits[4] |
         ecchmatrix[3][284]^sbits[3] |
         ecchmatrix[2][284]^sbits[2] |
         ecchmatrix[1][284]^sbits[1] |
         ecchmatrix[0][284]^sbits[0]);
  assign biterr_wire[283] = ~(
         ecchmatrix[9][283]^sbits[9] |
         ecchmatrix[8][283]^sbits[8] |
         ecchmatrix[7][283]^sbits[7] |
         ecchmatrix[6][283]^sbits[6] |
         ecchmatrix[5][283]^sbits[5] |
         ecchmatrix[4][283]^sbits[4] |
         ecchmatrix[3][283]^sbits[3] |
         ecchmatrix[2][283]^sbits[2] |
         ecchmatrix[1][283]^sbits[1] |
         ecchmatrix[0][283]^sbits[0]);
  assign biterr_wire[282] = ~(
         ecchmatrix[9][282]^sbits[9] |
         ecchmatrix[8][282]^sbits[8] |
         ecchmatrix[7][282]^sbits[7] |
         ecchmatrix[6][282]^sbits[6] |
         ecchmatrix[5][282]^sbits[5] |
         ecchmatrix[4][282]^sbits[4] |
         ecchmatrix[3][282]^sbits[3] |
         ecchmatrix[2][282]^sbits[2] |
         ecchmatrix[1][282]^sbits[1] |
         ecchmatrix[0][282]^sbits[0]);
  assign biterr_wire[281] = ~(
         ecchmatrix[9][281]^sbits[9] |
         ecchmatrix[8][281]^sbits[8] |
         ecchmatrix[7][281]^sbits[7] |
         ecchmatrix[6][281]^sbits[6] |
         ecchmatrix[5][281]^sbits[5] |
         ecchmatrix[4][281]^sbits[4] |
         ecchmatrix[3][281]^sbits[3] |
         ecchmatrix[2][281]^sbits[2] |
         ecchmatrix[1][281]^sbits[1] |
         ecchmatrix[0][281]^sbits[0]);
  assign biterr_wire[280] = ~(
         ecchmatrix[9][280]^sbits[9] |
         ecchmatrix[8][280]^sbits[8] |
         ecchmatrix[7][280]^sbits[7] |
         ecchmatrix[6][280]^sbits[6] |
         ecchmatrix[5][280]^sbits[5] |
         ecchmatrix[4][280]^sbits[4] |
         ecchmatrix[3][280]^sbits[3] |
         ecchmatrix[2][280]^sbits[2] |
         ecchmatrix[1][280]^sbits[1] |
         ecchmatrix[0][280]^sbits[0]);
  assign biterr_wire[279] = ~(
         ecchmatrix[9][279]^sbits[9] |
         ecchmatrix[8][279]^sbits[8] |
         ecchmatrix[7][279]^sbits[7] |
         ecchmatrix[6][279]^sbits[6] |
         ecchmatrix[5][279]^sbits[5] |
         ecchmatrix[4][279]^sbits[4] |
         ecchmatrix[3][279]^sbits[3] |
         ecchmatrix[2][279]^sbits[2] |
         ecchmatrix[1][279]^sbits[1] |
         ecchmatrix[0][279]^sbits[0]);
  assign biterr_wire[278] = ~(
         ecchmatrix[9][278]^sbits[9] |
         ecchmatrix[8][278]^sbits[8] |
         ecchmatrix[7][278]^sbits[7] |
         ecchmatrix[6][278]^sbits[6] |
         ecchmatrix[5][278]^sbits[5] |
         ecchmatrix[4][278]^sbits[4] |
         ecchmatrix[3][278]^sbits[3] |
         ecchmatrix[2][278]^sbits[2] |
         ecchmatrix[1][278]^sbits[1] |
         ecchmatrix[0][278]^sbits[0]);
  assign biterr_wire[277] = ~(
         ecchmatrix[9][277]^sbits[9] |
         ecchmatrix[8][277]^sbits[8] |
         ecchmatrix[7][277]^sbits[7] |
         ecchmatrix[6][277]^sbits[6] |
         ecchmatrix[5][277]^sbits[5] |
         ecchmatrix[4][277]^sbits[4] |
         ecchmatrix[3][277]^sbits[3] |
         ecchmatrix[2][277]^sbits[2] |
         ecchmatrix[1][277]^sbits[1] |
         ecchmatrix[0][277]^sbits[0]);
  assign biterr_wire[276] = ~(
         ecchmatrix[9][276]^sbits[9] |
         ecchmatrix[8][276]^sbits[8] |
         ecchmatrix[7][276]^sbits[7] |
         ecchmatrix[6][276]^sbits[6] |
         ecchmatrix[5][276]^sbits[5] |
         ecchmatrix[4][276]^sbits[4] |
         ecchmatrix[3][276]^sbits[3] |
         ecchmatrix[2][276]^sbits[2] |
         ecchmatrix[1][276]^sbits[1] |
         ecchmatrix[0][276]^sbits[0]);
  assign biterr_wire[275] = ~(
         ecchmatrix[9][275]^sbits[9] |
         ecchmatrix[8][275]^sbits[8] |
         ecchmatrix[7][275]^sbits[7] |
         ecchmatrix[6][275]^sbits[6] |
         ecchmatrix[5][275]^sbits[5] |
         ecchmatrix[4][275]^sbits[4] |
         ecchmatrix[3][275]^sbits[3] |
         ecchmatrix[2][275]^sbits[2] |
         ecchmatrix[1][275]^sbits[1] |
         ecchmatrix[0][275]^sbits[0]);
  assign biterr_wire[274] = ~(
         ecchmatrix[9][274]^sbits[9] |
         ecchmatrix[8][274]^sbits[8] |
         ecchmatrix[7][274]^sbits[7] |
         ecchmatrix[6][274]^sbits[6] |
         ecchmatrix[5][274]^sbits[5] |
         ecchmatrix[4][274]^sbits[4] |
         ecchmatrix[3][274]^sbits[3] |
         ecchmatrix[2][274]^sbits[2] |
         ecchmatrix[1][274]^sbits[1] |
         ecchmatrix[0][274]^sbits[0]);
  assign biterr_wire[273] = ~(
         ecchmatrix[9][273]^sbits[9] |
         ecchmatrix[8][273]^sbits[8] |
         ecchmatrix[7][273]^sbits[7] |
         ecchmatrix[6][273]^sbits[6] |
         ecchmatrix[5][273]^sbits[5] |
         ecchmatrix[4][273]^sbits[4] |
         ecchmatrix[3][273]^sbits[3] |
         ecchmatrix[2][273]^sbits[2] |
         ecchmatrix[1][273]^sbits[1] |
         ecchmatrix[0][273]^sbits[0]);
  assign biterr_wire[272] = ~(
         ecchmatrix[9][272]^sbits[9] |
         ecchmatrix[8][272]^sbits[8] |
         ecchmatrix[7][272]^sbits[7] |
         ecchmatrix[6][272]^sbits[6] |
         ecchmatrix[5][272]^sbits[5] |
         ecchmatrix[4][272]^sbits[4] |
         ecchmatrix[3][272]^sbits[3] |
         ecchmatrix[2][272]^sbits[2] |
         ecchmatrix[1][272]^sbits[1] |
         ecchmatrix[0][272]^sbits[0]);
  assign biterr_wire[271] = ~(
         ecchmatrix[9][271]^sbits[9] |
         ecchmatrix[8][271]^sbits[8] |
         ecchmatrix[7][271]^sbits[7] |
         ecchmatrix[6][271]^sbits[6] |
         ecchmatrix[5][271]^sbits[5] |
         ecchmatrix[4][271]^sbits[4] |
         ecchmatrix[3][271]^sbits[3] |
         ecchmatrix[2][271]^sbits[2] |
         ecchmatrix[1][271]^sbits[1] |
         ecchmatrix[0][271]^sbits[0]);
  assign biterr_wire[270] = ~(
         ecchmatrix[9][270]^sbits[9] |
         ecchmatrix[8][270]^sbits[8] |
         ecchmatrix[7][270]^sbits[7] |
         ecchmatrix[6][270]^sbits[6] |
         ecchmatrix[5][270]^sbits[5] |
         ecchmatrix[4][270]^sbits[4] |
         ecchmatrix[3][270]^sbits[3] |
         ecchmatrix[2][270]^sbits[2] |
         ecchmatrix[1][270]^sbits[1] |
         ecchmatrix[0][270]^sbits[0]);
  assign biterr_wire[269] = ~(
         ecchmatrix[9][269]^sbits[9] |
         ecchmatrix[8][269]^sbits[8] |
         ecchmatrix[7][269]^sbits[7] |
         ecchmatrix[6][269]^sbits[6] |
         ecchmatrix[5][269]^sbits[5] |
         ecchmatrix[4][269]^sbits[4] |
         ecchmatrix[3][269]^sbits[3] |
         ecchmatrix[2][269]^sbits[2] |
         ecchmatrix[1][269]^sbits[1] |
         ecchmatrix[0][269]^sbits[0]);
  assign biterr_wire[268] = ~(
         ecchmatrix[9][268]^sbits[9] |
         ecchmatrix[8][268]^sbits[8] |
         ecchmatrix[7][268]^sbits[7] |
         ecchmatrix[6][268]^sbits[6] |
         ecchmatrix[5][268]^sbits[5] |
         ecchmatrix[4][268]^sbits[4] |
         ecchmatrix[3][268]^sbits[3] |
         ecchmatrix[2][268]^sbits[2] |
         ecchmatrix[1][268]^sbits[1] |
         ecchmatrix[0][268]^sbits[0]);
  assign biterr_wire[267] = ~(
         ecchmatrix[9][267]^sbits[9] |
         ecchmatrix[8][267]^sbits[8] |
         ecchmatrix[7][267]^sbits[7] |
         ecchmatrix[6][267]^sbits[6] |
         ecchmatrix[5][267]^sbits[5] |
         ecchmatrix[4][267]^sbits[4] |
         ecchmatrix[3][267]^sbits[3] |
         ecchmatrix[2][267]^sbits[2] |
         ecchmatrix[1][267]^sbits[1] |
         ecchmatrix[0][267]^sbits[0]);
  assign biterr_wire[266] = ~(
         ecchmatrix[9][266]^sbits[9] |
         ecchmatrix[8][266]^sbits[8] |
         ecchmatrix[7][266]^sbits[7] |
         ecchmatrix[6][266]^sbits[6] |
         ecchmatrix[5][266]^sbits[5] |
         ecchmatrix[4][266]^sbits[4] |
         ecchmatrix[3][266]^sbits[3] |
         ecchmatrix[2][266]^sbits[2] |
         ecchmatrix[1][266]^sbits[1] |
         ecchmatrix[0][266]^sbits[0]);
  assign biterr_wire[265] = ~(
         ecchmatrix[9][265]^sbits[9] |
         ecchmatrix[8][265]^sbits[8] |
         ecchmatrix[7][265]^sbits[7] |
         ecchmatrix[6][265]^sbits[6] |
         ecchmatrix[5][265]^sbits[5] |
         ecchmatrix[4][265]^sbits[4] |
         ecchmatrix[3][265]^sbits[3] |
         ecchmatrix[2][265]^sbits[2] |
         ecchmatrix[1][265]^sbits[1] |
         ecchmatrix[0][265]^sbits[0]);
  assign biterr_wire[264] = ~(
         ecchmatrix[9][264]^sbits[9] |
         ecchmatrix[8][264]^sbits[8] |
         ecchmatrix[7][264]^sbits[7] |
         ecchmatrix[6][264]^sbits[6] |
         ecchmatrix[5][264]^sbits[5] |
         ecchmatrix[4][264]^sbits[4] |
         ecchmatrix[3][264]^sbits[3] |
         ecchmatrix[2][264]^sbits[2] |
         ecchmatrix[1][264]^sbits[1] |
         ecchmatrix[0][264]^sbits[0]);
  assign biterr_wire[263] = ~(
         ecchmatrix[9][263]^sbits[9] |
         ecchmatrix[8][263]^sbits[8] |
         ecchmatrix[7][263]^sbits[7] |
         ecchmatrix[6][263]^sbits[6] |
         ecchmatrix[5][263]^sbits[5] |
         ecchmatrix[4][263]^sbits[4] |
         ecchmatrix[3][263]^sbits[3] |
         ecchmatrix[2][263]^sbits[2] |
         ecchmatrix[1][263]^sbits[1] |
         ecchmatrix[0][263]^sbits[0]);
  assign biterr_wire[262] = ~(
         ecchmatrix[9][262]^sbits[9] |
         ecchmatrix[8][262]^sbits[8] |
         ecchmatrix[7][262]^sbits[7] |
         ecchmatrix[6][262]^sbits[6] |
         ecchmatrix[5][262]^sbits[5] |
         ecchmatrix[4][262]^sbits[4] |
         ecchmatrix[3][262]^sbits[3] |
         ecchmatrix[2][262]^sbits[2] |
         ecchmatrix[1][262]^sbits[1] |
         ecchmatrix[0][262]^sbits[0]);
  assign biterr_wire[261] = ~(
         ecchmatrix[9][261]^sbits[9] |
         ecchmatrix[8][261]^sbits[8] |
         ecchmatrix[7][261]^sbits[7] |
         ecchmatrix[6][261]^sbits[6] |
         ecchmatrix[5][261]^sbits[5] |
         ecchmatrix[4][261]^sbits[4] |
         ecchmatrix[3][261]^sbits[3] |
         ecchmatrix[2][261]^sbits[2] |
         ecchmatrix[1][261]^sbits[1] |
         ecchmatrix[0][261]^sbits[0]);
  assign biterr_wire[260] = ~(
         ecchmatrix[9][260]^sbits[9] |
         ecchmatrix[8][260]^sbits[8] |
         ecchmatrix[7][260]^sbits[7] |
         ecchmatrix[6][260]^sbits[6] |
         ecchmatrix[5][260]^sbits[5] |
         ecchmatrix[4][260]^sbits[4] |
         ecchmatrix[3][260]^sbits[3] |
         ecchmatrix[2][260]^sbits[2] |
         ecchmatrix[1][260]^sbits[1] |
         ecchmatrix[0][260]^sbits[0]);
  assign biterr_wire[259] = ~(
         ecchmatrix[9][259]^sbits[9] |
         ecchmatrix[8][259]^sbits[8] |
         ecchmatrix[7][259]^sbits[7] |
         ecchmatrix[6][259]^sbits[6] |
         ecchmatrix[5][259]^sbits[5] |
         ecchmatrix[4][259]^sbits[4] |
         ecchmatrix[3][259]^sbits[3] |
         ecchmatrix[2][259]^sbits[2] |
         ecchmatrix[1][259]^sbits[1] |
         ecchmatrix[0][259]^sbits[0]);
  assign biterr_wire[258] = ~(
         ecchmatrix[9][258]^sbits[9] |
         ecchmatrix[8][258]^sbits[8] |
         ecchmatrix[7][258]^sbits[7] |
         ecchmatrix[6][258]^sbits[6] |
         ecchmatrix[5][258]^sbits[5] |
         ecchmatrix[4][258]^sbits[4] |
         ecchmatrix[3][258]^sbits[3] |
         ecchmatrix[2][258]^sbits[2] |
         ecchmatrix[1][258]^sbits[1] |
         ecchmatrix[0][258]^sbits[0]);
  assign biterr_wire[257] = ~(
         ecchmatrix[9][257]^sbits[9] |
         ecchmatrix[8][257]^sbits[8] |
         ecchmatrix[7][257]^sbits[7] |
         ecchmatrix[6][257]^sbits[6] |
         ecchmatrix[5][257]^sbits[5] |
         ecchmatrix[4][257]^sbits[4] |
         ecchmatrix[3][257]^sbits[3] |
         ecchmatrix[2][257]^sbits[2] |
         ecchmatrix[1][257]^sbits[1] |
         ecchmatrix[0][257]^sbits[0]);
  assign biterr_wire[256] = ~(
         ecchmatrix[9][256]^sbits[9] |
         ecchmatrix[8][256]^sbits[8] |
         ecchmatrix[7][256]^sbits[7] |
         ecchmatrix[6][256]^sbits[6] |
         ecchmatrix[5][256]^sbits[5] |
         ecchmatrix[4][256]^sbits[4] |
         ecchmatrix[3][256]^sbits[3] |
         ecchmatrix[2][256]^sbits[2] |
         ecchmatrix[1][256]^sbits[1] |
         ecchmatrix[0][256]^sbits[0]);
  assign biterr_wire[255] = ~(
         ecchmatrix[9][255]^sbits[9] |
         ecchmatrix[8][255]^sbits[8] |
         ecchmatrix[7][255]^sbits[7] |
         ecchmatrix[6][255]^sbits[6] |
         ecchmatrix[5][255]^sbits[5] |
         ecchmatrix[4][255]^sbits[4] |
         ecchmatrix[3][255]^sbits[3] |
         ecchmatrix[2][255]^sbits[2] |
         ecchmatrix[1][255]^sbits[1] |
         ecchmatrix[0][255]^sbits[0]);
  assign biterr_wire[254] = ~(
         ecchmatrix[9][254]^sbits[9] |
         ecchmatrix[8][254]^sbits[8] |
         ecchmatrix[7][254]^sbits[7] |
         ecchmatrix[6][254]^sbits[6] |
         ecchmatrix[5][254]^sbits[5] |
         ecchmatrix[4][254]^sbits[4] |
         ecchmatrix[3][254]^sbits[3] |
         ecchmatrix[2][254]^sbits[2] |
         ecchmatrix[1][254]^sbits[1] |
         ecchmatrix[0][254]^sbits[0]);
  assign biterr_wire[253] = ~(
         ecchmatrix[9][253]^sbits[9] |
         ecchmatrix[8][253]^sbits[8] |
         ecchmatrix[7][253]^sbits[7] |
         ecchmatrix[6][253]^sbits[6] |
         ecchmatrix[5][253]^sbits[5] |
         ecchmatrix[4][253]^sbits[4] |
         ecchmatrix[3][253]^sbits[3] |
         ecchmatrix[2][253]^sbits[2] |
         ecchmatrix[1][253]^sbits[1] |
         ecchmatrix[0][253]^sbits[0]);
  assign biterr_wire[252] = ~(
         ecchmatrix[9][252]^sbits[9] |
         ecchmatrix[8][252]^sbits[8] |
         ecchmatrix[7][252]^sbits[7] |
         ecchmatrix[6][252]^sbits[6] |
         ecchmatrix[5][252]^sbits[5] |
         ecchmatrix[4][252]^sbits[4] |
         ecchmatrix[3][252]^sbits[3] |
         ecchmatrix[2][252]^sbits[2] |
         ecchmatrix[1][252]^sbits[1] |
         ecchmatrix[0][252]^sbits[0]);
  assign biterr_wire[251] = ~(
         ecchmatrix[9][251]^sbits[9] |
         ecchmatrix[8][251]^sbits[8] |
         ecchmatrix[7][251]^sbits[7] |
         ecchmatrix[6][251]^sbits[6] |
         ecchmatrix[5][251]^sbits[5] |
         ecchmatrix[4][251]^sbits[4] |
         ecchmatrix[3][251]^sbits[3] |
         ecchmatrix[2][251]^sbits[2] |
         ecchmatrix[1][251]^sbits[1] |
         ecchmatrix[0][251]^sbits[0]);
  assign biterr_wire[250] = ~(
         ecchmatrix[9][250]^sbits[9] |
         ecchmatrix[8][250]^sbits[8] |
         ecchmatrix[7][250]^sbits[7] |
         ecchmatrix[6][250]^sbits[6] |
         ecchmatrix[5][250]^sbits[5] |
         ecchmatrix[4][250]^sbits[4] |
         ecchmatrix[3][250]^sbits[3] |
         ecchmatrix[2][250]^sbits[2] |
         ecchmatrix[1][250]^sbits[1] |
         ecchmatrix[0][250]^sbits[0]);
  assign biterr_wire[249] = ~(
         ecchmatrix[9][249]^sbits[9] |
         ecchmatrix[8][249]^sbits[8] |
         ecchmatrix[7][249]^sbits[7] |
         ecchmatrix[6][249]^sbits[6] |
         ecchmatrix[5][249]^sbits[5] |
         ecchmatrix[4][249]^sbits[4] |
         ecchmatrix[3][249]^sbits[3] |
         ecchmatrix[2][249]^sbits[2] |
         ecchmatrix[1][249]^sbits[1] |
         ecchmatrix[0][249]^sbits[0]);
  assign biterr_wire[248] = ~(
         ecchmatrix[9][248]^sbits[9] |
         ecchmatrix[8][248]^sbits[8] |
         ecchmatrix[7][248]^sbits[7] |
         ecchmatrix[6][248]^sbits[6] |
         ecchmatrix[5][248]^sbits[5] |
         ecchmatrix[4][248]^sbits[4] |
         ecchmatrix[3][248]^sbits[3] |
         ecchmatrix[2][248]^sbits[2] |
         ecchmatrix[1][248]^sbits[1] |
         ecchmatrix[0][248]^sbits[0]);
  assign biterr_wire[247] = ~(
         ecchmatrix[9][247]^sbits[9] |
         ecchmatrix[8][247]^sbits[8] |
         ecchmatrix[7][247]^sbits[7] |
         ecchmatrix[6][247]^sbits[6] |
         ecchmatrix[5][247]^sbits[5] |
         ecchmatrix[4][247]^sbits[4] |
         ecchmatrix[3][247]^sbits[3] |
         ecchmatrix[2][247]^sbits[2] |
         ecchmatrix[1][247]^sbits[1] |
         ecchmatrix[0][247]^sbits[0]);
  assign biterr_wire[246] = ~(
         ecchmatrix[9][246]^sbits[9] |
         ecchmatrix[8][246]^sbits[8] |
         ecchmatrix[7][246]^sbits[7] |
         ecchmatrix[6][246]^sbits[6] |
         ecchmatrix[5][246]^sbits[5] |
         ecchmatrix[4][246]^sbits[4] |
         ecchmatrix[3][246]^sbits[3] |
         ecchmatrix[2][246]^sbits[2] |
         ecchmatrix[1][246]^sbits[1] |
         ecchmatrix[0][246]^sbits[0]);
  assign biterr_wire[245] = ~(
         ecchmatrix[9][245]^sbits[9] |
         ecchmatrix[8][245]^sbits[8] |
         ecchmatrix[7][245]^sbits[7] |
         ecchmatrix[6][245]^sbits[6] |
         ecchmatrix[5][245]^sbits[5] |
         ecchmatrix[4][245]^sbits[4] |
         ecchmatrix[3][245]^sbits[3] |
         ecchmatrix[2][245]^sbits[2] |
         ecchmatrix[1][245]^sbits[1] |
         ecchmatrix[0][245]^sbits[0]);
  assign biterr_wire[244] = ~(
         ecchmatrix[9][244]^sbits[9] |
         ecchmatrix[8][244]^sbits[8] |
         ecchmatrix[7][244]^sbits[7] |
         ecchmatrix[6][244]^sbits[6] |
         ecchmatrix[5][244]^sbits[5] |
         ecchmatrix[4][244]^sbits[4] |
         ecchmatrix[3][244]^sbits[3] |
         ecchmatrix[2][244]^sbits[2] |
         ecchmatrix[1][244]^sbits[1] |
         ecchmatrix[0][244]^sbits[0]);
  assign biterr_wire[243] = ~(
         ecchmatrix[9][243]^sbits[9] |
         ecchmatrix[8][243]^sbits[8] |
         ecchmatrix[7][243]^sbits[7] |
         ecchmatrix[6][243]^sbits[6] |
         ecchmatrix[5][243]^sbits[5] |
         ecchmatrix[4][243]^sbits[4] |
         ecchmatrix[3][243]^sbits[3] |
         ecchmatrix[2][243]^sbits[2] |
         ecchmatrix[1][243]^sbits[1] |
         ecchmatrix[0][243]^sbits[0]);
  assign biterr_wire[242] = ~(
         ecchmatrix[9][242]^sbits[9] |
         ecchmatrix[8][242]^sbits[8] |
         ecchmatrix[7][242]^sbits[7] |
         ecchmatrix[6][242]^sbits[6] |
         ecchmatrix[5][242]^sbits[5] |
         ecchmatrix[4][242]^sbits[4] |
         ecchmatrix[3][242]^sbits[3] |
         ecchmatrix[2][242]^sbits[2] |
         ecchmatrix[1][242]^sbits[1] |
         ecchmatrix[0][242]^sbits[0]);
  assign biterr_wire[241] = ~(
         ecchmatrix[9][241]^sbits[9] |
         ecchmatrix[8][241]^sbits[8] |
         ecchmatrix[7][241]^sbits[7] |
         ecchmatrix[6][241]^sbits[6] |
         ecchmatrix[5][241]^sbits[5] |
         ecchmatrix[4][241]^sbits[4] |
         ecchmatrix[3][241]^sbits[3] |
         ecchmatrix[2][241]^sbits[2] |
         ecchmatrix[1][241]^sbits[1] |
         ecchmatrix[0][241]^sbits[0]);
  assign biterr_wire[240] = ~(
         ecchmatrix[9][240]^sbits[9] |
         ecchmatrix[8][240]^sbits[8] |
         ecchmatrix[7][240]^sbits[7] |
         ecchmatrix[6][240]^sbits[6] |
         ecchmatrix[5][240]^sbits[5] |
         ecchmatrix[4][240]^sbits[4] |
         ecchmatrix[3][240]^sbits[3] |
         ecchmatrix[2][240]^sbits[2] |
         ecchmatrix[1][240]^sbits[1] |
         ecchmatrix[0][240]^sbits[0]);
  assign biterr_wire[239] = ~(
         ecchmatrix[9][239]^sbits[9] |
         ecchmatrix[8][239]^sbits[8] |
         ecchmatrix[7][239]^sbits[7] |
         ecchmatrix[6][239]^sbits[6] |
         ecchmatrix[5][239]^sbits[5] |
         ecchmatrix[4][239]^sbits[4] |
         ecchmatrix[3][239]^sbits[3] |
         ecchmatrix[2][239]^sbits[2] |
         ecchmatrix[1][239]^sbits[1] |
         ecchmatrix[0][239]^sbits[0]);
  assign biterr_wire[238] = ~(
         ecchmatrix[9][238]^sbits[9] |
         ecchmatrix[8][238]^sbits[8] |
         ecchmatrix[7][238]^sbits[7] |
         ecchmatrix[6][238]^sbits[6] |
         ecchmatrix[5][238]^sbits[5] |
         ecchmatrix[4][238]^sbits[4] |
         ecchmatrix[3][238]^sbits[3] |
         ecchmatrix[2][238]^sbits[2] |
         ecchmatrix[1][238]^sbits[1] |
         ecchmatrix[0][238]^sbits[0]);
  assign biterr_wire[237] = ~(
         ecchmatrix[9][237]^sbits[9] |
         ecchmatrix[8][237]^sbits[8] |
         ecchmatrix[7][237]^sbits[7] |
         ecchmatrix[6][237]^sbits[6] |
         ecchmatrix[5][237]^sbits[5] |
         ecchmatrix[4][237]^sbits[4] |
         ecchmatrix[3][237]^sbits[3] |
         ecchmatrix[2][237]^sbits[2] |
         ecchmatrix[1][237]^sbits[1] |
         ecchmatrix[0][237]^sbits[0]);
  assign biterr_wire[236] = ~(
         ecchmatrix[9][236]^sbits[9] |
         ecchmatrix[8][236]^sbits[8] |
         ecchmatrix[7][236]^sbits[7] |
         ecchmatrix[6][236]^sbits[6] |
         ecchmatrix[5][236]^sbits[5] |
         ecchmatrix[4][236]^sbits[4] |
         ecchmatrix[3][236]^sbits[3] |
         ecchmatrix[2][236]^sbits[2] |
         ecchmatrix[1][236]^sbits[1] |
         ecchmatrix[0][236]^sbits[0]);
  assign biterr_wire[235] = ~(
         ecchmatrix[9][235]^sbits[9] |
         ecchmatrix[8][235]^sbits[8] |
         ecchmatrix[7][235]^sbits[7] |
         ecchmatrix[6][235]^sbits[6] |
         ecchmatrix[5][235]^sbits[5] |
         ecchmatrix[4][235]^sbits[4] |
         ecchmatrix[3][235]^sbits[3] |
         ecchmatrix[2][235]^sbits[2] |
         ecchmatrix[1][235]^sbits[1] |
         ecchmatrix[0][235]^sbits[0]);
  assign biterr_wire[234] = ~(
         ecchmatrix[9][234]^sbits[9] |
         ecchmatrix[8][234]^sbits[8] |
         ecchmatrix[7][234]^sbits[7] |
         ecchmatrix[6][234]^sbits[6] |
         ecchmatrix[5][234]^sbits[5] |
         ecchmatrix[4][234]^sbits[4] |
         ecchmatrix[3][234]^sbits[3] |
         ecchmatrix[2][234]^sbits[2] |
         ecchmatrix[1][234]^sbits[1] |
         ecchmatrix[0][234]^sbits[0]);
  assign biterr_wire[233] = ~(
         ecchmatrix[9][233]^sbits[9] |
         ecchmatrix[8][233]^sbits[8] |
         ecchmatrix[7][233]^sbits[7] |
         ecchmatrix[6][233]^sbits[6] |
         ecchmatrix[5][233]^sbits[5] |
         ecchmatrix[4][233]^sbits[4] |
         ecchmatrix[3][233]^sbits[3] |
         ecchmatrix[2][233]^sbits[2] |
         ecchmatrix[1][233]^sbits[1] |
         ecchmatrix[0][233]^sbits[0]);
  assign biterr_wire[232] = ~(
         ecchmatrix[9][232]^sbits[9] |
         ecchmatrix[8][232]^sbits[8] |
         ecchmatrix[7][232]^sbits[7] |
         ecchmatrix[6][232]^sbits[6] |
         ecchmatrix[5][232]^sbits[5] |
         ecchmatrix[4][232]^sbits[4] |
         ecchmatrix[3][232]^sbits[3] |
         ecchmatrix[2][232]^sbits[2] |
         ecchmatrix[1][232]^sbits[1] |
         ecchmatrix[0][232]^sbits[0]);
  assign biterr_wire[231] = ~(
         ecchmatrix[9][231]^sbits[9] |
         ecchmatrix[8][231]^sbits[8] |
         ecchmatrix[7][231]^sbits[7] |
         ecchmatrix[6][231]^sbits[6] |
         ecchmatrix[5][231]^sbits[5] |
         ecchmatrix[4][231]^sbits[4] |
         ecchmatrix[3][231]^sbits[3] |
         ecchmatrix[2][231]^sbits[2] |
         ecchmatrix[1][231]^sbits[1] |
         ecchmatrix[0][231]^sbits[0]);
  assign biterr_wire[230] = ~(
         ecchmatrix[9][230]^sbits[9] |
         ecchmatrix[8][230]^sbits[8] |
         ecchmatrix[7][230]^sbits[7] |
         ecchmatrix[6][230]^sbits[6] |
         ecchmatrix[5][230]^sbits[5] |
         ecchmatrix[4][230]^sbits[4] |
         ecchmatrix[3][230]^sbits[3] |
         ecchmatrix[2][230]^sbits[2] |
         ecchmatrix[1][230]^sbits[1] |
         ecchmatrix[0][230]^sbits[0]);
  assign biterr_wire[229] = ~(
         ecchmatrix[9][229]^sbits[9] |
         ecchmatrix[8][229]^sbits[8] |
         ecchmatrix[7][229]^sbits[7] |
         ecchmatrix[6][229]^sbits[6] |
         ecchmatrix[5][229]^sbits[5] |
         ecchmatrix[4][229]^sbits[4] |
         ecchmatrix[3][229]^sbits[3] |
         ecchmatrix[2][229]^sbits[2] |
         ecchmatrix[1][229]^sbits[1] |
         ecchmatrix[0][229]^sbits[0]);
  assign biterr_wire[228] = ~(
         ecchmatrix[9][228]^sbits[9] |
         ecchmatrix[8][228]^sbits[8] |
         ecchmatrix[7][228]^sbits[7] |
         ecchmatrix[6][228]^sbits[6] |
         ecchmatrix[5][228]^sbits[5] |
         ecchmatrix[4][228]^sbits[4] |
         ecchmatrix[3][228]^sbits[3] |
         ecchmatrix[2][228]^sbits[2] |
         ecchmatrix[1][228]^sbits[1] |
         ecchmatrix[0][228]^sbits[0]);
  assign biterr_wire[227] = ~(
         ecchmatrix[9][227]^sbits[9] |
         ecchmatrix[8][227]^sbits[8] |
         ecchmatrix[7][227]^sbits[7] |
         ecchmatrix[6][227]^sbits[6] |
         ecchmatrix[5][227]^sbits[5] |
         ecchmatrix[4][227]^sbits[4] |
         ecchmatrix[3][227]^sbits[3] |
         ecchmatrix[2][227]^sbits[2] |
         ecchmatrix[1][227]^sbits[1] |
         ecchmatrix[0][227]^sbits[0]);
  assign biterr_wire[226] = ~(
         ecchmatrix[9][226]^sbits[9] |
         ecchmatrix[8][226]^sbits[8] |
         ecchmatrix[7][226]^sbits[7] |
         ecchmatrix[6][226]^sbits[6] |
         ecchmatrix[5][226]^sbits[5] |
         ecchmatrix[4][226]^sbits[4] |
         ecchmatrix[3][226]^sbits[3] |
         ecchmatrix[2][226]^sbits[2] |
         ecchmatrix[1][226]^sbits[1] |
         ecchmatrix[0][226]^sbits[0]);
  assign biterr_wire[225] = ~(
         ecchmatrix[9][225]^sbits[9] |
         ecchmatrix[8][225]^sbits[8] |
         ecchmatrix[7][225]^sbits[7] |
         ecchmatrix[6][225]^sbits[6] |
         ecchmatrix[5][225]^sbits[5] |
         ecchmatrix[4][225]^sbits[4] |
         ecchmatrix[3][225]^sbits[3] |
         ecchmatrix[2][225]^sbits[2] |
         ecchmatrix[1][225]^sbits[1] |
         ecchmatrix[0][225]^sbits[0]);
  assign biterr_wire[224] = ~(
         ecchmatrix[9][224]^sbits[9] |
         ecchmatrix[8][224]^sbits[8] |
         ecchmatrix[7][224]^sbits[7] |
         ecchmatrix[6][224]^sbits[6] |
         ecchmatrix[5][224]^sbits[5] |
         ecchmatrix[4][224]^sbits[4] |
         ecchmatrix[3][224]^sbits[3] |
         ecchmatrix[2][224]^sbits[2] |
         ecchmatrix[1][224]^sbits[1] |
         ecchmatrix[0][224]^sbits[0]);
  assign biterr_wire[223] = ~(
         ecchmatrix[9][223]^sbits[9] |
         ecchmatrix[8][223]^sbits[8] |
         ecchmatrix[7][223]^sbits[7] |
         ecchmatrix[6][223]^sbits[6] |
         ecchmatrix[5][223]^sbits[5] |
         ecchmatrix[4][223]^sbits[4] |
         ecchmatrix[3][223]^sbits[3] |
         ecchmatrix[2][223]^sbits[2] |
         ecchmatrix[1][223]^sbits[1] |
         ecchmatrix[0][223]^sbits[0]);
  assign biterr_wire[222] = ~(
         ecchmatrix[9][222]^sbits[9] |
         ecchmatrix[8][222]^sbits[8] |
         ecchmatrix[7][222]^sbits[7] |
         ecchmatrix[6][222]^sbits[6] |
         ecchmatrix[5][222]^sbits[5] |
         ecchmatrix[4][222]^sbits[4] |
         ecchmatrix[3][222]^sbits[3] |
         ecchmatrix[2][222]^sbits[2] |
         ecchmatrix[1][222]^sbits[1] |
         ecchmatrix[0][222]^sbits[0]);
  assign biterr_wire[221] = ~(
         ecchmatrix[9][221]^sbits[9] |
         ecchmatrix[8][221]^sbits[8] |
         ecchmatrix[7][221]^sbits[7] |
         ecchmatrix[6][221]^sbits[6] |
         ecchmatrix[5][221]^sbits[5] |
         ecchmatrix[4][221]^sbits[4] |
         ecchmatrix[3][221]^sbits[3] |
         ecchmatrix[2][221]^sbits[2] |
         ecchmatrix[1][221]^sbits[1] |
         ecchmatrix[0][221]^sbits[0]);
  assign biterr_wire[220] = ~(
         ecchmatrix[9][220]^sbits[9] |
         ecchmatrix[8][220]^sbits[8] |
         ecchmatrix[7][220]^sbits[7] |
         ecchmatrix[6][220]^sbits[6] |
         ecchmatrix[5][220]^sbits[5] |
         ecchmatrix[4][220]^sbits[4] |
         ecchmatrix[3][220]^sbits[3] |
         ecchmatrix[2][220]^sbits[2] |
         ecchmatrix[1][220]^sbits[1] |
         ecchmatrix[0][220]^sbits[0]);
  assign biterr_wire[219] = ~(
         ecchmatrix[9][219]^sbits[9] |
         ecchmatrix[8][219]^sbits[8] |
         ecchmatrix[7][219]^sbits[7] |
         ecchmatrix[6][219]^sbits[6] |
         ecchmatrix[5][219]^sbits[5] |
         ecchmatrix[4][219]^sbits[4] |
         ecchmatrix[3][219]^sbits[3] |
         ecchmatrix[2][219]^sbits[2] |
         ecchmatrix[1][219]^sbits[1] |
         ecchmatrix[0][219]^sbits[0]);
  assign biterr_wire[218] = ~(
         ecchmatrix[9][218]^sbits[9] |
         ecchmatrix[8][218]^sbits[8] |
         ecchmatrix[7][218]^sbits[7] |
         ecchmatrix[6][218]^sbits[6] |
         ecchmatrix[5][218]^sbits[5] |
         ecchmatrix[4][218]^sbits[4] |
         ecchmatrix[3][218]^sbits[3] |
         ecchmatrix[2][218]^sbits[2] |
         ecchmatrix[1][218]^sbits[1] |
         ecchmatrix[0][218]^sbits[0]);
  assign biterr_wire[217] = ~(
         ecchmatrix[9][217]^sbits[9] |
         ecchmatrix[8][217]^sbits[8] |
         ecchmatrix[7][217]^sbits[7] |
         ecchmatrix[6][217]^sbits[6] |
         ecchmatrix[5][217]^sbits[5] |
         ecchmatrix[4][217]^sbits[4] |
         ecchmatrix[3][217]^sbits[3] |
         ecchmatrix[2][217]^sbits[2] |
         ecchmatrix[1][217]^sbits[1] |
         ecchmatrix[0][217]^sbits[0]);
  assign biterr_wire[216] = ~(
         ecchmatrix[9][216]^sbits[9] |
         ecchmatrix[8][216]^sbits[8] |
         ecchmatrix[7][216]^sbits[7] |
         ecchmatrix[6][216]^sbits[6] |
         ecchmatrix[5][216]^sbits[5] |
         ecchmatrix[4][216]^sbits[4] |
         ecchmatrix[3][216]^sbits[3] |
         ecchmatrix[2][216]^sbits[2] |
         ecchmatrix[1][216]^sbits[1] |
         ecchmatrix[0][216]^sbits[0]);
  assign biterr_wire[215] = ~(
         ecchmatrix[9][215]^sbits[9] |
         ecchmatrix[8][215]^sbits[8] |
         ecchmatrix[7][215]^sbits[7] |
         ecchmatrix[6][215]^sbits[6] |
         ecchmatrix[5][215]^sbits[5] |
         ecchmatrix[4][215]^sbits[4] |
         ecchmatrix[3][215]^sbits[3] |
         ecchmatrix[2][215]^sbits[2] |
         ecchmatrix[1][215]^sbits[1] |
         ecchmatrix[0][215]^sbits[0]);
  assign biterr_wire[214] = ~(
         ecchmatrix[9][214]^sbits[9] |
         ecchmatrix[8][214]^sbits[8] |
         ecchmatrix[7][214]^sbits[7] |
         ecchmatrix[6][214]^sbits[6] |
         ecchmatrix[5][214]^sbits[5] |
         ecchmatrix[4][214]^sbits[4] |
         ecchmatrix[3][214]^sbits[3] |
         ecchmatrix[2][214]^sbits[2] |
         ecchmatrix[1][214]^sbits[1] |
         ecchmatrix[0][214]^sbits[0]);
  assign biterr_wire[213] = ~(
         ecchmatrix[9][213]^sbits[9] |
         ecchmatrix[8][213]^sbits[8] |
         ecchmatrix[7][213]^sbits[7] |
         ecchmatrix[6][213]^sbits[6] |
         ecchmatrix[5][213]^sbits[5] |
         ecchmatrix[4][213]^sbits[4] |
         ecchmatrix[3][213]^sbits[3] |
         ecchmatrix[2][213]^sbits[2] |
         ecchmatrix[1][213]^sbits[1] |
         ecchmatrix[0][213]^sbits[0]);
  assign biterr_wire[212] = ~(
         ecchmatrix[9][212]^sbits[9] |
         ecchmatrix[8][212]^sbits[8] |
         ecchmatrix[7][212]^sbits[7] |
         ecchmatrix[6][212]^sbits[6] |
         ecchmatrix[5][212]^sbits[5] |
         ecchmatrix[4][212]^sbits[4] |
         ecchmatrix[3][212]^sbits[3] |
         ecchmatrix[2][212]^sbits[2] |
         ecchmatrix[1][212]^sbits[1] |
         ecchmatrix[0][212]^sbits[0]);
  assign biterr_wire[211] = ~(
         ecchmatrix[9][211]^sbits[9] |
         ecchmatrix[8][211]^sbits[8] |
         ecchmatrix[7][211]^sbits[7] |
         ecchmatrix[6][211]^sbits[6] |
         ecchmatrix[5][211]^sbits[5] |
         ecchmatrix[4][211]^sbits[4] |
         ecchmatrix[3][211]^sbits[3] |
         ecchmatrix[2][211]^sbits[2] |
         ecchmatrix[1][211]^sbits[1] |
         ecchmatrix[0][211]^sbits[0]);
  assign biterr_wire[210] = ~(
         ecchmatrix[9][210]^sbits[9] |
         ecchmatrix[8][210]^sbits[8] |
         ecchmatrix[7][210]^sbits[7] |
         ecchmatrix[6][210]^sbits[6] |
         ecchmatrix[5][210]^sbits[5] |
         ecchmatrix[4][210]^sbits[4] |
         ecchmatrix[3][210]^sbits[3] |
         ecchmatrix[2][210]^sbits[2] |
         ecchmatrix[1][210]^sbits[1] |
         ecchmatrix[0][210]^sbits[0]);
  assign biterr_wire[209] = ~(
         ecchmatrix[9][209]^sbits[9] |
         ecchmatrix[8][209]^sbits[8] |
         ecchmatrix[7][209]^sbits[7] |
         ecchmatrix[6][209]^sbits[6] |
         ecchmatrix[5][209]^sbits[5] |
         ecchmatrix[4][209]^sbits[4] |
         ecchmatrix[3][209]^sbits[3] |
         ecchmatrix[2][209]^sbits[2] |
         ecchmatrix[1][209]^sbits[1] |
         ecchmatrix[0][209]^sbits[0]);
  assign biterr_wire[208] = ~(
         ecchmatrix[9][208]^sbits[9] |
         ecchmatrix[8][208]^sbits[8] |
         ecchmatrix[7][208]^sbits[7] |
         ecchmatrix[6][208]^sbits[6] |
         ecchmatrix[5][208]^sbits[5] |
         ecchmatrix[4][208]^sbits[4] |
         ecchmatrix[3][208]^sbits[3] |
         ecchmatrix[2][208]^sbits[2] |
         ecchmatrix[1][208]^sbits[1] |
         ecchmatrix[0][208]^sbits[0]);
  assign biterr_wire[207] = ~(
         ecchmatrix[9][207]^sbits[9] |
         ecchmatrix[8][207]^sbits[8] |
         ecchmatrix[7][207]^sbits[7] |
         ecchmatrix[6][207]^sbits[6] |
         ecchmatrix[5][207]^sbits[5] |
         ecchmatrix[4][207]^sbits[4] |
         ecchmatrix[3][207]^sbits[3] |
         ecchmatrix[2][207]^sbits[2] |
         ecchmatrix[1][207]^sbits[1] |
         ecchmatrix[0][207]^sbits[0]);
  assign biterr_wire[206] = ~(
         ecchmatrix[9][206]^sbits[9] |
         ecchmatrix[8][206]^sbits[8] |
         ecchmatrix[7][206]^sbits[7] |
         ecchmatrix[6][206]^sbits[6] |
         ecchmatrix[5][206]^sbits[5] |
         ecchmatrix[4][206]^sbits[4] |
         ecchmatrix[3][206]^sbits[3] |
         ecchmatrix[2][206]^sbits[2] |
         ecchmatrix[1][206]^sbits[1] |
         ecchmatrix[0][206]^sbits[0]);
  assign biterr_wire[205] = ~(
         ecchmatrix[9][205]^sbits[9] |
         ecchmatrix[8][205]^sbits[8] |
         ecchmatrix[7][205]^sbits[7] |
         ecchmatrix[6][205]^sbits[6] |
         ecchmatrix[5][205]^sbits[5] |
         ecchmatrix[4][205]^sbits[4] |
         ecchmatrix[3][205]^sbits[3] |
         ecchmatrix[2][205]^sbits[2] |
         ecchmatrix[1][205]^sbits[1] |
         ecchmatrix[0][205]^sbits[0]);
  assign biterr_wire[204] = ~(
         ecchmatrix[9][204]^sbits[9] |
         ecchmatrix[8][204]^sbits[8] |
         ecchmatrix[7][204]^sbits[7] |
         ecchmatrix[6][204]^sbits[6] |
         ecchmatrix[5][204]^sbits[5] |
         ecchmatrix[4][204]^sbits[4] |
         ecchmatrix[3][204]^sbits[3] |
         ecchmatrix[2][204]^sbits[2] |
         ecchmatrix[1][204]^sbits[1] |
         ecchmatrix[0][204]^sbits[0]);
  assign biterr_wire[203] = ~(
         ecchmatrix[9][203]^sbits[9] |
         ecchmatrix[8][203]^sbits[8] |
         ecchmatrix[7][203]^sbits[7] |
         ecchmatrix[6][203]^sbits[6] |
         ecchmatrix[5][203]^sbits[5] |
         ecchmatrix[4][203]^sbits[4] |
         ecchmatrix[3][203]^sbits[3] |
         ecchmatrix[2][203]^sbits[2] |
         ecchmatrix[1][203]^sbits[1] |
         ecchmatrix[0][203]^sbits[0]);
  assign biterr_wire[202] = ~(
         ecchmatrix[9][202]^sbits[9] |
         ecchmatrix[8][202]^sbits[8] |
         ecchmatrix[7][202]^sbits[7] |
         ecchmatrix[6][202]^sbits[6] |
         ecchmatrix[5][202]^sbits[5] |
         ecchmatrix[4][202]^sbits[4] |
         ecchmatrix[3][202]^sbits[3] |
         ecchmatrix[2][202]^sbits[2] |
         ecchmatrix[1][202]^sbits[1] |
         ecchmatrix[0][202]^sbits[0]);
  assign biterr_wire[201] = ~(
         ecchmatrix[9][201]^sbits[9] |
         ecchmatrix[8][201]^sbits[8] |
         ecchmatrix[7][201]^sbits[7] |
         ecchmatrix[6][201]^sbits[6] |
         ecchmatrix[5][201]^sbits[5] |
         ecchmatrix[4][201]^sbits[4] |
         ecchmatrix[3][201]^sbits[3] |
         ecchmatrix[2][201]^sbits[2] |
         ecchmatrix[1][201]^sbits[1] |
         ecchmatrix[0][201]^sbits[0]);
  assign biterr_wire[200] = ~(
         ecchmatrix[9][200]^sbits[9] |
         ecchmatrix[8][200]^sbits[8] |
         ecchmatrix[7][200]^sbits[7] |
         ecchmatrix[6][200]^sbits[6] |
         ecchmatrix[5][200]^sbits[5] |
         ecchmatrix[4][200]^sbits[4] |
         ecchmatrix[3][200]^sbits[3] |
         ecchmatrix[2][200]^sbits[2] |
         ecchmatrix[1][200]^sbits[1] |
         ecchmatrix[0][200]^sbits[0]);
  assign biterr_wire[199] = ~(
         ecchmatrix[9][199]^sbits[9] |
         ecchmatrix[8][199]^sbits[8] |
         ecchmatrix[7][199]^sbits[7] |
         ecchmatrix[6][199]^sbits[6] |
         ecchmatrix[5][199]^sbits[5] |
         ecchmatrix[4][199]^sbits[4] |
         ecchmatrix[3][199]^sbits[3] |
         ecchmatrix[2][199]^sbits[2] |
         ecchmatrix[1][199]^sbits[1] |
         ecchmatrix[0][199]^sbits[0]);
  assign biterr_wire[198] = ~(
         ecchmatrix[9][198]^sbits[9] |
         ecchmatrix[8][198]^sbits[8] |
         ecchmatrix[7][198]^sbits[7] |
         ecchmatrix[6][198]^sbits[6] |
         ecchmatrix[5][198]^sbits[5] |
         ecchmatrix[4][198]^sbits[4] |
         ecchmatrix[3][198]^sbits[3] |
         ecchmatrix[2][198]^sbits[2] |
         ecchmatrix[1][198]^sbits[1] |
         ecchmatrix[0][198]^sbits[0]);
  assign biterr_wire[197] = ~(
         ecchmatrix[9][197]^sbits[9] |
         ecchmatrix[8][197]^sbits[8] |
         ecchmatrix[7][197]^sbits[7] |
         ecchmatrix[6][197]^sbits[6] |
         ecchmatrix[5][197]^sbits[5] |
         ecchmatrix[4][197]^sbits[4] |
         ecchmatrix[3][197]^sbits[3] |
         ecchmatrix[2][197]^sbits[2] |
         ecchmatrix[1][197]^sbits[1] |
         ecchmatrix[0][197]^sbits[0]);
  assign biterr_wire[196] = ~(
         ecchmatrix[9][196]^sbits[9] |
         ecchmatrix[8][196]^sbits[8] |
         ecchmatrix[7][196]^sbits[7] |
         ecchmatrix[6][196]^sbits[6] |
         ecchmatrix[5][196]^sbits[5] |
         ecchmatrix[4][196]^sbits[4] |
         ecchmatrix[3][196]^sbits[3] |
         ecchmatrix[2][196]^sbits[2] |
         ecchmatrix[1][196]^sbits[1] |
         ecchmatrix[0][196]^sbits[0]);
  assign biterr_wire[195] = ~(
         ecchmatrix[9][195]^sbits[9] |
         ecchmatrix[8][195]^sbits[8] |
         ecchmatrix[7][195]^sbits[7] |
         ecchmatrix[6][195]^sbits[6] |
         ecchmatrix[5][195]^sbits[5] |
         ecchmatrix[4][195]^sbits[4] |
         ecchmatrix[3][195]^sbits[3] |
         ecchmatrix[2][195]^sbits[2] |
         ecchmatrix[1][195]^sbits[1] |
         ecchmatrix[0][195]^sbits[0]);
  assign biterr_wire[194] = ~(
         ecchmatrix[9][194]^sbits[9] |
         ecchmatrix[8][194]^sbits[8] |
         ecchmatrix[7][194]^sbits[7] |
         ecchmatrix[6][194]^sbits[6] |
         ecchmatrix[5][194]^sbits[5] |
         ecchmatrix[4][194]^sbits[4] |
         ecchmatrix[3][194]^sbits[3] |
         ecchmatrix[2][194]^sbits[2] |
         ecchmatrix[1][194]^sbits[1] |
         ecchmatrix[0][194]^sbits[0]);
  assign biterr_wire[193] = ~(
         ecchmatrix[9][193]^sbits[9] |
         ecchmatrix[8][193]^sbits[8] |
         ecchmatrix[7][193]^sbits[7] |
         ecchmatrix[6][193]^sbits[6] |
         ecchmatrix[5][193]^sbits[5] |
         ecchmatrix[4][193]^sbits[4] |
         ecchmatrix[3][193]^sbits[3] |
         ecchmatrix[2][193]^sbits[2] |
         ecchmatrix[1][193]^sbits[1] |
         ecchmatrix[0][193]^sbits[0]);
  assign biterr_wire[192] = ~(
         ecchmatrix[9][192]^sbits[9] |
         ecchmatrix[8][192]^sbits[8] |
         ecchmatrix[7][192]^sbits[7] |
         ecchmatrix[6][192]^sbits[6] |
         ecchmatrix[5][192]^sbits[5] |
         ecchmatrix[4][192]^sbits[4] |
         ecchmatrix[3][192]^sbits[3] |
         ecchmatrix[2][192]^sbits[2] |
         ecchmatrix[1][192]^sbits[1] |
         ecchmatrix[0][192]^sbits[0]);
  assign biterr_wire[191] = ~(
         ecchmatrix[9][191]^sbits[9] |
         ecchmatrix[8][191]^sbits[8] |
         ecchmatrix[7][191]^sbits[7] |
         ecchmatrix[6][191]^sbits[6] |
         ecchmatrix[5][191]^sbits[5] |
         ecchmatrix[4][191]^sbits[4] |
         ecchmatrix[3][191]^sbits[3] |
         ecchmatrix[2][191]^sbits[2] |
         ecchmatrix[1][191]^sbits[1] |
         ecchmatrix[0][191]^sbits[0]);
  assign biterr_wire[190] = ~(
         ecchmatrix[9][190]^sbits[9] |
         ecchmatrix[8][190]^sbits[8] |
         ecchmatrix[7][190]^sbits[7] |
         ecchmatrix[6][190]^sbits[6] |
         ecchmatrix[5][190]^sbits[5] |
         ecchmatrix[4][190]^sbits[4] |
         ecchmatrix[3][190]^sbits[3] |
         ecchmatrix[2][190]^sbits[2] |
         ecchmatrix[1][190]^sbits[1] |
         ecchmatrix[0][190]^sbits[0]);
  assign biterr_wire[189] = ~(
         ecchmatrix[9][189]^sbits[9] |
         ecchmatrix[8][189]^sbits[8] |
         ecchmatrix[7][189]^sbits[7] |
         ecchmatrix[6][189]^sbits[6] |
         ecchmatrix[5][189]^sbits[5] |
         ecchmatrix[4][189]^sbits[4] |
         ecchmatrix[3][189]^sbits[3] |
         ecchmatrix[2][189]^sbits[2] |
         ecchmatrix[1][189]^sbits[1] |
         ecchmatrix[0][189]^sbits[0]);
  assign biterr_wire[188] = ~(
         ecchmatrix[9][188]^sbits[9] |
         ecchmatrix[8][188]^sbits[8] |
         ecchmatrix[7][188]^sbits[7] |
         ecchmatrix[6][188]^sbits[6] |
         ecchmatrix[5][188]^sbits[5] |
         ecchmatrix[4][188]^sbits[4] |
         ecchmatrix[3][188]^sbits[3] |
         ecchmatrix[2][188]^sbits[2] |
         ecchmatrix[1][188]^sbits[1] |
         ecchmatrix[0][188]^sbits[0]);
  assign biterr_wire[187] = ~(
         ecchmatrix[9][187]^sbits[9] |
         ecchmatrix[8][187]^sbits[8] |
         ecchmatrix[7][187]^sbits[7] |
         ecchmatrix[6][187]^sbits[6] |
         ecchmatrix[5][187]^sbits[5] |
         ecchmatrix[4][187]^sbits[4] |
         ecchmatrix[3][187]^sbits[3] |
         ecchmatrix[2][187]^sbits[2] |
         ecchmatrix[1][187]^sbits[1] |
         ecchmatrix[0][187]^sbits[0]);
  assign biterr_wire[186] = ~(
         ecchmatrix[9][186]^sbits[9] |
         ecchmatrix[8][186]^sbits[8] |
         ecchmatrix[7][186]^sbits[7] |
         ecchmatrix[6][186]^sbits[6] |
         ecchmatrix[5][186]^sbits[5] |
         ecchmatrix[4][186]^sbits[4] |
         ecchmatrix[3][186]^sbits[3] |
         ecchmatrix[2][186]^sbits[2] |
         ecchmatrix[1][186]^sbits[1] |
         ecchmatrix[0][186]^sbits[0]);
  assign biterr_wire[185] = ~(
         ecchmatrix[9][185]^sbits[9] |
         ecchmatrix[8][185]^sbits[8] |
         ecchmatrix[7][185]^sbits[7] |
         ecchmatrix[6][185]^sbits[6] |
         ecchmatrix[5][185]^sbits[5] |
         ecchmatrix[4][185]^sbits[4] |
         ecchmatrix[3][185]^sbits[3] |
         ecchmatrix[2][185]^sbits[2] |
         ecchmatrix[1][185]^sbits[1] |
         ecchmatrix[0][185]^sbits[0]);
  assign biterr_wire[184] = ~(
         ecchmatrix[9][184]^sbits[9] |
         ecchmatrix[8][184]^sbits[8] |
         ecchmatrix[7][184]^sbits[7] |
         ecchmatrix[6][184]^sbits[6] |
         ecchmatrix[5][184]^sbits[5] |
         ecchmatrix[4][184]^sbits[4] |
         ecchmatrix[3][184]^sbits[3] |
         ecchmatrix[2][184]^sbits[2] |
         ecchmatrix[1][184]^sbits[1] |
         ecchmatrix[0][184]^sbits[0]);
  assign biterr_wire[183] = ~(
         ecchmatrix[9][183]^sbits[9] |
         ecchmatrix[8][183]^sbits[8] |
         ecchmatrix[7][183]^sbits[7] |
         ecchmatrix[6][183]^sbits[6] |
         ecchmatrix[5][183]^sbits[5] |
         ecchmatrix[4][183]^sbits[4] |
         ecchmatrix[3][183]^sbits[3] |
         ecchmatrix[2][183]^sbits[2] |
         ecchmatrix[1][183]^sbits[1] |
         ecchmatrix[0][183]^sbits[0]);
  assign biterr_wire[182] = ~(
         ecchmatrix[9][182]^sbits[9] |
         ecchmatrix[8][182]^sbits[8] |
         ecchmatrix[7][182]^sbits[7] |
         ecchmatrix[6][182]^sbits[6] |
         ecchmatrix[5][182]^sbits[5] |
         ecchmatrix[4][182]^sbits[4] |
         ecchmatrix[3][182]^sbits[3] |
         ecchmatrix[2][182]^sbits[2] |
         ecchmatrix[1][182]^sbits[1] |
         ecchmatrix[0][182]^sbits[0]);
  assign biterr_wire[181] = ~(
         ecchmatrix[9][181]^sbits[9] |
         ecchmatrix[8][181]^sbits[8] |
         ecchmatrix[7][181]^sbits[7] |
         ecchmatrix[6][181]^sbits[6] |
         ecchmatrix[5][181]^sbits[5] |
         ecchmatrix[4][181]^sbits[4] |
         ecchmatrix[3][181]^sbits[3] |
         ecchmatrix[2][181]^sbits[2] |
         ecchmatrix[1][181]^sbits[1] |
         ecchmatrix[0][181]^sbits[0]);
  assign biterr_wire[180] = ~(
         ecchmatrix[9][180]^sbits[9] |
         ecchmatrix[8][180]^sbits[8] |
         ecchmatrix[7][180]^sbits[7] |
         ecchmatrix[6][180]^sbits[6] |
         ecchmatrix[5][180]^sbits[5] |
         ecchmatrix[4][180]^sbits[4] |
         ecchmatrix[3][180]^sbits[3] |
         ecchmatrix[2][180]^sbits[2] |
         ecchmatrix[1][180]^sbits[1] |
         ecchmatrix[0][180]^sbits[0]);
  assign biterr_wire[179] = ~(
         ecchmatrix[9][179]^sbits[9] |
         ecchmatrix[8][179]^sbits[8] |
         ecchmatrix[7][179]^sbits[7] |
         ecchmatrix[6][179]^sbits[6] |
         ecchmatrix[5][179]^sbits[5] |
         ecchmatrix[4][179]^sbits[4] |
         ecchmatrix[3][179]^sbits[3] |
         ecchmatrix[2][179]^sbits[2] |
         ecchmatrix[1][179]^sbits[1] |
         ecchmatrix[0][179]^sbits[0]);
  assign biterr_wire[178] = ~(
         ecchmatrix[9][178]^sbits[9] |
         ecchmatrix[8][178]^sbits[8] |
         ecchmatrix[7][178]^sbits[7] |
         ecchmatrix[6][178]^sbits[6] |
         ecchmatrix[5][178]^sbits[5] |
         ecchmatrix[4][178]^sbits[4] |
         ecchmatrix[3][178]^sbits[3] |
         ecchmatrix[2][178]^sbits[2] |
         ecchmatrix[1][178]^sbits[1] |
         ecchmatrix[0][178]^sbits[0]);
  assign biterr_wire[177] = ~(
         ecchmatrix[9][177]^sbits[9] |
         ecchmatrix[8][177]^sbits[8] |
         ecchmatrix[7][177]^sbits[7] |
         ecchmatrix[6][177]^sbits[6] |
         ecchmatrix[5][177]^sbits[5] |
         ecchmatrix[4][177]^sbits[4] |
         ecchmatrix[3][177]^sbits[3] |
         ecchmatrix[2][177]^sbits[2] |
         ecchmatrix[1][177]^sbits[1] |
         ecchmatrix[0][177]^sbits[0]);
  assign biterr_wire[176] = ~(
         ecchmatrix[9][176]^sbits[9] |
         ecchmatrix[8][176]^sbits[8] |
         ecchmatrix[7][176]^sbits[7] |
         ecchmatrix[6][176]^sbits[6] |
         ecchmatrix[5][176]^sbits[5] |
         ecchmatrix[4][176]^sbits[4] |
         ecchmatrix[3][176]^sbits[3] |
         ecchmatrix[2][176]^sbits[2] |
         ecchmatrix[1][176]^sbits[1] |
         ecchmatrix[0][176]^sbits[0]);
  assign biterr_wire[175] = ~(
         ecchmatrix[9][175]^sbits[9] |
         ecchmatrix[8][175]^sbits[8] |
         ecchmatrix[7][175]^sbits[7] |
         ecchmatrix[6][175]^sbits[6] |
         ecchmatrix[5][175]^sbits[5] |
         ecchmatrix[4][175]^sbits[4] |
         ecchmatrix[3][175]^sbits[3] |
         ecchmatrix[2][175]^sbits[2] |
         ecchmatrix[1][175]^sbits[1] |
         ecchmatrix[0][175]^sbits[0]);
  assign biterr_wire[174] = ~(
         ecchmatrix[9][174]^sbits[9] |
         ecchmatrix[8][174]^sbits[8] |
         ecchmatrix[7][174]^sbits[7] |
         ecchmatrix[6][174]^sbits[6] |
         ecchmatrix[5][174]^sbits[5] |
         ecchmatrix[4][174]^sbits[4] |
         ecchmatrix[3][174]^sbits[3] |
         ecchmatrix[2][174]^sbits[2] |
         ecchmatrix[1][174]^sbits[1] |
         ecchmatrix[0][174]^sbits[0]);
  assign biterr_wire[173] = ~(
         ecchmatrix[9][173]^sbits[9] |
         ecchmatrix[8][173]^sbits[8] |
         ecchmatrix[7][173]^sbits[7] |
         ecchmatrix[6][173]^sbits[6] |
         ecchmatrix[5][173]^sbits[5] |
         ecchmatrix[4][173]^sbits[4] |
         ecchmatrix[3][173]^sbits[3] |
         ecchmatrix[2][173]^sbits[2] |
         ecchmatrix[1][173]^sbits[1] |
         ecchmatrix[0][173]^sbits[0]);
  assign biterr_wire[172] = ~(
         ecchmatrix[9][172]^sbits[9] |
         ecchmatrix[8][172]^sbits[8] |
         ecchmatrix[7][172]^sbits[7] |
         ecchmatrix[6][172]^sbits[6] |
         ecchmatrix[5][172]^sbits[5] |
         ecchmatrix[4][172]^sbits[4] |
         ecchmatrix[3][172]^sbits[3] |
         ecchmatrix[2][172]^sbits[2] |
         ecchmatrix[1][172]^sbits[1] |
         ecchmatrix[0][172]^sbits[0]);
  assign biterr_wire[171] = ~(
         ecchmatrix[9][171]^sbits[9] |
         ecchmatrix[8][171]^sbits[8] |
         ecchmatrix[7][171]^sbits[7] |
         ecchmatrix[6][171]^sbits[6] |
         ecchmatrix[5][171]^sbits[5] |
         ecchmatrix[4][171]^sbits[4] |
         ecchmatrix[3][171]^sbits[3] |
         ecchmatrix[2][171]^sbits[2] |
         ecchmatrix[1][171]^sbits[1] |
         ecchmatrix[0][171]^sbits[0]);
  assign biterr_wire[170] = ~(
         ecchmatrix[9][170]^sbits[9] |
         ecchmatrix[8][170]^sbits[8] |
         ecchmatrix[7][170]^sbits[7] |
         ecchmatrix[6][170]^sbits[6] |
         ecchmatrix[5][170]^sbits[5] |
         ecchmatrix[4][170]^sbits[4] |
         ecchmatrix[3][170]^sbits[3] |
         ecchmatrix[2][170]^sbits[2] |
         ecchmatrix[1][170]^sbits[1] |
         ecchmatrix[0][170]^sbits[0]);
  assign biterr_wire[169] = ~(
         ecchmatrix[9][169]^sbits[9] |
         ecchmatrix[8][169]^sbits[8] |
         ecchmatrix[7][169]^sbits[7] |
         ecchmatrix[6][169]^sbits[6] |
         ecchmatrix[5][169]^sbits[5] |
         ecchmatrix[4][169]^sbits[4] |
         ecchmatrix[3][169]^sbits[3] |
         ecchmatrix[2][169]^sbits[2] |
         ecchmatrix[1][169]^sbits[1] |
         ecchmatrix[0][169]^sbits[0]);
  assign biterr_wire[168] = ~(
         ecchmatrix[9][168]^sbits[9] |
         ecchmatrix[8][168]^sbits[8] |
         ecchmatrix[7][168]^sbits[7] |
         ecchmatrix[6][168]^sbits[6] |
         ecchmatrix[5][168]^sbits[5] |
         ecchmatrix[4][168]^sbits[4] |
         ecchmatrix[3][168]^sbits[3] |
         ecchmatrix[2][168]^sbits[2] |
         ecchmatrix[1][168]^sbits[1] |
         ecchmatrix[0][168]^sbits[0]);
  assign biterr_wire[167] = ~(
         ecchmatrix[9][167]^sbits[9] |
         ecchmatrix[8][167]^sbits[8] |
         ecchmatrix[7][167]^sbits[7] |
         ecchmatrix[6][167]^sbits[6] |
         ecchmatrix[5][167]^sbits[5] |
         ecchmatrix[4][167]^sbits[4] |
         ecchmatrix[3][167]^sbits[3] |
         ecchmatrix[2][167]^sbits[2] |
         ecchmatrix[1][167]^sbits[1] |
         ecchmatrix[0][167]^sbits[0]);
  assign biterr_wire[166] = ~(
         ecchmatrix[9][166]^sbits[9] |
         ecchmatrix[8][166]^sbits[8] |
         ecchmatrix[7][166]^sbits[7] |
         ecchmatrix[6][166]^sbits[6] |
         ecchmatrix[5][166]^sbits[5] |
         ecchmatrix[4][166]^sbits[4] |
         ecchmatrix[3][166]^sbits[3] |
         ecchmatrix[2][166]^sbits[2] |
         ecchmatrix[1][166]^sbits[1] |
         ecchmatrix[0][166]^sbits[0]);
  assign biterr_wire[165] = ~(
         ecchmatrix[9][165]^sbits[9] |
         ecchmatrix[8][165]^sbits[8] |
         ecchmatrix[7][165]^sbits[7] |
         ecchmatrix[6][165]^sbits[6] |
         ecchmatrix[5][165]^sbits[5] |
         ecchmatrix[4][165]^sbits[4] |
         ecchmatrix[3][165]^sbits[3] |
         ecchmatrix[2][165]^sbits[2] |
         ecchmatrix[1][165]^sbits[1] |
         ecchmatrix[0][165]^sbits[0]);
  assign biterr_wire[164] = ~(
         ecchmatrix[9][164]^sbits[9] |
         ecchmatrix[8][164]^sbits[8] |
         ecchmatrix[7][164]^sbits[7] |
         ecchmatrix[6][164]^sbits[6] |
         ecchmatrix[5][164]^sbits[5] |
         ecchmatrix[4][164]^sbits[4] |
         ecchmatrix[3][164]^sbits[3] |
         ecchmatrix[2][164]^sbits[2] |
         ecchmatrix[1][164]^sbits[1] |
         ecchmatrix[0][164]^sbits[0]);
  assign biterr_wire[163] = ~(
         ecchmatrix[9][163]^sbits[9] |
         ecchmatrix[8][163]^sbits[8] |
         ecchmatrix[7][163]^sbits[7] |
         ecchmatrix[6][163]^sbits[6] |
         ecchmatrix[5][163]^sbits[5] |
         ecchmatrix[4][163]^sbits[4] |
         ecchmatrix[3][163]^sbits[3] |
         ecchmatrix[2][163]^sbits[2] |
         ecchmatrix[1][163]^sbits[1] |
         ecchmatrix[0][163]^sbits[0]);
  assign biterr_wire[162] = ~(
         ecchmatrix[9][162]^sbits[9] |
         ecchmatrix[8][162]^sbits[8] |
         ecchmatrix[7][162]^sbits[7] |
         ecchmatrix[6][162]^sbits[6] |
         ecchmatrix[5][162]^sbits[5] |
         ecchmatrix[4][162]^sbits[4] |
         ecchmatrix[3][162]^sbits[3] |
         ecchmatrix[2][162]^sbits[2] |
         ecchmatrix[1][162]^sbits[1] |
         ecchmatrix[0][162]^sbits[0]);
  assign biterr_wire[161] = ~(
         ecchmatrix[9][161]^sbits[9] |
         ecchmatrix[8][161]^sbits[8] |
         ecchmatrix[7][161]^sbits[7] |
         ecchmatrix[6][161]^sbits[6] |
         ecchmatrix[5][161]^sbits[5] |
         ecchmatrix[4][161]^sbits[4] |
         ecchmatrix[3][161]^sbits[3] |
         ecchmatrix[2][161]^sbits[2] |
         ecchmatrix[1][161]^sbits[1] |
         ecchmatrix[0][161]^sbits[0]);
  assign biterr_wire[160] = ~(
         ecchmatrix[9][160]^sbits[9] |
         ecchmatrix[8][160]^sbits[8] |
         ecchmatrix[7][160]^sbits[7] |
         ecchmatrix[6][160]^sbits[6] |
         ecchmatrix[5][160]^sbits[5] |
         ecchmatrix[4][160]^sbits[4] |
         ecchmatrix[3][160]^sbits[3] |
         ecchmatrix[2][160]^sbits[2] |
         ecchmatrix[1][160]^sbits[1] |
         ecchmatrix[0][160]^sbits[0]);
  assign biterr_wire[159] = ~(
         ecchmatrix[9][159]^sbits[9] |
         ecchmatrix[8][159]^sbits[8] |
         ecchmatrix[7][159]^sbits[7] |
         ecchmatrix[6][159]^sbits[6] |
         ecchmatrix[5][159]^sbits[5] |
         ecchmatrix[4][159]^sbits[4] |
         ecchmatrix[3][159]^sbits[3] |
         ecchmatrix[2][159]^sbits[2] |
         ecchmatrix[1][159]^sbits[1] |
         ecchmatrix[0][159]^sbits[0]);
  assign biterr_wire[158] = ~(
         ecchmatrix[9][158]^sbits[9] |
         ecchmatrix[8][158]^sbits[8] |
         ecchmatrix[7][158]^sbits[7] |
         ecchmatrix[6][158]^sbits[6] |
         ecchmatrix[5][158]^sbits[5] |
         ecchmatrix[4][158]^sbits[4] |
         ecchmatrix[3][158]^sbits[3] |
         ecchmatrix[2][158]^sbits[2] |
         ecchmatrix[1][158]^sbits[1] |
         ecchmatrix[0][158]^sbits[0]);
  assign biterr_wire[157] = ~(
         ecchmatrix[9][157]^sbits[9] |
         ecchmatrix[8][157]^sbits[8] |
         ecchmatrix[7][157]^sbits[7] |
         ecchmatrix[6][157]^sbits[6] |
         ecchmatrix[5][157]^sbits[5] |
         ecchmatrix[4][157]^sbits[4] |
         ecchmatrix[3][157]^sbits[3] |
         ecchmatrix[2][157]^sbits[2] |
         ecchmatrix[1][157]^sbits[1] |
         ecchmatrix[0][157]^sbits[0]);
  assign biterr_wire[156] = ~(
         ecchmatrix[9][156]^sbits[9] |
         ecchmatrix[8][156]^sbits[8] |
         ecchmatrix[7][156]^sbits[7] |
         ecchmatrix[6][156]^sbits[6] |
         ecchmatrix[5][156]^sbits[5] |
         ecchmatrix[4][156]^sbits[4] |
         ecchmatrix[3][156]^sbits[3] |
         ecchmatrix[2][156]^sbits[2] |
         ecchmatrix[1][156]^sbits[1] |
         ecchmatrix[0][156]^sbits[0]);
  assign biterr_wire[155] = ~(
         ecchmatrix[9][155]^sbits[9] |
         ecchmatrix[8][155]^sbits[8] |
         ecchmatrix[7][155]^sbits[7] |
         ecchmatrix[6][155]^sbits[6] |
         ecchmatrix[5][155]^sbits[5] |
         ecchmatrix[4][155]^sbits[4] |
         ecchmatrix[3][155]^sbits[3] |
         ecchmatrix[2][155]^sbits[2] |
         ecchmatrix[1][155]^sbits[1] |
         ecchmatrix[0][155]^sbits[0]);
  assign biterr_wire[154] = ~(
         ecchmatrix[9][154]^sbits[9] |
         ecchmatrix[8][154]^sbits[8] |
         ecchmatrix[7][154]^sbits[7] |
         ecchmatrix[6][154]^sbits[6] |
         ecchmatrix[5][154]^sbits[5] |
         ecchmatrix[4][154]^sbits[4] |
         ecchmatrix[3][154]^sbits[3] |
         ecchmatrix[2][154]^sbits[2] |
         ecchmatrix[1][154]^sbits[1] |
         ecchmatrix[0][154]^sbits[0]);
  assign biterr_wire[153] = ~(
         ecchmatrix[9][153]^sbits[9] |
         ecchmatrix[8][153]^sbits[8] |
         ecchmatrix[7][153]^sbits[7] |
         ecchmatrix[6][153]^sbits[6] |
         ecchmatrix[5][153]^sbits[5] |
         ecchmatrix[4][153]^sbits[4] |
         ecchmatrix[3][153]^sbits[3] |
         ecchmatrix[2][153]^sbits[2] |
         ecchmatrix[1][153]^sbits[1] |
         ecchmatrix[0][153]^sbits[0]);
  assign biterr_wire[152] = ~(
         ecchmatrix[9][152]^sbits[9] |
         ecchmatrix[8][152]^sbits[8] |
         ecchmatrix[7][152]^sbits[7] |
         ecchmatrix[6][152]^sbits[6] |
         ecchmatrix[5][152]^sbits[5] |
         ecchmatrix[4][152]^sbits[4] |
         ecchmatrix[3][152]^sbits[3] |
         ecchmatrix[2][152]^sbits[2] |
         ecchmatrix[1][152]^sbits[1] |
         ecchmatrix[0][152]^sbits[0]);
  assign biterr_wire[151] = ~(
         ecchmatrix[9][151]^sbits[9] |
         ecchmatrix[8][151]^sbits[8] |
         ecchmatrix[7][151]^sbits[7] |
         ecchmatrix[6][151]^sbits[6] |
         ecchmatrix[5][151]^sbits[5] |
         ecchmatrix[4][151]^sbits[4] |
         ecchmatrix[3][151]^sbits[3] |
         ecchmatrix[2][151]^sbits[2] |
         ecchmatrix[1][151]^sbits[1] |
         ecchmatrix[0][151]^sbits[0]);
  assign biterr_wire[150] = ~(
         ecchmatrix[9][150]^sbits[9] |
         ecchmatrix[8][150]^sbits[8] |
         ecchmatrix[7][150]^sbits[7] |
         ecchmatrix[6][150]^sbits[6] |
         ecchmatrix[5][150]^sbits[5] |
         ecchmatrix[4][150]^sbits[4] |
         ecchmatrix[3][150]^sbits[3] |
         ecchmatrix[2][150]^sbits[2] |
         ecchmatrix[1][150]^sbits[1] |
         ecchmatrix[0][150]^sbits[0]);
  assign biterr_wire[149] = ~(
         ecchmatrix[9][149]^sbits[9] |
         ecchmatrix[8][149]^sbits[8] |
         ecchmatrix[7][149]^sbits[7] |
         ecchmatrix[6][149]^sbits[6] |
         ecchmatrix[5][149]^sbits[5] |
         ecchmatrix[4][149]^sbits[4] |
         ecchmatrix[3][149]^sbits[3] |
         ecchmatrix[2][149]^sbits[2] |
         ecchmatrix[1][149]^sbits[1] |
         ecchmatrix[0][149]^sbits[0]);
  assign biterr_wire[148] = ~(
         ecchmatrix[9][148]^sbits[9] |
         ecchmatrix[8][148]^sbits[8] |
         ecchmatrix[7][148]^sbits[7] |
         ecchmatrix[6][148]^sbits[6] |
         ecchmatrix[5][148]^sbits[5] |
         ecchmatrix[4][148]^sbits[4] |
         ecchmatrix[3][148]^sbits[3] |
         ecchmatrix[2][148]^sbits[2] |
         ecchmatrix[1][148]^sbits[1] |
         ecchmatrix[0][148]^sbits[0]);
  assign biterr_wire[147] = ~(
         ecchmatrix[9][147]^sbits[9] |
         ecchmatrix[8][147]^sbits[8] |
         ecchmatrix[7][147]^sbits[7] |
         ecchmatrix[6][147]^sbits[6] |
         ecchmatrix[5][147]^sbits[5] |
         ecchmatrix[4][147]^sbits[4] |
         ecchmatrix[3][147]^sbits[3] |
         ecchmatrix[2][147]^sbits[2] |
         ecchmatrix[1][147]^sbits[1] |
         ecchmatrix[0][147]^sbits[0]);
  assign biterr_wire[146] = ~(
         ecchmatrix[9][146]^sbits[9] |
         ecchmatrix[8][146]^sbits[8] |
         ecchmatrix[7][146]^sbits[7] |
         ecchmatrix[6][146]^sbits[6] |
         ecchmatrix[5][146]^sbits[5] |
         ecchmatrix[4][146]^sbits[4] |
         ecchmatrix[3][146]^sbits[3] |
         ecchmatrix[2][146]^sbits[2] |
         ecchmatrix[1][146]^sbits[1] |
         ecchmatrix[0][146]^sbits[0]);
  assign biterr_wire[145] = ~(
         ecchmatrix[9][145]^sbits[9] |
         ecchmatrix[8][145]^sbits[8] |
         ecchmatrix[7][145]^sbits[7] |
         ecchmatrix[6][145]^sbits[6] |
         ecchmatrix[5][145]^sbits[5] |
         ecchmatrix[4][145]^sbits[4] |
         ecchmatrix[3][145]^sbits[3] |
         ecchmatrix[2][145]^sbits[2] |
         ecchmatrix[1][145]^sbits[1] |
         ecchmatrix[0][145]^sbits[0]);
  assign biterr_wire[144] = ~(
         ecchmatrix[9][144]^sbits[9] |
         ecchmatrix[8][144]^sbits[8] |
         ecchmatrix[7][144]^sbits[7] |
         ecchmatrix[6][144]^sbits[6] |
         ecchmatrix[5][144]^sbits[5] |
         ecchmatrix[4][144]^sbits[4] |
         ecchmatrix[3][144]^sbits[3] |
         ecchmatrix[2][144]^sbits[2] |
         ecchmatrix[1][144]^sbits[1] |
         ecchmatrix[0][144]^sbits[0]);
  assign biterr_wire[143] = ~(
         ecchmatrix[9][143]^sbits[9] |
         ecchmatrix[8][143]^sbits[8] |
         ecchmatrix[7][143]^sbits[7] |
         ecchmatrix[6][143]^sbits[6] |
         ecchmatrix[5][143]^sbits[5] |
         ecchmatrix[4][143]^sbits[4] |
         ecchmatrix[3][143]^sbits[3] |
         ecchmatrix[2][143]^sbits[2] |
         ecchmatrix[1][143]^sbits[1] |
         ecchmatrix[0][143]^sbits[0]);
  assign biterr_wire[142] = ~(
         ecchmatrix[9][142]^sbits[9] |
         ecchmatrix[8][142]^sbits[8] |
         ecchmatrix[7][142]^sbits[7] |
         ecchmatrix[6][142]^sbits[6] |
         ecchmatrix[5][142]^sbits[5] |
         ecchmatrix[4][142]^sbits[4] |
         ecchmatrix[3][142]^sbits[3] |
         ecchmatrix[2][142]^sbits[2] |
         ecchmatrix[1][142]^sbits[1] |
         ecchmatrix[0][142]^sbits[0]);
  assign biterr_wire[141] = ~(
         ecchmatrix[9][141]^sbits[9] |
         ecchmatrix[8][141]^sbits[8] |
         ecchmatrix[7][141]^sbits[7] |
         ecchmatrix[6][141]^sbits[6] |
         ecchmatrix[5][141]^sbits[5] |
         ecchmatrix[4][141]^sbits[4] |
         ecchmatrix[3][141]^sbits[3] |
         ecchmatrix[2][141]^sbits[2] |
         ecchmatrix[1][141]^sbits[1] |
         ecchmatrix[0][141]^sbits[0]);
  assign biterr_wire[140] = ~(
         ecchmatrix[9][140]^sbits[9] |
         ecchmatrix[8][140]^sbits[8] |
         ecchmatrix[7][140]^sbits[7] |
         ecchmatrix[6][140]^sbits[6] |
         ecchmatrix[5][140]^sbits[5] |
         ecchmatrix[4][140]^sbits[4] |
         ecchmatrix[3][140]^sbits[3] |
         ecchmatrix[2][140]^sbits[2] |
         ecchmatrix[1][140]^sbits[1] |
         ecchmatrix[0][140]^sbits[0]);
  assign biterr_wire[139] = ~(
         ecchmatrix[9][139]^sbits[9] |
         ecchmatrix[8][139]^sbits[8] |
         ecchmatrix[7][139]^sbits[7] |
         ecchmatrix[6][139]^sbits[6] |
         ecchmatrix[5][139]^sbits[5] |
         ecchmatrix[4][139]^sbits[4] |
         ecchmatrix[3][139]^sbits[3] |
         ecchmatrix[2][139]^sbits[2] |
         ecchmatrix[1][139]^sbits[1] |
         ecchmatrix[0][139]^sbits[0]);
  assign biterr_wire[138] = ~(
         ecchmatrix[9][138]^sbits[9] |
         ecchmatrix[8][138]^sbits[8] |
         ecchmatrix[7][138]^sbits[7] |
         ecchmatrix[6][138]^sbits[6] |
         ecchmatrix[5][138]^sbits[5] |
         ecchmatrix[4][138]^sbits[4] |
         ecchmatrix[3][138]^sbits[3] |
         ecchmatrix[2][138]^sbits[2] |
         ecchmatrix[1][138]^sbits[1] |
         ecchmatrix[0][138]^sbits[0]);
  assign biterr_wire[137] = ~(
         ecchmatrix[9][137]^sbits[9] |
         ecchmatrix[8][137]^sbits[8] |
         ecchmatrix[7][137]^sbits[7] |
         ecchmatrix[6][137]^sbits[6] |
         ecchmatrix[5][137]^sbits[5] |
         ecchmatrix[4][137]^sbits[4] |
         ecchmatrix[3][137]^sbits[3] |
         ecchmatrix[2][137]^sbits[2] |
         ecchmatrix[1][137]^sbits[1] |
         ecchmatrix[0][137]^sbits[0]);
  assign biterr_wire[136] = ~(
         ecchmatrix[9][136]^sbits[9] |
         ecchmatrix[8][136]^sbits[8] |
         ecchmatrix[7][136]^sbits[7] |
         ecchmatrix[6][136]^sbits[6] |
         ecchmatrix[5][136]^sbits[5] |
         ecchmatrix[4][136]^sbits[4] |
         ecchmatrix[3][136]^sbits[3] |
         ecchmatrix[2][136]^sbits[2] |
         ecchmatrix[1][136]^sbits[1] |
         ecchmatrix[0][136]^sbits[0]);
  assign biterr_wire[135] = ~(
         ecchmatrix[9][135]^sbits[9] |
         ecchmatrix[8][135]^sbits[8] |
         ecchmatrix[7][135]^sbits[7] |
         ecchmatrix[6][135]^sbits[6] |
         ecchmatrix[5][135]^sbits[5] |
         ecchmatrix[4][135]^sbits[4] |
         ecchmatrix[3][135]^sbits[3] |
         ecchmatrix[2][135]^sbits[2] |
         ecchmatrix[1][135]^sbits[1] |
         ecchmatrix[0][135]^sbits[0]);
  assign biterr_wire[134] = ~(
         ecchmatrix[9][134]^sbits[9] |
         ecchmatrix[8][134]^sbits[8] |
         ecchmatrix[7][134]^sbits[7] |
         ecchmatrix[6][134]^sbits[6] |
         ecchmatrix[5][134]^sbits[5] |
         ecchmatrix[4][134]^sbits[4] |
         ecchmatrix[3][134]^sbits[3] |
         ecchmatrix[2][134]^sbits[2] |
         ecchmatrix[1][134]^sbits[1] |
         ecchmatrix[0][134]^sbits[0]);
  assign biterr_wire[133] = ~(
         ecchmatrix[9][133]^sbits[9] |
         ecchmatrix[8][133]^sbits[8] |
         ecchmatrix[7][133]^sbits[7] |
         ecchmatrix[6][133]^sbits[6] |
         ecchmatrix[5][133]^sbits[5] |
         ecchmatrix[4][133]^sbits[4] |
         ecchmatrix[3][133]^sbits[3] |
         ecchmatrix[2][133]^sbits[2] |
         ecchmatrix[1][133]^sbits[1] |
         ecchmatrix[0][133]^sbits[0]);
  assign biterr_wire[132] = ~(
         ecchmatrix[9][132]^sbits[9] |
         ecchmatrix[8][132]^sbits[8] |
         ecchmatrix[7][132]^sbits[7] |
         ecchmatrix[6][132]^sbits[6] |
         ecchmatrix[5][132]^sbits[5] |
         ecchmatrix[4][132]^sbits[4] |
         ecchmatrix[3][132]^sbits[3] |
         ecchmatrix[2][132]^sbits[2] |
         ecchmatrix[1][132]^sbits[1] |
         ecchmatrix[0][132]^sbits[0]);
  assign biterr_wire[131] = ~(
         ecchmatrix[9][131]^sbits[9] |
         ecchmatrix[8][131]^sbits[8] |
         ecchmatrix[7][131]^sbits[7] |
         ecchmatrix[6][131]^sbits[6] |
         ecchmatrix[5][131]^sbits[5] |
         ecchmatrix[4][131]^sbits[4] |
         ecchmatrix[3][131]^sbits[3] |
         ecchmatrix[2][131]^sbits[2] |
         ecchmatrix[1][131]^sbits[1] |
         ecchmatrix[0][131]^sbits[0]);
  assign biterr_wire[130] = ~(
         ecchmatrix[9][130]^sbits[9] |
         ecchmatrix[8][130]^sbits[8] |
         ecchmatrix[7][130]^sbits[7] |
         ecchmatrix[6][130]^sbits[6] |
         ecchmatrix[5][130]^sbits[5] |
         ecchmatrix[4][130]^sbits[4] |
         ecchmatrix[3][130]^sbits[3] |
         ecchmatrix[2][130]^sbits[2] |
         ecchmatrix[1][130]^sbits[1] |
         ecchmatrix[0][130]^sbits[0]);
  assign biterr_wire[129] = ~(
         ecchmatrix[9][129]^sbits[9] |
         ecchmatrix[8][129]^sbits[8] |
         ecchmatrix[7][129]^sbits[7] |
         ecchmatrix[6][129]^sbits[6] |
         ecchmatrix[5][129]^sbits[5] |
         ecchmatrix[4][129]^sbits[4] |
         ecchmatrix[3][129]^sbits[3] |
         ecchmatrix[2][129]^sbits[2] |
         ecchmatrix[1][129]^sbits[1] |
         ecchmatrix[0][129]^sbits[0]);
  assign biterr_wire[128] = ~(
         ecchmatrix[9][128]^sbits[9] |
         ecchmatrix[8][128]^sbits[8] |
         ecchmatrix[7][128]^sbits[7] |
         ecchmatrix[6][128]^sbits[6] |
         ecchmatrix[5][128]^sbits[5] |
         ecchmatrix[4][128]^sbits[4] |
         ecchmatrix[3][128]^sbits[3] |
         ecchmatrix[2][128]^sbits[2] |
         ecchmatrix[1][128]^sbits[1] |
         ecchmatrix[0][128]^sbits[0]);
  assign biterr_wire[127] = ~(
         ecchmatrix[9][127]^sbits[9] |
         ecchmatrix[8][127]^sbits[8] |
         ecchmatrix[7][127]^sbits[7] |
         ecchmatrix[6][127]^sbits[6] |
         ecchmatrix[5][127]^sbits[5] |
         ecchmatrix[4][127]^sbits[4] |
         ecchmatrix[3][127]^sbits[3] |
         ecchmatrix[2][127]^sbits[2] |
         ecchmatrix[1][127]^sbits[1] |
         ecchmatrix[0][127]^sbits[0]);
  assign biterr_wire[126] = ~(
         ecchmatrix[9][126]^sbits[9] |
         ecchmatrix[8][126]^sbits[8] |
         ecchmatrix[7][126]^sbits[7] |
         ecchmatrix[6][126]^sbits[6] |
         ecchmatrix[5][126]^sbits[5] |
         ecchmatrix[4][126]^sbits[4] |
         ecchmatrix[3][126]^sbits[3] |
         ecchmatrix[2][126]^sbits[2] |
         ecchmatrix[1][126]^sbits[1] |
         ecchmatrix[0][126]^sbits[0]);
  assign biterr_wire[125] = ~(
         ecchmatrix[9][125]^sbits[9] |
         ecchmatrix[8][125]^sbits[8] |
         ecchmatrix[7][125]^sbits[7] |
         ecchmatrix[6][125]^sbits[6] |
         ecchmatrix[5][125]^sbits[5] |
         ecchmatrix[4][125]^sbits[4] |
         ecchmatrix[3][125]^sbits[3] |
         ecchmatrix[2][125]^sbits[2] |
         ecchmatrix[1][125]^sbits[1] |
         ecchmatrix[0][125]^sbits[0]);
  assign biterr_wire[124] = ~(
         ecchmatrix[9][124]^sbits[9] |
         ecchmatrix[8][124]^sbits[8] |
         ecchmatrix[7][124]^sbits[7] |
         ecchmatrix[6][124]^sbits[6] |
         ecchmatrix[5][124]^sbits[5] |
         ecchmatrix[4][124]^sbits[4] |
         ecchmatrix[3][124]^sbits[3] |
         ecchmatrix[2][124]^sbits[2] |
         ecchmatrix[1][124]^sbits[1] |
         ecchmatrix[0][124]^sbits[0]);
  assign biterr_wire[123] = ~(
         ecchmatrix[9][123]^sbits[9] |
         ecchmatrix[8][123]^sbits[8] |
         ecchmatrix[7][123]^sbits[7] |
         ecchmatrix[6][123]^sbits[6] |
         ecchmatrix[5][123]^sbits[5] |
         ecchmatrix[4][123]^sbits[4] |
         ecchmatrix[3][123]^sbits[3] |
         ecchmatrix[2][123]^sbits[2] |
         ecchmatrix[1][123]^sbits[1] |
         ecchmatrix[0][123]^sbits[0]);
  assign biterr_wire[122] = ~(
         ecchmatrix[9][122]^sbits[9] |
         ecchmatrix[8][122]^sbits[8] |
         ecchmatrix[7][122]^sbits[7] |
         ecchmatrix[6][122]^sbits[6] |
         ecchmatrix[5][122]^sbits[5] |
         ecchmatrix[4][122]^sbits[4] |
         ecchmatrix[3][122]^sbits[3] |
         ecchmatrix[2][122]^sbits[2] |
         ecchmatrix[1][122]^sbits[1] |
         ecchmatrix[0][122]^sbits[0]);
  assign biterr_wire[121] = ~(
         ecchmatrix[9][121]^sbits[9] |
         ecchmatrix[8][121]^sbits[8] |
         ecchmatrix[7][121]^sbits[7] |
         ecchmatrix[6][121]^sbits[6] |
         ecchmatrix[5][121]^sbits[5] |
         ecchmatrix[4][121]^sbits[4] |
         ecchmatrix[3][121]^sbits[3] |
         ecchmatrix[2][121]^sbits[2] |
         ecchmatrix[1][121]^sbits[1] |
         ecchmatrix[0][121]^sbits[0]);
  assign biterr_wire[120] = ~(
         ecchmatrix[9][120]^sbits[9] |
         ecchmatrix[8][120]^sbits[8] |
         ecchmatrix[7][120]^sbits[7] |
         ecchmatrix[6][120]^sbits[6] |
         ecchmatrix[5][120]^sbits[5] |
         ecchmatrix[4][120]^sbits[4] |
         ecchmatrix[3][120]^sbits[3] |
         ecchmatrix[2][120]^sbits[2] |
         ecchmatrix[1][120]^sbits[1] |
         ecchmatrix[0][120]^sbits[0]);
  assign biterr_wire[119] = ~(
         ecchmatrix[9][119]^sbits[9] |
         ecchmatrix[8][119]^sbits[8] |
         ecchmatrix[7][119]^sbits[7] |
         ecchmatrix[6][119]^sbits[6] |
         ecchmatrix[5][119]^sbits[5] |
         ecchmatrix[4][119]^sbits[4] |
         ecchmatrix[3][119]^sbits[3] |
         ecchmatrix[2][119]^sbits[2] |
         ecchmatrix[1][119]^sbits[1] |
         ecchmatrix[0][119]^sbits[0]);
  assign biterr_wire[118] = ~(
         ecchmatrix[9][118]^sbits[9] |
         ecchmatrix[8][118]^sbits[8] |
         ecchmatrix[7][118]^sbits[7] |
         ecchmatrix[6][118]^sbits[6] |
         ecchmatrix[5][118]^sbits[5] |
         ecchmatrix[4][118]^sbits[4] |
         ecchmatrix[3][118]^sbits[3] |
         ecchmatrix[2][118]^sbits[2] |
         ecchmatrix[1][118]^sbits[1] |
         ecchmatrix[0][118]^sbits[0]);
  assign biterr_wire[117] = ~(
         ecchmatrix[9][117]^sbits[9] |
         ecchmatrix[8][117]^sbits[8] |
         ecchmatrix[7][117]^sbits[7] |
         ecchmatrix[6][117]^sbits[6] |
         ecchmatrix[5][117]^sbits[5] |
         ecchmatrix[4][117]^sbits[4] |
         ecchmatrix[3][117]^sbits[3] |
         ecchmatrix[2][117]^sbits[2] |
         ecchmatrix[1][117]^sbits[1] |
         ecchmatrix[0][117]^sbits[0]);
  assign biterr_wire[116] = ~(
         ecchmatrix[9][116]^sbits[9] |
         ecchmatrix[8][116]^sbits[8] |
         ecchmatrix[7][116]^sbits[7] |
         ecchmatrix[6][116]^sbits[6] |
         ecchmatrix[5][116]^sbits[5] |
         ecchmatrix[4][116]^sbits[4] |
         ecchmatrix[3][116]^sbits[3] |
         ecchmatrix[2][116]^sbits[2] |
         ecchmatrix[1][116]^sbits[1] |
         ecchmatrix[0][116]^sbits[0]);
  assign biterr_wire[115] = ~(
         ecchmatrix[9][115]^sbits[9] |
         ecchmatrix[8][115]^sbits[8] |
         ecchmatrix[7][115]^sbits[7] |
         ecchmatrix[6][115]^sbits[6] |
         ecchmatrix[5][115]^sbits[5] |
         ecchmatrix[4][115]^sbits[4] |
         ecchmatrix[3][115]^sbits[3] |
         ecchmatrix[2][115]^sbits[2] |
         ecchmatrix[1][115]^sbits[1] |
         ecchmatrix[0][115]^sbits[0]);
  assign biterr_wire[114] = ~(
         ecchmatrix[9][114]^sbits[9] |
         ecchmatrix[8][114]^sbits[8] |
         ecchmatrix[7][114]^sbits[7] |
         ecchmatrix[6][114]^sbits[6] |
         ecchmatrix[5][114]^sbits[5] |
         ecchmatrix[4][114]^sbits[4] |
         ecchmatrix[3][114]^sbits[3] |
         ecchmatrix[2][114]^sbits[2] |
         ecchmatrix[1][114]^sbits[1] |
         ecchmatrix[0][114]^sbits[0]);
  assign biterr_wire[113] = ~(
         ecchmatrix[9][113]^sbits[9] |
         ecchmatrix[8][113]^sbits[8] |
         ecchmatrix[7][113]^sbits[7] |
         ecchmatrix[6][113]^sbits[6] |
         ecchmatrix[5][113]^sbits[5] |
         ecchmatrix[4][113]^sbits[4] |
         ecchmatrix[3][113]^sbits[3] |
         ecchmatrix[2][113]^sbits[2] |
         ecchmatrix[1][113]^sbits[1] |
         ecchmatrix[0][113]^sbits[0]);
  assign biterr_wire[112] = ~(
         ecchmatrix[9][112]^sbits[9] |
         ecchmatrix[8][112]^sbits[8] |
         ecchmatrix[7][112]^sbits[7] |
         ecchmatrix[6][112]^sbits[6] |
         ecchmatrix[5][112]^sbits[5] |
         ecchmatrix[4][112]^sbits[4] |
         ecchmatrix[3][112]^sbits[3] |
         ecchmatrix[2][112]^sbits[2] |
         ecchmatrix[1][112]^sbits[1] |
         ecchmatrix[0][112]^sbits[0]);
  assign biterr_wire[111] = ~(
         ecchmatrix[9][111]^sbits[9] |
         ecchmatrix[8][111]^sbits[8] |
         ecchmatrix[7][111]^sbits[7] |
         ecchmatrix[6][111]^sbits[6] |
         ecchmatrix[5][111]^sbits[5] |
         ecchmatrix[4][111]^sbits[4] |
         ecchmatrix[3][111]^sbits[3] |
         ecchmatrix[2][111]^sbits[2] |
         ecchmatrix[1][111]^sbits[1] |
         ecchmatrix[0][111]^sbits[0]);
  assign biterr_wire[110] = ~(
         ecchmatrix[9][110]^sbits[9] |
         ecchmatrix[8][110]^sbits[8] |
         ecchmatrix[7][110]^sbits[7] |
         ecchmatrix[6][110]^sbits[6] |
         ecchmatrix[5][110]^sbits[5] |
         ecchmatrix[4][110]^sbits[4] |
         ecchmatrix[3][110]^sbits[3] |
         ecchmatrix[2][110]^sbits[2] |
         ecchmatrix[1][110]^sbits[1] |
         ecchmatrix[0][110]^sbits[0]);
  assign biterr_wire[109] = ~(
         ecchmatrix[9][109]^sbits[9] |
         ecchmatrix[8][109]^sbits[8] |
         ecchmatrix[7][109]^sbits[7] |
         ecchmatrix[6][109]^sbits[6] |
         ecchmatrix[5][109]^sbits[5] |
         ecchmatrix[4][109]^sbits[4] |
         ecchmatrix[3][109]^sbits[3] |
         ecchmatrix[2][109]^sbits[2] |
         ecchmatrix[1][109]^sbits[1] |
         ecchmatrix[0][109]^sbits[0]);
  assign biterr_wire[108] = ~(
         ecchmatrix[9][108]^sbits[9] |
         ecchmatrix[8][108]^sbits[8] |
         ecchmatrix[7][108]^sbits[7] |
         ecchmatrix[6][108]^sbits[6] |
         ecchmatrix[5][108]^sbits[5] |
         ecchmatrix[4][108]^sbits[4] |
         ecchmatrix[3][108]^sbits[3] |
         ecchmatrix[2][108]^sbits[2] |
         ecchmatrix[1][108]^sbits[1] |
         ecchmatrix[0][108]^sbits[0]);
  assign biterr_wire[107] = ~(
         ecchmatrix[9][107]^sbits[9] |
         ecchmatrix[8][107]^sbits[8] |
         ecchmatrix[7][107]^sbits[7] |
         ecchmatrix[6][107]^sbits[6] |
         ecchmatrix[5][107]^sbits[5] |
         ecchmatrix[4][107]^sbits[4] |
         ecchmatrix[3][107]^sbits[3] |
         ecchmatrix[2][107]^sbits[2] |
         ecchmatrix[1][107]^sbits[1] |
         ecchmatrix[0][107]^sbits[0]);
  assign biterr_wire[106] = ~(
         ecchmatrix[9][106]^sbits[9] |
         ecchmatrix[8][106]^sbits[8] |
         ecchmatrix[7][106]^sbits[7] |
         ecchmatrix[6][106]^sbits[6] |
         ecchmatrix[5][106]^sbits[5] |
         ecchmatrix[4][106]^sbits[4] |
         ecchmatrix[3][106]^sbits[3] |
         ecchmatrix[2][106]^sbits[2] |
         ecchmatrix[1][106]^sbits[1] |
         ecchmatrix[0][106]^sbits[0]);
  assign biterr_wire[105] = ~(
         ecchmatrix[9][105]^sbits[9] |
         ecchmatrix[8][105]^sbits[8] |
         ecchmatrix[7][105]^sbits[7] |
         ecchmatrix[6][105]^sbits[6] |
         ecchmatrix[5][105]^sbits[5] |
         ecchmatrix[4][105]^sbits[4] |
         ecchmatrix[3][105]^sbits[3] |
         ecchmatrix[2][105]^sbits[2] |
         ecchmatrix[1][105]^sbits[1] |
         ecchmatrix[0][105]^sbits[0]);
  assign biterr_wire[104] = ~(
         ecchmatrix[9][104]^sbits[9] |
         ecchmatrix[8][104]^sbits[8] |
         ecchmatrix[7][104]^sbits[7] |
         ecchmatrix[6][104]^sbits[6] |
         ecchmatrix[5][104]^sbits[5] |
         ecchmatrix[4][104]^sbits[4] |
         ecchmatrix[3][104]^sbits[3] |
         ecchmatrix[2][104]^sbits[2] |
         ecchmatrix[1][104]^sbits[1] |
         ecchmatrix[0][104]^sbits[0]);
  assign biterr_wire[103] = ~(
         ecchmatrix[9][103]^sbits[9] |
         ecchmatrix[8][103]^sbits[8] |
         ecchmatrix[7][103]^sbits[7] |
         ecchmatrix[6][103]^sbits[6] |
         ecchmatrix[5][103]^sbits[5] |
         ecchmatrix[4][103]^sbits[4] |
         ecchmatrix[3][103]^sbits[3] |
         ecchmatrix[2][103]^sbits[2] |
         ecchmatrix[1][103]^sbits[1] |
         ecchmatrix[0][103]^sbits[0]);
  assign biterr_wire[102] = ~(
         ecchmatrix[9][102]^sbits[9] |
         ecchmatrix[8][102]^sbits[8] |
         ecchmatrix[7][102]^sbits[7] |
         ecchmatrix[6][102]^sbits[6] |
         ecchmatrix[5][102]^sbits[5] |
         ecchmatrix[4][102]^sbits[4] |
         ecchmatrix[3][102]^sbits[3] |
         ecchmatrix[2][102]^sbits[2] |
         ecchmatrix[1][102]^sbits[1] |
         ecchmatrix[0][102]^sbits[0]);
  assign biterr_wire[101] = ~(
         ecchmatrix[9][101]^sbits[9] |
         ecchmatrix[8][101]^sbits[8] |
         ecchmatrix[7][101]^sbits[7] |
         ecchmatrix[6][101]^sbits[6] |
         ecchmatrix[5][101]^sbits[5] |
         ecchmatrix[4][101]^sbits[4] |
         ecchmatrix[3][101]^sbits[3] |
         ecchmatrix[2][101]^sbits[2] |
         ecchmatrix[1][101]^sbits[1] |
         ecchmatrix[0][101]^sbits[0]);
  assign biterr_wire[100] = ~(
         ecchmatrix[9][100]^sbits[9] |
         ecchmatrix[8][100]^sbits[8] |
         ecchmatrix[7][100]^sbits[7] |
         ecchmatrix[6][100]^sbits[6] |
         ecchmatrix[5][100]^sbits[5] |
         ecchmatrix[4][100]^sbits[4] |
         ecchmatrix[3][100]^sbits[3] |
         ecchmatrix[2][100]^sbits[2] |
         ecchmatrix[1][100]^sbits[1] |
         ecchmatrix[0][100]^sbits[0]);
  assign biterr_wire[99] = ~(
         ecchmatrix[9][99]^sbits[9] |
         ecchmatrix[8][99]^sbits[8] |
         ecchmatrix[7][99]^sbits[7] |
         ecchmatrix[6][99]^sbits[6] |
         ecchmatrix[5][99]^sbits[5] |
         ecchmatrix[4][99]^sbits[4] |
         ecchmatrix[3][99]^sbits[3] |
         ecchmatrix[2][99]^sbits[2] |
         ecchmatrix[1][99]^sbits[1] |
         ecchmatrix[0][99]^sbits[0]);
  assign biterr_wire[98] = ~(
         ecchmatrix[9][98]^sbits[9] |
         ecchmatrix[8][98]^sbits[8] |
         ecchmatrix[7][98]^sbits[7] |
         ecchmatrix[6][98]^sbits[6] |
         ecchmatrix[5][98]^sbits[5] |
         ecchmatrix[4][98]^sbits[4] |
         ecchmatrix[3][98]^sbits[3] |
         ecchmatrix[2][98]^sbits[2] |
         ecchmatrix[1][98]^sbits[1] |
         ecchmatrix[0][98]^sbits[0]);
  assign biterr_wire[97] = ~(
         ecchmatrix[9][97]^sbits[9] |
         ecchmatrix[8][97]^sbits[8] |
         ecchmatrix[7][97]^sbits[7] |
         ecchmatrix[6][97]^sbits[6] |
         ecchmatrix[5][97]^sbits[5] |
         ecchmatrix[4][97]^sbits[4] |
         ecchmatrix[3][97]^sbits[3] |
         ecchmatrix[2][97]^sbits[2] |
         ecchmatrix[1][97]^sbits[1] |
         ecchmatrix[0][97]^sbits[0]);
  assign biterr_wire[96] = ~(
         ecchmatrix[9][96]^sbits[9] |
         ecchmatrix[8][96]^sbits[8] |
         ecchmatrix[7][96]^sbits[7] |
         ecchmatrix[6][96]^sbits[6] |
         ecchmatrix[5][96]^sbits[5] |
         ecchmatrix[4][96]^sbits[4] |
         ecchmatrix[3][96]^sbits[3] |
         ecchmatrix[2][96]^sbits[2] |
         ecchmatrix[1][96]^sbits[1] |
         ecchmatrix[0][96]^sbits[0]);
  assign biterr_wire[95] = ~(
         ecchmatrix[9][95]^sbits[9] |
         ecchmatrix[8][95]^sbits[8] |
         ecchmatrix[7][95]^sbits[7] |
         ecchmatrix[6][95]^sbits[6] |
         ecchmatrix[5][95]^sbits[5] |
         ecchmatrix[4][95]^sbits[4] |
         ecchmatrix[3][95]^sbits[3] |
         ecchmatrix[2][95]^sbits[2] |
         ecchmatrix[1][95]^sbits[1] |
         ecchmatrix[0][95]^sbits[0]);
  assign biterr_wire[94] = ~(
         ecchmatrix[9][94]^sbits[9] |
         ecchmatrix[8][94]^sbits[8] |
         ecchmatrix[7][94]^sbits[7] |
         ecchmatrix[6][94]^sbits[6] |
         ecchmatrix[5][94]^sbits[5] |
         ecchmatrix[4][94]^sbits[4] |
         ecchmatrix[3][94]^sbits[3] |
         ecchmatrix[2][94]^sbits[2] |
         ecchmatrix[1][94]^sbits[1] |
         ecchmatrix[0][94]^sbits[0]);
  assign biterr_wire[93] = ~(
         ecchmatrix[9][93]^sbits[9] |
         ecchmatrix[8][93]^sbits[8] |
         ecchmatrix[7][93]^sbits[7] |
         ecchmatrix[6][93]^sbits[6] |
         ecchmatrix[5][93]^sbits[5] |
         ecchmatrix[4][93]^sbits[4] |
         ecchmatrix[3][93]^sbits[3] |
         ecchmatrix[2][93]^sbits[2] |
         ecchmatrix[1][93]^sbits[1] |
         ecchmatrix[0][93]^sbits[0]);
  assign biterr_wire[92] = ~(
         ecchmatrix[9][92]^sbits[9] |
         ecchmatrix[8][92]^sbits[8] |
         ecchmatrix[7][92]^sbits[7] |
         ecchmatrix[6][92]^sbits[6] |
         ecchmatrix[5][92]^sbits[5] |
         ecchmatrix[4][92]^sbits[4] |
         ecchmatrix[3][92]^sbits[3] |
         ecchmatrix[2][92]^sbits[2] |
         ecchmatrix[1][92]^sbits[1] |
         ecchmatrix[0][92]^sbits[0]);
  assign biterr_wire[91] = ~(
         ecchmatrix[9][91]^sbits[9] |
         ecchmatrix[8][91]^sbits[8] |
         ecchmatrix[7][91]^sbits[7] |
         ecchmatrix[6][91]^sbits[6] |
         ecchmatrix[5][91]^sbits[5] |
         ecchmatrix[4][91]^sbits[4] |
         ecchmatrix[3][91]^sbits[3] |
         ecchmatrix[2][91]^sbits[2] |
         ecchmatrix[1][91]^sbits[1] |
         ecchmatrix[0][91]^sbits[0]);
  assign biterr_wire[90] = ~(
         ecchmatrix[9][90]^sbits[9] |
         ecchmatrix[8][90]^sbits[8] |
         ecchmatrix[7][90]^sbits[7] |
         ecchmatrix[6][90]^sbits[6] |
         ecchmatrix[5][90]^sbits[5] |
         ecchmatrix[4][90]^sbits[4] |
         ecchmatrix[3][90]^sbits[3] |
         ecchmatrix[2][90]^sbits[2] |
         ecchmatrix[1][90]^sbits[1] |
         ecchmatrix[0][90]^sbits[0]);
  assign biterr_wire[89] = ~(
         ecchmatrix[9][89]^sbits[9] |
         ecchmatrix[8][89]^sbits[8] |
         ecchmatrix[7][89]^sbits[7] |
         ecchmatrix[6][89]^sbits[6] |
         ecchmatrix[5][89]^sbits[5] |
         ecchmatrix[4][89]^sbits[4] |
         ecchmatrix[3][89]^sbits[3] |
         ecchmatrix[2][89]^sbits[2] |
         ecchmatrix[1][89]^sbits[1] |
         ecchmatrix[0][89]^sbits[0]);
  assign biterr_wire[88] = ~(
         ecchmatrix[9][88]^sbits[9] |
         ecchmatrix[8][88]^sbits[8] |
         ecchmatrix[7][88]^sbits[7] |
         ecchmatrix[6][88]^sbits[6] |
         ecchmatrix[5][88]^sbits[5] |
         ecchmatrix[4][88]^sbits[4] |
         ecchmatrix[3][88]^sbits[3] |
         ecchmatrix[2][88]^sbits[2] |
         ecchmatrix[1][88]^sbits[1] |
         ecchmatrix[0][88]^sbits[0]);
  assign biterr_wire[87] = ~(
         ecchmatrix[9][87]^sbits[9] |
         ecchmatrix[8][87]^sbits[8] |
         ecchmatrix[7][87]^sbits[7] |
         ecchmatrix[6][87]^sbits[6] |
         ecchmatrix[5][87]^sbits[5] |
         ecchmatrix[4][87]^sbits[4] |
         ecchmatrix[3][87]^sbits[3] |
         ecchmatrix[2][87]^sbits[2] |
         ecchmatrix[1][87]^sbits[1] |
         ecchmatrix[0][87]^sbits[0]);
  assign biterr_wire[86] = ~(
         ecchmatrix[9][86]^sbits[9] |
         ecchmatrix[8][86]^sbits[8] |
         ecchmatrix[7][86]^sbits[7] |
         ecchmatrix[6][86]^sbits[6] |
         ecchmatrix[5][86]^sbits[5] |
         ecchmatrix[4][86]^sbits[4] |
         ecchmatrix[3][86]^sbits[3] |
         ecchmatrix[2][86]^sbits[2] |
         ecchmatrix[1][86]^sbits[1] |
         ecchmatrix[0][86]^sbits[0]);
  assign biterr_wire[85] = ~(
         ecchmatrix[9][85]^sbits[9] |
         ecchmatrix[8][85]^sbits[8] |
         ecchmatrix[7][85]^sbits[7] |
         ecchmatrix[6][85]^sbits[6] |
         ecchmatrix[5][85]^sbits[5] |
         ecchmatrix[4][85]^sbits[4] |
         ecchmatrix[3][85]^sbits[3] |
         ecchmatrix[2][85]^sbits[2] |
         ecchmatrix[1][85]^sbits[1] |
         ecchmatrix[0][85]^sbits[0]);
  assign biterr_wire[84] = ~(
         ecchmatrix[9][84]^sbits[9] |
         ecchmatrix[8][84]^sbits[8] |
         ecchmatrix[7][84]^sbits[7] |
         ecchmatrix[6][84]^sbits[6] |
         ecchmatrix[5][84]^sbits[5] |
         ecchmatrix[4][84]^sbits[4] |
         ecchmatrix[3][84]^sbits[3] |
         ecchmatrix[2][84]^sbits[2] |
         ecchmatrix[1][84]^sbits[1] |
         ecchmatrix[0][84]^sbits[0]);
  assign biterr_wire[83] = ~(
         ecchmatrix[9][83]^sbits[9] |
         ecchmatrix[8][83]^sbits[8] |
         ecchmatrix[7][83]^sbits[7] |
         ecchmatrix[6][83]^sbits[6] |
         ecchmatrix[5][83]^sbits[5] |
         ecchmatrix[4][83]^sbits[4] |
         ecchmatrix[3][83]^sbits[3] |
         ecchmatrix[2][83]^sbits[2] |
         ecchmatrix[1][83]^sbits[1] |
         ecchmatrix[0][83]^sbits[0]);
  assign biterr_wire[82] = ~(
         ecchmatrix[9][82]^sbits[9] |
         ecchmatrix[8][82]^sbits[8] |
         ecchmatrix[7][82]^sbits[7] |
         ecchmatrix[6][82]^sbits[6] |
         ecchmatrix[5][82]^sbits[5] |
         ecchmatrix[4][82]^sbits[4] |
         ecchmatrix[3][82]^sbits[3] |
         ecchmatrix[2][82]^sbits[2] |
         ecchmatrix[1][82]^sbits[1] |
         ecchmatrix[0][82]^sbits[0]);
  assign biterr_wire[81] = ~(
         ecchmatrix[9][81]^sbits[9] |
         ecchmatrix[8][81]^sbits[8] |
         ecchmatrix[7][81]^sbits[7] |
         ecchmatrix[6][81]^sbits[6] |
         ecchmatrix[5][81]^sbits[5] |
         ecchmatrix[4][81]^sbits[4] |
         ecchmatrix[3][81]^sbits[3] |
         ecchmatrix[2][81]^sbits[2] |
         ecchmatrix[1][81]^sbits[1] |
         ecchmatrix[0][81]^sbits[0]);
  assign biterr_wire[80] = ~(
         ecchmatrix[9][80]^sbits[9] |
         ecchmatrix[8][80]^sbits[8] |
         ecchmatrix[7][80]^sbits[7] |
         ecchmatrix[6][80]^sbits[6] |
         ecchmatrix[5][80]^sbits[5] |
         ecchmatrix[4][80]^sbits[4] |
         ecchmatrix[3][80]^sbits[3] |
         ecchmatrix[2][80]^sbits[2] |
         ecchmatrix[1][80]^sbits[1] |
         ecchmatrix[0][80]^sbits[0]);
  assign biterr_wire[79] = ~(
         ecchmatrix[9][79]^sbits[9] |
         ecchmatrix[8][79]^sbits[8] |
         ecchmatrix[7][79]^sbits[7] |
         ecchmatrix[6][79]^sbits[6] |
         ecchmatrix[5][79]^sbits[5] |
         ecchmatrix[4][79]^sbits[4] |
         ecchmatrix[3][79]^sbits[3] |
         ecchmatrix[2][79]^sbits[2] |
         ecchmatrix[1][79]^sbits[1] |
         ecchmatrix[0][79]^sbits[0]);
  assign biterr_wire[78] = ~(
         ecchmatrix[9][78]^sbits[9] |
         ecchmatrix[8][78]^sbits[8] |
         ecchmatrix[7][78]^sbits[7] |
         ecchmatrix[6][78]^sbits[6] |
         ecchmatrix[5][78]^sbits[5] |
         ecchmatrix[4][78]^sbits[4] |
         ecchmatrix[3][78]^sbits[3] |
         ecchmatrix[2][78]^sbits[2] |
         ecchmatrix[1][78]^sbits[1] |
         ecchmatrix[0][78]^sbits[0]);
  assign biterr_wire[77] = ~(
         ecchmatrix[9][77]^sbits[9] |
         ecchmatrix[8][77]^sbits[8] |
         ecchmatrix[7][77]^sbits[7] |
         ecchmatrix[6][77]^sbits[6] |
         ecchmatrix[5][77]^sbits[5] |
         ecchmatrix[4][77]^sbits[4] |
         ecchmatrix[3][77]^sbits[3] |
         ecchmatrix[2][77]^sbits[2] |
         ecchmatrix[1][77]^sbits[1] |
         ecchmatrix[0][77]^sbits[0]);
  assign biterr_wire[76] = ~(
         ecchmatrix[9][76]^sbits[9] |
         ecchmatrix[8][76]^sbits[8] |
         ecchmatrix[7][76]^sbits[7] |
         ecchmatrix[6][76]^sbits[6] |
         ecchmatrix[5][76]^sbits[5] |
         ecchmatrix[4][76]^sbits[4] |
         ecchmatrix[3][76]^sbits[3] |
         ecchmatrix[2][76]^sbits[2] |
         ecchmatrix[1][76]^sbits[1] |
         ecchmatrix[0][76]^sbits[0]);
  assign biterr_wire[75] = ~(
         ecchmatrix[9][75]^sbits[9] |
         ecchmatrix[8][75]^sbits[8] |
         ecchmatrix[7][75]^sbits[7] |
         ecchmatrix[6][75]^sbits[6] |
         ecchmatrix[5][75]^sbits[5] |
         ecchmatrix[4][75]^sbits[4] |
         ecchmatrix[3][75]^sbits[3] |
         ecchmatrix[2][75]^sbits[2] |
         ecchmatrix[1][75]^sbits[1] |
         ecchmatrix[0][75]^sbits[0]);
  assign biterr_wire[74] = ~(
         ecchmatrix[9][74]^sbits[9] |
         ecchmatrix[8][74]^sbits[8] |
         ecchmatrix[7][74]^sbits[7] |
         ecchmatrix[6][74]^sbits[6] |
         ecchmatrix[5][74]^sbits[5] |
         ecchmatrix[4][74]^sbits[4] |
         ecchmatrix[3][74]^sbits[3] |
         ecchmatrix[2][74]^sbits[2] |
         ecchmatrix[1][74]^sbits[1] |
         ecchmatrix[0][74]^sbits[0]);
  assign biterr_wire[73] = ~(
         ecchmatrix[9][73]^sbits[9] |
         ecchmatrix[8][73]^sbits[8] |
         ecchmatrix[7][73]^sbits[7] |
         ecchmatrix[6][73]^sbits[6] |
         ecchmatrix[5][73]^sbits[5] |
         ecchmatrix[4][73]^sbits[4] |
         ecchmatrix[3][73]^sbits[3] |
         ecchmatrix[2][73]^sbits[2] |
         ecchmatrix[1][73]^sbits[1] |
         ecchmatrix[0][73]^sbits[0]);
  assign biterr_wire[72] = ~(
         ecchmatrix[9][72]^sbits[9] |
         ecchmatrix[8][72]^sbits[8] |
         ecchmatrix[7][72]^sbits[7] |
         ecchmatrix[6][72]^sbits[6] |
         ecchmatrix[5][72]^sbits[5] |
         ecchmatrix[4][72]^sbits[4] |
         ecchmatrix[3][72]^sbits[3] |
         ecchmatrix[2][72]^sbits[2] |
         ecchmatrix[1][72]^sbits[1] |
         ecchmatrix[0][72]^sbits[0]);
  assign biterr_wire[71] = ~(
         ecchmatrix[9][71]^sbits[9] |
         ecchmatrix[8][71]^sbits[8] |
         ecchmatrix[7][71]^sbits[7] |
         ecchmatrix[6][71]^sbits[6] |
         ecchmatrix[5][71]^sbits[5] |
         ecchmatrix[4][71]^sbits[4] |
         ecchmatrix[3][71]^sbits[3] |
         ecchmatrix[2][71]^sbits[2] |
         ecchmatrix[1][71]^sbits[1] |
         ecchmatrix[0][71]^sbits[0]);
  assign biterr_wire[70] = ~(
         ecchmatrix[9][70]^sbits[9] |
         ecchmatrix[8][70]^sbits[8] |
         ecchmatrix[7][70]^sbits[7] |
         ecchmatrix[6][70]^sbits[6] |
         ecchmatrix[5][70]^sbits[5] |
         ecchmatrix[4][70]^sbits[4] |
         ecchmatrix[3][70]^sbits[3] |
         ecchmatrix[2][70]^sbits[2] |
         ecchmatrix[1][70]^sbits[1] |
         ecchmatrix[0][70]^sbits[0]);
  assign biterr_wire[69] = ~(
         ecchmatrix[9][69]^sbits[9] |
         ecchmatrix[8][69]^sbits[8] |
         ecchmatrix[7][69]^sbits[7] |
         ecchmatrix[6][69]^sbits[6] |
         ecchmatrix[5][69]^sbits[5] |
         ecchmatrix[4][69]^sbits[4] |
         ecchmatrix[3][69]^sbits[3] |
         ecchmatrix[2][69]^sbits[2] |
         ecchmatrix[1][69]^sbits[1] |
         ecchmatrix[0][69]^sbits[0]);
  assign biterr_wire[68] = ~(
         ecchmatrix[9][68]^sbits[9] |
         ecchmatrix[8][68]^sbits[8] |
         ecchmatrix[7][68]^sbits[7] |
         ecchmatrix[6][68]^sbits[6] |
         ecchmatrix[5][68]^sbits[5] |
         ecchmatrix[4][68]^sbits[4] |
         ecchmatrix[3][68]^sbits[3] |
         ecchmatrix[2][68]^sbits[2] |
         ecchmatrix[1][68]^sbits[1] |
         ecchmatrix[0][68]^sbits[0]);
  assign biterr_wire[67] = ~(
         ecchmatrix[9][67]^sbits[9] |
         ecchmatrix[8][67]^sbits[8] |
         ecchmatrix[7][67]^sbits[7] |
         ecchmatrix[6][67]^sbits[6] |
         ecchmatrix[5][67]^sbits[5] |
         ecchmatrix[4][67]^sbits[4] |
         ecchmatrix[3][67]^sbits[3] |
         ecchmatrix[2][67]^sbits[2] |
         ecchmatrix[1][67]^sbits[1] |
         ecchmatrix[0][67]^sbits[0]);
  assign biterr_wire[66] = ~(
         ecchmatrix[9][66]^sbits[9] |
         ecchmatrix[8][66]^sbits[8] |
         ecchmatrix[7][66]^sbits[7] |
         ecchmatrix[6][66]^sbits[6] |
         ecchmatrix[5][66]^sbits[5] |
         ecchmatrix[4][66]^sbits[4] |
         ecchmatrix[3][66]^sbits[3] |
         ecchmatrix[2][66]^sbits[2] |
         ecchmatrix[1][66]^sbits[1] |
         ecchmatrix[0][66]^sbits[0]);
  assign biterr_wire[65] = ~(
         ecchmatrix[9][65]^sbits[9] |
         ecchmatrix[8][65]^sbits[8] |
         ecchmatrix[7][65]^sbits[7] |
         ecchmatrix[6][65]^sbits[6] |
         ecchmatrix[5][65]^sbits[5] |
         ecchmatrix[4][65]^sbits[4] |
         ecchmatrix[3][65]^sbits[3] |
         ecchmatrix[2][65]^sbits[2] |
         ecchmatrix[1][65]^sbits[1] |
         ecchmatrix[0][65]^sbits[0]);
  assign biterr_wire[64] = ~(
         ecchmatrix[9][64]^sbits[9] |
         ecchmatrix[8][64]^sbits[8] |
         ecchmatrix[7][64]^sbits[7] |
         ecchmatrix[6][64]^sbits[6] |
         ecchmatrix[5][64]^sbits[5] |
         ecchmatrix[4][64]^sbits[4] |
         ecchmatrix[3][64]^sbits[3] |
         ecchmatrix[2][64]^sbits[2] |
         ecchmatrix[1][64]^sbits[1] |
         ecchmatrix[0][64]^sbits[0]);
  assign biterr_wire[63] = ~(
         ecchmatrix[9][63]^sbits[9] |
         ecchmatrix[8][63]^sbits[8] |
         ecchmatrix[7][63]^sbits[7] |
         ecchmatrix[6][63]^sbits[6] |
         ecchmatrix[5][63]^sbits[5] |
         ecchmatrix[4][63]^sbits[4] |
         ecchmatrix[3][63]^sbits[3] |
         ecchmatrix[2][63]^sbits[2] |
         ecchmatrix[1][63]^sbits[1] |
         ecchmatrix[0][63]^sbits[0]);
  assign biterr_wire[62] = ~(
         ecchmatrix[9][62]^sbits[9] |
         ecchmatrix[8][62]^sbits[8] |
         ecchmatrix[7][62]^sbits[7] |
         ecchmatrix[6][62]^sbits[6] |
         ecchmatrix[5][62]^sbits[5] |
         ecchmatrix[4][62]^sbits[4] |
         ecchmatrix[3][62]^sbits[3] |
         ecchmatrix[2][62]^sbits[2] |
         ecchmatrix[1][62]^sbits[1] |
         ecchmatrix[0][62]^sbits[0]);
  assign biterr_wire[61] = ~(
         ecchmatrix[9][61]^sbits[9] |
         ecchmatrix[8][61]^sbits[8] |
         ecchmatrix[7][61]^sbits[7] |
         ecchmatrix[6][61]^sbits[6] |
         ecchmatrix[5][61]^sbits[5] |
         ecchmatrix[4][61]^sbits[4] |
         ecchmatrix[3][61]^sbits[3] |
         ecchmatrix[2][61]^sbits[2] |
         ecchmatrix[1][61]^sbits[1] |
         ecchmatrix[0][61]^sbits[0]);
  assign biterr_wire[60] = ~(
         ecchmatrix[9][60]^sbits[9] |
         ecchmatrix[8][60]^sbits[8] |
         ecchmatrix[7][60]^sbits[7] |
         ecchmatrix[6][60]^sbits[6] |
         ecchmatrix[5][60]^sbits[5] |
         ecchmatrix[4][60]^sbits[4] |
         ecchmatrix[3][60]^sbits[3] |
         ecchmatrix[2][60]^sbits[2] |
         ecchmatrix[1][60]^sbits[1] |
         ecchmatrix[0][60]^sbits[0]);
  assign biterr_wire[59] = ~(
         ecchmatrix[9][59]^sbits[9] |
         ecchmatrix[8][59]^sbits[8] |
         ecchmatrix[7][59]^sbits[7] |
         ecchmatrix[6][59]^sbits[6] |
         ecchmatrix[5][59]^sbits[5] |
         ecchmatrix[4][59]^sbits[4] |
         ecchmatrix[3][59]^sbits[3] |
         ecchmatrix[2][59]^sbits[2] |
         ecchmatrix[1][59]^sbits[1] |
         ecchmatrix[0][59]^sbits[0]);
  assign biterr_wire[58] = ~(
         ecchmatrix[9][58]^sbits[9] |
         ecchmatrix[8][58]^sbits[8] |
         ecchmatrix[7][58]^sbits[7] |
         ecchmatrix[6][58]^sbits[6] |
         ecchmatrix[5][58]^sbits[5] |
         ecchmatrix[4][58]^sbits[4] |
         ecchmatrix[3][58]^sbits[3] |
         ecchmatrix[2][58]^sbits[2] |
         ecchmatrix[1][58]^sbits[1] |
         ecchmatrix[0][58]^sbits[0]);
  assign biterr_wire[57] = ~(
         ecchmatrix[9][57]^sbits[9] |
         ecchmatrix[8][57]^sbits[8] |
         ecchmatrix[7][57]^sbits[7] |
         ecchmatrix[6][57]^sbits[6] |
         ecchmatrix[5][57]^sbits[5] |
         ecchmatrix[4][57]^sbits[4] |
         ecchmatrix[3][57]^sbits[3] |
         ecchmatrix[2][57]^sbits[2] |
         ecchmatrix[1][57]^sbits[1] |
         ecchmatrix[0][57]^sbits[0]);
  assign biterr_wire[56] = ~(
         ecchmatrix[9][56]^sbits[9] |
         ecchmatrix[8][56]^sbits[8] |
         ecchmatrix[7][56]^sbits[7] |
         ecchmatrix[6][56]^sbits[6] |
         ecchmatrix[5][56]^sbits[5] |
         ecchmatrix[4][56]^sbits[4] |
         ecchmatrix[3][56]^sbits[3] |
         ecchmatrix[2][56]^sbits[2] |
         ecchmatrix[1][56]^sbits[1] |
         ecchmatrix[0][56]^sbits[0]);
  assign biterr_wire[55] = ~(
         ecchmatrix[9][55]^sbits[9] |
         ecchmatrix[8][55]^sbits[8] |
         ecchmatrix[7][55]^sbits[7] |
         ecchmatrix[6][55]^sbits[6] |
         ecchmatrix[5][55]^sbits[5] |
         ecchmatrix[4][55]^sbits[4] |
         ecchmatrix[3][55]^sbits[3] |
         ecchmatrix[2][55]^sbits[2] |
         ecchmatrix[1][55]^sbits[1] |
         ecchmatrix[0][55]^sbits[0]);
  assign biterr_wire[54] = ~(
         ecchmatrix[9][54]^sbits[9] |
         ecchmatrix[8][54]^sbits[8] |
         ecchmatrix[7][54]^sbits[7] |
         ecchmatrix[6][54]^sbits[6] |
         ecchmatrix[5][54]^sbits[5] |
         ecchmatrix[4][54]^sbits[4] |
         ecchmatrix[3][54]^sbits[3] |
         ecchmatrix[2][54]^sbits[2] |
         ecchmatrix[1][54]^sbits[1] |
         ecchmatrix[0][54]^sbits[0]);
  assign biterr_wire[53] = ~(
         ecchmatrix[9][53]^sbits[9] |
         ecchmatrix[8][53]^sbits[8] |
         ecchmatrix[7][53]^sbits[7] |
         ecchmatrix[6][53]^sbits[6] |
         ecchmatrix[5][53]^sbits[5] |
         ecchmatrix[4][53]^sbits[4] |
         ecchmatrix[3][53]^sbits[3] |
         ecchmatrix[2][53]^sbits[2] |
         ecchmatrix[1][53]^sbits[1] |
         ecchmatrix[0][53]^sbits[0]);
  assign biterr_wire[52] = ~(
         ecchmatrix[9][52]^sbits[9] |
         ecchmatrix[8][52]^sbits[8] |
         ecchmatrix[7][52]^sbits[7] |
         ecchmatrix[6][52]^sbits[6] |
         ecchmatrix[5][52]^sbits[5] |
         ecchmatrix[4][52]^sbits[4] |
         ecchmatrix[3][52]^sbits[3] |
         ecchmatrix[2][52]^sbits[2] |
         ecchmatrix[1][52]^sbits[1] |
         ecchmatrix[0][52]^sbits[0]);
  assign biterr_wire[51] = ~(
         ecchmatrix[9][51]^sbits[9] |
         ecchmatrix[8][51]^sbits[8] |
         ecchmatrix[7][51]^sbits[7] |
         ecchmatrix[6][51]^sbits[6] |
         ecchmatrix[5][51]^sbits[5] |
         ecchmatrix[4][51]^sbits[4] |
         ecchmatrix[3][51]^sbits[3] |
         ecchmatrix[2][51]^sbits[2] |
         ecchmatrix[1][51]^sbits[1] |
         ecchmatrix[0][51]^sbits[0]);
  assign biterr_wire[50] = ~(
         ecchmatrix[9][50]^sbits[9] |
         ecchmatrix[8][50]^sbits[8] |
         ecchmatrix[7][50]^sbits[7] |
         ecchmatrix[6][50]^sbits[6] |
         ecchmatrix[5][50]^sbits[5] |
         ecchmatrix[4][50]^sbits[4] |
         ecchmatrix[3][50]^sbits[3] |
         ecchmatrix[2][50]^sbits[2] |
         ecchmatrix[1][50]^sbits[1] |
         ecchmatrix[0][50]^sbits[0]);
  assign biterr_wire[49] = ~(
         ecchmatrix[9][49]^sbits[9] |
         ecchmatrix[8][49]^sbits[8] |
         ecchmatrix[7][49]^sbits[7] |
         ecchmatrix[6][49]^sbits[6] |
         ecchmatrix[5][49]^sbits[5] |
         ecchmatrix[4][49]^sbits[4] |
         ecchmatrix[3][49]^sbits[3] |
         ecchmatrix[2][49]^sbits[2] |
         ecchmatrix[1][49]^sbits[1] |
         ecchmatrix[0][49]^sbits[0]);
  assign biterr_wire[48] = ~(
         ecchmatrix[9][48]^sbits[9] |
         ecchmatrix[8][48]^sbits[8] |
         ecchmatrix[7][48]^sbits[7] |
         ecchmatrix[6][48]^sbits[6] |
         ecchmatrix[5][48]^sbits[5] |
         ecchmatrix[4][48]^sbits[4] |
         ecchmatrix[3][48]^sbits[3] |
         ecchmatrix[2][48]^sbits[2] |
         ecchmatrix[1][48]^sbits[1] |
         ecchmatrix[0][48]^sbits[0]);
  assign biterr_wire[47] = ~(
         ecchmatrix[9][47]^sbits[9] |
         ecchmatrix[8][47]^sbits[8] |
         ecchmatrix[7][47]^sbits[7] |
         ecchmatrix[6][47]^sbits[6] |
         ecchmatrix[5][47]^sbits[5] |
         ecchmatrix[4][47]^sbits[4] |
         ecchmatrix[3][47]^sbits[3] |
         ecchmatrix[2][47]^sbits[2] |
         ecchmatrix[1][47]^sbits[1] |
         ecchmatrix[0][47]^sbits[0]);
  assign biterr_wire[46] = ~(
         ecchmatrix[9][46]^sbits[9] |
         ecchmatrix[8][46]^sbits[8] |
         ecchmatrix[7][46]^sbits[7] |
         ecchmatrix[6][46]^sbits[6] |
         ecchmatrix[5][46]^sbits[5] |
         ecchmatrix[4][46]^sbits[4] |
         ecchmatrix[3][46]^sbits[3] |
         ecchmatrix[2][46]^sbits[2] |
         ecchmatrix[1][46]^sbits[1] |
         ecchmatrix[0][46]^sbits[0]);
  assign biterr_wire[45] = ~(
         ecchmatrix[9][45]^sbits[9] |
         ecchmatrix[8][45]^sbits[8] |
         ecchmatrix[7][45]^sbits[7] |
         ecchmatrix[6][45]^sbits[6] |
         ecchmatrix[5][45]^sbits[5] |
         ecchmatrix[4][45]^sbits[4] |
         ecchmatrix[3][45]^sbits[3] |
         ecchmatrix[2][45]^sbits[2] |
         ecchmatrix[1][45]^sbits[1] |
         ecchmatrix[0][45]^sbits[0]);
  assign biterr_wire[44] = ~(
         ecchmatrix[9][44]^sbits[9] |
         ecchmatrix[8][44]^sbits[8] |
         ecchmatrix[7][44]^sbits[7] |
         ecchmatrix[6][44]^sbits[6] |
         ecchmatrix[5][44]^sbits[5] |
         ecchmatrix[4][44]^sbits[4] |
         ecchmatrix[3][44]^sbits[3] |
         ecchmatrix[2][44]^sbits[2] |
         ecchmatrix[1][44]^sbits[1] |
         ecchmatrix[0][44]^sbits[0]);
  assign biterr_wire[43] = ~(
         ecchmatrix[9][43]^sbits[9] |
         ecchmatrix[8][43]^sbits[8] |
         ecchmatrix[7][43]^sbits[7] |
         ecchmatrix[6][43]^sbits[6] |
         ecchmatrix[5][43]^sbits[5] |
         ecchmatrix[4][43]^sbits[4] |
         ecchmatrix[3][43]^sbits[3] |
         ecchmatrix[2][43]^sbits[2] |
         ecchmatrix[1][43]^sbits[1] |
         ecchmatrix[0][43]^sbits[0]);
  assign biterr_wire[42] = ~(
         ecchmatrix[9][42]^sbits[9] |
         ecchmatrix[8][42]^sbits[8] |
         ecchmatrix[7][42]^sbits[7] |
         ecchmatrix[6][42]^sbits[6] |
         ecchmatrix[5][42]^sbits[5] |
         ecchmatrix[4][42]^sbits[4] |
         ecchmatrix[3][42]^sbits[3] |
         ecchmatrix[2][42]^sbits[2] |
         ecchmatrix[1][42]^sbits[1] |
         ecchmatrix[0][42]^sbits[0]);
  assign biterr_wire[41] = ~(
         ecchmatrix[9][41]^sbits[9] |
         ecchmatrix[8][41]^sbits[8] |
         ecchmatrix[7][41]^sbits[7] |
         ecchmatrix[6][41]^sbits[6] |
         ecchmatrix[5][41]^sbits[5] |
         ecchmatrix[4][41]^sbits[4] |
         ecchmatrix[3][41]^sbits[3] |
         ecchmatrix[2][41]^sbits[2] |
         ecchmatrix[1][41]^sbits[1] |
         ecchmatrix[0][41]^sbits[0]);
  assign biterr_wire[40] = ~(
         ecchmatrix[9][40]^sbits[9] |
         ecchmatrix[8][40]^sbits[8] |
         ecchmatrix[7][40]^sbits[7] |
         ecchmatrix[6][40]^sbits[6] |
         ecchmatrix[5][40]^sbits[5] |
         ecchmatrix[4][40]^sbits[4] |
         ecchmatrix[3][40]^sbits[3] |
         ecchmatrix[2][40]^sbits[2] |
         ecchmatrix[1][40]^sbits[1] |
         ecchmatrix[0][40]^sbits[0]);
  assign biterr_wire[39] = ~(
         ecchmatrix[9][39]^sbits[9] |
         ecchmatrix[8][39]^sbits[8] |
         ecchmatrix[7][39]^sbits[7] |
         ecchmatrix[6][39]^sbits[6] |
         ecchmatrix[5][39]^sbits[5] |
         ecchmatrix[4][39]^sbits[4] |
         ecchmatrix[3][39]^sbits[3] |
         ecchmatrix[2][39]^sbits[2] |
         ecchmatrix[1][39]^sbits[1] |
         ecchmatrix[0][39]^sbits[0]);
  assign biterr_wire[38] = ~(
         ecchmatrix[9][38]^sbits[9] |
         ecchmatrix[8][38]^sbits[8] |
         ecchmatrix[7][38]^sbits[7] |
         ecchmatrix[6][38]^sbits[6] |
         ecchmatrix[5][38]^sbits[5] |
         ecchmatrix[4][38]^sbits[4] |
         ecchmatrix[3][38]^sbits[3] |
         ecchmatrix[2][38]^sbits[2] |
         ecchmatrix[1][38]^sbits[1] |
         ecchmatrix[0][38]^sbits[0]);
  assign biterr_wire[37] = ~(
         ecchmatrix[9][37]^sbits[9] |
         ecchmatrix[8][37]^sbits[8] |
         ecchmatrix[7][37]^sbits[7] |
         ecchmatrix[6][37]^sbits[6] |
         ecchmatrix[5][37]^sbits[5] |
         ecchmatrix[4][37]^sbits[4] |
         ecchmatrix[3][37]^sbits[3] |
         ecchmatrix[2][37]^sbits[2] |
         ecchmatrix[1][37]^sbits[1] |
         ecchmatrix[0][37]^sbits[0]);
  assign biterr_wire[36] = ~(
         ecchmatrix[9][36]^sbits[9] |
         ecchmatrix[8][36]^sbits[8] |
         ecchmatrix[7][36]^sbits[7] |
         ecchmatrix[6][36]^sbits[6] |
         ecchmatrix[5][36]^sbits[5] |
         ecchmatrix[4][36]^sbits[4] |
         ecchmatrix[3][36]^sbits[3] |
         ecchmatrix[2][36]^sbits[2] |
         ecchmatrix[1][36]^sbits[1] |
         ecchmatrix[0][36]^sbits[0]);
  assign biterr_wire[35] = ~(
         ecchmatrix[9][35]^sbits[9] |
         ecchmatrix[8][35]^sbits[8] |
         ecchmatrix[7][35]^sbits[7] |
         ecchmatrix[6][35]^sbits[6] |
         ecchmatrix[5][35]^sbits[5] |
         ecchmatrix[4][35]^sbits[4] |
         ecchmatrix[3][35]^sbits[3] |
         ecchmatrix[2][35]^sbits[2] |
         ecchmatrix[1][35]^sbits[1] |
         ecchmatrix[0][35]^sbits[0]);
  assign biterr_wire[34] = ~(
         ecchmatrix[9][34]^sbits[9] |
         ecchmatrix[8][34]^sbits[8] |
         ecchmatrix[7][34]^sbits[7] |
         ecchmatrix[6][34]^sbits[6] |
         ecchmatrix[5][34]^sbits[5] |
         ecchmatrix[4][34]^sbits[4] |
         ecchmatrix[3][34]^sbits[3] |
         ecchmatrix[2][34]^sbits[2] |
         ecchmatrix[1][34]^sbits[1] |
         ecchmatrix[0][34]^sbits[0]);
  assign biterr_wire[33] = ~(
         ecchmatrix[9][33]^sbits[9] |
         ecchmatrix[8][33]^sbits[8] |
         ecchmatrix[7][33]^sbits[7] |
         ecchmatrix[6][33]^sbits[6] |
         ecchmatrix[5][33]^sbits[5] |
         ecchmatrix[4][33]^sbits[4] |
         ecchmatrix[3][33]^sbits[3] |
         ecchmatrix[2][33]^sbits[2] |
         ecchmatrix[1][33]^sbits[1] |
         ecchmatrix[0][33]^sbits[0]);
  assign biterr_wire[32] = ~(
         ecchmatrix[9][32]^sbits[9] |
         ecchmatrix[8][32]^sbits[8] |
         ecchmatrix[7][32]^sbits[7] |
         ecchmatrix[6][32]^sbits[6] |
         ecchmatrix[5][32]^sbits[5] |
         ecchmatrix[4][32]^sbits[4] |
         ecchmatrix[3][32]^sbits[3] |
         ecchmatrix[2][32]^sbits[2] |
         ecchmatrix[1][32]^sbits[1] |
         ecchmatrix[0][32]^sbits[0]);
  assign biterr_wire[31] = ~(
         ecchmatrix[9][31]^sbits[9] |
         ecchmatrix[8][31]^sbits[8] |
         ecchmatrix[7][31]^sbits[7] |
         ecchmatrix[6][31]^sbits[6] |
         ecchmatrix[5][31]^sbits[5] |
         ecchmatrix[4][31]^sbits[4] |
         ecchmatrix[3][31]^sbits[3] |
         ecchmatrix[2][31]^sbits[2] |
         ecchmatrix[1][31]^sbits[1] |
         ecchmatrix[0][31]^sbits[0]);
  assign biterr_wire[30] = ~(
         ecchmatrix[9][30]^sbits[9] |
         ecchmatrix[8][30]^sbits[8] |
         ecchmatrix[7][30]^sbits[7] |
         ecchmatrix[6][30]^sbits[6] |
         ecchmatrix[5][30]^sbits[5] |
         ecchmatrix[4][30]^sbits[4] |
         ecchmatrix[3][30]^sbits[3] |
         ecchmatrix[2][30]^sbits[2] |
         ecchmatrix[1][30]^sbits[1] |
         ecchmatrix[0][30]^sbits[0]);
  assign biterr_wire[29] = ~(
         ecchmatrix[9][29]^sbits[9] |
         ecchmatrix[8][29]^sbits[8] |
         ecchmatrix[7][29]^sbits[7] |
         ecchmatrix[6][29]^sbits[6] |
         ecchmatrix[5][29]^sbits[5] |
         ecchmatrix[4][29]^sbits[4] |
         ecchmatrix[3][29]^sbits[3] |
         ecchmatrix[2][29]^sbits[2] |
         ecchmatrix[1][29]^sbits[1] |
         ecchmatrix[0][29]^sbits[0]);
  assign biterr_wire[28] = ~(
         ecchmatrix[9][28]^sbits[9] |
         ecchmatrix[8][28]^sbits[8] |
         ecchmatrix[7][28]^sbits[7] |
         ecchmatrix[6][28]^sbits[6] |
         ecchmatrix[5][28]^sbits[5] |
         ecchmatrix[4][28]^sbits[4] |
         ecchmatrix[3][28]^sbits[3] |
         ecchmatrix[2][28]^sbits[2] |
         ecchmatrix[1][28]^sbits[1] |
         ecchmatrix[0][28]^sbits[0]);
  assign biterr_wire[27] = ~(
         ecchmatrix[9][27]^sbits[9] |
         ecchmatrix[8][27]^sbits[8] |
         ecchmatrix[7][27]^sbits[7] |
         ecchmatrix[6][27]^sbits[6] |
         ecchmatrix[5][27]^sbits[5] |
         ecchmatrix[4][27]^sbits[4] |
         ecchmatrix[3][27]^sbits[3] |
         ecchmatrix[2][27]^sbits[2] |
         ecchmatrix[1][27]^sbits[1] |
         ecchmatrix[0][27]^sbits[0]);
  assign biterr_wire[26] = ~(
         ecchmatrix[9][26]^sbits[9] |
         ecchmatrix[8][26]^sbits[8] |
         ecchmatrix[7][26]^sbits[7] |
         ecchmatrix[6][26]^sbits[6] |
         ecchmatrix[5][26]^sbits[5] |
         ecchmatrix[4][26]^sbits[4] |
         ecchmatrix[3][26]^sbits[3] |
         ecchmatrix[2][26]^sbits[2] |
         ecchmatrix[1][26]^sbits[1] |
         ecchmatrix[0][26]^sbits[0]);
  assign biterr_wire[25] = ~(
         ecchmatrix[9][25]^sbits[9] |
         ecchmatrix[8][25]^sbits[8] |
         ecchmatrix[7][25]^sbits[7] |
         ecchmatrix[6][25]^sbits[6] |
         ecchmatrix[5][25]^sbits[5] |
         ecchmatrix[4][25]^sbits[4] |
         ecchmatrix[3][25]^sbits[3] |
         ecchmatrix[2][25]^sbits[2] |
         ecchmatrix[1][25]^sbits[1] |
         ecchmatrix[0][25]^sbits[0]);
  assign biterr_wire[24] = ~(
         ecchmatrix[9][24]^sbits[9] |
         ecchmatrix[8][24]^sbits[8] |
         ecchmatrix[7][24]^sbits[7] |
         ecchmatrix[6][24]^sbits[6] |
         ecchmatrix[5][24]^sbits[5] |
         ecchmatrix[4][24]^sbits[4] |
         ecchmatrix[3][24]^sbits[3] |
         ecchmatrix[2][24]^sbits[2] |
         ecchmatrix[1][24]^sbits[1] |
         ecchmatrix[0][24]^sbits[0]);
  assign biterr_wire[23] = ~(
         ecchmatrix[9][23]^sbits[9] |
         ecchmatrix[8][23]^sbits[8] |
         ecchmatrix[7][23]^sbits[7] |
         ecchmatrix[6][23]^sbits[6] |
         ecchmatrix[5][23]^sbits[5] |
         ecchmatrix[4][23]^sbits[4] |
         ecchmatrix[3][23]^sbits[3] |
         ecchmatrix[2][23]^sbits[2] |
         ecchmatrix[1][23]^sbits[1] |
         ecchmatrix[0][23]^sbits[0]);
  assign biterr_wire[22] = ~(
         ecchmatrix[9][22]^sbits[9] |
         ecchmatrix[8][22]^sbits[8] |
         ecchmatrix[7][22]^sbits[7] |
         ecchmatrix[6][22]^sbits[6] |
         ecchmatrix[5][22]^sbits[5] |
         ecchmatrix[4][22]^sbits[4] |
         ecchmatrix[3][22]^sbits[3] |
         ecchmatrix[2][22]^sbits[2] |
         ecchmatrix[1][22]^sbits[1] |
         ecchmatrix[0][22]^sbits[0]);
  assign biterr_wire[21] = ~(
         ecchmatrix[9][21]^sbits[9] |
         ecchmatrix[8][21]^sbits[8] |
         ecchmatrix[7][21]^sbits[7] |
         ecchmatrix[6][21]^sbits[6] |
         ecchmatrix[5][21]^sbits[5] |
         ecchmatrix[4][21]^sbits[4] |
         ecchmatrix[3][21]^sbits[3] |
         ecchmatrix[2][21]^sbits[2] |
         ecchmatrix[1][21]^sbits[1] |
         ecchmatrix[0][21]^sbits[0]);
  assign biterr_wire[20] = ~(
         ecchmatrix[9][20]^sbits[9] |
         ecchmatrix[8][20]^sbits[8] |
         ecchmatrix[7][20]^sbits[7] |
         ecchmatrix[6][20]^sbits[6] |
         ecchmatrix[5][20]^sbits[5] |
         ecchmatrix[4][20]^sbits[4] |
         ecchmatrix[3][20]^sbits[3] |
         ecchmatrix[2][20]^sbits[2] |
         ecchmatrix[1][20]^sbits[1] |
         ecchmatrix[0][20]^sbits[0]);
  assign biterr_wire[19] = ~(
         ecchmatrix[9][19]^sbits[9] |
         ecchmatrix[8][19]^sbits[8] |
         ecchmatrix[7][19]^sbits[7] |
         ecchmatrix[6][19]^sbits[6] |
         ecchmatrix[5][19]^sbits[5] |
         ecchmatrix[4][19]^sbits[4] |
         ecchmatrix[3][19]^sbits[3] |
         ecchmatrix[2][19]^sbits[2] |
         ecchmatrix[1][19]^sbits[1] |
         ecchmatrix[0][19]^sbits[0]);
  assign biterr_wire[18] = ~(
         ecchmatrix[9][18]^sbits[9] |
         ecchmatrix[8][18]^sbits[8] |
         ecchmatrix[7][18]^sbits[7] |
         ecchmatrix[6][18]^sbits[6] |
         ecchmatrix[5][18]^sbits[5] |
         ecchmatrix[4][18]^sbits[4] |
         ecchmatrix[3][18]^sbits[3] |
         ecchmatrix[2][18]^sbits[2] |
         ecchmatrix[1][18]^sbits[1] |
         ecchmatrix[0][18]^sbits[0]);
  assign biterr_wire[17] = ~(
         ecchmatrix[9][17]^sbits[9] |
         ecchmatrix[8][17]^sbits[8] |
         ecchmatrix[7][17]^sbits[7] |
         ecchmatrix[6][17]^sbits[6] |
         ecchmatrix[5][17]^sbits[5] |
         ecchmatrix[4][17]^sbits[4] |
         ecchmatrix[3][17]^sbits[3] |
         ecchmatrix[2][17]^sbits[2] |
         ecchmatrix[1][17]^sbits[1] |
         ecchmatrix[0][17]^sbits[0]);
  assign biterr_wire[16] = ~(
         ecchmatrix[9][16]^sbits[9] |
         ecchmatrix[8][16]^sbits[8] |
         ecchmatrix[7][16]^sbits[7] |
         ecchmatrix[6][16]^sbits[6] |
         ecchmatrix[5][16]^sbits[5] |
         ecchmatrix[4][16]^sbits[4] |
         ecchmatrix[3][16]^sbits[3] |
         ecchmatrix[2][16]^sbits[2] |
         ecchmatrix[1][16]^sbits[1] |
         ecchmatrix[0][16]^sbits[0]);
  assign biterr_wire[15] = ~(
         ecchmatrix[9][15]^sbits[9] |
         ecchmatrix[8][15]^sbits[8] |
         ecchmatrix[7][15]^sbits[7] |
         ecchmatrix[6][15]^sbits[6] |
         ecchmatrix[5][15]^sbits[5] |
         ecchmatrix[4][15]^sbits[4] |
         ecchmatrix[3][15]^sbits[3] |
         ecchmatrix[2][15]^sbits[2] |
         ecchmatrix[1][15]^sbits[1] |
         ecchmatrix[0][15]^sbits[0]);
  assign biterr_wire[14] = ~(
         ecchmatrix[9][14]^sbits[9] |
         ecchmatrix[8][14]^sbits[8] |
         ecchmatrix[7][14]^sbits[7] |
         ecchmatrix[6][14]^sbits[6] |
         ecchmatrix[5][14]^sbits[5] |
         ecchmatrix[4][14]^sbits[4] |
         ecchmatrix[3][14]^sbits[3] |
         ecchmatrix[2][14]^sbits[2] |
         ecchmatrix[1][14]^sbits[1] |
         ecchmatrix[0][14]^sbits[0]);
  assign biterr_wire[13] = ~(
         ecchmatrix[9][13]^sbits[9] |
         ecchmatrix[8][13]^sbits[8] |
         ecchmatrix[7][13]^sbits[7] |
         ecchmatrix[6][13]^sbits[6] |
         ecchmatrix[5][13]^sbits[5] |
         ecchmatrix[4][13]^sbits[4] |
         ecchmatrix[3][13]^sbits[3] |
         ecchmatrix[2][13]^sbits[2] |
         ecchmatrix[1][13]^sbits[1] |
         ecchmatrix[0][13]^sbits[0]);
  assign biterr_wire[12] = ~(
         ecchmatrix[9][12]^sbits[9] |
         ecchmatrix[8][12]^sbits[8] |
         ecchmatrix[7][12]^sbits[7] |
         ecchmatrix[6][12]^sbits[6] |
         ecchmatrix[5][12]^sbits[5] |
         ecchmatrix[4][12]^sbits[4] |
         ecchmatrix[3][12]^sbits[3] |
         ecchmatrix[2][12]^sbits[2] |
         ecchmatrix[1][12]^sbits[1] |
         ecchmatrix[0][12]^sbits[0]);
  assign biterr_wire[11] = ~(
         ecchmatrix[9][11]^sbits[9] |
         ecchmatrix[8][11]^sbits[8] |
         ecchmatrix[7][11]^sbits[7] |
         ecchmatrix[6][11]^sbits[6] |
         ecchmatrix[5][11]^sbits[5] |
         ecchmatrix[4][11]^sbits[4] |
         ecchmatrix[3][11]^sbits[3] |
         ecchmatrix[2][11]^sbits[2] |
         ecchmatrix[1][11]^sbits[1] |
         ecchmatrix[0][11]^sbits[0]);
  assign biterr_wire[10] = ~(
         ecchmatrix[9][10]^sbits[9] |
         ecchmatrix[8][10]^sbits[8] |
         ecchmatrix[7][10]^sbits[7] |
         ecchmatrix[6][10]^sbits[6] |
         ecchmatrix[5][10]^sbits[5] |
         ecchmatrix[4][10]^sbits[4] |
         ecchmatrix[3][10]^sbits[3] |
         ecchmatrix[2][10]^sbits[2] |
         ecchmatrix[1][10]^sbits[1] |
         ecchmatrix[0][10]^sbits[0]);
  assign biterr_wire[9] = ~(
         ecchmatrix[9][9]^sbits[9] |
         ecchmatrix[8][9]^sbits[8] |
         ecchmatrix[7][9]^sbits[7] |
         ecchmatrix[6][9]^sbits[6] |
         ecchmatrix[5][9]^sbits[5] |
         ecchmatrix[4][9]^sbits[4] |
         ecchmatrix[3][9]^sbits[3] |
         ecchmatrix[2][9]^sbits[2] |
         ecchmatrix[1][9]^sbits[1] |
         ecchmatrix[0][9]^sbits[0]);
  assign biterr_wire[8] = ~(
         ecchmatrix[9][8]^sbits[9] |
         ecchmatrix[8][8]^sbits[8] |
         ecchmatrix[7][8]^sbits[7] |
         ecchmatrix[6][8]^sbits[6] |
         ecchmatrix[5][8]^sbits[5] |
         ecchmatrix[4][8]^sbits[4] |
         ecchmatrix[3][8]^sbits[3] |
         ecchmatrix[2][8]^sbits[2] |
         ecchmatrix[1][8]^sbits[1] |
         ecchmatrix[0][8]^sbits[0]);
  assign biterr_wire[7] = ~(
         ecchmatrix[9][7]^sbits[9] |
         ecchmatrix[8][7]^sbits[8] |
         ecchmatrix[7][7]^sbits[7] |
         ecchmatrix[6][7]^sbits[6] |
         ecchmatrix[5][7]^sbits[5] |
         ecchmatrix[4][7]^sbits[4] |
         ecchmatrix[3][7]^sbits[3] |
         ecchmatrix[2][7]^sbits[2] |
         ecchmatrix[1][7]^sbits[1] |
         ecchmatrix[0][7]^sbits[0]);
  assign biterr_wire[6] = ~(
         ecchmatrix[9][6]^sbits[9] |
         ecchmatrix[8][6]^sbits[8] |
         ecchmatrix[7][6]^sbits[7] |
         ecchmatrix[6][6]^sbits[6] |
         ecchmatrix[5][6]^sbits[5] |
         ecchmatrix[4][6]^sbits[4] |
         ecchmatrix[3][6]^sbits[3] |
         ecchmatrix[2][6]^sbits[2] |
         ecchmatrix[1][6]^sbits[1] |
         ecchmatrix[0][6]^sbits[0]);
  assign biterr_wire[5] = ~(
         ecchmatrix[9][5]^sbits[9] |
         ecchmatrix[8][5]^sbits[8] |
         ecchmatrix[7][5]^sbits[7] |
         ecchmatrix[6][5]^sbits[6] |
         ecchmatrix[5][5]^sbits[5] |
         ecchmatrix[4][5]^sbits[4] |
         ecchmatrix[3][5]^sbits[3] |
         ecchmatrix[2][5]^sbits[2] |
         ecchmatrix[1][5]^sbits[1] |
         ecchmatrix[0][5]^sbits[0]);
  assign biterr_wire[4] = ~(
         ecchmatrix[9][4]^sbits[9] |
         ecchmatrix[8][4]^sbits[8] |
         ecchmatrix[7][4]^sbits[7] |
         ecchmatrix[6][4]^sbits[6] |
         ecchmatrix[5][4]^sbits[5] |
         ecchmatrix[4][4]^sbits[4] |
         ecchmatrix[3][4]^sbits[3] |
         ecchmatrix[2][4]^sbits[2] |
         ecchmatrix[1][4]^sbits[1] |
         ecchmatrix[0][4]^sbits[0]);
  assign biterr_wire[3] = ~(
         ecchmatrix[9][3]^sbits[9] |
         ecchmatrix[8][3]^sbits[8] |
         ecchmatrix[7][3]^sbits[7] |
         ecchmatrix[6][3]^sbits[6] |
         ecchmatrix[5][3]^sbits[5] |
         ecchmatrix[4][3]^sbits[4] |
         ecchmatrix[3][3]^sbits[3] |
         ecchmatrix[2][3]^sbits[2] |
         ecchmatrix[1][3]^sbits[1] |
         ecchmatrix[0][3]^sbits[0]);
  assign biterr_wire[2] = ~(
         ecchmatrix[9][2]^sbits[9] |
         ecchmatrix[8][2]^sbits[8] |
         ecchmatrix[7][2]^sbits[7] |
         ecchmatrix[6][2]^sbits[6] |
         ecchmatrix[5][2]^sbits[5] |
         ecchmatrix[4][2]^sbits[4] |
         ecchmatrix[3][2]^sbits[3] |
         ecchmatrix[2][2]^sbits[2] |
         ecchmatrix[1][2]^sbits[1] |
         ecchmatrix[0][2]^sbits[0]);
  assign biterr_wire[1] = ~(
         ecchmatrix[9][1]^sbits[9] |
         ecchmatrix[8][1]^sbits[8] |
         ecchmatrix[7][1]^sbits[7] |
         ecchmatrix[6][1]^sbits[6] |
         ecchmatrix[5][1]^sbits[5] |
         ecchmatrix[4][1]^sbits[4] |
         ecchmatrix[3][1]^sbits[3] |
         ecchmatrix[2][1]^sbits[2] |
         ecchmatrix[1][1]^sbits[1] |
         ecchmatrix[0][1]^sbits[0]);
  assign biterr_wire[0] = ~(
         ecchmatrix[9][0]^sbits[9] |
         ecchmatrix[8][0]^sbits[8] |
         ecchmatrix[7][0]^sbits[7] |
         ecchmatrix[6][0]^sbits[6] |
         ecchmatrix[5][0]^sbits[5] |
         ecchmatrix[4][0]^sbits[4] |
         ecchmatrix[3][0]^sbits[3] |
         ecchmatrix[2][0]^sbits[2] |
         ecchmatrix[1][0]^sbits[1] |
         ecchmatrix[0][0]^sbits[0]);

  wire [ECCDWIDTH+ECCWIDTH-1:0]   biterr;
  wire [ECCDWIDTH-1:0]	din_f2;
  wire [ECCWIDTH-1:0]   sbits_f2;
  generate if(FLOPECC2) begin
	reg [ECCDWIDTH+ECCWIDTH-1:0]   biterr_reg;
	reg [ECCDWIDTH-1:0]	din_f2_reg;
	reg [ECCWIDTH-1:0] sbits_f2_reg;
	always @(posedge clk) begin
		biterr_reg <= biterr_wire;
		din_f2_reg <= din_f1;
		sbits_f2_reg <= sbits;
	end
	assign biterr = biterr_reg;
	assign din_f2 = din_f2_reg;
	assign sbits_f2 = sbits_f2_reg;
  end else begin
	assign biterr = biterr_wire;
	assign din_f2 = din_f1;
	assign sbits_f2 = sbits;
  end
  endgenerate 

 assign  dout    = din_f2 ^ biterr;
 assign  sec_err = |biterr;
 assign  ded_err = |sbits_f2 & ~|biterr;

endmodule
