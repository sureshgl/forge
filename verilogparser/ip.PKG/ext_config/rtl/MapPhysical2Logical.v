module MapPhysical2Logical #(   parameter LOGICAL_WIDTH=256,
                                parameter LOGICAL_MASK=256'hffff_ffff_ffff_f,
                                parameter PHYSICAL_WIDTH=204)
                                
(
        input           [PHYSICAL_WIDTH-1:0]    physicalData,
        output          [LOGICAL_WIDTH-1:0]     logicalData
);

localparam SAFE_MASK={LOGICAL_WIDTH{1'b0}} + LOGICAL_MASK;

// {logicalBits, physicalBits}

`define logicalBits     ((loopVar>>16)&32'hffff)
`define physicalBits    (loopVar&32'hffff)

generate
genvar loopVar;

        if (SAFE_MASK == 0) begin
                assign logicalData = physicalData;
        end
        else begin
       		//synthesis loop_limit 4096
                for (   loopVar = (LOGICAL_WIDTH<<16) + PHYSICAL_WIDTH;
                        `logicalBits > 0;
                        loopVar = ((`logicalBits-1)<<16)+ `physicalBits-(SAFE_MASK[`logicalBits-1] ? 0:1) 
                ) begin : genBits
        
                        if ( SAFE_MASK[`logicalBits-1] == 0) begin
                                assign logicalData[`logicalBits-1] = physicalData[`physicalBits-1];
                                
                                `ifdef SYNTHESIS
                                `else
                                if ( (`logicalBits==1) && (`physicalBits != 1))  begin 
                                        initial begin
                                        $display("\nWarning: %m LogicalDataMask # of 0s MISMATCH actual physicalWidth, mask=0, logicBits=%d, phyBits=%d",
						`logicalBits, `physicalBits);
                                        end     
                                end
                                `endif
                        end
                        
        
                        else begin
                        
                                assign logicalData[`logicalBits-1] = 1'b0;                        
                        end
                
                end
        end
        
endgenerate 

/*
integer logicalBits,physicalBits;
wire [LOGICAL_WIDTH-1:0] logicalDataMask = LOGICAL_MASK;
reg     [LOGICAL_WIDTH-1:0]     logicalData;

always @ (*) begin
        
        physicalBits = PHYSICAL_WIDTH;
        logicalData = {LOGICAL_WIDTH{1'b0}};
        
        for (   logicalBits=(LOGICAL_WIDTH-1); 
                logicalBits >= 0;
                logicalBits = logicalBits - 1)
        begin
                if (!logicalDataMask[logicalBits]) begin
                        logicalData[logicalBits] = physicalData[(physicalBits-1)];
                                                                
                                
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
 `undef logicalBits
 `undef physicalBits
   
endmodule
                
                        
