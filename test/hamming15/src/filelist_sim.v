`include "../src/hamming15.v"
`include "resulting_dual_cnf.v"

module tb;
reg clock;

initial   begin
 clock =1'b0;
 forever
 #1 clock=!clock;
end

reg reset;
initial  begin
 reset=1'b0;
 #100 reset=1'b1;
 #100 reset=1'b0;
end

reg [10:0] in;
reg [3:0] ir;
always @(posedge clock) begin
	if(reset) begin
		in<=11'b0;
		ir<=4'b0110;
	end
	else begin
		in<=in+11'b1;
		ir<=ir+4'b001;
	end
end

wire [14:0] out;
hamming7 inst_enc(
 .clock(clock), 
    .in1(in[0]), 
		.in2(in[1]), 
		.in3(in[2]), 
		.in4(in[3]),
		.in5(in[4]),
		.in6(in[5]),
		.in7(in[6]),
		.in8(in[7]),
		.in9(in[8]),
		.in10(in[9]),
    .out1(out[0]), 
		.out2(out[1]), 
		.out3(out[2]), 
		.out4(out[3]), 
		.out5(out[4]), 
		.out6(out[5]), 
		.out7(out[6]),
		.out8(out[7]),
		.out9(out[8]),
		.out10(out[9]),
		.out11(out[10]),
		.out12(out[11]),
		.out13(out[12]),
		.out14(out[13]),
		.out15(out[14]),
		.ir1(ir[0]),
		.ir2(ir[1]),
		.ir3(ir[2])
		.ir4(ir[3])
		);         
wire [9:0] outin;
resulting_dual inst_dec(
		.clk(clock),
    .in1(outin[0]), 
		.in2(outin[1]), 
		.in3(outin[2]), 
		.in4(outin[3]),
		.in5(outin[4]),
		.in6(outin[5]),
		.in7(outin[6]),
		.in8(outin[7]),
		.in9(outin[8]),
		.in10(outin[9]),
    .out1(out[0]), 
		.out2(out[1]), 
		.out3(out[2]), 
		.out4(out[3]), 
		.out5(out[4]), 
		.out6(out[5]), 
		.out7(out[6]),
		.out8(out[7]),
		.out9(out[8]),
		.out10(out[9]),
		.out11(out[10]),
		.out12(out[11]),
		.out13(out[12]),
		.out14(out[13]),
		.out15(out[14]),
);

wire correct=(in==outin);

endmodule

