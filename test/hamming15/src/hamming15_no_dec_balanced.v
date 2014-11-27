// Benchmark "hamming" written by ABC on Mon Nov 24 10:39:49 2014

module hamming ( clock, 
    in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11,
    out2, out3, out4, out5, out6, out7, out8, out9, out10, out11, out12,
    out13, out14, out15  );
  input  clock;
  input  in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11;
  output out2, out3, out4, out5, out6, out7, out8, out9, out10, out11, out12,
    out13, out14, out15;
  reg c2, c1, c0, r0, r1, r2, r3;
  wire n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60,
    n61, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74,
    n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88,
    n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101,
    n102, n103, n104, n105, n106, n107, n108, n109, n110, n111, n112, n113,
    n114, n115, n116, n117, n118, n119, n120, n121, n122, n123, n124, n125,
    n126, n127, n128, n130, n131, n132, n133, n134, n135, n136, n137, n138,
    n139, n140, n141, n142, n143, n144, n145, n146, n147, n148, n149, n150,
    n151, n152, n153, n154, n155, n156, n157, n158, n159, n160, n161, n162,
    n52_1, n57_1, n62_1, n67_1, n72_1, n77_1, n82_1;
  assign n47 = c2 & ~r0;
  assign n48 = r1 & n47;
  assign n49 = ~r2 & n48;
  assign n50 = ~r3 & n49;
  assign n51 = ~in10 & in11;
  assign n52 = in10 & ~in11;
  assign n53 = ~n51 & ~n52;
  assign n54 = in4 & ~n53;
  assign n55 = ~in4 & n53;
  assign n56 = ~n54 & ~n55;
  assign n57 = in6 & ~in7;
  assign n58 = ~in6 & in7;
  assign n59 = ~n57 & ~n58;
  assign n60 = in1 & in3;
  assign n61 = ~in1 & ~in3;
  assign n62 = ~n60 & ~n61;
  assign n63 = ~n59 & n62;
  assign n64 = n59 & ~n62;
  assign n65 = ~n63 & ~n64;
  assign n66 = n56 & n65;
  assign n67 = ~n56 & ~n65;
  assign n68 = ~n66 & ~n67;
  assign n69 = n50 & ~n68;
  assign n70 = ~n50 & n68;
  assign n71 = ~n69 & ~n70;
  assign n72 = c2 & r0;
  assign n73 = r1 & n72;
  assign n74 = ~r2 & n73;
  assign n75 = ~r3 & n74;
  assign n76 = in1 & ~n75;
  assign n77 = ~in1 & n75;
  assign n78 = ~n76 & ~n77;
  assign n79 = ~r1 & n47;
  assign n80 = r2 & n79;
  assign n81 = ~r3 & n80;
  assign n82 = ~in8 & ~in9;
  assign n83 = in8 & in9;
  assign n84 = ~n82 & ~n83;
  assign n85 = in2 & ~in3;
  assign n86 = ~in2 & in3;
  assign n87 = ~n85 & ~n86;
  assign n88 = ~n84 & n87;
  assign n89 = n84 & ~n87;
  assign n90 = ~n88 & ~n89;
  assign n91 = n56 & n90;
  assign n92 = ~n56 & ~n90;
  assign n93 = ~n91 & ~n92;
  assign n94 = n81 & ~n93;
  assign n95 = ~n81 & n93;
  assign n96 = ~n94 & ~n95;
  assign n97 = ~r1 & n72;
  assign n98 = r2 & n97;
  assign n99 = ~r3 & n98;
  assign n100 = in2 & ~n99;
  assign n101 = ~in2 & n99;
  assign n102 = ~n100 & ~n101;
  assign n103 = r2 & n48;
  assign n104 = ~r3 & n103;
  assign n105 = in3 & ~n104;
  assign n106 = ~in3 & n104;
  assign n107 = ~n105 & ~n106;
  assign n108 = r2 & n73;
  assign n109 = ~r3 & n108;
  assign n110 = in4 & ~n109;
  assign n111 = ~in4 & n109;
  assign n112 = ~n110 & ~n111;
  assign n113 = ~r2 & r3;
  assign n114 = n79 & n113;
  assign n115 = ~in11 & n114;
  assign n116 = in11 & ~n114;
  assign n117 = ~n115 & ~n116;
  assign n118 = ~in5 & ~in10;
  assign n119 = in5 & in10;
  assign n120 = ~n118 & ~n119;
  assign n121 = ~n59 & n84;
  assign n122 = n59 & ~n84;
  assign n123 = ~n121 & ~n122;
  assign n124 = ~n120 & ~n123;
  assign n125 = n120 & n123;
  assign n126 = ~n124 & ~n125;
  assign n127 = ~n117 & n126;
  assign n128 = n117 & ~n126;
  assign out8 = ~n127 & ~n128;
  assign n130 = n97 & n113;
  assign n131 = ~in5 & n130;
  assign n132 = in5 & ~n130;
  assign n133 = ~n131 & ~n132;
  assign n134 = r3 & n49;
  assign n135 = in6 & ~n134;
  assign n136 = ~in6 & n134;
  assign n137 = ~n135 & ~n136;
  assign n138 = r3 & n74;
  assign n139 = in7 & ~n138;
  assign n140 = ~in7 & n138;
  assign n141 = ~n139 & ~n140;
  assign n142 = r3 & n80;
  assign n143 = in8 & ~n142;
  assign n144 = ~in8 & n142;
  assign n145 = ~n143 & ~n144;
  assign n146 = r3 & n98;
  assign n147 = in9 & ~n146;
  assign n148 = ~in9 & n146;
  assign n149 = ~n147 & ~n148;
  assign n150 = r3 & n103;
  assign n151 = in10 & ~n150;
  assign n152 = ~in10 & n150;
  assign n153 = ~n151 & ~n152;
  assign n154 = r3 & n108;
  assign n155 = in11 & ~n154;
  assign n156 = ~in11 & n154;
  assign n157 = ~n155 & ~n156;
  assign n158 = c1 & c0;
  assign n159 = c2 & ~n158;
  assign n160 = ~c2 & n158;
  assign n161 = ~n159 & ~n160;
  assign n162 = ~c1 & ~c0;
  assign n57_1 = ~n158 & ~n162;
  assign out2 = ~n71;
  assign out3 = ~n78;
  assign out4 = ~n96;
  assign out5 = ~n102;
  assign out6 = ~n107;
  assign out7 = ~n112;
  assign out9 = ~n133;
  assign out10 = ~n137;
  assign out11 = ~n141;
  assign out12 = ~n145;
  assign out13 = ~n149;
  assign out14 = ~n153;
  assign out15 = ~n157;
  assign n52_1 = ~n161;
  assign n62_1 = ~c0;
  assign n67_1 = r0;
  assign n72_1 = r1;
  assign n77_1 = r2;
  assign n82_1 = r3;
  always @ (posedge clock) begin
    c2 <= n52_1;
    c1 <= n57_1;
    c0 <= n62_1;
    r0 <= n67_1;
    r1 <= n72_1;
    r2 <= n77_1;
    r3 <= n82_1;
  end
endmodule


