module muxencoder (clk,in_data,in_datavalid,out_data,out_datavalid);
input clk;
input [7:0] in_data;
input  in_datavalid;
output [7:0] out_data;
output out_datavalid;


reg [7:0] reg_data1;
reg reg_datavalid1;
reg [7:0] reg_data2;
reg reg_datavalid2;
reg [7:0] reg_data3;
reg reg_datavalid3;
reg [7:0] reg_data4;
reg reg_datavalid4;
reg [7:0] reg_data5;
reg reg_datavalid5;
reg [7:0] reg_data6;
reg reg_datavalid6;
reg [7:0] reg_data7;
reg reg_datavalid7;

always @(posedge clk) begin
	reg_data1 <= in_datavalid?in_data:8'b0;
	reg_datavalid1 <= in_datavalid;
	reg_data2 <= reg_data1;
	reg_datavalid2 <= reg_datavalid1;
	reg_data3 <= reg_data2;
	reg_datavalid3 <= reg_datavalid2;
	reg_data4 <= reg_data3;
	reg_datavalid4 <= reg_datavalid3;
	reg_data5 <= reg_data4;
	reg_datavalid5 <= reg_datavalid4;
	reg_data6 <= reg_data5;
	reg_datavalid6 <= reg_datavalid5;
	reg_data7 <= reg_data6;
	reg_datavalid7 <= reg_datavalid6;
end

assign out_data=reg_data7;
assign out_datavalid=reg_datavalid7;

endmodule
