// Benchmark "Convolutional_Code_3" written by ABC on Mon Nov 24 10:05:05 2014

module Convolutional_Code_3 ( clock, 
    in,
    out1, out2  );
  input  clock;
  input  in;
  output out1, out2;
  reg Convolutional_Code_3_r0 , Convolutional_Code_3_r1 ,
    Convolutional_Code_3_r2 , \Convolutional_Code_3|noise(3)|r0 ,
    \Convolutional_Code_3|noise(3)|r1 , \Convolutional_Code_3|noise(3)|x0 ,
    \Convolutional_Code_3|noise(3)|x1 , \Convolutional_Code_3|noise(3)|x2 ;
  wire n28, n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41,
    n44, n45, n46, n8, n13, n18, n23, n28_1, n33_1, n38_2, n43_1;
  assign n28 = ~\Convolutional_Code_3|noise(3)|r1  & \Convolutional_Code_3|noise(3)|x2 ;
  assign n29 = ~\Convolutional_Code_3|noise(3)|r0  & n28;
  assign n30 = Convolutional_Code_3_r0  & ~Convolutional_Code_3_r2 ;
  assign n31 = ~Convolutional_Code_3_r0  & Convolutional_Code_3_r2 ;
  assign n32 = ~n30 & ~n31;
  assign n33 = ~n29 & ~n32;
  assign n34 = n29 & n32;
  assign n35 = ~n33 & ~n34;
  assign n36 = \Convolutional_Code_3|noise(3)|r0  & n28;
  assign n37 = Convolutional_Code_3_r1  & ~n32;
  assign n38 = ~Convolutional_Code_3_r1  & n32;
  assign n39 = ~n37 & ~n38;
  assign n40 = n36 & n39;
  assign n41 = ~n36 & ~n39;
  assign out2 = ~n40 & ~n41;
  assign n33_1 = ~\Convolutional_Code_3|noise(3)|x0  & ~\Convolutional_Code_3|noise(3)|x2 ;
  assign n44 = \Convolutional_Code_3|noise(3)|x0  & \Convolutional_Code_3|noise(3)|x1 ;
  assign n45 = ~\Convolutional_Code_3|noise(3)|x0  & ~\Convolutional_Code_3|noise(3)|x1 ;
  assign n46 = ~\Convolutional_Code_3|noise(3)|x2  & ~n45;
  assign n38_2 = ~n44 & n46;
  assign n43_1 = ~\Convolutional_Code_3|noise(3)|x2  & n44;
  assign out1 = ~n35;
  assign n8 = in;
  assign n13 = Convolutional_Code_3_r0 ;
  assign n18 = Convolutional_Code_3_r1 ;
  assign n23 = \Convolutional_Code_3|noise(3)|r0 ;
  assign n28_1 = \Convolutional_Code_3|noise(3)|r1 ;
  always @ (posedge clock) begin
    Convolutional_Code_3_r0  <= n8;
    Convolutional_Code_3_r1  <= n13;
    Convolutional_Code_3_r2  <= n18;
    \Convolutional_Code_3|noise(3)|r0  <= n23;
    \Convolutional_Code_3|noise(3)|r1  <= n28_1;
    \Convolutional_Code_3|noise(3)|x0  <= n33_1;
    \Convolutional_Code_3|noise(3)|x1  <= n38_2;
    \Convolutional_Code_3|noise(3)|x2  <= n43_1;
  end
endmodule


