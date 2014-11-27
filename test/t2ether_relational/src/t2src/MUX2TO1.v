module MUX2TO1 (dout, sel, data0, data1);
parameter dwidth = 2;
   output [dwidth-1:0] dout;
   input 	       sel;
   input [dwidth-1:0]  data0;
   input [dwidth-1:0]  data1;
   
   wire [dwidth-1:0]   data0;
   wire [dwidth-1:0]   data1;
   wire 	       sel;
   reg [dwidth-1:0]    dout;

  always @ (sel or data0 or data1)
    begin:MUX2TO1
       case (sel) // synopsys parallel_case full_case 
	 1'b0: dout = data0;
	 1'b1: dout = data1;
       endcase
    end

   
endmodule
