
module np2_addr_ramwrap (
  vbadr, vradr, vaddr
);

parameter     NUMADDR = 8192;
parameter     BITADDR = 13;
parameter     NUMVBNK = 8;
parameter     BITVBNK = 3;
parameter     BITPBNK = BITVBNK;
parameter     NUMVROW = 1024;
parameter     BITVROW = 10;
localparam    LBITPBK = BITPBNK>0 ? BITPBNK : 1;
  
output reg [LBITPBK-1:0] vbadr;
output reg [BITVROW-1:0] vradr;

input [BITADDR-1:0] vaddr;

  integer v_int;
  integer v1_int, v2_int;

generate if (BITVBNK==0) begin: one_loop
  wire vbadr_tmp = 0;
  always_comb begin
    vbadr = vbadr_tmp;
    vradr = vaddr;
  end
end else begin: two_loop    
  always_comb begin
    v1_int = 0;
    v2_int = 0;
    if (NUMVBNK*NUMVROW == NUMADDR)
      if (NUMVROW == (1'b1 << BITVROW)) begin
        vbadr = vaddr >> BITVROW;
        vradr = vaddr & {BITVROW{1'b1}};
      end else if (NUMVBNK == (1'b1 << BITVBNK)) begin
//        vbadr = ~0;
//        vradr = 0;
//        if (vaddr < NUMVBNK*NUMVROW) begin
          vbadr = vaddr & {BITVBNK{1'b1}};
          vradr = vaddr >> BITVBNK;
//        end
      end else begin
        vbadr = ~0;
        vradr = 0;
        for (v_int=0; v_int<=BITVROW-1; v_int=v_int+1)

          if (NUMVROW & (1'b1 << v_int)) begin
            v1_int = ((~0) << v_int) & NUMVROW;
            v2_int = ((~0) << (v_int+1)) & NUMVROW;
            if (vaddr < NUMVBNK*v1_int) begin
              vbadr = (vaddr - NUMVBNK*v2_int) >> v_int;
              vradr = (~((~0) << v_int) & vaddr[BITVROW-1:0]) | v2_int;
            end
          end
      end
    else
      if (vaddr >= NUMVBNK*NUMVROW) begin
        vbadr = ~0;
        vradr = 0;
      end else if (vaddr >= (NUMVBNK-1)*NUMVROW) begin
        vbadr = NUMVBNK-1;
        vradr = vaddr - (NUMVBNK-1)*NUMVROW;
      end else if (NUMVROW == (1'b1 << BITVROW)) begin
        vbadr = vaddr >> BITVROW;
        vradr = vaddr & {BITVROW{1'b1}};
      end else if ((NUMVBNK-1) == (1'b1 << BITVBNK)) begin
        vbadr = vaddr & {BITVBNK{1'b1}};
        vradr = vaddr >> BITVBNK;
      end else begin
        vbadr = ~0;
        vradr = 0;
        for (v_int=0; v_int<=BITVROW-1; v_int=v_int+1)
          if (NUMVROW & (1'b1 << v_int)) begin
            v1_int = ((~0) << v_int) & NUMVROW;
            v2_int = ((~0) << (v_int+1)) & NUMVROW;
            if (vaddr < (NUMVBNK-1)*v1_int) begin
              vbadr = (vaddr - (NUMVBNK-1)*v2_int) >> v_int;
              vradr = (~((~0) << v_int) & vaddr[BITVROW-1:0]) | v2_int;
            end
          end
      end
  end
end
endgenerate

endmodule
