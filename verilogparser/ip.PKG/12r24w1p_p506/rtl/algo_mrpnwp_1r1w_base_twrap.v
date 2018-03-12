module pdin_slcdin_2bc ( cin, pwrbus, bitdin, cout, clk);

 parameter NUMWRPT = 1;
 parameter WRBUSRED = 4;
 parameter FLOPPY = 0;
 integer wrp_int;
input [NUMWRPT/WRBUSRED-1:0] cin;
input [NUMWRPT/WRBUSRED-1:0] pwrbus;
output              bitdin;
output [NUMWRPT/WRBUSRED-1:0] cout;
input clk;

reg [NUMWRPT/WRBUSRED-1:0] cout;
reg [NUMWRPT/WRBUSRED-1:0] pwrbus_red;
reg [NUMWRPT/WRBUSRED-1:0] pwrbus_tmp;

generate if (FLOPPY) begin: flp_loop
  always @(posedge clk)
    cout <= cin;
end else begin: nflp_loop
  always_comb
    cout = cin;
end
endgenerate

assign bitdin = |(pwrbus & cin);
endmodule

module pdout_slcdout_2bc ( cin, pdout, prdbus, cout, clk);

parameter FLOPPY = 1;
parameter GRPWDTH = 1;

input [GRPWDTH-1:0] cin;
input [GRPWDTH-1:0] pdout;
input prdbus;
output [GRPWDTH-1:0] cout;
input clk;

reg [GRPWDTH-1:0] cout;

generate 
    if (FLOPPY) begin: flp_loop
      always @(posedge clk)
        cout <= prdbus ? pdout : cin;
    end else begin: nflp_loop
      always_comb
        cout = prdbus ? pdout : cin;
    end
endgenerate

endmodule

