 

`timescale 1ns/1ps
 module sprout(
	clk, 
	write, 
        din, 
        wraddr, 
        rdaddr,
        read,
        rst,
        rd_vld,
	rd_dout
	   
	   );

   parameter WIDTH = 8;
   parameter BITADDR = 6;
   parameter NUMADDR = 64;
   parameter NUMRPRT = 2;
   parameter NUMWPRT = 2;
   parameter BITPRED = 2;
   parameter READ_DELAY = 1;  
   parameter BITNUMWPRT = (NUMWPRT>1)?($clog2(NUMWPRT)) : (1);
  
  input clk;
  input rst;
  input [NUMWPRT-1:0]  write;
  input [NUMWPRT*WIDTH-1:0] din;
  input [NUMRPRT*BITADDR-1:0] 	  rdaddr;
  output [NUMRPRT-1:0] rd_vld;
  output [NUMRPRT*WIDTH-1:0] rd_dout; 
  input [NUMRPRT-1:0]  read;
  input [NUMWPRT*BITADDR-1:0] wraddr;

  
 
  wire  [NUMWPRT-1:0] ddin [WIDTH-1:0];   
  wire [BITNUMWPRT*NUMADDR-1:0] sel ;
  wire [NUMADDR-1:0] 		ce;
  wire [NUMWPRT*(1<<BITADDR)-1:0] wlw;	      
  wire [NUMRPRT-1:0] DPORT [WIDTH-1:0];
  wire [NUMWPRT-1:0] clkx [NUMADDR-1:0];
  wire [NUMRPRT*WIDTH-1:0] DFOUT;




//_____________________________________________________________________________ 
 genvar i, kk;
  generate
    for (i=0; i<NUMADDR; i=i+1) begin : clkmix  	 
    		for (kk=0; kk<NUMWPRT; kk=kk+1) begin : iP
		assign clkx[i][kk]=wlw[i+kk*NUMADDR];	     
		
		end
	   

   ormix #(NUMWPRT) ormix (.row(ce[i]), .abcd(clkx[i]));
 
 
 end
 endgenerate
 
//_____________________________________________________________________________ 
 
  genvar p;
  generate
    for (p=0; p<NUMWPRT; p=p+1) begin : dec_
decoder #(BITADDR, BITPRED) dec (.we(write[p]), .wadr(wraddr[(p+1)*BITADDR-1:p*BITADDR]), .wlw(wlw[(p+1)*(1<<BITADDR)-1:p*(1<<BITADDR)])); 
  end
 endgenerate
 




  genvar n,nn,d;														    
  generate
    for (n=0; n<WIDTH; n=n+1) begin : width

		for (nn=0; nn<NUMRPRT; nn=nn+1) begin : i
                assign rd_dout[n+nn*WIDTH] = DPORT[n][nn];               
		end
		for (d=0; d<NUMWPRT; d=d+1) begin : dinn
		assign ddin[n][d] = din[n+d*WIDTH];
		end

  columnslice #(BITADDR, NUMADDR, NUMRPRT, NUMWPRT, BITNUMWPRT) column (.rst(rst), .ce(ce), .sel(sel), .din(ddin[n]), .clk(clk), .radr(rdaddr), .dout(DPORT[n]));
     //columnslice #(BITADDR, NUMADDR, NUMREADPORT, NUMWRITEPORT) column (.rst(rst), .ce(ce), .wlw(wlw), .clk(clk), .radr(rdaddr), .dout(DPORT[n]));
    


 end
 endgenerate
 //_________________________________________________________
genvar e;														    
  generate
  

		for (e=0; e<NUMRPRT; e=e+1) begin : vld
	
	 rdflop #(READ_DELAY) rd_flop (.ren(read[e]), .rst(rst), .rvld(rd_vld[e]), .clk(clk));
       
					   end
		
 endgenerate 

dataencoder #(NUMADDR, NUMWPRT, BITNUMWPRT) encoder (.wlw(wlw), .sel(sel)); 

endmodule 
 
 
//_______________________________________________________________________________________________________________		  



//________________________________INITIALIZING CLKMIXER___________________________________________________________

module ormix(row, abcd);
parameter NUMWRITEPORT = 3;
input  [NUMWRITEPORT-1:0] abcd;

output row;

assign row = ( | abcd);
//assign row =  abcd[NUMWRITEPORT-1];
endmodule
  

//________________________________INITIALIZING DECODER____________________________________________________________
module decoder(we, wadr, wlw);

parameter BITADDR=3;
//parameter NUMADDR=(1<<BITADDR);
parameter BITPRED=3;
parameter NUMPRED=(BITADDR%BITPRED) ? (BITADDR/BITPRED*(1<<BITPRED)+(1<<BITADDR%BITPRED)) : ((BITADDR/BITPRED)*(1<<BITPRED)); 

input we;
input [BITADDR-1:0] wadr;
wire [BITADDR-1:0] wwadr;
wire [NUMPRED-1:0] WPREDOUT;
output [(1<<BITADDR)-1:0] wlw;
wire [(1<<BITADDR)-1:0] wl;
//wire [(1<<BITADDR)-1:0] ww [0:(1<<BITADDR)-1] ; //for connections between an2d////
wire [(1<<BITADDR)-1:0] ww [0:BITADDR/BITPRED] ;


genvar a;
generate

for (a=0; a<BITADDR; a=a+1) begin : ANDWE  
an2d andwe_( .I0(wadr[a]), .I1(we),  .O(wwadr[a]));
end
endgenerate


predecoder #(BITADDR, BITPRED) PREDECODER (.wraddr(wwadr), .WPREDOUT(WPREDOUT));

genvar n, j, i, k, t, m;
generate

if (BITADDR%BITPRED != 0) begin :kk
 
for (j=0; j<(1<<BITPRED); j=j+1) begin : dec2			 
for (n=0; n<(1<<BITADDR%BITPRED); n=n+1) begin : dec3							
an2d  a1_ (.I0(WPREDOUT[NUMPRED-(1<<BITPRED)-(1<<(BITADDR%BITPRED))+j]), .I1(WPREDOUT[NUMPRED-(1<<(BITADDR%BITPRED))+n]), .O (ww[0][(1<<BITADDR)-1-n*(1<<BITPRED)-j]));
end					  
end  
  
for (t=0; t<BITADDR/BITPRED-1; t=t+1) begin : dec5    
for (k=0; k<((1<<BITPRED)*(1<<(BITADDR%BITPRED)))<<t*BITPRED; k=k+1) begin : dec4 
for (m=0; m<(1<<BITPRED); m=m+1) begin : dec3									   
an2d  a1_0 (.I0(WPREDOUT[NUMPRED-(2+t)*(1<<BITPRED)-(1<<BITADDR%BITPRED)+m]), .I1(ww[t][(1<<BITADDR)-1-k]), .O (ww[1+t][(1<<BITADDR)-1-m-(1<<BITPRED)*k]));
end																			
end
end


assign wl = ww[BITADDR/BITPRED-1];

end
//___________________________________________________________________________________________________________________________________________

if (BITADDR%BITPRED == 0) begin :pp

for (j=0; j<(1<<BITPRED); j=j+1) begin : dec2	
for (n=0; n<(1<<BITPRED); n=n+1) begin : dec3						
an2d  a1_ (.I0(WPREDOUT[NUMPRED-2*(1<<BITPRED)+j]), .I1(WPREDOUT[NUMPRED-(1<<BITPRED)+n]), .O (ww[0][(1<<BITADDR)-1-n*(1<<BITPRED)-j]));
end					  	
end  
  
for (t=0; t<BITADDR/BITPRED-2; t=t+1) begin : dec5    
for (k=0; k<((1<<BITPRED)*(1<<BITPRED))<<t*BITPRED; k=k+1) begin : dec4 
for (m=0; m<(1<<BITPRED); m=m+1) begin : dec3									   
an2d  a1_0 (.I0(WPREDOUT[NUMPRED-(2+t)*(1<<BITPRED)-(1<<BITPRED)+m]), .I1(ww[t][(1<<BITADDR)-1-k]), .O (ww[1+t][(1<<BITADDR)-1-m-(1<<BITPRED)*k]));
end																			
end
end


assign wl = ww[BITADDR/BITPRED-2];

end

an2d  we_0 ( .I0(we),  .I1(wl[0]),           .O (wlw[0]));
an2d  we_1 ( .I0(we),  .I1(wl[(1<<BITADDR)-1]),   .O (wlw[(1<<BITADDR)-1]));
assign wlw[(1<<BITADDR)-2:1]=wl[(1<<BITADDR)-2:1];

endgenerate
//________________________________________________________________________________________________________
endmodule

//______________________________________________________________________________________________________________________

module columnslice(rst, din, sel, ce, clk, radr, dout );

parameter BITADDR = 3;
parameter NUMADDR = 8;
parameter NUMREADPORT = 1;
parameter NUMWRITEPORT = 2;
parameter NUMWR = 3;

input clk;
input rst;
input [NUMWRITEPORT-1:0] din;
input [NUMADDR-1:0] ce;
//input [NUMWRITEPORT*NUMADDR-1:0] wlw;
input [NUMWR*NUMADDR-1:0] sel;
wire [NUMWR-1:0] select [NUMADDR-1:0];
//wire [NUMWRITEPORT-1:0] select [NUMADDR-1:0];
input [NUMREADPORT*BITADDR-1:0] radr;
output [NUMREADPORT-1:0] dout;




 wire [NUMADDR-1:0] flopout;	
 wire [NUMWRITEPORT-1:0] I;
				

 assign I = din;
 
 
 
 genvar d, t, k, nm;
  generate
   for (d=0; d<NUMADDR; d=d+1) begin : selem
   for (t=0; t<NUMWR; t=t+1) begin : selsel
   assign select[d][t]=sel[d+t*NUMADDR];
 end
  end 

    
   

 
 for (k=0; k<NUMADDR; k=k+1) begin : depth

  bitslice  #(NUMWRITEPORT, NUMWR) flops (.in(I), .sel(select[k]), .ce(ce[k]), .clk(clk), .rst(rst), .out(flopout[k]));
// 	bitslice  #(NUMWRITEPORT, NUMWR) bitslice (.in(I), .sel(select[NUMADDR-1]), .clkrow(clkrow[NUMADDR-1]), .se(se), .out(flopout[NUMADDR-1]), .out1(si));	   
  end
 
  


 for (nm=0; nm<NUMREADPORT; nm=nm+1) begin : mux_

    mux #(BITADDR, NUMADDR) read (.in(flopout), .clk(clk), .sel(radr[(nm+1)*BITADDR-1:nm*BITADDR]), .out(dout[nm]));

	   
  end
  endgenerate

endmodule


//_________________________________________________________________________________________________
module dff(rst, muxout, ce, clk, out);
input ce;
input rst;
input muxout;
input clk;
output reg out;



always @(posedge clk)
/*     if (rst)
	  begin
           out <= 0; 
       end
	  else begin */
	   if (ce) begin
           out <= muxout;					    
         end
  




    endmodule

//_________________________________________________________________________________________________

module rdflop(ren, rst, rvld, clk);

 parameter READ_DELAY = 5;
input rst;
input ren;
input clk;
output rvld;
wire vld [0:READ_DELAY];

assign vld[0] = ren;

  genvar n;
  generate for (n=0; n<READ_DELAY; n=n+1) begin : rd
	ffvld vld_inst (.in(vld[n]), .rst(rst), .clk(clk), .out(vld[n+1]));

   end 

				  endgenerate

		assign rvld = vld[READ_DELAY];
        endmodule
//_______________________________________________________________________________________________

module ffvld(in, rst, clk, out);

input in;
input clk;
input rst;
output  out;
reg out_reg;

always @(posedge clk)
if (rst) begin
 out_reg <= 0;
 end else begin
   out_reg <= in;
  end
assign out = out_reg;
endmodule



//_________________________________________________________________________________________________



module mux2_1(in, sel, out); 

input [1:0] in;
input  sel;
output out;

assign out = in[sel];

endmodule
//_________________________________________________________________________________________________

module bitslice(in, sel, ce, out, rst, clk);
parameter NUMWRITEPORT=2;
parameter NUMWR = 1;
input rst;
input [NUMWRITEPORT-1:0] in;
input [NUMWR-1:0] sel;
wire muxout;

input clk;
input ce;
output out;

   

genvar i;
  generate
if (NUMWRITEPORT==1) begin: mmx1
dff dff (.muxout(in), .ce(ce), .rst(rst), .clk(clk), .out(out)); 
end

if (NUMWRITEPORT>1) begin: dataflop
muxwr #(NUMWR) muxn(.in(in), .sel(sel), .out(muxout));
//data_sel #(NUMWRITEPORT) sel(.in(in), .sel(sel), .out(muxout));   
dff dff (.muxout(muxout), .ce(ce), .rst(rst), .clk(clk), .out(out)); 
end

endgenerate

endmodule
//_________________________________________________________________________________________________
module muxwr(in, sel, out); 
parameter NUMWR=2;
input [(1<<NUMWR)-1:0] in;
input [NUMWR-1:0] sel;
output out;

assign out = in[sel];

endmodule
//________________________________________________________________________________________________
module data_sel(in, sel, out); 
parameter NUMWRITEPORT=4;
input [NUMWRITEPORT-1:0] in;
input [NUMWRITEPORT-1:0] sel;
wire [NUMWRITEPORT-1:0] andout;
output out;


genvar i;
  generate
for (i=0; i<NUMWRITEPORT; i=i+1) begin : data
an2d an2d2( .I0(in[i]), .I1(sel[i]), .O (andout[i]));

end
endgenerate
assign out = ( | andout);
endmodule
//________________________________________________________________________________________________

module mux (out, sel, in, clk);

parameter BITADDR = 3;
parameter NUMADDR = 8;
parameter NUMBNK = (((1<<BITADDR)==NUMADDR) ? NUMADDR : (1<<BITADDR));
parameter FLOPMUX = 32'b00000000000000000000000000000011;

input clk;
input [NUMADDR-1:0] in;
input [BITADDR-1:0] sel; 
wire  [2*NUMBNK+1:0] pp [4*BITADDR+1:0];
wire  [2*NUMBNK+1:0] adr [2*BITADDR+1:0];

output  out ;

assign pp[0] = in;
assign adr[0]= sel;

genvar i, k, n, m;

  generate

for (i=0; i<BITADDR; i=i+1) begin : stage
        for (k=0; k<(NUMBNK>>(i+1)); k=k+1) begin : mux
             mux2_1 inst(.in(pp[2*i][2*k+1:2*k]), .sel(adr[i][i]), .out(pp[2*i+1][k]));
        end
end



for (n=1; n<2*BITADDR; n=n+1) begin : slice1
        for (m=0; m<2*NUMBNK; m=m+1) begin : flfp1

      if (FLOPMUX[n-1]) begin : pdows    // only first  stage  
        ffmx ffinst (.in(adr[n-1][m]), .clk(clk), .out(adr[n][m]));
      end

      if (FLOPMUX[n-1]==0) begin : nflpfp
        assign  adr[n][m] = adr[n-1][m];

      end
end
end


for (n=1; n<2*BITADDR; n=n+1) begin : slice2
        for (m=0; m<2*NUMBNK; m=m+1) begin : flfp2

                if (FLOPMUX[n-1]) begin : pdows    // only first  stage  
      ffmx minst (.in(pp[2*n-1][m]), .clk(clk), .out(pp[2*n][m]));
end

     if (FLOPMUX[n-1]==0) begin : nflpfp
    assign  pp[2*n][m] = pp[2*n-1][m];
end

end
 end

endgenerate


    assign out = pp[2*BITADDR][0];
endmodule
/////////////////////////////////////////////



module ffmx (in, clk, out);
input in;
input clk;
output  out;
reg outreg;

always @(posedge clk)
 outreg <= in;
assign out = outreg;
endmodule
//____________________________________________________________________________________________________________
//_________________________________________________________________________________________________

//____________________________________________________________________________________________________________
module an2d (I0, I1, O); 
input I0, I1;
output O;

assign O = I0 && I1;

endmodule
 
//____________________________________________________________________________________________________________
module predecoder (wraddr, WPREDOUT);

parameter BITADDR=5;
parameter BITPRED=2;
parameter NUMPRED=(BITADDR%BITPRED) ? (BITADDR/BITPRED*(1<<BITPRED)+(1<<BITADDR%BITPRED)) : ((BITADDR/BITPRED)*(1<<BITPRED)); 
input [BITADDR-1:0] wraddr;
output [NUMPRED-1:0] WPREDOUT;


genvar n, i, j;
generate
for (i=0; i<BITADDR/BITPRED+1; i=i+1) begin : decparam
if (i<BITADDR/BITPRED) begin :tt
dec_param  #(BITPRED) DECPARAM (.din(wraddr[(i+1)*BITPRED-1:i*BITPRED]), .dout(WPREDOUT[(i+1)*(1<<BITPRED)-1:i*(1<<BITPRED)])); 
end 

else begin : ii  					
if (BITADDR%BITPRED!=0)  begin : pp
dec_param  #(BITADDR%BITPRED) DECPARAM0 (.din(wraddr[BITADDR-1:BITADDR-BITADDR%BITPRED]), .dout(WPREDOUT[NUMPRED-1:NUMPRED-(1<<BITADDR%BITPRED)]));
end 
end
end 
endgenerate
endmodule


//________________________________INITIALIZING DECODER____________________________________________________________
	   
module dec_param(din, dout);
parameter BITPRED=3;
parameter DECOUT=2<<(BITPRED-1);

input [BITPRED-1:0] din;
output [DECOUT-1:0] dout;
wire [DECOUT-1:0] ddout;
	///////
wire [BITPRED-1:2] ndin;

wire [DECOUT-1:0] ww [0:DECOUT-1] ;
genvar n, i, j, k, t;
generate
for (t=0; t<1; t=t+1) begin : inv
if (BITPRED>1) begin : btt
  
dec2_4 dec2to4 (.in(din[1:0]), .out(ww[0][3:0]));

 for (n=0; n<BITPRED-2; n=n+1) begin : INV  
inv2 inv_ (.in(din[2+n]), .out(ndin[2+n]));
end

for (i=0; i<BITPRED-2; i=i+1) begin : ii
for (j=0; j<(4<<i); j=j+1) begin : jj			    

an2d  a_( .I0(ww[i][j]), .I1(din[2+i]),  .O(ww[i+1][j]));
an2d  b_( .I0(ww[i][j]), .I1(ndin[2+i]),  .O(ww[i+1][(4<<i)+j]));
end
end

assign  ww[BITPRED-1] = ww[BITPRED-2];
assign dout = ww[BITPRED-1]; //////
end

else begin :inv
assign dout[0]=din;
inv2 inv1 (.in(din), .out(dout[1]));

end
end
endgenerate
///////////////////////
	 	    

	 /*
assign ddout = 1<<din;
genvar n, i, j, k, t;
generate
for (t=0; t<DECOUT; t=t+1) begin : rev
assign dout[t] = ddout[DECOUT-1-t]; 

end
endgenerate
    	   */
endmodule

//______________________________________________________________________________________________________________________
module inv2 (in, out);
input in;
output out;

assign out = ~in; 


endmodule
//_____________________________________________________________________________________________________________


module dec2_4 (in, out);
input [1:0] in;
output [3:0] out;
wire [1:0] nin;

  inv2 inv1 (.in(in[0]), .out(nin[0]));
  inv2 inv2 (.in(in[1]), .out(nin[1]));


 an2d  b_0( .I0(nin[0]), .I1(nin[1]),  .O(out[3]));
 an2d  b_1( .I0(in[0]), .I1(nin[1]),  .O(out[2]));
 an2d  b_2( .I0(nin[0]), .I1(in[1]),  .O(out[1]));
 an2d  b_3( .I0(in[0]), .I1(in[1]),  .O(out[0]));

 endmodule

//_______________________________________________________________________________________________________________		  




  module dataencoder (wlw, sel);
parameter NUMADDR = 8;
parameter NUMWRITEPORT =2;
parameter NUMWR=1;
//reg [NUMWR-1:0] PP;
input [NUMWRITEPORT*NUMADDR-1:0] wlw;	 
output [NUMWR*NUMADDR-1:0] sel ;	   

//integer t;	   

genvar jj;
  generate
  for (jj=0; jj<1; jj=jj+1) begin : SEL
 
 
 
 
 
   if (NUMWRITEPORT==1) begin : sel1
   assign sel[NUMADDR-1:0] = 0;
   end

   if (NUMWRITEPORT==2) begin : sel2
   assign sel[NUMADDR-1:0] = wlw[2*NUMADDR-1:NUMADDR];
   end


   if (NUMWRITEPORT==3) begin : sel3
   assign sel[NUMADDR-1:0] = wlw[2*NUMADDR-1:NUMADDR] ;
   assign sel[2*NUMADDR-1:NUMADDR] = wlw[3*NUMADDR-1:2*NUMADDR];
   end

   if (NUMWRITEPORT==4) begin : sel4
   assign sel[NUMADDR-1:0] = wlw[2*NUMADDR-1:NUMADDR] | wlw[4*NUMADDR-1:3*NUMADDR];
   assign sel[2*NUMADDR-1:NUMADDR] = wlw[3*NUMADDR-1:2*NUMADDR] | wlw[4*NUMADDR-1:3*NUMADDR];
   end

  
 
    if (NUMWRITEPORT==5) begin : sel5
 assign sel[NUMADDR-1:0] = wlw[2*NUMADDR-1:NUMADDR] | wlw[4*NUMADDR-1:3*NUMADDR];
 assign sel[2*NUMADDR-1:NUMADDR] =   wlw[3*NUMADDR-1:2*NUMADDR] | wlw[4*NUMADDR-1:3*NUMADDR];
 assign sel[3*NUMADDR-1:2*NUMADDR] = wlw[5*NUMADDR-1:4*NUMADDR];
 end
 

   if (NUMWRITEPORT==6) begin : sel6
 assign sel[NUMADDR-1:0] = wlw[2*NUMADDR-1:NUMADDR] | wlw[4*NUMADDR-1:3*NUMADDR] | wlw[6*NUMADDR-1:5*NUMADDR];
 assign sel[2*NUMADDR-1:NUMADDR] =   wlw[3*NUMADDR-1:2*NUMADDR] | wlw[4*NUMADDR-1:3*NUMADDR];
 assign sel[3*NUMADDR-1:2*NUMADDR] = wlw[5*NUMADDR-1:4*NUMADDR] | wlw[6*NUMADDR-1:5*NUMADDR];
 end

   if (NUMWRITEPORT==7) begin : sel7
 assign sel[NUMADDR-1:0] = wlw[2*NUMADDR-1:NUMADDR] | wlw[4*NUMADDR-1:3*NUMADDR] | wlw[6*NUMADDR-1:5*NUMADDR];
 assign sel[2*NUMADDR-1:NUMADDR] =   wlw[3*NUMADDR-1:2*NUMADDR] | wlw[4*NUMADDR-1:3*NUMADDR] | wlw[7*NUMADDR-1:6*NUMADDR];
 assign sel[3*NUMADDR-1:2*NUMADDR] = wlw[5*NUMADDR-1:4*NUMADDR] | wlw[6*NUMADDR-1:5*NUMADDR] | wlw[7*NUMADDR-1:6*NUMADDR];
 end
 
  if (NUMWRITEPORT==8) begin : sel8
 assign sel[NUMADDR-1:0] = wlw[2*NUMADDR-1:NUMADDR] | wlw[4*NUMADDR-1:3*NUMADDR] | wlw[6*NUMADDR-1:5*NUMADDR] | wlw[8*NUMADDR-1:7*NUMADDR];
 assign sel[2*NUMADDR-1:NUMADDR] =   wlw[3*NUMADDR-1:2*NUMADDR] | wlw[4*NUMADDR-1:3*NUMADDR] | wlw[7*NUMADDR-1:6*NUMADDR] | wlw[8*NUMADDR-1:7*NUMADDR];
 assign sel[3*NUMADDR-1:2*NUMADDR] = wlw[5*NUMADDR-1:4*NUMADDR] | wlw[6*NUMADDR-1:5*NUMADDR] | wlw[7*NUMADDR-1:6*NUMADDR] | wlw[8*NUMADDR-1:7*NUMADDR];
 end
	 


  end 
endgenerate
    
    /*
  always 
  begin
   for (t=0; t<NUMWRITEPORT+1; t=t+1) begin 
    PP=PP+1;
  if (PP[0] == 1)
    assign sel[NUMADDR-1:0] = wlw[2*NUMADDR-1:NUMADDR];
  
   
   end
    end


	*/







  
endmodule







































