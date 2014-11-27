// Benchmark "Huffman_alphabet_5" written by ABC on Fri Nov 21 17:26:14 2014

module Huffman_alphabet_5 ( clock, 
    in_0 , in_1 , in_2 , in_3 , in_4 ,
    carestate, out  );
  input  clock;
  input  in_0 , in_1 , in_2 , in_3 , in_4 ;
  output carestate, out;
  reg reg_0 , reg_1 , reg_2 , reg_3 , reg_4 , counter_0 ,
    counter_1 , counter_2 , counter_3 ;
  wire n35, n41_1, n42, n43, n44, n45, n46_1, n47, n48, n49, n50, n51_1, n52,
    n57, n58, n59, n60, n61, n62, n63, n65, n66, n16, n21, n26, n31, n36,
    n41, n46, n51, n56;
  assign n35 = ~counter_0  & ~counter_1  & ~counter_2  & ~counter_3 ;
  assign n16 = n35 ? in_0  : reg_0 ;
  assign n21 = n35 ? in_1  : reg_1 ;
  assign n26 = n35 ? in_2  : reg_2 ;
  assign n31 = n35 ? in_3  : reg_3 ;
  assign n36 = n35 ? in_4  : reg_4 ;
  assign n41_1 = in_4  & ((~in_0  & in_3  & (~in_1  ^ in_2 )) | (in_0  & ~in_1  & in_2  & ~in_3 ));
  assign n42 = ((in_1  ^ in_3 ) & (in_0  ? (~in_2  & in_4 ) : (in_2  | (~in_2  & ~in_4 )))) | (in_0  & ((~in_4  & (in_1  ^ in_2 )) | (in_1  & ~in_2  & in_3  & in_4 ))) | (~in_0  & ~in_1  & in_2  & ~in_3  & ~in_4 );
  assign n43 = ((in_2  ? (in_3  & ~in_4 ) : (~in_3  & in_4 )) & (~in_0  ^ ~in_1 )) | (~in_1  & (((in_2  ^ ~in_4 ) & (~in_0  ^ in_3 )) | (~in_0  & ~in_3  & (in_2  ^ in_4 )))) | (in_0  & in_1  & in_2  & ~in_3  & ~in_4 );
  assign n44 = in_4  ? (((~in_1  ^ in_3 ) & (in_0  ^ in_2 )) | (~in_0  & ~in_1  & ~in_2 )) : (((~in_2  ^ ~in_3 ) & (in_0  | (~in_0  & ~in_1 ))) | (~in_0  & (in_1  ? in_2  : (~in_2  & ~in_3 ))));
  assign n45 = 1'b0;
  assign n46_1 = counter_3  | n45;
  assign n47 = counter_2  | n46_1;
  assign n48 = counter_1  | n47;
  assign n49 = counter_0  ^ ~n48;
  assign n50 = counter_1  ^ ~n47;
  assign n51_1 = counter_2  ^ ~n46_1;
  assign n52 = counter_3  ^ ~n45;
  assign n41 = n35 ? n41_1 : n49;
  assign n46 = n35 ? n42 : n50;
  assign n51 = n35 ? n43 : n51_1;
  assign n56 = n35 ? n44 : n52;
  assign n57 = in_0  ^ ~reg_0 ;
  assign n58 = in_1  ^ ~reg_1 ;
  assign n59 = in_2  ^ ~reg_2 ;
  assign n60 = in_3  ^ ~reg_3 ;
  assign n61 = in_4  ^ ~reg_4 ;
  assign n62 = n61 & n60 & n59 & n57 & n58;
  assign n63 = (in_1  & ((in_3  & (~in_0  ^ in_2 )) | (~in_3  & in_4  & in_0  & in_2 ))) | (in_0  & ~in_1  & ~in_2  & ~in_3  & ~in_4 );
  assign carestate = n35 ? ~n63 : n62;
  assign n65 = (~in_1  & (in_2  ? (~in_3  & ~in_4 ) : (in_3  & in_4 ))) | (in_1  & (~in_2  | (in_2  & in_3  & in_4 ))) | (in_0  & ((in_2  & ((~in_3  & in_4 ) | (in_3  & ~in_4 ) | (~in_1  & in_3  & in_4 ))) | (~in_1  & ~in_2  & ~in_4 )));
  assign n66 = reg_0  ? ((~counter_0  & ((~reg_1  & ((~counter_1  & counter_2  & ~reg_2  & reg_3 ) | (counter_1  & ~counter_2  & reg_2  & ~reg_3 ))) | (reg_1  & ~reg_2  & ((~counter_1  & counter_2  & counter_3 ) | (counter_1  & ~counter_2  & ~counter_3  & reg_3 ))) | (~counter_1  & ((counter_2  & ~reg_1  & reg_2  & ~reg_4 ) | (~counter_2  & counter_3  & reg_1  & ~reg_2  & reg_4 ) | (~reg_1  & ((~reg_2  & ~reg_3  & reg_4  & (counter_2  | (~counter_2  & counter_3 ))) | (~counter_2  & counter_3  & reg_2  & reg_3  & ~reg_4 ))) | (counter_2  & ~counter_3  & reg_1  & reg_2  & ~reg_3  & ~reg_4 ))) | (counter_1  & ~reg_1  & ((reg_2  & ((counter_2  & ~reg_3  & reg_4 ) | (~counter_2  & reg_3  & ~reg_4 ) | (counter_2  & ~counter_3  & reg_3  & ~reg_4 ))) | (~counter_2  & ~counter_3  & ~reg_2  & reg_3  & reg_4 ))))) | (counter_0  & ~counter_1  & ~counter_2  & ~counter_3  & ~reg_3  & reg_4  & ~reg_1  & reg_2 )) : (((~reg_1  ^ reg_2 ) & ((reg_3  & ((reg_4  & ((~counter_0  & counter_1  & counter_2 ) | (counter_0  & ~counter_1  & ~counter_2 ) | (~counter_0  & (counter_1  ? (~counter_2  & counter_3 ) : (counter_2  & ~counter_3 ))))) | (~counter_0  & ~counter_1  & counter_2  & counter_3  & ~reg_4 ))) | (~counter_0  & ~counter_1  & ~counter_2  & counter_3  & ~reg_3  & reg_4 ))) | (~counter_0  & (reg_1  ? (~reg_3  & ((~counter_1  & ((counter_2  & (~counter_3  ^ ~reg_4 )) | (~counter_2  & counter_3  & ~reg_4 ) | (counter_2  & (counter_3  ? (reg_2  & reg_4 ) : (~reg_2  & ~reg_4 ))))) | (counter_1  & ~counter_2  & ~counter_3  & reg_2  & ~reg_4 ))) : (((counter_1  ? (~counter_3  & ~reg_4 ) : (counter_3  & reg_4 )) & (counter_2  ? (reg_2  & ~reg_3 ) : (reg_2  | (~reg_2  & reg_3 )))) | (reg_2  & ((reg_3  & ((~counter_1  & counter_2  & counter_3 ) | (counter_1  & ~counter_2  & ~counter_3  & reg_4 ))) | (counter_3  & ~reg_3  & ~reg_4 )))))));
  assign out = n35 ? n65 : n66;
  always @ (posedge clock) begin
    reg_0  <= n16;
    reg_1  <= n21;
    reg_2  <= n26;
    reg_3  <= n31;
    reg_4  <= n36;
    counter_0  <= n41;
    counter_1  <= n46;
    counter_2  <= n51;
    counter_3  <= n56;
  end
  initial begin
    reg_0  <= 1'b0;
    reg_1  <= 1'b0;
    reg_2  <= 1'b0;
    reg_3  <= 1'b0;
    reg_4  <= 1'b0;
    counter_0  <= 1'b0;
    counter_1  <= 1'b0;
    counter_2  <= 1'b0;
    counter_3  <= 1'b0;
  end
endmodule


