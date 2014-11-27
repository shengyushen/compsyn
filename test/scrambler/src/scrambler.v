module scrambler(CLK,reset,data_66b_tpg,data_scrambled,assertion_shengyushen);
input [63:0] data_66b_tpg;
input CLK,reset;
output [63:0] data_scrambled;
output assertion_shengyushen;

  reg [57:0] data_prev;
  wire [57:0] data_prev_in;
  wire [38:0] data_scrambled_38_0;
  wire [18:0] data_scrambled_57_39;
  wire [5:0] data_scrambled_63_58;
//  wire [63:0] data_scrambled;

  assign data_scrambled_38_0  = data_66b_tpg[38:0]  ^ data_prev[57:19]           ^ data_prev[38:0]            ;
  assign data_scrambled_57_39 = data_66b_tpg[57:39] ^ data_scrambled_38_0[18:0]  ^ data_prev[57:39]           ;
  assign data_scrambled_63_58 = data_66b_tpg[63:58] ^ data_scrambled_38_0[24:19] ^ data_scrambled_38_0[5:0]   ;
  assign data_scrambled = {data_scrambled_63_58, data_scrambled_57_39, data_scrambled_38_0};

  assign data_prev_in = data_scrambled[63:6];

assign assertion_shengyushen=(reset==1'b0);

  always @(posedge CLK)
        data_prev <= (reset == 1'b1)?58'h0:data_prev_in;
endmodule