module  algo_mrpnwp_1r1w_base_twrap (pwrite, pwrbadr, pwrradr, pdin,
                              vread_bus, vrdbadr_bus, vrdradr_bus, 
                              t1_writeA, t1_addrA, t1_dinA,
                              t1_readB, t1_addrB, t1_doutB,
			      pdobus_reg_bus, vread_vld_bus, vread_padr_bus,
	                      clk, rst);
 
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMRDPT = 2;
  parameter NUMWRPT = 3;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPADR = 13;

  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;
  parameter BITDMUX = 0;

  parameter NUMGRPW = 25;
  parameter GRPWDTH = 72;
  parameter NUMGRPF = 5;
  parameter WRBUSRED = 1;
  parameter NUMGRPV = NUMGRPW/NUMGRPF+1;

  parameter NUMCMDL = 2;
  parameter BITCMDL = 1; 
  parameter NUMGRPC = NUMVBNK/NUMCMDL;

  output [NUMGRPW*NUMVBNK-1:0]                  t1_writeA;
  output [NUMGRPW*NUMVBNK*BITVROW-1:0]          t1_addrA;
  output [NUMVBNK*WIDTH-1:0]            t1_dinA;
  input  [NUMVBNK*WIDTH-1:0]            t1_doutB;
  output [WIDTH*NUMRDPT-1:0]            pdobus_reg_bus;
  output [NUMRDPT-1:0] 		 vread_vld_bus;
  output [(BITPADR*NUMRDPT)-1:0] vread_padr_bus;

  output [NUMGRPW*NUMVBNK-1:0]                  t1_readB;
  output [NUMGRPW*NUMVBNK*BITVROW-1:0]          t1_addrB;
  
  input [NUMWRPT-1:0] pwrite;
  input [(BITVBNK*NUMWRPT)-1:0] pwrbadr;
  input [(BITVROW*NUMWRPT)-1:0] pwrradr;
  input [(WIDTH*(NUMWRPT/WRBUSRED))-1:0]   pdin;
  input [NUMRDPT-1:0] vread_bus;
  input [(BITVBNK*NUMRDPT)-1:0] vrdbadr_bus;
  input [(BITVROW*NUMRDPT)-1:0] vrdradr_bus;
  
  input                                 clk;
  input                                 rst;

  reg [NUMWRPT*BITVBNK-1:0] pwrbadr_reg;
  reg [NUMWRPT*BITVROW-1:0] pwrradr_reg;
  reg [NUMWRPT*BITVBNK-1:0] vrdbadr_bus_reg;
  reg [NUMWRPT*BITVROW-1:0] vrdradr_bus_reg;


  generate if (FLOPIN) begin: flpi_loop
    always @(posedge clk) begin
      pwrbadr_reg <= pwrbadr;
      pwrradr_reg <= pwrradr;
      vrdbadr_bus_reg <= vrdbadr_bus;
      vrdradr_bus_reg <= vrdradr_bus;
    end
  end else begin
    always_comb begin
      pwrbadr_reg = pwrbadr;
      pwrradr_reg = pwrradr;
      vrdbadr_bus_reg = vrdbadr_bus;
      vrdradr_bus_reg = vrdradr_bus;
    end
  end
  endgenerate

  reg vread_out [0:NUMRDPT-1];
  reg [BITVBNK-1:0] vrdbadr_out [0:NUMRDPT-1];
  reg [BITVROW-1:0] vrdradr_out [0:NUMRDPT-1];
  reg pwrite_wire [0:NUMWRPT-1];
  reg [BITADDR-1:0] vwraddr_wire [0:NUMWRPT-1];
  reg [BITVBNK-1:0] pwrbadr_wire [0:NUMWRPT-1];
  reg [BITVROW-1:0] pwrradr_wire [0:NUMWRPT-1];
  reg [WIDTH-1:0] pdin_wire [0:(NUMWRPT/WRBUSRED)-1];

  integer pwrpo_int;
  always_comb begin
    for (pwrpo_int=0; pwrpo_int<NUMWRPT; pwrpo_int=pwrpo_int+1) begin
      pwrite_wire[pwrpo_int] = pwrite >> pwrpo_int;
      pwrbadr_wire[pwrpo_int] = pwrbadr_reg >> (pwrpo_int*BITVBNK);
      pwrradr_wire[pwrpo_int] = pwrradr_reg >> (pwrpo_int*BITVROW);
    end
  end

  integer pwrp_int;
  always_comb begin
    for (pwrp_int=0; pwrp_int<NUMWRPT/WRBUSRED; pwrp_int=pwrp_int+1) begin
      pdin_wire[pwrp_int] = pdin >> ((pwrp_int)*WIDTH);
    end
  end

  reg [WIDTH-1:0] pdin_reg [0:NUMWRPT/WRBUSRED-1][0:NUMGRPV-1];
  integer pwrd_int, pwrd_del;
  always @(posedge clk)
    for (pwrd_int=0; pwrd_int<NUMWRPT/WRBUSRED; pwrd_int=pwrd_int+1) begin
      for (pwrd_del=0; pwrd_del<NUMGRPV; pwrd_del=pwrd_del+1)
        if (pwrd_del>0)
	  pdin_reg[pwrd_int][pwrd_del] <= pdin_reg[pwrd_int][pwrd_del-1];
	else		
          pdin_reg[pwrd_int][pwrd_del] <= pdin_wire[pwrd_int];
    end



