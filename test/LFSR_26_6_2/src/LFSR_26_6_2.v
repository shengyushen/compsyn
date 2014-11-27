// Benchmark "LFSR_26_6_2" written by ABC on Fri Nov 21 18:25:36 2014

module LFSR_26_6_2 ( clock, 
    in,
    out  );
  input  clock;
  input  in;
  output out;
  reg reg_1 , reg_2 , reg_3 , reg_4 , reg_5 , reg_6 , reg_7 ,
    reg_8 , reg_9 , reg_10 , reg_11 , reg_12 , reg_13 ,
    reg_14 , reg_15 , reg_16 , reg_17 , reg_18 , reg_19 ,
    reg_20 , reg_21 , reg_22 , reg_23 , reg_24 , reg_25 ,
    reg_26 ;
  wire n81, n82, n84, n85, n86, n87, n88, n89, n90, n91_1, n6, n11, n16, n21,
    n26, n31, n36, n41, n46, n51, n56, n61, n66, n71, n76, n81_1, n86_1,
    n91, n96, n101, n106, n111, n116, n121, n126, n131;
  assign n81 = ~in & ~reg_1 ;
  assign n82 = in & reg_1 ;
  assign out = n81 | n82;
  assign n84 = reg_6  & ~reg_26 ;
  assign n85 = ~reg_6  & reg_26 ;
  assign n86 = ~n84 & ~n85;
  assign n87 = reg_2  & n86;
  assign n88 = ~reg_2  & ~n86;
  assign n89 = ~n87 & ~n88;
  assign n90 = ~reg_1  & n89;
  assign n91_1 = reg_1  & ~n89;
  assign n131 = n90 | n91_1;
  assign n6 = ~reg_2 ;
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
  assign n81_1 = reg_17 ;
  assign n86_1 = reg_18 ;
  assign n91 = reg_19 ;
  assign n96 = reg_20 ;
  assign n101 = reg_21 ;
  assign n106 = reg_22 ;
  assign n111 = reg_23 ;
  assign n116 = reg_24 ;
  assign n121 = reg_25 ;
  assign n126 = reg_26 ;
  always @ (posedge clock) begin
    reg_1  <= n6;
    reg_2  <= n11;
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
    reg_16  <= n81_1;
    reg_17  <= n86_1;
    reg_18  <= n91;
    reg_19  <= n96;
    reg_20  <= n101;
    reg_21  <= n106;
    reg_22  <= n111;
    reg_23  <= n116;
    reg_24  <= n121;
    reg_25  <= n126;
    reg_26  <= n131;
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
  end
endmodule


