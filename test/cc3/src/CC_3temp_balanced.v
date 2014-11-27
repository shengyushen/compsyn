// Benchmark "Convolutional_Code_3" written by ABC on Mon Nov 24 11:19:34 2014

module Convolutional_Code_3 ( clock, 
    in, noise0, noise1,
    out1, out2, decosy  );
  input  clock;
  input  in, noise0, noise1;
  output out1, out2, decosy;
  reg Convolutional_Code_3_r0 , Convolutional_Code_3_r1 ,
    Convolutional_Code_3_r2 , \Convolutional_Code_3|noise(3)|x0 ,
    \Convolutional_Code_3|noise(3)|x1 , \Convolutional_Code_3|noise(3)|x2 ;
  wire n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36, n37, n38,
    n39, n40, n41, n42, n44, n46, n47, n48, n14, n19, n24, n29_1, n34_1,
    n39_1;
  assign n25 = ~\Convolutional_Code_3|noise(3)|x0  & ~\Convolutional_Code_3|noise(3)|x1 ;
  assign n26 = \Convolutional_Code_3|noise(3)|x2  & n25;
  assign n27 = ~noise1 & n26;
  assign n28 = ~noise0 & n27;
  assign n29 = Convolutional_Code_3_r0  & ~Convolutional_Code_3_r2 ;
  assign n30 = ~Convolutional_Code_3_r0  & Convolutional_Code_3_r2 ;
  assign n31 = ~n29 & ~n30;
  assign n32 = ~n28 & ~n31;
  assign n33 = n28 & n31;
  assign n34 = ~n32 & ~n33;
  assign n35 = noise0 & n27;
  assign n36 = Convolutional_Code_3_r1  & ~n31;
  assign n37 = ~Convolutional_Code_3_r1  & n31;
  assign n38 = ~n36 & ~n37;
  assign n39 = n35 & ~n38;
  assign n40 = ~n35 & n38;
  assign n41 = ~n39 & ~n40;
  assign n42 = \Convolutional_Code_3|noise(3)|x2  & ~n25;
  assign n29_1 = ~\Convolutional_Code_3|noise(3)|x0  & ~n26;
  assign n44 = \Convolutional_Code_3|noise(3)|x0  & \Convolutional_Code_3|noise(3)|x1 ;
  assign n34_1 = ~n25 & ~n44;
  assign n46 = \Convolutional_Code_3|noise(3)|x2  & n44;
  assign n47 = ~\Convolutional_Code_3|noise(3)|x2  & ~n44;
  assign n48 = ~n46 & ~n47;
  assign n39_1 = ~n27 & n48;
  assign out1 = ~n34;
  assign out2 = ~n41;
  assign decosy = ~n42;
  assign n14 = in;
  assign n19 = Convolutional_Code_3_r0 ;
  assign n24 = Convolutional_Code_3_r1 ;
  always @ (posedge clock) begin
    Convolutional_Code_3_r0  <= n14;
    Convolutional_Code_3_r1  <= n19;
    Convolutional_Code_3_r2  <= n24;
    \Convolutional_Code_3|noise(3)|x0  <= n29_1;
    \Convolutional_Code_3|noise(3)|x1  <= n34_1;
    \Convolutional_Code_3|noise(3)|x2  <= n39_1;
  end
endmodule


