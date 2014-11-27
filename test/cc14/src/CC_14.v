// Benchmark "Convolutional_Code_14" written by ABC on Fri Nov 21 16:04:15 2014

module Convolutional_Code_14 ( clock, 
    in,
    out1, out2  );
  input  clock;
  input  in;
  output out1, out2;
  reg Convolutional_Code_14_r0 , Convolutional_Code_14_r1 ,
    Convolutional_Code_14_r2 , Convolutional_Code_14_r3 ,
    Convolutional_Code_14_r4 , Convolutional_Code_14_r5 ,
    Convolutional_Code_14_r6 , Convolutional_Code_14_r7 ,
    Convolutional_Code_14_r8 , Convolutional_Code_14_r9 ,
    Convolutional_Code_14_r10 , Convolutional_Code_14_r11 ,
    Convolutional_Code_14_r12 , Convolutional_Code_14_r13 ;
  wire n46_1, n47, n48_1, n50, n51_1, n52_1, n21, n24, n27, n30, n33, n36,
    n39, n42, n45, n48, n51, n54, n57, n60;
  assign n46_1 = Convolutional_Code_14_r1  ? (~Convolutional_Code_14_r4  ^ Convolutional_Code_14_r5 ) : (Convolutional_Code_14_r4  ^ Convolutional_Code_14_r5 );
  assign n47 = Convolutional_Code_14_r6  ? (~Convolutional_Code_14_r8  ^ Convolutional_Code_14_r9 ) : (Convolutional_Code_14_r8  ^ Convolutional_Code_14_r9 );
  assign n48_1 = Convolutional_Code_14_r10  ? (~Convolutional_Code_14_r11  ^ Convolutional_Code_14_r13 ) : (Convolutional_Code_14_r11  ^ Convolutional_Code_14_r13 );
  assign out1 = n46_1 ? (~n47 ^ n48_1) : (n47 ^ n48_1);
  assign n50 = Convolutional_Code_14_r12  ^ Convolutional_Code_14_r13 ;
  assign n51_1 = Convolutional_Code_14_r0  ? (~Convolutional_Code_14_r2  ^ Convolutional_Code_14_r3 ) : (Convolutional_Code_14_r2  ^ Convolutional_Code_14_r3 );
  assign n52_1 = Convolutional_Code_14_r4  ? (~Convolutional_Code_14_r7  ^ Convolutional_Code_14_r9 ) : (Convolutional_Code_14_r7  ^ Convolutional_Code_14_r9 );
  assign out2 = n51_1 ? (~n52_1 ^ n50) : (n52_1 ^ n50);
  assign n21 = in;
  assign n24 = Convolutional_Code_14_r0 ;
  assign n27 = Convolutional_Code_14_r1 ;
  assign n30 = Convolutional_Code_14_r2 ;
  assign n33 = Convolutional_Code_14_r3 ;
  assign n36 = Convolutional_Code_14_r4 ;
  assign n39 = Convolutional_Code_14_r5 ;
  assign n42 = Convolutional_Code_14_r6 ;
  assign n45 = Convolutional_Code_14_r7 ;
  assign n48 = Convolutional_Code_14_r8 ;
  assign n51 = Convolutional_Code_14_r9 ;
  assign n54 = Convolutional_Code_14_r10 ;
  assign n57 = Convolutional_Code_14_r11 ;
  assign n60 = Convolutional_Code_14_r12 ;
  always @ (posedge clock) begin
    Convolutional_Code_14_r0  <= n21;
    Convolutional_Code_14_r1  <= n24;
    Convolutional_Code_14_r2  <= n27;
    Convolutional_Code_14_r3  <= n30;
    Convolutional_Code_14_r4  <= n33;
    Convolutional_Code_14_r5  <= n36;
    Convolutional_Code_14_r6  <= n39;
    Convolutional_Code_14_r7  <= n42;
    Convolutional_Code_14_r8  <= n45;
    Convolutional_Code_14_r9  <= n48;
    Convolutional_Code_14_r10  <= n51;
    Convolutional_Code_14_r11  <= n54;
    Convolutional_Code_14_r12  <= n57;
    Convolutional_Code_14_r13  <= n60;
  end
  initial begin
    Convolutional_Code_14_r0  <= 1'b0;
    Convolutional_Code_14_r1  <= 1'b0;
    Convolutional_Code_14_r2  <= 1'b0;
    Convolutional_Code_14_r3  <= 1'b0;
    Convolutional_Code_14_r4  <= 1'b0;
    Convolutional_Code_14_r5  <= 1'b0;
    Convolutional_Code_14_r6  <= 1'b0;
    Convolutional_Code_14_r7  <= 1'b0;
    Convolutional_Code_14_r8  <= 1'b0;
    Convolutional_Code_14_r9  <= 1'b0;
    Convolutional_Code_14_r10  <= 1'b0;
    Convolutional_Code_14_r11  <= 1'b0;
    Convolutional_Code_14_r12  <= 1'b0;
    Convolutional_Code_14_r13  <= 1'b0;
  end
endmodule