//Write part
  wire [WIDTH-1:0] t1_din [0:NUMVBNK-1];
  reg [(NUMWRPT/WRBUSRED)-1:0] pdinbus [0:WIDTH-1];
  reg [NUMWRPT/WRBUSRED-1:0] pwrbus [0:NUMVBNK-1];
  reg t1_writeA_wire [0:NUMVBNK-1];
  reg [BITVROW-1:0] t1_addrA_wire [0:NUMVBNK-1];
  reg [NUMVBNK*WIDTH-1:0] t1_dinA_wire; 
  assign t1_dinA = t1_dinA_wire;
  integer t1w_int, t1wa_int, pwrb_int, pdin_del;

  always_comb begin 
    t1_dinA_wire = 0;
    for (pwrb_int=0; pwrb_int<NUMVBNK; pwrb_int=pwrb_int+1) begin
      t1_writeA_wire[pwrb_int] = 1'b0;
      t1_addrA_wire[pwrb_int] = 0;
    end
    
    for (t1w_int=0; t1w_int<NUMWRPT; t1w_int=t1w_int+1)
      for (pwrb_int=0; pwrb_int<NUMVBNK; pwrb_int=pwrb_int+1)
        if (pwrite_wire[t1w_int] && (pwrbadr_wire[t1w_int]==pwrb_int)) begin
          t1_writeA_wire[pwrb_int] = 1'b1;
          t1_addrA_wire[pwrb_int] = pwrradr_wire[t1w_int];
        end
    for (pwrb_int=0; pwrb_int<NUMVBNK; pwrb_int=pwrb_int+1)
      for (t1wa_int=0; t1wa_int<WIDTH; t1wa_int=t1wa_int+1)
        t1_dinA_wire[pwrb_int*WIDTH+t1wa_int] = t1_din[pwrb_int][t1wa_int];

    for (t1w_int=0; t1w_int<NUMWRPT; t1w_int=t1w_int+1)
      for (pwrb_int=0; pwrb_int<NUMVBNK; pwrb_int=pwrb_int+1)
          pwrbus[pwrb_int][t1w_int/WRBUSRED] = 1'b0;

    for (t1w_int=0; t1w_int<NUMWRPT; t1w_int=t1w_int+1)
      for (pwrb_int=0; pwrb_int<NUMVBNK; pwrb_int=pwrb_int+1)
        if (pwrite_wire[t1w_int] && (pwrbadr_wire[t1w_int]==pwrb_int))
          pwrbus[pwrb_int][t1w_int/WRBUSRED] = 1'b1;

    for (t1w_int=0; t1w_int<NUMWRPT/WRBUSRED; t1w_int=t1w_int+1)
      for (t1wa_int=0; t1wa_int<WIDTH; t1wa_int=t1wa_int+1) begin
	pdin_del = t1wa_int / (NUMGRPF*GRPWDTH);
        pdinbus[t1wa_int][t1w_int] = pdin_reg[t1w_int][pdin_del][t1wa_int];
    end
  end

  reg t1_writeA_reg [0:NUMVBNK-1][0:NUMGRPC+1+2];  
  reg [BITVROW-1:0] t1_addrA_reg [0:NUMVBNK-1][0:NUMGRPC+1+2];

  genvar t1wb_var, t1wd_var;

  generate
    for (t1wb_var=0; t1wb_var<NUMVBNK; t1wb_var=t1wb_var+1) begin: t1wb_loop
      for (t1wd_var=0; t1wd_var<=NUMGRPC+1+2; t1wd_var=t1wd_var+1) begin: t1wd_loop
        if (t1wd_var==0) begin: init_loop
  	  always @(posedge clk) begin
            t1_writeA_reg[t1wb_var][t1wd_var] <= t1_writeA_wire[t1wb_var];
            t1_addrA_reg[t1wb_var][t1wd_var] <= t1_addrA_wire[t1wb_var];
	  end
        end else begin: flop_loop
          always @(posedge clk) begin
            t1_writeA_reg[t1wb_var][t1wd_var] <= t1_writeA_reg[t1wb_var][t1wd_var-1];
            t1_addrA_reg[t1wb_var][t1wd_var] <= t1_addrA_reg[t1wb_var][t1wd_var-1];
	  end
        end
      end
    end
  endgenerate

  reg [NUMWRPT/WRBUSRED-1:0] pwrbus_reg [0:NUMVBNK-1][0:NUMGRPC+1+2];
  genvar pwrr_var, pwrb_var, pwrd_var;
  generate
    for (pwrb_var=0; pwrb_var<NUMVBNK; pwrb_var=pwrb_var+1) begin: pwrb_loop
      for (pwrd_var=0; pwrd_var<=NUMGRPC+1+2; pwrd_var=pwrd_var+1) begin: pwrd_loop
        if (pwrd_var==0) begin: init_loop
          always @(posedge clk)
            pwrbus_reg[pwrb_var][pwrd_var] <= pwrbus[pwrb_var];
        end else begin: flop_loop
          always @(posedge clk)
            pwrbus_reg[pwrb_var][pwrd_var] <= pwrbus_reg[pwrb_var][pwrd_var-1];
        end
      end
    end
  endgenerate

  reg t1_writeA_out [0:NUMVBNK-1][0:NUMGRPW-1];
  reg [BITVROW-1:0] t1_addrA_out [0:NUMVBNK-1][0:NUMGRPW-1];
 
  wire [NUMWRPT/WRBUSRED-1:0] pdibus [0:WIDTH-1][0:NUMVBNK];
  genvar pdib_int, pdig_int;
  generate
    for (pdib_int=0; pdib_int<NUMVBNK; pdib_int = pdib_int+1) begin: pdib_int_loop
      for (pdig_int=0; pdig_int<NUMGRPW; pdig_int = pdig_int+1) begin: pdig_int_loop
         always_comb begin
            t1_writeA_out[pdib_int][pdig_int] = t1_writeA_reg[pdib_int][(pdib_int>>BITCMDL)+(pdig_int/NUMGRPF)];
            t1_addrA_out[pdib_int][pdig_int] = t1_addrA_reg[pdib_int][(pdib_int>>BITCMDL)+(pdig_int/NUMGRPF)];
	 end
      end
    end
  endgenerate

  genvar pdib_var, pdiw_var, pdig_var;
  generate
    for (pdib_var=0; pdib_var<NUMVBNK; pdib_var = pdib_var+1) begin: pdib_loop
      for (pdiw_var=0; pdiw_var<WIDTH; pdiw_var= pdiw_var+1) begin: pdiw_loop
        if (pdib_var==0) begin: init_loop
          assign pdibus[pdiw_var][pdib_var] = pdinbus[pdiw_var];
        end
        if (((pdib_var % NUMCMDL) == (NUMCMDL-1)) && (pdib_var != (NUMVBNK-1))) begin : fl_loop
          pdin_slcdin_2bc #(.NUMWRPT(NUMWRPT), .WRBUSRED(WRBUSRED),
                        .FLOPPY(1)) inst
              (.cin (pdibus[pdiw_var][pdib_var]),
               .pwrbus (pwrbus_reg[pdib_var][(pdib_var>>BITCMDL)+(pdiw_var/(NUMGRPF*GRPWDTH))]),
               .bitdin (t1_din[pdib_var][pdiw_var]),
               .cout (pdibus[pdiw_var][pdib_var+1]),
               .clk (clk));
        end else begin
          pdin_slcdin_2bc #(.NUMWRPT(NUMWRPT), .WRBUSRED(WRBUSRED),
                        .FLOPPY(0)) inst
              (.cin (pdibus[pdiw_var][pdib_var]),
               .pwrbus (pwrbus_reg[pdib_var][(pdib_var>>BITCMDL)+(pdiw_var/(NUMGRPF*GRPWDTH))]),
               .bitdin (t1_din[pdib_var][pdiw_var]),
               .cout (pdibus[pdiw_var][pdib_var+1]),
               .clk (clk));
        end
      end
    end
  endgenerate

