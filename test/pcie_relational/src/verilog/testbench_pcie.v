module testbench_pcie ();

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

reg [7:0] data;

always @(posedge clock or posedge reset) begin
	if(reset==1'b1) data<=0;
	else data<=data+1;
end

wire  datak;
assign datak=(data==8'h1C  || data==8'h3C  || data==8'h5C  || data==8'h9C  || data==8'hBC  || data==8'hDC  || data==8'hFC  || data==8'hF7  || data==8'hFB  || data==8'hFD  || data==8'hFE  );
assign CNTL_TXEnable_P0=(data!=8'h25);

reg [7:0] data_1;
reg      datak_1;

reg [7:0] data_2;
reg      datak_2;

always @(posedge clock) begin
	 data_1 <=  data;
	datak_1 <= datak;

	 data_2 <=  data_1;
	datak_2 <= datak_1;
end

wire [9:0] txd;

PCIEXP_TX inst_tx
    (
      .PCLK250(clock)                                    ,

      .RST_BeaconEnable_R0(1'b0)                        ,

      .CNTL_RESETN_P0(~reset)                             ,
      .CNTL_Loopback_P0(1'b0)                           ,
      .CNTL_TXEnable_P0(CNTL_TXEnable_P0)                           ,

      .RX_LoopbackData_P2(10'b0)                         ,

      .TXCOMPLIANCE(1'b1)                               ,
      .TXDATA(data)                                     ,
      .TXDATAK (datak)                                   ,
      .TXELECIDLE (1'b0)                                ,

      .HSS_TXBEACONCMD (HSS_TXBEACONCMD)                           ,
      .HSS_TXD         (txd)                           ,
      .HSS_TXELECIDLE	(HSS_TXELECIDLE)			,
      
      .assertion_shengyushen()

    );

wire [7:0] datarx;
wire   datakrx;


wire [7:0] data_recov;
wire datak_recov;

resulting_dual inst_rx_dualsyn(
  .HSS_TXELECIDLE(HSS_TXELECIDLE),
  .HSS_TXBEACONCMD(HSS_TXBEACONCMD),
   .HSS_TXD(txd) ,
   .TXDATA(data_recov) ,
   .TXDATAK(datak_recov) ,
  .CNTL_TXEnable_P0(CNTL_TXEnable_P0_recov),
   .clk(clock)
);

reg [7:0] data1;
reg      datak1;

reg [7:0] data2;
reg      datak2;

always @(posedge clock) begin
	 data1 <=  data;
	datak1 <= datak;

	 data2 <=  data1;
	datak2 <= datak1;

end

wire correct=(data2==data_recov) && (datak2==datak_recov);

endmodule
