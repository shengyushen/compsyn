// Benchmark "hamming7" written by ABC on Mon Nov 24 08:48:29 2014

module hamming7 ( clock, 
    in1, in2, in3, in4,
    out1, out2, out3, out4, out5, out6, out7  );
  input  clock;
  input  in1, in2, in3, in4;
  output out1, out2, out3, out4, out5, out6, out7;
  reg r0, r1, r2;
  wire n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34,
    n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48,
    n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62,
    n63, n64, n65, n66, n67, n24_1, n29_1, n34_1;
  assign n21 = r0 & ~r2;
  assign n22 = ~r1 & n21;
  assign n23 = ~in2 & in4;
  assign n24 = in2 & ~in4;
  assign n25 = ~n23 & ~n24;
  assign n26 = in1 & ~n25;
  assign n27 = ~in1 & n25;
  assign n28 = ~n26 & ~n27;
  assign n29 = n22 & ~n28;
  assign n30 = ~n22 & n28;
  assign n31 = ~n29 & ~n30;
  assign n32 = ~r0 & r1;
  assign n33 = ~r2 & n32;
  assign n34 = ~in3 & ~in4;
  assign n35 = in3 & in4;
  assign n36 = ~n34 & ~n35;
  assign n37 = in1 & ~n36;
  assign n38 = ~in1 & n36;
  assign n39 = ~n37 & ~n38;
  assign n40 = n33 & n39;
  assign n41 = ~n33 & ~n39;
  assign n42 = ~n40 & ~n41;
  assign n43 = r0 & r1;
  assign n44 = ~r2 & n43;
  assign n45 = in1 & ~n44;
  assign n46 = ~in1 & n44;
  assign n47 = ~n45 & ~n46;
  assign n48 = ~r1 & r2;
  assign n49 = ~r0 & n48;
  assign n50 = in3 & ~n25;
  assign n51 = ~in3 & n25;
  assign n52 = ~n50 & ~n51;
  assign n53 = n49 & ~n52;
  assign n54 = ~n49 & n52;
  assign n55 = ~n53 & ~n54;
  assign n56 = r0 & n48;
  assign n57 = in2 & ~n56;
  assign n58 = ~in2 & n56;
  assign n59 = ~n57 & ~n58;
  assign n60 = r2 & n32;
  assign n61 = in3 & ~n60;
  assign n62 = ~in3 & n60;
  assign n63 = ~n61 & ~n62;
  assign n64 = r2 & n43;
  assign n65 = in4 & ~n64;
  assign n66 = ~in4 & n64;
  assign n67 = ~n65 & ~n66;
  assign out1 = ~n31;
  assign out2 = ~n42;
  assign out3 = ~n47;
  assign out4 = ~n55;
  assign out5 = ~n59;
  assign out6 = ~n63;
  assign out7 = ~n67;
  assign n24_1 = r0;
  assign n29_1 = r1;
  assign n34_1 = r2;
  always @ (posedge clock) begin
    r0 <= n24_1;
    r1 <= n29_1;
    r2 <= n34_1;
  end
endmodule


