// Benchmark "LFSR_32_7_6" written by ABC on Fri Nov 21 18:29:22 2014

module LFSR_32_7_6 ( clock, 
    in,
    out  );
  input  clock;
  input  in;
  output out;
  reg reg_1 , n8_inv, reg_3 , reg_4 , reg_5 , reg_6 , reg_7 ,
    reg_8 , reg_9 , reg_10 , reg_11 , reg_12 , reg_13 ,
    reg_14 , reg_15 , reg_16 , reg_17 , reg_18 , reg_19 ,
    reg_20 , reg_21 , reg_22 , reg_23 , reg_24 , reg_25 ,
    reg_26 , reg_27 , reg_28 , reg_29 , reg_30 , reg_31 ,
    reg_32 ;
  wire n99, n100, n102, n103, n104, n105, n106, n107, n108, n109, n6, n11,
    n16, n21, n26, n31, n36, n41, n46, n51, n56, n61, n66, n71, n76, n81,
    n86, n91, n96, n101_1, n106_1, n111, n116, n121, n126, n131, n136,
    n141, n146, n151, n156, n161;
  assign n99 = ~in & reg_1 ;
  assign n100 = in & ~reg_1 ;
  assign out = n99 | n100;
  assign n102 = reg_7  & reg_32 ;
  assign n103 = ~reg_7  & ~reg_32 ;
  assign n104 = ~n102 & ~n103;
  assign n105 = reg_6  & n104;
  assign n106 = ~reg_6  & ~n104;
  assign n107 = ~n105 & ~n106;
  assign n108 = n8_inv & n107;
  assign n109 = ~n8_inv & ~n107;
  assign n161 = ~n108 & ~n109;
  assign n156 = ~reg_32 ;
  assign n6 = n8_inv;
  assign n11 = reg_3 ;
  assign n16 = reg_4 ;
  assign n21 = reg_5 ;
  assign n26 = reg_6 ;
  assign n31 = reg_7 ;
  assign n36 = reg_8 ;
  assign n41 = reg_9 ;
  assign n46 = reg_10 ;
  assign n51 = reg_11 ;
  assign n56 = reg_12 ;
  assign n61 = reg_13 ;
  assign n66 = reg_14 ;
  assign n71 = reg_15 ;
  assign n76 = reg_16 ;
  assign n81 = reg_17 ;
  assign n86 = reg_18 ;
  assign n91 = reg_19 ;
  assign n96 = reg_20 ;
  assign n101_1 = reg_21 ;
  assign n106_1 = reg_22 ;
  assign n111 = reg_23 ;
  assign n116 = reg_24 ;
  assign n121 = reg_25 ;
  assign n126 = reg_26 ;
  assign n131 = reg_27 ;
  assign n136 = reg_28 ;
  assign n141 = reg_29 ;
  assign n146 = reg_30 ;
  assign n151 = reg_31 ;
  always @ (posedge clock) begin
    reg_1  <= n6;
    n8_inv <= n11;
    reg_3  <= n16;
    reg_4  <= n21;
    reg_5  <= n26;
    reg_6  <= n31;
    reg_7  <= n36;
    reg_8  <= n41;
    reg_9  <= n46;
    reg_10  <= n51;
    reg_11  <= n56;
    reg_12  <= n61;
    reg_13  <= n66;
    reg_14  <= n71;
    reg_15  <= n76;
    reg_16  <= n81;
    reg_17  <= n86;
    reg_18  <= n91;
    reg_19  <= n96;
    reg_20  <= n101_1;
    reg_21  <= n106_1;
    reg_22  <= n111;
    reg_23  <= n116;
    reg_24  <= n121;
    reg_25  <= n126;
    reg_26  <= n131;
    reg_27  <= n136;
    reg_28  <= n141;
    reg_29  <= n146;
    reg_30  <= n151;
    reg_31  <= n156;
    reg_32  <= n161;
  end
  initial begin
    reg_1  <= 1'b0;
    n8_inv <= 1'b0;
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
    reg_13  <= 1'b0;
    reg_14  <= 1'b0;
    reg_15  <= 1'b0;
    reg_16  <= 1'b0;
    reg_17  <= 1'b0;
    reg_18  <= 1'b0;
    reg_19  <= 1'b0;
    reg_20  <= 1'b0;
    reg_21  <= 1'b0;
    reg_22  <= 1'b0;
    reg_23  <= 1'b0;
    reg_24  <= 1'b0;
    reg_25  <= 1'b0;
    reg_26  <= 1'b0;
    reg_27  <= 1'b0;
    reg_28  <= 1'b0;
    reg_29  <= 1'b0;
    reg_30  <= 1'b0;
    reg_31  <= 1'b0;
    reg_32  <= 1'b0;
  end
endmodule


