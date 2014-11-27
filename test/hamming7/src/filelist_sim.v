`include "../src/hamming7.v"
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

reg [3:0] in;
reg [2:0] ir;
always @(posedge clock) begin
	if(reset) begin
		in<=4'b0;
		ir<=3'b110;
	end
	else begin
		in<=in+4'b1;
		ir<=ir+3'b001;
	end
end

wire [6:0] out;
hamming7 inst_enc(
 .clock(clock), 
    .in1(in[0]), 
		.in2(in[1]), 
		.in3(in[2]), 
		.in4(in[3]),
    .out1(out[0]), 
		.out2(out[1]), 
		.out3(out[2]), 
		.out4(out[3]), 
		.out5(out[4]), 
		.out6(out[5]), 
		.out7(out[6]),
		.in_randon1(ir[0]),
		.in_randon2(ir[1]),
		.in_randon3(ir[2])
		);         
wire [3:0] outin;
resulting_dual inst_dec(
		.clk(clock),
    .in1(outin[0]), 
		.in2(outin[1]), 
		.in3(outin[2]), 
		.in4(outin[3]),
    .out1(out[0]), 
		.out2(out[1]), 
		.out3(out[2]), 
		.out4(out[3]), 
		.out5(out[4]), 
		.out6(out[5]), 
		.out7(out[6])
);

wire correct=(in==outin);

endmodule

