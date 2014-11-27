// Benchmark "hamming15" written by ABC on Mon Nov 24 08:52:41 2014

module hamming15 ( clock, 
    in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11,
    out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, out11,
    out12, out13, out14, out15  );
  input  clock;
  input  in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11;
  output out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, out11,
    out12, out13, out14, out15;
  reg r0, r1, r2, r3;
  wire n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50, n51, n52,
    n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66,
    n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80,
    n81, n82, n83, n84, n85, n87, n88, n89, n90, n91, n92, n93, n94, n95,
    n96, n97, n98, n99, n100, n101, n102, n103, n104, n105, n106, n107,
    n108, n109, n110, n111, n112, n113, n114, n115, n116, n117, n118, n119,
    n120, n121, n122, n123, n124, n125, n126, n127, n128, n129, n130, n131,
    n132, n133, n134, n135, n136, n137, n138, n139, n140, n141, n142, n143,
    n144, n145, n146, n147, n148, n149, n150, n151, n152, n153, n154, n155,
    n156, n157, n158, n159, n160, n161, n162, n163, n164, n165, n166, n167,
    n168, n169, n170, n171, n172, n173, n54_1, n59_1, n64_1, n69_1;
  assign n39 = r0 & ~r1;
  assign n40 = ~r2 & n39;
  assign n41 = ~r3 & n40;
  assign n42 = in11 & ~n41;
  assign n43 = ~in11 & n41;
  assign n44 = ~n42 & ~n43;
  assign n45 = ~in5 & in7;
  assign n46 = in5 & ~in7;
  assign n47 = ~n45 & ~n46;
  assign n48 = in4 & ~n47;
  assign n49 = ~in4 & n47;
  assign n50 = ~n48 & ~n49;
  assign n51 = in1 & in2;
  assign n52 = ~in1 & ~in2;
  assign n53 = ~n51 & ~n52;
  assign n54 = in9 & ~n53;
  assign n55 = ~in9 & n53;
  assign n56 = ~n54 & ~n55;
  assign n57 = ~n50 & ~n56;
  assign n58 = n50 & n56;
  assign n59 = ~n57 & ~n58;
  assign n60 = ~n44 & n59;
  assign n61 = n44 & ~n59;
  assign n62 = ~n60 & ~n61;
  assign n63 = ~r0 & r1;
  assign n64 = ~r2 & n63;
  assign n65 = ~r3 & n64;
  assign n66 = ~in4 & in10;
  assign n67 = in4 & ~in10;
  assign n68 = ~n66 & ~n67;
  assign n69 = in3 & ~n68;
  assign n70 = ~in3 & n68;
  assign n71 = ~n69 & ~n70;
  assign n72 = in7 & ~in11;
  assign n73 = ~in7 & in11;
  assign n74 = ~n72 & ~n73;
  assign n75 = in1 & in6;
  assign n76 = ~in1 & ~in6;
  assign n77 = ~n75 & ~n76;
  assign n78 = n74 & n77;
  assign n79 = ~n74 & ~n77;
  assign n80 = ~n78 & ~n79;
  assign n81 = ~n71 & n80;
  assign n82 = n71 & ~n80;
  assign n83 = ~n81 & ~n82;
  assign n84 = ~n65 & ~n83;
  assign n85 = n65 & n83;
  assign out2 = ~n84 & ~n85;
  assign n87 = r0 & r1;
  assign n88 = ~r2 & n87;
  assign n89 = ~r3 & n88;
  assign n90 = in1 & ~n89;
  assign n91 = ~in1 & n89;
  assign n92 = ~n90 & ~n91;
  assign n93 = ~r0 & ~r1;
  assign n94 = r2 & n93;
  assign n95 = ~r3 & n94;
  assign n96 = ~in8 & ~in9;
  assign n97 = in8 & in9;
  assign n98 = ~n96 & ~n97;
  assign n99 = in2 & ~in11;
  assign n100 = ~in2 & in11;
  assign n101 = ~n99 & ~n100;
  assign n102 = ~n98 & n101;
  assign n103 = n98 & ~n101;
  assign n104 = ~n102 & ~n103;
  assign n105 = n71 & n104;
  assign n106 = ~n71 & ~n104;
  assign n107 = ~n105 & ~n106;
  assign n108 = n95 & ~n107;
  assign n109 = ~n95 & n107;
  assign n110 = ~n108 & ~n109;
  assign n111 = r2 & n39;
  assign n112 = ~r3 & n111;
  assign n113 = in2 & ~n112;
  assign n114 = ~in2 & n112;
  assign n115 = ~n113 & ~n114;
  assign n116 = r2 & n63;
  assign n117 = ~r3 & n116;
  assign n118 = in3 & ~n117;
  assign n119 = ~in3 & n117;
  assign n120 = ~n118 & ~n119;
  assign n121 = r2 & n87;
  assign n122 = ~r3 & n121;
  assign n123 = in4 & ~n122;
  assign n124 = ~in4 & n122;
  assign n125 = ~n123 & ~n124;
  assign n126 = r3 & n93;
  assign n127 = ~r2 & n126;
  assign n128 = ~in11 & ~n127;
  assign n129 = in11 & n127;
  assign n130 = ~n128 & ~n129;
  assign n131 = ~in6 & in10;
  assign n132 = in6 & ~in10;
  assign n133 = ~n131 & ~n132;
  assign n134 = in5 & ~n133;
  assign n135 = ~in5 & n133;
  assign n136 = ~n134 & ~n135;
  assign n137 = in7 & n98;
  assign n138 = ~in7 & ~n98;
  assign n139 = ~n137 & ~n138;
  assign n140 = n136 & ~n139;
  assign n141 = ~n136 & n139;
  assign n142 = ~n140 & ~n141;
  assign n143 = ~n130 & ~n142;
  assign n144 = n130 & n142;
  assign n145 = ~n143 & ~n144;
  assign n146 = r3 & n40;
  assign n147 = in5 & ~n146;
  assign n148 = ~in5 & n146;
  assign n149 = ~n147 & ~n148;
  assign n150 = r3 & n64;
  assign n151 = in6 & ~n150;
  assign n152 = ~in6 & n150;
  assign n153 = ~n151 & ~n152;
  assign n154 = r3 & n88;
  assign n155 = in7 & ~n154;
  assign n156 = ~in7 & n154;
  assign n157 = ~n155 & ~n156;
  assign n158 = r3 & n94;
  assign n159 = in8 & ~n158;
  assign n160 = ~in8 & n158;
  assign n161 = ~n159 & ~n160;
  assign n162 = r3 & n111;
  assign n163 = in9 & ~n162;
  assign n164 = ~in9 & n162;
  assign n165 = ~n163 & ~n164;
  assign n166 = r3 & n116;
  assign n167 = in10 & ~n166;
  assign n168 = ~in10 & n166;
  assign n169 = ~n167 & ~n168;
  assign n170 = r3 & n121;
  assign n171 = in11 & ~n170;
  assign n172 = ~in11 & n170;
  assign n173 = ~n171 & ~n172;
  assign out1 = ~n62;
  assign out3 = ~n92;
  assign out4 = ~n110;
  assign out5 = ~n115;
  assign out6 = ~n120;
  assign out7 = ~n125;
  assign out8 = ~n145;
  assign out9 = ~n149;
  assign out10 = ~n153;
  assign out11 = ~n157;
  assign out12 = ~n161;
  assign out13 = ~n165;
  assign out14 = ~n169;
  assign out15 = ~n173;
  assign n54_1 = r0;
  assign n59_1 = r1;
  assign n64_1 = r2;
  assign n69_1 = r3;
  always @ (posedge clock) begin
    r0 <= n54_1;
    r1 <= n59_1;
    r2 <= n64_1;
    r3 <= n69_1;
  end
endmodule


