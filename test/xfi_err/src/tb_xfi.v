`timescale  1ns/10ps
module tb_xfi();
reg clock,reset;

initial begin
	clock=1'b1;
	forever #5 clock=~clock;
end

initial begin
	reset=1'b0;
	#9	reset=1'b1;
	#100	reset=1'b0;
end


reg	[15:0]	enc_data;

always	@(posedge clock) begin
	if(reset==1'b1) enc_data<=0;
	else enc_data<=enc_data+1;
end
wire	[63:0] enc_data_in={4{enc_data}};
wire	[7:0] enc_cntl_in=8'h00;
wire	[65:0] ENCODER_DATA_OUT;
//assert_always i1(data_66b_o!=enc_in);
XFIPCS_64B66B_ENC inst1(
                      .CLK(clock),
                      .RESET(reset),
                      .DATA_VALID(1'b1),
                      .ENCODER_DATA_IN(enc_data_in),
                      .ENCODER_CONTROL_IN(enc_cntl_in),
                      .TEST_PAT_SEED_A(0),
                      .TEST_PAT_SEED_B(0),
                      .TEST_MODE(0),
                      .DATA_PAT_SEL(0),
		      .ENCODER_DATA_OUT(ENCODER_DATA_OUT)
);

wire [7:0] cntl_dec;
wire [63:0] data_dec;
resulting_dual inst_dec(
   .ENCODER_CONTROL_IN(cntl_dec) ,
   .ENCODER_DATA_IN(data_dec) ,
   .ENCODER_DATA_OUT(ENCODER_DATA_OUT) ,
   .clk(clock)
);

wire correct=(cntl_dec==enc_cntl_in) && (enc_data_in==data_dec);

endmodule
