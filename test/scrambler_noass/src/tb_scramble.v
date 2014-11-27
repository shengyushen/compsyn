module tb_scramble();
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
reg	[31:0]	r;
always	@(posedge clock) begin
	if(reset==1'b1) enc_data<=0;
	else enc_data<=enc_data+1;
	
	r<=$random;
end
wire [63:0] d;
wire [63:0] din,dout,dout_gen;
assign din = {4{enc_data}};
scrambler scrambler(.CLK(clock),
		.reset(reset),
		.data_66b_tpg(din),
		.data_scrambled(d)
		);
wire	rgen=(r>0 && r<200000000);
descrambler descrambler(.CLK(clock),
		.reset(reset),
		.data_66b_tpg(rgen?0:d),
		.data_scrambled(dout)
		);
		
resulting_dual	inst_gened(
   .data_66b_tpg(dout_gen) , 
   .data_scrambled(rgen?0:d) , 
   .clk(clock)
);

//assert_always i1(din!=dout);
wire	correct=(dout_gen==dout);
endmodule
