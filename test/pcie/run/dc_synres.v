
module PCIEXP_TX ( PCLK250, RST_BeaconEnable_R0, CNTL_RESETN_P0, 
        CNTL_Loopback_P0, CNTL_TXEnable_P0, RX_LoopbackData_P2, TXCOMPLIANCE, 
        TXDATA, TXDATAK, TXELECIDLE, HSS_TXBEACONCMD, HSS_TXD, HSS_TXELECIDLE, 
        assertion_shengyushen );
  input [9:0] RX_LoopbackData_P2;
  input [7:0] TXDATA;
  output [9:0] HSS_TXD;
  input PCLK250, RST_BeaconEnable_R0, CNTL_RESETN_P0, CNTL_Loopback_P0,
         CNTL_TXEnable_P0, TXCOMPLIANCE, TXDATAK, TXELECIDLE;
  output HSS_TXBEACONCMD, HSS_TXELECIDLE, assertion_shengyushen;
  wire   InputDataEnable_P2, InputDataK_P0, InputCompliance_P0,
         InputDataEnable_P0, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         N16, N17, N18, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29,
         N30, N31, N32, N33, N34, N35, N36, N37, N38, N39, N40, N41, N42, N43,
         N44, N45, N46, N47, N48, N49, N50, N51, N52, N53, N54, N55, N56, N57,
         N58, N59, N60, N61, N62, N63, N64, N65, N66, N67, N68, N69, N70, N71,
         N72, N73, N74, N75, N76, N77, N78, N79, N80, N81, N82, N83, N84, N85,
         N86, N87, N88, N89, N90, N92, N93, N94, N95, N96, N97, N98, N99, N100,
         N101, N102, N103, N104, N105, N106, N107, N143, N142, N1411, N140,
         N139, N137, N136, N135, N134, N1311, N130, N128, N127, N126, N125,
         N124, N123, N122, N119, N118, N117, N115, N114, N113, N112, N1111,
         N1101, N109, N1081, N1071, N1061, N1051, N1041, N1031, N1021, N1011,
         N1001, N991, N981, N971, N961, N951, N941, N931, N921, N911, N901,
         N891, N881, N851, N831, N821, N811, N791, N781, N771, N751, N741,
         N731, N711, N701, N681, N661, N641, N631, N611, N591, N571, N551,
         N531, N511, N501, N491, N481, N461, N451, N421, N411, N401, N371,
         N361, N351, N321, N291, N261, N251, N231, N211, N181, N171, N161,
         N141, N131, N121, N108, N910, N810, N710, N610, N510, N310, N210,
         INVERT34, INVERT56, DISPARITY, KCODE_OPT, PLUS_34_NEUT_DISP,
         PLUS_34_FLP_DISP, DATA_OUT_34_0, ALT_7, MINUS_56_FLP_DISP,
         PLUS_56_FLP_DISP, DISPARITY_P2, DISPARITY_P0, n22, n23, n25, n27, n29,
         n31, n33, n35, n37, n39, n41, n90, n91, n92, n93, n94, n95, n96, n97,
         n98, n99, n100, n101, n102, n103, n104, n105, n106, n107, n108, n109,
         n110, n111, n112, n113, n114, n115, n116, n117, n118, n119, n120,
         n121, n122, n123, n124, n125, n126, n127, n128, n129, n130, n131,
         n132, n133, n134, n135, n136, n137, n138, n139, n140, n141, n142,
         n143, n144, n145, n146, n147, n148, n149, n150, n155, n157, n158,
         n159, n160, n161, n162, n163, n164, n165, n166, n167, n168, n169,
         n170, n171, n172, n173, n174, n175, n176, n177, n178, n179, n180,
         n181, n182, n183, n184, n185, n186, n187, n188, n189, n190, n191,
         n192, n193, n194, n195, n196, n197, n198, n199, n200, n201, n202,
         n203, n204, n205, n206, n207, n208, n209, n210, n211, n212, n213,
         n214, n215, n216, n217, n218, n219, n220, n221, n222, n223, n224,
         n225, n226, n227, n228, n229, n230, n231, n232, n233, n234, n235,
         n236, n237, n238, n239, n240, n241, n242, n243, n244, n245, n246,
         n247, n248, n249, n250, n251, n252, n253, n254, n255, n256;
  wire   [7:0] InputData_P0;
  wire   [9:0] EncodedData_P2;
  wire   [9:0] MuxedData_P2;
  wire   [3:2] DATA_OUT_34;
  wire   [4:0] DATA_OUT_56;

  OR2 C36 ( .A(n119), .B(n120), .Z(N210) );
  OR2 C37 ( .A(InputData_P0[7]), .B(N210), .Z(N310) );
  AN2 C39 ( .A(InputData_P0[1]), .B(InputData_P0[0]), .Z(N510) );
  AN2 C40 ( .A(InputData_P0[2]), .B(N510), .Z(N610) );
  AN2 C41 ( .A(InputData_P0[3]), .B(N610), .Z(N710) );
  OR2 C42 ( .A(InputData_P0[1]), .B(InputData_P0[0]), .Z(N810) );
  OR2 C43 ( .A(InputData_P0[2]), .B(N810), .Z(N910) );
  OR2 C44 ( .A(InputData_P0[3]), .B(N910), .Z(N108) );
  AN2 C46 ( .A(InputData_P0[6]), .B(InputData_P0[5]), .Z(N121) );
  AN2 C47 ( .A(InputData_P0[7]), .B(N121), .Z(N131) );
  OR2 C48 ( .A(EncodedData_P2[5]), .B(EncodedData_P2[4]), .Z(N141) );
  AN2 C50 ( .A(EncodedData_P2[5]), .B(EncodedData_P2[4]), .Z(N161) );
  OR2 C53 ( .A(InputData_P0[6]), .B(InputData_P0[5]), .Z(N171) );
  OR2 C54 ( .A(InputData_P0[7]), .B(N171), .Z(N181) );
  OR2 C58 ( .A(n116), .B(N171), .Z(N211) );
  OR2 C60 ( .A(InputData_P0[3]), .B(InputData_P0[2]), .Z(N231) );
  OR2 C67 ( .A(n139), .B(N451), .Z(N251) );
  OR2 C68 ( .A(InputData_P0[4]), .B(N251), .Z(N261) );
  OR2 C75 ( .A(n130), .B(N461), .Z(N291) );
  OR2 C80 ( .A(n139), .B(N910), .Z(N321) );
  OR2 C83 ( .A(InputData_P0[1]), .B(n148), .Z(N351) );
  OR2 C84 ( .A(InputData_P0[2]), .B(N351), .Z(N361) );
  OR2 C85 ( .A(InputData_P0[3]), .B(N361), .Z(N371) );
  OR2 C88 ( .A(n147), .B(InputData_P0[0]), .Z(N401) );
  OR2 C89 ( .A(InputData_P0[2]), .B(N401), .Z(N411) );
  OR2 C90 ( .A(InputData_P0[3]), .B(N411), .Z(N421) );
  OR2 C94 ( .A(n146), .B(N810), .Z(N451) );
  OR2 C95 ( .A(InputData_P0[3]), .B(N451), .Z(N461) );
  OR2 C1001 ( .A(n147), .B(n148), .Z(N481) );
  OR2 C1011 ( .A(n146), .B(N481), .Z(N491) );
  OR2 C1021 ( .A(InputData_P0[3]), .B(N491), .Z(N501) );
  OR2 C1031 ( .A(InputData_P0[4]), .B(N501), .Z(N511) );
  OR2 C108 ( .A(InputData_P0[4]), .B(N108), .Z(N531) );
  OR2 C1141 ( .A(InputData_P0[4]), .B(N371), .Z(N551) );
  OR2 C120 ( .A(InputData_P0[4]), .B(N421), .Z(N571) );
  OR2 C1261 ( .A(InputData_P0[4]), .B(N461), .Z(N591) );
  OR2 C132 ( .A(InputData_P0[4]), .B(N321), .Z(N611) );
  OR2 C1401 ( .A(n139), .B(N491), .Z(N631) );
  OR2 C141 ( .A(InputData_P0[4]), .B(N631), .Z(N641) );
  OR2 C1481 ( .A(n130), .B(N321), .Z(N661) );
  OR2 C154 ( .A(n130), .B(N108), .Z(N681) );
  AN2 C159 ( .A(InputData_P0[4]), .B(N710), .Z(N701) );
  OR2 C167 ( .A(n130), .B(N501), .Z(N711) );
  OR2 C1741 ( .A(InputData_P0[2]), .B(N481), .Z(N731) );
  OR2 C1751 ( .A(n139), .B(N731), .Z(N741) );
  OR2 C1761 ( .A(n130), .B(N741), .Z(N751) );
  OR2 C183 ( .A(n146), .B(N351), .Z(N771) );
  OR2 C184 ( .A(n139), .B(N771), .Z(N781) );
  OR2 C185 ( .A(n130), .B(N781), .Z(N791) );
  OR2 C1921 ( .A(n146), .B(N401), .Z(N811) );
  OR2 C193 ( .A(n139), .B(N811), .Z(N821) );
  OR2 C194 ( .A(n130), .B(N821), .Z(N831) );
  OR2 C202 ( .A(n130), .B(N251), .Z(N851) );
  OR2 C2061 ( .A(N881), .B(n144), .Z(DATA_OUT_56[4]) );
  AN2 C2071 ( .A(InputData_P0[1]), .B(n145), .Z(N881) );
  OR2 C209 ( .A(N891), .B(n128), .Z(DATA_OUT_56[3]) );
  OR2 C210 ( .A(InputData_P0[2]), .B(n144), .Z(N891) );
  AN2 C211 ( .A(InputData_P0[3]), .B(n145), .Z(DATA_OUT_56[2]) );
  OR2 C213 ( .A(N901), .B(N921), .Z(DATA_OUT_56[1]) );
  OR2 C215 ( .A(N911), .B(n140), .Z(N921) );
  OR2 C216 ( .A(n142), .B(n141), .Z(N911) );
  OR2 C217 ( .A(N1021), .B(N1031), .Z(DATA_OUT_56[0]) );
  OR2 C218 ( .A(N1011), .B(N701), .Z(N1021) );
  OR2 C219 ( .A(N1001), .B(n129), .Z(N1011) );
  OR2 C2201 ( .A(N991), .B(n138), .Z(N1001) );
  OR2 C2211 ( .A(N941), .B(N981), .Z(N991) );
  AN2 C2221 ( .A(n143), .B(N931), .Z(N941) );
  AN2 C224 ( .A(N971), .B(n130), .Z(N981) );
  AN2 C225 ( .A(N951), .B(N961), .Z(N971) );
  AN2 C229 ( .A(n122), .B(InputDataK_P0), .Z(N1031) );
  OR2 C230 ( .A(N1081), .B(n128), .Z(PLUS_56_FLP_DISP) );
  OR2 C231 ( .A(N1071), .B(n131), .Z(N1081) );
  OR2 C232 ( .A(N1061), .B(n132), .Z(N1071) );
  OR2 C233 ( .A(N1051), .B(n133), .Z(N1061) );
  OR2 C234 ( .A(N1041), .B(n134), .Z(N1051) );
  OR2 C235 ( .A(n136), .B(n135), .Z(N1041) );
  OR2 C236 ( .A(N113), .B(N114), .Z(MINUS_56_FLP_DISP) );
  OR2 C2371 ( .A(N112), .B(N701), .Z(N113) );
  OR2 C238 ( .A(N1111), .B(n123), .Z(N112) );
  OR2 C239 ( .A(N1101), .B(n124), .Z(N1111) );
  OR2 C240 ( .A(N109), .B(n125), .Z(N1101) );
  OR2 C241 ( .A(n127), .B(n126), .Z(N109) );
  AN2 C242 ( .A(n122), .B(InputDataK_P0), .Z(N114) );
  AN2 C243 ( .A(N119), .B(N131), .Z(ALT_7) );
  OR2 C244 ( .A(N118), .B(InputDataK_P0), .Z(N119) );
  OR2 C245 ( .A(N115), .B(N117), .Z(N118) );
  AN2 C246 ( .A(n112), .B(n111), .Z(N115) );
  AN2 C247 ( .A(n155), .B(N161), .Z(N117) );
  AN2 C249 ( .A(InputData_P0[5]), .B(n110), .Z(DATA_OUT_34[3]) );
  OR2 C2511 ( .A(InputData_P0[6]), .B(n117), .Z(DATA_OUT_34[2]) );
  OR2 C2521 ( .A(N122), .B(ALT_7), .Z(DATA_OUT_34_0) );
  AN2 C253 ( .A(N124), .B(n116), .Z(N122) );
  OR2 C256 ( .A(n117), .B(n115), .Z(PLUS_34_FLP_DISP) );
  AN2 C257 ( .A(N123), .B(N124), .Z(PLUS_34_NEUT_DISP) );
  AN2 C2581 ( .A(n122), .B(InputDataK_P0), .Z(N123) );
  OR2 C2601 ( .A(N127), .B(n122), .Z(KCODE_OPT) );
  OR2 C261 ( .A(N126), .B(n123), .Z(N127) );
  OR2 C262 ( .A(N125), .B(n124), .Z(N126) );
  OR2 C2631 ( .A(n126), .B(n125), .Z(N125) );
  OR2 C2651 ( .A(PLUS_56_FLP_DISP), .B(MINUS_56_FLP_DISP), .Z(N128) );
  AN2 C266 ( .A(InputDataEnable_P0), .B(N1311), .Z(DISPARITY_P2) );
  OR2 C269 ( .A(PLUS_34_FLP_DISP), .B(N131), .Z(N130) );
  AN2 C270 ( .A(n114), .B(DISPARITY_P0), .Z(DISPARITY) );
  OR2 C272 ( .A(N137), .B(N139), .Z(INVERT56) );
  OR2 C273 ( .A(N134), .B(N136), .Z(N137) );
  AN2 C274 ( .A(n113), .B(PLUS_56_FLP_DISP), .Z(N134) );
  AN2 C2761 ( .A(DISPARITY), .B(N135), .Z(N136) );
  OR2 C2771 ( .A(n137), .B(MINUS_56_FLP_DISP), .Z(N135) );
  AN2 C2781 ( .A(n121), .B(InputDataK_P0), .Z(N139) );
  OR2 C2801 ( .A(N1411), .B(N143), .Z(INVERT34) );
  AN2 C2811 ( .A(n155), .B(N140), .Z(N1411) );
  OR2 C2831 ( .A(PLUS_34_FLP_DISP), .B(PLUS_34_NEUT_DISP), .Z(N140) );
  AN2 C2841 ( .A(n112), .B(N142), .Z(N143) );
  OR2 C2851 ( .A(n118), .B(N131), .Z(N142) );
  OR2 C292 ( .A(N17), .B(N25), .Z(N92) );
  OR2 C291 ( .A(N92), .B(N34), .Z(N93) );
  OR2 C290 ( .A(N93), .B(N41), .Z(N94) );
  OR2 C289 ( .A(N94), .B(N50), .Z(N95) );
  OR2 C288 ( .A(N95), .B(N57), .Z(N96) );
  OR2 C287 ( .A(N96), .B(N65), .Z(N97) );
  OR2 C286 ( .A(N97), .B(N72), .Z(N98) );
  OR2 C285 ( .A(N98), .B(N79), .Z(N99) );
  OR2 C284 ( .A(N99), .B(N83), .Z(N100) );
  OR2 C283 ( .A(N100), .B(N85), .Z(N101) );
  OR2 C282 ( .A(N101), .B(N88), .Z(N102) );
  AN2 C281 ( .A(TXDATAK), .B(N102), .Z(N103) );
  OR2 C280 ( .A(N6), .B(N103), .Z(N104) );
  AN2 C279 ( .A(N104), .B(CNTL_RESETN_P0), .Z(N105) );
  AN2 C278 ( .A(N105), .B(CNTL_TXEnable_P0), .Z(N106) );
  AN2 C277 ( .A(N106), .B(N89), .Z(N107) );
  AN2 C276 ( .A(N107), .B(N90), .Z(assertion_shengyushen) );
  AN2 C265 ( .A(CNTL_TXEnable_P0), .B(N89), .Z(InputDataEnable_P2) );
  AN2 C263 ( .A(RST_BeaconEnable_R0), .B(N89), .Z(HSS_TXBEACONCMD) );
  IV I_22 ( .A(CNTL_Loopback_P0), .Z(N90) );
  IV I_21 ( .A(TXELECIDLE), .Z(N89) );
  IV I_20 ( .A(N87), .Z(N88) );
  OR2 C252 ( .A(TXDATA[0]), .B(N86), .Z(N87) );
  OR2 C251 ( .A(N73), .B(N69), .Z(N86) );
  IV I_19 ( .A(N84), .Z(N85) );
  OR2 C237 ( .A(N74), .B(N70), .Z(N84) );
  IV I_18 ( .A(N82), .Z(N83) );
  OR2 C222 ( .A(N74), .B(N81), .Z(N82) );
  OR2 C221 ( .A(N73), .B(N80), .Z(N81) );
  OR2 C220 ( .A(TXDATA[2]), .B(N68), .Z(N80) );
  IV I_17 ( .A(N78), .Z(N79) );
  OR2 C207 ( .A(N74), .B(N77), .Z(N78) );
  OR2 C206 ( .A(N73), .B(N76), .Z(N77) );
  OR2 C205 ( .A(N9), .B(N75), .Z(N76) );
  OR2 C204 ( .A(TXDATA[3]), .B(N67), .Z(N75) );
  IV I_16 ( .A(TXDATA[0]), .Z(N74) );
  IV I_15 ( .A(TXDATA[1]), .Z(N73) );
  IV I_14 ( .A(N71), .Z(N72) );
  OR2 C192 ( .A(TXDATA[0]), .B(N70), .Z(N71) );
  OR2 C191 ( .A(TXDATA[1]), .B(N69), .Z(N70) );
  OR2 C190 ( .A(N9), .B(N68), .Z(N69) );
  OR2 C189 ( .A(N8), .B(N67), .Z(N68) );
  OR2 C188 ( .A(N7), .B(N66), .Z(N67) );
  OR2 C187 ( .A(N18), .B(N58), .Z(N66) );
  IV I_13 ( .A(N64), .Z(N65) );
  OR2 C178 ( .A(TXDATA[0]), .B(N63), .Z(N64) );
  OR2 C177 ( .A(TXDATA[1]), .B(N62), .Z(N63) );
  OR2 C176 ( .A(N9), .B(N61), .Z(N62) );
  OR2 C175 ( .A(N8), .B(N60), .Z(N61) );
  OR2 C174 ( .A(N7), .B(N59), .Z(N60) );
  OR2 C173 ( .A(TXDATA[5]), .B(N58), .Z(N59) );
  OR2 C172 ( .A(N26), .B(N42), .Z(N58) );
  IV I_12 ( .A(N56), .Z(N57) );
  OR2 C165 ( .A(TXDATA[0]), .B(N55), .Z(N56) );
  OR2 C164 ( .A(TXDATA[1]), .B(N54), .Z(N55) );
  OR2 C163 ( .A(N9), .B(N53), .Z(N54) );
  OR2 C162 ( .A(N8), .B(N52), .Z(N53) );
  OR2 C161 ( .A(N7), .B(N51), .Z(N52) );
  OR2 C160 ( .A(N18), .B(N43), .Z(N51) );
  IV I_11 ( .A(N49), .Z(N50) );
  OR2 C152 ( .A(TXDATA[0]), .B(N48), .Z(N49) );
  OR2 C151 ( .A(TXDATA[1]), .B(N47), .Z(N48) );
  OR2 C150 ( .A(N9), .B(N46), .Z(N47) );
  OR2 C149 ( .A(N8), .B(N45), .Z(N46) );
  OR2 C148 ( .A(N7), .B(N44), .Z(N45) );
  OR2 C147 ( .A(TXDATA[5]), .B(N43), .Z(N44) );
  OR2 C146 ( .A(TXDATA[6]), .B(N42), .Z(N43) );
  IV I_10 ( .A(TXDATA[7]), .Z(N42) );
  IV I_9 ( .A(N40), .Z(N41) );
  OR2 C140 ( .A(TXDATA[0]), .B(N39), .Z(N40) );
  OR2 C139 ( .A(TXDATA[1]), .B(N38), .Z(N39) );
  OR2 C138 ( .A(N9), .B(N37), .Z(N38) );
  OR2 C137 ( .A(N8), .B(N36), .Z(N37) );
  OR2 C136 ( .A(N7), .B(N35), .Z(N36) );
  OR2 C135 ( .A(N18), .B(N27), .Z(N35) );
  IV I_8 ( .A(N33), .Z(N34) );
  OR2 C127 ( .A(TXDATA[0]), .B(N32), .Z(N33) );
  OR2 C126 ( .A(TXDATA[1]), .B(N31), .Z(N32) );
  OR2 C125 ( .A(N9), .B(N30), .Z(N31) );
  OR2 C124 ( .A(N8), .B(N29), .Z(N30) );
  OR2 C123 ( .A(N7), .B(N28), .Z(N29) );
  OR2 C122 ( .A(TXDATA[5]), .B(N27), .Z(N28) );
  OR2 C121 ( .A(N26), .B(TXDATA[7]), .Z(N27) );
  IV I_7 ( .A(TXDATA[6]), .Z(N26) );
  IV I_6 ( .A(N24), .Z(N25) );
  OR2 C115 ( .A(TXDATA[0]), .B(N23), .Z(N24) );
  OR2 C114 ( .A(TXDATA[1]), .B(N22), .Z(N23) );
  OR2 C113 ( .A(N9), .B(N21), .Z(N22) );
  OR2 C112 ( .A(N8), .B(N20), .Z(N21) );
  OR2 C111 ( .A(N7), .B(N19), .Z(N20) );
  OR2 C110 ( .A(N18), .B(N10), .Z(N19) );
  IV I_5 ( .A(TXDATA[5]), .Z(N18) );
  IV I_4 ( .A(N16), .Z(N17) );
  OR2 C103 ( .A(TXDATA[0]), .B(N15), .Z(N16) );
  OR2 C102 ( .A(TXDATA[1]), .B(N14), .Z(N15) );
  OR2 C101 ( .A(N9), .B(N13), .Z(N14) );
  OR2 C100 ( .A(N8), .B(N12), .Z(N13) );
  OR2 C99 ( .A(N7), .B(N11), .Z(N12) );
  OR2 C98 ( .A(TXDATA[5]), .B(N10), .Z(N11) );
  OR2 C97 ( .A(TXDATA[6]), .B(TXDATA[7]), .Z(N10) );
  IV I_3 ( .A(TXDATA[2]), .Z(N9) );
  IV I_2 ( .A(TXDATA[3]), .Z(N8) );
  IV I_1 ( .A(TXDATA[4]), .Z(N7) );
  IV I_0 ( .A(TXDATAK), .Z(N6) );
  FD1 InputDataK_P0_reg ( .D(n109), .CP(PCLK250), .Q(InputDataK_P0) );
  FD1 InputCompliance_P0_reg ( .D(n108), .CP(PCLK250), .Q(InputCompliance_P0)
         );
  FD1 InputData_P0_reg_7_ ( .D(n107), .CP(PCLK250), .Q(InputData_P0[7]) );
  FD1 InputData_P0_reg_6_ ( .D(n106), .CP(PCLK250), .Q(InputData_P0[6]) );
  FD1 InputData_P0_reg_5_ ( .D(n105), .CP(PCLK250), .Q(InputData_P0[5]) );
  FD1 InputData_P0_reg_4_ ( .D(n104), .CP(PCLK250), .Q(InputData_P0[4]) );
  FD1 InputData_P0_reg_3_ ( .D(n103), .CP(PCLK250), .Q(InputData_P0[3]) );
  FD1 InputData_P0_reg_2_ ( .D(n102), .CP(PCLK250), .Q(InputData_P0[2]) );
  FD1 InputData_P0_reg_1_ ( .D(n101), .CP(PCLK250), .Q(InputData_P0[1]) );
  FD1 InputData_P0_reg_0_ ( .D(n100), .CP(PCLK250), .Q(InputData_P0[0]) );
  FD1 InputDataEnable_P0_reg ( .D(n178), .CP(PCLK250), .Q(InputDataEnable_P0)
         );
  FD1 OutputElecIdle_P0_reg ( .D(N5), .CP(PCLK250), .Q(HSS_TXELECIDLE) );
  FD1 DISPARITY_P0_reg ( .D(DISPARITY_P2), .CP(PCLK250), .Q(DISPARITY_P0) );
  FD1 OutputData_P0_reg_7_ ( .D(n99), .CP(PCLK250), .Q(HSS_TXD[7]) );
  FD1 OutputData_P0_reg_8_ ( .D(n98), .CP(PCLK250), .Q(HSS_TXD[8]) );
  FD1 OutputData_P0_reg_0_ ( .D(n97), .CP(PCLK250), .Q(HSS_TXD[0]) );
  FD1 OutputData_P0_reg_1_ ( .D(n96), .CP(PCLK250), .Q(HSS_TXD[1]) );
  FD1 OutputData_P0_reg_2_ ( .D(n95), .CP(PCLK250), .Q(HSS_TXD[2]) );
  FD1 OutputData_P0_reg_3_ ( .D(n94), .CP(PCLK250), .Q(HSS_TXD[3]) );
  FD1 OutputData_P0_reg_4_ ( .D(n93), .CP(PCLK250), .Q(HSS_TXD[4]) );
  FD1 OutputData_P0_reg_5_ ( .D(n92), .CP(PCLK250), .Q(HSS_TXD[5]) );
  FD1 OutputData_P0_reg_9_ ( .D(n91), .CP(PCLK250), .Q(HSS_TXD[9]) );
  FD1 OutputData_P0_reg_6_ ( .D(n90), .CP(PCLK250), .Q(HSS_TXD[6]) );
  AN2 U34 ( .A(TXDATA[0]), .B(InputDataEnable_P2), .Z(n22) );
  AN2 U37 ( .A(TXDATA[1]), .B(InputDataEnable_P2), .Z(n25) );
  AN2 U40 ( .A(TXDATA[2]), .B(InputDataEnable_P2), .Z(n27) );
  AN2 U43 ( .A(TXDATA[3]), .B(InputDataEnable_P2), .Z(n29) );
  AN2 U46 ( .A(TXDATA[4]), .B(InputDataEnable_P2), .Z(n31) );
  AN2 U49 ( .A(TXDATA[5]), .B(InputDataEnable_P2), .Z(n33) );
  AN2 U52 ( .A(TXDATA[6]), .B(InputDataEnable_P2), .Z(n35) );
  AN2 U55 ( .A(TXDATA[7]), .B(InputDataEnable_P2), .Z(n37) );
  AN2 U58 ( .A(TXCOMPLIANCE), .B(InputDataEnable_P2), .Z(n39) );
  AN2 U61 ( .A(TXDATAK), .B(InputDataEnable_P2), .Z(n41) );
  IV U63 ( .A(InputDataEnable_P2), .Z(n23) );
  IV U94 ( .A(CNTL_RESETN_P0), .Z(n150) );
  AN2 U171 ( .A(InputDataEnable_P2), .B(CNTL_RESETN_P0), .Z(n178) );
  OR2 U172 ( .A(n176), .B(n177), .Z(MuxedData_P2[9]) );
  AN2 U173 ( .A(EncodedData_P2[9]), .B(N90), .Z(n177) );
  AN2 U174 ( .A(RX_LoopbackData_P2[9]), .B(CNTL_Loopback_P0), .Z(n176) );
  OR2 U175 ( .A(n174), .B(n175), .Z(MuxedData_P2[8]) );
  AN2 U176 ( .A(EncodedData_P2[8]), .B(N90), .Z(n175) );
  AN2 U177 ( .A(RX_LoopbackData_P2[8]), .B(CNTL_Loopback_P0), .Z(n174) );
  OR2 U178 ( .A(n172), .B(n173), .Z(MuxedData_P2[7]) );
  AN2 U179 ( .A(EncodedData_P2[7]), .B(N90), .Z(n173) );
  AN2 U180 ( .A(RX_LoopbackData_P2[7]), .B(CNTL_Loopback_P0), .Z(n172) );
  OR2 U181 ( .A(n170), .B(n171), .Z(MuxedData_P2[6]) );
  AN2 U182 ( .A(EncodedData_P2[6]), .B(N90), .Z(n171) );
  AN2 U183 ( .A(RX_LoopbackData_P2[6]), .B(CNTL_Loopback_P0), .Z(n170) );
  OR2 U184 ( .A(n168), .B(n169), .Z(MuxedData_P2[5]) );
  AN2 U185 ( .A(EncodedData_P2[5]), .B(N90), .Z(n169) );
  AN2 U186 ( .A(RX_LoopbackData_P2[5]), .B(CNTL_Loopback_P0), .Z(n168) );
  OR2 U187 ( .A(n166), .B(n167), .Z(MuxedData_P2[4]) );
  AN2 U188 ( .A(EncodedData_P2[4]), .B(N90), .Z(n167) );
  AN2 U189 ( .A(RX_LoopbackData_P2[4]), .B(CNTL_Loopback_P0), .Z(n166) );
  OR2 U190 ( .A(n164), .B(n165), .Z(MuxedData_P2[3]) );
  AN2 U191 ( .A(EncodedData_P2[3]), .B(N90), .Z(n165) );
  AN2 U192 ( .A(RX_LoopbackData_P2[3]), .B(CNTL_Loopback_P0), .Z(n164) );
  OR2 U193 ( .A(n162), .B(n163), .Z(MuxedData_P2[2]) );
  AN2 U194 ( .A(EncodedData_P2[2]), .B(N90), .Z(n163) );
  AN2 U195 ( .A(RX_LoopbackData_P2[2]), .B(CNTL_Loopback_P0), .Z(n162) );
  OR2 U196 ( .A(n160), .B(n161), .Z(MuxedData_P2[1]) );
  AN2 U197 ( .A(EncodedData_P2[1]), .B(N90), .Z(n161) );
  AN2 U198 ( .A(RX_LoopbackData_P2[1]), .B(CNTL_Loopback_P0), .Z(n160) );
  OR2 U199 ( .A(n158), .B(n159), .Z(MuxedData_P2[0]) );
  AN2 U200 ( .A(EncodedData_P2[0]), .B(N90), .Z(n159) );
  AN2 U201 ( .A(RX_LoopbackData_P2[0]), .B(CNTL_Loopback_P0), .Z(n158) );
  OR2 U202 ( .A(n150), .B(n157), .Z(N5) );
  AN2 U203 ( .A(n149), .B(CNTL_RESETN_P0), .Z(n157) );
  OR2 U205 ( .A(n179), .B(n180), .Z(n99) );
  AN2 U206 ( .A(MuxedData_P2[7]), .B(InputDataEnable_P0), .Z(n180) );
  AN2 U207 ( .A(HSS_TXD[7]), .B(n149), .Z(n179) );
  OR2 U208 ( .A(n181), .B(n182), .Z(n98) );
  AN2 U209 ( .A(MuxedData_P2[8]), .B(InputDataEnable_P0), .Z(n182) );
  AN2 U210 ( .A(HSS_TXD[8]), .B(n149), .Z(n181) );
  OR2 U211 ( .A(n183), .B(n184), .Z(n97) );
  AN2 U212 ( .A(MuxedData_P2[0]), .B(InputDataEnable_P0), .Z(n184) );
  AN2 U213 ( .A(HSS_TXD[0]), .B(n149), .Z(n183) );
  OR2 U214 ( .A(n185), .B(n186), .Z(n96) );
  AN2 U215 ( .A(MuxedData_P2[1]), .B(InputDataEnable_P0), .Z(n186) );
  AN2 U216 ( .A(HSS_TXD[1]), .B(n149), .Z(n185) );
  OR2 U217 ( .A(n187), .B(n188), .Z(n95) );
  AN2 U218 ( .A(MuxedData_P2[2]), .B(InputDataEnable_P0), .Z(n188) );
  AN2 U219 ( .A(HSS_TXD[2]), .B(n149), .Z(n187) );
  OR2 U220 ( .A(n189), .B(n190), .Z(n94) );
  AN2 U221 ( .A(MuxedData_P2[3]), .B(InputDataEnable_P0), .Z(n190) );
  AN2 U222 ( .A(HSS_TXD[3]), .B(n149), .Z(n189) );
  OR2 U223 ( .A(n191), .B(n192), .Z(n93) );
  AN2 U224 ( .A(MuxedData_P2[4]), .B(InputDataEnable_P0), .Z(n192) );
  AN2 U225 ( .A(HSS_TXD[4]), .B(n149), .Z(n191) );
  OR2 U226 ( .A(n193), .B(n194), .Z(n92) );
  AN2 U227 ( .A(MuxedData_P2[5]), .B(InputDataEnable_P0), .Z(n194) );
  AN2 U228 ( .A(HSS_TXD[5]), .B(n149), .Z(n193) );
  OR2 U229 ( .A(n195), .B(n196), .Z(n91) );
  AN2 U230 ( .A(MuxedData_P2[9]), .B(InputDataEnable_P0), .Z(n196) );
  AN2 U231 ( .A(HSS_TXD[9]), .B(n149), .Z(n195) );
  OR2 U232 ( .A(n197), .B(n198), .Z(n90) );
  AN2 U233 ( .A(MuxedData_P2[6]), .B(InputDataEnable_P0), .Z(n198) );
  AN2 U234 ( .A(HSS_TXD[6]), .B(n149), .Z(n197) );
  IV U235 ( .A(InputDataEnable_P0), .Z(n149) );
  IV U236 ( .A(N710), .Z(n145) );
  IV U237 ( .A(N108), .Z(n144) );
  IV U238 ( .A(N231), .Z(n143) );
  IV U239 ( .A(N371), .Z(n142) );
  IV U240 ( .A(N421), .Z(n141) );
  IV U241 ( .A(N461), .Z(n140) );
  IV U242 ( .A(N261), .Z(n138) );
  IV U243 ( .A(N511), .Z(n137) );
  IV U244 ( .A(N531), .Z(n136) );
  IV U245 ( .A(N551), .Z(n135) );
  IV U246 ( .A(N571), .Z(n134) );
  IV U247 ( .A(N591), .Z(n133) );
  IV U248 ( .A(N611), .Z(n132) );
  IV U249 ( .A(N641), .Z(n131) );
  IV U250 ( .A(N291), .Z(n129) );
  IV U251 ( .A(N661), .Z(n128) );
  IV U252 ( .A(N681), .Z(n127) );
  IV U253 ( .A(N711), .Z(n126) );
  IV U254 ( .A(N751), .Z(n125) );
  IV U255 ( .A(N791), .Z(n124) );
  IV U256 ( .A(N831), .Z(n123) );
  IV U257 ( .A(N851), .Z(n122) );
  IV U258 ( .A(KCODE_OPT), .Z(n121) );
  IV U259 ( .A(N310), .Z(n118) );
  IV U260 ( .A(N181), .Z(n117) );
  IV U261 ( .A(N211), .Z(n115) );
  IV U262 ( .A(InputCompliance_P0), .Z(n114) );
  IV U263 ( .A(N141), .Z(n111) );
  IV U264 ( .A(ALT_7), .Z(n110) );
  OR2 U265 ( .A(n199), .B(n41), .Z(n109) );
  AN2 U266 ( .A(n23), .B(InputDataK_P0), .Z(n199) );
  OR2 U267 ( .A(n200), .B(n39), .Z(n108) );
  AN2 U268 ( .A(n23), .B(InputCompliance_P0), .Z(n200) );
  OR2 U269 ( .A(n201), .B(n37), .Z(n107) );
  AN2 U270 ( .A(n23), .B(InputData_P0[7]), .Z(n201) );
  OR2 U271 ( .A(n202), .B(n35), .Z(n106) );
  AN2 U272 ( .A(n23), .B(InputData_P0[6]), .Z(n202) );
  OR2 U273 ( .A(n203), .B(n33), .Z(n105) );
  AN2 U274 ( .A(n23), .B(InputData_P0[5]), .Z(n203) );
  OR2 U275 ( .A(n204), .B(n31), .Z(n104) );
  AN2 U276 ( .A(n23), .B(InputData_P0[4]), .Z(n204) );
  OR2 U277 ( .A(n205), .B(n29), .Z(n103) );
  AN2 U278 ( .A(n23), .B(InputData_P0[3]), .Z(n205) );
  OR2 U279 ( .A(n206), .B(n27), .Z(n102) );
  AN2 U280 ( .A(n23), .B(InputData_P0[2]), .Z(n206) );
  OR2 U281 ( .A(n207), .B(n25), .Z(n101) );
  AN2 U282 ( .A(n23), .B(InputData_P0[1]), .Z(n207) );
  OR2 U283 ( .A(n208), .B(n22), .Z(n100) );
  AN2 U284 ( .A(n23), .B(InputData_P0[0]), .Z(n208) );
  OR2 U285 ( .A(n209), .B(n210), .Z(N961) );
  AN2 U286 ( .A(InputData_P0[2]), .B(n139), .Z(n210) );
  IV U287 ( .A(InputData_P0[3]), .Z(n139) );
  AN2 U288 ( .A(InputData_P0[3]), .B(n146), .Z(n209) );
  IV U289 ( .A(InputData_P0[2]), .Z(n146) );
  OR2 U290 ( .A(n211), .B(n212), .Z(N951) );
  AN2 U291 ( .A(InputData_P0[0]), .B(n147), .Z(n212) );
  IV U292 ( .A(InputData_P0[1]), .Z(n147) );
  AN2 U293 ( .A(InputData_P0[1]), .B(n148), .Z(n211) );
  OR2 U294 ( .A(n213), .B(n214), .Z(N931) );
  AN2 U295 ( .A(InputData_P0[4]), .B(n215), .Z(n214) );
  IV U296 ( .A(N510), .Z(n215) );
  AN2 U297 ( .A(N510), .B(n130), .Z(n213) );
  AN2 U298 ( .A(n216), .B(n217), .Z(N901) );
  OR2 U299 ( .A(InputData_P0[4]), .B(n218), .Z(n217) );
  IV U300 ( .A(N321), .Z(n218) );
  OR2 U301 ( .A(N321), .B(n130), .Z(n216) );
  IV U302 ( .A(InputData_P0[4]), .Z(n130) );
  OR2 U303 ( .A(n219), .B(n220), .Z(N1311) );
  AN2 U304 ( .A(n112), .B(n221), .Z(n220) );
  IV U305 ( .A(N130), .Z(n221) );
  IV U306 ( .A(n155), .Z(n112) );
  AN2 U307 ( .A(N130), .B(n155), .Z(n219) );
  AN2 U308 ( .A(n222), .B(n223), .Z(n155) );
  OR2 U309 ( .A(n113), .B(N128), .Z(n223) );
  IV U310 ( .A(DISPARITY), .Z(n113) );
  OR2 U311 ( .A(n224), .B(DISPARITY), .Z(n222) );
  IV U312 ( .A(N128), .Z(n224) );
  OR2 U313 ( .A(n225), .B(n226), .Z(N124) );
  AN2 U314 ( .A(InputData_P0[5]), .B(n119), .Z(n226) );
  IV U315 ( .A(InputData_P0[6]), .Z(n119) );
  AN2 U316 ( .A(InputData_P0[6]), .B(n120), .Z(n225) );
  IV U317 ( .A(InputData_P0[5]), .Z(n120) );
  OR2 U318 ( .A(n227), .B(n228), .Z(EncodedData_P2[9]) );
  AN2 U319 ( .A(DATA_OUT_34_0), .B(n229), .Z(n228) );
  AN2 U320 ( .A(INVERT34), .B(n230), .Z(n227) );
  IV U321 ( .A(DATA_OUT_34_0), .Z(n230) );
  OR2 U322 ( .A(n231), .B(n232), .Z(EncodedData_P2[8]) );
  AN2 U323 ( .A(INVERT34), .B(n116), .Z(n232) );
  IV U324 ( .A(InputData_P0[7]), .Z(n116) );
  AN2 U325 ( .A(InputData_P0[7]), .B(n229), .Z(n231) );
  OR2 U326 ( .A(n233), .B(n234), .Z(EncodedData_P2[7]) );
  AN2 U327 ( .A(DATA_OUT_34[2]), .B(n229), .Z(n234) );
  AN2 U328 ( .A(INVERT34), .B(n235), .Z(n233) );
  IV U329 ( .A(DATA_OUT_34[2]), .Z(n235) );
  OR2 U330 ( .A(n236), .B(n237), .Z(EncodedData_P2[6]) );
  AN2 U331 ( .A(DATA_OUT_34[3]), .B(n229), .Z(n237) );
  IV U332 ( .A(INVERT34), .Z(n229) );
  AN2 U333 ( .A(INVERT34), .B(n238), .Z(n236) );
  IV U334 ( .A(DATA_OUT_34[3]), .Z(n238) );
  OR2 U335 ( .A(n239), .B(n240), .Z(EncodedData_P2[5]) );
  AN2 U336 ( .A(DATA_OUT_56[0]), .B(n241), .Z(n240) );
  AN2 U337 ( .A(INVERT56), .B(n242), .Z(n239) );
  IV U338 ( .A(DATA_OUT_56[0]), .Z(n242) );
  OR2 U339 ( .A(n243), .B(n244), .Z(EncodedData_P2[4]) );
  AN2 U340 ( .A(DATA_OUT_56[1]), .B(n241), .Z(n244) );
  AN2 U341 ( .A(INVERT56), .B(n245), .Z(n243) );
  IV U342 ( .A(DATA_OUT_56[1]), .Z(n245) );
  OR2 U343 ( .A(n246), .B(n247), .Z(EncodedData_P2[3]) );
  AN2 U344 ( .A(DATA_OUT_56[2]), .B(n241), .Z(n247) );
  AN2 U345 ( .A(INVERT56), .B(n248), .Z(n246) );
  IV U346 ( .A(DATA_OUT_56[2]), .Z(n248) );
  OR2 U347 ( .A(n249), .B(n250), .Z(EncodedData_P2[2]) );
  AN2 U348 ( .A(DATA_OUT_56[3]), .B(n241), .Z(n250) );
  AN2 U349 ( .A(INVERT56), .B(n251), .Z(n249) );
  IV U350 ( .A(DATA_OUT_56[3]), .Z(n251) );
  OR2 U351 ( .A(n252), .B(n253), .Z(EncodedData_P2[1]) );
  AN2 U352 ( .A(DATA_OUT_56[4]), .B(n241), .Z(n253) );
  AN2 U353 ( .A(INVERT56), .B(n254), .Z(n252) );
  IV U354 ( .A(DATA_OUT_56[4]), .Z(n254) );
  OR2 U355 ( .A(n255), .B(n256), .Z(EncodedData_P2[0]) );
  AN2 U356 ( .A(INVERT56), .B(n148), .Z(n256) );
  IV U357 ( .A(InputData_P0[0]), .Z(n148) );
  AN2 U358 ( .A(InputData_P0[0]), .B(n241), .Z(n255) );
  IV U359 ( .A(INVERT56), .Z(n241) );
endmodule