//Read part
//Formation of vread_out, vrdbadr_out and vrdradr_out
  integer vrdpo_int;
  always_comb begin
    for (vrdpo_int=0; vrdpo_int<NUMRDPT; vrdpo_int=vrdpo_int+1) begin
      vread_out[vrdpo_int] = vread_bus >> vrdpo_int;
      vrdbadr_out[vrdpo_int] = vrdbadr_bus_reg >> (vrdpo_int*BITVBNK);
      vrdradr_out[vrdpo_int] = vrdradr_bus_reg >> (vrdpo_int*BITVROW);
    end
  end

//Formation of t1_readB_bus and t1_addrB_bus
  reg [NUMVBNK-1:0] t1_readB_bus;
  reg [NUMVBNK*BITVROW-1:0] t1_addrB_bus;

  integer pbnk_int, prtb_int, prtw_int; 
  always_comb begin
    t1_readB_bus = 0;
    t1_addrB_bus = 0;
    for (pbnk_int=0; pbnk_int<NUMVBNK; pbnk_int=pbnk_int+1)
      for (prtb_int=0; prtb_int<NUMRDPT; prtb_int=prtb_int+1)
        if (vread_out[prtb_int] && (vrdbadr_out[prtb_int]==pbnk_int)) begin
          t1_readB_bus[pbnk_int] = 1'b1;
          for (prtw_int=0; prtw_int<BITVROW; prtw_int=prtw_int+1)
            t1_addrB_bus[pbnk_int*BITVROW+prtw_int] = vrdradr_out[prtb_int][prtw_int];
        end
  end
//Formation of t1_readB_wire and t1_addrB_wire
  reg t1_readB_wire [0:NUMVBNK-1];
  reg [BITVROW-1:0] t1_addrB_wire [0:NUMVBNK-1];
  integer t1r_int;
  always_comb
    for (t1r_int=0; t1r_int<NUMVBNK; t1r_int=t1r_int+1) begin
      t1_readB_wire[t1r_int] = t1_readB_bus >> t1r_int;
      t1_addrB_wire[t1r_int] = t1_addrB_bus >> (t1r_int*BITVROW);
    end

