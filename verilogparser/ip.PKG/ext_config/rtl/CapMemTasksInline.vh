//////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2006, Cisco Systems, Inc.
// All Rights Reserved.
//
// This is UNPUBLISHED PROPRIETARY SOURCE CODE of Cisco Systems, Inc;
// the contents of this file may not be disclosed to third parties, copied or
// duplicated in any form, in whole or in part, without the prior written
// permission of Cisco Systems, Inc.
//
// RESTRICTED RIGHTS LEGEND:
// Use, duplication or disclosure by the Government is subject to restrictions
// as set forth in subdivision (c)(1)(ii) of the Rights in Technical Data
// and Computer Software clause at DFARS 252.227-7013, and/or in similar or
// successor clauses in the FAR, DOD or NASA FAR Supplement. Unpublished -
// rights reserved under the Copyright Laws of the United States.
//
//////////////////////////////////////////////////////////////////////////////
//
// File          : CapMemTasksInline.vh
// Author        : Rakesh Sanam
// Description   : CAP wrapper Memory Backdoor tasks
//
//
//////////////////////////////////////////////////////////////////////////////


`ifdef SYNTHESIS
`else
 `ifndef CAP_GENERIC_EXTERNAL

   function [WIDTH-1:0] stripData;
      input [`CAP_1P_PROT_WIDTH-1:0] protectedData;
      integer                        i;
      begin
         for (i=0; i<CAP_NUMWORDENABLES; i=i+1) begin
            stripData[(SUB_WIDTH*i)+:SUB_WIDTH] = protectedData[(SUB_PROT_WIDTH*i)+:SUB_WIDTH];
         end
      end
   endfunction // stripData
   



   function [ECC_WIDTH-1:0] getEccCode;
      input [WIDTH-1:0] data;
      reg [SUB_PROT_WIDTH-1:0] hammingData;
      integer                  tangleVar, c, i, j;
      reg [ECC_WIDTH-1:0]      eccSyndrome;
      begin
         hammingData[1:0]         = 2'b0;
          for (tangleVar=2; tangleVar < SUB_PROT_WIDTH-1; tangleVar=tangleVar+1) begin : inteleaveECC
            case (tangleVar)
               32'h0000_0003 :  hammingData[tangleVar] = 1'b0;
               32'h0000_0007 :  hammingData[tangleVar] = 1'b0;
               32'h0000_000f :  hammingData[tangleVar] = 1'b0;
               32'h0000_001f :  hammingData[tangleVar] = 1'b0;
               32'h0000_003f :  hammingData[tangleVar] = 1'b0;
               32'h0000_007f :  hammingData[tangleVar] = 1'b0;
               32'h0000_00ff :  hammingData[tangleVar] = 1'b0;
               32'h0000_01ff :  hammingData[tangleVar] = 1'b0;
               32'h0000_03ff :  hammingData[tangleVar] = 1'b0;
               32'h0000_07ff :  hammingData[tangleVar] = 1'b0;
               32'h0000_0fff :  hammingData[tangleVar] = 1'b0;
               32'h0000_1fff :  hammingData[tangleVar] = 1'b0;
               32'h0000_3fff :  hammingData[tangleVar] = 1'b0;
               32'h0000_7fff :  hammingData[tangleVar] = 1'b0;
               32'h0000_ffff :  hammingData[tangleVar] = 1'b0;
               32'h0001_ffff :  hammingData[tangleVar] = 1'b0;
               32'h0003_ffff :  hammingData[tangleVar] = 1'b0;
               32'h0007_ffff :  hammingData[tangleVar] = 1'b0;
               32'h000f_ffff :  hammingData[tangleVar] = 1'b0;
               32'h001f_ffff :  hammingData[tangleVar] = 1'b0;
               32'h003f_ffff :  hammingData[tangleVar] = 1'b0;
               32'h007f_ffff :  hammingData[tangleVar] = 1'b0;
               32'h00ff_ffff :  hammingData[tangleVar] = 1'b0;
               32'h01ff_ffff :  hammingData[tangleVar] = 1'b0;
               32'h03ff_ffff :  hammingData[tangleVar] = 1'b0;
               32'h07ff_ffff :  hammingData[tangleVar] = 1'b0;
               32'h0fff_ffff :  hammingData[tangleVar] = 1'b0;
               32'h1fff_ffff :  hammingData[tangleVar] = 1'b0;
               32'h3fff_ffff :  hammingData[tangleVar] = 1'b0;
               32'h7fff_ffff :  hammingData[tangleVar] = 1'b0;
               default       :  hammingData[tangleVar] = data[tangleVar-log2(tangleVar+1)];
            endcase // case (sweepvar)
            hammingData[SUB_PROT_WIDTH-1] = 1'b0;                      
         end // block: inteleaveECC
         
         eccSyndrome=0;
         for (c=0; c<(ECC_WIDTH-1); c=c+1) begin
            if (c==0) begin
               for (i=0; i<SUB_PROT_WIDTH-1; i=i+2) begin
                  eccSyndrome[c] = eccSyndrome[c] ^  hammingData[i];
               end
            end else begin
               for (i=(1'b1<<c)-1; i<SUB_PROT_WIDTH-1; i=i+(1'b1<<(c+1))) begin
                  for (j=0; (j<(1'b1<<c)) && ((i+j) < (SUB_PROT_WIDTH-1)); j=j+1) begin
                     eccSyndrome[c] = eccSyndrome[c] ^  hammingData[i+j];
                  end
               end
            end // else: !if(c==0)
         end // for (c=0; c<(ECC_WIDTH-1); c=c+1)
         eccSyndrome[ECC_WIDTH-1] = ^{eccSyndrome[ECC_WIDTH-2:0], data};
         getEccCode = eccSyndrome;
      end
      
   endfunction // getEccCode

   function getParity;
      input [WIDTH-1:0] data;
      begin
         getParity = ^data;
      end
   endfunction // getParity
   

   function [`CAP_1P_PROT_WIDTH-1:0] getProtData;
      input [WIDTH-1:0]                  data;
      integer                            i;
      begin
         if (PARITY != 0)
            for (i=0; i<CAP_NUMWORDENABLES; i=i+1)
               getProtData[(SUB_PROT_WIDTH*i)+:SUB_PROT_WIDTH] = {getParity(data[(SUB_WIDTH*i)+:SUB_WIDTH]), data[(SUB_WIDTH*i)+:SUB_WIDTH]};
         else if (ECC != 0)
            for (i=0; i<CAP_NUMWORDENABLES; i=i+1)
               getProtData[(SUB_PROT_WIDTH*i)+:SUB_PROT_WIDTH] = {getEccCode(data[(SUB_WIDTH*i)+:SUB_WIDTH]), data[(SUB_WIDTH*i)+:SUB_WIDTH]};
         else
            getProtData = data;
      end
   endfunction // getProtData

   function [WIDTH-1:0] ReadWord;
      input [AWIDTH-1:0] addr;
      begin
         if (NUMWORDENABLES > 1)
            ReadWord = stripData(gen.GenericMem.ReadWord(addr));
         else
            ReadWord = stripData(gen.GenericMem.ReadWord(addr));
      end
   endfunction // ReadWord
   
   task WriteWord;
      input [AWIDTH-1:0]            addr;
      input [WIDTH-1:0]                  data;
      begin
         gen.GenericMem.WriteWord(addr,getProtData(data));
      end
   endtask // WriteWord


   task FillZero;
      integer i;
      begin
         for (i=0; i<DEPTH; i=i+1) begin
            WriteWord(i, {WIDTH{1'b0}});
         end
      end
   endtask // FillZero

   task FillOne;
      integer i;
      begin
         for (i=0; i<DEPTH; i=i+1) begin
            WriteWord(i, {WIDTH{1'b1}});
         end
      end
   endtask // FillOne

//   task FillRandom;
//      integer i, word32s;
//      begin
//         WriteWord(i, {CAPWORD32S{$random}});
//      end
//   endtask // FillRandom
//

   task FillRandom ;
      integer  addr;
      integer data=0;
   begin
      for (addr = 0; addr < DEPTH ; addr = addr + 1) begin
         data = {WIDTH{$random}};
         WriteWord (addr, data);
     end
   end
   endtask // FillRandom

   task FillIncrData ;
      integer  addr;
      integer data=0;
    begin
      for (addr = 0; addr < DEPTH ; addr = addr + 1) begin
        data = data + 1;
        WriteWord (addr, {WIDTH{data}});
      end
    end
   endtask // FillIncrData

 `endif //  `ifndef CAP_GENERIC_EXTERNAL
`endif // SYNTHESIS
