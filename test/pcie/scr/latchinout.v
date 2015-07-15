module latchinout (
input [9:0] HSS_TXD,
output  TXDATAK,
output [7:0] TXDATA,
input clk);

reg [9:0] HSS_TXD_pipe;
reg  TXDATAK_pipe;
reg [7:0] TXDATA_pipe;

wire  TXDATAK_w;
wire [7:0] TXDATA_w;
resulting_dual inst_dec(
.HSS_TXD(HSS_TXD_pipe),
.TXDATAK(TXDATAK_w),
.TXDATA(TXDATA_w),
.clk(clk)
);


always @(posedge clk) begin
	HSS_TXD_pipe <= HSS_TXD ; 
	TXDATAK_pipe <= TXDATAK_w ;
	TXDATA_pipe <= TXDATA_w ;
end


assign TXDATAK = TXDATAK_pipe ;
assign TXDATA = TXDATA_pipe ;
endmodule
