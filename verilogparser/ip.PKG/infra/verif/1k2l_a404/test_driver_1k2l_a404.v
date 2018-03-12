/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */
module test_driver_1k2l_a404 (
                    push, pu_adr, pu_din,
                    pop, po_adr, po_dvld, po_dout,
                    freecnt,
                    clk, ready, rst);

parameter DEPTH = 32;
parameter BITADDR = 5;
parameter WIDTH   = 8;
parameter BITPADR = 16;

parameter NUMPUPT = 2;
parameter NUMPOPT = 1;

parameter BITPUPT = 1;

parameter NUMQUEU = 64;
parameter BITQUEU = 6;
parameter NUMCELL = 48;
parameter BITCELL = 6;

parameter DELAY = 4;
parameter WAITCYC = 8;

parameter BITQCNT = BITADDR+1;

parameter TB_HALF_CLK_PER = 1000;

parameter TB_VPD_DUMP_FILE = "dump.vpd";

output [NUMPUPT-1:0]         push;
output [NUMPUPT*BITQUEU-1:0] pu_adr;
output [NUMPUPT*WIDTH-1:0]   pu_din; 

output [NUMPOPT-1:0]         pop;
output [NUMPOPT*BITQUEU-1:0] po_adr;
input [NUMPOPT-1:0]          po_dvld;
input [NUMPOPT*WIDTH-1:0]    po_dout; 

input [BITQCNT-1:0]          freecnt;
output                       clk;
output                       rst;
input                        ready;

reg                       clk;
reg                       rst;
reg [NUMPUPT-1:0]         push;
reg [NUMPUPT*BITQUEU-1:0] pu_adr;
reg [NUMPUPT*WIDTH-1:0]   pu_din; 
reg [NUMPOPT-1:0]         pop;
reg [NUMPOPT*BITQUEU-1:0] po_adr;

reg [WIDTH-1:0] mem [0:NUMQUEU-1][0:DEPTH-1];
reg [BITADDR:0] quecnt[0:NUMQUEU-1];
reg [BITADDR:0] quecnt_nxt[0:NUMQUEU-1];
reg [BITADDR:0] pu_mem_adr[0:NUMQUEU-1];
reg [BITADDR:0] pu_mem_adr_nxt[0:NUMQUEU-1];
reg [BITADDR:0] po_mem_adr[0:NUMQUEU-1];
reg [BITADDR:0] po_mem_adr_nxt[0:NUMQUEU-1];
reg [BITADDR:0] master_cnt;
reg [BITADDR:0] master_cnt_nxt;
reg [BITADDR:0] master_cnt_pu[0:1-1];

parameter INITCNT = 2*(4+1);

always @(posedge clk) begin
  master_cnt_pu[0] = master_cnt;
end
initial begin
  push = 1'b0;
  pop = 1'b0;
end

task cyc;
  input [31:0] cycles;
  integer i;
  begin
    if (cycles > 0) begin
      for (i=0; i<cycles; i=i+1)
        @(posedge clk);
      #(TB_HALF_CLK_PER/2);
    end
  end
endtask

