
module XGXSSYNTH_ENC_8B10B ( bad_code, bad_disp, clk, encode_data_in, konstant, 
        rst, disp_out, encode_data_out, assertion_shengyushen );
  input [7:0] encode_data_in;
  output [9:0] encode_data_out;
  input bad_code, bad_disp, clk, konstant, rst;
  output disp_out, assertion_shengyushen;
  wire   kz, y, plus56, minus56b, disp_lat_fix, plus34, f_disp, disp_lat,
         t1_5_, i_disp_latch, konstant_latch, s, alt_7, kx_latch, plus34k,
         plus34_latch, minus34b_latch, t2_3_, bad_code_reg, N5, N6, N7, N8, N9,
         N10, N11, N12, N13, N14, N15, N16, N17, N18, N19, N20, N21, N22, N23,
         N24, N25, N26, N27, N28, N29, N30, N31, N32, N33, N34, N35, N36, N37,
         N38, N39, N40, N41, N42, N43, N44, N45, N46, N47, N48, N49, N50, N51,
         N52, N53, N54, N55, N56, N57, N58, N59, N60, N61, N62, N63, N64, N65,
         N66, N67, N68, N69, N70, N71, N72, N73, N74, N75, N76, N77, N78, N79,
         N80, N81, N82, N83, N84, N85, N86, N87, N88, N89, N90, N94, N95, N97,
         N98, N99, N100, N101, N102, N103, N104, N105, N106, N107, N108, N109,
         N110, N111, N112, N113, N114, N115, N116, N117, N118, N119, N120,
         N121, N122, N123, N124, N125, N126, N127, N128, N129, N130, N131,
         N132, N133, N134, N135, N136, N137, N138, N139, N140, N141, N143,
         N144, N145, N146, N147, N148, N149, N150, N151, N152, N153, N154,
         N155, N156, N157, N158, N159, N160, N161, N162, N163, N164, N165,
         N166, N167, N168, N169, N170, N171, N172, N173, N174, N175, N176,
         N177, N178, N179, N180, N181, N182, N183, N184, N185, N186, N187,
         N188, N189, N190, N191, N192, N193, N194, N195, N196, N197, N198,
         N199, N200, N201, N202, N203, N204, N205, N206, N207, N208, N209,
         N210, N211, N212, N213, N214, N215, N216, N217, N218, N220, N221,
         N222, N223, N224, N225, N226, N227, N228, N230, N231, N235, N236,
         N237, N238, N239, N240, N241, n1, n2, n4, n5, n7, n10, n11, n13, n14,
         n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28,
         n29, n30, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100,
         n101, n102, n103, n104, n105, n106, n107, n108, n109, n110, n111,
         n112, n113, n114, n115, n116, n117, n118, n119, n120, n121, n122,
         n123, n124, n125, n126, n127, n128, n129, n130, n131, n132;
  wire   [4:0] int;
  wire   [9:0] data_out;
  wire   [5:0] data_out_latch;
  wire   [2:1] ip_data_latch;
  wire   [3:0] ins;

  OR2 C827 ( .A(data_out_latch[5]), .B(bad_code_reg), .Z(encode_data_out[0])
         );
  AN2 C825 ( .A(data_out_latch[4]), .B(n1), .Z(encode_data_out[1]) );
  OR2 C824 ( .A(data_out_latch[3]), .B(bad_code_reg), .Z(encode_data_out[2])
         );
  OR2 C823 ( .A(data_out_latch[2]), .B(bad_code_reg), .Z(encode_data_out[3])
         );
  OR2 C822 ( .A(data_out_latch[1]), .B(bad_code_reg), .Z(encode_data_out[4])
         );
  OR2 C821 ( .A(data_out_latch[0]), .B(bad_code_reg), .Z(encode_data_out[5])
         );
  AN2 C819 ( .A(data_out[3]), .B(n1), .Z(encode_data_out[6]) );
  OR2 C818 ( .A(data_out[2]), .B(bad_code_reg), .Z(encode_data_out[7]) );
  AN2 C816 ( .A(data_out[1]), .B(n1), .Z(encode_data_out[8]) );
  AN2 C814 ( .A(data_out[0]), .B(n1), .Z(encode_data_out[9]) );
  OR2 C809 ( .A(n10), .B(minus34b_latch), .Z(N240) );
  AN2 C808 ( .A(i_disp_latch), .B(N240), .Z(N241) );
  OR2 C807 ( .A(plus34_latch), .B(plus34k), .Z(N238) );
  AN2 C805 ( .A(n17), .B(N238), .Z(N239) );
  OR2 C804 ( .A(N239), .B(N241), .Z(t2_3_) );
  AN2 C801 ( .A(kx_latch), .B(konstant_latch), .Z(N236) );
  AN2 C800 ( .A(N236), .B(N237), .Z(plus34k) );
  AN2 C797 ( .A(N237), .B(n15), .Z(N235) );
  OR2 C796 ( .A(N235), .B(alt_7), .Z(ins[0]) );
  OR2 C795 ( .A(ip_data_latch[1]), .B(n13), .Z(ins[2]) );
  AN2 C793 ( .A(ip_data_latch[2]), .B(n7), .Z(ins[3]) );
  AN2 C792 ( .A(s), .B(N133), .Z(alt_7) );
  AN2 C790 ( .A(n17), .B(N143), .Z(N230) );
  AN2 C789 ( .A(i_disp_latch), .B(n16), .Z(N228) );
  OR2 C788 ( .A(N228), .B(N230), .Z(N231) );
  OR2 C787 ( .A(N231), .B(konstant_latch), .Z(s) );
  OR2 C770 ( .A(plus34), .B(N99), .Z(N227) );
  OR2 C767 ( .A(N136), .B(N138), .Z(plus34) );
  OR2 C764 ( .A(plus56), .B(minus56b), .Z(N226) );
  IV I_54 ( .A(y), .Z(N224) );
  AN2 C761 ( .A(N224), .B(konstant), .Z(N225) );
  OR2 C760 ( .A(N131), .B(minus56b), .Z(N221) );
  AN2 C759 ( .A(disp_lat_fix), .B(N221), .Z(N222) );
  AN2 C757 ( .A(n4), .B(plus56), .Z(N220) );
  OR2 C756 ( .A(N220), .B(N222), .Z(N223) );
  OR2 C755 ( .A(N223), .B(N225), .Z(t1_5_) );
  AN2 C754 ( .A(N140), .B(konstant), .Z(N218) );
  OR2 C753 ( .A(N160), .B(N162), .Z(N213) );
  OR2 C752 ( .A(N213), .B(N166), .Z(N214) );
  OR2 C751 ( .A(N214), .B(N170), .Z(N215) );
  OR2 C750 ( .A(N215), .B(N174), .Z(N216) );
  OR2 C749 ( .A(N216), .B(N175), .Z(N217) );
  OR2 C748 ( .A(N217), .B(N218), .Z(minus56b) );
  OR2 C741 ( .A(N145), .B(N147), .Z(N208) );
  OR2 C740 ( .A(N208), .B(N149), .Z(N209) );
  OR2 C739 ( .A(N209), .B(N151), .Z(N210) );
  OR2 C738 ( .A(N210), .B(N153), .Z(N211) );
  OR2 C737 ( .A(N211), .B(N156), .Z(N212) );
  OR2 C736 ( .A(N212), .B(N158), .Z(plus56) );
  AN2 C729 ( .A(N140), .B(konstant), .Z(N207) );
  AN2 C725 ( .A(N199), .B(N200), .Z(N201) );
  AN2 C724 ( .A(N201), .B(N7), .Z(N202) );
  AN2 C722 ( .A(N120), .B(N197), .Z(N198) );
  OR2 C721 ( .A(N198), .B(N202), .Z(N203) );
  OR2 C720 ( .A(N203), .B(N124), .Z(N204) );
  OR2 C719 ( .A(N204), .B(N126), .Z(N205) );
  OR2 C718 ( .A(N205), .B(N175), .Z(N206) );
  OR2 C717 ( .A(N206), .B(N207), .Z(int[0]) );
  OR2 C716 ( .A(N111), .B(N115), .Z(N195) );
  OR2 C715 ( .A(N195), .B(N118), .Z(N196) );
  OR2 C713 ( .A(N194), .B(N196), .Z(int[1]) );
  AN2 C711 ( .A(encode_data_in[3]), .B(N191), .Z(int[2]) );
  OR2 C710 ( .A(encode_data_in[2]), .B(N103), .Z(N193) );
  OR2 C709 ( .A(N193), .B(N158), .Z(int[3]) );
  IV I_52 ( .A(N105), .Z(N191) );
  AN2 C707 ( .A(encode_data_in[1]), .B(N191), .Z(N192) );
  OR2 C706 ( .A(N192), .B(N103), .Z(int[4]) );
  OR2 C693 ( .A(N140), .B(kz), .Z(y) );
  OR2 C692 ( .A(N162), .B(N166), .Z(N189) );
  OR2 C691 ( .A(N189), .B(N170), .Z(N190) );
  OR2 C690 ( .A(N190), .B(N174), .Z(kz) );
  OR2 C688 ( .A(N17), .B(N25), .Z(N176) );
  OR2 C687 ( .A(N176), .B(N34), .Z(N177) );
  OR2 C686 ( .A(N177), .B(N41), .Z(N178) );
  AN2 C685 ( .A(konstant), .B(N178), .Z(N179) );
  OR2 C684 ( .A(N179), .B(N50), .Z(N180) );
  OR2 C683 ( .A(N180), .B(N57), .Z(N181) );
  OR2 C682 ( .A(N181), .B(N65), .Z(N182) );
  OR2 C681 ( .A(N182), .B(N72), .Z(N183) );
  OR2 C680 ( .A(N183), .B(N79), .Z(N184) );
  OR2 C679 ( .A(N184), .B(N83), .Z(N185) );
  OR2 C678 ( .A(N185), .B(N85), .Z(N186) );
  OR2 C677 ( .A(N186), .B(N88), .Z(N187) );
  OR2 C676 ( .A(N6), .B(N187), .Z(N188) );
  AN2 C675 ( .A(N5), .B(N188), .Z(assertion_shengyushen) );
  AN2 C626 ( .A(encode_data_in[4]), .B(N105), .Z(N175) );
  IV I_51 ( .A(N173), .Z(N174) );
  OR2 C621 ( .A(N7), .B(N172), .Z(N173) );
  OR2 C620 ( .A(N8), .B(N171), .Z(N172) );
  OR2 C619 ( .A(N9), .B(N112), .Z(N171) );
  IV I_50 ( .A(N169), .Z(N170) );
  OR2 C612 ( .A(N7), .B(N168), .Z(N169) );
  OR2 C611 ( .A(N8), .B(N167), .Z(N168) );
  OR2 C610 ( .A(N9), .B(N108), .Z(N167) );
  IV I_49 ( .A(N165), .Z(N166) );
  OR2 C603 ( .A(N7), .B(N164), .Z(N165) );
  OR2 C602 ( .A(N8), .B(N163), .Z(N164) );
  OR2 C601 ( .A(encode_data_in[2]), .B(N127), .Z(N163) );
  IV I_48 ( .A(N161), .Z(N162) );
  OR2 C594 ( .A(N7), .B(N129), .Z(N161) );
  IV I_47 ( .A(N159), .Z(N160) );
  OR2 C585 ( .A(N7), .B(N102), .Z(N159) );
  IV I_46 ( .A(N157), .Z(N158) );
  OR2 C579 ( .A(N7), .B(N106), .Z(N157) );
  IV I_45 ( .A(N155), .Z(N156) );
  OR2 C572 ( .A(encode_data_in[4]), .B(N154), .Z(N155) );
  OR2 C571 ( .A(N8), .B(N128), .Z(N154) );
  IV I_44 ( .A(N152), .Z(N153) );
  OR2 C563 ( .A(encode_data_in[4]), .B(N106), .Z(N152) );
  IV I_43 ( .A(N150), .Z(N151) );
  OR2 C557 ( .A(encode_data_in[4]), .B(N117), .Z(N150) );
  IV I_42 ( .A(N148), .Z(N149) );
  OR2 C551 ( .A(encode_data_in[4]), .B(N114), .Z(N148) );
  IV I_41 ( .A(N146), .Z(N147) );
  OR2 C545 ( .A(encode_data_in[4]), .B(N110), .Z(N146) );
  IV I_40 ( .A(N144), .Z(N145) );
  OR2 C539 ( .A(encode_data_in[4]), .B(N102), .Z(N144) );
  AN2 C535 ( .A(data_out_latch[0]), .B(data_out_latch[1]), .Z(N143) );
  OR2 C533 ( .A(data_out_latch[0]), .B(data_out_latch[1]), .Z(N141) );
  IV I_38 ( .A(N139), .Z(N140) );
  OR2 C531 ( .A(N7), .B(N122), .Z(N139) );
  IV I_37 ( .A(N137), .Z(N138) );
  OR2 C523 ( .A(N42), .B(N134), .Z(N137) );
  IV I_36 ( .A(N135), .Z(N136) );
  OR2 C519 ( .A(encode_data_in[7]), .B(N134), .Z(N135) );
  OR2 C518 ( .A(encode_data_in[6]), .B(encode_data_in[5]), .Z(N134) );
  AN2 C517 ( .A(ins[1]), .B(N132), .Z(N133) );
  AN2 C516 ( .A(ip_data_latch[1]), .B(ip_data_latch[2]), .Z(N132) );
  IV I_35 ( .A(N130), .Z(N131) );
  OR2 C514 ( .A(encode_data_in[4]), .B(N129), .Z(N130) );
  OR2 C513 ( .A(encode_data_in[3]), .B(N128), .Z(N129) );
  OR2 C512 ( .A(N9), .B(N127), .Z(N128) );
  OR2 C511 ( .A(N73), .B(N74), .Z(N127) );
  IV I_34 ( .A(N125), .Z(N126) );
  OR2 C506 ( .A(N7), .B(N117), .Z(N125) );
  IV I_33 ( .A(N123), .Z(N124) );
  OR2 C499 ( .A(encode_data_in[4]), .B(N122), .Z(N123) );
  OR2 C498 ( .A(N8), .B(N116), .Z(N122) );
  AN2 C493 ( .A(encode_data_in[1]), .B(encode_data_in[0]), .Z(N121) );
  IV I_32 ( .A(N119), .Z(N120) );
  OR2 C491 ( .A(encode_data_in[3]), .B(encode_data_in[2]), .Z(N119) );
  IV I_31 ( .A(N117), .Z(N118) );
  OR2 C489 ( .A(encode_data_in[3]), .B(N116), .Z(N117) );
  OR2 C488 ( .A(N9), .B(N100), .Z(N116) );
  IV I_30 ( .A(N114), .Z(N115) );
  OR2 C484 ( .A(encode_data_in[3]), .B(N113), .Z(N114) );
  OR2 C483 ( .A(encode_data_in[2]), .B(N112), .Z(N113) );
  OR2 C482 ( .A(N73), .B(encode_data_in[0]), .Z(N112) );
  IV I_29 ( .A(N110), .Z(N111) );
  OR2 C479 ( .A(encode_data_in[3]), .B(N109), .Z(N110) );
  OR2 C478 ( .A(encode_data_in[2]), .B(N108), .Z(N109) );
  OR2 C477 ( .A(encode_data_in[1]), .B(N74), .Z(N108) );
  IV I_28 ( .A(N106), .Z(N107) );
  OR2 C474 ( .A(N8), .B(N101), .Z(N106) );
  AN2 C470 ( .A(encode_data_in[3]), .B(N104), .Z(N105) );
  AN2 C469 ( .A(encode_data_in[2]), .B(N121), .Z(N104) );
  IV I_27 ( .A(N102), .Z(N103) );
  OR2 C466 ( .A(encode_data_in[3]), .B(N101), .Z(N102) );
  OR2 C465 ( .A(encode_data_in[2]), .B(N100), .Z(N101) );
  OR2 C464 ( .A(encode_data_in[1]), .B(encode_data_in[0]), .Z(N100) );
  AN2 C463 ( .A(encode_data_in[7]), .B(N98), .Z(N99) );
  AN2 C462 ( .A(encode_data_in[6]), .B(encode_data_in[5]), .Z(N98) );
  IV I_26 ( .A(bad_disp), .Z(N97) );
  OR2 C459 ( .A(ins[1]), .B(N94), .Z(N95) );
  OR2 C458 ( .A(n14), .B(n11), .Z(N94) );
  OR2 C454 ( .A(ins[1]), .B(N89), .Z(N90) );
  OR2 C453 ( .A(ip_data_latch[1]), .B(ip_data_latch[2]), .Z(N89) );
  IV I_21 ( .A(N87), .Z(N88) );
  OR2 C451 ( .A(encode_data_in[0]), .B(N86), .Z(N87) );
  OR2 C450 ( .A(N73), .B(N69), .Z(N86) );
  IV I_20 ( .A(N84), .Z(N85) );
  OR2 C436 ( .A(N74), .B(N70), .Z(N84) );
  IV I_19 ( .A(N82), .Z(N83) );
  OR2 C421 ( .A(N74), .B(N81), .Z(N82) );
  OR2 C420 ( .A(N73), .B(N80), .Z(N81) );
  OR2 C419 ( .A(encode_data_in[2]), .B(N68), .Z(N80) );
  IV I_18 ( .A(N78), .Z(N79) );
  OR2 C406 ( .A(N74), .B(N77), .Z(N78) );
  OR2 C405 ( .A(N73), .B(N76), .Z(N77) );
  OR2 C404 ( .A(N9), .B(N75), .Z(N76) );
  OR2 C403 ( .A(encode_data_in[3]), .B(N67), .Z(N75) );
  IV I_17 ( .A(encode_data_in[0]), .Z(N74) );
  IV I_16 ( .A(encode_data_in[1]), .Z(N73) );
  IV I_15 ( .A(N71), .Z(N72) );
  OR2 C391 ( .A(encode_data_in[0]), .B(N70), .Z(N71) );
  OR2 C390 ( .A(encode_data_in[1]), .B(N69), .Z(N70) );
  OR2 C389 ( .A(N9), .B(N68), .Z(N69) );
  OR2 C388 ( .A(N8), .B(N67), .Z(N68) );
  OR2 C387 ( .A(N7), .B(N66), .Z(N67) );
  OR2 C386 ( .A(N18), .B(N58), .Z(N66) );
  IV I_14 ( .A(N64), .Z(N65) );
  OR2 C377 ( .A(encode_data_in[0]), .B(N63), .Z(N64) );
  OR2 C376 ( .A(encode_data_in[1]), .B(N62), .Z(N63) );
  OR2 C375 ( .A(N9), .B(N61), .Z(N62) );
  OR2 C374 ( .A(N8), .B(N60), .Z(N61) );
  OR2 C373 ( .A(N7), .B(N59), .Z(N60) );
  OR2 C372 ( .A(encode_data_in[5]), .B(N58), .Z(N59) );
  OR2 C371 ( .A(N26), .B(N42), .Z(N58) );
  IV I_13 ( .A(N56), .Z(N57) );
  OR2 C364 ( .A(encode_data_in[0]), .B(N55), .Z(N56) );
  OR2 C363 ( .A(encode_data_in[1]), .B(N54), .Z(N55) );
  OR2 C362 ( .A(N9), .B(N53), .Z(N54) );
  OR2 C361 ( .A(N8), .B(N52), .Z(N53) );
  OR2 C360 ( .A(N7), .B(N51), .Z(N52) );
  OR2 C359 ( .A(N18), .B(N43), .Z(N51) );
  IV I_12 ( .A(N49), .Z(N50) );
  OR2 C351 ( .A(encode_data_in[0]), .B(N48), .Z(N49) );
  OR2 C350 ( .A(encode_data_in[1]), .B(N47), .Z(N48) );
  OR2 C349 ( .A(N9), .B(N46), .Z(N47) );
  OR2 C348 ( .A(N8), .B(N45), .Z(N46) );
  OR2 C347 ( .A(N7), .B(N44), .Z(N45) );
  OR2 C346 ( .A(encode_data_in[5]), .B(N43), .Z(N44) );
  OR2 C345 ( .A(encode_data_in[6]), .B(N42), .Z(N43) );
  IV I_11 ( .A(encode_data_in[7]), .Z(N42) );
  IV I_10 ( .A(N40), .Z(N41) );
  OR2 C339 ( .A(encode_data_in[0]), .B(N39), .Z(N40) );
  OR2 C338 ( .A(encode_data_in[1]), .B(N38), .Z(N39) );
  OR2 C337 ( .A(N9), .B(N37), .Z(N38) );
  OR2 C336 ( .A(N8), .B(N36), .Z(N37) );
  OR2 C335 ( .A(N7), .B(N35), .Z(N36) );
  OR2 C334 ( .A(N18), .B(N27), .Z(N35) );
  IV I_9 ( .A(N33), .Z(N34) );
  OR2 C326 ( .A(encode_data_in[0]), .B(N32), .Z(N33) );
  OR2 C325 ( .A(encode_data_in[1]), .B(N31), .Z(N32) );
  OR2 C324 ( .A(N9), .B(N30), .Z(N31) );
  OR2 C323 ( .A(N8), .B(N29), .Z(N30) );
  OR2 C322 ( .A(N7), .B(N28), .Z(N29) );
  OR2 C321 ( .A(encode_data_in[5]), .B(N27), .Z(N28) );
  OR2 C320 ( .A(N26), .B(encode_data_in[7]), .Z(N27) );
  IV I_8 ( .A(encode_data_in[6]), .Z(N26) );
  IV I_7 ( .A(N24), .Z(N25) );
  OR2 C314 ( .A(encode_data_in[0]), .B(N23), .Z(N24) );
  OR2 C313 ( .A(encode_data_in[1]), .B(N22), .Z(N23) );
  OR2 C312 ( .A(N9), .B(N21), .Z(N22) );
  OR2 C311 ( .A(N8), .B(N20), .Z(N21) );
  OR2 C310 ( .A(N7), .B(N19), .Z(N20) );
  OR2 C309 ( .A(N18), .B(N10), .Z(N19) );
  IV I_6 ( .A(encode_data_in[5]), .Z(N18) );
  IV I_5 ( .A(N16), .Z(N17) );
  OR2 C302 ( .A(encode_data_in[0]), .B(N15), .Z(N16) );
  OR2 C301 ( .A(encode_data_in[1]), .B(N14), .Z(N15) );
  OR2 C300 ( .A(N9), .B(N13), .Z(N14) );
  OR2 C299 ( .A(N8), .B(N12), .Z(N13) );
  OR2 C298 ( .A(N7), .B(N11), .Z(N12) );
  OR2 C297 ( .A(encode_data_in[5]), .B(N10), .Z(N11) );
  OR2 C296 ( .A(encode_data_in[6]), .B(encode_data_in[7]), .Z(N10) );
  IV I_4 ( .A(encode_data_in[2]), .Z(N9) );
  IV I_3 ( .A(encode_data_in[3]), .Z(N8) );
  IV I_2 ( .A(encode_data_in[4]), .Z(N7) );
  IV I_1 ( .A(konstant), .Z(N6) );
  IV I_0 ( .A(rst), .Z(N5) );
  FD1 bad_code_reg_reg ( .D(bad_code), .CP(clk), .Q(bad_code_reg) );
  FD1 disp_lat_reg ( .D(n98), .CP(clk), .Q(disp_lat) );
  FD1 konstant_latch_reg ( .D(konstant), .CP(clk), .Q(konstant_latch) );
  FD1 ip_data_latch_reg_2_ ( .D(encode_data_in[5]), .CP(clk), .Q(
        ip_data_latch[2]) );
  FD1 ip_data_latch_reg_1_ ( .D(encode_data_in[6]), .CP(clk), .Q(
        ip_data_latch[1]) );
  FD1 ip_data_latch_reg_0_ ( .D(encode_data_in[7]), .CP(clk), .Q(ins[1]) );
  FD1 disp_lat_fix_latch_reg ( .D(disp_lat_fix), .CP(clk), .Q(disp_out) );
  FD1 data_out_latch_reg_5_ ( .D(data_out[9]), .CP(clk), .Q(data_out_latch[5])
         );
  FD1 data_out_latch_reg_4_ ( .D(data_out[8]), .CP(clk), .Q(data_out_latch[4])
         );
  FD1 data_out_latch_reg_3_ ( .D(data_out[7]), .CP(clk), .Q(data_out_latch[3])
         );
  FD1 data_out_latch_reg_2_ ( .D(data_out[6]), .CP(clk), .Q(data_out_latch[2])
         );
  FD1 data_out_latch_reg_1_ ( .D(data_out[5]), .CP(clk), .Q(data_out_latch[1])
         );
  FD1 data_out_latch_reg_0_ ( .D(data_out[4]), .CP(clk), .Q(data_out_latch[0])
         );
  FD1 kx_latch_reg ( .D(N140), .CP(clk), .Q(kx_latch) );
  FD1 plus34_latch_reg ( .D(plus34), .CP(clk), .Q(plus34_latch) );
  FD1 minus34b_latch_reg ( .D(N99), .CP(clk), .Q(minus34b_latch) );
  FD1 i_disp_latch_reg ( .D(n2), .CP(clk), .Q(i_disp_latch) );
  IV U20 ( .A(N227), .Z(n18) );
  IV U21 ( .A(int[0]), .Z(n19) );
  IV U22 ( .A(int[1]), .Z(n20) );
  IV U23 ( .A(N226), .Z(n21) );
  IV U24 ( .A(int[3]), .Z(n22) );
  IV U25 ( .A(encode_data_in[4]), .Z(n23) );
  IV U26 ( .A(n91), .Z(n24) );
  IV U27 ( .A(int[4]), .Z(n25) );
  IV U28 ( .A(int[2]), .Z(n26) );
  IV U29 ( .A(encode_data_in[2]), .Z(n27) );
  IV U30 ( .A(encode_data_in[1]), .Z(n28) );
  IV U31 ( .A(N121), .Z(n29) );
  IV U32 ( .A(encode_data_in[0]), .Z(n30) );
  OR2 U72 ( .A(n90), .B(n24), .Z(N200) );
  OR2 U73 ( .A(n27), .B(encode_data_in[3]), .Z(n91) );
  AN2 U74 ( .A(encode_data_in[3]), .B(n27), .Z(n90) );
  OR2 U75 ( .A(n92), .B(n93), .Z(N199) );
  AN2 U76 ( .A(encode_data_in[0]), .B(n28), .Z(n93) );
  AN2 U77 ( .A(encode_data_in[1]), .B(n30), .Z(n92) );
  OR2 U78 ( .A(n94), .B(n95), .Z(N197) );
  AN2 U79 ( .A(N121), .B(n23), .Z(n95) );
  AN2 U80 ( .A(encode_data_in[4]), .B(n29), .Z(n94) );
  OR2 U81 ( .A(n96), .B(n97), .Z(N194) );
  AN2 U82 ( .A(N107), .B(n23), .Z(n97) );
  AN2 U83 ( .A(encode_data_in[4]), .B(N106), .Z(n96) );
  OR2 U84 ( .A(n99), .B(n100), .Z(disp_lat_fix) );
  AN2 U85 ( .A(n5), .B(bad_disp), .Z(n100) );
  AN2 U86 ( .A(disp_lat), .B(N97), .Z(n99) );
  AN2 U87 ( .A(f_disp), .B(N5), .Z(n98) );
  IV U88 ( .A(alt_7), .Z(n7) );
  IV U89 ( .A(disp_lat), .Z(n5) );
  IV U90 ( .A(i_disp_latch), .Z(n17) );
  IV U91 ( .A(N141), .Z(n16) );
  IV U92 ( .A(N90), .Z(n13) );
  IV U93 ( .A(N95), .Z(n10) );
  IV U94 ( .A(bad_code_reg), .Z(n1) );
  OR2 U95 ( .A(n101), .B(n102), .Z(f_disp) );
  AN2 U96 ( .A(N227), .B(n103), .Z(n102) );
  AN2 U97 ( .A(n18), .B(n2), .Z(n101) );
  IV U98 ( .A(n103), .Z(n2) );
  OR2 U99 ( .A(n104), .B(n105), .Z(n103) );
  AN2 U100 ( .A(N226), .B(disp_lat_fix), .Z(n105) );
  AN2 U101 ( .A(n21), .B(n4), .Z(n104) );
  IV U102 ( .A(disp_lat_fix), .Z(n4) );
  OR2 U103 ( .A(n106), .B(n107), .Z(data_out[9]) );
  AN2 U104 ( .A(n30), .B(t1_5_), .Z(n107) );
  AN2 U105 ( .A(encode_data_in[0]), .B(n108), .Z(n106) );
  OR2 U106 ( .A(n109), .B(n110), .Z(data_out[8]) );
  AN2 U107 ( .A(n25), .B(t1_5_), .Z(n110) );
  AN2 U108 ( .A(int[4]), .B(n108), .Z(n109) );
  OR2 U109 ( .A(n111), .B(n112), .Z(data_out[7]) );
  AN2 U110 ( .A(n22), .B(t1_5_), .Z(n112) );
  AN2 U111 ( .A(int[3]), .B(n108), .Z(n111) );
  OR2 U112 ( .A(n113), .B(n114), .Z(data_out[6]) );
  AN2 U113 ( .A(n26), .B(t1_5_), .Z(n114) );
  AN2 U114 ( .A(int[2]), .B(n108), .Z(n113) );
  OR2 U115 ( .A(n115), .B(n116), .Z(data_out[5]) );
  AN2 U116 ( .A(n20), .B(t1_5_), .Z(n116) );
  AN2 U117 ( .A(int[1]), .B(n108), .Z(n115) );
  OR2 U118 ( .A(n117), .B(n118), .Z(data_out[4]) );
  AN2 U119 ( .A(n19), .B(t1_5_), .Z(n118) );
  AN2 U120 ( .A(int[0]), .B(n108), .Z(n117) );
  IV U121 ( .A(t1_5_), .Z(n108) );
  OR2 U122 ( .A(n119), .B(n120), .Z(data_out[3]) );
  AN2 U123 ( .A(ins[3]), .B(n121), .Z(n120) );
  AN2 U124 ( .A(t2_3_), .B(n122), .Z(n119) );
  IV U125 ( .A(ins[3]), .Z(n122) );
  OR2 U126 ( .A(n123), .B(n124), .Z(data_out[2]) );
  AN2 U127 ( .A(ins[2]), .B(n121), .Z(n124) );
  AN2 U128 ( .A(t2_3_), .B(n125), .Z(n123) );
  IV U129 ( .A(ins[2]), .Z(n125) );
  OR2 U130 ( .A(n126), .B(n127), .Z(data_out[1]) );
  AN2 U131 ( .A(ins[1]), .B(n121), .Z(n127) );
  AN2 U132 ( .A(t2_3_), .B(n15), .Z(n126) );
  IV U133 ( .A(ins[1]), .Z(n15) );
  OR2 U134 ( .A(n128), .B(n129), .Z(data_out[0]) );
  AN2 U135 ( .A(ins[0]), .B(n121), .Z(n129) );
  IV U136 ( .A(t2_3_), .Z(n121) );
  AN2 U137 ( .A(t2_3_), .B(n130), .Z(n128) );
  IV U138 ( .A(ins[0]), .Z(n130) );
  OR2 U139 ( .A(n131), .B(n132), .Z(N237) );
  AN2 U140 ( .A(ip_data_latch[1]), .B(n11), .Z(n132) );
  IV U141 ( .A(ip_data_latch[2]), .Z(n11) );
  AN2 U142 ( .A(ip_data_latch[2]), .B(n14), .Z(n131) );
  IV U143 ( .A(ip_data_latch[1]), .Z(n14) );
endmodule

