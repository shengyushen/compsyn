`timescale 1ns/10ps


module tb();
reg clk;
reg rst;

initial 
begin
	clk=0;
	forever 
	#(3) clk=~clk;
end

initial 
begin
	rst=0;
	#1 rst=1;
	#3 rst=0;
end

reg [7:0] encode_data_reg;
reg       konstant_reg;

always @(posedge clk) 
begin
	if(rst) begin
		konstant_reg=0;
		encode_data_reg=0;
	end 
	else begin
		encode_data_reg<=encode_data_reg+1;
		konstant_reg=(encode_data_reg==8'hBB || encode_data_reg==8'h1B || encode_data_reg==8'h7B);
	end
end

wire [9:0] edc;

XGXSSYNTH_ENC_8B10B inst_0 (
	.bad_code(1'b0),
	.bad_disp(1'b0),
	.clk(clk),
	.encode_data_in(encode_data_reg),
	.konstant(konstant_reg),
	.rst(rst),
	.disp_out(),
	.encode_data_out(edc)
);

wire [7:0] decode_data_res;
wire konstant_res;

XGXSSYNTH_DEC_8B10B inst_1(
	.clk(clk),
	.decode_data_in(edc),
	.rst(rst),
	.code_bad(),
	.code_viol(),
	.decode_data_out(decode_data_res),
	.konstant_rx(konstant_res)
                      );
wire [7:0] decode_data_res_gen;
wire konstant_res_gen;

resulting_dual inst_1_gen(
   .encode_data_in(decode_data_res_gen) , 
   .konstant(konstant_res_gen) , 
   .encode_data_out(edc) , 
   .clk(clk)
);
/*
resulting_dual_bad inst_1_gen_bad(
   .encode_data_in() , 
   .konstant() , 
   .encode_data_out(edc) , 
   .clk(clk)
);
*/
wire correct=(decode_data_res==decode_data_res_gen) && (konstant_res == konstant_res_gen);
//wire improper_case=(edc[9]==1'b0 && edc[8]==1'b1 && edc[6]==1'b1 );
endmodule
