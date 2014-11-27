// Benchmark "hamming" written by ABC on Mon Nov 24 10:37:05 2014

module hamming ( clock, 
    in1, in2, in3, in4,
    out2, out3, out4, out5, out6, out7  );
  input  clock;
  input  in1, in2, in3, in4;
  output out2, out3, out4, out5, out6, out7;
  reg c2, c1, c0, r0, r1, r2;
  wire n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n41, n42, n43,
    n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n55, n56, n57, n58,
    n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n22,
    n27, n32_1, n37_1, n42_1, n47_1;
  assign n29 = c2 & ~r0;
  assign n30 = r1 & n29;
  assign n31 = ~r2 & n30;
  assign n32 = in3 & ~in4;
  assign n33 = ~in3 & in4;
  assign n34 = ~n32 & ~n33;
  assign n35 = ~in1 & n34;
  assign n36 = in1 & ~n34;
  assign n37 = ~n35 & ~n36;
  assign n38 = n31 & n37;
  assign n39 = ~n31 & ~n37;
  assign out2 = ~n38 & ~n39;
  assign n41 = c2 & r0;
  assign n42 = r1 & n41;
  assign n43 = ~r2 & n42;
  assign n44 = in1 & ~n43;
  assign n45 = ~in1 & n43;
  assign n46 = ~n44 & ~n45;
  assign n47 = ~r1 & r2;
  assign n48 = n29 & n47;
  assign n49 = ~in2 & n34;
  assign n50 = in2 & ~n34;
  assign n51 = ~n49 & ~n50;
  assign n52 = n48 & n51;
  assign n53 = ~n48 & ~n51;
  assign out4 = ~n52 & ~n53;
  assign n55 = n41 & n47;
  assign n56 = ~in2 & n55;
  assign n57 = in2 & ~n55;
  assign n58 = ~n56 & ~n57;
  assign n59 = r2 & n30;
  assign n60 = in3 & ~n59;
  assign n61 = ~in3 & n59;
  assign n62 = ~n60 & ~n61;
  assign n63 = r2 & n42;
  assign n64 = in4 & ~n63;
  assign n65 = ~in4 & n63;
  assign n66 = ~n64 & ~n65;
  assign n67 = c1 & c0;
  assign n68 = c2 & ~n67;
  assign n69 = ~c2 & n67;
  assign n70 = ~n68 & ~n69;
  assign n71 = ~c1 & ~c0;
  assign n27 = ~n67 & ~n71;
  assign out3 = ~n46;
  assign out5 = ~n58;
  assign out6 = ~n62;
  assign out7 = ~n66;
  assign n22 = ~n70;
  assign n32_1 = ~c0;
  assign n37_1 = r0;
  assign n42_1 = r1;
  assign n47_1 = r2;
  always @ (posedge clock) begin
    c2 <= n22;
    c1 <= n27;
    c0 <= n32_1;
    r0 <= n37_1;
    r1 <= n42_1;
    r2 <= n47_1;
  end
endmodule


