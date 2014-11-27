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

always @(posedge clk) 
begin
	if(rst) begin
		konstant_reg=0;
		encode_data_reg=0;
	end 
	else begin
		encode_data_reg<=encode_data_reg+1;
		konstant_reg=0;
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
	.tx_enc_ctrl_sel(`PCS_ENC_DATA),
	.tx_enc_conf_sel(`PCS_ENC_DATA),
	.link_up_loc(1'b1),	
	.jitter_study_pci(2'b00),

	.tx_10bdata(edc),
	.tx_en_d(),
	.tx_er_d(),
	.txd_eq_crs_ext(), 	// outputs
	.pos_disp_tx_p()
);

wire [7:0] decode_data_res_gen;

resulting_dual inst_1_gen(
   .txd(decode_data_res_gen) , 
   .tx_10bdata(edc) , 
   .clk(clk)
);


wire [7:0] add4=decode_data_res_gen+4;
wire correct=(add4==encode_data_reg);
endmodule
