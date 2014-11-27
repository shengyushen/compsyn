module MUX4TO1 (dout, sel, data0, data1, data2, data3);
parameter dwidth = 2;
   output [dwidth-1:0] dout;
   input [1:0]	       sel;
   input [dwidth-1:0]  data0;
   input [dwidth-1:0]  data1;
   input [dwidth-1:0]  data2;
   input [dwidth-1:0]  data3;
   

   wire [dwidth-1:0]   data0;
   wire [dwidth-1:0]   data1;
   wire [dwidth-1:0]   data2;
   wire [dwidth-1:0]   data3;
   wire [1:0]	       sel;
   reg  [dwidth-1:0]   dout;

  always @ (sel or data0 or data1 or data2 or data3)
    begin:MUX4TO1
       case (sel) // synopsys parallel_case full_case 
	 2'b00: dout = data0;
	 2'b01: dout = data1;
	 2'b10: dout = data2;
	 2'b11: dout = data3;
       endcase
    end

endmodule
