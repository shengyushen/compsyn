// Benchmark "Convolutional_Code_4" written by ABC on Mon Nov 24 10:11:32 2014

module Convolutional_Code_4 ( clock, 
    in,
    out1, out2  );
  input  clock;
  input  in;
  output out1, out2;
  reg Convolutional_Code_4_r0 , Convolutional_Code_4_r1 ,
    Convolutional_Code_4_r2 , Convolutional_Code_4_r3 ,
    \Convolutional_Code_4|noise(3)|r0 , \Convolutional_Code_4|noise(3)|r1 ,
    \Convolutional_Code_4|noise(3)|x0 , \Convolutional_Code_4|noise(3)|x1 ,
    \Convolutional_Code_4|noise(3)|x2 ;
  wire n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n44, n45,
    n46, n47, n48, n49, n50, n51, n8, n13, n18_1, n23, n28, n33_1, n38_1,
    n43, n48_2;
  assign n31 = 1'b1;
  assign n32 = ~Convolutional_Code_4_r1  & Convolutional_Code_4_r3 ;
  assign n33 = Convolutional_Code_4_r1  & ~Convolutional_Code_4_r3 ;
  assign n34 = ~n32 & ~n33;
  assign n35 = Convolutional_Code_4_r0  & ~n34;
  assign n36 = ~Convolutional_Code_4_r0  & n34;
  assign n37 = ~n35 & ~n36;
  assign n38 = ~\Convolutional_Code_4|noise(3)|x1  & ~\Convolutional_Code_4|noise(3)|x2 ;
  assign n39 = ~\Convolutional_Code_4|noise(3)|r0  & ~\Convolutional_Code_4|noise(3)|r1 ;
  assign n40 = ~n38 & n39;
  assign n41 = ~n37 & ~n40;
  assign n42 = n37 & n40;
  assign out1 = ~n41 & ~n42;
  assign n44 = \Convolutional_Code_4|noise(3)|r0  & ~\Convolutional_Code_4|noise(3)|r1 ;
  assign n45 = ~n38 & n44;
  assign n46 = ~Convolutional_Code_4_r2  & n45;
  assign n47 = Convolutional_Code_4_r2  & ~n45;
  assign n48 = ~n46 & ~n47;
  assign n49 = n37 & n48;
  assign n50 = ~n37 & ~n48;
  assign n51 = ~n49 & ~n50;
  assign n38_1 = ~\Convolutional_Code_4|noise(3)|x0  & n38;
  assign n43 = \Convolutional_Code_4|noise(3)|x0  & n38;
  assign out2 = ~n51;
  assign n8 = in;
  assign n13 = Convolutional_Code_4_r0 ;
  assign n18_1 = Convolutional_Code_4_r1 ;
  assign n23 = Convolutional_Code_4_r2 ;
  assign n28 = \Convolutional_Code_4|noise(3)|r0 ;
  assign n33_1 = \Convolutional_Code_4|noise(3)|r1 ;
  assign n48_2 = ~n31;
  always @ (posedge clock) begin
    Convolutional_Code_4_r0  <= n8;
    Convolutional_Code_4_r1  <= n13;
    Convolutional_Code_4_r2  <= n18_1;
    Convolutional_Code_4_r3  <= n23;
    \Convolutional_Code_4|noise(3)|r0  <= n28;
    \Convolutional_Code_4|noise(3)|r1  <= n33_1;
    \Convolutional_Code_4|noise(3)|x0  <= n38_1;
    \Convolutional_Code_4|noise(3)|x1  <= n43;
    \Convolutional_Code_4|noise(3)|x2  <= n48_2;
  end
  initial begin
    Convolutional_Code_4_r0  <= 1'b0;
    Convolutional_Code_4_r1  <= 1'b0;
    Convolutional_Code_4_r2  <= 1'b0;
    Convolutional_Code_4_r3  <= 1'b0;
  end
endmodule


