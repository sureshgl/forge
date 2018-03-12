// Added by gvaidya for memory parity/ECC testing.
`ifndef SYNTHESIS

// This function needs to use PROT_PHYSICAL_WIDTH as width
// instead of WIDTH since one should be able to corrupt 
// even the parity/ECC bits.
// Also if CAP_NUMWORDENABLES > 1, each subword needs to be corrupted.
    function [PROT_PHYSICAL_WIDTH-1:0] genError;

        input [PROT_PHYSICAL_WIDTH-1:0] memWord;
        input integer     numBitFlips;

        integer           i, wordNum, randNum;
        reg               tempBit;
        reg [SUB_PROT_WIDTH-1:0] tempGenError;

        begin
            if (numBitFlips > SUB_PROT_WIDTH)
            begin
                $display("DOPPLER_FAULT_INJECTION_TEST_ERROR: numBitFlips > SUB_PROT_WIDTH in call to genError() in %m");
                $finish;
            end
            else if (numBitFlips === 0)
            begin
                $display("DOPPLER_FAULT_INJECTION_TEST_ERROR: numBitFlips === 0 in call to genError() in %m");
                $finish;
            end

            genError = 0;
            // Perform corruption for each subWord
            for (wordNum = CAP_NUMWORDENABLES; wordNum > 0; wordNum = wordNum - 1)
            begin
                // Create a vector with 1's in random places
                tempGenError = 'b1;
                tempGenError = (tempGenError << numBitFlips) - 1;
                // tempGenError[numBitFlips-1:0] = ~tempGenError[numBitFlips-1:0]; // Doesn't work
                for (i = 0; i < numBitFlips; i = i + 1)
                begin
                    randNum               = i + ({$random} % (SUB_PROT_WIDTH - i));
                    tempBit               = tempGenError[randNum];
                    tempGenError[randNum] = tempGenError[i];
                    tempGenError[i]       = tempBit;
                end
                genError = genError | tempGenError;
                genError = genError << ((wordNum - 1) * SUB_PROT_WIDTH);
            end
            // Corrupt the memWord with the generated vector
            genError = memWord ^ genError;
        end
    endfunction

    // This will be set by an external backdoor-access-like process.
    reg     createError       = 1'b0;
    reg     createErrorSticky = 1'b0;
    wire    createErrorValid;
    integer numBitFlipsGlobal;
    integer createErrorDelay0 = 1'b0;
    integer createErrorDelay1 = 1'b0;
    integer i;

    reg  [log2(READ_PORTS+1)-1:0]  createErrorPipe[0:GENERIC_PIPELINE];

    initial
    begin
        $value$plusargs("CORRUPT_RTL_STICKY=%d", createErrorSticky);
        case (createErrorSticky)
            0: createErrorSticky = 1'b0;
            1: createErrorSticky = 1'b1;
            default: createErrorSticky = 1'b0;
        endcase
    end

    logic   [log2(READ_PORTS+1)-1:0] targetPort;
    
    always @*
    begin
        targetPort = READ_PORTS;

        for(int readPort = 0; readPort < READ_PORTS; readPort++)
        begin
            if(read[readPort])
                targetPort = readPort;
        end
    end

    assign createErrorValid = createErrorPipe[0] != READ_PORTS;

    always @(posedge CLK)
    begin
        for (i = 0; i < GENERIC_PIPELINE; i = i + 1)
        begin
            createErrorPipe[i] <= createErrorPipe[i + 1];
        end 

        // When not creating error now:
        createErrorPipe[GENERIC_PIPELINE] <= READ_PORTS;

        if (createError === 1'b1 && targetPort < READ_PORTS)
        begin
            if (createErrorDelay0 === 0)
            begin
                if (!createErrorSticky)
                begin
                    createError <= 1'b0;
                end
                createErrorPipe[GENERIC_PIPELINE] <= targetPort;
            end
            else
            begin
                createErrorDelay0 = createErrorDelay0 - 1;
            end
        end

        if (createErrorValid === 1'b1)
        begin
            $display("DOPPLER_FAULT_INJECTION_TEST - Flipping %0d bits at address 0x%0h on readPort %0d", numBitFlipsGlobal, readAddr[targetPort], targetPort);
        end
    end // always @ (posedge CLK)

    always_comb
    begin
        for(int port = 0; port < READ_PORTS; port++)
        begin
            protPhysDoutTemp[port] = (createErrorPipe[0] == port) ? genError(protPhysDout[port], numBitFlipsGlobal) : protPhysDout[port];
        end
    end

    // This task can be called to arm the memory error injection mechanism
    // Added to inject errors into memories that aren't in the RDL memory map
    // Other memories can be corrupted using the DIM error injection mechanism 
    task memCorrupt;
        input integer numBitFlipsInput;
        input integer createErrorDelayInput;
        begin
            createError <= 1'b1;
            numBitFlipsGlobal <= numBitFlipsInput;
            createErrorDelay0 <= createErrorDelayInput;
        end
    endtask

`endif