//Formation of vread_reg, vrdbadr_reg and vrdradr_reg
  reg vread_reg [0:NUMRDPT-1][0:NUMGRPC+2+2+3];
  reg [BITVBNK-1:0] vrdbadr_reg [0:NUMRDPT-1][0:NUMGRPC+2+2+3];
  reg [BITVROW-1:0] vrdradr_reg [0:NUMRDPT-1][0:NUMGRPC+2+2+3];
  integer vrdr_int, vrdd_int;
  always @(posedge clk)
    for (vrdr_int=0; vrdr_int<NUMRDPT; vrdr_int=vrdr_int+1)
      for (vrdd_int=0; vrdd_int<=NUMGRPC+2+2+3; vrdd_int=vrdd_int+1)
        if (vrdd_int>0) begin
          vread_reg[vrdr_int][vrdd_int] <= vread_reg[vrdr_int][vrdd_int-1];
          vrdbadr_reg[vrdr_int][vrdd_int] <= vrdbadr_reg[vrdr_int][vrdd_int-1];
          vrdradr_reg[vrdr_int][vrdd_int] <= vrdradr_reg[vrdr_int][vrdd_int-1];
        end else begin
          vread_reg[vrdr_int][vrdd_int] <= vread_out[vrdr_int];
          vrdbadr_reg[vrdr_int][vrdd_int] <= vrdbadr_out[vrdr_int];
          vrdradr_reg[vrdr_int][vrdd_int] <= vrdradr_out[vrdr_int];
        end

//Formation of t1_readB_reg and t1_addrB_reg
  reg t1_readB_out [0:NUMVBNK-1][0:NUMGRPW-1];
  reg [BITVROW-1:0] t1_addrB_out [0:NUMVBNK-1][0:NUMGRPW-1];

  reg t1_readB_reg [0:NUMVBNK-1][0:NUMGRPC+1+2];
  reg [BITVROW-1:0] t1_addrB_reg [0:NUMVBNK-1][0:NUMGRPC+1+2];
  genvar t1rb_var, t1rd_var;
  generate
    for (t1rb_var=0; t1rb_var<NUMVBNK; t1rb_var=t1rb_var+1) begin: t1rb_loop
      for (t1rd_var=0; t1rd_var<=NUMGRPC+1+2; t1rd_var=t1rd_var+1) begin: t1rd_loop
        if (t1rd_var==0) begin: init_loop
           always @(posedge clk) begin
            t1_readB_reg[t1rb_var][t1rd_var] <= t1_readB_wire[t1rb_var];
            t1_addrB_reg[t1rb_var][t1rd_var] <= t1_addrB_wire[t1rb_var];
	   end
        end else begin: flop_loop
           always @(posedge clk) begin
            t1_readB_reg[t1rb_var][t1rd_var] <= t1_readB_reg[t1rb_var][t1rd_var-1];
            t1_addrB_reg[t1rb_var][t1rd_var] <= t1_addrB_reg[t1rb_var][t1rd_var-1];
	   end
        end
      end
    end
  endgenerate

//Formation of pdoutbus and prdbus
  reg [GRPWDTH-1:0] pdoutbus [0:NUMVBNK-1][0:NUMGRPW-1];
  reg prdbus [0:NUMRDPT-1][0:NUMVBNK-1];
  integer pdor_int, pdob_int, pdog_int;
  always_comb begin
    for (pdor_int=0; pdor_int<NUMRDPT; pdor_int=pdor_int+1)
      for (pdob_int=0; pdob_int<NUMVBNK; pdob_int=pdob_int+1)
        prdbus[pdor_int][pdob_int] = 1'b0;

    for (pdor_int=0; pdor_int<NUMRDPT; pdor_int=pdor_int+1)
      for (pdob_int=0; pdob_int<NUMVBNK; pdob_int=pdob_int+1)
        if (vread_out[pdor_int] && (vrdbadr_out[pdor_int]==pdob_int))
          prdbus[pdor_int][pdob_int] = 1'b1;

    for (pdob_int=0; pdob_int<NUMVBNK; pdob_int=pdob_int+1)
        for (pdog_int=0; pdog_int<NUMGRPW; pdog_int=pdog_int+1)
	    pdoutbus[pdob_int][pdog_int] = t1_doutB >> (pdob_int*WIDTH+pdog_int*GRPWDTH);

  end

