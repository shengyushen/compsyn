// Benchmark "Huffman_skew_6" written by ABC on Fri Nov 21 18:07:18 2014

module Huffman_skew_6 ( clock, 
    in_0 , in_1 , in_2 , in_3 , in_4 , in_5 ,
    carestate, out  );
  input  clock;
  input  in_0 , in_1 , in_2 , in_3 , in_4 , in_5 ;
  output carestate, out;
  reg reg_0 , reg_1 , reg_2 , reg_3 , reg_4 , reg_5 ,
    counter_0 , counter_1 , counter_2 , counter_3 , counter_4 ,
    counter_5 ;
  wire n45, n52, n53_1, n54, n55, n56, n57, n58_1, n59, n60, n61, n62, n63_1,
    n64, n65, n66, n67, n68_1, n69, n76, n77, n78, n79, n80, n81, n82, n83,
    n85, n86, n18, n23, n28, n33, n38, n43, n48, n53, n58, n63, n68, n73;
  assign n45 = ~counter_0  & ~counter_1  & ~counter_2  & ~counter_3  & ~counter_4  & ~counter_5 ;
  assign n18 = n45 ? in_0  : reg_0 ;
  assign n23 = n45 ? in_1  : reg_1 ;
  assign n28 = n45 ? in_2  : reg_2 ;
  assign n33 = n45 ? in_3  : reg_3 ;
  assign n38 = n45 ? in_4  : reg_4 ;
  assign n43 = n45 ? in_5  : reg_5 ;
  assign n52 = (in_0  & (in_4  ? (in_2  ? in_5  : (~in_3  & ~in_5 )) : (in_2  ^ in_3 ))) | (~in_0  & ~in_2  & ~in_3  & in_4  & ~in_5 ) | (in_1  & ((~in_3  & ((~in_2  & (in_0  ? (~in_4  ^ in_5 ) : ~in_4 )) | (~in_0  & in_2  & ~in_4 ))) | (~in_0  & in_3  & (in_2  ? (in_4  | (~in_4  & in_5 )) : (in_4  & in_5 ))))) | (~in_1  & ((~in_0  & ((~in_3  & in_4  & in_5 ) | (in_3  & ~in_4  & ~in_5 ) | (in_2  & ~in_3  & in_4  & ~in_5 ))) | (in_3  & ~in_4  & ~in_5  & in_0  & in_2 )));
  assign n53_1 = (~in_4  & ((in_0  & ((in_1  & in_2 ) | (~in_1  & ~in_2 ) | (~in_1  & in_2  & ~in_3 ))) | (in_2  & ~in_3  & ~in_0  & in_1 ))) | (~in_0  & in_4  & (in_1  ? (~in_2  ^ in_3 ) : (in_2  & in_3 ))) | (in_1  & (((in_0  ? (in_2  & in_4 ) : (~in_2  & ~in_4 )) & (in_3  ^ in_5 )) | (in_5  & ((~in_2  & (in_0  ? ~in_4  : (in_3  & in_4 ))) | (~in_0  & in_2  & in_3  & ~in_4 ))))) | (~in_1  & ((in_5  & (in_0  ? (in_2  ? (in_3  & ~in_4 ) : (~in_3  & in_4 )) : (~in_4  & (~in_2  ^ in_3 )))) | (in_0  & in_2  & in_4  & ~in_5 )));
  assign n54 = ((~in_4  ^ ~in_5 ) & (in_0  ? ((in_2  & (~in_1  | (in_1  & in_3 ))) | (~in_1  & ~in_2  & ~in_3 )) : (in_1  ? (~in_2  & in_3 ) : (in_2  & ~in_3 )))) | ((in_2  ^ in_3 ) & ((~in_1  & (in_0  ? (~in_4  & ~in_5 ) : (~in_4  ^ in_5 ))) | (in_0  & in_1  & in_5 ))) | (~in_5  & ((~in_0  & ~in_1  & ~in_2  & in_4 ) | (in_0  & in_1  & in_2  & ~in_4 ) | (~in_0  & ~in_4  & (in_1  ? (~in_2  & ~in_3 ) : (~in_2  ^ in_3 ))))) | (~in_2  & in_5  & ((in_0  & ~in_4  & (in_1  ^ in_3 )) | (~in_0  & ~in_1  & ~in_3  & in_4 )));
  assign n55 = (((in_0  & (in_3  ? (in_4  & in_5 ) : (~in_4  & ~in_5 ))) | (~in_4  & in_5  & ~in_0  & in_3 )) & (in_1  | (~in_1  & ~in_2 ))) | (~in_2  & ~in_4  & (in_0  ? (in_1  & in_3 ) : (~in_1  & ~in_3 ))) | (in_2  & in_4  & (in_0  ? (in_1  ^ in_3 ) : (~in_1  ^ in_3 ))) | (~in_5  & ((in_2  & ((in_0  & in_4  & (~in_1  ^ in_3 )) | (~in_0  & ~in_1  & in_3  & ~in_4 ))) | (in_1  & ~in_2  & ((in_3  & (~in_0  | (in_0  & in_4 ))) | (~in_0  & ~in_3  & ~in_4 ))))) | (in_1  & ~in_3  & in_5  & ((~in_4  & (in_0  | (~in_0  & in_2 ))) | (~in_0  & ~in_2  & in_4 )));
  assign n56 = ((in_3  ^ in_5 ) & ((~in_4  & (in_0  ? (in_1  ^ in_2 ) : (~in_1  & in_2 ))) | (~in_0  & in_1  & in_4 ))) | (~in_0  & (in_1  ? ((~in_3  & ~in_4  & ~in_5 ) | (in_3  & (~in_4  ^ in_5 )) | (~in_2  & in_3  & ~in_4  & in_5 )) : (in_3  ? (~in_2  ^ in_4 ) : (in_2  ? (~in_4  & ~in_5 ) : (in_4  & in_5 ))))) | (in_0  & in_2  & ((in_1  & in_5 ) | (~in_1  & ~in_3  & ~in_5 ) | (~in_1  & in_5  & (~in_3  ^ ~in_4 )) | (in_4  & ~in_5  & in_1  & ~in_3 )));
  assign n57 = ((~in_3  ^ ~in_4 ) & ((~in_0  & ~in_5  & (in_1  | (~in_1  & ~in_2 ))) | (in_0  & ~in_1  & ~in_2  & in_5 ))) | ((in_0  ? (in_1  & ~in_2 ) : (~in_1  & in_2 )) & (in_3  ? (in_4  & ~in_5 ) : in_5 )) | (in_0  & in_2  & in_3  & (~in_1  ^ in_4 )) | (~in_0  & ~in_1  & ~in_2  & ~in_3  & ~in_4 ) | (~in_0  & ((in_3  & ((in_5  & (~in_1  ^ in_2 )) | (in_4  & ~in_5  & in_1  & ~in_2 ))) | (in_1  & ~in_3  & ~in_4  & ~in_5 ))) | (in_0  & ~in_4  & ((in_1  & ~in_5  & (in_2  | (~in_2  & ~in_3 ))) | (~in_3  & in_5  & ~in_1  & in_2 )));
  assign n58_1 = 1'b0;
  assign n59 = counter_5  | n58_1;
  assign n60 = counter_4  | n59;
  assign n61 = counter_3  | n60;
  assign n62 = counter_2  | n61;
  assign n63_1 = counter_1  | n62;
  assign n64 = counter_0  ^ ~n63_1;
  assign n65 = counter_1  ^ ~n62;
  assign n66 = counter_2  ^ ~n61;
  assign n67 = counter_3  ^ ~n60;
  assign n68_1 = counter_4  ^ ~n59;
  assign n69 = counter_5  ^ ~n58_1;
  assign n48 = n45 ? n52 : n64;
  assign n53 = n45 ? n53_1 : n65;
  assign n58 = n45 ? n54 : n66;
  assign n63 = n45 ? n55 : n67;
  assign n68 = n45 ? n56 : n68_1;
  assign n73 = n45 ? n57 : n69;
  assign n76 = in_0  ^ ~reg_0 ;
  assign n77 = in_1  ^ ~reg_1 ;
  assign n78 = in_2  ^ ~reg_2 ;
  assign n79 = in_3  ^ ~reg_3 ;
  assign n80 = in_4  ^ ~reg_4 ;
  assign n81 = in_5  ^ ~reg_5 ;
  assign n82 = n81 & n80 & n79 & n78 & n76 & n77;
  assign n83 = 1'b0;
  assign carestate = n45 ? ~n83 : n82;
  assign n85 = ~in_0  | (in_0  & in_1 ) | (in_0  & ~in_1  & in_2 ) | (~in_2  & ~in_3  & in_0  & ~in_1 ) | (in_0  & ~in_1  & ~in_2  & in_3  & ~in_4 ) | (in_3  & in_4  & in_5  & in_0  & ~in_1  & ~in_2 );
  assign n86 = ((~reg_3  ^ reg_4 ) & ((reg_2  & ((reg_1  & ((~reg_0  & ((~counter_0  & ~counter_1  & counter_2 ) | (~counter_0  & counter_1 ) | (counter_0  & ~counter_1 ))) | (~counter_0  & (counter_1  ^ counter_2 ) & reg_0 ))) | (~counter_0  & reg_0  & (counter_1  ^ counter_2 ) & ~reg_1 ))) | (~counter_0  & ~counter_1  & counter_2  & ~reg_0  & reg_1  & ~reg_2 ) | (~counter_0  & ((reg_2  & ((~counter_1  & ~counter_2  & counter_3 ) | (counter_1  & counter_2  & ~counter_3  & reg_0 ))) | (~counter_1  & ~counter_2  & counter_3  & ~reg_0  & ~reg_2 ))) | (counter_0  & counter_1  & ~counter_2  & ~counter_3  & ~reg_0  & reg_1  & reg_2 ))) | (~counter_0  & (((counter_1  ^ counter_2 ) & ((reg_0  & reg_3  & ~reg_4 ) | (~reg_0  & ~reg_1  & ~reg_3  & reg_4 ))) | (counter_2  & ~reg_1  & ~reg_3  & reg_4  & (counter_1  ^ reg_0 )))) | (counter_0  & ~counter_1  & ~counter_2  & ~reg_0  & ~reg_1  & ~reg_3  & reg_4 ) | (~counter_0  & ((reg_0  & ((~reg_4  & (counter_1  ? (counter_2  & (counter_3  ? (reg_1  & ~reg_3 ) : (~reg_1  & reg_3 ))) : (~counter_2  & counter_3  & reg_3 ))) | (~counter_1  & ~counter_2  & counter_3  & ~reg_1  & ~reg_3  & reg_4 ))) | (~counter_1  & ~counter_2  & counter_3  & ~reg_0  & ~reg_1  & (~reg_3  ^ ~reg_4 )))) | (~reg_4  & ((~reg_3  & ((counter_0  & ~counter_1  & (reg_0  ? reg_2  : (reg_1  & ~reg_2 ))) | (~counter_0  & counter_1  & ~reg_0  & reg_1  & ~reg_2 ))) | (counter_0  & ~counter_1  & reg_0  & ~reg_1  & ~reg_2  & reg_3 ) | (reg_0  & ((~reg_3  & ((counter_0  & counter_1  & ~counter_2  & reg_2 ) | (~counter_0  & ~counter_1  & counter_2  & ~reg_2 ) | (~counter_0  & counter_1  & ~counter_2  & reg_1  & ~reg_2 ))) | (counter_1  & ~reg_2  & reg_3  & (counter_0  ? (~counter_2  & ~reg_1 ) : (counter_2  & reg_1 ))))) | (~counter_0  & ~counter_1  & counter_2  & ~reg_0  & ~reg_1  & reg_2  & reg_3 ))) | (~counter_0  & reg_4  & ((~reg_3  & ((reg_1  & ~reg_2  & ((reg_0  & (counter_1  | (~counter_1  & counter_2 ))) | (~counter_1  & counter_2  & ~reg_0 ))) | (counter_1  & ~counter_2  & reg_0  & ~reg_1  & reg_2 ))) | (~counter_1  & counter_2  & ~reg_0  & ~reg_1  & reg_2  & reg_3 ))) | (~counter_1  & ((~counter_3  & (counter_0  ? ((counter_2  & ~reg_0  & ~reg_1  & reg_2  & ~reg_3  & reg_4 ) | (~counter_2  & reg_0  & reg_1  & ~reg_2  & reg_3  & ~reg_4 )) : (counter_2  & ~reg_0  & ~reg_2  & ~reg_4  & (~reg_1  ^ reg_3 )))) | (~counter_0  & ~counter_2  & counter_3  & ~reg_2  & ((reg_1  & ((~reg_3  & (reg_0  | (~reg_0  & reg_4 ))) | (~reg_0  & reg_3  & ~reg_4 ))) | (~reg_3  & ~reg_4  & reg_0  & ~reg_1 ))))) | (counter_1  & ((~counter_0  & ((~reg_3  & ((~counter_3  & ((reg_0  & ((counter_2  & (reg_1  ? (~reg_2  & ~reg_4 ) : (reg_2  & reg_4 ))) | (~counter_2  & ~reg_1  & ~reg_2  & ~reg_4 ))) | (~counter_2  & ~reg_0  & reg_1  & ~reg_2  & reg_4 ))) | (counter_2  & counter_3  & reg_0  & ~reg_1  & reg_2  & ~reg_4 ))) | (counter_2  & counter_3  & reg_0  & reg_3  & ~reg_4  & ~reg_1  & ~reg_2 ))) | (counter_0  & counter_2  & ~counter_3  & reg_0  & ~reg_3  & ~reg_4  & reg_1  & reg_2 ))) | (~counter_1  & ((~reg_2  & ((~counter_4  & (counter_0  ? ((~reg_1  & ~reg_3  & reg_4  & counter_2  & ~counter_3  & ~reg_0 ) | (~counter_2  & counter_3  & reg_0  & reg_1  & reg_3  & ~reg_4 )) : (counter_3  & ((counter_2  & ~reg_0  & ~reg_4  & (~reg_1  ^ reg_3 )) | (~counter_2  & reg_0  & reg_1  & reg_3  & reg_4 ))))) | (~counter_0  & ~counter_2  & ~counter_3  & counter_4  & (~reg_0  | (reg_0  & reg_1 ) | (reg_0  & ~reg_1  & ~reg_3 ) | (reg_3  & ~reg_4  & reg_0  & ~reg_1 ))))) | (~counter_0  & reg_2  & ((~reg_3  & ((~counter_4  & ((~counter_2  & counter_3  & reg_0  & reg_1  & reg_4 ) | (counter_2  & ~counter_3  & ~reg_0  & ~reg_1  & ~reg_4 ))) | (~counter_2  & ~counter_3  & counter_4  & (reg_0  | (~reg_0  & ~reg_1 ) | (~reg_0  & reg_1  & ~reg_4 ))))) | (~counter_2  & ~counter_3  & counter_4  & reg_3 ))))) | (counter_1  & ~counter_4  & (counter_0  ? (reg_2  & ((counter_2  & reg_0  & ~reg_3  & ~reg_4  & (~counter_3  ^ reg_1 )) | (reg_1  & reg_3  & reg_4  & ~counter_2  & counter_3  & ~reg_0 ))) : ((reg_4  & ((counter_3  & ((counter_2  & reg_0  & reg_2  & (~reg_1  ^ reg_3 )) | (~counter_2  & ~reg_0  & reg_1  & ~reg_2  & ~reg_3 ))) | (~counter_2  & ~counter_3  & ~reg_1  & (reg_0  ? (~reg_2  & ~reg_3 ) : (reg_2  & reg_3 ))))) | (counter_2  & ~counter_3  & reg_0  & reg_1  & reg_2  & reg_3  & ~reg_4 )))) | (reg_5  & (reg_0  ? (reg_4  ? ((reg_2  & ((((~counter_2  & ~counter_3  & counter_0  & ~counter_1 ) | (~counter_0  & counter_1  & counter_2  & counter_3 )) & (reg_1  ^ reg_3 )) | (reg_1  & (((counter_1  ^ counter_2 ) & ~reg_3 ) | (counter_0  & ~counter_1  & ~counter_2  & reg_3 ) | (~reg_3  & ((counter_2  & ~counter_3  & ~counter_0  & counter_1 ) | (counter_0  & (counter_1  ? (counter_2  & ~counter_3 ) : (~counter_2  & counter_3 ))))))))) | (~counter_0  & ~counter_1  & counter_2  & ~reg_2  & reg_3  & ~counter_3  & reg_1 ) | (~counter_1  & ~counter_2  & ((~counter_3  & ((counter_0  & ~counter_4  & ~reg_3  & (~reg_1  ^ ~reg_2 )) | (~reg_1  & ~reg_2  & reg_3  & ~counter_0  & counter_4 ))) | (~counter_0  & counter_3  & counter_4  & reg_1  & (reg_2  ^ reg_3 )))) | (counter_1  & counter_2  & counter_3  & reg_2  & ((~counter_0  & counter_4  & (~reg_1  ^ reg_3 )) | (counter_0  & ~counter_4  & reg_1  & ~reg_3 )))) : ((~reg_2  & ((counter_0  & reg_1  & reg_3  & ((~counter_1  & counter_2 ) | (counter_1  & ~counter_2 ) | (counter_1  & counter_2  & ~counter_3 ))) | (~counter_0  & counter_1  & ~counter_2  & counter_3  & ~reg_1  & ~reg_3 ) | (counter_0  & reg_3  & ((~counter_1  & ~counter_2  & counter_3  & counter_4  & reg_1 ) | (counter_1  & counter_2  & ~counter_3  & ~counter_4  & ~reg_1 ))))) | (counter_0  & counter_1  & counter_2  & ~counter_3  & reg_2  & ~reg_3  & counter_4  & ~reg_1 ))) : (reg_2  ? (counter_1  ? (reg_1  & reg_3  & ((~counter_2  & (counter_0  ? (counter_3  ? (~counter_4  ^ reg_4 ) : ~reg_4 ) : ~reg_4 )) | (~counter_0  & counter_2  & ~reg_4 ))) : (counter_2  ? (reg_1  ? (reg_3  & ~reg_4 ) : (~reg_3  & ((counter_0  & counter_3  & ~counter_4  & reg_4 ) | (~counter_0  & ~counter_3  & counter_4  & ~reg_4 )))) : (reg_1  & reg_3  & ~reg_4  & (counter_0  | (~counter_0  & counter_3 ))))) : (((counter_1  ? (~counter_2  & ~counter_4 ) : (counter_2  & counter_4 )) & ((reg_1  & reg_3  & reg_4  & counter_0  & ~counter_3 ) | (~counter_0  & counter_3  & ~reg_1  & ~reg_3  & ~reg_4 ))) | (reg_1  & reg_3  & reg_4  & ((~counter_0  & counter_1 ) | (counter_0  & ~counter_1  & ~counter_2 ) | (counter_2  & counter_3  & counter_0  & ~counter_1 ))) | (~counter_0  & counter_1  & ~counter_2  & ~reg_3  & ~reg_4  & ~counter_3  & ~reg_1 ) | (~counter_1  & counter_2  & ~counter_3  & ~counter_4  & reg_3  & reg_4  & (~counter_0  ^ reg_1 )))))) | (~reg_5  & ((((~counter_2  & ~counter_3  & counter_0  & ~counter_1 ) | (~counter_0  & counter_1  & counter_2  & counter_3 )) & ((~reg_1  & (reg_0  ? (reg_2  ? (reg_3  & ~reg_4 ) : (~reg_3  & reg_4 )) : (reg_3  & ~reg_4 ))) | (~reg_2  & ~reg_3  & reg_4  & ~reg_0  & reg_1 ))) | (~reg_2  & ((~counter_1  & ((~reg_0  & ((counter_2  & ((~reg_3  & reg_4  & counter_0  & reg_1 ) | (reg_3  & ~reg_4  & ~counter_0  & ~reg_1 ) | (counter_0  & ~counter_3  & ~reg_1  & reg_3  & ~reg_4 ))) | (counter_0  & ~counter_2  & counter_3  & (reg_1  ? (~reg_3  & reg_4 ) : (reg_3  & ~reg_4 ))))) | (counter_0  & ~counter_2  & reg_0  & ~reg_3  & (counter_3  ? (~reg_1  & reg_4 ) : (reg_1  & ~reg_4 ))))) | (~counter_0  & counter_1  & ((~reg_1  & (((counter_2  ^ counter_3 ) & (reg_0  ? (~reg_3  & reg_4 ) : (reg_3  & ~reg_4 ))) | (~counter_2  & ~counter_3  & ~reg_0  & reg_3  & ~reg_4 ))) | (~reg_0  & reg_1  & ((~counter_2  & reg_3  & ~reg_4 ) | (counter_2  & ~counter_3  & ~reg_3  & reg_4 ))))))) | (~reg_0  & ~reg_1  & reg_2  & reg_3  & ~reg_4  & (((counter_2  ^ counter_3 ) & (counter_0  ^ counter_1 )) | (~counter_0  & counter_1  & ~counter_2  & ~counter_3 ))) | (~reg_0  & (counter_0  ? (~counter_4  & ((counter_1  & ~counter_2  & ~counter_3  & reg_1  & ~reg_2  & ~reg_3  & reg_4 ) | (~counter_1  & counter_2  & counter_3  & reg_3  & ~reg_4  & ~reg_1  & reg_2 ))) : (counter_4  & ((counter_1  & ~counter_2  & reg_4  & ((reg_2  & reg_3  & ~counter_3  & ~reg_1 ) | (~reg_2  & ~reg_3  & counter_3  & reg_1 ))) | (~counter_1  & counter_2  & counter_3  & reg_1  & ~reg_2  & reg_3  & ~reg_4 ))))) | (~counter_2  & reg_0  & ~reg_2  & ~reg_3  & ((~counter_0  & counter_1  & ~counter_3  & counter_4  & ~reg_1  & reg_4 ) | (counter_0  & ~counter_1  & counter_3  & ~counter_4  & reg_1  & ~reg_4 ))))) | (~counter_5  & (reg_1  ? (counter_3  ? ((reg_5  & ((counter_2  & ((~reg_2  & reg_3  & ((~counter_0  & ~counter_1  & (counter_4  ? (~reg_0  & ~reg_4 ) : (reg_0  & reg_4 ))) | (counter_0  & counter_1  & ~counter_4  & reg_0  & ~reg_4 ))) | (counter_0  & counter_1  & counter_4  & reg_0  & reg_2  & ~reg_3 ))) | (counter_1  & ~counter_2  & ~reg_0  & ~reg_3  & ((~reg_2  & reg_4  & ~counter_0  & counter_4 ) | (counter_0  & ~counter_4  & reg_2  & ~reg_4 ))))) | (~counter_2  & counter_4  & ~reg_5  & ((counter_0  & reg_3  & ((counter_1  & ~reg_0  & reg_2  & reg_4 ) | (~counter_1  & reg_0  & ~reg_2  & ~reg_4 ))) | (reg_2  & ~reg_3  & reg_4  & ~counter_0  & ~counter_1  & reg_0 )))) : ((reg_5  & ((counter_1  & ((counter_0  & ~counter_2  & ~reg_0  & ~reg_2  & (counter_4  ? (reg_3  & reg_4 ) : (~reg_3  & ~reg_4 ))) | (~counter_0  & counter_2  & counter_4  & reg_3  & ~reg_4  & reg_0  & reg_2 ))) | (~counter_0  & ~counter_1  & ~counter_2  & counter_4  & ~reg_3  & reg_4  & ~reg_0  & reg_2 ))) | (~counter_2  & ~counter_4  & counter_0  & ~counter_1  & reg_0  & ~reg_2  & ~reg_3  & reg_4  & ~reg_5 ))) : (reg_0  ? ((~reg_3  & ((~counter_3  & ((counter_2  & ((counter_0  & ~reg_5  & ((~counter_1  & ~counter_4  & ~reg_2  & reg_4 ) | (counter_1  & counter_4  & reg_2  & ~reg_4 ))) | (~counter_0  & counter_1  & ~counter_4  & ~reg_2  & ~reg_4  & reg_5 ))) | (counter_0  & ~counter_1  & ~counter_2  & counter_4  & reg_2  & reg_4  & reg_5 ))) | (~counter_0  & counter_1  & counter_3  & ~reg_5  & ((counter_2  & counter_4  & reg_2  & reg_4 ) | (~counter_2  & ~counter_4  & ~reg_2  & ~reg_4 ))))) | (~counter_4  & reg_3  & (counter_0  ? ((~counter_1  & ~counter_2  & counter_3  & reg_2  & reg_4  & reg_5 ) | (counter_1  & counter_2  & ~counter_3  & ~reg_2  & ~reg_4  & ~reg_5 )) : (counter_3  & reg_4  & ((~counter_1  & ~counter_2  & ~reg_2  & reg_5 ) | (counter_1  & counter_2  & reg_2  & ~reg_5 )))))) : ((~counter_3  & ((~counter_0  & ((reg_2  & ((counter_1  & ~counter_2  & reg_3  & reg_5  & (~counter_4  ^ reg_4 )) | (~counter_1  & counter_2  & counter_4  & ~reg_3  & ~reg_4  & ~reg_5 ))) | (~counter_1  & counter_2  & ~counter_4  & ~reg_2  & reg_3  & reg_4  & ~reg_5 ))) | (counter_2  & counter_4  & counter_0  & ~counter_1  & ~reg_2  & ~reg_3  & reg_4  & reg_5 ))) | (counter_0  & ~counter_1  & counter_2  & counter_3  & reg_2  & ~reg_5  & (counter_4  ? (reg_3  & ~reg_4 ) : (~reg_3  & reg_4 ))))))) | (~counter_0  & ~counter_1  & ~counter_2  & ~counter_3  & ~counter_4  & counter_5  & reg_0  & reg_1  & reg_2  & ~reg_3  & reg_4  & reg_5 );
  assign out = n45 ? n85 : n86;
  always @ (posedge clock) begin
    reg_0  <= n18;
    reg_1  <= n23;
    reg_2  <= n28;
    reg_3  <= n33;
    reg_4  <= n38;
    reg_5  <= n43;
    counter_0  <= n48;
    counter_1  <= n53;
    counter_2  <= n58;
    counter_3  <= n63;
    counter_4  <= n68;
    counter_5  <= n73;
  end
  initial begin
    reg_0  <= 1'b0;
    reg_1  <= 1'b0;
    reg_2  <= 1'b0;
    reg_3  <= 1'b0;
    reg_4  <= 1'b0;
    reg_5  <= 1'b0;
    counter_0  <= 1'b0;
    counter_1  <= 1'b0;
    counter_2  <= 1'b0;
    counter_3  <= 1'b0;
    counter_4  <= 1'b0;
    counter_5  <= 1'b0;
  end
endmodule


