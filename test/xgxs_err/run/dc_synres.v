
module XGXSSYNTH_ENC_8B10B ( bad_code, bad_disp, clk, encode_data_in, konstant, 
        rst, disp_out, encode_data_out, assertion_shengyushen );
  input [7:0] encode_data_in;
  output [9:0] encode_data_out;
  input bad_code, bad_disp, clk, konstant, rst;
  output disp_out, assertion_shengyushen;
  wire   n1, n2, n3, n4, n6, n7, n9, n11, n12, n14, n15, n16, n17, n18, n19,
         n20, n21, n22, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34,
         n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48,
         n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n61, n62, n63,
         n65, n66, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81,
         n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95,
         n96, n97, n98, n99, n100, n101, n102, n103, n104, n105, n106, n107,
         n108, n109, n110, n111, n112, n113, n114, n115, n116, n117, n118,
         n119, n120, n121, n122, n123, n124, n125, n126, n127, n128, n129,
         n130, n131, n132, n133, n134, n135, n136, n137, n138, n139, n140,
         n141, n142, n143, n144, n145, n146, n148, n149, n150, n151, n152,
         n153, n154, n155, n156, n160, n161, n162, n163, n164, n165, n166,
         n167, n168, n174, n175, n176, n177, n178, n179, n180, n181, n182,
         n183, n184, n185, n186, n187, n188, n189, n190, n191, n192, n193,
         n194, n195, n196, n197, n198, n199, n200, n201, n202, n203, n204,
         n205, n206, n208, n219, n220, n221, n223, n224, n229, n230, n231,
         n232, n235, n236, n239, n240, n241, n242, n243, n244, n245, n246,
         n247, n248, n249, n250, n251, n252, n253, n254, n255, n257, n262,
         n265, n267, n274, n281, n282, n283, n284, n285, n299, n300, U6_Z_0,
         U6_DATA1_0, U5_Z_0, U4_DATA2_0, U4_DATA2_1, U4_DATA2_2, U4_DATA2_3,
         U4_DATA2_4, U4_DATA2_5, U4_DATA2_6, U4_DATA2_7, U4_DATA2_8,
         U4_DATA2_9, n339, n344, n345, n347, n348, n350, n351, n354, n355,
         n356, n357, n358, n359, n360, n361, n362, n363, n364, n365, n366,
         n367, n368, n369, n370, n371, n406, n407, n408, n409, n410, n411,
         n412, n413, n441, n442, n443, n444, n445, n446, n447, n448, n449,
         n450, n451, n452, n453, n454, n455, n456, n457, n458, n459, n460,
         n461, n462, n463, n464, n465, n466, n467, n468, n469, n470, n471,
         n472, n473, n474, n475, n476, n477, n478, n479, n480, n481, n482,
         n483, n484;
  wire   [228:225] n;

  OR2 C747 ( .A(n344), .B(n345), .Z(n208) );
  OR2 C746 ( .A(n244), .B(bad_code), .Z(U4_DATA2_0) );
  AN2 C744 ( .A(n243), .B(n205), .Z(U4_DATA2_1) );
  OR2 C743 ( .A(n242), .B(bad_code), .Z(U4_DATA2_2) );
  OR2 C742 ( .A(n241), .B(bad_code), .Z(U4_DATA2_3) );
  OR2 C741 ( .A(n240), .B(bad_code), .Z(U4_DATA2_4) );
  OR2 C740 ( .A(n239), .B(bad_code), .Z(U4_DATA2_5) );
  AN2 C738 ( .A(n248), .B(n205), .Z(U4_DATA2_6) );
  OR2 C737 ( .A(n247), .B(bad_code), .Z(U4_DATA2_7) );
  AN2 C735 ( .A(n246), .B(n205), .Z(U4_DATA2_8) );
  AN2 C733 ( .A(n245), .B(n205), .Z(U4_DATA2_9) );
  OR2 C728 ( .A(n354), .B(n220), .Z(n2) );
  AN2 C727 ( .A(n232), .B(n2), .Z(n1) );
  OR2 C726 ( .A(n221), .B(n223), .Z(n4) );
  AN2 C724 ( .A(n364), .B(n4), .Z(n3) );
  OR2 C723 ( .A(n3), .B(n1), .Z(n219) );
  AN2 C720 ( .A(n224), .B(n231), .Z(n6) );
  AN2 C719 ( .A(n6), .B(n9), .Z(n223) );
  AN2 C716 ( .A(n9), .B(n358), .Z(n7) );
  OR2 C715 ( .A(n7), .B(n229), .Z(n[225]) );
  OR2 C714 ( .A(n235), .B(n356), .Z(n[227]) );
  AN2 C712 ( .A(n236), .B(n347), .Z(n[228]) );
  AN2 C711 ( .A(n230), .B(n62), .Z(n229) );
  AN2 C709 ( .A(n364), .B(n59), .Z(n12) );
  AN2 C708 ( .A(n232), .B(n361), .Z(n14) );
  OR2 C707 ( .A(n14), .B(n12), .Z(n11) );
  OR2 C706 ( .A(n11), .B(n231), .Z(n230) );
  IV I_56 ( .A(rst), .Z(n257) );
  OR2 C689 ( .A(n262), .B(n145), .Z(n15) );
  OR2 C686 ( .A(n108), .B(n106), .Z(n262) );
  OR2 C683 ( .A(n274), .B(n267), .Z(n16) );
  IV I_54 ( .A(n299), .Z(n18) );
  AN2 C680 ( .A(n18), .B(konstant), .Z(n17) );
  OR2 C679 ( .A(n111), .B(n267), .Z(n21) );
  AN2 C678 ( .A(U6_Z_0), .B(n21), .Z(n20) );
  AN2 C676 ( .A(n339), .B(n274), .Z(n22) );
  OR2 C675 ( .A(n22), .B(n20), .Z(n19) );
  OR2 C674 ( .A(n19), .B(n17), .Z(n255) );
  AN2 C673 ( .A(n104), .B(konstant), .Z(n24) );
  OR2 C672 ( .A(n87), .B(n85), .Z(n29) );
  OR2 C671 ( .A(n29), .B(n81), .Z(n28) );
  OR2 C670 ( .A(n28), .B(n77), .Z(n27) );
  OR2 C669 ( .A(n27), .B(n73), .Z(n26) );
  OR2 C668 ( .A(n26), .B(n72), .Z(n25) );
  OR2 C667 ( .A(n25), .B(n24), .Z(n267) );
  OR2 C660 ( .A(n102), .B(n100), .Z(n34) );
  OR2 C659 ( .A(n34), .B(n98), .Z(n33) );
  OR2 C658 ( .A(n33), .B(n96), .Z(n32) );
  OR2 C657 ( .A(n32), .B(n94), .Z(n31) );
  OR2 C656 ( .A(n31), .B(n91), .Z(n30) );
  OR2 C655 ( .A(n30), .B(n89), .Z(n274) );
  AN2 C648 ( .A(n104), .B(konstant), .Z(n35) );
  AN2 C644 ( .A(n43), .B(n42), .Z(n41) );
  AN2 C643 ( .A(n41), .B(n203), .Z(n40) );
  AN2 C641 ( .A(n122), .B(n45), .Z(n44) );
  OR2 C640 ( .A(n44), .B(n40), .Z(n39) );
  OR2 C639 ( .A(n39), .B(n118), .Z(n38) );
  OR2 C638 ( .A(n38), .B(n116), .Z(n37) );
  OR2 C637 ( .A(n37), .B(n72), .Z(n36) );
  OR2 C636 ( .A(n36), .B(n35), .Z(n281) );
  OR2 C635 ( .A(n132), .B(n127), .Z(n47) );
  OR2 C634 ( .A(n47), .B(n124), .Z(n46) );
  OR2 C632 ( .A(n48), .B(n46), .Z(n282) );
  AN2 C630 ( .A(encode_data_in[3]), .B(n51), .Z(n283) );
  OR2 C629 ( .A(encode_data_in[2]), .B(n141), .Z(n49) );
  OR2 C628 ( .A(n49), .B(n89), .Z(n284) );
  IV I_52 ( .A(n139), .Z(n51) );
  AN2 C626 ( .A(encode_data_in[1]), .B(n51), .Z(n50) );
  OR2 C625 ( .A(n50), .B(n141), .Z(n285) );
  OR2 C612 ( .A(n104), .B(n300), .Z(n299) );
  OR2 C611 ( .A(n85), .B(n81), .Z(n53) );
  OR2 C610 ( .A(n53), .B(n77), .Z(n52) );
  OR2 C609 ( .A(n52), .B(n73), .Z(n300) );
  OR2 C607 ( .A(n193), .B(n183), .Z(n57) );
  OR2 C606 ( .A(n57), .B(n174), .Z(n56) );
  AN2 C605 ( .A(konstant), .B(n56), .Z(n55) );
  OR2 C604 ( .A(n204), .B(n55), .Z(n54) );
  AN2 C603 ( .A(n206), .B(n205), .Z(n58) );
  AN2 C602 ( .A(n58), .B(n54), .Z(assertion_shengyushen) );
  AN2 C596 ( .A(n239), .B(n240), .Z(n59) );
  OR2 C594 ( .A(n239), .B(n240), .Z(n61) );
  AN2 C593 ( .A(n[226]), .B(n63), .Z(n62) );
  AN2 C592 ( .A(n235), .B(n236), .Z(n63) );
  OR2 C590 ( .A(n[226]), .B(n66), .Z(n65) );
  OR2 C589 ( .A(n357), .B(n355), .Z(n66) );
  OR2 C585 ( .A(n[226]), .B(n71), .Z(n70) );
  OR2 C584 ( .A(n235), .B(n236), .Z(n71) );
  AN2 C539 ( .A(encode_data_in[4]), .B(n139), .Z(n72) );
  IV I_46 ( .A(n74), .Z(n73) );
  OR2 C534 ( .A(n203), .B(n75), .Z(n74) );
  OR2 C533 ( .A(n202), .B(n76), .Z(n75) );
  OR2 C532 ( .A(n201), .B(n130), .Z(n76) );
  IV I_45 ( .A(n78), .Z(n77) );
  OR2 C525 ( .A(n203), .B(n79), .Z(n78) );
  OR2 C524 ( .A(n202), .B(n80), .Z(n79) );
  OR2 C523 ( .A(n201), .B(n135), .Z(n80) );
  IV I_44 ( .A(n82), .Z(n81) );
  OR2 C516 ( .A(n203), .B(n83), .Z(n82) );
  OR2 C515 ( .A(n202), .B(n84), .Z(n83) );
  OR2 C514 ( .A(encode_data_in[2]), .B(n115), .Z(n84) );
  IV I_43 ( .A(n86), .Z(n85) );
  OR2 C507 ( .A(n203), .B(n113), .Z(n86) );
  IV I_42 ( .A(n88), .Z(n87) );
  OR2 C498 ( .A(n203), .B(n142), .Z(n88) );
  IV I_41 ( .A(n90), .Z(n89) );
  OR2 C492 ( .A(n203), .B(n138), .Z(n90) );
  IV I_40 ( .A(n92), .Z(n91) );
  OR2 C485 ( .A(encode_data_in[4]), .B(n93), .Z(n92) );
  OR2 C484 ( .A(n202), .B(n114), .Z(n93) );
  IV I_39 ( .A(n95), .Z(n94) );
  OR2 C476 ( .A(encode_data_in[4]), .B(n138), .Z(n95) );
  IV I_38 ( .A(n97), .Z(n96) );
  OR2 C470 ( .A(encode_data_in[4]), .B(n125), .Z(n97) );
  IV I_37 ( .A(n99), .Z(n98) );
  OR2 C464 ( .A(encode_data_in[4]), .B(n128), .Z(n99) );
  IV I_36 ( .A(n101), .Z(n100) );
  OR2 C458 ( .A(encode_data_in[4]), .B(n133), .Z(n101) );
  IV I_35 ( .A(n103), .Z(n102) );
  OR2 C452 ( .A(encode_data_in[4]), .B(n142), .Z(n103) );
  IV I_34 ( .A(n105), .Z(n104) );
  OR2 C447 ( .A(n203), .B(n120), .Z(n105) );
  IV I_33 ( .A(n107), .Z(n106) );
  OR2 C439 ( .A(n182), .B(n110), .Z(n107) );
  IV I_32 ( .A(n109), .Z(n108) );
  OR2 C435 ( .A(encode_data_in[7]), .B(n110), .Z(n109) );
  OR2 C434 ( .A(encode_data_in[6]), .B(encode_data_in[5]), .Z(n110) );
  IV I_31 ( .A(n112), .Z(n111) );
  OR2 C432 ( .A(encode_data_in[4]), .B(n113), .Z(n112) );
  OR2 C431 ( .A(encode_data_in[3]), .B(n114), .Z(n113) );
  OR2 C430 ( .A(n201), .B(n115), .Z(n114) );
  OR2 C429 ( .A(n131), .B(n136), .Z(n115) );
  IV I_30 ( .A(n117), .Z(n116) );
  OR2 C424 ( .A(n203), .B(n125), .Z(n117) );
  IV I_29 ( .A(n119), .Z(n118) );
  OR2 C417 ( .A(encode_data_in[4]), .B(n120), .Z(n119) );
  OR2 C416 ( .A(n202), .B(n126), .Z(n120) );
  AN2 C411 ( .A(encode_data_in[1]), .B(encode_data_in[0]), .Z(n121) );
  IV I_28 ( .A(n123), .Z(n122) );
  OR2 C409 ( .A(encode_data_in[3]), .B(encode_data_in[2]), .Z(n123) );
  IV I_27 ( .A(n125), .Z(n124) );
  OR2 C407 ( .A(encode_data_in[3]), .B(n126), .Z(n125) );
  OR2 C406 ( .A(n201), .B(n144), .Z(n126) );
  IV I_26 ( .A(n128), .Z(n127) );
  OR2 C402 ( .A(encode_data_in[3]), .B(n129), .Z(n128) );
  OR2 C401 ( .A(encode_data_in[2]), .B(n130), .Z(n129) );
  OR2 C400 ( .A(n131), .B(encode_data_in[0]), .Z(n130) );
  IV I_25 ( .A(encode_data_in[1]), .Z(n131) );
  IV I_24 ( .A(n133), .Z(n132) );
  OR2 C397 ( .A(encode_data_in[3]), .B(n134), .Z(n133) );
  OR2 C396 ( .A(encode_data_in[2]), .B(n135), .Z(n134) );
  OR2 C395 ( .A(encode_data_in[1]), .B(n136), .Z(n135) );
  IV I_23 ( .A(encode_data_in[0]), .Z(n136) );
  IV I_22 ( .A(n138), .Z(n137) );
  OR2 C392 ( .A(n202), .B(n143), .Z(n138) );
  AN2 C388 ( .A(encode_data_in[3]), .B(n140), .Z(n139) );
  AN2 C387 ( .A(encode_data_in[2]), .B(n121), .Z(n140) );
  IV I_21 ( .A(n142), .Z(n141) );
  OR2 C384 ( .A(encode_data_in[3]), .B(n143), .Z(n142) );
  OR2 C383 ( .A(encode_data_in[2]), .B(n144), .Z(n143) );
  OR2 C382 ( .A(encode_data_in[1]), .B(encode_data_in[0]), .Z(n144) );
  AN2 C381 ( .A(encode_data_in[7]), .B(n146), .Z(n145) );
  AN2 C380 ( .A(encode_data_in[6]), .B(encode_data_in[5]), .Z(n146) );
  OR2 C377 ( .A(U4_DATA2_0), .B(n149), .Z(n148) );
  OR2 C376 ( .A(U4_DATA2_1), .B(n150), .Z(n149) );
  OR2 C375 ( .A(n359), .B(n151), .Z(n150) );
  OR2 C374 ( .A(n360), .B(n152), .Z(n151) );
  OR2 C373 ( .A(n362), .B(n153), .Z(n152) );
  OR2 C372 ( .A(n363), .B(n154), .Z(n153) );
  OR2 C371 ( .A(U4_DATA2_6), .B(n155), .Z(n154) );
  OR2 C370 ( .A(U4_DATA2_7), .B(n156), .Z(n155) );
  OR2 C369 ( .A(n350), .B(n348), .Z(n156) );
  OR2 C361 ( .A(U4_DATA2_0), .B(n161), .Z(n160) );
  OR2 C360 ( .A(U4_DATA2_1), .B(n162), .Z(n161) );
  OR2 C359 ( .A(n359), .B(n163), .Z(n162) );
  OR2 C358 ( .A(n360), .B(n164), .Z(n163) );
  OR2 C357 ( .A(n362), .B(n165), .Z(n164) );
  OR2 C356 ( .A(n363), .B(n166), .Z(n165) );
  OR2 C355 ( .A(U4_DATA2_6), .B(n167), .Z(n166) );
  OR2 C354 ( .A(n351), .B(n168), .Z(n167) );
  OR2 C353 ( .A(U4_DATA2_8), .B(U4_DATA2_9), .Z(n168) );
  IV I_11 ( .A(n175), .Z(n174) );
  OR2 C346 ( .A(encode_data_in[0]), .B(n176), .Z(n175) );
  OR2 C345 ( .A(encode_data_in[1]), .B(n177), .Z(n176) );
  OR2 C344 ( .A(n201), .B(n178), .Z(n177) );
  OR2 C343 ( .A(n202), .B(n179), .Z(n178) );
  OR2 C342 ( .A(n203), .B(n180), .Z(n179) );
  OR2 C341 ( .A(n191), .B(n181), .Z(n180) );
  OR2 C340 ( .A(encode_data_in[6]), .B(n182), .Z(n181) );
  IV I_10 ( .A(encode_data_in[7]), .Z(n182) );
  IV I_9 ( .A(n184), .Z(n183) );
  OR2 C333 ( .A(encode_data_in[0]), .B(n185), .Z(n184) );
  OR2 C332 ( .A(encode_data_in[1]), .B(n186), .Z(n185) );
  OR2 C331 ( .A(n201), .B(n187), .Z(n186) );
  OR2 C330 ( .A(n202), .B(n188), .Z(n187) );
  OR2 C329 ( .A(n203), .B(n189), .Z(n188) );
  OR2 C328 ( .A(n191), .B(n190), .Z(n189) );
  OR2 C327 ( .A(n192), .B(encode_data_in[7]), .Z(n190) );
  IV I_8 ( .A(encode_data_in[5]), .Z(n191) );
  IV I_7 ( .A(encode_data_in[6]), .Z(n192) );
  IV I_6 ( .A(n194), .Z(n193) );
  OR2 C320 ( .A(encode_data_in[0]), .B(n195), .Z(n194) );
  OR2 C319 ( .A(encode_data_in[1]), .B(n196), .Z(n195) );
  OR2 C318 ( .A(n201), .B(n197), .Z(n196) );
  OR2 C317 ( .A(n202), .B(n198), .Z(n197) );
  OR2 C316 ( .A(n203), .B(n199), .Z(n198) );
  OR2 C315 ( .A(encode_data_in[5]), .B(n200), .Z(n199) );
  OR2 C314 ( .A(encode_data_in[6]), .B(encode_data_in[7]), .Z(n200) );
  IV I_5 ( .A(encode_data_in[2]), .Z(n201) );
  IV I_4 ( .A(encode_data_in[3]), .Z(n202) );
  IV I_3 ( .A(encode_data_in[4]), .Z(n203) );
  IV I_2 ( .A(konstant), .Z(n204) );
  IV I_1 ( .A(bad_code), .Z(n205) );
  IV I_0 ( .A(bad_disp), .Z(n206) );
  FD1 disp_lat_reg ( .D(U5_Z_0), .CP(clk), .Q(U6_DATA1_0) );
  FD1 konstant_latch_reg ( .D(konstant), .CP(clk), .Q(n231) );
  FD1 ip_data_latch_reg_2_ ( .D(encode_data_in[5]), .CP(clk), .Q(n236) );
  FD1 ip_data_latch_reg_1_ ( .D(encode_data_in[6]), .CP(clk), .Q(n235) );
  FD1 ip_data_latch_reg_0_ ( .D(encode_data_in[7]), .CP(clk), .Q(n[226]) );
  FD1 disp_lat_fix_latch_reg ( .D(U6_Z_0), .CP(clk), .Q(disp_out) );
  FD1 data_out_latch_reg_5_ ( .D(n254), .CP(clk), .Q(n244) );
  FD1 data_out_latch_reg_4_ ( .D(n253), .CP(clk), .Q(n243) );
  FD1 data_out_latch_reg_3_ ( .D(n252), .CP(clk), .Q(n242) );
  FD1 data_out_latch_reg_2_ ( .D(n251), .CP(clk), .Q(n241) );
  FD1 data_out_latch_reg_1_ ( .D(n250), .CP(clk), .Q(n240) );
  FD1 data_out_latch_reg_0_ ( .D(n249), .CP(clk), .Q(n239) );
  FD1 kx_latch_reg ( .D(n104), .CP(clk), .Q(n224) );
  FD1 plus34_latch_reg ( .D(n262), .CP(clk), .Q(n221) );
  FD1 minus34b_latch_reg ( .D(n145), .CP(clk), .Q(n220) );
  FD1 i_disp_latch_reg ( .D(n265), .CP(clk), .Q(n232) );
  IV U35 ( .A(n409), .Z(n365) );
  IV U36 ( .A(n407), .Z(n366) );
  IV U37 ( .A(encode_data_in[4]), .Z(n367) );
  IV U38 ( .A(encode_data_in[3]), .Z(n368) );
  IV U39 ( .A(encode_data_in[2]), .Z(n369) );
  IV U40 ( .A(n411), .Z(n370) );
  IV U41 ( .A(encode_data_in[0]), .Z(n371) );
  OR2 U45 ( .A(n406), .B(n366), .Z(n48) );
  OR2 U46 ( .A(n367), .B(n137), .Z(n407) );
  AN2 U47 ( .A(n137), .B(n367), .Z(n406) );
  OR2 U48 ( .A(n408), .B(n365), .Z(n45) );
  OR2 U49 ( .A(n367), .B(n121), .Z(n409) );
  AN2 U50 ( .A(n121), .B(n367), .Z(n408) );
  OR2 U51 ( .A(n410), .B(n370), .Z(n43) );
  OR2 U52 ( .A(n371), .B(encode_data_in[1]), .Z(n411) );
  AN2 U53 ( .A(encode_data_in[1]), .B(n371), .Z(n410) );
  OR2 U54 ( .A(n412), .B(n413), .Z(n42) );
  AN2 U55 ( .A(encode_data_in[2]), .B(n368), .Z(n413) );
  AN2 U56 ( .A(encode_data_in[3]), .B(n369), .Z(n412) );
  OR2 U107 ( .A(n441), .B(n442), .Z(n9) );
  AN2 U108 ( .A(n235), .B(n355), .Z(n442) );
  AN2 U109 ( .A(n236), .B(n357), .Z(n441) );
  IV U110 ( .A(n232), .Z(n364) );
  IV U111 ( .A(U4_DATA2_5), .Z(n363) );
  IV U112 ( .A(U4_DATA2_4), .Z(n362) );
  IV U113 ( .A(n61), .Z(n361) );
  IV U114 ( .A(U4_DATA2_3), .Z(n360) );
  IV U115 ( .A(U4_DATA2_2), .Z(n359) );
  IV U116 ( .A(n235), .Z(n357) );
  IV U117 ( .A(n70), .Z(n356) );
  IV U118 ( .A(n236), .Z(n355) );
  IV U119 ( .A(n65), .Z(n354) );
  IV U120 ( .A(U4_DATA2_7), .Z(n351) );
  IV U121 ( .A(U4_DATA2_8), .Z(n350) );
  IV U122 ( .A(U4_DATA2_9), .Z(n348) );
  IV U123 ( .A(n229), .Z(n347) );
  IV U124 ( .A(n148), .Z(n345) );
  IV U125 ( .A(n160), .Z(n344) );
  OR2 U126 ( .A(n443), .B(n444), .Z(n254) );
  AN2 U127 ( .A(n371), .B(n255), .Z(n444) );
  AN2 U128 ( .A(encode_data_in[0]), .B(n445), .Z(n443) );
  OR2 U129 ( .A(n446), .B(n447), .Z(n253) );
  AN2 U130 ( .A(n255), .B(n448), .Z(n447) );
  IV U131 ( .A(n285), .Z(n448) );
  AN2 U132 ( .A(n285), .B(n445), .Z(n446) );
  OR2 U133 ( .A(n449), .B(n450), .Z(n252) );
  AN2 U134 ( .A(n255), .B(n451), .Z(n450) );
  IV U135 ( .A(n284), .Z(n451) );
  AN2 U136 ( .A(n284), .B(n445), .Z(n449) );
  OR2 U137 ( .A(n452), .B(n453), .Z(n251) );
  AN2 U138 ( .A(n255), .B(n454), .Z(n453) );
  IV U139 ( .A(n283), .Z(n454) );
  AN2 U140 ( .A(n283), .B(n445), .Z(n452) );
  OR2 U141 ( .A(n455), .B(n456), .Z(n250) );
  AN2 U142 ( .A(n255), .B(n457), .Z(n456) );
  IV U143 ( .A(n282), .Z(n457) );
  AN2 U144 ( .A(n282), .B(n445), .Z(n455) );
  OR2 U145 ( .A(n458), .B(n459), .Z(n249) );
  AN2 U146 ( .A(n255), .B(n460), .Z(n459) );
  IV U147 ( .A(n281), .Z(n460) );
  AN2 U148 ( .A(n281), .B(n445), .Z(n458) );
  IV U149 ( .A(n255), .Z(n445) );
  OR2 U150 ( .A(n461), .B(n462), .Z(n248) );
  AN2 U151 ( .A(n219), .B(n463), .Z(n462) );
  IV U152 ( .A(n[228]), .Z(n463) );
  AN2 U153 ( .A(n[228]), .B(n464), .Z(n461) );
  OR2 U154 ( .A(n465), .B(n466), .Z(n247) );
  AN2 U155 ( .A(n219), .B(n467), .Z(n466) );
  IV U156 ( .A(n[227]), .Z(n467) );
  AN2 U157 ( .A(n[227]), .B(n464), .Z(n465) );
  OR2 U158 ( .A(n468), .B(n469), .Z(n246) );
  AN2 U159 ( .A(n219), .B(n358), .Z(n469) );
  IV U160 ( .A(n[226]), .Z(n358) );
  AN2 U161 ( .A(n[226]), .B(n464), .Z(n468) );
  OR2 U162 ( .A(n470), .B(n471), .Z(n245) );
  AN2 U163 ( .A(n219), .B(n472), .Z(n471) );
  IV U164 ( .A(n[225]), .Z(n472) );
  AN2 U165 ( .A(n[225]), .B(n464), .Z(n470) );
  IV U166 ( .A(n219), .Z(n464) );
  AN2 U167 ( .A(n257), .B(n473), .Z(U5_Z_0) );
  OR2 U168 ( .A(n474), .B(n475), .Z(n473) );
  AN2 U169 ( .A(n265), .B(n476), .Z(n475) );
  IV U170 ( .A(n15), .Z(n476) );
  IV U171 ( .A(n477), .Z(n265) );
  AN2 U172 ( .A(n15), .B(n477), .Z(n474) );
  AN2 U173 ( .A(n478), .B(n479), .Z(n477) );
  OR2 U174 ( .A(n339), .B(n16), .Z(n479) );
  IV U175 ( .A(U6_Z_0), .Z(n339) );
  OR2 U176 ( .A(n480), .B(U6_Z_0), .Z(n478) );
  OR2 U177 ( .A(n481), .B(n482), .Z(U6_Z_0) );
  AN2 U178 ( .A(n206), .B(U6_DATA1_0), .Z(n482) );
  AN2 U179 ( .A(bad_disp), .B(n483), .Z(n481) );
  IV U180 ( .A(U6_DATA1_0), .Z(n483) );
  IV U181 ( .A(n16), .Z(n480) );
  AN2 U182 ( .A(U4_DATA2_9), .B(n484), .Z(encode_data_out[9]) );
  AN2 U183 ( .A(U4_DATA2_8), .B(n484), .Z(encode_data_out[8]) );
  AN2 U184 ( .A(U4_DATA2_7), .B(n484), .Z(encode_data_out[7]) );
  AN2 U185 ( .A(U4_DATA2_6), .B(n484), .Z(encode_data_out[6]) );
  AN2 U186 ( .A(U4_DATA2_5), .B(n484), .Z(encode_data_out[5]) );
  AN2 U187 ( .A(U4_DATA2_4), .B(n484), .Z(encode_data_out[4]) );
  AN2 U188 ( .A(U4_DATA2_3), .B(n484), .Z(encode_data_out[3]) );
  AN2 U189 ( .A(U4_DATA2_2), .B(n484), .Z(encode_data_out[2]) );
  AN2 U190 ( .A(U4_DATA2_1), .B(n484), .Z(encode_data_out[1]) );
  IV U191 ( .A(n208), .Z(n484) );
  OR2 U192 ( .A(U4_DATA2_0), .B(n208), .Z(encode_data_out[0]) );
endmodule
