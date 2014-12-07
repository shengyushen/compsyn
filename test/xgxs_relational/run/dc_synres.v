
module XGXSSYNTH_ENC_8B10B ( bad_code, bad_disp, clk, encode_data_in, konstant, 
        rst, disp_out, encode_data_out, assertion_shengyushen );
  input [7:0] encode_data_in;
  output [9:0] encode_data_out;
  input bad_code, bad_disp, clk, konstant, rst;
  output disp_out, assertion_shengyushen;
  wire   n2, n3, n4, n5, n6, n7, n8, n12, n13, n15, n16, n17, n18, n19, n20,
         n21, n22, n23, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35,
         n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49,
         n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63,
         n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77,
         n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91,
         n92, n93, n94, n95, n96, n97, n98, n99, n100, n102, n103, n104, n105,
         n106, n107, n108, n109, n110, n111, n112, n113, n114, n115, n116,
         n117, n118, n119, n120, n121, n122, n123, n124, n125, n126, n127,
         n128, n129, n130, n131, n132, n133, n134, n135, n136, n137, n138,
         n139, n140, n141, n142, n143, n144, n145, n146, n148, n149, n153,
         n154, n155, n156, n157, n158, n159, n160, n161, n162, n163, n164,
         n165, n166, n167, n168, n169, n170, n171, n172, n173, n174, n175,
         n176, n177, n178, n179, n180, n181, n182, n183, n184, n185, n186,
         n187, n188, n189, n190, n191, n192, n193, n194, n195, n196, n197,
         n198, n199, n200, n201, n202, n203, n204, n205, n206, n207, n208,
         n209, n210, n211, n212, n213, n214, n215, n216, n217, n218, n219,
         n220, n221, n222, n223, n224, n225, n226, n227, n228, n229, n230,
         n231, n232, n233, n234, n235, n236, n237, n238, n239, n240, n241,
         n242, n244, n245, n250, n251, n252, n253, n256, n257, n260, n261,
         n262, n263, n264, n265, n266, n267, n268, n269, n270, n271, n272,
         n273, n274, n275, n276, n282, n285, n287, n294, n301, n302, n303,
         n304, n305, n319, n320, U5_Z_0, U5_DATA1_0, U4_Z_0, n352, n359, n364,
         n368, n369, n370, n371, n372, n373, n374, n375, n376, n377, n378,
         n379, n380, n381, n414, n415, n416, n417, n418, n419, n420, n421,
         n451, n452, n453, n454, n455, n456, n457, n458, n459, n460, n461,
         n462, n463, n464, n465, n466, n467, n468, n469, n470, n471, n472,
         n473, n474, n475, n476, n477, n478, n479, n480, n481, n482, n483,
         n484, n485, n486, n487, n488, n489, n490, n491, n492, n493;
  wire   [249:246] n;

  OR2 C827 ( .A(n265), .B(n239), .Z(encode_data_out[0]) );
  AN2 C825 ( .A(n264), .B(n352), .Z(encode_data_out[1]) );
  OR2 C824 ( .A(n263), .B(n239), .Z(encode_data_out[2]) );
  OR2 C823 ( .A(n262), .B(n239), .Z(encode_data_out[3]) );
  OR2 C822 ( .A(n261), .B(n239), .Z(encode_data_out[4]) );
  OR2 C821 ( .A(n260), .B(n239), .Z(encode_data_out[5]) );
  AN2 C819 ( .A(n269), .B(n352), .Z(encode_data_out[6]) );
  OR2 C818 ( .A(n268), .B(n239), .Z(encode_data_out[7]) );
  AN2 C816 ( .A(n267), .B(n352), .Z(encode_data_out[8]) );
  AN2 C814 ( .A(n266), .B(n352), .Z(encode_data_out[9]) );
  OR2 C809 ( .A(n368), .B(n241), .Z(n3) );
  AN2 C808 ( .A(n253), .B(n3), .Z(n2) );
  OR2 C807 ( .A(n242), .B(n244), .Z(n5) );
  AN2 C805 ( .A(n374), .B(n5), .Z(n4) );
  OR2 C804 ( .A(n4), .B(n2), .Z(n240) );
  AN2 C801 ( .A(n245), .B(n252), .Z(n7) );
  AN2 C800 ( .A(n7), .B(n6), .Z(n244) );
  AN2 C797 ( .A(n6), .B(n372), .Z(n8) );
  OR2 C796 ( .A(n8), .B(n250), .Z(n[246]) );
  OR2 C795 ( .A(n256), .B(n370), .Z(n[248]) );
  AN2 C793 ( .A(n257), .B(n364), .Z(n[249]) );
  AN2 C792 ( .A(n251), .B(n110), .Z(n250) );
  AN2 C790 ( .A(n374), .B(n100), .Z(n13) );
  AN2 C789 ( .A(n253), .B(n373), .Z(n15) );
  OR2 C788 ( .A(n15), .B(n13), .Z(n12) );
  OR2 C787 ( .A(n12), .B(n252), .Z(n251) );
  OR2 C770 ( .A(n282), .B(n144), .Z(n16) );
  OR2 C767 ( .A(n107), .B(n105), .Z(n282) );
  OR2 C764 ( .A(n294), .B(n287), .Z(n17) );
  IV I_54 ( .A(n319), .Z(n19) );
  AN2 C761 ( .A(n19), .B(konstant), .Z(n18) );
  OR2 C760 ( .A(n112), .B(n287), .Z(n22) );
  AN2 C759 ( .A(U5_Z_0), .B(n22), .Z(n21) );
  AN2 C757 ( .A(n359), .B(n294), .Z(n23) );
  OR2 C756 ( .A(n23), .B(n21), .Z(n20) );
  OR2 C755 ( .A(n20), .B(n18), .Z(n276) );
  AN2 C754 ( .A(n103), .B(konstant), .Z(n25) );
  OR2 C753 ( .A(n83), .B(n81), .Z(n30) );
  OR2 C752 ( .A(n30), .B(n77), .Z(n29) );
  OR2 C751 ( .A(n29), .B(n73), .Z(n28) );
  OR2 C750 ( .A(n28), .B(n69), .Z(n27) );
  OR2 C749 ( .A(n27), .B(n68), .Z(n26) );
  OR2 C748 ( .A(n26), .B(n25), .Z(n287) );
  OR2 C741 ( .A(n98), .B(n96), .Z(n35) );
  OR2 C740 ( .A(n35), .B(n94), .Z(n34) );
  OR2 C739 ( .A(n34), .B(n92), .Z(n33) );
  OR2 C738 ( .A(n33), .B(n90), .Z(n32) );
  OR2 C737 ( .A(n32), .B(n87), .Z(n31) );
  OR2 C736 ( .A(n31), .B(n85), .Z(n294) );
  AN2 C729 ( .A(n103), .B(konstant), .Z(n36) );
  AN2 C725 ( .A(n44), .B(n43), .Z(n42) );
  AN2 C724 ( .A(n42), .B(n236), .Z(n41) );
  AN2 C722 ( .A(n123), .B(n46), .Z(n45) );
  OR2 C721 ( .A(n45), .B(n41), .Z(n40) );
  OR2 C720 ( .A(n40), .B(n119), .Z(n39) );
  OR2 C719 ( .A(n39), .B(n117), .Z(n38) );
  OR2 C718 ( .A(n38), .B(n68), .Z(n37) );
  OR2 C717 ( .A(n37), .B(n36), .Z(n301) );
  OR2 C716 ( .A(n132), .B(n128), .Z(n48) );
  OR2 C715 ( .A(n48), .B(n125), .Z(n47) );
  OR2 C713 ( .A(n49), .B(n47), .Z(n302) );
  AN2 C711 ( .A(encode_data_in[3]), .B(n52), .Z(n303) );
  OR2 C710 ( .A(encode_data_in[2]), .B(n140), .Z(n50) );
  OR2 C709 ( .A(n50), .B(n85), .Z(n304) );
  IV I_52 ( .A(n138), .Z(n52) );
  AN2 C707 ( .A(encode_data_in[1]), .B(n52), .Z(n51) );
  OR2 C706 ( .A(n51), .B(n140), .Z(n305) );
  OR2 C693 ( .A(n103), .B(n320), .Z(n319) );
  OR2 C692 ( .A(n81), .B(n77), .Z(n54) );
  OR2 C691 ( .A(n54), .B(n73), .Z(n53) );
  OR2 C690 ( .A(n53), .B(n69), .Z(n320) );
  OR2 C688 ( .A(n226), .B(n218), .Z(n67) );
  OR2 C687 ( .A(n67), .B(n209), .Z(n66) );
  OR2 C686 ( .A(n66), .B(n202), .Z(n65) );
  AN2 C685 ( .A(konstant), .B(n65), .Z(n64) );
  OR2 C684 ( .A(n64), .B(n193), .Z(n63) );
  OR2 C683 ( .A(n63), .B(n186), .Z(n62) );
  OR2 C682 ( .A(n62), .B(n178), .Z(n61) );
  OR2 C681 ( .A(n61), .B(n171), .Z(n60) );
  OR2 C680 ( .A(n60), .B(n164), .Z(n59) );
  OR2 C679 ( .A(n59), .B(n160), .Z(n58) );
  OR2 C678 ( .A(n58), .B(n158), .Z(n57) );
  OR2 C677 ( .A(n57), .B(n155), .Z(n56) );
  OR2 C676 ( .A(n237), .B(n56), .Z(n55) );
  AN2 C675 ( .A(n238), .B(n55), .Z(assertion_shengyushen) );
  AN2 C626 ( .A(encode_data_in[4]), .B(n138), .Z(n68) );
  IV I_51 ( .A(n70), .Z(n69) );
  OR2 C621 ( .A(n236), .B(n71), .Z(n70) );
  OR2 C620 ( .A(n235), .B(n72), .Z(n71) );
  OR2 C619 ( .A(n234), .B(n131), .Z(n72) );
  IV I_50 ( .A(n74), .Z(n73) );
  OR2 C612 ( .A(n236), .B(n75), .Z(n74) );
  OR2 C611 ( .A(n235), .B(n76), .Z(n75) );
  OR2 C610 ( .A(n234), .B(n135), .Z(n76) );
  IV I_49 ( .A(n78), .Z(n77) );
  OR2 C603 ( .A(n236), .B(n79), .Z(n78) );
  OR2 C602 ( .A(n235), .B(n80), .Z(n79) );
  OR2 C601 ( .A(encode_data_in[2]), .B(n116), .Z(n80) );
  IV I_48 ( .A(n82), .Z(n81) );
  OR2 C594 ( .A(n236), .B(n114), .Z(n82) );
  IV I_47 ( .A(n84), .Z(n83) );
  OR2 C585 ( .A(n236), .B(n141), .Z(n84) );
  IV I_46 ( .A(n86), .Z(n85) );
  OR2 C579 ( .A(n236), .B(n137), .Z(n86) );
  IV I_45 ( .A(n88), .Z(n87) );
  OR2 C572 ( .A(encode_data_in[4]), .B(n89), .Z(n88) );
  OR2 C571 ( .A(n235), .B(n115), .Z(n89) );
  IV I_44 ( .A(n91), .Z(n90) );
  OR2 C563 ( .A(encode_data_in[4]), .B(n137), .Z(n91) );
  IV I_43 ( .A(n93), .Z(n92) );
  OR2 C557 ( .A(encode_data_in[4]), .B(n126), .Z(n93) );
  IV I_42 ( .A(n95), .Z(n94) );
  OR2 C551 ( .A(encode_data_in[4]), .B(n129), .Z(n95) );
  IV I_41 ( .A(n97), .Z(n96) );
  OR2 C545 ( .A(encode_data_in[4]), .B(n133), .Z(n97) );
  IV I_40 ( .A(n99), .Z(n98) );
  OR2 C539 ( .A(encode_data_in[4]), .B(n141), .Z(n99) );
  AN2 C535 ( .A(n260), .B(n261), .Z(n100) );
  OR2 C533 ( .A(n260), .B(n261), .Z(n102) );
  IV I_38 ( .A(n104), .Z(n103) );
  OR2 C531 ( .A(n236), .B(n121), .Z(n104) );
  IV I_37 ( .A(n106), .Z(n105) );
  OR2 C523 ( .A(n201), .B(n109), .Z(n106) );
  IV I_36 ( .A(n108), .Z(n107) );
  OR2 C519 ( .A(encode_data_in[7]), .B(n109), .Z(n108) );
  OR2 C518 ( .A(encode_data_in[6]), .B(encode_data_in[5]), .Z(n109) );
  AN2 C517 ( .A(n[247]), .B(n111), .Z(n110) );
  AN2 C516 ( .A(n256), .B(n257), .Z(n111) );
  IV I_35 ( .A(n113), .Z(n112) );
  OR2 C514 ( .A(encode_data_in[4]), .B(n114), .Z(n113) );
  OR2 C513 ( .A(encode_data_in[3]), .B(n115), .Z(n114) );
  OR2 C512 ( .A(n234), .B(n116), .Z(n115) );
  OR2 C511 ( .A(n170), .B(n169), .Z(n116) );
  IV I_34 ( .A(n118), .Z(n117) );
  OR2 C506 ( .A(n236), .B(n126), .Z(n118) );
  IV I_33 ( .A(n120), .Z(n119) );
  OR2 C499 ( .A(encode_data_in[4]), .B(n121), .Z(n120) );
  OR2 C498 ( .A(n235), .B(n127), .Z(n121) );
  AN2 C493 ( .A(encode_data_in[1]), .B(encode_data_in[0]), .Z(n122) );
  IV I_32 ( .A(n124), .Z(n123) );
  OR2 C491 ( .A(encode_data_in[3]), .B(encode_data_in[2]), .Z(n124) );
  IV I_31 ( .A(n126), .Z(n125) );
  OR2 C489 ( .A(encode_data_in[3]), .B(n127), .Z(n126) );
  OR2 C488 ( .A(n234), .B(n143), .Z(n127) );
  IV I_30 ( .A(n129), .Z(n128) );
  OR2 C484 ( .A(encode_data_in[3]), .B(n130), .Z(n129) );
  OR2 C483 ( .A(encode_data_in[2]), .B(n131), .Z(n130) );
  OR2 C482 ( .A(n170), .B(encode_data_in[0]), .Z(n131) );
  IV I_29 ( .A(n133), .Z(n132) );
  OR2 C479 ( .A(encode_data_in[3]), .B(n134), .Z(n133) );
  OR2 C478 ( .A(encode_data_in[2]), .B(n135), .Z(n134) );
  OR2 C477 ( .A(encode_data_in[1]), .B(n169), .Z(n135) );
  IV I_28 ( .A(n137), .Z(n136) );
  OR2 C474 ( .A(n235), .B(n142), .Z(n137) );
  AN2 C470 ( .A(encode_data_in[3]), .B(n139), .Z(n138) );
  AN2 C469 ( .A(encode_data_in[2]), .B(n122), .Z(n139) );
  IV I_27 ( .A(n141), .Z(n140) );
  OR2 C466 ( .A(encode_data_in[3]), .B(n142), .Z(n141) );
  OR2 C465 ( .A(encode_data_in[2]), .B(n143), .Z(n142) );
  OR2 C464 ( .A(encode_data_in[1]), .B(encode_data_in[0]), .Z(n143) );
  AN2 C463 ( .A(encode_data_in[7]), .B(n145), .Z(n144) );
  AN2 C462 ( .A(encode_data_in[6]), .B(encode_data_in[5]), .Z(n145) );
  IV I_26 ( .A(bad_disp), .Z(n146) );
  OR2 C459 ( .A(n[247]), .B(n149), .Z(n148) );
  OR2 C458 ( .A(n371), .B(n369), .Z(n149) );
  OR2 C454 ( .A(n[247]), .B(n154), .Z(n153) );
  OR2 C453 ( .A(n256), .B(n257), .Z(n154) );
  IV I_21 ( .A(n156), .Z(n155) );
  OR2 C451 ( .A(encode_data_in[0]), .B(n157), .Z(n156) );
  OR2 C450 ( .A(n170), .B(n174), .Z(n157) );
  IV I_20 ( .A(n159), .Z(n158) );
  OR2 C436 ( .A(n169), .B(n173), .Z(n159) );
  IV I_19 ( .A(n161), .Z(n160) );
  OR2 C421 ( .A(n169), .B(n162), .Z(n161) );
  OR2 C420 ( .A(n170), .B(n163), .Z(n162) );
  OR2 C419 ( .A(encode_data_in[2]), .B(n175), .Z(n163) );
  IV I_18 ( .A(n165), .Z(n164) );
  OR2 C406 ( .A(n169), .B(n166), .Z(n165) );
  OR2 C405 ( .A(n170), .B(n167), .Z(n166) );
  OR2 C404 ( .A(n234), .B(n168), .Z(n167) );
  OR2 C403 ( .A(encode_data_in[3]), .B(n176), .Z(n168) );
  IV I_17 ( .A(encode_data_in[0]), .Z(n169) );
  IV I_16 ( .A(encode_data_in[1]), .Z(n170) );
  IV I_15 ( .A(n172), .Z(n171) );
  OR2 C391 ( .A(encode_data_in[0]), .B(n173), .Z(n172) );
  OR2 C390 ( .A(encode_data_in[1]), .B(n174), .Z(n173) );
  OR2 C389 ( .A(n234), .B(n175), .Z(n174) );
  OR2 C388 ( .A(n235), .B(n176), .Z(n175) );
  OR2 C387 ( .A(n236), .B(n177), .Z(n176) );
  OR2 C386 ( .A(n225), .B(n185), .Z(n177) );
  IV I_14 ( .A(n179), .Z(n178) );
  OR2 C377 ( .A(encode_data_in[0]), .B(n180), .Z(n179) );
  OR2 C376 ( .A(encode_data_in[1]), .B(n181), .Z(n180) );
  OR2 C375 ( .A(n234), .B(n182), .Z(n181) );
  OR2 C374 ( .A(n235), .B(n183), .Z(n182) );
  OR2 C373 ( .A(n236), .B(n184), .Z(n183) );
  OR2 C372 ( .A(encode_data_in[5]), .B(n185), .Z(n184) );
  OR2 C371 ( .A(n217), .B(n201), .Z(n185) );
  IV I_13 ( .A(n187), .Z(n186) );
  OR2 C364 ( .A(encode_data_in[0]), .B(n188), .Z(n187) );
  OR2 C363 ( .A(encode_data_in[1]), .B(n189), .Z(n188) );
  OR2 C362 ( .A(n234), .B(n190), .Z(n189) );
  OR2 C361 ( .A(n235), .B(n191), .Z(n190) );
  OR2 C360 ( .A(n236), .B(n192), .Z(n191) );
  OR2 C359 ( .A(n225), .B(n200), .Z(n192) );
  IV I_12 ( .A(n194), .Z(n193) );
  OR2 C351 ( .A(encode_data_in[0]), .B(n195), .Z(n194) );
  OR2 C350 ( .A(encode_data_in[1]), .B(n196), .Z(n195) );
  OR2 C349 ( .A(n234), .B(n197), .Z(n196) );
  OR2 C348 ( .A(n235), .B(n198), .Z(n197) );
  OR2 C347 ( .A(n236), .B(n199), .Z(n198) );
  OR2 C346 ( .A(encode_data_in[5]), .B(n200), .Z(n199) );
  OR2 C345 ( .A(encode_data_in[6]), .B(n201), .Z(n200) );
  IV I_11 ( .A(encode_data_in[7]), .Z(n201) );
  IV I_10 ( .A(n203), .Z(n202) );
  OR2 C339 ( .A(encode_data_in[0]), .B(n204), .Z(n203) );
  OR2 C338 ( .A(encode_data_in[1]), .B(n205), .Z(n204) );
  OR2 C337 ( .A(n234), .B(n206), .Z(n205) );
  OR2 C336 ( .A(n235), .B(n207), .Z(n206) );
  OR2 C335 ( .A(n236), .B(n208), .Z(n207) );
  OR2 C334 ( .A(n225), .B(n216), .Z(n208) );
  IV I_9 ( .A(n210), .Z(n209) );
  OR2 C326 ( .A(encode_data_in[0]), .B(n211), .Z(n210) );
  OR2 C325 ( .A(encode_data_in[1]), .B(n212), .Z(n211) );
  OR2 C324 ( .A(n234), .B(n213), .Z(n212) );
  OR2 C323 ( .A(n235), .B(n214), .Z(n213) );
  OR2 C322 ( .A(n236), .B(n215), .Z(n214) );
  OR2 C321 ( .A(encode_data_in[5]), .B(n216), .Z(n215) );
  OR2 C320 ( .A(n217), .B(encode_data_in[7]), .Z(n216) );
  IV I_8 ( .A(encode_data_in[6]), .Z(n217) );
  IV I_7 ( .A(n219), .Z(n218) );
  OR2 C314 ( .A(encode_data_in[0]), .B(n220), .Z(n219) );
  OR2 C313 ( .A(encode_data_in[1]), .B(n221), .Z(n220) );
  OR2 C312 ( .A(n234), .B(n222), .Z(n221) );
  OR2 C311 ( .A(n235), .B(n223), .Z(n222) );
  OR2 C310 ( .A(n236), .B(n224), .Z(n223) );
  OR2 C309 ( .A(n225), .B(n233), .Z(n224) );
  IV I_6 ( .A(encode_data_in[5]), .Z(n225) );
  IV I_5 ( .A(n227), .Z(n226) );
  OR2 C302 ( .A(encode_data_in[0]), .B(n228), .Z(n227) );
  OR2 C301 ( .A(encode_data_in[1]), .B(n229), .Z(n228) );
  OR2 C300 ( .A(n234), .B(n230), .Z(n229) );
  OR2 C299 ( .A(n235), .B(n231), .Z(n230) );
  OR2 C298 ( .A(n236), .B(n232), .Z(n231) );
  OR2 C297 ( .A(encode_data_in[5]), .B(n233), .Z(n232) );
  OR2 C296 ( .A(encode_data_in[6]), .B(encode_data_in[7]), .Z(n233) );
  IV I_4 ( .A(encode_data_in[2]), .Z(n234) );
  IV I_3 ( .A(encode_data_in[3]), .Z(n235) );
  IV I_2 ( .A(encode_data_in[4]), .Z(n236) );
  IV I_1 ( .A(konstant), .Z(n237) );
  IV I_0 ( .A(rst), .Z(n238) );
  FD1 bad_code_reg_reg ( .D(bad_code), .CP(clk), .Q(n239) );
  FD1 disp_lat_reg ( .D(U4_Z_0), .CP(clk), .Q(U5_DATA1_0) );
  FD1 konstant_latch_reg ( .D(konstant), .CP(clk), .Q(n252) );
  FD1 ip_data_latch_reg_2_ ( .D(encode_data_in[5]), .CP(clk), .Q(n257) );
  FD1 ip_data_latch_reg_1_ ( .D(encode_data_in[6]), .CP(clk), .Q(n256) );
  FD1 ip_data_latch_reg_0_ ( .D(encode_data_in[7]), .CP(clk), .Q(n[247]) );
  FD1 disp_lat_fix_latch_reg ( .D(U5_Z_0), .CP(clk), .Q(disp_out) );
  FD1 data_out_latch_reg_5_ ( .D(n275), .CP(clk), .Q(n265) );
  FD1 data_out_latch_reg_4_ ( .D(n274), .CP(clk), .Q(n264) );
  FD1 data_out_latch_reg_3_ ( .D(n273), .CP(clk), .Q(n263) );
  FD1 data_out_latch_reg_2_ ( .D(n272), .CP(clk), .Q(n262) );
  FD1 data_out_latch_reg_1_ ( .D(n271), .CP(clk), .Q(n261) );
  FD1 data_out_latch_reg_0_ ( .D(n270), .CP(clk), .Q(n260) );
  FD1 kx_latch_reg ( .D(n103), .CP(clk), .Q(n245) );
  FD1 plus34_latch_reg ( .D(n282), .CP(clk), .Q(n242) );
  FD1 minus34b_latch_reg ( .D(n144), .CP(clk), .Q(n241) );
  FD1 i_disp_latch_reg ( .D(n285), .CP(clk), .Q(n253) );
  IV U26 ( .A(n417), .Z(n375) );
  IV U27 ( .A(n415), .Z(n376) );
  IV U28 ( .A(encode_data_in[4]), .Z(n377) );
  IV U29 ( .A(encode_data_in[3]), .Z(n378) );
  IV U30 ( .A(encode_data_in[2]), .Z(n379) );
  IV U31 ( .A(n419), .Z(n380) );
  IV U32 ( .A(encode_data_in[0]), .Z(n381) );
  OR2 U33 ( .A(n414), .B(n376), .Z(n49) );
  OR2 U34 ( .A(n377), .B(n136), .Z(n415) );
  AN2 U35 ( .A(n136), .B(n377), .Z(n414) );
  OR2 U36 ( .A(n416), .B(n375), .Z(n46) );
  OR2 U37 ( .A(n377), .B(n122), .Z(n417) );
  AN2 U38 ( .A(n122), .B(n377), .Z(n416) );
  OR2 U39 ( .A(n418), .B(n380), .Z(n44) );
  OR2 U40 ( .A(n381), .B(encode_data_in[1]), .Z(n419) );
  AN2 U41 ( .A(encode_data_in[1]), .B(n381), .Z(n418) );
  OR2 U42 ( .A(n420), .B(n421), .Z(n43) );
  AN2 U43 ( .A(encode_data_in[2]), .B(n378), .Z(n421) );
  AN2 U44 ( .A(encode_data_in[3]), .B(n379), .Z(n420) );
  OR2 U88 ( .A(n451), .B(n452), .Z(n6) );
  AN2 U89 ( .A(n256), .B(n369), .Z(n452) );
  AN2 U90 ( .A(n257), .B(n371), .Z(n451) );
  IV U91 ( .A(n253), .Z(n374) );
  IV U92 ( .A(n102), .Z(n373) );
  IV U93 ( .A(n256), .Z(n371) );
  IV U94 ( .A(n153), .Z(n370) );
  IV U95 ( .A(n257), .Z(n369) );
  IV U96 ( .A(n148), .Z(n368) );
  IV U97 ( .A(n250), .Z(n364) );
  IV U98 ( .A(n239), .Z(n352) );
  OR2 U99 ( .A(n453), .B(n454), .Z(n275) );
  AN2 U100 ( .A(n381), .B(n276), .Z(n454) );
  AN2 U101 ( .A(encode_data_in[0]), .B(n455), .Z(n453) );
  OR2 U102 ( .A(n456), .B(n457), .Z(n274) );
  AN2 U103 ( .A(n276), .B(n458), .Z(n457) );
  IV U104 ( .A(n305), .Z(n458) );
  AN2 U105 ( .A(n305), .B(n455), .Z(n456) );
  OR2 U106 ( .A(n459), .B(n460), .Z(n273) );
  AN2 U107 ( .A(n276), .B(n461), .Z(n460) );
  IV U108 ( .A(n304), .Z(n461) );
  AN2 U109 ( .A(n304), .B(n455), .Z(n459) );
  OR2 U110 ( .A(n462), .B(n463), .Z(n272) );
  AN2 U111 ( .A(n276), .B(n464), .Z(n463) );
  IV U112 ( .A(n303), .Z(n464) );
  AN2 U113 ( .A(n303), .B(n455), .Z(n462) );
  OR2 U114 ( .A(n465), .B(n466), .Z(n271) );
  AN2 U115 ( .A(n276), .B(n467), .Z(n466) );
  IV U116 ( .A(n302), .Z(n467) );
  AN2 U117 ( .A(n302), .B(n455), .Z(n465) );
  OR2 U118 ( .A(n468), .B(n469), .Z(n270) );
  AN2 U119 ( .A(n276), .B(n470), .Z(n469) );
  IV U120 ( .A(n301), .Z(n470) );
  AN2 U121 ( .A(n301), .B(n455), .Z(n468) );
  IV U122 ( .A(n276), .Z(n455) );
  OR2 U123 ( .A(n471), .B(n472), .Z(n269) );
  AN2 U124 ( .A(n240), .B(n473), .Z(n472) );
  IV U125 ( .A(n[249]), .Z(n473) );
  AN2 U126 ( .A(n[249]), .B(n474), .Z(n471) );
  OR2 U127 ( .A(n475), .B(n476), .Z(n268) );
  AN2 U128 ( .A(n240), .B(n477), .Z(n476) );
  IV U129 ( .A(n[248]), .Z(n477) );
  AN2 U130 ( .A(n[248]), .B(n474), .Z(n475) );
  OR2 U131 ( .A(n478), .B(n479), .Z(n267) );
  AN2 U132 ( .A(n240), .B(n372), .Z(n479) );
  IV U133 ( .A(n[247]), .Z(n372) );
  AN2 U134 ( .A(n[247]), .B(n474), .Z(n478) );
  OR2 U135 ( .A(n480), .B(n481), .Z(n266) );
  AN2 U136 ( .A(n240), .B(n482), .Z(n481) );
  IV U137 ( .A(n[246]), .Z(n482) );
  AN2 U138 ( .A(n[246]), .B(n474), .Z(n480) );
  IV U139 ( .A(n240), .Z(n474) );
  AN2 U140 ( .A(n238), .B(n483), .Z(U4_Z_0) );
  OR2 U141 ( .A(n484), .B(n485), .Z(n483) );
  AN2 U142 ( .A(n285), .B(n486), .Z(n485) );
  IV U143 ( .A(n16), .Z(n486) );
  IV U144 ( .A(n487), .Z(n285) );
  AN2 U145 ( .A(n16), .B(n487), .Z(n484) );
  AN2 U146 ( .A(n488), .B(n489), .Z(n487) );
  OR2 U147 ( .A(n359), .B(n17), .Z(n489) );
  IV U148 ( .A(U5_Z_0), .Z(n359) );
  OR2 U149 ( .A(n490), .B(U5_Z_0), .Z(n488) );
  OR2 U150 ( .A(n491), .B(n492), .Z(U5_Z_0) );
  AN2 U151 ( .A(n146), .B(U5_DATA1_0), .Z(n492) );
  AN2 U152 ( .A(bad_disp), .B(n493), .Z(n491) );
  IV U153 ( .A(U5_DATA1_0), .Z(n493) );
  IV U154 ( .A(n17), .Z(n490) );
endmodule
