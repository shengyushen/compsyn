// Benchmark "Convolutional_Code_13" written by ABC on Thu Nov 20 20:42:02 2014

module Convolutional_Code_13 ( clock, 
    in,
    out1, out2  );
  input  clock;
  input  in;
  output out1, out2;
  reg Convolutional_Code_13_r_0 , Convolutional_Code_13_r_1 ,
    Convolutional_Code_13_r_2 , Convolutional_Code_13_r_3 ,
    Convolutional_Code_13_r_4 , Convolutional_Code_13_r_5 ,
    Convolutional_Code_13_r_6 , Convolutional_Code_13_r_7 ,
    Convolutional_Code_13_r_8 , Convolutional_Code_13_r_9 ,
    Convolutional_Code_13_r_10 , Convolutional_Code_13_r_11 ,
    Convolutional_Code_13_r_12 ;
  wire n43, n44_1, n46, n47_1, n48_1, n20, n23, n26, n29, n32, n35, n38, n41,
    n44, n47, n50, n53, n56;
  assign n43 = Convolutional_Code_13_r_0  ? (~Convolutional_Code_13_r_4  ^ Convolutional_Code_13_r_6 ) : (Convolutional_Code_13_r_4  ^ Convolutional_Code_13_r_6 );
  assign n44_1 = Convolutional_Code_13_r_8  ? (~Convolutional_Code_13_r_9  ^ Convolutional_Code_13_r_11 ) : (Convolutional_Code_13_r_9  ^ Convolutional_Code_13_r_11 );
  assign out1 = n43 ? (~n44_1 ^ Convolutional_Code_13_r_12 ) : (n44_1 ^ Convolutional_Code_13_r_12 );
  assign n46 = Convolutional_Code_13_r_0  ? (~Convolutional_Code_13_r_1  ^ Convolutional_Code_13_r_2 ) : (Convolutional_Code_13_r_1  ^ Convolutional_Code_13_r_2 );
  assign n47_1 = Convolutional_Code_13_r_3  ? (~Convolutional_Code_13_r_4  ^ Convolutional_Code_13_r_5 ) : (Convolutional_Code_13_r_4  ^ Convolutional_Code_13_r_5 );
  assign n48_1 = Convolutional_Code_13_r_7  ? (~Convolutional_Code_13_r_8  ^ Convolutional_Code_13_r_12 ) : (Convolutional_Code_13_r_8  ^ Convolutional_Code_13_r_12 );
  assign out2 = n46 ? (~n47_1 ^ n48_1) : (n47_1 ^ n48_1);
  assign n20 = in;
  assign n23 = Convolutional_Code_13_r_0 ;
  assign n26 = Convolutional_Code_13_r_1 ;
  assign n29 = Convolutional_Code_13_r_2 ;
  assign n32 = Convolutional_Code_13_r_3 ;
  assign n35 = Convolutional_Code_13_r_4 ;
  assign n38 = Convolutional_Code_13_r_5 ;
  assign n41 = Convolutional_Code_13_r_6 ;
  assign n44 = Convolutional_Code_13_r_7 ;
  assign n47 = Convolutional_Code_13_r_8 ;
  assign n50 = Convolutional_Code_13_r_9 ;
  assign n53 = Convolutional_Code_13_r_10 ;
  assign n56 = Convolutional_Code_13_r_11 ;
  always @ (posedge clock) begin
    Convolutional_Code_13_r_0  <= n20;
    Convolutional_Code_13_r_1  <= n23;
    Convolutional_Code_13_r_2  <= n26;
    Convolutional_Code_13_r_3  <= n29;
    Convolutional_Code_13_r_4  <= n32;
    Convolutional_Code_13_r_5  <= n35;
    Convolutional_Code_13_r_6  <= n38;
    Convolutional_Code_13_r_7  <= n41;
    Convolutional_Code_13_r_8  <= n44;
    Convolutional_Code_13_r_9  <= n47;
    Convolutional_Code_13_r_10  <= n50;
    Convolutional_Code_13_r_11  <= n53;
    Convolutional_Code_13_r_12  <= n56;
  end
  initial begin
    Convolutional_Code_13_r_0  <= 1'b0;
    Convolutional_Code_13_r_1  <= 1'b0;
    Convolutional_Code_13_r_2  <= 1'b0;
    Convolutional_Code_13_r_3  <= 1'b0;
    Convolutional_Code_13_r_4  <= 1'b0;
    Convolutional_Code_13_r_5  <= 1'b0;
    Convolutional_Code_13_r_6  <= 1'b0;
    Convolutional_Code_13_r_7  <= 1'b0;
    Convolutional_Code_13_r_8  <= 1'b0;
    Convolutional_Code_13_r_9  <= 1'b0;
    Convolutional_Code_13_r_10  <= 1'b0;
    Convolutional_Code_13_r_11  <= 1'b0;
    Convolutional_Code_13_r_12  <= 1'b0;
  end
endmodule


