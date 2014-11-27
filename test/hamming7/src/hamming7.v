// Benchmark "hamming7" written by ABC on Mon Nov 24 09:53:00 2014
//shengyu shen modify it add three random input
module hamming7 ( clock, 
    in1, in2, in3, in4,
    out1, out2, out3, out4, out5, out6, out7 ,in_randon1,in_randon2,in_randon3 );
  input  clock;
  input  in1, in2, in3, in4;
	input in_randon1,in_randon2,in_randon3;
  output out1, out2, out3, out4, out5, out6, out7;
  reg r0, r1, r2;
  wire n21, n22, n23, n27, n28, n29_1, n30, n31, n32, n33, n43, n44, n45,
    n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59,
    n60, n61, n62, n63, n64, n65, n66, n67, n68, n24, n29, n34;
  assign n21 = r0;
  assign n22 = r1;
  assign n23 = r2;
  assign n24 = n21;
  assign n29 = n22;
  assign n34 = n23;
  assign n27 = r0 & ~r1 & ~r2;
  assign n28 = ~r2 & ~r0 & r1;
  assign n29_1 = ~r2 & r0 & r1;
  assign n30 = r2 & ~r0 & ~r1;
  assign n31 = r0 & ~r1 & r2;
  assign n32 = r2 & ~r0 & r1;
  assign n33 = r2 & r0 & r1;
  assign out1 = ~n54 ^ ~n27;
  assign out2 = ~n59 ^ ~n28;
  assign out3 = ~n65 ^ ~n29_1;
  assign out4 = ~n64 ^ ~n30;
  assign out5 = ~n66 ^ ~n31;
  assign out6 = ~n67 ^ ~n32;
  assign out7 = ~n68 ^ ~n33;
  assign n43 = 1'b0;
  assign n44 = 1'b0;
  assign n45 = in1;
  assign n46 = 1'b0;
  assign n47 = in2;
  assign n48 = in3;
  assign n49 = in4;
  assign n50 = n43;
  assign n51 = ~n45 ^ ~n50;
  assign n52 = ~n47 ^ ~n51;
  assign n53 = ~n49 ^ ~n52;
  assign n54 = n53;
  assign n55 = n44;
  assign n56 = ~n45 ^ ~n55;
  assign n57 = ~n48 ^ ~n56;
  assign n58 = ~n49 ^ ~n57;
  assign n59 = n58;
  assign n60 = n46;
  assign n61 = ~n47 ^ ~n60;
  assign n62 = ~n48 ^ ~n61;
  assign n63 = ~n49 ^ ~n62;
  assign n64 = n63;
  assign n65 = n45;
  assign n66 = n47;
  assign n67 = n48;
  assign n68 = n49;
  always @ (posedge clock) begin
    r0 <= in_randon1;
    r1 <= in_randon2;
    r2 <= in_randon3;
  end
endmodule


