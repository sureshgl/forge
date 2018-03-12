module core_ecc_calc (din, mem_din, clk, rst);

  parameter WIDTH = 32;
  parameter ENAPAR = 0;
  parameter ENAECC = 1;
  parameter ENADEC = 0;
  parameter ENAHEC = 0;
  parameter ENAQEC = 0;
  parameter ECCWDTH = 7;

  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : ENADEC ? 2*WIDTH+ECCWDTH : ENAHEC ? WIDTH+2*ECCWDTH : ENAQEC ? WIDTH+4*ECCWDTH : WIDTH;

  input [WIDTH-1:0] din;

  output [MEMWDTH-1:0] mem_din;

  input clk;
  input rst;

  wire [MEMWDTH-1:0] mem_din;
  generate if (ENAPAR) begin: pg_loop
    assign mem_din = {^din,din};
  end else if (ENAECC) begin: eg_loop
    wire [ECCWDTH-1:0] din_ecc_a;
    ecc_calc #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
      ecc_calc_inst (.din(din), .eccout(din_ecc_a));
    assign mem_din = {din_ecc_a,din};
  end else if (ENADEC) begin: dg_loop
    wire [ECCWDTH-1:0] din_ecc_b;
    ecc_calc #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
      ecc_calc_inst (.din(din), .eccout(din_ecc_b));
    assign mem_din = {din,din_ecc_b,din};
  end else if (ENAHEC) begin: hg_loop
    wire [(WIDTH>>1)-1:0] din_wire1_c = din;
    wire [ECCWDTH-1:0] din_ecc1_c;
    ecc_calc #(.ECCDWIDTH(WIDTH>>1), .ECCWIDTH(ECCWDTH))
      ecc_calc_1_inst (.din(din_wire1_c), .eccout(din_ecc1_c));
    wire [(WIDTH>>1)-1:0] din_wire2_c = din >> (WIDTH>>1);
    wire [ECCWDTH-1:0] din_ecc2_c;
    ecc_calc #(.ECCDWIDTH(WIDTH>>1), .ECCWIDTH(ECCWDTH))
      ecc_calc_2_inst (.din(din_wire2_c), .eccout(din_ecc2_c));
    assign mem_din = {din_ecc2_c,din_wire2_c,din_ecc1_c,din_wire1_c};
  end else if (ENAQEC) begin: qg_loop
    wire [(WIDTH>>2)-1:0] din_wire1_d = din;
    wire [ECCWDTH-1:0] din_ecc1_d;
    ecc_calc #(.ECCDWIDTH(WIDTH>>2), .ECCWIDTH(ECCWDTH))
      ecc_calc_1_inst (.din(din_wire1_d), .eccout(din_ecc1_d));
    wire [(WIDTH>>2)-1:0] din_wire2_d = din >> (WIDTH>>2);
    wire [ECCWDTH-1:0] din_ecc2_d;
    ecc_calc #(.ECCDWIDTH(WIDTH>>2), .ECCWIDTH(ECCWDTH))
      ecc_calc_2_inst (.din(din_wire2_d), .eccout(din_ecc2_d));
    wire [(WIDTH>>2)-1:0] din_wire3_d = din >> 2*(WIDTH>>2);
    wire [ECCWDTH-1:0] din_ecc3_d;
    ecc_calc #(.ECCDWIDTH(WIDTH>>2), .ECCWIDTH(ECCWDTH))
      ecc_calc_3_inst (.din(din_wire3_d), .eccout(din_ecc3_d));
    wire [(WIDTH>>2)-1:0] din_wire4_d = din >> 3*(WIDTH>>2);
    wire [ECCWDTH-1:0] din_ecc4_d;
    ecc_calc #(.ECCDWIDTH(WIDTH>>2), .ECCWIDTH(ECCWDTH))
      ecc_calc_4_inst (.din(din_wire4_d), .eccout(din_ecc4_d));
    assign mem_din = {din_ecc4_d,din_wire4_d,din_ecc3_d,din_wire3_d,din_ecc2_d,din_wire2_d,din_ecc1_d,din_wire1_d};
  end else begin: ng_loop
    assign mem_din = din;
  end
  endgenerate

endmodule