//Formation of prdbus_reg
  reg prdbus_reg [0:NUMRDPT-1][0:NUMVBNK-1][0:NUMGRPC+3+2];
  genvar prdr_var, prdb_var, prdd_var;
  generate
    for (prdr_var=0; prdr_var<NUMRDPT; prdr_var=prdr_var+1) begin: prdr_loop
      for (prdb_var=0; prdb_var<NUMVBNK; prdb_var=prdb_var+1) begin: prdb_loop
        for (prdd_var=0; prdd_var<=NUMGRPC+3+2; prdd_var=prdd_var+1) begin: prdd_loop
          if (prdd_var==0) begin: init_loop
            always @(posedge clk)
              prdbus_reg[prdr_var][prdb_var][prdd_var] <= prdbus[prdr_var][prdb_var];
          end else begin: flp_loop
            always @(posedge clk)
              prdbus_reg[prdr_var][prdb_var][prdd_var] <= prdbus_reg[prdr_var][prdb_var][prdd_var-1];
          end
        end
      end
    end
  endgenerate

//Formation of t1_readB_out and t1_addrB_out
  genvar dog_int, dob_int;
  generate
    for (dob_int=0; dob_int<NUMVBNK; dob_int=dob_int+1) begin: dob_loop
      for (dog_int=0; dog_int<NUMGRPW; dog_int=dog_int+1) begin: dog_loop
          always_comb begin
            t1_readB_out[dob_int][dog_int] = t1_readB_reg[dob_int][(dob_int>>BITCMDL)+(dog_int/NUMGRPF)];
            t1_addrB_out[dob_int][dog_int] = t1_addrB_reg[dob_int][(dob_int>>BITCMDL)+(dog_int/NUMGRPF)];
          end
      end
    end
  endgenerate
