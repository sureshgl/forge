interface Misc_Ifc (input clk);
  logic           rst;
  logic           ready;
  logic           refr;           

  clocking tb_req @(posedge clk);
    output        rst;
  endclocking

  clocking tb_rsp @(posedge clk);
    default input #30 output #10;
    input         ready;
    input         refr;
  endclocking

  modport tb (output rst, input ready, input refr); 

endinterface

