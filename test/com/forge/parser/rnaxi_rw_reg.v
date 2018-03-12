module rnaxi_rw_reg 
  (
    clk,
    rst,
    field_wr_en,
    field_rd_en,
    field_wr_data,
    field_out,
    field_rd_trigger,
    field_wr_trigger
   );

   parameter FIELD_WIDTH  = 2048;
   parameter FIELD_RST_VALUE  = 2048'h0;
   parameter FIELD_WRITE_TRIGGER  = 1'b0;
   parameter FIELD_READ_TRIGGER  = 1'b0;
   parameter FIELD_READ_CLEAR  = 1'b0;

   input clk;
   input rst;
   input [FIELD_WIDTH-1:0] field_wr_data;
   input [FIELD_WIDTH-1:0] field_wr_en;
   input [FIELD_WIDTH-1:0] field_rd_en;

   output reg [FIELD_WIDTH-1:0] field_out;
   output reg field_rd_trigger;
   output reg field_wr_trigger;
   
   wire [FIELD_WIDTH-1:0]reg_out_temp1;
   wire [FIELD_WIDTH-1:0]reg_out_temp2;
   wire read_on_clear;

   always @(posedge clk or posedge rst) begin
     if (rst) begin 
        field_out <= FIELD_RST_VALUE;
     end else if(|field_wr_en) begin
        field_out <= reg_out_temp1 | reg_out_temp2 ;
     end else if(read_on_clear) begin
        field_out <= {FIELD_WIDTH{1'h0}};
     end
   end

  assign reg_out_temp1 = (~field_wr_en) & field_out;
  assign reg_out_temp2 = (field_wr_en & field_wr_data);
  
  generate 
  	if (FIELD_READ_CLEAR) begin
	  assign read_on_clear = |field_rd_en;
	end else begin
	  assign read_on_clear = 1'b0;
	end
  endgenerate

  generate 
  	if (FIELD_WRITE_TRIGGER) begin
	  assign field_wr_trigger = |field_wr_en;
	end else begin
	  assign field_wr_trigger = 1'b0;
	end
  endgenerate
  
  generate 
  	if (FIELD_READ_TRIGGER) begin
	  assign field_rd_trigger = |field_rd_en;
	end else begin
	  assign field_rd_trigger = 1'b0;
	end
  endgenerate

endmodule