//Formation of pdobus
  reg [GRPWDTH-1:0] pdobus [0:NUMRDPT-1][0:NUMVBNK][0:NUMGRPW-1];
  genvar pdor_var, pdog_var, pdow_var, pdob_var;
  generate
    for (pdob_var=0; pdob_var<NUMVBNK; pdob_var=pdob_var+1) begin: pdob_loop
      for (pdor_var=0; pdor_var<NUMRDPT; pdor_var= pdor_var+1) begin: pdor_loop
        for (pdog_var=0; pdog_var<NUMGRPW; pdog_var= pdog_var+1) begin: pdog_loop
            if (pdob_var==0) begin: init_loop
              assign pdobus[pdor_var][pdob_var][pdog_var] = {GRPWDTH{1'b0}};
            end

            if ((pdob_var % NUMCMDL) == (NUMCMDL-1)) begin : fl_loop
              pdout_slcdout_2bc #(.FLOPPY (1), .GRPWDTH(GRPWDTH)) inst
                  (.cin (pdobus[pdor_var][pdob_var][pdog_var]),
                   .pdout (pdoutbus[pdob_var][pdog_var]),
                   .prdbus (prdbus_reg[pdor_var][pdob_var][(pdob_var>>BITCMDL)+(pdog_var/NUMGRPF)+2]),
                   .cout (pdobus[pdor_var][pdob_var+1][pdog_var]),
                   .clk (clk));
            end else begin : nfl_loop
              pdout_slcdout_2bc #(.FLOPPY (0), .GRPWDTH(GRPWDTH)) inst
                  (.cin (pdobus[pdor_var][pdob_var][pdog_var]),
                   .pdout (pdoutbus[pdob_var][pdog_var]),
                   .prdbus (prdbus_reg[pdor_var][pdob_var][(pdob_var>>BITCMDL)+(pdog_var/NUMGRPF)+2]),
                   .cout (pdobus[pdor_var][pdob_var+1][pdog_var]),
                   .clk (clk));
            end
        end
      end
    end
  endgenerate

//Formation of pdobus_reg
  reg [(WIDTH*NUMRDPT)-1:0] pdobus_reg_bus;
  reg [GRPWDTH-1:0] pdobus_reg [0:NUMRDPT-1][0:NUMGRPW-1];
  reg [GRPWDTH-1:0] pdobus_tmp [0:NUMRDPT-1][0:NUMGRPV-1][0:NUMGRPW-1];
  genvar pdrg_var, pdrw_var, prdgv_var;
  generate
    for (pdrg_var=0; pdrg_var<NUMRDPT; pdrg_var=pdrg_var+1) begin: pdrg_loop
      for (pdrw_var=0; pdrw_var<NUMGRPW; pdrw_var=pdrw_var+1) begin: pdrw_loop
        assign pdobus_tmp[pdrg_var][0][pdrw_var] = pdobus[pdrg_var][NUMVBNK][pdrw_var];
        for (prdgv_var=1; prdgv_var<NUMGRPV; prdgv_var=prdgv_var+1) begin: flp_loop
           always @(posedge clk)
            pdobus_tmp[pdrg_var][prdgv_var][pdrw_var] <= pdobus_tmp[pdrg_var][prdgv_var-1][pdrw_var];
        end
        assign pdobus_reg[pdrg_var][pdrw_var] = pdobus_tmp[pdrg_var][(NUMGRPV-1)-(pdrw_var/NUMGRPF)][pdrw_var];
      end
    end
  endgenerate

  integer prdpo_int,pwd_int,pgw_int;
  always_comb begin
    pdobus_reg_bus = 0;
    for (prdpo_int=0; prdpo_int<NUMRDPT; prdpo_int=prdpo_int+1)
      for (pwd_int=0; pwd_int<NUMGRPW; pwd_int=pwd_int+1)
        for (pgw_int=0; pgw_int<GRPWDTH; pgw_int=pgw_int+1)
	  if (pwd_int*GRPWDTH+pgw_int < WIDTH)
            pdobus_reg_bus[prdpo_int*WIDTH+pwd_int*GRPWDTH+pgw_int] = pdobus_reg[prdpo_int][pwd_int][pgw_int];
  end


  reg vread_vld_wire [0:NUMRDPT-1];
  reg [BITPADR-1:0] vread_padr_wire [0:NUMRDPT-1];
  integer vdop_int;
  always_comb
    for (vdop_int=0; vdop_int<NUMRDPT; vdop_int=vdop_int+1) begin
      vread_vld_wire[vdop_int] = vread_reg[vdop_int][NUMGRPC+2+2+3];
      vread_padr_wire[vdop_int] = {vrdbadr_reg[vdop_int][NUMGRPC+2+2+3],vrdradr_reg[vdop_int][NUMGRPC+2+2+3]};
  end

  reg [NUMRDPT-1:0] vread_vld_bus;
  reg [(BITPADR*NUMRDPT)-1:0] vread_padr_bus;
  integer prba_int, prdp_int;
  always_comb begin
    for (prdp_int=0; prdp_int<NUMRDPT; prdp_int=prdp_int+1) begin
      vread_vld_bus[prdp_int] = vread_vld_wire[prdp_int];
      for (prba_int=0; prba_int<BITPADR; prba_int=prba_int+1)
        vread_padr_bus[prdp_int*BITPADR+prba_int] = vread_padr_wire[prdp_int][prba_int];
    end
  end


//Formation of t type signals. Final part.
  reg [NUMGRPW*NUMVBNK - 1:0] t1_writeA;
  reg [NUMGRPW*NUMVBNK*BITVROW - 1:0] t1_addrA;
  reg [NUMGRPW*NUMVBNK- 1:0]          t1_readB;
  reg [NUMGRPW*NUMVBNK*BITVROW - 1:0] t1_addrB;

  integer t1p_int, t1g_int;
  always_comb begin
    t1_writeA = 0;
    t1_addrA = 0;
    t1_readB = 0;
    t1_addrB = 0;
    for (t1p_int=0; t1p_int<NUMVBNK; t1p_int=t1p_int+1)
      for (t1g_int=0; t1g_int<NUMGRPW; t1g_int=t1g_int+1) begin
          t1_writeA = t1_writeA | (t1_writeA_out[t1p_int][t1g_int] << (t1p_int*NUMGRPW+t1g_int));
          t1_addrA = t1_addrA | (t1_addrA_out[t1p_int][t1g_int] << ((t1p_int*NUMGRPW+t1g_int)*BITVROW));
          t1_readB = t1_readB | (t1_readB_out[t1p_int][t1g_int] << (t1p_int*NUMGRPW+t1g_int));
          t1_addrB = t1_addrB | (t1_addrB_out[t1p_int][t1g_int] << ((t1p_int*NUMGRPW+t1g_int)*BITVROW));
      end
  end

endmodule



