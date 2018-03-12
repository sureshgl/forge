module rnaxi_slv 
  (
    clk,
    rst,
    u_req_valid, 
    u_req_type,
    u_req_attr,
    u_req_size,
    u_req_data,
    u_req_intr,
    u_req_stall,
    d_req_valid, 
    d_req_type,
    d_req_attr,
    d_req_size,
    d_req_data,
    d_req_intr,
    d_req_stall,
    wr_req_rcvd,
    rd_req_rcvd,
    load_rd_data,
    req_addr,
    reg_wr_data,
    reg_rd_data,
    req_size,
    ack_rcvd

   );

   parameter REQ_TYPE_RES    = 2'h3;
   parameter REQ_TYPE_READ   = 2'h1;
   parameter REQ_TYPE_WRITE  = 2'h0;
   parameter REQ_TYPE_FLUSH  = 2'h2;
   parameter REQ_TYPE_WIDTH  = 2;
   parameter REQ_ATTR_WIDTH  = 3;
   parameter REQ_SIZE_WIDTH  = 6;
   parameter REQ_DATA_WIDTH  = 32;
   parameter REQ_MAX_BEATS   = 64;
   parameter REQ_MAX_BITS    = REQ_MAX_BEATS * REQ_DATA_WIDTH;
   parameter REQ_LAST_BEAT_FIELD  = 1;

   parameter SLV_START_ADDR  = 32'h0000_0000;
   parameter SLV_END_ADDR  = 32'hFFFF_FFFF;
   parameter SLV_INTR_BIT  = 31;

   input clk;
   input rst;
   //up stream inputs
   input u_req_valid; 
   input u_req_intr;
   input [REQ_TYPE_WIDTH-1:0] u_req_type;
   input [REQ_ATTR_WIDTH-1:0] u_req_attr;
   input [REQ_SIZE_WIDTH-1:0] u_req_size;
   input [REQ_DATA_WIDTH-1:0] u_req_data;
   //down stream inputs
   input  d_req_stall;

   //up stream outputs
   output reg u_req_stall;

   //down stream outputs
   output reg d_req_valid; 
   output reg d_req_intr;
   output reg [REQ_TYPE_WIDTH-1:0] d_req_type;
   output reg [REQ_ATTR_WIDTH-1:0] d_req_attr;
   output reg [REQ_SIZE_WIDTH-1:0] d_req_size;
   output reg [REQ_DATA_WIDTH-1:0] d_req_data;
   output reg wr_req_rcvd;
   output reg rd_req_rcvd;
   output reg load_rd_data;
   output reg [REQ_DATA_WIDTH-1:0] req_addr;
   output reg [REQ_MAX_BITS-1:0] reg_wr_data;
   input reg [REQ_MAX_BITS-1:0] reg_rd_data;
   output reg [REQ_SIZE_WIDTH:0] req_size;
   input ack_rcvd;


   localparam S_RNAXI_IDLE           = 3'd0;
   localparam S_RNAXI_SEND_RES       = 3'd1;
   localparam S_RNAXI_BEAT           = 3'd2;
   localparam S_RNAXI_BYPASS         = 3'd3;
   localparam S_RNAXI_WAIT_ACK       = 3'd4;

   reg [2:0] s_rnaxi_nstate;
   reg [2:0] s_rnaxi_cstate;
   reg [REQ_MAX_BITS-1:0] shft_reg;
   reg [REQ_SIZE_WIDTH:0] beats_sent;
   reg [REQ_ATTR_WIDTH-1:0] req_attr;
   reg [REQ_TYPE_WIDTH-1:0] req_type;
   reg own_stall;
   wire nstate_idle;
   wire nstate_send_res;
   wire nstate_beat;
   wire nstate_wait_ack;
   wire cstate_idle;
   wire cstate_send_res;
   wire cstate_beat;
   wire cstate_wait_ack;
   wire all_beats_sent;
   wire own_space;
   wire no_resp_req;


   assign own_space = (SLV_START_ADDR <= u_req_data[REQ_DATA_WIDTH-1:0]) && (u_req_data[REQ_DATA_WIDTH-1:0] <= SLV_END_ADDR);

   always @(*) begin
      case (s_rnaxi_cstate)

        S_RNAXI_IDLE: begin
          if ((u_req_valid && (~own_space)) || (u_req_type == 2'h3)) begin  //Response or Request for other slave
            s_rnaxi_nstate = S_RNAXI_BYPASS;
          end else if(u_req_valid && (u_req_type == 2'h0)) begin //WRITE
            s_rnaxi_nstate = S_RNAXI_BEAT;
          end else if(u_req_valid && (u_req_type == 2'h1)) begin //READ
            s_rnaxi_nstate = S_RNAXI_WAIT_ACK;
          end else if(u_req_valid && (u_req_type == 2'h2)) begin //FLUSH
            s_rnaxi_nstate = S_RNAXI_SEND_RES;
          end else begin
            s_rnaxi_nstate = S_RNAXI_IDLE;
          end
        end 
        S_RNAXI_BEAT: begin
          if(u_req_valid && u_req_attr[REQ_LAST_BEAT_FIELD]) begin
            s_rnaxi_nstate = S_RNAXI_WAIT_ACK;
          end else begin
            s_rnaxi_nstate = S_RNAXI_BEAT;
          end
        end
        S_RNAXI_BYPASS: begin
          if(u_req_attr[REQ_LAST_BEAT_FIELD]) begin
            s_rnaxi_nstate = S_RNAXI_IDLE;
          end else begin
            s_rnaxi_nstate = S_RNAXI_BYPASS;
          end
        end
        S_RNAXI_WAIT_ACK: begin
          if(ack_rcvd && no_resp_req) begin
            s_rnaxi_nstate = S_RNAXI_IDLE;
          end else if(ack_rcvd) begin
            s_rnaxi_nstate = S_RNAXI_SEND_RES;
          end else begin
            s_rnaxi_nstate = S_RNAXI_WAIT_ACK;
          end
        end
        S_RNAXI_SEND_RES: begin
          if(all_beats_sent || no_resp_req) begin
            s_rnaxi_nstate = S_RNAXI_IDLE;
          end else begin
            s_rnaxi_nstate = S_RNAXI_SEND_RES;
          end 
        end 
        default : begin 
          s_rnaxi_nstate = S_RNAXI_IDLE;
        end
      endcase
   end //always_end

   always @(posedge clk or posedge rst) begin
     if (rst) begin 
        s_rnaxi_cstate <= S_RNAXI_IDLE;
     end else begin
        s_rnaxi_cstate <= s_rnaxi_nstate;
     end
   end

   always @(posedge clk or posedge rst) begin
     if (rst) begin
       req_size <= {REQ_SIZE_WIDTH{1'b0}};
       req_type <= {REQ_TYPE_WIDTH{1'b0}};
       req_attr <= {REQ_ATTR_WIDTH{1'b0}};
       req_addr <= {REQ_DATA_WIDTH{1'b0}};
     end else if(cstate_idle && (nstate_beat || nstate_wait_ack || nstate_send_res)) begin
       req_size <= (~|u_req_size) ? 7'h40 : {1'b0,u_req_size[REQ_SIZE_WIDTH-1:0]};
       req_type <= u_req_type[REQ_TYPE_WIDTH-1:0];
       req_attr <= u_req_attr[REQ_ATTR_WIDTH-1:0];
       req_addr <= u_req_data[REQ_DATA_WIDTH-1:0];
     end
   end

   always @(posedge clk or posedge rst) begin
     if (rst) begin
       reg_wr_data <= {REQ_MAX_BITS{1'b0}};
     end else if(cstate_idle) begin
       reg_wr_data <= {REQ_MAX_BITS{1'b0}};
    end else if(nstate_wait_ack && cstate_beat) begin
       reg_wr_data[REQ_MAX_BITS-1:0] = ({u_req_data,reg_wr_data[REQ_MAX_BITS-1:32]}) >> (12'h800-((req_size[REQ_SIZE_WIDTH:0]) << 5));
     end else if(cstate_beat) begin
       reg_wr_data <= {u_req_data,reg_wr_data[REQ_MAX_BITS-1:32]};
     end 
   end

   always @(posedge clk or posedge rst) begin
     if (rst) begin
       beats_sent <= {(REQ_SIZE_WIDTH+1){1'b0}};
     end else if(cstate_send_res && nstate_idle && (~d_req_stall)) begin
       beats_sent <= {(REQ_SIZE_WIDTH+1){1'b0}};
     end else if(cstate_send_res &&(~d_req_stall)) begin
       beats_sent <= beats_sent + 1;
     end else if(cstate_send_res && d_req_stall) begin
       beats_sent <= beats_sent;
     end else begin
       beats_sent <= {(REQ_SIZE_WIDTH+1){1'b0}};
     end 
   end

  assign all_beats_sent = (beats_sent == (req_size-1)) && (~d_req_stall);

  assign nstate_idle     =  (s_rnaxi_nstate == S_RNAXI_IDLE);
  assign nstate_send_res =  (s_rnaxi_nstate == S_RNAXI_SEND_RES);
  assign nstate_wait_ack =  (s_rnaxi_nstate == S_RNAXI_WAIT_ACK);
  assign nstate_beat     =  (s_rnaxi_nstate == S_RNAXI_BEAT);
  assign nstate_bypass   =  (s_rnaxi_nstate == S_RNAXI_BYPASS);

  assign cstate_idle     =  (s_rnaxi_cstate == S_RNAXI_IDLE);
  assign cstate_send_res =  (s_rnaxi_cstate == S_RNAXI_SEND_RES);
  assign cstate_wait_ack =  (s_rnaxi_cstate == S_RNAXI_WAIT_ACK);
  assign cstate_beat     =  (s_rnaxi_cstate == S_RNAXI_BEAT);
  assign cstate_bypass   =  (s_rnaxi_cstate == S_RNAXI_BYPASS);


  always @(posedge clk or posedge rst) begin
    if(rst) begin
      wr_req_rcvd <= 1'b0;
    end else if(nstate_wait_ack && cstate_beat && (req_type == REQ_TYPE_WRITE)) begin
      wr_req_rcvd <= 1'b1;
    end else begin
      wr_req_rcvd <= 1'b0;
    end
  end

  always @(posedge clk or posedge rst) begin
    if(rst) begin
      rd_req_rcvd <= 1'b0;
    end else if(cstate_idle && nstate_wait_ack) begin
      rd_req_rcvd <= 1'b1;
    end else begin
      rd_req_rcvd <= 1'b0;
    end
  end

  always @(posedge clk or posedge rst) begin
    if(rst) begin
      own_stall <= 1'b0;
     end else if(cstate_send_res && d_req_stall) begin //stall only when request is asserted //REVISIT
      own_stall <= 1'b1;
    end else if(cstate_send_res) begin
      own_stall <= 1'b0; //unstall as long as it is in read and no new request
    end else if(cstate_idle) begin
      own_stall <= 1'b0;
    end
  end

  assign load_rd_data = cstate_wait_ack && nstate_send_res;

  always @(posedge clk or posedge rst) begin
    if(rst) begin
      shft_reg <= {REQ_MAX_BITS{1'b0}};
      d_req_data <= {REQ_DATA_WIDTH{1'b0}};
      d_req_attr <= {REQ_ATTR_WIDTH{1'b0}};
      d_req_type <= {REQ_TYPE_WIDTH{1'b0}};
      d_req_size <= {REQ_SIZE_WIDTH{1'b0}};
      d_req_intr <= 1'b0;
    end else if (cstate_bypass || nstate_bypass) begin
      shft_reg <= {REQ_MAX_BITS{1'b0}};
      d_req_data <= u_req_data;
      d_req_attr <= u_req_attr;
      d_req_type <= u_req_type;
      d_req_size <= u_req_size; 
      d_req_intr <= u_req_intr;
    end else if(load_rd_data) begin
      if(req_type == REQ_TYPE_READ) begin //READ data
         shft_reg <= reg_rd_data[REQ_MAX_BITS-1:0]; 
         d_req_data <= reg_rd_data[REQ_DATA_WIDTH-1:0];
         d_req_attr <= (req_size == 7'h1) ? 3'h2 : 3'h0;
         d_req_type <= REQ_TYPE_RES;
         d_req_size <= req_size[REQ_SIZE_WIDTH-1:0]; 
         d_req_intr <= 1'b0;
      end else begin //WRITE res and RES packets
      end
    end else if(cstate_send_res && nstate_idle && (~d_req_stall)) begin
      shft_reg <= {REQ_MAX_BITS{1'b0}}; 
      d_req_data <= {REQ_DATA_WIDTH{1'b0}};
      d_req_attr <= {REQ_ATTR_WIDTH{1'b0}};
      d_req_type <= {REQ_TYPE_WIDTH{1'b0}};
      d_req_size <= {REQ_SIZE_WIDTH{1'b0}};
      d_req_intr <= 1'b0;
    end else if(cstate_send_res && (~d_req_stall)) begin
      shft_reg <= {32'h0,shft_reg[REQ_MAX_BITS-1:32]};
      d_req_data <= shft_reg[(2*REQ_DATA_WIDTH)-1:REQ_DATA_WIDTH];
      d_req_attr <= ((req_size - beats_sent) == 7'h2) ? 3'h2 : 3'h0;
      d_req_type <= REQ_TYPE_RES;
      d_req_size <= req_size[REQ_SIZE_WIDTH-1:0]; 
      d_req_intr <= 1'b0;
    end else if(cstate_send_res) begin
      shft_reg <= shft_reg;
      d_req_data <= d_req_data;
      d_req_attr <= d_req_attr;
      d_req_type <= d_req_type;
      d_req_size <= d_req_size;
      d_req_intr <= 1'b0;
    end else begin
      shft_reg <= {REQ_MAX_BITS{1'b0}};
      d_req_data <= {REQ_DATA_WIDTH{1'b0}};
      d_req_attr <= {REQ_ATTR_WIDTH{1'b0}};
      d_req_type <= {REQ_TYPE_WIDTH{1'b0}};
      d_req_size <= {REQ_SIZE_WIDTH{1'b0}};
      d_req_intr <= 1'b0;
    end
  end

  assign no_resp_req = ~req_attr[1];

  always @(posedge clk or posedge rst) begin
    if(rst) begin
       d_req_valid <= 1'b0;
    end else begin
       d_req_valid <= (cstate_bypass || nstate_bypass) ? u_req_valid : nstate_send_res ;
    end
  end
  
  assign u_req_stall = ((cstate_bypass || nstate_bypass) && d_req_stall) || own_stall; 

endmodule
