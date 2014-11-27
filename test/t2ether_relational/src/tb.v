`timescale 1ns/10ps
`include  "pcs_define.h"


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
reg [3:0] tx_enc_ctrl_sel;
always @(posedge clk) 
begin
	if(rst) begin
		konstant_reg<=0;
		encode_data_reg<=0;
		tx_enc_ctrl_sel<=`PCS_ENC_DATA;
	end 
	else begin
		encode_data_reg<=encode_data_reg+1;
		konstant_reg<=0;
		tx_enc_ctrl_sel<=(encode_data_reg==0)?`PCS_ENC_K285:
		(encode_data_reg==1)?`PCS_ENC_SOP:
		(encode_data_reg==2)?`PCS_ENC_T_CHAR:
		(encode_data_reg==3)?`PCS_ENC_R_CHAR:
		(encode_data_reg==4)?`PCS_ENC_H_CHAR:`PCS_ENC_DATA;
	end
end

wire [9:0] edc;
pcs_tx_dpath inst_0(
	.txclk(clk),
	.reset_tx(rst),
	.txd(encode_data_reg),
	.tx_en(1'b0),
	.tx_er(1'b0),		// inputs
	.adver_reg(0),
	.ack(0),
	.txd_sel(`PCS_TX_GMII_DATA),
	.tx_enc_ctrl_sel(tx_enc_ctrl_sel),
	.tx_enc_conf_sel(`PCS_ENC_DATA),
	.link_up_loc(1'b1),	
	.jitter_study_pci(2'b00),

	.tx_10bdata(edc),
	.tx_en_d(tx_en_d),
	.tx_er_d(tx_er_d),
	.txd_eq_crs_ext(txd_eq_crs_ext), 	// outputs
	.pos_disp_tx_p(pos_disp_tx_p)
);

wire [7:0] decode_data_res_gen;
wire [3:0] tx_enc_ctrl_sel_rec;
resulting_dual inst_1_gen(
  .pos_disp_tx_p(pos_disp_tx_p),
  .tx_en_d(tx_en_d),
  .tx_er_d(tx_er_d),
  .txd_eq_crs_ext(txd_eq_crs_ext),
   .tx_10bdata(edc) , 
  .tx_er(tx_er_rec),
  .tx_en(tx_en_rec),
  .tx_enc_ctrl_sel(tx_enc_ctrl_sel_rec),
   .txd(decode_data_res_gen) , 
   .clk(clk)
);


wire [7:0] add4=decode_data_res_gen+4;
wire correct=(add4==encode_data_reg);
endmodule
