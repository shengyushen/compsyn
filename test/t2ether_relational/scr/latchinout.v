module latchinout (
clk,
 tx_10bdata,
  tx_enc_ctrl_sel,
  txd
);
input clk;
input [9:0]  tx_10bdata;
output [3:0]  tx_enc_ctrl_sel;
output [7:0]  txd;

reg [9:0] tx_10bdata_reg;
always @(posedge clk) begin
	tx_10bdata_reg <= tx_10bdata ;
end

wire [7:0] txd_wire;
wire [3:0] tx_enc_ctrl_sel_wire;
 resulting_dual inst1(
  .tx_10bdata(tx_10bdata_reg),
  .tx_enc_ctrl_sel(tx_enc_ctrl_sel_wire),
  .txd(txd_wire),
  .clk(clk));

reg [7:0] txd_reg;
reg [3:0] tx_enc_ctrl_sel_reg;
always @(posedge clk) begin
	txd_reg <= txd_wire;
	tx_enc_ctrl_sel_reg <= tx_enc_ctrl_sel_wire ;
end
assign tx_enc_ctrl_sel = tx_enc_ctrl_sel_reg;
assign txd = txd_reg ;
endmodule
