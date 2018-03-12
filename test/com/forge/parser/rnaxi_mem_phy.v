// *
// *  $Description: RNAXI mem intf 
// *  $Owner: Surya Vinnakota
// *  $Author: suvinnak
// *  $Source:  $
// *  $Revision: 1.0 $
// *  $Date: 2017/08/16 $
// * 
// *---------------------------------------------------------------------------*/
module rnaxi_mem_phy 
  (
    clk,
    rst,
    mem_wr_en,
    mem_rd_en,
    mem_wr_data,
    mem_rd_data,
    mem_addr,
    mem_phy_addr,
    mem_phy_wr_data,
    mem_phy_rd_data,
    mem_phy_wr_en,
    mem_phy_rd_en,
    ack_out,
    ack_in
   );

   parameter MEM_ROW_SIZE_IN_WORDS = 64;
   parameter MEM_ROW_DATA_WIDTH = 2048;
   parameter MEM_ADDR_WIDTH = 32;

   input clk;
   input rst;
   input [MEM_ROW_SIZE_IN_WORDS-1:0] mem_wr_en;
   input  mem_rd_en;
   input [MEM_ROW_DATA_WIDTH-1:0] mem_wr_data;
   input [MEM_ROW_DATA_WIDTH-1:0] mem_phy_rd_data;
   input [MEM_ADDR_WIDTH-1:0] mem_addr;
   input ack_in;

   output reg [MEM_ROW_DATA_WIDTH-1:0] mem_phy_wr_data;
   output reg [MEM_ROW_DATA_WIDTH-1:0] mem_rd_data;
   output reg [MEM_ROW_SIZE_IN_WORDS-1:0] mem_phy_wr_en;
   output reg [MEM_ADDR_WIDTH-1:0] mem_phy_addr;
   output reg mem_phy_rd_en;
   output reg ack_out;
   

   always @(posedge clk or posedge rst) begin
     if (rst) begin 
       mem_phy_wr_en <= {MEM_ROW_SIZE_IN_WORDS{1'b0}};
       mem_phy_wr_data <= {MEM_ROW_DATA_WIDTH{1'b0}};
     end else if(|mem_wr_en) begin
       mem_phy_wr_en <= mem_wr_en[MEM_ROW_SIZE_IN_WORDS-1:0];
       mem_phy_wr_data <= mem_wr_data;
     end else if(ack_in) begin
       mem_phy_wr_en <= {MEM_ROW_SIZE_IN_WORDS{1'b0}};
       mem_phy_wr_data <= {MEM_ROW_DATA_WIDTH{1'b0}};
     end
   end

   always @(posedge clk or posedge rst) begin
     if (rst) begin 
       mem_phy_rd_en <= 1'b0;
     end else if(mem_rd_en) begin
       mem_phy_rd_en <= 1'b1;
     end else if(ack_in) begin
       mem_phy_rd_en <= 1'b0;
     end
   end
   
  always @(posedge clk or posedge rst) begin
     if (rst) begin 
       mem_phy_addr <= {MEM_ADDR_WIDTH{1'b0}};
     end else if(mem_rd_en || (|mem_wr_en)) begin
       mem_phy_addr <= mem_addr;
     end else if(ack_in) begin
       mem_phy_addr <= {MEM_ADDR_WIDTH{1'b0}};
     end
   end


assign mem_rd_data = mem_phy_rd_data;

assign ack_out = ack_in && (mem_phy_rd_en || (|mem_phy_wr_en));

endmodule // rnaxi_mem_phy
