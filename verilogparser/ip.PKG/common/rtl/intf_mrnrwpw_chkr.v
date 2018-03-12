module intf_mrnrwpw_chkr (refr, 
                          read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
                          rw_read, rw_write, rw_addr, rw_din, rw_vld, rw_dout, rw_serr, rw_derr, rw_padr,
                          write, wr_adr, din,
                          cnt, ct_adr, ct_imm, ct_vld, ct_serr, ct_derr,
                          ac_read, ac_write, ac_addr, ac_din, ac_vld, ac_dout, ac_serr, ac_derr, ac_padr,
                          clk, ready, rst);

  parameter WIDTH = 4;
  parameter NUMADDR = 16;
  parameter BITADDR = 4;
  parameter NUMRDPT = 2;
  parameter NUMRWPT = 0;
  parameter NUMWRPT = 1;
  parameter NUMCTPT = 0;
  parameter NUMACPT = 0;
  parameter BITPADR = 17;

  parameter REFRESH = 0;
  parameter REFFREQ = 16;
  parameter REFFRHF = 0;

  parameter RDOR1WR = 0;
  parameter CTOR1AC = 0;

  input                        refr;

  input [NUMRDPT-1:0]          read;
  input [NUMRDPT*BITADDR-1:0]  rd_adr;
  output [NUMRDPT-1:0]         rd_vld;
  output [NUMRDPT*WIDTH-1:0]   rd_dout;
  output [NUMRDPT-1:0]         rd_serr;
  output [NUMRDPT-1:0]         rd_derr;
  output [NUMRDPT*BITPADR-1:0] rd_padr;

  input [NUMRWPT-1:0]          rw_read;
  input [NUMRWPT-1:0]          rw_write;
  input [NUMRWPT*BITADDR-1:0]  rw_addr;
  input [NUMRWPT*WIDTH-1:0]    rw_din;
  output [NUMRWPT-1:0]         rw_vld;
  output [NUMRWPT*WIDTH-1:0]   rw_dout;
  output [NUMRWPT-1:0]         rw_serr;
  output [NUMRWPT-1:0]         rw_derr;
  output [NUMRWPT*BITPADR-1:0] rw_padr;

  input [NUMWRPT-1:0]          write;
  input [NUMWRPT*BITADDR-1:0]  wr_adr;
  input [NUMWRPT*WIDTH-1:0]    din;

  input [NUMCTPT-1:0]          cnt;
  input [NUMCTPT*BITADDR-1:0]  ct_adr;
  input [NUMCTPT*WIDTH-1:0]    ct_imm;
  output [NUMCTPT-1:0]         ct_vld;
  output [NUMCTPT-1:0]         ct_serr;
  output [NUMCTPT-1:0]         ct_derr;

  input [NUMACPT-1:0]          ac_read;
  input [NUMACPT-1:0]          ac_write;
  input [NUMACPT*BITADDR-1:0]  ac_addr;
  input [NUMACPT*WIDTH-1:0]    ac_din;
  output [NUMACPT-1:0]         ac_vld;
  output [NUMACPT*WIDTH-1:0]   ac_dout;
  output [NUMACPT-1:0]         ac_serr;
  output [NUMACPT-1:0]         ac_derr;
  output [NUMACPT*BITPADR-1:0] ac_padr;

  input                        clk;
  input                        rst;
  input                        ready;

