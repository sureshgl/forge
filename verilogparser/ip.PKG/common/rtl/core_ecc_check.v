module core_ecc_check (rd_dout, rd_vld, rd_serr, rd_derr, rd_fwrd, rd_padr, mem_rd_dout, mem_rd_vld, mem_rd_fwrd, mem_rd_padr, clk, rst);

  parameter WIDTH = 32;
  parameter BITPADR = 2;
  parameter ECCWDTH = 7;
  parameter ENAPAR = 0;
  parameter ENAECC = 1;
  parameter ENADEC = 0;
  parameter ENAHEC = 0;
  parameter ENAQEC = 0;
  parameter FLOPECC1 = 0;
  parameter FLOPECC2 = 0;

  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : ENADEC ? 2*WIDTH+ECCWDTH : ENAHEC ? WIDTH+2*ECCWDTH : ENAQEC ? WIDTH+4*ECCWDTH : WIDTH;

  output [WIDTH-1:0] rd_dout;
  output rd_vld;
  output rd_fwrd;
  output [BITPADR-1:0] rd_padr;
  output rd_serr;
  output rd_derr;

  input [MEMWDTH-1:0] mem_rd_dout;
  input mem_rd_vld;
  input mem_rd_fwrd;
  input [BITPADR-1:0] mem_rd_padr;

  input clk;
  input rst;

  parameter COREECC = ENAPAR + ENAECC + ENADEC + ENAHEC + ENAQEC;
  parameter ECC_DELAY = FLOPECC1 + FLOPECC2;

  generate 
    if ((COREECC > 0) && (ECC_DELAY > 0)) begin: p_loop
      reg mem_rd_vld_reg[0:1];
      reg mem_rd_fwrd_reg [0:1];
      reg [BITPADR-1:0] mem_rd_padr_reg [0:1];
      always @(posedge clk)
        for (integer i=0; i<ECC_DELAY; i=i+1)
          if (i>0) begin
            mem_rd_vld_reg[i] <= mem_rd_vld_reg[i-1];
            mem_rd_fwrd_reg[i] <= mem_rd_fwrd_reg[i-1];
            mem_rd_padr_reg[i] <= mem_rd_padr_reg[i-1];
          end else begin
            mem_rd_vld_reg[i] <= mem_rd_vld;
            mem_rd_fwrd_reg[i] <= mem_rd_fwrd;
            mem_rd_padr_reg[i] <= mem_rd_padr;
          end
      assign rd_vld = mem_rd_vld_reg[ECC_DELAY-1];
      assign rd_fwrd = mem_rd_fwrd_reg[ECC_DELAY-1];
      assign rd_padr = mem_rd_padr_reg[ECC_DELAY-1];
    end else begin: np_loop
      assign rd_vld = mem_rd_vld;
      assign rd_fwrd = mem_rd_fwrd;
      assign rd_padr = mem_rd_padr;
    end
  endgenerate

  generate if (ENAPAR) begin: pc_loop
    assign rd_dout = mem_rd_dout;
    assign rd_serr = ^mem_rd_dout;
    assign rd_derr = 1'b0;
  end else if (ENAECC) begin: ec_loop
    wire [WIDTH-1:0] rd_data_wire_e = mem_rd_dout;
    wire [ECCWDTH-1:0] rd_ecc_wire_e = mem_rd_dout >> WIDTH;
    wire [WIDTH-1:0] rd_corr_data_wire_e;
    wire rd_sec_err_wire_e;
    wire rd_ded_err_wire_e;

    ecc_check   #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH), .FLOPECC1(FLOPECC1), .FLOPECC2(FLOPECC2))
        ecc_check_inst (.din(rd_data_wire_e), .eccin(rd_ecc_wire_e),
                        .dout(rd_corr_data_wire_e), .sec_err(rd_sec_err_wire_e), .ded_err(rd_ded_err_wire_e),
                        .clk(clk), .rst(rst));

    assign rd_dout = rd_corr_data_wire_e;
    assign rd_serr = rd_sec_err_wire_e;
    assign rd_derr = rd_ded_err_wire_e;
  end else if (ENADEC) begin: dc_loop
    wire [WIDTH-1:0] rd_data_wire_d = mem_rd_dout;
    wire [ECCWDTH-1:0] rd_ecc_wire_d = mem_rd_dout >> WIDTH;
    wire [WIDTH-1:0] rd_dup_data_wire = mem_rd_dout >> (WIDTH+ECCWDTH);
    wire [WIDTH-1:0] rd_corr_data_wire_d;
    wire rd_sec_err_wire_d;
    wire rd_ded_err_wire_d;
    wire rd_dup_sec_err_wire;
    wire rd_dup_ded_err_wire;

    ecc_check #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH), .FLOPECC1(FLOPECC1), .FLOPECC2(FLOPECC2))
        ecc_check_inst (.din(rd_data_wire_d), .eccin(rd_ecc_wire_d),
                        .dout(rd_corr_data_wire_d), .sec_err(rd_sec_err_wire_d), .ded_err(rd_ded_err_wire_d),
                        .clk(clk), .rst(rst));

    ecc_check #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH), .FLOPECC1(FLOPECC1), .FLOPECC2(FLOPECC2))
        ecc_dup_check_inst (.din(rd_dup_data_wire), .eccin(rd_ecc_wire_d),
                            .dout(), .sec_err(rd_dup_sec_err_wire), .ded_err(rd_dup_ded_err_wire),
                            .clk(clk), .rst(rst));
     
    assign rd_dout = rd_ded_err_wire_d ? rd_dup_data_wire : rd_corr_data_wire_d;
    assign rd_serr = (((rd_data_wire_d == rd_corr_data_wire_d) && rd_sec_err_wire_d  && rd_dup_sec_err_wire) ||
                          ((rd_sec_err_wire_d  ^ rd_dup_sec_err_wire) && !rd_ded_err_wire_d  && !rd_dup_ded_err_wire));
    assign rd_derr = (((rd_data_wire_d != rd_corr_data_wire_d) && rd_sec_err_wire_d  && rd_dup_sec_err_wire) ||
                          rd_ded_err_wire_d  || rd_dup_ded_err_wire);
  end else if (ENAHEC) begin: hc_loop
    wire [(WIDTH>>1)-1:0] rd_data_1h_wire = mem_rd_dout;
    wire [ECCWDTH-1:0] rd_ecc_1h_wire = mem_rd_dout >> (WIDTH>>1);
    wire [(WIDTH>>1)-1:0] rd_corr_data_1h_wire;
    wire rd_sec_err_1h_wire;
    wire rd_ded_err_1h_wire;

    wire [(WIDTH>>1)-1:0] rd_data_2h_wire = mem_rd_dout >> ((WIDTH>>1)+ECCWDTH);
    wire [ECCWDTH-1:0] rd_ecc_2h_wire = mem_rd_dout >> (WIDTH+ECCWDTH);
    wire [(WIDTH>>1)-1:0] rd_corr_data_2h_wire;
    wire rd_sec_err_2h_wire;
    wire rd_ded_err_2h_wire;

    ecc_check #(.ECCDWIDTH(WIDTH>>1), .ECCWIDTH(ECCWDTH), .FLOPECC1(FLOPECC1), .FLOPECC2(FLOPECC2)) 
        ecc_check_1_inst (.din(rd_data_1h_wire), .eccin(rd_ecc_1h_wire),
                          .dout(rd_corr_data_1h_wire), .sec_err(rd_sec_err_1h_wire), .ded_err(rd_ded_err_1h_wire),
                          .clk(clk), .rst(rst));

    ecc_check #(.ECCDWIDTH(WIDTH>>1), .ECCWIDTH(ECCWDTH), .FLOPECC1(FLOPECC1), .FLOPECC2(FLOPECC2))
        ecc_check_2_inst (.din(rd_data_2h_wire), .eccin(rd_ecc_2h_wire),
                          .dout(rd_corr_data_2h_wire), .sec_err(rd_sec_err_2h_wire), .ded_err(rd_ded_err_2h_wire),
                          .clk(clk), .rst(rst));

    assign rd_dout = {rd_corr_data_2h_wire,rd_corr_data_1h_wire};
    assign rd_serr = (rd_sec_err_1h_wire || rd_sec_err_2h_wire);
    assign rd_derr = (rd_ded_err_1h_wire || rd_ded_err_2h_wire);
  end else if (ENAQEC) begin: qc_loop
    wire [(WIDTH>>2)-1:0] rd_data_1q_wire = mem_rd_dout;
    wire [ECCWDTH-1:0] rd_ecc_1q_wire = mem_rd_dout >> (WIDTH>>2);
    wire [(WIDTH>>2)-1:0] rd_corr_data_1q_wire;
    wire rd_sec_err_1q_wire;
    wire rd_ded_err_1q_wire;

    wire [(WIDTH>>2)-1:0] rd_data_2q_wire = mem_rd_dout >> ((WIDTH>>2)+ECCWDTH);
    wire [ECCWDTH-1:0] rd_ecc_2q_wire = mem_rd_dout >> ((WIDTH>>2)+((WIDTH>>2)+ECCWDTH));
    wire [(WIDTH>>2)-1:0] rd_corr_data_2q_wire;
    wire rd_sec_err_2q_wire;
    wire rd_ded_err_2q_wire;

    wire [(WIDTH>>2)-1:0] rd_data_3q_wire = mem_rd_dout >> (2*((WIDTH>>2)+ECCWDTH));
    wire [ECCWDTH-1:0] rd_ecc_3q_wire = mem_rd_dout >> ((WIDTH>>2)+(2*((WIDTH>>2)+ECCWDTH)));
    wire [(WIDTH>>2)-1:0] rd_corr_data_3q_wire;
    wire rd_sec_err_3q_wire;
    wire rd_ded_err_3q_wire;

    wire [(WIDTH>>2)-1:0] rd_data_4q_wire = mem_rd_dout >> (3*((WIDTH>>2)+ECCWDTH));
    wire [ECCWDTH-1:0] rd_ecc_4q_wire = mem_rd_dout >> ((WIDTH>>2)+(3*((WIDTH>>2)+ECCWDTH)));
    wire [(WIDTH>>2)-1:0] rd_corr_data_4q_wire;
    wire rd_sec_err_4q_wire;
    wire rd_ded_err_4q_wire;

    ecc_check #(.ECCDWIDTH(WIDTH>>2), .ECCWIDTH(ECCWDTH), .FLOPECC1(FLOPECC1), .FLOPECC2(FLOPECC2))
        ecc_check_1_inst (.din(rd_data_1q_wire), .eccin(rd_ecc_1q_wire),
                          .dout(rd_corr_data_1q_wire), .sec_err(rd_sec_err_1q_wire), .ded_err(rd_ded_err_1q_wire),
                          .clk(clk), .rst(rst));

    ecc_check #(.ECCDWIDTH(WIDTH>>2), .ECCWIDTH(ECCWDTH), .FLOPECC1(FLOPECC1), .FLOPECC2(FLOPECC2))
        ecc_check_2_inst (.din(rd_data_2q_wire), .eccin(rd_ecc_2q_wire),
                          .dout(rd_corr_data_2q_wire), .sec_err(rd_sec_err_2q_wire), .ded_err(rd_ded_err_2q_wire),
                          .clk(clk), .rst(rst));

    ecc_check #(.ECCDWIDTH(WIDTH>>2), .ECCWIDTH(ECCWDTH), .FLOPECC1(FLOPECC1), .FLOPECC2(FLOPECC2))
        ecc_check_3_inst (.din(rd_data_3q_wire), .eccin(rd_ecc_3q_wire),
                          .dout(rd_corr_data_3q_wire), .sec_err(rd_sec_err_3q_wire), .ded_err(rd_ded_err_3q_wire),
                          .clk(clk), .rst(rst));

    ecc_check #(.ECCDWIDTH(WIDTH>>2), .ECCWIDTH(ECCWDTH), .FLOPECC1(FLOPECC1), .FLOPECC2(FLOPECC2))
        ecc_check_4_inst (.din(rd_data_4q_wire), .eccin(rd_ecc_4q_wire),
                          .dout(rd_corr_data_4q_wire), .sec_err(rd_sec_err_4q_wire), .ded_err(rd_ded_err_4q_wire),
                          .clk(clk), .rst(rst));

    assign rd_dout = {rd_corr_data_4q_wire,rd_corr_data_3q_wire,rd_corr_data_2q_wire,rd_corr_data_1q_wire};
    assign rd_serr = (rd_sec_err_1q_wire || rd_sec_err_2q_wire || rd_sec_err_3q_wire || rd_sec_err_4q_wire);
    assign rd_derr = (rd_ded_err_1q_wire || rd_ded_err_2q_wire || rd_ded_err_3q_wire || rd_ded_err_4q_wire);
  end else begin: nc_loop
    assign rd_dout = mem_rd_dout;
    assign rd_serr = 1'b0;
    assign rd_derr = 1'b0;
  end
  endgenerate

endmodule
