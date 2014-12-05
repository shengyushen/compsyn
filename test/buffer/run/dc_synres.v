
module buffer ( in, out, reset, clk );
  input [1:0] in;
  output [1:0] out;
  input reset, clk;
  wire   n2, n3, n20, U8_Z_0, U8_Z_1, U7_Z_0, U7_Z_1, U6_Z_0, U6_Z_1,
         U6_DATA2_0, U6_DATA2_1, U5_Z_0, U5_Z_1, U5_DATA2_0, U5_DATA2_1,
         U4_Z_0, U4_Z_1, U4_DATA2_0, U4_DATA2_1;

  IV I_2 ( .A(reset), .Z(n20) );
  OR2 C26 ( .A(n3), .B(in[1]), .Z(n2) );
  IV I_0 ( .A(in[0]), .Z(n3) );
  FD1 tmp1_reg_1_ ( .D(U7_Z_1), .CP(clk), .Q(U6_DATA2_1) );
  FD1 tmp2_reg_1_ ( .D(U6_Z_1), .CP(clk), .Q(U5_DATA2_1) );
  FD1 tmp3_reg_1_ ( .D(U5_Z_1), .CP(clk), .Q(U4_DATA2_1) );
  FD1 tmp4_reg_1_ ( .D(U4_Z_1), .CP(clk), .Q(out[1]) );
  FD1 tmp1_reg_0_ ( .D(U7_Z_0), .CP(clk), .Q(U6_DATA2_0) );
  FD1 tmp2_reg_0_ ( .D(U6_Z_0), .CP(clk), .Q(U5_DATA2_0) );
  FD1 tmp3_reg_0_ ( .D(U5_Z_0), .CP(clk), .Q(U4_DATA2_0) );
  FD1 tmp4_reg_0_ ( .D(U4_Z_0), .CP(clk), .Q(out[0]) );
  AN2 U3 ( .A(n20), .B(U8_Z_1), .Z(U7_Z_1) );
  AN2 U4 ( .A(n2), .B(in[1]), .Z(U8_Z_1) );
  AN2 U5 ( .A(U8_Z_0), .B(n20), .Z(U7_Z_0) );
  AN2 U6 ( .A(n2), .B(in[0]), .Z(U8_Z_0) );
  AN2 U13 ( .A(n20), .B(U6_DATA2_1), .Z(U6_Z_1) );
  AN2 U14 ( .A(U6_DATA2_0), .B(n20), .Z(U6_Z_0) );
  AN2 U15 ( .A(U5_DATA2_1), .B(n20), .Z(U5_Z_1) );
  AN2 U16 ( .A(U5_DATA2_0), .B(n20), .Z(U5_Z_0) );
  AN2 U17 ( .A(U4_DATA2_1), .B(n20), .Z(U4_Z_1) );
  AN2 U18 ( .A(U4_DATA2_0), .B(n20), .Z(U4_Z_0) );
endmodule

