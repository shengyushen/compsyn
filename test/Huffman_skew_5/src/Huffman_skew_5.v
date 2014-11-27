// Benchmark "Huffman_skew_5" written by ABC on Fri Nov 21 17:57:43 2014

module Huffman_skew_5 ( clock, 
    in_0 , in_1 , in_2 , in_3 , in_4 ,
    carestate, out  );
  input  clock;
  input  in_0 , in_1 , in_2 , in_3 , in_4 ;
  output carestate, out;
  reg reg_0 , reg_1 , reg_2 , reg_3 , reg_4 , counter_0 ,
    counter_1 , counter_2 , counter_3 , counter_4 ;
  wire n38, n44, n45, n46_1, n47, n48, n49, n50, n51_1, n52, n53, n54, n55,
    n56_1, n57, n58, n64, n65, n66, n67, n68, n69, n70, n72, n73, n16, n21,
    n26, n31, n36, n41, n46, n51, n56, n61;
  assign n38 = ~counter_0  & ~counter_1  & ~counter_2  & ~counter_3  & ~counter_4 ;
  assign n16 = n38 ? in_0  : reg_0 ;
  assign n21 = n38 ? in_1  : reg_1 ;
  assign n26 = n38 ? in_2  : reg_2 ;
  assign n31 = n38 ? in_3  : reg_3 ;
  assign n36 = n38 ? in_4  : reg_4 ;
  assign n44 = (in_3  & (in_1  ? (in_2  & in_4 ) : (in_2  ^ in_4 ))) | (in_1  & ~in_3  & ~in_4 ) | (~in_2  & ((in_4  & (in_0  ? in_1  : (~in_1  & ~in_3 ))) | (~in_0  & ~in_1  & in_3  & ~in_4 ))) | (in_0  & in_2  & in_3  & (in_1  ^ in_4 ));
  assign n45 = ((in_1  ^ in_4 ) & (in_0  ? (~in_2  & in_3 ) : ~in_3 )) | (~in_1  & (in_0  ? ~in_3  : (in_2  & in_3 ))) | (in_1  & in_4  & (in_0  ? (~in_2  ^ in_3 ) : in_2 ));
  assign n46_1 = (in_1  & (in_0  ? (in_2  ^ in_4 ) : (~in_2  & in_4 ))) | (~in_0  & ~in_1  & in_2  & in_4 ) | (in_1  & (in_0  ? (in_2  ? (in_3  & in_4 ) : (~in_3  & ~in_4 )) : (in_2  ? (in_3  ^ ~in_4 ) : (in_3  & ~in_4 )))) | (in_0  & ~in_1  & (in_2  ? (~in_3  & in_4 ) : (~in_3  ^ ~in_4 )));
  assign n47 = (in_1  & (in_2  ? (in_3  & ~in_4 ) : (~in_3  & in_4 ))) | (~in_1  & ~in_3  & (~in_2  ^ in_4 )) | (in_1  & ((~in_4  & (in_0  ? (in_2  ^ in_3 ) : (~in_2  & ~in_3 ))) | (~in_0  & in_3  & in_4 ))) | (~in_0  & ~in_1  & in_3  & (~in_2  | (in_2  & ~in_4 )));
  assign n48 = (in_0  & (in_1  ? (in_2  & in_3 ) : (~in_2  & ~in_3 ))) | (~in_0  & (in_1  ? (~in_2  & in_3 ) : (in_2  & ~in_3 ))) | (~in_1  & (in_0  ? (in_2  & ~in_4 ) : (~in_2  & in_4 ))) | (in_1  & ((~in_0  & ~in_4  & (~in_2  ^ in_3 )) | (in_3  & in_4  & in_0  & ~in_2 )));
  assign n49 = 1'b0;
  assign n50 = counter_4  | n49;
  assign n51_1 = counter_3  | n50;
  assign n52 = counter_2  | n51_1;
  assign n53 = counter_1  | n52;
  assign n54 = counter_0  ^ ~n53;
  assign n55 = counter_1  ^ ~n52;
  assign n56_1 = counter_2  ^ ~n51_1;
  assign n57 = counter_3  ^ ~n50;
  assign n58 = counter_4  ^ ~n49;
  assign n41 = n38 ? n44 : n54;
  assign n46 = n38 ? n45 : n55;
  assign n51 = n38 ? n46_1 : n56_1;
  assign n56 = n38 ? n47 : n57;
  assign n61 = n38 ? n48 : n58;
  assign n64 = in_0  ^ ~reg_0 ;
  assign n65 = in_1  ^ ~reg_1 ;
  assign n66 = in_2  ^ ~reg_2 ;
  assign n67 = in_3  ^ ~reg_3 ;
  assign n68 = in_4  ^ ~reg_4 ;
  assign n69 = n68 & n67 & n66 & n64 & n65;
  assign n70 = 1'b0;
  assign carestate = n38 ? ~n70 : n69;
  assign n72 = ~in_0  | (in_0  & ~in_1 ) | (in_0  & in_1  & ~in_2 ) | (in_0  & in_1  & in_2  & in_3 ) | (in_0  & in_1  & in_2  & ~in_3  & ~in_4 );
  assign n73 = ((reg_2  ? (reg_3  & ~reg_4 ) : (~reg_3  & reg_4 )) & (((~reg_0  ^ reg_1 ) & ((counter_0  & ~counter_1 ) | (~counter_0  & counter_1 ) | (~counter_0  & ~counter_1  & counter_2 ) | (~counter_0  & ~counter_1  & ~counter_2  & counter_3 ))) | (~counter_2  & ((~counter_0  & ((reg_0  & ~reg_1  & (counter_1  | (~counter_1  & counter_3 ))) | (~counter_1  & counter_3  & ~reg_0  & reg_1 ))) | (counter_0  & counter_1  & ~counter_3  & ~reg_0  & ~reg_1 ))) | (~counter_0  & counter_2  & reg_0  & ~reg_1  & (~counter_1  | (counter_1  & ~counter_3 ))))) | (~counter_2  & ((((~counter_3  & reg_0  & ~reg_2  & reg_4 ) | (counter_3  & ~reg_0  & reg_2  & ~reg_4 )) & ((reg_1  & ~reg_3  & (counter_0  ? counter_1  : (~counter_1  & counter_4 ))) | (counter_0  & counter_1  & ~counter_4  & ~reg_1  & reg_3 ))) | (reg_3  & ((~counter_1  & ((~reg_1  & (counter_4  ? (~reg_2  & (counter_0  ? (~counter_3  & ~reg_0 ) : counter_3 )) : ((~reg_2  & ((~reg_0  & (counter_0  | (~counter_0  & counter_3 ))) | (~counter_0  & counter_3  & reg_0 ))) | (counter_0  & ~counter_3  & reg_0  & reg_2 )))) | (~counter_0  & counter_3  & reg_1  & ~reg_2 ))) | (~counter_0  & counter_1  & ~reg_2  & (((~reg_0  ^ reg_1 ) & (~counter_3  | (counter_3  & ~counter_4 ))) | (counter_3  & counter_4  & ~reg_0  & ~reg_1 ))))) | (~counter_0  & reg_2  & ~reg_3  & (counter_1  ^ counter_3 ) & (counter_4  ? (reg_0  & ~reg_1 ) : (reg_0  ^ reg_1 ))) | (counter_1  & (((reg_2  ? (reg_3  & reg_4 ) : (~reg_3  & ~reg_4 )) & (counter_0  ? (~reg_0  & reg_1 ) : (reg_0  | (~reg_0  & reg_1 )))) | (~counter_0  & (reg_0  ? ((reg_3  & reg_4  & ~reg_1  & ~reg_2 ) | (~reg_3  & ~reg_4  & reg_1  & reg_2 )) : (~reg_1  & reg_2  & reg_4 ))) | (reg_2  & reg_3  & reg_4  & counter_0  & reg_0  & reg_1 ))) | (counter_0  & ~counter_1  & ((reg_1  & (((~reg_3  ^ reg_4 ) & (reg_0  | (~reg_0  & reg_2 ))) | (~reg_3  & ~reg_4  & ~reg_0  & ~reg_2 ))) | (reg_0  & ~reg_1  & ~reg_2  & reg_3  & reg_4 ))) | (~reg_3  & ~reg_4  & reg_1  & reg_2  & ~counter_0  & counter_1  & counter_4  & ~reg_0 ) | (~reg_3  & ((reg_1  & (counter_0  ? (counter_1  & ((~reg_2  & reg_4  & counter_3  & reg_0 ) | (reg_2  & ~reg_4  & ~counter_3  & ~reg_0 ))) : (~counter_1  & counter_3  & ~reg_4  & (reg_0  | (~reg_0  & ~reg_2 ))))) | (~counter_0  & counter_3  & ~reg_1  & ((~counter_1  & (reg_0  ? (~reg_2  & ~reg_4 ) : (reg_2  & reg_4 ))) | (reg_2  & reg_4  & counter_1  & reg_0 ))))) | (~counter_0  & ~counter_1  & counter_3  & reg_2  & reg_3  & reg_4 ) | (~counter_1  & ((counter_4  & ((counter_0  & ~reg_1  & reg_3  & ((~reg_2  & reg_4  & counter_3  & ~reg_0 ) | (~counter_3  & reg_0  & reg_2  & ~reg_4 ))) | (~counter_0  & counter_3  & ~reg_0  & ~reg_3  & reg_4  & reg_1  & reg_2 ))) | (~counter_0  & counter_3  & ~counter_4  & ~reg_0  & ~reg_3  & ~reg_4  & ~reg_1  & ~reg_2 ))) | (~counter_0  & counter_1  & counter_3  & reg_1  & ((~reg_2  & reg_3  & reg_4  & counter_4  & reg_0 ) | (~counter_4  & ~reg_0  & reg_2  & ~reg_3  & ~reg_4 ))))) | (counter_2  & (((reg_1  ^ ~reg_2 ) & ((~counter_0  & ((reg_3  & reg_4 ) | (~reg_3  & ~reg_4  & ~counter_1  & reg_0 ))) | (counter_0  & ~counter_1  & reg_0  & reg_3  & reg_4 ))) | ((~reg_3  ^ reg_4 ) & ((~counter_1  & ((~counter_0  & (reg_0  ? (~reg_1  ^ ~reg_2 ) : (reg_1  & ~reg_2 ))) | (reg_1  & reg_2  & counter_0  & ~reg_0 ))) | (~counter_0  & counter_1  & reg_0  & reg_1  & ~reg_2 ))) | (~counter_0  & (reg_2  ? (((~counter_1  ^ reg_0 ) & (reg_1  ? (~reg_3  & ~reg_4 ) : (reg_3  & reg_4 ))) | (~reg_3  & ((~reg_0  & (counter_1  ? (reg_1  ^ reg_4 ) : reg_4 )) | (~counter_1  & reg_0  & ~reg_1  & reg_4 )))) : (~reg_4  & ((~reg_0  & (counter_1  ? (reg_1  ^ reg_3 ) : (~reg_1  & reg_3 ))) | (~counter_1  & reg_0  & reg_1  & reg_3 ))))) | (counter_0  & ~counter_1  & ~reg_0  & reg_1  & ~reg_2  & ~reg_3  & ~reg_4 ) | (reg_0  & ((counter_1  & ((~counter_3  & reg_4  & ((counter_0  & reg_1  & (~reg_2  ^ reg_3 )) | (~counter_0  & ~reg_1  & reg_2  & ~reg_3 ))) | (reg_2  & reg_3  & ~reg_4  & ~counter_0  & counter_3  & ~reg_1 ))) | (counter_0  & ~counter_1  & ~counter_3  & reg_1  & (reg_2  ? (~reg_3  & ~reg_4 ) : (reg_3  & reg_4 ))))) | (~counter_3  & ~reg_0  & reg_1  & ((~counter_0  & ~counter_1  & ~reg_2  & (reg_3  ^ reg_4 )) | (counter_0  & counter_1  & reg_2  & reg_3  & reg_4 ))) | (~counter_4  & (counter_1  ? ((reg_2  & ((~reg_0  & ((counter_0  & reg_1  & (counter_3  ? (reg_3  & reg_4 ) : (~reg_3  & ~reg_4 ))) | (~counter_0  & ~counter_3  & ~reg_1  & reg_3  & reg_4 ))) | (~counter_0  & counter_3  & reg_0  & ~reg_1  & ~reg_3  & reg_4 ))) | (counter_0  & counter_3  & reg_0  & ~reg_3  & reg_4  & reg_1  & ~reg_2 )) : ((reg_0  & ~reg_4  & ((counter_0  & reg_1  & ~reg_3  & (~counter_3  ^ reg_2 )) | (~counter_0  & ~counter_3  & ~reg_1  & ~reg_2  & reg_3 ))) | (~counter_0  & counter_3  & ~reg_0  & ~reg_3  & reg_4  & reg_1  & ~reg_2 ))))));
  assign out = n38 ? n72 : n73;
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
    counter_4  <= n61;
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
    counter_4  <= 1'b0;
  end
endmodule