task reset;
begin
  `TB_YAP("asserting reset")
  rst = 1;
  cyc (20);
  rst = 0;
  while (!ready)
    cyc (1);
end
endtask

reg push_wire[0:NUMPUPT-1];
reg [WIDTH-1:0] pu_din_wire [0:NUMPUPT-1];
reg [BITQUEU-1:0] pu_adr_wire [0:NUMPUPT-1];
task push_one;
  integer i;
  input [NUMPUPT-1:0] pu;
  input [NUMPUPT*BITQUEU-1:0] pu_prt;
  input [NUMPUPT*WIDTH-1:0] pu_data;
  begin
    for (i=0;i<NUMPUPT;i++) begin
      pu_adr_wire[i] = pu_prt >> (i*BITQUEU);
      pu_din_wire[i] = pu_data >> (i*WIDTH);
    end
    if(pu_adr_wire[1] != pu_adr_wire[0])
      push = pu;
      pu_adr = pu_prt;
      pu_din = pu_data;
    for (i=0;i<NUMPUPT;i++) 
      push_wire[i] = push >> i;
      
    cyc(1);
    push = 2'b00;
    pu_adr = 'x;
    pu_din = 'x;
    for (i=0;i<NUMPUPT;i++) begin
      push_wire[i] = push >> i;
      pu_adr_wire[i] = pu_adr >> (i*BITQUEU);
      pu_din_wire[i] = pu_din >> (i*WIDTH);
    end
  end
endtask

task pop_one;
  input [BITQUEU-1:0] pu_prt;
  begin
    pop = 1'b1;
    po_adr = pu_prt;
    cyc(1);
    pop = 1'b0;
    po_adr = 'x;
  end
endtask
 
function [NUMPUPT*WIDTH-1:0] randomPUvalue; input integer width; integer i; begin randomPUvalue = 0; for (i = width/32; i >= 0; i--) randomPUvalue = (randomPUvalue << 32) + $urandom; end endfunction

function max_depth_test; 
  input depth;
  begin
    max_depth_test = (depth > DEPTH);
  end
endfunction


task push_all;
  integer m;
  reg [BITQUEU-1:0] puadr_wire [0:NUMPUPT-1];
  reg [NUMPUPT-1:0] pu;
  reg [NUMPUPT*BITQUEU-1:0] addr;
  reg [NUMPUPT*WIDTH-1:0] data;
  begin
    `TB_YAP($psprintf("push_all running"))
    for (m=0; m<DEPTH/2; m=m+1) begin
      addr =0;
      data =0;
      pu = 0;
      for (integer i=0;i<NUMPUPT;i++) 
        puadr_wire[i] = 'bx;
      for (integer i=0;i<NUMPUPT;i++) begin
        puadr_wire[i] = (m+i)%NUMQUEU;
        pu = pu | (1 << i);
        addr = addr | (puadr_wire[i] << i*BITQUEU);
      end
      data = randomPUvalue(NUMPUPT*WIDTH);
      push_one(pu,addr,data);
      cyc(1);
    end
    `TB_YAP($psprintf("push_all completed"))
  end
endtask

task pop_all;
  integer m;
  begin
    `TB_YAP($psprintf("pop_all running"))
    for (m=0; m<DEPTH; m=m+1) begin
      if(quecnt[m%NUMQUEU] > 0)
        pop_one(m%NUMQUEU);
      cyc($urandom%WAITCYC);
    end
    `TB_YAP($psprintf("pop_all completed"))
  end
endtask

task pop_random;
  input [31:0] num;
  integer i,n;
  reg tmpacc;
  reg [BITQUEU-1:0] tmpadr;
  begin
    for(n=0;n<num;n=n+1) begin
       if ((n% 10000) == 0)
         `TB_YAP($psprintf("pop_random sent %0d of %0d", n, num))
      pop = 0;
      po_adr = 0;
      for(i=0;i<NUMPOPT; i= i+1) begin
        tmpacc =  ($urandom < 32'hC0000000);
        tmpadr = $urandom%NUMQUEU;
        while ((quecnt[tmpadr]  < 0)) begin
          tmpadr = $urandom%NUMQUEU;
        end
        pop = (tmpacc  && (master_cnt>0) && (quecnt[tmpadr] > 0));
        po_adr = (tmpadr << (i*BITQUEU));
        cyc(1);
        pop=0;
        po_adr = {BITQUEU{1'bx}};
      end
    end
  end
endtask

reg [BITPUPT:0] pu_cnt;
reg pu_wire[0:NUMPUPT-1];
initial begin
  pu_wire[0] = 0;
  pu_wire[1] = 0;
end

reg done;
reg done1;
reg [BITQUEU - 1:0] puadr_wire [0:NUMPUPT-1];
reg [BITQUEU - 1:0] push_addr;
task push_random;
  input [31:0] num;
  integer i,n,j;
  reg tmpacc;
  reg [BITQUEU-1:0] tmpadr;
  begin
    for(n=0;n<num;n=n+1) begin
      if ((n% 10000) == 0)
       `TB_YAP($psprintf("push_random sent %0d of %0d", n, num))
      push ={NUMPUPT{1'b0}};
      pu_adr = {NUMPUPT*BITQUEU{1'b0}};
      for(i=0;i<NUMPUPT;i=i+1) begin
        puadr_wire[i] = {BITQUEU{1'bx}};
        pu_cnt  = 0;
      end
      for(i=0;i<NUMPUPT;i=i+1) begin
        done = 0;
        done1 = 1;
        pu_wire[i]=0;
        tmpacc = ($urandom < 32'hC0000000);
        while (done ==0) begin
          push_addr[BITQUEU -1 :0] = ($urandom%NUMQUEU);
          for(j=0; j<i; j = j+1) begin
            if(puadr_wire[j] === (push_addr[BITQUEU -1 :0])) begin
              done = 0;
              j = NUMPUPT;
              done1 = 0;
              push_addr[BITQUEU -1 :0] = ($urandom%NUMQUEU);
            end else  begin
              done1 = (1 && (quecnt[push_addr] <= (DEPTH-1)));
            end
          end
          if(done1 == 1) begin
            done  = 1; 
            puadr_wire[i] = push_addr[BITQUEU -1 :0];
          end   
        end 
        pu_wire[i] = (tmpacc && (freecnt > pu_cnt) && (quecnt[puadr_wire[i]] < DEPTH));
        if ((freecnt == 0) && pu_wire[i]) begin
          $display ("freecnt = %0x, pu_cnt = %0d\n", freecnt, pu_cnt);
          cyc(20);
          $finish;
        end
        pu_cnt = pu_cnt+pu_wire[i];
      end
      for(i=0;i<NUMPUPT;i++) begin
        push = push | (pu_wire[i] << i);
        if (!((i>0) && (puadr_wire[i] == puadr_wire[i-1])))
          pu_adr = pu_adr | (puadr_wire[i] << (BITQUEU*i));
      end
      pu_din = randomPUvalue(NUMPUPT*WIDTH);
      for (i=0;i<NUMPUPT;i++) begin
        push_wire[i] = push >> i;
        pu_adr_wire[i] = pu_adr >> (i*BITQUEU);
        pu_din_wire[i] = pu_din >> (i*WIDTH);
      end
      cyc(1);
      push ={NUMPUPT{1'b0}};
      pu_adr = {NUMPUPT*BITQUEU{1'bx}};
      pu_din = {NUMPUPT*WIDTH{1'bx}};
      for (i=0;i<NUMPUPT;i++) begin
        push_wire[i] = push >> i;
        pu_adr_wire[i] = pu_adr >> (i*BITQUEU);
        pu_din_wire[i] = pu_din >> (i*WIDTH);
      end
    end
  end
endtask

task test_random;
  input [31:0] num;
  integer n;
  begin
  `TB_YAP("Running test_random")
    fork
      push_random(num);
      pop_random(num);
    join
  end
endtask

task test_random_queue;
  input [31:0] num;
  integer n,m,i;
  reg [BITQUEU-1:0] tmpque;
  reg [BITADDR-1:0] tmpdep;
  reg tmpacc;
  begin
  `TB_YAP("Running test_random_queue")
  for (i=0;i<NUMQUEU;i++) begin
    for(m=0;m<DEPTH;m=m+1) begin
      if((master_cnt >0) && (quecnt[tmpque] >0))
        pop_one(tmpque);
    end
  end
  `TB_YAP("full push followed by full pop for a random queue")
  for(n=0;n<10;n=n+1) begin
  tmpque = $urandom%NUMQUEU;
    for(m=0;m<DEPTH;m=m+1) begin 
      if((freecnt > 0) && (quecnt[tmpque] < DEPTH)) // && (master_cnt < (DEPTH-1)))
        push_one(2'b01,tmpque,randomPUvalue(WIDTH));
    end
    for(m=0;m<DEPTH;m=m+1) begin
      if((master_cnt >0) && (quecnt[tmpque] >0))
        pop_one(tmpque);
    end
  end
/*
  for(n=0;n<num;n=n+1) begin
       if ((n% 10000) == 0)
         `TB_YAP($psprintf("test_random_queue sent %0d of %0d", n, num))
    tmpdep = $urandom%DEPTH;
    tmpque = $urandom%NUMQUEU;
    for(m=0;m<tmpdep;m=m+1) begin 
      if((freecnt > 0) && (quecnt[tmpque] <DEPTH))
      push_one(2'b11,tmpque,randomPUvalue(WIDTH));
    end
    push = 1'b0;
    for(i=0;i<tmpdep;i=i+1) begin 
      if((master_cnt >0) && (quecnt[tmpque] >0))
      pop_one(tmpque);
    end
    pop=1'b0;
  end

  for(n=0;n<num;n=n+1) begin
   if ((n% 10000) == 0)
    `TB_YAP($psprintf("test_random_queue with varied depth."))
    pop = 0;
    for(i=0;i<NUMPOPT; i =i+1) begin
      tmpacc = ($urandom < 32'hC0000000);
      tmpque = $urandom%NUMQUEU;
      tmpdep = $urandom%DEPTH;
      while ((quecnt[tmpque]  < 0)) begin
        tmpque = $urandom%NUMQUEU;
      end
      for(m=0;m<tmpdep;m=m+1) begin
        pop=((tmpacc << i) && (master_cnt > 0) && (quecnt[tmpque] > 0));
        po_adr =tmpque;
        cyc(1);
      end 
      pop =0;
      po_adr = 'hx;
    end
    push = 0;
    for(i=0;i<NUMPUPT; i =i+1) begin
      tmpque = $urandom%NUMQUEU;
      tmpacc =  ($urandom < 32'hC0000000);
      tmpdep = $urandom%DEPTH;
      while ((quecnt[tmpque] >= DEPTH)) begin
        tmpque = $urandom%NUMQUEU;
      end 
      for(m=0;m<tmpdep;m=m+1) begin
        push=((tmpacc << i) && (freecnt > 0) && (quecnt[tmpque] < (DEPTH-1)));
        pu_adr =tmpque;
        pu_din = randomPUvalue(WIDTH);
        cyc(1);
      end
      push =0;
      pu_adr = 'hx;
      pu_din= 'hx;
    end
  end
  */
  end
endtask




reg [BITADDR -1:0] mem_fl;

initial begin
  clk = 0;
  forever #TB_HALF_CLK_PER clk = !clk;
end

integer bnk;
initial begin
  reset;
  `TB_YAP("Running tests")
  cyc(10);
  push_all;
  cyc(10);
  pop_all;
  cyc(20);
  test_random(DEPTH +20000);
  cyc(20);
  test_random_queue(10);
  cyc(10);
  `TB_YAP("tests completed")
  $finish;
end

integer mn_int, qn_int, pu_int;
always_comb begin
  master_cnt_nxt = master_cnt;
  for(qn_int=0;qn_int<NUMQUEU;qn_int=qn_int+1) begin
    quecnt_nxt[qn_int] = quecnt[qn_int];
    pu_mem_adr_nxt[qn_int] = pu_mem_adr[qn_int];
    po_mem_adr_nxt[qn_int] = po_mem_adr[qn_int];
  end
  for(pu_int=0;pu_int<NUMPUPT;pu_int++) begin
    if (push_wire[pu_int] && (master_cnt <= DEPTH)) begin
      quecnt_nxt[pu_adr_wire[pu_int]] =  quecnt_nxt[pu_adr_wire[pu_int]] + 1;
      master_cnt_nxt = master_cnt_nxt + 1;
      pu_mem_adr_nxt[pu_adr_wire[pu_int]] = ((quecnt[pu_adr_wire[pu_int]] === (DEPTH-1)) || pu_mem_adr_nxt[pu_adr_wire[pu_int]] === (DEPTH-1))? 0 : pu_mem_adr_nxt[pu_adr_wire[pu_int]]+1;
    end
  end
  if (pop && (master_cnt > 0)) begin
    quecnt_nxt[po_adr] = (quecnt[po_adr] > 0) ? (quecnt_nxt[po_adr] - 1) : quecnt_nxt[po_adr];
    master_cnt_nxt = (quecnt[po_adr] >0) ? (master_cnt_nxt - 1) : master_cnt_nxt;
    po_mem_adr_nxt[po_adr] = (quecnt[po_adr] > 0) ? ((po_mem_adr_nxt[po_adr] === (DEPTH-1)) ? 0 : (po_mem_adr_nxt[po_adr]+1)) :   po_mem_adr_nxt[po_adr];
  end
end

integer m_int, pn_int, q_int;
always @(posedge clk) begin
  if (rst) begin
    master_cnt <= 0;
    for(q_int=0;q_int<NUMQUEU;q_int=q_int+1) begin
      quecnt[q_int] <= 0;
      pu_mem_adr[q_int] <= 0;
      po_mem_adr[q_int] <= 0;
    end
  end else begin
    master_cnt <= master_cnt_nxt;
    for(pn_int=0;pn_int<NUMPUPT;pn_int++)
      mem[pu_adr_wire[pn_int]][pu_mem_adr[pu_adr_wire[pn_int]]] <= (push_wire[pn_int] && (master_cnt <= DEPTH)) ? pu_din_wire[pn_int] : mem[pu_adr_wire[pn_int]][pu_mem_adr[pu_adr_wire[pn_int]]];
    for(q_int=0;q_int<NUMQUEU;q_int=q_int+1) begin
      quecnt[q_int] <= quecnt_nxt[q_int];
      pu_mem_adr[q_int] <= pu_mem_adr_nxt[q_int];
      po_mem_adr[q_int] <= po_mem_adr_nxt[q_int];
    end
  end
end

reg mismatch;

reg pop_dly[0:DELAY-1];
reg [BITQUEU-1:0] po_adr_dly [0:DELAY-1];
reg [BITADDR:0] quecnt_dly[0:NUMQUEU-1][0:DELAY-1];
reg [BITADDR:0] po_mem_adr_dly[0:NUMQUEU-1][0:DELAY-1];
reg [BITADDR:0] master_cnt_dly [0:DELAY-1];
integer i,j;
always@(negedge clk)
  if (rst) begin
    mismatch <= 0;
    for (i=0;i<DELAY;i=i+1) begin
      pop_dly[i] <= 0;
      po_adr_dly[i] <= 0;
      master_cnt_dly[i] <= 0;
      for (j=0;j<NUMQUEU;j=j+1) begin
        po_mem_adr_dly[j][i] <= 0;
      end
    end
  end else begin
    for (i=0;i<DELAY;i=i+1)
      if (i>0) begin
        pop_dly[i] <= pop_dly[i-1];
        po_adr_dly[i] <= po_adr_dly[i-1];
        master_cnt_dly[i] <= master_cnt_dly[i-1];
        for (j=0;j<NUMQUEU;j=j+1) begin
          quecnt_dly[j][i] <= quecnt_dly[j][i-1];
          po_mem_adr_dly[j][i] <= po_mem_adr_dly[j][i-1];
        end
      end else begin
        pop_dly[i] <= pop;
        po_adr_dly[i] <= po_adr;
        master_cnt_dly[i] <= master_cnt;
        for (j=0;j<NUMQUEU;j=j+1) begin
          quecnt_dly[j][i] <= quecnt[j];
          po_mem_adr_dly[j][i] <= po_mem_adr[j];
        end
      end
      if (pop_dly[DELAY-1] && master_cnt_dly[DELAY-1] > 0 && quecnt_dly[po_adr_dly[DELAY-1]][DELAY-1] > 0)
        if (po_dvld) begin 
          mismatch <= mismatch | (po_dout !== mem[po_adr_dly[DELAY-1]][po_mem_adr_dly[po_adr_dly[DELAY-1]][DELAY-1]]);
      end
    end
always@(posedge clk) begin
  if (mismatch) begin
    $display("%t: Mismatch @ queue %0x . exp is %0x act is %0x at %d", $time, po_adr_dly[DELAY-1], mem[po_adr_dly[DELAY-1]][po_mem_adr_dly[po_adr_dly[DELAY-1]][DELAY-1]], po_dout,$time);
    cyc(2);
    $finish;
  end
end

wire [WIDTH-1:0] mem_dbg = mem[po_adr_dly[DELAY-1]][po_mem_adr_dly[po_adr_dly[DELAY-1]][DELAY-1]];
wire [NUMQUEU-1:0] po_adr_dly_dbg = po_adr_dly[DELAY-1];
wire [WIDTH-1:0] po_dout_dbg = po_dout;


endmodule
