// Benchmark "Convolutional_Code_4" written by ABC on Mon Nov 24 10:08:58 2014

module Convolutional_Code_4 ( clock, 
    in, noise0, noise1,
    out1, out2, decosy  );
  input  clock;
  input  in, noise0, noise1;
  output out1, out2, decosy;
  reg Convolutional_Code_4_r0 , Convolutional_Code_4_r1 ,
    Convolutional_Code_4_r2 , Convolutional_Code_4_r3 ,
    \Convolutional_Code_4|noise(3)|x0 , \Convolutional_Code_4|noise(3)|x1 ,
    \Convolutional_Code_4|noise(3)|x2 ;
  wire n28, n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41,
    n42, n43, n44, n45, n46, n47, n48, n50, n52, n53, n54, n14, n19, n24_1,
    n29_1, n34_1, n39_1, n44_1;
  assign n28 = ~Convolutional_Code_4_r1  & Convolutional_Code_4_r3 ;
  assign n29 = Convolutional_Code_4_r1  & ~Convolutional_Code_4_r3 ;
  assign n30 = ~n28 & ~n29;
  assign n31 = Convolutional_Code_4_r0  & ~n30;
  assign n32 = ~Convolutional_Code_4_r0  & n30;
  assign n33 = ~n31 & ~n32;
  assign n34 = ~\Convolutional_Code_4|noise(3)|x0  & ~\Convolutional_Code_4|noise(3)|x1 ;
  assign n35 = \Convolutional_Code_4|noise(3)|x2  & n34;
  assign n36 = ~noise1 & n35;
  assign n37 = ~noise0 & n36;
  assign n38 = n33 & ~n37;
  assign n39 = ~n33 & n37;
  assign n40 = ~n38 & ~n39;
  assign n41 = noise0 & n36;
  assign n42 = ~Convolutional_Code_4_r2  & n33;
  assign n43 = Convolutional_Code_4_r2  & ~n33;
  assign n44 = ~n42 & ~n43;
  assign n45 = n41 & n44;
  assign n46 = ~n41 & ~n44;
  assign n47 = ~n45 & ~n46;
  assign n48 = \Convolutional_Code_4|noise(3)|x2  & ~n34;
  assign n34_1 = ~\Convolutional_Code_4|noise(3)|x0  & ~n35;
  assign n50 = \Convolutional_Code_4|noise(3)|x0  & \Convolutional_Code_4|noise(3)|x1 ;
  assign n39_1 = ~n34 & ~n50;
  assign n52 = \Convolutional_Code_4|noise(3)|x2  & n50;
  assign n53 = ~\Convolutional_Code_4|noise(3)|x2  & ~n50;
  assign n54 = ~n52 & ~n53;
  assign n44_1 = ~n36 & n54;
  assign out1 = ~n40;
  assign out2 = ~n47;
  assign decosy = ~n48;
  assign n14 = in;
  assign n19 = Convolutional_Code_4_r0 ;
  assign n24_1 = Convolutional_Code_4_r1 ;
  assign n29_1 = Convolutional_Code_4_r2 ;
  always @ (posedge clock) begin
    Convolutional_Code_4_r0  <= n14;
    Convolutional_Code_4_r1  <= n19;
    Convolutional_Code_4_r2  <= n24_1;
    Convolutional_Code_4_r3  <= n29_1;
    \Convolutional_Code_4|noise(3)|x0  <= n34_1;
    \Convolutional_Code_4|noise(3)|x1  <= n39_1;
    \Convolutional_Code_4|noise(3)|x2  <= n44_1;
  end
  initial begin
    Convolutional_Code_4_r0  <= 1'b0;
    Convolutional_Code_4_r1  <= 1'b0;
    Convolutional_Code_4_r2  <= 1'b0;
    Convolutional_Code_4_r3  <= 1'b0;
  end
endmodule


