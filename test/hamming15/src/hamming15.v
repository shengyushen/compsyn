// Benchmark "hamming15" written by ABC on Mon Nov 24 09:52:03 2014

module hamming15 ( clock, 
    in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11,
    out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, out11,
    out12, out13, out14, out15  ,
		inr1,inr2,inr3,inr4
		);
  input  clock;
  input  in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11;
		input inr1,inr2,inr3,inr4;
  output out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, out11,
    out12, out13, out14, out15;
  reg r0, r1, r2, r3;
  wire n39, n40, n41, n42, n47, n48, n49, n50, n51, n52, n53, n54_1, n55,
    n56, n57, n58, n59_1, n60, n61, n79, n80, n81, n82, n83, n84, n85, n86,
    n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100,
    n101, n102, n103, n104, n105, n106, n107, n108, n109, n110, n111, n112,
    n113, n114, n115, n116, n117, n118, n119, n120, n121, n122, n123, n124,
    n125, n126, n127, n128, n129, n130, n131, n132, n133, n134, n135, n136,
    n137, n138, n139, n140, n54, n59, n64, n69;
  assign n39 = r0;
  assign n40 = r1;
  assign n41 = r2;
  assign n42 = r3;
  assign n54 = n39;
  assign n59 = n40;
  assign n64 = n41;
  assign n69 = n42;
  assign n47 = r0 & ~r1 & ~r2 & ~r3;
  assign n48 = ~r3 & ~r2 & ~r0 & r1;
  assign n49 = ~r3 & ~r2 & r0 & r1;
  assign n50 = ~r3 & r2 & ~r0 & ~r1;
  assign n51 = ~r3 & r0 & ~r1 & r2;
  assign n52 = ~r3 & r2 & ~r0 & r1;
  assign n53 = ~r3 & r2 & r0 & r1;
  assign n54_1 = r3 & ~r2 & ~r0 & ~r1;
  assign n55 = r0 & ~r1 & ~r2 & r3;
  assign n56 = r3 & ~r2 & ~r0 & r1;
  assign n57 = r3 & ~r2 & r0 & r1;
  assign n58 = r3 & r2 & ~r0 & ~r1;
  assign n59_1 = r3 & r0 & ~r1 & r2;
  assign n60 = r3 & r2 & ~r0 & r1;
  assign n61 = r3 & r2 & r0 & r1;
  assign out1 = ~n102 ^ ~n47;
  assign out2 = ~n111 ^ ~n48;
  assign out3 = ~n130 ^ ~n49;
  assign out4 = ~n120 ^ ~n50;
  assign out5 = ~n131 ^ ~n51;
  assign out6 = ~n132 ^ ~n52;
  assign out7 = ~n133 ^ ~n53;
  assign out8 = ~n129 ^ ~n54_1;
  assign out9 = ~n134 ^ ~n55;
  assign out10 = ~n135 ^ ~n56;
  assign out11 = ~n136 ^ ~n57;
  assign out12 = ~n137 ^ ~n58;
  assign out13 = ~n138 ^ ~n59_1;
  assign out14 = ~n139 ^ ~n60;
  assign out15 = ~n140 ^ ~n61;
  assign n79 = 1'b0;
  assign n80 = 1'b0;
  assign n81 = in1;
  assign n82 = 1'b0;
  assign n83 = in2;
  assign n84 = in3;
  assign n85 = in4;
  assign n86 = 1'b0;
  assign n87 = in5;
  assign n88 = in6;
  assign n89 = in7;
  assign n90 = in8;
  assign n91 = in9;
  assign n92 = in10;
  assign n93 = in11;
  assign n94 = n79;
  assign n95 = ~n81 ^ ~n94;
  assign n96 = ~n83 ^ ~n95;
  assign n97 = ~n85 ^ ~n96;
  assign n98 = ~n87 ^ ~n97;
  assign n99 = ~n89 ^ ~n98;
  assign n100 = ~n91 ^ ~n99;
  assign n101 = ~n93 ^ ~n100;
  assign n102 = n101;
  assign n103 = n80;
  assign n104 = ~n81 ^ ~n103;
  assign n105 = ~n84 ^ ~n104;
  assign n106 = ~n85 ^ ~n105;
  assign n107 = ~n88 ^ ~n106;
  assign n108 = ~n89 ^ ~n107;
  assign n109 = ~n92 ^ ~n108;
  assign n110 = ~n93 ^ ~n109;
  assign n111 = n110;
  assign n112 = n82;
  assign n113 = ~n83 ^ ~n112;
  assign n114 = ~n84 ^ ~n113;
  assign n115 = ~n85 ^ ~n114;
  assign n116 = ~n90 ^ ~n115;
  assign n117 = ~n91 ^ ~n116;
  assign n118 = ~n92 ^ ~n117;
  assign n119 = ~n93 ^ ~n118;
  assign n120 = n119;
  assign n121 = n86;
  assign n122 = ~n87 ^ ~n121;
  assign n123 = ~n88 ^ ~n122;
  assign n124 = ~n89 ^ ~n123;
  assign n125 = ~n90 ^ ~n124;
  assign n126 = ~n91 ^ ~n125;
  assign n127 = ~n92 ^ ~n126;
  assign n128 = ~n93 ^ ~n127;
  assign n129 = n128;
  assign n130 = n81;
  assign n131 = n83;
  assign n132 = n84;
  assign n133 = n85;
  assign n134 = n87;
  assign n135 = n88;
  assign n136 = n89;
  assign n137 = n90;
  assign n138 = n91;
  assign n139 = n92;
  assign n140 = n93;
  always @ (posedge clock) begin
    r0 <= inr1;
    r1 <= inr2;
    r2 <= inr3;
    r3 <= inr4;
  end
endmodule


