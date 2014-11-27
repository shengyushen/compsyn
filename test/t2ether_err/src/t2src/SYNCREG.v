module SYNCREG (qout, clk, din);
//non-resettable variable width register 
//only one Q output

output qout;
input clk;
input din; 

SYNC_CELL PCS_SYNC_CELL(.D(din),.CP(clk),.Q(qout));

endmodule
