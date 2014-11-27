
`include "XFIPCS.defines.v"
`timescale 1ns/10ps

module `XFIPCS_TOPLEVELNAME_ASYNC_DRS (
                        clk,
                        data_in,
                        data_out
                );

input           clk;
input           data_in;
output          data_out;
wire            data_out;

reg             drs1;
reg             drs2;
wire            data_wam;

parameter       SHORT_DELAY=0;
parameter       NO_XSTATE=0;

`ifdef XFIPCS_TOPLEVELNAME_WAM_ON
wam #(.random_seed(0),
      .gated_data(0),
      .short_delay(SHORT_DELAY),
      .negative_edge(0),
      .no_xstate(NO_XSTATE)) wam(.datain(data_in), .dataout(data_wam), .dst_clk(clk));
`else
assign data_wam = data_in;
`endif

always @(posedge clk)
  begin
    drs1 <= data_wam;
    drs2 <= drs1;
  end

assign data_out = drs2;

endmodule
