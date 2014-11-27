module RREG (qout, clk, rst, din);
//synchronous reset variable width register 
//active hi reset (rst); 
//only one Q output
//if used as flop, just instantiate with #1

parameter dwidth = 2;
output [dwidth-1:0] qout;
input clk, rst;
input [dwidth-1:0] din; 

reg   [dwidth-1:0] qout;

always @ (posedge clk)
if (rst)
    qout <= 0;
else
    qout <= din; 
endmodule

