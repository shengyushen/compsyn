module latchinout(
   tx_enc_ctrl_sel , 
   txd , 
   tx_10bdata , 
   clk
);


  output [3:0] tx_enc_ctrl_sel ; 
  output [7:0] txd ; 
  input  [9:0] tx_10bdata ; 
	input clk;

  reg [3:0] tx_enc_ctrl_sel_pipe ; 
  reg [7:0] txd_pipe ; 
  reg [9:0] tx_10bdata_pipe ; 

  wire [3:0] tx_enc_ctrl_sel_w ; 
  wire [7:0] txd_w ; 

always @(posedge clk) begin
	tx_10bdata_pipe <= tx_10bdata ;
	tx_enc_ctrl_sel_pipe <= tx_enc_ctrl_sel_w ;
	txd_pipe <= txd_w ;
end

assign tx_enc_ctrl_sel = tx_enc_ctrl_sel_pipe ;
assign txd = txd_pipe ;
 resulting_dual inst_dec(
   .tx_enc_ctrl_sel(tx_enc_ctrl_sel_w) , 
   .txd(txd_w) , 
   .tx_10bdata(tx_10bdata_pipe) , 
   .clk(clk)
);

endmodule
