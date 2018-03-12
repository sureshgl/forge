
module flop_array_tb;
 
   localparam NUMRWPT = 1;
   localparam WIDTH = 32;
   localparam DEPTH = 256;
   localparam BITADDR = 8;
   localparam NUMPRTMUX = 4;
   localparam MUXLEVEL = $clog2(DEPTH)/$clog2(NUMPRTMUX) ;
   

   reg clk, reset;
   reg read, write;
   reg [BITADDR-1:0] addr;
   reg [WIDTH-1:0] din;
   
   wire rd_vld;
   wire [WIDTH-1:0] rd_dout;

   reg [WIDTH-1:0] flop_array_ref [0: DEPTH-1];
   reg [WIDTH-1:0] flop_array_dout_d [0:MUXLEVEL-1];
   integer 	   err_cnt;
   
   always @ (posedge clk)
     begin
	if(read)
	  flop_array_dout_d [0] <= flop_array_ref[addr];

	for(int i=0;i<MUXLEVEL-1;i++)
	  flop_array_dout_d[i+1] <= flop_array_dout_d[i];
     end
   
  
   always @ (posedge clk)
     begin
	if(reset)
	  begin
	     for(int i=0;i<DEPTH;i++)
	       flop_array_ref[i] <= 0;
	  end
	else if(write) begin
	  flop_array_ref[addr] <= din;
	end
     end // always @ (posedge clk)
   
  
   flop_array_top #(.WIDTH(WIDTH),
		    .BITWDTH(5),
		    .DEPTH(DEPTH),
		    .NUMRDPT(0),
		    .NUMRWPT(1),
		    .NUMWRPT(0),
		    .BITADDR(BITADDR),
		    .NUMPRTMUX(NUMPRTMUX),
		    .FLOPOUT(1)) flop_array_inst
   (.clk(clk), .rst(reset), .read(read), .write(write), .addr(addr), .din(din), 
    .rd_vld(rd_vld), .rd_dout(rd_dout));

   task reset_task;
      #10;
      reset = 1;
      repeat (10) @ (posedge clk);
      reset = 0;
      write = 0;
      read = 0;
   endtask // reset_task
   
   task write_task;
      input [BITADDR-1:0] input_addr;
      input [WIDTH-1:0]   input_din;
      begin
	 @ (posedge clk);
	 write = 1;
	 addr = input_addr;
	 din = input_din;
	 @ (posedge clk);
	 write = 0;
	 addr = 0;
	 din = 0;
      end
   endtask // write_task

   task read_task;
      input [BITADDR-1:0] input_addr;
      begin
	 @ (posedge clk);
	 read = 1;
	 addr = input_addr;
	 @ (posedge clk);
	 read  = 0;
	 addr = 0;
      end
   endtask // read_task

   
      

   initial begin
      clk=0;
      reset=0;
      err_cnt = 0;
             
      #10;

      reset_task();

      repeat (10) @ (posedge clk);

      for(int i=0; i<DEPTH; i++)
	write_task(i,i);
	 //write_task(i,32'd34);
	 //write_task(i,32'd56);

      repeat (20) @ (posedge clk);

      for(int j=DEPTH-1; j>=0; j--)
	read_task(j);
      
      //read_task(4);
      //read_task(3);
   end

   always
     #5 clk = ~clk;

	 
  
   initial begin
      while(1)
	begin
	   @(posedge clk);
	   if(rd_vld) begin
	      if(rd_dout != flop_array_dout_d[MUXLEVEL-1]) begin
		 err_cnt ++;
		 $display("Read data doesn't match Ref Model, rd_dout = %d, ref_rd_dout = %d\n", rd_dout, flop_array_dout_d[MUXLEVEL-1]);
	      end
	   end
	end
   end
 
	     
   initial begin
      while(1)
	begin
	   @(posedge clk);
	   if(write)
	     $display("Time = %d, write to adddr %d, din = %d\n", $time, addr, din);
	   if(read)
	     $display("Time = %d, read to addr %d\n", $time, addr);
	   if(rd_vld)
	     $display("Time = %d, Read data vld, dout = %d\n", $time, rd_dout);
	end
   end // initial begin
      
      
   initial begin
      $display("Read Delay = %d Cycles\n", $clog2(DEPTH));
      $vcdpluson();
      $vcdplusmemon();
      #40000;
      finish_task();
      $vcdplusoff();

   end
   
   task finish_task;
      begin   
      if(err_cnt != 0)
	begin
	   $display("TEST FAILED\n");
	   $finish;
	end
      else 
	begin
	   $display("TEST PASSED\n");
	   $finish;
	end
     end 
   endtask // finish_task
   
      
      
	
   

endmodule // flop_array_tb


   
