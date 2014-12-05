module buffer (in,out,reset,clk);
input  [1:0] in;
output [1:0] out;
input reset;
input clk;

reg [1:0] tmp1;
reg [1:0] tmp2;
reg [1:0] tmp3;
reg [1:0] tmp4;

always @(posedge clk) begin
	if(reset==1'b1) begin
		tmp1 <= 2'b0;
		tmp2 <= 2'b0;
		tmp3 <= 2'b0;
		tmp4 <= 2'b0;
	end
	else begin
		tmp1 <= (in==2'b01)?2'b00:in;
		tmp2 <= tmp1;
		tmp3 <= tmp2;
		tmp4 <= tmp3;
	end
end

assign out = tmp4;
endmodule
