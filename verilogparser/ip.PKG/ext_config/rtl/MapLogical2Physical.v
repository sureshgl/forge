module MapLogical2Physical #(   parameter LOGICAL_WIDTH=256,
                                parameter PHYSICAL_WIDTH=204,
                                parameter LOGICAL_MASK=256'hFFFF_FFFF_FFFF_F)
        
(
        input           [LOGICAL_WIDTH-1:0]     logicalData,
        output          [PHYSICAL_WIDTH-1:0]    physicalData
);

localparam SAFE_MASK={LOGICAL_WIDTH{1'b0}} + LOGICAL_MASK;

// {logicalBits, physicalBits}

`define logicalBits     ((loopVar>>16)&32'hffff)
`define physicalBits    (loopVar&32'hffff)

generate
genvar loopVar;

        if (SAFE_MASK == 0) begin
                assign physicalData = logicalData;
        end
        else begin
        	//synthesis loop_limit 4096
                for (   loopVar = (LOGICAL_WIDTH<<16) + PHYSICAL_WIDTH;
                        `logicalBits > 0;
                        loopVar = ((`logicalBits-1)<<16)+ `physicalBits-(SAFE_MASK[`logicalBits-1] ? 0:1) 
                ) begin : genBits
        
                        if (!SAFE_MASK[`logicalBits-1]) begin

                                assign physicalData[`physicalBits-1] = logicalData[`logicalBits-1];
                        
                                `ifdef SYNTHESIS
                                `else
                                if ( (`logicalBits==1) && (`physicalBits != 1))  begin 
                                        initial begin
                                        $display("\nWarning: %m LogicalDataMask # of 0s MISMATCH actual physicalWidth. mask=0, logicalBits=%d, phyBits=%d",
							`logicalBits, `physicalBits);
                                        end
                                end
                                `endif
                        end        
                end
        end
        
endgenerate 

  `undef logicalBits
  `undef physicalBits

/*
integer logicalBits,physicalBits;
wire [LOGICAL_WIDTH-1:0] logicalDataMask = LOGICAL_MASK;
reg  [PHYSICAL_WIDTH-1:0] physicalData;

always @ (*) begin

        physicalBits = PHYSICAL_WIDTH;
        physicalData = {PHYSICAL_WIDTH{1'b0}};
        
        for (   logicalBits=(LOGICAL_WIDTH-1); 
                logicalBits >= 0;
                logicalBits = logicalBits - 1)
        begin
                if (!logicalDataMask[logicalBits]) begin
                        physicalData[(physicalBits-1)] = logicalData[logicalBits];
                        
                        `ifdef SYNTHESIS
                        `else
                        if (physicalBits == 0) begin
                                $display("\nWarning: %m LogicalDataMask # of 0s > actual physicalWidth");
                        end
                        `endif
                                
                        physicalBits = physicalBits-1;
                                                        
                end
        end
                
        `ifdef SYNTHESIS
        `else
        if (physicalBits != 0) begin
                $display("\nWarning: %m LogicalDataMask # of 0s < actual physicalWidth");
        end
        `endif
        
end
*/


endmodule