//synopsys translate_off
  wire               read_wire [0:NUMRDPT-1];
  wire [BITADDR-1:0] rd_adr_wire [0:NUMRDPT-1];
  wire               rw_read_wire [0:NUMRWPT-1];
  wire               rw_write_wire [0:NUMRWPT-1];
  wire [BITADDR-1:0] rw_addr_wire [0:NUMRWPT-1];
  wire               write_wire [0:NUMWRPT-1];
  wire [BITADDR-1:0] wr_adr_wire [0:NUMWRPT-1];
  wire               cnt_wire [0:NUMCTPT-1];
  wire [BITADDR-1:0] ct_adr_wire [0:NUMCTPT-1];
  wire               ac_read_wire [0:NUMACPT-1];
  wire               ac_write_wire [0:NUMACPT-1];
  wire [BITADDR-1:0] ac_addr_wire [0:NUMACPT-1];
  integer bus_int;

  genvar prt_var;
  generate if (1) begin: prt_loop
    for (prt_var=0; prt_var<NUMRDPT; prt_var=prt_var+1) begin: rd_loop
      assign read_wire[prt_var] = read >> prt_var;
      assign rd_adr_wire[prt_var] = rd_adr >> (prt_var*BITADDR);
    end
    for (prt_var=0; prt_var<NUMRWPT; prt_var=prt_var+1) begin: rw_loop
      assign rw_read_wire[prt_var] = rw_read >> prt_var;
      assign rw_write_wire[prt_var] = rw_write >> prt_var;
      assign rw_addr_wire[prt_var] = rw_addr >> (prt_var*BITADDR);
    end
    for (prt_var=0; prt_var<NUMWRPT; prt_var=prt_var+1) begin: wr_loop
      assign write_wire[prt_var] = write >> prt_var;
      assign wr_adr_wire[prt_var] = wr_adr >> (prt_var*BITADDR);
    end
    for (prt_var=0; prt_var<NUMCTPT; prt_var=prt_var+1) begin: ct_loop
      assign cnt_wire[prt_var] = cnt >> prt_var;
      assign ct_adr_wire[prt_var] = ct_adr >> (prt_var*BITADDR);
    end
    for (prt_var=0; prt_var<NUMACPT; prt_var=prt_var+1) begin: ac_loop
      assign ac_read_wire[prt_var] = ac_read >> prt_var;
      assign ac_write_wire[prt_var] = ac_write >> prt_var;
      assign ac_addr_wire[prt_var] = ac_addr >> (prt_var*BITADDR);
    end
  end
  endgenerate

  generate if (REFRESH) begin: refr_loop
    reg [31:0] refr_cnt;
    reg refr_half;
    always @(posedge clk)
      if (!ready) begin
        refr_cnt <= 0;
        refr_half <= REFFRHF;
      end else if (refr) begin
        refr_cnt <= 0;
        refr_half <= REFFRHF && (refr_cnt < REFFREQ); 
      end else begin
        refr_cnt <= refr_cnt + 1; 
      end

    always @(posedge clk) begin
      if (ready && refr && (NUMRDPT>0) && |read)
        $display("Error:%0t: Read command invalidated, read signal high when refresh is asserted",$time);
      if (ready && refr && (NUMRWPT>0) && |rw_read)
        $display("Error:%0t: Read/Write command invalidated, read signal high when refresh is asserted",$time);
      if (ready && refr && (NUMRWPT>0) && |rw_write)
        $display("Error:%0t: Read/Write command invalidated, write signal high when refresh is asserted",$time);
      if (ready && refr && (NUMRDPT>0) && |write)
        $display("Error:%0t: Write command invalidated, write signal high when refresh is asserted",$time);
      if (ready && (refr_cnt >= REFFREQ+refr_half))
        $display("Error:%0t: No refresh in the last N cycles",$time);
    end
  end
  endgenerate

  generate if (RDOR1WR) begin: rorw_loop
    always @(posedge clk)
      if (ready && write && |read)
        $display("Error:%0t: Read command invalidated, read signal high when write is asserted",$time);
  end
  endgenerate

  generate if (CTOR1AC) begin: cora_loop
    always @(posedge clk)
      if (ready && (ac_read || ac_write) && |cnt)
        $display("Error:%0t: Count command invalidated, cnt signal high when access is asserted",$time);
  end
  endgenerate

  genvar ass_var;
  generate if (1) begin: ass_loop
    for (ass_var=0; ass_var<NUMRDPT; ass_var=ass_var+1) begin: rd_loop
      always @(posedge clk) begin
        if (ready && (read_wire[ass_var] === 1'bx)) 
          $display("Error:%0t: Read command invalidated, read signal is unknown",$time);
        if (ready && read_wire[ass_var] && (^rd_adr_wire[ass_var] === 1'bx)) 
          $display("Error:%0t: Read command invalidated, read address is unknown",$time);
        if (ready && read_wire[ass_var] && (rd_adr_wire[ass_var] >= NUMADDR))
          $display("Error:%0t: Read command invalidated, read address out of range",$time);
      end
    end
    for (ass_var=0; ass_var<NUMRWPT; ass_var=ass_var+1) begin: rw_loop
      always @(posedge clk) begin
        if (ready && (rw_read_wire[ass_var] === 1'bx))
          $display("Error:%0t: Read/Write command invalidated, read signal is unknown",$time);
        if (ready && (rw_write_wire[ass_var] === 1'bx))
          $display("Error:%0t: Read/Write command invalidated, write signal is unknown",$time);
        if (ready && rw_read_wire[ass_var] && rw_write_wire[ass_var])
          $display("Error:%0t: Read/Write command invalidated, read signal high when write is asserted",$time);
        if (ready && rw_read_wire[ass_var] && (^rw_addr_wire[ass_var] === 1'bx)) 
          $display("Error:%0t: Read/Write command invalidated, read address is unknown",$time);
        if (ready && rw_read_wire[ass_var] && (rw_addr_wire[ass_var] >= NUMADDR))
          $display("Error:%0t: Read/Write command invalidated, read address out of range",$time);
        if (ready && rw_write_wire[ass_var] && (^rw_addr_wire[ass_var] === 1'bx)) 
          $display("Error:%0t: Read/Write command invalidated, write address is unknown",$time);
        if (ready && rw_write_wire[ass_var] && (rw_addr_wire[ass_var] >= NUMADDR))
          $display("Error:%0t: Read/Write command invalidated, write address out of range",$time);
      end
    end
    for (ass_var=0; ass_var<NUMWRPT; ass_var=ass_var+1) begin: wr_loop
      always @(posedge clk) begin
        if (ready && (write_wire[ass_var] === 1'bx))
          $display("Error:%0t: Write command invalidated, write signal is unknown",$time);
        if (ready && write_wire[ass_var] && (^wr_adr_wire[ass_var] === 1'bx)) 
          $display("Error:%0t: Write command invalidated, write address is unknown",$time);
        if (ready && write_wire[ass_var] && (wr_adr_wire[ass_var] >= NUMADDR))
          $display("Error:%0t: Write command invalidated, write address out of range",$time);
      end
    end
    for (ass_var=0; ass_var<NUMCTPT; ass_var=ass_var+1) begin: ct_loop
      always @(posedge clk) begin
        if (ready && (cnt_wire[ass_var] === 1'bx))
          $display("Error:%0t: Count command invalidated, count signal is unknown",$time);
        if (ready && cnt_wire[ass_var] && (^ct_adr_wire[ass_var] === 1'bx)) 
          $display("Error:%0t: Count command invalidated, count address is unknown",$time);
        if (ready && cnt_wire[ass_var] && (ct_adr_wire[ass_var] >= NUMADDR))
          $display("Error:%0t: Count command invalidated, count address out of range",$time);
      end
    end
    for (ass_var=0; ass_var<NUMACPT; ass_var=ass_var+1) begin: ac_loop
      always @(posedge clk) begin
        if (ready && (ac_read_wire[ass_var] === 1'bx))
          $display("Error:%0t: Access command invalidated, read signal is unknown",$time);
        if (ready && (ac_write_wire[ass_var] === 1'bx))
          $display("Error:%0t: Access command invalidated, write signal is unknown",$time);
        if (ready && ac_read_wire[ass_var] && (^ac_addr_wire[ass_var] === 1'bx)) 
          $display("Error:%0t: Access command invalidated, read address is unknown",$time);
        if (ready && ac_read_wire[ass_var] && (ac_addr_wire[ass_var] >= NUMADDR))
          $display("Error:%0t: Access command invalidated, read address out of range",$time);
        if (ready && ac_write_wire[ass_var] && (^ac_addr_wire[ass_var] === 1'bx)) 
          $display("Error:%0t: Access command invalidated, write address is unknown",$time);
        if (ready && ac_write_wire[ass_var] && (ac_addr_wire[ass_var] >= NUMADDR))
          $display("Error:%0t: Access command invalidated, write address out of range",$time);
      end
    end
  end
  endgenerate
//synopsys translate_on
endmodule

