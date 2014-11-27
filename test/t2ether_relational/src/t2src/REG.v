module REG (qout, clk, din);
//non-resettable variable width register 
//only one Q output
//if used as flop, just instantiate with #1

parameter dwidth = 2;
output [dwidth-1:0] qout;
input clk;
input [dwidth-1:0] din; 

reg   [dwidth-1:0] qout;

always @ (posedge clk)
    qout <= din;
endmodule
