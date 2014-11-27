module descrambler(CLK,reset,data_66b_tpg,data_scrambled);
input [63:0] data_66b_tpg;
input CLK,reset;
output [63:0] data_scrambled;

  reg  [57:0] data_prev;
  wire [57:0] data_to_save;

  always @(posedge CLK)
    begin
      data_prev <= reset ? 58'h0:data_66b_tpg[63:6];
    end

  wire [63:0] data_shifted_39;
  wire [63:0] data_shifted_58;
  wire [63:0] block_payload;

  assign data_shifted_39 = {data_66b_tpg[24:0], data_prev[57:19]};
  assign data_shifted_58 = {data_66b_tpg[5:0], data_prev};
  assign data_scrambled = data_66b_tpg[63:0] ^ data_shifted_39 ^ data_shifted_58;

endmodule
