// Benchmark "LFSR_12_6_4" written by ABC on Fri Nov 21 18:23:08 2014

module LFSR_12_6_4 ( clock, 
    in,
    out  );
  input  clock;
  input  in;
  output out;
  reg reg_1 , reg_2 , reg_3 , reg_4 , reg_5 , reg_6 , reg_7 ,
    reg_8 , reg_9 , reg_10 , reg_11 , reg_12 ;
  wire n39, n40, n42, n43, n44, n45, n46, n47, n48, n49, n6, n11, n16, n21,
    n26, n31, n36, n41_1, n46_1, n51, n56, n61;
  assign n39 = ~in & ~reg_1 ;
  assign n40 = in & reg_1 ;
  assign out = n39 | n40;
  assign n42 = reg_6  & ~reg_12 ;
  assign n43 = ~reg_6  & reg_12 ;
  assign n44 = ~n42 & ~n43;
  assign n45 = reg_4  & n44;
  assign n46 = ~reg_4  & ~n44;
  assign n47 = ~n45 & ~n46;
  assign n48 = ~reg_1  & n47;
  assign n49 = reg_1  & ~n47;
  assign n61 = n48 | n49;
  assign n6 = ~reg_2 ;
  assign n11 = reg_3 ;
  assign n16 = reg_4 ;
  assign n21 = reg_5 ;
  assign n26 = reg_6 ;
  assign n31 = reg_7 ;
  assign n36 = reg_8 ;
  assign n41_1 = reg_9 ;
  assign n46_1 = reg_10 ;
  assign n51 = reg_11 ;
  assign n56 = reg_12 ;
  always @ (posedge clock) begin
    reg_1  <= n6;
    reg_2  <= n11;
    reg_3  <= n16;
    reg_4  <= n21;
    reg_5  <= n26;
    reg_6  <= n31;
    reg_7  <= n36;
    reg_8  <= n41_1;
    reg_9  <= n46_1;
    reg_10  <= n51;
    reg_11  <= n56;
    reg_12  <= n61;
  end
  initial begin
    reg_1  <= 1'b0;
    reg_2  <= 1'b0;
    reg_3  <= 1'b0;
    reg_4  <= 1'b0;
    reg_5  <= 1'b0;
    reg_6  <= 1'b0;
    reg_7  <= 1'b0;
    reg_8  <= 1'b0;
    reg_9  <= 1'b0;
    reg_10  <= 1'b0;
    reg_11  <= 1'b0;
    reg_12  <= 1'b0;
  end
endmodule


