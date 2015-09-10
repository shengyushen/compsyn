
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
         InputDataEnable_P0, OutputDataEnable_P2, OutputElecIdle_P2, N6, N7,
         N8, N9, N10, N11, N12, N13, N14, N15, N16, N17, N18, N19, N20, N21,
         N22, N23, N24, N25, N26, N27, N28, N29, N30, N31, N32, N33, N34, N35,
         N36, N37, N38, N39, N40, N41, N42, N43, N44, N45, N46, N47, N48, N49,
         N50, N51, N52, N53, N54, N55, N56, N57, N58, N59, N60, N61, N62, N63,
         N64, N65, N66, N67, N68, N69, N70, N71, N72, N73, N74, N75, N76, N77,
         N78, N79, N80, N81, N82, N83, N84, N85, N86, N87, N88, N89, N90, N91,
         N93, N94, N95, N96, N97, N98, N99, N100, N101, N102, N103, N104, N105,
         N106, N107, N145, N143, N1411, N140, N139, N137, N136, N135, N134,
         N133, N1311, N129, N128, N127, N126, N123, N122, N120, N119, N118,
         N117, N116, N115, N114, N113, N112, N1111, N1101, N109, N1081, N1071,
         N1061, N1051, N1041, N1031, N1021, N1011, N1001, N991, N981, N971,
         N961, N951, N941, N931, N921, N911, N901, N891, N881, N851, N831,
         N821, N811, N791, N781, N771, N751, N741, N731, N711, N701, N681,
         N661, N641, N631, N611, N591, N571, N551, N531, N511, N501, N491,
         N481, N461, N431, N421, N411, N391, N371, N361, N331, N321, N311,
         N281, N271, N261, N231, N211, N201, N181, N171, N161, N141, N111,
         N108, N910, N710, N510, N410, N110, N01, DATA_OUT_34_0, ALT_7,
         INVERT34_reg, DATA_IN_reg_0_, DATA_IN_reg_1_, DATA_IN_reg_2_,
         BP_DATAIN_34_000_reg, BP_DATAIN_34_111_reg, KCodeIn_P2_reg,
         DISPARITY_56_reg, INVERT34, INVERT56, DISPARITY, KCODE_OPT,
         PLUS_34_NEUT_DISP, PLUS_34_FLP_DISP, MINUS_56_FLP_DISP,
         PLUS_56_FLP_DISP, DISPARITY_P2, DISPARITY_P0, n23, n24, n26, n28, n30,
         n32, n34, n36, n38, n40, n42, n95, n96, n97, n98, n99, n100, n101,
         n102, n103, n104, n105, n106, n107, n108, n109, n110, n111, n112,
         n113, n114, n115, n116, n117, n118, n119, n120, n121, n122, n123,
         n124, n125, n126, n127, n128, n129, n130, n131, n132, n133, n134,
         n135, n136, n137, n138, n139, n140, n141, n142, n143, n144, n145,
         n146, n147, n148, n149, n150, n151, n152, n153, n154, n155, n156,
         n157, n162, n164, n165, n166, n167, n168, n169, n170, n171, n172,
         n173, n174, n175, n176, n177, n178, n179, n180, n181, n182, n183,
         n184, n185, n186, n187, n188, n189, n190, n191, n192, n193, n194,
         n195, n196, n197, n198, n199, n200, n201, n202, n203, n204, n205,
         n206, n207, n208, n209, n210, n211, n212, n213, n214, n215, n216,
         n217, n218, n219, n220, n221, n222, n223, n224, n225, n226, n227,
         n228, n229, n230, n231, n232, n233, n234, n235, n236, n237, n238,
         n239, n240, n241, n242, n243, n244, n245, n246, n247, n248, n249,
         n250, n251, n252, n253, n254, n255, n256, n257, n258, n259, n260,
         n261, n262, n263, n264, n265, n266, n267, n268;
  wire   [7:0] InputData_P0;
  wire   [9:0] EncodedData_P2;
  wire   [9:0] MuxedData_P2;
  wire   [3:2] DATA_OUT_34;
  wire   [9:4] DATA_OUT_810;
  wire   [4:0] DATA_OUT_56;

  AN2 C34 ( .A(InputData_P0[6]), .B(InputData_P0[5]), .Z(N01) );
  AN2 C35 ( .A(InputData_P0[7]), .B(N01), .Z(N110) );
  OR2 C38 ( .A(n122), .B(n123), .Z(N410) );
  OR2 C39 ( .A(InputData_P0[7]), .B(N410), .Z(N510) );
  OR2 C43 ( .A(EncodedData_P2[5]), .B(EncodedData_P2[4]), .Z(N710) );
  AN2 C45 ( .A(EncodedData_P2[5]), .B(EncodedData_P2[4]), .Z(N910) );
  OR2 C46 ( .A(InputData_P0[6]), .B(InputData_P0[5]), .Z(N108) );
  OR2 C47 ( .A(InputData_P0[7]), .B(N108), .Z(N111) );
  OR2 C51 ( .A(n119), .B(N108), .Z(N141) );
  OR2 C53 ( .A(InputData_P0[1]), .B(InputData_P0[0]), .Z(N161) );
  OR2 C54 ( .A(InputData_P0[2]), .B(N161), .Z(N171) );
  OR2 C55 ( .A(InputData_P0[3]), .B(N171), .Z(N181) );
  AN2 C58 ( .A(InputData_P0[2]), .B(N411), .Z(N201) );
  AN2 C59 ( .A(InputData_P0[3]), .B(N201), .Z(N211) );
  OR2 C63 ( .A(n142), .B(N171), .Z(N231) );
  OR2 C66 ( .A(InputData_P0[1]), .B(n151), .Z(N261) );
  OR2 C67 ( .A(InputData_P0[2]), .B(N261), .Z(N271) );
  OR2 C68 ( .A(InputData_P0[3]), .B(N271), .Z(N281) );
  OR2 C71 ( .A(n150), .B(InputData_P0[0]), .Z(N311) );
  OR2 C72 ( .A(InputData_P0[2]), .B(N311), .Z(N321) );
  OR2 C73 ( .A(InputData_P0[3]), .B(N321), .Z(N331) );
  OR2 C77 ( .A(n149), .B(N161), .Z(N361) );
  OR2 C78 ( .A(InputData_P0[3]), .B(N361), .Z(N371) );
  OR2 C80 ( .A(InputData_P0[3]), .B(InputData_P0[2]), .Z(N391) );
  AN2 C82 ( .A(InputData_P0[1]), .B(InputData_P0[0]), .Z(N411) );
  OR2 C87 ( .A(n142), .B(N361), .Z(N421) );
  OR2 C88 ( .A(InputData_P0[4]), .B(N421), .Z(N431) );
  OR2 C95 ( .A(n133), .B(N371), .Z(N461) );
  OR2 C1001 ( .A(n150), .B(n151), .Z(N481) );
  OR2 C1011 ( .A(n149), .B(N481), .Z(N491) );
  OR2 C1021 ( .A(InputData_P0[3]), .B(N491), .Z(N501) );
  OR2 C103 ( .A(InputData_P0[4]), .B(N501), .Z(N511) );
  OR2 C108 ( .A(InputData_P0[4]), .B(N181), .Z(N531) );
  OR2 C1141 ( .A(InputData_P0[4]), .B(N281), .Z(N551) );
  OR2 C1201 ( .A(InputData_P0[4]), .B(N331), .Z(N571) );
  OR2 C1261 ( .A(InputData_P0[4]), .B(N371), .Z(N591) );
  OR2 C132 ( .A(InputData_P0[4]), .B(N231), .Z(N611) );
  OR2 C140 ( .A(n142), .B(N491), .Z(N631) );
  OR2 C141 ( .A(InputData_P0[4]), .B(N631), .Z(N641) );
  OR2 C1481 ( .A(n133), .B(N231), .Z(N661) );
  OR2 C154 ( .A(n133), .B(N181), .Z(N681) );
  AN2 C1591 ( .A(InputData_P0[4]), .B(N211), .Z(N701) );
  OR2 C167 ( .A(n133), .B(N501), .Z(N711) );
  OR2 C1741 ( .A(InputData_P0[2]), .B(N481), .Z(N731) );
  OR2 C1751 ( .A(n142), .B(N731), .Z(N741) );
  OR2 C1761 ( .A(n133), .B(N741), .Z(N751) );
  OR2 C183 ( .A(n149), .B(N261), .Z(N771) );
  OR2 C184 ( .A(n142), .B(N771), .Z(N781) );
  OR2 C185 ( .A(n133), .B(N781), .Z(N791) );
  OR2 C192 ( .A(n149), .B(N311), .Z(N811) );
  OR2 C193 ( .A(n142), .B(N811), .Z(N821) );
  OR2 C194 ( .A(n133), .B(N821), .Z(N831) );
  OR2 C202 ( .A(n133), .B(N421), .Z(N851) );
  OR2 C2061 ( .A(N881), .B(n148), .Z(DATA_OUT_56[4]) );
  AN2 C207 ( .A(InputData_P0[1]), .B(n147), .Z(N881) );
  OR2 C209 ( .A(N891), .B(n131), .Z(DATA_OUT_56[3]) );
  OR2 C210 ( .A(InputData_P0[2]), .B(n148), .Z(N891) );
  AN2 C211 ( .A(InputData_P0[3]), .B(n147), .Z(DATA_OUT_56[2]) );
  OR2 C213 ( .A(N901), .B(N921), .Z(DATA_OUT_56[1]) );
  OR2 C215 ( .A(N911), .B(n144), .Z(N921) );
  OR2 C216 ( .A(n146), .B(n145), .Z(N911) );
  OR2 C217 ( .A(N1021), .B(N1031), .Z(DATA_OUT_56[0]) );
  OR2 C218 ( .A(N1011), .B(N701), .Z(N1021) );
  OR2 C2191 ( .A(N1001), .B(n132), .Z(N1011) );
  OR2 C2201 ( .A(N991), .B(n141), .Z(N1001) );
  OR2 C2211 ( .A(N941), .B(N981), .Z(N991) );
  AN2 C222 ( .A(n143), .B(N931), .Z(N941) );
  AN2 C224 ( .A(N971), .B(n133), .Z(N981) );
  AN2 C225 ( .A(N951), .B(N961), .Z(N971) );
  AN2 C229 ( .A(n125), .B(InputDataK_P0), .Z(N1031) );
  OR2 C230 ( .A(N1081), .B(n131), .Z(PLUS_56_FLP_DISP) );
  OR2 C231 ( .A(N1071), .B(n134), .Z(N1081) );
  OR2 C232 ( .A(N1061), .B(n135), .Z(N1071) );
  OR2 C233 ( .A(N1051), .B(n136), .Z(N1061) );
  OR2 C234 ( .A(N1041), .B(n137), .Z(N1051) );
  OR2 C235 ( .A(n139), .B(n138), .Z(N1041) );
  OR2 C2361 ( .A(N113), .B(N114), .Z(MINUS_56_FLP_DISP) );
  OR2 C237 ( .A(N112), .B(N701), .Z(N113) );
  OR2 C238 ( .A(N1111), .B(n126), .Z(N112) );
  OR2 C239 ( .A(N1101), .B(n127), .Z(N1111) );
  OR2 C240 ( .A(N109), .B(n128), .Z(N1101) );
  OR2 C241 ( .A(n130), .B(n129), .Z(N109) );
  AN2 C242 ( .A(n125), .B(InputDataK_P0), .Z(N114) );
  OR2 C243 ( .A(n120), .B(n118), .Z(PLUS_34_FLP_DISP) );
  AN2 C244 ( .A(N115), .B(N116), .Z(PLUS_34_NEUT_DISP) );
  AN2 C245 ( .A(n125), .B(InputDataK_P0), .Z(N115) );
  OR2 C247 ( .A(N119), .B(n125), .Z(KCODE_OPT) );
  OR2 C248 ( .A(N118), .B(n126), .Z(N119) );
  OR2 C249 ( .A(N117), .B(n127), .Z(N118) );
  OR2 C2501 ( .A(n129), .B(n128), .Z(N117) );
  OR2 C252 ( .A(PLUS_56_FLP_DISP), .B(MINUS_56_FLP_DISP), .Z(N120) );
  AN2 C253 ( .A(InputDataEnable_P0), .B(N123), .Z(DISPARITY_P2) );
  OR2 C256 ( .A(PLUS_34_FLP_DISP), .B(N110), .Z(N122) );
  AN2 C2571 ( .A(n117), .B(DISPARITY_P0), .Z(DISPARITY) );
  OR2 C2591 ( .A(N129), .B(N1311), .Z(INVERT56) );
  OR2 C260 ( .A(N126), .B(N128), .Z(N129) );
  AN2 C261 ( .A(n116), .B(PLUS_56_FLP_DISP), .Z(N126) );
  AN2 C263 ( .A(DISPARITY), .B(N127), .Z(N128) );
  OR2 C2641 ( .A(n140), .B(MINUS_56_FLP_DISP), .Z(N127) );
  AN2 C265 ( .A(n124), .B(InputDataK_P0), .Z(N1311) );
  OR2 C267 ( .A(N134), .B(N136), .Z(INVERT34) );
  AN2 C268 ( .A(n162), .B(N133), .Z(N134) );
  OR2 C270 ( .A(PLUS_34_FLP_DISP), .B(PLUS_34_NEUT_DISP), .Z(N133) );
  AN2 C271 ( .A(n115), .B(N135), .Z(N136) );
  OR2 C272 ( .A(n121), .B(N110), .Z(N135) );
  AN2 C2791 ( .A(N1411), .B(BP_DATAIN_34_111_reg), .Z(ALT_7) );
  OR2 C2801 ( .A(N140), .B(KCodeIn_P2_reg), .Z(N1411) );
  OR2 C2811 ( .A(N137), .B(N139), .Z(N140) );
  AN2 C2821 ( .A(DISPARITY_56_reg), .B(n157), .Z(N137) );
  AN2 C2831 ( .A(n156), .B(N910), .Z(N139) );
  AN2 C2851 ( .A(DATA_IN_reg_2_), .B(n155), .Z(DATA_OUT_34[3]) );
  OR2 C2871 ( .A(DATA_IN_reg_1_), .B(BP_DATAIN_34_000_reg), .Z(DATA_OUT_34[2])
         );
  OR2 C2881 ( .A(N145), .B(ALT_7), .Z(DATA_OUT_34_0) );
  AN2 C2891 ( .A(N143), .B(n154), .Z(N145) );
  OR2 C290 ( .A(N18), .B(N26), .Z(N93) );
  OR2 C289 ( .A(N93), .B(N35), .Z(N94) );
  OR2 C288 ( .A(N94), .B(N42), .Z(N95) );
  OR2 C287 ( .A(N95), .B(N51), .Z(N96) );
  OR2 C286 ( .A(N96), .B(N58), .Z(N97) );
  OR2 C285 ( .A(N97), .B(N66), .Z(N98) );
  OR2 C284 ( .A(N98), .B(N73), .Z(N99) );
  OR2 C283 ( .A(N99), .B(N80), .Z(N100) );
  OR2 C282 ( .A(N100), .B(N84), .Z(N101) );
  OR2 C281 ( .A(N101), .B(N86), .Z(N102) );
  OR2 C280 ( .A(N102), .B(N89), .Z(N103) );
  AN2 C279 ( .A(TXDATAK), .B(N103), .Z(N104) );
  OR2 C278 ( .A(N7), .B(N104), .Z(N105) );
  AN2 C277 ( .A(N105), .B(CNTL_RESETN_P0), .Z(N106) );
  AN2 C276 ( .A(N106), .B(N90), .Z(N107) );
  AN2 C275 ( .A(N107), .B(N91), .Z(assertion_shengyushen) );
  AN2 C264 ( .A(CNTL_TXEnable_P0), .B(N90), .Z(InputDataEnable_P2) );
  AN2 C262 ( .A(RST_BeaconEnable_R0), .B(N90), .Z(HSS_TXBEACONCMD) );
  IV I_22 ( .A(CNTL_Loopback_P0), .Z(N91) );
  IV I_21 ( .A(TXELECIDLE), .Z(N90) );
  IV I_20 ( .A(N88), .Z(N89) );
  OR2 C251 ( .A(TXDATA[0]), .B(N87), .Z(N88) );
  OR2 C250 ( .A(N74), .B(N70), .Z(N87) );
  IV I_19 ( .A(N85), .Z(N86) );
  OR2 C236 ( .A(N75), .B(N71), .Z(N85) );
  IV I_18 ( .A(N83), .Z(N84) );
  OR2 C221 ( .A(N75), .B(N82), .Z(N83) );
  OR2 C220 ( .A(N74), .B(N81), .Z(N82) );
  OR2 C219 ( .A(TXDATA[2]), .B(N69), .Z(N81) );
  IV I_17 ( .A(N79), .Z(N80) );
  OR2 C206 ( .A(N75), .B(N78), .Z(N79) );
  OR2 C205 ( .A(N74), .B(N77), .Z(N78) );
  OR2 C204 ( .A(N10), .B(N76), .Z(N77) );
  OR2 C203 ( .A(TXDATA[3]), .B(N68), .Z(N76) );
  IV I_16 ( .A(TXDATA[0]), .Z(N75) );
  IV I_15 ( .A(TXDATA[1]), .Z(N74) );
  IV I_14 ( .A(N72), .Z(N73) );
  OR2 C191 ( .A(TXDATA[0]), .B(N71), .Z(N72) );
  OR2 C190 ( .A(TXDATA[1]), .B(N70), .Z(N71) );
  OR2 C189 ( .A(N10), .B(N69), .Z(N70) );
  OR2 C188 ( .A(N9), .B(N68), .Z(N69) );
  OR2 C187 ( .A(N8), .B(N67), .Z(N68) );
  OR2 C186 ( .A(N19), .B(N59), .Z(N67) );
  IV I_13 ( .A(N65), .Z(N66) );
  OR2 C177 ( .A(TXDATA[0]), .B(N64), .Z(N65) );
  OR2 C176 ( .A(TXDATA[1]), .B(N63), .Z(N64) );
  OR2 C175 ( .A(N10), .B(N62), .Z(N63) );
  OR2 C174 ( .A(N9), .B(N61), .Z(N62) );
  OR2 C173 ( .A(N8), .B(N60), .Z(N61) );
  OR2 C172 ( .A(TXDATA[5]), .B(N59), .Z(N60) );
  OR2 C171 ( .A(N27), .B(N43), .Z(N59) );
  IV I_12 ( .A(N57), .Z(N58) );
  OR2 C164 ( .A(TXDATA[0]), .B(N56), .Z(N57) );
  OR2 C163 ( .A(TXDATA[1]), .B(N55), .Z(N56) );
  OR2 C162 ( .A(N10), .B(N54), .Z(N55) );
  OR2 C161 ( .A(N9), .B(N53), .Z(N54) );
  OR2 C160 ( .A(N8), .B(N52), .Z(N53) );
  OR2 C159 ( .A(N19), .B(N44), .Z(N52) );
  IV I_11 ( .A(N50), .Z(N51) );
  OR2 C151 ( .A(TXDATA[0]), .B(N49), .Z(N50) );
  OR2 C150 ( .A(TXDATA[1]), .B(N48), .Z(N49) );
  OR2 C149 ( .A(N10), .B(N47), .Z(N48) );
  OR2 C148 ( .A(N9), .B(N46), .Z(N47) );
  OR2 C147 ( .A(N8), .B(N45), .Z(N46) );
  OR2 C146 ( .A(TXDATA[5]), .B(N44), .Z(N45) );
  OR2 C145 ( .A(TXDATA[6]), .B(N43), .Z(N44) );
  IV I_10 ( .A(TXDATA[7]), .Z(N43) );
  IV I_9 ( .A(N41), .Z(N42) );
  OR2 C139 ( .A(TXDATA[0]), .B(N40), .Z(N41) );
  OR2 C138 ( .A(TXDATA[1]), .B(N39), .Z(N40) );
  OR2 C137 ( .A(N10), .B(N38), .Z(N39) );
  OR2 C136 ( .A(N9), .B(N37), .Z(N38) );
  OR2 C135 ( .A(N8), .B(N36), .Z(N37) );
  OR2 C134 ( .A(N19), .B(N28), .Z(N36) );
  IV I_8 ( .A(N34), .Z(N35) );
  OR2 C126 ( .A(TXDATA[0]), .B(N33), .Z(N34) );
  OR2 C125 ( .A(TXDATA[1]), .B(N32), .Z(N33) );
  OR2 C124 ( .A(N10), .B(N31), .Z(N32) );
  OR2 C123 ( .A(N9), .B(N30), .Z(N31) );
  OR2 C122 ( .A(N8), .B(N29), .Z(N30) );
  OR2 C121 ( .A(TXDATA[5]), .B(N28), .Z(N29) );
  OR2 C120 ( .A(N27), .B(TXDATA[7]), .Z(N28) );
  IV I_7 ( .A(TXDATA[6]), .Z(N27) );
  IV I_6 ( .A(N25), .Z(N26) );
  OR2 C114 ( .A(TXDATA[0]), .B(N24), .Z(N25) );
  OR2 C113 ( .A(TXDATA[1]), .B(N23), .Z(N24) );
  OR2 C112 ( .A(N10), .B(N22), .Z(N23) );
  OR2 C111 ( .A(N9), .B(N21), .Z(N22) );
  OR2 C110 ( .A(N8), .B(N20), .Z(N21) );
  OR2 C109 ( .A(N19), .B(N11), .Z(N20) );
  IV I_5 ( .A(TXDATA[5]), .Z(N19) );
  IV I_4 ( .A(N17), .Z(N18) );
  OR2 C102 ( .A(TXDATA[0]), .B(N16), .Z(N17) );
  OR2 C101 ( .A(TXDATA[1]), .B(N15), .Z(N16) );
  OR2 C100 ( .A(N10), .B(N14), .Z(N15) );
  OR2 C99 ( .A(N9), .B(N13), .Z(N14) );
  OR2 C98 ( .A(N8), .B(N12), .Z(N13) );
  OR2 C97 ( .A(TXDATA[5]), .B(N11), .Z(N12) );
  OR2 C96 ( .A(TXDATA[6]), .B(TXDATA[7]), .Z(N11) );
  IV I_3 ( .A(TXDATA[2]), .Z(N10) );
  IV I_2 ( .A(TXDATA[3]), .Z(N9) );
  IV I_1 ( .A(TXDATA[4]), .Z(N8) );
  IV I_0 ( .A(TXDATAK), .Z(N7) );
  FD1 InputDataK_P0_reg ( .D(n114), .CP(PCLK250), .Q(InputDataK_P0) );
  FD1 InputCompliance_P0_reg ( .D(n113), .CP(PCLK250), .Q(InputCompliance_P0)
         );
  FD1 InputData_P0_reg_7_ ( .D(n112), .CP(PCLK250), .Q(InputData_P0[7]) );
  FD1 InputData_P0_reg_6_ ( .D(n111), .CP(PCLK250), .Q(InputData_P0[6]) );
  FD1 InputData_P0_reg_5_ ( .D(n110), .CP(PCLK250), .Q(InputData_P0[5]) );
  FD1 InputData_P0_reg_4_ ( .D(n109), .CP(PCLK250), .Q(InputData_P0[4]) );
  FD1 InputData_P0_reg_3_ ( .D(n108), .CP(PCLK250), .Q(InputData_P0[3]) );
  FD1 InputData_P0_reg_2_ ( .D(n107), .CP(PCLK250), .Q(InputData_P0[2]) );
  FD1 InputData_P0_reg_1_ ( .D(n106), .CP(PCLK250), .Q(InputData_P0[1]) );
  FD1 InputData_P0_reg_0_ ( .D(n105), .CP(PCLK250), .Q(InputData_P0[0]) );
  FD1 InputDataEnable_P0_reg ( .D(n185), .CP(PCLK250), .Q(InputDataEnable_P0)
         );
  FD1 OutputDataEnable_P2_reg ( .D(InputDataEnable_P0), .CP(PCLK250), .Q(
        OutputDataEnable_P2) );
  FD1 OutputElecIdle_P2_reg ( .D(n152), .CP(PCLK250), .Q(OutputElecIdle_P2) );
  FD1 OutputElecIdle_P0_reg ( .D(N6), .CP(PCLK250), .Q(HSS_TXELECIDLE) );
  FD1 DATA_IN_reg_reg_0_ ( .D(InputData_P0[7]), .CP(PCLK250), .Q(
        DATA_IN_reg_0_) );
  FD1 DATA_IN_reg_reg_1_ ( .D(InputData_P0[6]), .CP(PCLK250), .Q(
        DATA_IN_reg_1_) );
  FD1 DATA_IN_reg_reg_2_ ( .D(InputData_P0[5]), .CP(PCLK250), .Q(
        DATA_IN_reg_2_) );
  FD1 BP_DATAIN_34_000_reg_reg ( .D(n120), .CP(PCLK250), .Q(
        BP_DATAIN_34_000_reg) );
  FD1 BP_DATAIN_34_111_reg_reg ( .D(N110), .CP(PCLK250), .Q(
        BP_DATAIN_34_111_reg) );
  FD1 KCodeIn_P2_reg_reg ( .D(InputDataK_P0), .CP(PCLK250), .Q(KCodeIn_P2_reg)
         );
  FD1 DISPARITY_P0_reg ( .D(DISPARITY_P2), .CP(PCLK250), .Q(DISPARITY_P0) );
  FD1 INVERT34_reg_reg ( .D(INVERT34), .CP(PCLK250), .Q(INVERT34_reg) );
  FD1 OutputData_P0_reg_7_ ( .D(n104), .CP(PCLK250), .Q(HSS_TXD[7]) );
  FD1 OutputData_P0_reg_8_ ( .D(n103), .CP(PCLK250), .Q(HSS_TXD[8]) );
  FD1 DISPARITY_56_reg_reg ( .D(n115), .CP(PCLK250), .Q(DISPARITY_56_reg) );
  FD1 DATA_OUT_810_reg_4_reg ( .D(DATA_OUT_810[4]), .CP(PCLK250), .Q(
        EncodedData_P2[5]) );
  FD1 OutputData_P0_reg_5_ ( .D(n102), .CP(PCLK250), .Q(HSS_TXD[5]) );
  FD1 DATA_OUT_810_reg_5_reg ( .D(DATA_OUT_810[5]), .CP(PCLK250), .Q(
        EncodedData_P2[4]) );
  FD1 OutputData_P0_reg_4_ ( .D(n101), .CP(PCLK250), .Q(HSS_TXD[4]) );
  FD1 OutputData_P0_reg_9_ ( .D(n100), .CP(PCLK250), .Q(HSS_TXD[9]) );
  FD1 OutputData_P0_reg_6_ ( .D(n99), .CP(PCLK250), .Q(HSS_TXD[6]) );
  FD1 DATA_OUT_810_reg_6_reg ( .D(DATA_OUT_810[6]), .CP(PCLK250), .Q(
        EncodedData_P2[3]) );
  FD1 OutputData_P0_reg_3_ ( .D(n98), .CP(PCLK250), .Q(HSS_TXD[3]) );
  FD1 DATA_OUT_810_reg_7_reg ( .D(DATA_OUT_810[7]), .CP(PCLK250), .Q(
        EncodedData_P2[2]) );
  FD1 OutputData_P0_reg_2_ ( .D(n97), .CP(PCLK250), .Q(HSS_TXD[2]) );
  FD1 DATA_OUT_810_reg_8_reg ( .D(DATA_OUT_810[8]), .CP(PCLK250), .Q(
        EncodedData_P2[1]) );
  FD1 OutputData_P0_reg_1_ ( .D(n96), .CP(PCLK250), .Q(HSS_TXD[1]) );
  FD1 DATA_OUT_810_reg_9_reg ( .D(DATA_OUT_810[9]), .CP(PCLK250), .Q(
        EncodedData_P2[0]) );
  FD1 OutputData_P0_reg_0_ ( .D(n95), .CP(PCLK250), .Q(HSS_TXD[0]) );
  AN2 U35 ( .A(TXDATA[0]), .B(InputDataEnable_P2), .Z(n23) );
  AN2 U38 ( .A(TXDATA[1]), .B(InputDataEnable_P2), .Z(n26) );
  AN2 U41 ( .A(TXDATA[2]), .B(InputDataEnable_P2), .Z(n28) );
  AN2 U44 ( .A(TXDATA[3]), .B(InputDataEnable_P2), .Z(n30) );
  AN2 U47 ( .A(TXDATA[4]), .B(InputDataEnable_P2), .Z(n32) );
  AN2 U50 ( .A(TXDATA[5]), .B(InputDataEnable_P2), .Z(n34) );
  AN2 U53 ( .A(TXDATA[6]), .B(InputDataEnable_P2), .Z(n36) );
  AN2 U56 ( .A(TXDATA[7]), .B(InputDataEnable_P2), .Z(n38) );
  AN2 U59 ( .A(TXCOMPLIANCE), .B(InputDataEnable_P2), .Z(n40) );
  AN2 U62 ( .A(TXDATAK), .B(InputDataEnable_P2), .Z(n42) );
  IV U64 ( .A(InputDataEnable_P2), .Z(n24) );
  IV U94 ( .A(CNTL_RESETN_P0), .Z(n153) );
  AN2 U179 ( .A(InputDataEnable_P2), .B(CNTL_RESETN_P0), .Z(n185) );
  OR2 U180 ( .A(n183), .B(n184), .Z(MuxedData_P2[9]) );
  AN2 U181 ( .A(EncodedData_P2[9]), .B(N91), .Z(n184) );
  AN2 U182 ( .A(RX_LoopbackData_P2[9]), .B(CNTL_Loopback_P0), .Z(n183) );
  OR2 U183 ( .A(n181), .B(n182), .Z(MuxedData_P2[8]) );
  AN2 U184 ( .A(EncodedData_P2[8]), .B(N91), .Z(n182) );
  AN2 U185 ( .A(RX_LoopbackData_P2[8]), .B(CNTL_Loopback_P0), .Z(n181) );
  OR2 U186 ( .A(n179), .B(n180), .Z(MuxedData_P2[7]) );
  AN2 U187 ( .A(EncodedData_P2[7]), .B(N91), .Z(n180) );
  AN2 U188 ( .A(RX_LoopbackData_P2[7]), .B(CNTL_Loopback_P0), .Z(n179) );
  OR2 U189 ( .A(n177), .B(n178), .Z(MuxedData_P2[6]) );
  AN2 U190 ( .A(EncodedData_P2[6]), .B(N91), .Z(n178) );
  AN2 U191 ( .A(RX_LoopbackData_P2[6]), .B(CNTL_Loopback_P0), .Z(n177) );
  OR2 U192 ( .A(n175), .B(n176), .Z(MuxedData_P2[5]) );
  AN2 U193 ( .A(EncodedData_P2[5]), .B(N91), .Z(n176) );
  AN2 U194 ( .A(RX_LoopbackData_P2[5]), .B(CNTL_Loopback_P0), .Z(n175) );
  OR2 U195 ( .A(n173), .B(n174), .Z(MuxedData_P2[4]) );
  AN2 U196 ( .A(EncodedData_P2[4]), .B(N91), .Z(n174) );
  AN2 U197 ( .A(RX_LoopbackData_P2[4]), .B(CNTL_Loopback_P0), .Z(n173) );
  OR2 U198 ( .A(n171), .B(n172), .Z(MuxedData_P2[3]) );
  AN2 U199 ( .A(EncodedData_P2[3]), .B(N91), .Z(n172) );
  AN2 U200 ( .A(RX_LoopbackData_P2[3]), .B(CNTL_Loopback_P0), .Z(n171) );
  OR2 U201 ( .A(n169), .B(n170), .Z(MuxedData_P2[2]) );
  AN2 U202 ( .A(EncodedData_P2[2]), .B(N91), .Z(n170) );
  AN2 U203 ( .A(RX_LoopbackData_P2[2]), .B(CNTL_Loopback_P0), .Z(n169) );
  OR2 U204 ( .A(n167), .B(n168), .Z(MuxedData_P2[1]) );
  AN2 U205 ( .A(EncodedData_P2[1]), .B(N91), .Z(n168) );
  AN2 U206 ( .A(RX_LoopbackData_P2[1]), .B(CNTL_Loopback_P0), .Z(n167) );
  OR2 U207 ( .A(n165), .B(n166), .Z(MuxedData_P2[0]) );
  AN2 U208 ( .A(EncodedData_P2[0]), .B(N91), .Z(n166) );
  AN2 U209 ( .A(RX_LoopbackData_P2[0]), .B(CNTL_Loopback_P0), .Z(n165) );
  OR2 U210 ( .A(n153), .B(n164), .Z(N6) );
  AN2 U211 ( .A(OutputElecIdle_P2), .B(CNTL_RESETN_P0), .Z(n164) );
  OR2 U213 ( .A(n186), .B(n187), .Z(n99) );
  AN2 U214 ( .A(MuxedData_P2[6]), .B(OutputDataEnable_P2), .Z(n187) );
  AN2 U215 ( .A(HSS_TXD[6]), .B(n188), .Z(n186) );
  OR2 U216 ( .A(n189), .B(n190), .Z(n98) );
  AN2 U217 ( .A(MuxedData_P2[3]), .B(OutputDataEnable_P2), .Z(n190) );
  AN2 U218 ( .A(HSS_TXD[3]), .B(n188), .Z(n189) );
  OR2 U219 ( .A(n191), .B(n192), .Z(n97) );
  AN2 U220 ( .A(MuxedData_P2[2]), .B(OutputDataEnable_P2), .Z(n192) );
  AN2 U221 ( .A(HSS_TXD[2]), .B(n188), .Z(n191) );
  OR2 U222 ( .A(n193), .B(n194), .Z(n96) );
  AN2 U223 ( .A(MuxedData_P2[1]), .B(OutputDataEnable_P2), .Z(n194) );
  AN2 U224 ( .A(HSS_TXD[1]), .B(n188), .Z(n193) );
  OR2 U225 ( .A(n195), .B(n196), .Z(n95) );
  AN2 U226 ( .A(MuxedData_P2[0]), .B(OutputDataEnable_P2), .Z(n196) );
  AN2 U227 ( .A(HSS_TXD[0]), .B(n188), .Z(n195) );
  IV U228 ( .A(N710), .Z(n157) );
  IV U229 ( .A(DISPARITY_56_reg), .Z(n156) );
  IV U230 ( .A(ALT_7), .Z(n155) );
  IV U231 ( .A(InputDataEnable_P0), .Z(n152) );
  IV U232 ( .A(N181), .Z(n148) );
  IV U233 ( .A(N211), .Z(n147) );
  IV U234 ( .A(N281), .Z(n146) );
  IV U235 ( .A(N331), .Z(n145) );
  IV U236 ( .A(N371), .Z(n144) );
  IV U237 ( .A(N391), .Z(n143) );
  IV U238 ( .A(N431), .Z(n141) );
  IV U239 ( .A(N511), .Z(n140) );
  IV U240 ( .A(N531), .Z(n139) );
  IV U241 ( .A(N551), .Z(n138) );
  IV U242 ( .A(N571), .Z(n137) );
  IV U243 ( .A(N591), .Z(n136) );
  IV U244 ( .A(N611), .Z(n135) );
  IV U245 ( .A(N641), .Z(n134) );
  IV U246 ( .A(N461), .Z(n132) );
  IV U247 ( .A(N661), .Z(n131) );
  IV U248 ( .A(N681), .Z(n130) );
  IV U249 ( .A(N711), .Z(n129) );
  IV U250 ( .A(N751), .Z(n128) );
  IV U251 ( .A(N791), .Z(n127) );
  IV U252 ( .A(N831), .Z(n126) );
  IV U253 ( .A(N851), .Z(n125) );
  IV U254 ( .A(KCODE_OPT), .Z(n124) );
  IV U255 ( .A(N510), .Z(n121) );
  IV U256 ( .A(N111), .Z(n120) );
  IV U257 ( .A(InputData_P0[7]), .Z(n119) );
  IV U258 ( .A(N141), .Z(n118) );
  IV U259 ( .A(InputCompliance_P0), .Z(n117) );
  OR2 U260 ( .A(n197), .B(n42), .Z(n114) );
  AN2 U261 ( .A(n24), .B(InputDataK_P0), .Z(n197) );
  OR2 U262 ( .A(n198), .B(n40), .Z(n113) );
  AN2 U263 ( .A(n24), .B(InputCompliance_P0), .Z(n198) );
  OR2 U264 ( .A(n199), .B(n38), .Z(n112) );
  AN2 U265 ( .A(n24), .B(InputData_P0[7]), .Z(n199) );
  OR2 U266 ( .A(n200), .B(n36), .Z(n111) );
  AN2 U267 ( .A(n24), .B(InputData_P0[6]), .Z(n200) );
  OR2 U268 ( .A(n201), .B(n34), .Z(n110) );
  AN2 U269 ( .A(n24), .B(InputData_P0[5]), .Z(n201) );
  OR2 U270 ( .A(n202), .B(n32), .Z(n109) );
  AN2 U271 ( .A(n24), .B(InputData_P0[4]), .Z(n202) );
  OR2 U272 ( .A(n203), .B(n30), .Z(n108) );
  AN2 U273 ( .A(n24), .B(InputData_P0[3]), .Z(n203) );
  OR2 U274 ( .A(n204), .B(n28), .Z(n107) );
  AN2 U275 ( .A(n24), .B(InputData_P0[2]), .Z(n204) );
  OR2 U276 ( .A(n205), .B(n26), .Z(n106) );
  AN2 U277 ( .A(n24), .B(InputData_P0[1]), .Z(n205) );
  OR2 U278 ( .A(n206), .B(n23), .Z(n105) );
  AN2 U279 ( .A(n24), .B(InputData_P0[0]), .Z(n206) );
  OR2 U280 ( .A(n207), .B(n208), .Z(n104) );
  AN2 U281 ( .A(MuxedData_P2[7]), .B(OutputDataEnable_P2), .Z(n208) );
  AN2 U282 ( .A(HSS_TXD[7]), .B(n188), .Z(n207) );
  OR2 U283 ( .A(n209), .B(n210), .Z(n103) );
  AN2 U284 ( .A(MuxedData_P2[8]), .B(OutputDataEnable_P2), .Z(n210) );
  AN2 U285 ( .A(HSS_TXD[8]), .B(n188), .Z(n209) );
  OR2 U286 ( .A(n211), .B(n212), .Z(n102) );
  AN2 U287 ( .A(MuxedData_P2[5]), .B(OutputDataEnable_P2), .Z(n212) );
  AN2 U288 ( .A(HSS_TXD[5]), .B(n188), .Z(n211) );
  OR2 U289 ( .A(n213), .B(n214), .Z(n101) );
  AN2 U290 ( .A(MuxedData_P2[4]), .B(OutputDataEnable_P2), .Z(n214) );
  AN2 U291 ( .A(HSS_TXD[4]), .B(n188), .Z(n213) );
  OR2 U292 ( .A(n215), .B(n216), .Z(n100) );
  AN2 U293 ( .A(MuxedData_P2[9]), .B(OutputDataEnable_P2), .Z(n216) );
  AN2 U294 ( .A(HSS_TXD[9]), .B(n188), .Z(n215) );
  IV U295 ( .A(OutputDataEnable_P2), .Z(n188) );
  OR2 U296 ( .A(n217), .B(n218), .Z(N961) );
  AN2 U297 ( .A(InputData_P0[2]), .B(n142), .Z(n218) );
  IV U298 ( .A(InputData_P0[3]), .Z(n142) );
  AN2 U299 ( .A(InputData_P0[3]), .B(n149), .Z(n217) );
  IV U300 ( .A(InputData_P0[2]), .Z(n149) );
  OR2 U301 ( .A(n219), .B(n220), .Z(N951) );
  AN2 U302 ( .A(InputData_P0[0]), .B(n150), .Z(n220) );
  IV U303 ( .A(InputData_P0[1]), .Z(n150) );
  AN2 U304 ( .A(InputData_P0[1]), .B(n151), .Z(n219) );
  OR2 U305 ( .A(n221), .B(n222), .Z(N931) );
  AN2 U306 ( .A(InputData_P0[4]), .B(n223), .Z(n222) );
  IV U307 ( .A(N411), .Z(n223) );
  AN2 U308 ( .A(N411), .B(n133), .Z(n221) );
  AN2 U309 ( .A(n224), .B(n225), .Z(N901) );
  OR2 U310 ( .A(InputData_P0[4]), .B(n226), .Z(n225) );
  IV U311 ( .A(N231), .Z(n226) );
  OR2 U312 ( .A(N231), .B(n133), .Z(n224) );
  IV U313 ( .A(InputData_P0[4]), .Z(n133) );
  OR2 U314 ( .A(n227), .B(n228), .Z(N143) );
  IV U315 ( .A(n229), .Z(n228) );
  OR2 U316 ( .A(n230), .B(DATA_IN_reg_2_), .Z(n229) );
  AN2 U317 ( .A(DATA_IN_reg_2_), .B(n230), .Z(n227) );
  IV U318 ( .A(DATA_IN_reg_1_), .Z(n230) );
  OR2 U319 ( .A(n231), .B(n232), .Z(N123) );
  AN2 U320 ( .A(n115), .B(n233), .Z(n232) );
  IV U321 ( .A(N122), .Z(n233) );
  IV U322 ( .A(n162), .Z(n115) );
  AN2 U323 ( .A(N122), .B(n162), .Z(n231) );
  AN2 U324 ( .A(n234), .B(n235), .Z(n162) );
  OR2 U325 ( .A(n116), .B(N120), .Z(n235) );
  IV U326 ( .A(DISPARITY), .Z(n116) );
  OR2 U327 ( .A(n236), .B(DISPARITY), .Z(n234) );
  IV U328 ( .A(N120), .Z(n236) );
  OR2 U329 ( .A(n237), .B(n238), .Z(N116) );
  AN2 U330 ( .A(InputData_P0[5]), .B(n122), .Z(n238) );
  IV U331 ( .A(InputData_P0[6]), .Z(n122) );
  AN2 U332 ( .A(InputData_P0[6]), .B(n123), .Z(n237) );
  IV U333 ( .A(InputData_P0[5]), .Z(n123) );
  OR2 U334 ( .A(n239), .B(n240), .Z(EncodedData_P2[9]) );
  AN2 U335 ( .A(DATA_OUT_34_0), .B(n241), .Z(n240) );
  AN2 U336 ( .A(INVERT34_reg), .B(n242), .Z(n239) );
  IV U337 ( .A(DATA_OUT_34_0), .Z(n242) );
  OR2 U338 ( .A(n243), .B(n244), .Z(EncodedData_P2[8]) );
  AN2 U339 ( .A(DATA_IN_reg_0_), .B(n241), .Z(n244) );
  AN2 U340 ( .A(INVERT34_reg), .B(n154), .Z(n243) );
  IV U341 ( .A(DATA_IN_reg_0_), .Z(n154) );
  OR2 U342 ( .A(n245), .B(n246), .Z(EncodedData_P2[7]) );
  AN2 U343 ( .A(DATA_OUT_34[2]), .B(n241), .Z(n246) );
  AN2 U344 ( .A(INVERT34_reg), .B(n247), .Z(n245) );
  IV U345 ( .A(DATA_OUT_34[2]), .Z(n247) );
  OR2 U346 ( .A(n248), .B(n249), .Z(EncodedData_P2[6]) );
  AN2 U347 ( .A(DATA_OUT_34[3]), .B(n241), .Z(n249) );
  IV U348 ( .A(INVERT34_reg), .Z(n241) );
  AN2 U349 ( .A(INVERT34_reg), .B(n250), .Z(n248) );
  IV U350 ( .A(DATA_OUT_34[3]), .Z(n250) );
  OR2 U351 ( .A(n251), .B(n252), .Z(DATA_OUT_810[9]) );
  AN2 U352 ( .A(INVERT56), .B(n151), .Z(n252) );
  IV U353 ( .A(InputData_P0[0]), .Z(n151) );
  AN2 U354 ( .A(InputData_P0[0]), .B(n253), .Z(n251) );
  OR2 U355 ( .A(n254), .B(n255), .Z(DATA_OUT_810[8]) );
  AN2 U356 ( .A(DATA_OUT_56[4]), .B(n253), .Z(n255) );
  AN2 U357 ( .A(INVERT56), .B(n256), .Z(n254) );
  IV U358 ( .A(DATA_OUT_56[4]), .Z(n256) );
  OR2 U359 ( .A(n257), .B(n258), .Z(DATA_OUT_810[7]) );
  AN2 U360 ( .A(DATA_OUT_56[3]), .B(n253), .Z(n258) );
  AN2 U361 ( .A(INVERT56), .B(n259), .Z(n257) );
  IV U362 ( .A(DATA_OUT_56[3]), .Z(n259) );
  OR2 U363 ( .A(n260), .B(n261), .Z(DATA_OUT_810[6]) );
  AN2 U364 ( .A(DATA_OUT_56[2]), .B(n253), .Z(n261) );
  AN2 U365 ( .A(INVERT56), .B(n262), .Z(n260) );
  IV U366 ( .A(DATA_OUT_56[2]), .Z(n262) );
  OR2 U367 ( .A(n263), .B(n264), .Z(DATA_OUT_810[5]) );
  AN2 U368 ( .A(DATA_OUT_56[1]), .B(n253), .Z(n264) );
  AN2 U369 ( .A(INVERT56), .B(n265), .Z(n263) );
  IV U370 ( .A(DATA_OUT_56[1]), .Z(n265) );
  OR2 U371 ( .A(n266), .B(n267), .Z(DATA_OUT_810[4]) );
  AN2 U372 ( .A(DATA_OUT_56[0]), .B(n253), .Z(n267) );
  IV U373 ( .A(INVERT56), .Z(n253) );
  AN2 U374 ( .A(INVERT56), .B(n268), .Z(n266) );
  IV U375 ( .A(DATA_OUT_56[0]), .Z(n268) );
endmodule

