
module XGXSSYNTH_ENC_8B10B ( bad_code, bad_disp, clk, encode_data_in, konstant, 
        rst, disp_out, encode_data_out, assertion_shengyushen );
  input [7:0] encode_data_in;
  output [9:0] encode_data_out;
  input bad_code, bad_disp, clk, konstant, rst;
  output disp_out, assertion_shengyushen;
  wire   n1, n2, n3, n4, n6, n7, n9, n11, n12, n14, n15, n16, n17, n18, n19,
         n20, n21, n22, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34,
         n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48,
         n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62,
         n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76,
         n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90,
         n91, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102, n103, n104,
         n105, n106, n107, n108, n109, n110, n111, n112, n113, n114, n115,
         n116, n117, n118, n119, n120, n121, n122, n123, n124, n125, n126,
         n127, n128, n129, n130, n131, n132, n133, n134, n135, n136, n137,
         n138, n140, n141, n145, n146, n147, n148, n149, n150, n151, n152,
         n153, n154, n155, n156, n157, n158, n159, n160, n161, n162, n163,
         n164, n165, n166, n167, n168, n169, n170, n171, n172, n173, n174,
         n175, n176, n177, n178, n179, n180, n181, n182, n184, n185, n190,
         n191, n192, n193, n196, n197, n200, n201, n202, n203, n204, n205,
         n206, n207, n208, n209, n210, n211, n212, n213, n214, n215, n216,
         n218, n223, n226, n228, n235, n242, n243, n244, n245, n246, n260,
         n261, U5_Z_0, U5_DATA1_0, U4_Z_0, n299, n304, n308, n309, n310, n311,
         n312, n313, n314, n315, n316, n317, n318, n319, n320, n321, n356,
         n357, n358, n359, n360, n361, n362, n363, n391, n392, n393, n394,
         n395, n396, n397, n398, n399, n400, n401, n402, n403, n404, n405,
         n406, n407, n408, n409, n410, n411, n412, n413, n414, n415, n416,
         n417, n418, n419, n420, n421, n422, n423, n424, n425, n426, n427,
         n428, n429, n430, n431, n432, n433;
  wire   [189:186] n;

  OR2 C698 ( .A(n205), .B(bad_code), .Z(encode_data_out[0]) );
  AN2 C696 ( .A(n204), .B(n178), .Z(encode_data_out[1]) );
  OR2 C695 ( .A(n203), .B(bad_code), .Z(encode_data_out[2]) );
  OR2 C694 ( .A(n202), .B(bad_code), .Z(encode_data_out[3]) );
  OR2 C693 ( .A(n201), .B(bad_code), .Z(encode_data_out[4]) );
  OR2 C692 ( .A(n200), .B(bad_code), .Z(encode_data_out[5]) );
  AN2 C690 ( .A(n209), .B(n178), .Z(encode_data_out[6]) );
  OR2 C689 ( .A(n208), .B(bad_code), .Z(encode_data_out[7]) );
  AN2 C687 ( .A(n207), .B(n178), .Z(encode_data_out[8]) );
  AN2 C685 ( .A(n206), .B(n178), .Z(encode_data_out[9]) );
  OR2 C680 ( .A(n308), .B(n181), .Z(n2) );
  AN2 C679 ( .A(n193), .B(n2), .Z(n1) );
  OR2 C678 ( .A(n182), .B(n184), .Z(n4) );
  AN2 C676 ( .A(n314), .B(n4), .Z(n3) );
  OR2 C675 ( .A(n3), .B(n1), .Z(n180) );
  AN2 C672 ( .A(n185), .B(n192), .Z(n6) );
  AN2 C671 ( .A(n6), .B(n9), .Z(n184) );
  AN2 C668 ( .A(n9), .B(n312), .Z(n7) );
  OR2 C667 ( .A(n7), .B(n190), .Z(n[186]) );
  OR2 C666 ( .A(n196), .B(n310), .Z(n[188]) );
  AN2 C664 ( .A(n197), .B(n304), .Z(n[189]) );
  AN2 C663 ( .A(n191), .B(n101), .Z(n190) );
  AN2 C661 ( .A(n314), .B(n91), .Z(n12) );
  AN2 C660 ( .A(n193), .B(n313), .Z(n14) );
  OR2 C659 ( .A(n14), .B(n12), .Z(n11) );
  OR2 C658 ( .A(n11), .B(n192), .Z(n191) );
  IV I_47 ( .A(rst), .Z(n218) );
  OR2 C641 ( .A(n223), .B(n137), .Z(n15) );
  OR2 C638 ( .A(n98), .B(n96), .Z(n223) );
  OR2 C635 ( .A(n235), .B(n228), .Z(n16) );
  IV I_45 ( .A(n260), .Z(n18) );
  AN2 C632 ( .A(n18), .B(konstant), .Z(n17) );
  OR2 C631 ( .A(n103), .B(n228), .Z(n21) );
  AN2 C630 ( .A(U5_Z_0), .B(n21), .Z(n20) );
  AN2 C628 ( .A(n299), .B(n235), .Z(n22) );
  OR2 C627 ( .A(n22), .B(n20), .Z(n19) );
  OR2 C626 ( .A(n19), .B(n17), .Z(n216) );
  AN2 C625 ( .A(n94), .B(konstant), .Z(n24) );
  OR2 C624 ( .A(n74), .B(n72), .Z(n29) );
  OR2 C623 ( .A(n29), .B(n68), .Z(n28) );
  OR2 C622 ( .A(n28), .B(n64), .Z(n27) );
  OR2 C621 ( .A(n27), .B(n60), .Z(n26) );
  OR2 C620 ( .A(n26), .B(n59), .Z(n25) );
  OR2 C619 ( .A(n25), .B(n24), .Z(n228) );
  OR2 C612 ( .A(n89), .B(n87), .Z(n34) );
  OR2 C611 ( .A(n34), .B(n85), .Z(n33) );
  OR2 C610 ( .A(n33), .B(n83), .Z(n32) );
  OR2 C609 ( .A(n32), .B(n81), .Z(n31) );
  OR2 C608 ( .A(n31), .B(n78), .Z(n30) );
  OR2 C607 ( .A(n30), .B(n76), .Z(n235) );
  AN2 C600 ( .A(n94), .B(konstant), .Z(n35) );
  AN2 C596 ( .A(n43), .B(n42), .Z(n41) );
  AN2 C595 ( .A(n41), .B(n176), .Z(n40) );
  AN2 C593 ( .A(n114), .B(n45), .Z(n44) );
  OR2 C592 ( .A(n44), .B(n40), .Z(n39) );
  OR2 C591 ( .A(n39), .B(n110), .Z(n38) );
  OR2 C590 ( .A(n38), .B(n108), .Z(n37) );
  OR2 C589 ( .A(n37), .B(n59), .Z(n36) );
  OR2 C588 ( .A(n36), .B(n35), .Z(n242) );
  OR2 C587 ( .A(n124), .B(n119), .Z(n47) );
  OR2 C586 ( .A(n47), .B(n116), .Z(n46) );
  OR2 C584 ( .A(n48), .B(n46), .Z(n243) );
  AN2 C582 ( .A(encode_data_in[3]), .B(n51), .Z(n244) );
  OR2 C581 ( .A(encode_data_in[2]), .B(n133), .Z(n49) );
  OR2 C580 ( .A(n49), .B(n76), .Z(n245) );
  IV I_43 ( .A(n131), .Z(n51) );
  AN2 C578 ( .A(encode_data_in[1]), .B(n51), .Z(n50) );
  OR2 C577 ( .A(n50), .B(n133), .Z(n246) );
  OR2 C564 ( .A(n94), .B(n261), .Z(n260) );
  OR2 C563 ( .A(n72), .B(n68), .Z(n53) );
  OR2 C562 ( .A(n53), .B(n64), .Z(n52) );
  OR2 C561 ( .A(n52), .B(n60), .Z(n261) );
  OR2 C559 ( .A(n166), .B(n156), .Z(n57) );
  OR2 C558 ( .A(n57), .B(n147), .Z(n56) );
  AN2 C557 ( .A(konstant), .B(n56), .Z(n55) );
  OR2 C556 ( .A(n177), .B(n55), .Z(n54) );
  AN2 C555 ( .A(n179), .B(n178), .Z(n58) );
  AN2 C554 ( .A(n58), .B(n54), .Z(assertion_shengyushen) );
  AN2 C505 ( .A(encode_data_in[4]), .B(n131), .Z(n59) );
  IV I_42 ( .A(n61), .Z(n60) );
  OR2 C500 ( .A(n176), .B(n62), .Z(n61) );
  OR2 C499 ( .A(n175), .B(n63), .Z(n62) );
  OR2 C498 ( .A(n174), .B(n122), .Z(n63) );
  IV I_41 ( .A(n65), .Z(n64) );
  OR2 C491 ( .A(n176), .B(n66), .Z(n65) );
  OR2 C490 ( .A(n175), .B(n67), .Z(n66) );
  OR2 C489 ( .A(n174), .B(n127), .Z(n67) );
  IV I_40 ( .A(n69), .Z(n68) );
  OR2 C482 ( .A(n176), .B(n70), .Z(n69) );
  OR2 C481 ( .A(n175), .B(n71), .Z(n70) );
  OR2 C480 ( .A(encode_data_in[2]), .B(n107), .Z(n71) );
  IV I_39 ( .A(n73), .Z(n72) );
  OR2 C473 ( .A(n176), .B(n105), .Z(n73) );
  IV I_38 ( .A(n75), .Z(n74) );
  OR2 C464 ( .A(n176), .B(n134), .Z(n75) );
  IV I_37 ( .A(n77), .Z(n76) );
  OR2 C458 ( .A(n176), .B(n130), .Z(n77) );
  IV I_36 ( .A(n79), .Z(n78) );
  OR2 C451 ( .A(encode_data_in[4]), .B(n80), .Z(n79) );
  OR2 C450 ( .A(n175), .B(n106), .Z(n80) );
  IV I_35 ( .A(n82), .Z(n81) );
  OR2 C442 ( .A(encode_data_in[4]), .B(n130), .Z(n82) );
  IV I_34 ( .A(n84), .Z(n83) );
  OR2 C436 ( .A(encode_data_in[4]), .B(n117), .Z(n84) );
  IV I_33 ( .A(n86), .Z(n85) );
  OR2 C430 ( .A(encode_data_in[4]), .B(n120), .Z(n86) );
  IV I_32 ( .A(n88), .Z(n87) );
  OR2 C424 ( .A(encode_data_in[4]), .B(n125), .Z(n88) );
  IV I_31 ( .A(n90), .Z(n89) );
  OR2 C418 ( .A(encode_data_in[4]), .B(n134), .Z(n90) );
  AN2 C414 ( .A(n200), .B(n201), .Z(n91) );
  OR2 C412 ( .A(n200), .B(n201), .Z(n93) );
  IV I_29 ( .A(n95), .Z(n94) );
  OR2 C410 ( .A(n176), .B(n112), .Z(n95) );
  IV I_28 ( .A(n97), .Z(n96) );
  OR2 C402 ( .A(n155), .B(n100), .Z(n97) );
  IV I_27 ( .A(n99), .Z(n98) );
  OR2 C398 ( .A(encode_data_in[7]), .B(n100), .Z(n99) );
  OR2 C397 ( .A(encode_data_in[6]), .B(encode_data_in[5]), .Z(n100) );
  AN2 C396 ( .A(n[187]), .B(n102), .Z(n101) );
  AN2 C395 ( .A(n196), .B(n197), .Z(n102) );
  IV I_26 ( .A(n104), .Z(n103) );
  OR2 C393 ( .A(encode_data_in[4]), .B(n105), .Z(n104) );
  OR2 C392 ( .A(encode_data_in[3]), .B(n106), .Z(n105) );
  OR2 C391 ( .A(n174), .B(n107), .Z(n106) );
  OR2 C390 ( .A(n123), .B(n128), .Z(n107) );
  IV I_25 ( .A(n109), .Z(n108) );
  OR2 C385 ( .A(n176), .B(n117), .Z(n109) );
  IV I_24 ( .A(n111), .Z(n110) );
  OR2 C378 ( .A(encode_data_in[4]), .B(n112), .Z(n111) );
  OR2 C377 ( .A(n175), .B(n118), .Z(n112) );
  AN2 C372 ( .A(encode_data_in[1]), .B(encode_data_in[0]), .Z(n113) );
  IV I_23 ( .A(n115), .Z(n114) );
  OR2 C370 ( .A(encode_data_in[3]), .B(encode_data_in[2]), .Z(n115) );
  IV I_22 ( .A(n117), .Z(n116) );
  OR2 C368 ( .A(encode_data_in[3]), .B(n118), .Z(n117) );
  OR2 C367 ( .A(n174), .B(n136), .Z(n118) );
  IV I_21 ( .A(n120), .Z(n119) );
  OR2 C363 ( .A(encode_data_in[3]), .B(n121), .Z(n120) );
  OR2 C362 ( .A(encode_data_in[2]), .B(n122), .Z(n121) );
  OR2 C361 ( .A(n123), .B(encode_data_in[0]), .Z(n122) );
  IV I_20 ( .A(encode_data_in[1]), .Z(n123) );
  IV I_19 ( .A(n125), .Z(n124) );
  OR2 C358 ( .A(encode_data_in[3]), .B(n126), .Z(n125) );
  OR2 C357 ( .A(encode_data_in[2]), .B(n127), .Z(n126) );
  OR2 C356 ( .A(encode_data_in[1]), .B(n128), .Z(n127) );
  IV I_18 ( .A(encode_data_in[0]), .Z(n128) );
  IV I_17 ( .A(n130), .Z(n129) );
  OR2 C353 ( .A(n175), .B(n135), .Z(n130) );
  AN2 C349 ( .A(encode_data_in[3]), .B(n132), .Z(n131) );
  AN2 C348 ( .A(encode_data_in[2]), .B(n113), .Z(n132) );
  IV I_16 ( .A(n134), .Z(n133) );
  OR2 C345 ( .A(encode_data_in[3]), .B(n135), .Z(n134) );
  OR2 C344 ( .A(encode_data_in[2]), .B(n136), .Z(n135) );
  OR2 C343 ( .A(encode_data_in[1]), .B(encode_data_in[0]), .Z(n136) );
  AN2 C342 ( .A(encode_data_in[7]), .B(n138), .Z(n137) );
  AN2 C341 ( .A(encode_data_in[6]), .B(encode_data_in[5]), .Z(n138) );
  OR2 C338 ( .A(n[187]), .B(n141), .Z(n140) );
  OR2 C337 ( .A(n311), .B(n309), .Z(n141) );
  OR2 C333 ( .A(n[187]), .B(n146), .Z(n145) );
  OR2 C332 ( .A(n196), .B(n197), .Z(n146) );
  IV I_11 ( .A(n148), .Z(n147) );
  OR2 C330 ( .A(encode_data_in[0]), .B(n149), .Z(n148) );
  OR2 C329 ( .A(encode_data_in[1]), .B(n150), .Z(n149) );
  OR2 C328 ( .A(n174), .B(n151), .Z(n150) );
  OR2 C327 ( .A(n175), .B(n152), .Z(n151) );
  OR2 C326 ( .A(n176), .B(n153), .Z(n152) );
  OR2 C325 ( .A(n164), .B(n154), .Z(n153) );
  OR2 C324 ( .A(encode_data_in[6]), .B(n155), .Z(n154) );
  IV I_10 ( .A(encode_data_in[7]), .Z(n155) );
  IV I_9 ( .A(n157), .Z(n156) );
  OR2 C317 ( .A(encode_data_in[0]), .B(n158), .Z(n157) );
  OR2 C316 ( .A(encode_data_in[1]), .B(n159), .Z(n158) );
  OR2 C315 ( .A(n174), .B(n160), .Z(n159) );
  OR2 C314 ( .A(n175), .B(n161), .Z(n160) );
  OR2 C313 ( .A(n176), .B(n162), .Z(n161) );
  OR2 C312 ( .A(n164), .B(n163), .Z(n162) );
  OR2 C311 ( .A(n165), .B(encode_data_in[7]), .Z(n163) );
  IV I_8 ( .A(encode_data_in[5]), .Z(n164) );
  IV I_7 ( .A(encode_data_in[6]), .Z(n165) );
  IV I_6 ( .A(n167), .Z(n166) );
  OR2 C304 ( .A(encode_data_in[0]), .B(n168), .Z(n167) );
  OR2 C303 ( .A(encode_data_in[1]), .B(n169), .Z(n168) );
  OR2 C302 ( .A(n174), .B(n170), .Z(n169) );
  OR2 C301 ( .A(n175), .B(n171), .Z(n170) );
  OR2 C300 ( .A(n176), .B(n172), .Z(n171) );
  OR2 C299 ( .A(encode_data_in[5]), .B(n173), .Z(n172) );
  OR2 C298 ( .A(encode_data_in[6]), .B(encode_data_in[7]), .Z(n173) );
  IV I_5 ( .A(encode_data_in[2]), .Z(n174) );
  IV I_4 ( .A(encode_data_in[3]), .Z(n175) );
  IV I_3 ( .A(encode_data_in[4]), .Z(n176) );
  IV I_2 ( .A(konstant), .Z(n177) );
  IV I_1 ( .A(bad_code), .Z(n178) );
  IV I_0 ( .A(bad_disp), .Z(n179) );
  FD1 disp_lat_reg ( .D(U4_Z_0), .CP(clk), .Q(U5_DATA1_0) );
  FD1 konstant_latch_reg ( .D(konstant), .CP(clk), .Q(n192) );
  FD1 ip_data_latch_reg_2_ ( .D(encode_data_in[5]), .CP(clk), .Q(n197) );
  FD1 ip_data_latch_reg_1_ ( .D(encode_data_in[6]), .CP(clk), .Q(n196) );
  FD1 ip_data_latch_reg_0_ ( .D(encode_data_in[7]), .CP(clk), .Q(n[187]) );
  FD1 disp_lat_fix_latch_reg ( .D(U5_Z_0), .CP(clk), .Q(disp_out) );
  FD1 data_out_latch_reg_5_ ( .D(n215), .CP(clk), .Q(n205) );
  FD1 data_out_latch_reg_4_ ( .D(n214), .CP(clk), .Q(n204) );
  FD1 data_out_latch_reg_3_ ( .D(n213), .CP(clk), .Q(n203) );
  FD1 data_out_latch_reg_2_ ( .D(n212), .CP(clk), .Q(n202) );
  FD1 data_out_latch_reg_1_ ( .D(n211), .CP(clk), .Q(n201) );
  FD1 data_out_latch_reg_0_ ( .D(n210), .CP(clk), .Q(n200) );
  FD1 kx_latch_reg ( .D(n94), .CP(clk), .Q(n185) );
  FD1 plus34_latch_reg ( .D(n223), .CP(clk), .Q(n182) );
  FD1 minus34b_latch_reg ( .D(n137), .CP(clk), .Q(n181) );
  FD1 i_disp_latch_reg ( .D(n226), .CP(clk), .Q(n193) );
  IV U25 ( .A(n359), .Z(n315) );
  IV U26 ( .A(n357), .Z(n316) );
  IV U27 ( .A(encode_data_in[4]), .Z(n317) );
  IV U28 ( .A(encode_data_in[3]), .Z(n318) );
  IV U29 ( .A(encode_data_in[2]), .Z(n319) );
  IV U30 ( .A(n361), .Z(n320) );
  IV U31 ( .A(encode_data_in[0]), .Z(n321) );
  OR2 U35 ( .A(n356), .B(n316), .Z(n48) );
  OR2 U36 ( .A(n317), .B(n129), .Z(n357) );
  AN2 U37 ( .A(n129), .B(n317), .Z(n356) );
  OR2 U38 ( .A(n358), .B(n315), .Z(n45) );
  OR2 U39 ( .A(n317), .B(n113), .Z(n359) );
  AN2 U40 ( .A(n113), .B(n317), .Z(n358) );
  OR2 U41 ( .A(n360), .B(n320), .Z(n43) );
  OR2 U42 ( .A(n321), .B(encode_data_in[1]), .Z(n361) );
  AN2 U43 ( .A(encode_data_in[1]), .B(n321), .Z(n360) );
  OR2 U44 ( .A(n362), .B(n363), .Z(n42) );
  AN2 U45 ( .A(encode_data_in[2]), .B(n318), .Z(n363) );
  AN2 U46 ( .A(encode_data_in[3]), .B(n319), .Z(n362) );
  OR2 U87 ( .A(n391), .B(n392), .Z(n9) );
  AN2 U88 ( .A(n196), .B(n309), .Z(n392) );
  AN2 U89 ( .A(n197), .B(n311), .Z(n391) );
  IV U90 ( .A(n193), .Z(n314) );
  IV U91 ( .A(n93), .Z(n313) );
  IV U92 ( .A(n196), .Z(n311) );
  IV U93 ( .A(n145), .Z(n310) );
  IV U94 ( .A(n197), .Z(n309) );
  IV U95 ( .A(n140), .Z(n308) );
  IV U96 ( .A(n190), .Z(n304) );
  OR2 U97 ( .A(n393), .B(n394), .Z(n215) );
  AN2 U98 ( .A(n321), .B(n216), .Z(n394) );
  AN2 U99 ( .A(encode_data_in[0]), .B(n395), .Z(n393) );
  OR2 U100 ( .A(n396), .B(n397), .Z(n214) );
  AN2 U101 ( .A(n216), .B(n398), .Z(n397) );
  IV U102 ( .A(n246), .Z(n398) );
  AN2 U103 ( .A(n246), .B(n395), .Z(n396) );
  OR2 U104 ( .A(n399), .B(n400), .Z(n213) );
  AN2 U105 ( .A(n216), .B(n401), .Z(n400) );
  IV U106 ( .A(n245), .Z(n401) );
  AN2 U107 ( .A(n245), .B(n395), .Z(n399) );
  OR2 U108 ( .A(n402), .B(n403), .Z(n212) );
  AN2 U109 ( .A(n216), .B(n404), .Z(n403) );
  IV U110 ( .A(n244), .Z(n404) );
  AN2 U111 ( .A(n244), .B(n395), .Z(n402) );
  OR2 U112 ( .A(n405), .B(n406), .Z(n211) );
  AN2 U113 ( .A(n216), .B(n407), .Z(n406) );
  IV U114 ( .A(n243), .Z(n407) );
  AN2 U115 ( .A(n243), .B(n395), .Z(n405) );
  OR2 U116 ( .A(n408), .B(n409), .Z(n210) );
  AN2 U117 ( .A(n216), .B(n410), .Z(n409) );
  IV U118 ( .A(n242), .Z(n410) );
  AN2 U119 ( .A(n242), .B(n395), .Z(n408) );
  IV U120 ( .A(n216), .Z(n395) );
  OR2 U121 ( .A(n411), .B(n412), .Z(n209) );
  AN2 U122 ( .A(n180), .B(n413), .Z(n412) );
  IV U123 ( .A(n[189]), .Z(n413) );
  AN2 U124 ( .A(n[189]), .B(n414), .Z(n411) );
  OR2 U125 ( .A(n415), .B(n416), .Z(n208) );
  AN2 U126 ( .A(n180), .B(n417), .Z(n416) );
  IV U127 ( .A(n[188]), .Z(n417) );
  AN2 U128 ( .A(n[188]), .B(n414), .Z(n415) );
  OR2 U129 ( .A(n418), .B(n419), .Z(n207) );
  AN2 U130 ( .A(n180), .B(n312), .Z(n419) );
  IV U131 ( .A(n[187]), .Z(n312) );
  AN2 U132 ( .A(n[187]), .B(n414), .Z(n418) );
  OR2 U133 ( .A(n420), .B(n421), .Z(n206) );
  AN2 U134 ( .A(n180), .B(n422), .Z(n421) );
  IV U135 ( .A(n[186]), .Z(n422) );
  AN2 U136 ( .A(n[186]), .B(n414), .Z(n420) );
  IV U137 ( .A(n180), .Z(n414) );
  AN2 U138 ( .A(n218), .B(n423), .Z(U4_Z_0) );
  OR2 U139 ( .A(n424), .B(n425), .Z(n423) );
  AN2 U140 ( .A(n226), .B(n426), .Z(n425) );
  IV U141 ( .A(n15), .Z(n426) );
  IV U142 ( .A(n427), .Z(n226) );
  AN2 U143 ( .A(n15), .B(n427), .Z(n424) );
  AN2 U144 ( .A(n428), .B(n429), .Z(n427) );
  OR2 U145 ( .A(n299), .B(n16), .Z(n429) );
  IV U146 ( .A(U5_Z_0), .Z(n299) );
  OR2 U147 ( .A(n430), .B(U5_Z_0), .Z(n428) );
  OR2 U148 ( .A(n431), .B(n432), .Z(U5_Z_0) );
  AN2 U149 ( .A(n179), .B(U5_DATA1_0), .Z(n432) );
  AN2 U150 ( .A(bad_disp), .B(n433), .Z(n431) );
  IV U151 ( .A(U5_DATA1_0), .Z(n433) );
  IV U152 ( .A(n16), .Z(n430) );
endmodule

