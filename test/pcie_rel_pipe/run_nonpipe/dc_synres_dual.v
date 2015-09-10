
module resulting_dual ( HSS_TXELECIDLE, HSS_TXBEACONCMD, HSS_TXD, 
        CNTL_TXEnable_P0, TXDATAK, TXDATA, clk );
  input [9:0] HSS_TXD;
  output [7:0] TXDATA;
  input HSS_TXELECIDLE, HSS_TXBEACONCMD, clk;
  output CNTL_TXEnable_P0, TXDATAK;
  wire   cycle11_HSS_TXELECIDLE, N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10,
         N11, N12, N13, N14, N15, N16, N17, N18, N19, N20, N21, N22, N23, N24,
         N25, N26, N27, N28, N29, N30, N31, N32, N33, N34, N35, N36, N37, N38,
         N39, N40, N41, N42, N43, N44, N45, N46, N47, N48, N49, N50, N51, N52,
         N53, N54, N55, N56, N57, N58, N59, N60, N61, N62, N63, N64, N65, N66,
         N67, N68, N69, N70, N71, N72, N73, N74, N75, N76, N77, N78, N79, N80,
         N81, N82, N83, N84, N85, N86, N87, N88, N89, N90, N91, N92, N93, N94,
         N95, N96, N97, N98, N99, N100, N101, N102, N103, N104, N105, N106,
         N107, N108, N109, N110, N111, N112, N113, N114, N115, N116, N117,
         N118, N119, N120, N121, N122, N123, N124, N125, N126, N127, N128,
         N129, N130, N131, N132, N133, N134, N135, N136, N137, N138, N139,
         N140, N141, N142, N143, N144, N145, N146, N147, N148, N149, N150,
         N151, N152, N153, N154, N155, N156, N157, N158, N159, N160, N161,
         N162, N163, N164, N165, N166, N167, N168, N169, N170, N171, N172,
         N173, N174, N175, N176, N177, N178, N179, N180, N181, N182, N183,
         N184, N185, N186, N187, N188, N189, N190, N191, N192, N193, N194,
         N195, N196, N197, N198, N199, N200, N201, N202, N203, N204, N205,
         N206, N207, N208, N209, N210, N211, N212, N213, N214, N215, N216,
         N217, N218, N219, N220, N221, N222, N223, N224, N225, N226, N227,
         N228, N229, N230, N231, N232, N233, N234, N235, N236, N237, N238,
         N239, N240, N241, N242, N243, N244, N245, N246, N247, N248, N249,
         N250, N251, N252, N253, N254, N255, N256, N257, N258, N259, N260,
         N261, N262, N263, N264, N265, N266, N267, N268, N269, N270, N271,
         N272, N273, N274, N275, N276, N277, N278, N279, N280, N281, N282,
         N283, N284, N285, N286, N287, N288, N289, N290, N291, N292, N293,
         N294, N295, N296, N297, N298, N299, N300, N301, N302, N303, N304,
         N305, N306, N307, N308, N309, N310, N311, N312, N313, N314, N315,
         N316, N317, N318, N319, N320, N321, N322, N323, N324, N325, N326,
         N327, N328, N329, N330, N331, N332, N333, N334, N335, N336, N337,
         N338, N339, N340, N341, N342, N343, N344, N345, N346, N347, N348,
         N349, N350, N351, N352, N353, N354, N355, N356, N357, N358, N359,
         N360, N361, N362, N363, N364, N365, N366, N367, N368, N369, N370,
         N371, N372, N373, N374, N375, N376, N377, N378, N379, N380, N381,
         N382, N383, N384, N385, N386, N387, N388, N389, N390, N391, N392,
         N393, N394, N395, N396, N397, N398, N399, N400, N401, N402, N403,
         N404, N405, N406, N407, N408, N409, N410, N411, N412, N413, N414,
         N415, N416, N417, N418, N419, N420, N421, N422, N423, N424, N425,
         N426, N427, N428, N429, N430, N431, N432, N433, N434, N435, N436,
         N437, N438, N439, N440, N441, N442, N443, N444, N445, N446, N447,
         N448, N449, N450, N451, N452, N453, N454, N455, N456, N457, N458,
         N459, N460, N461, N462, N463, N464, N465, N466, N467, N468, N469,
         N470, N471, N472, N473, N474, N475, N476, N477, N478, N479, N480,
         N481, N482, N483, N484, N485, N486, N487, N488, N489, N490, N491,
         N492, N493, N494, N495, N496, N497, N498, N499, N500, N501, N502,
         N503, N504, N505, N506, N507, N508, N509, N510, N511, N512, N513,
         N514, N515, N516, N517, N518, N519, N520, N521, N522, N523, N524,
         N525, N526, N527, N528, N529, N530, N531, N532, N533, N534, N535,
         N536, N537, N538, N539, N540, N541, N542, N543, N544, N545, N546,
         N547, N548, N549, N550, N551, N552, N553, N554, N555, N556, N557,
         N558, N559, N560, N561, N562, N563, N564, N565, N566, N567, N568,
         N569, N570, N571, N572, N573, N574, N575, N576, N577, N578, N579,
         N580, N581, N582, N583, N584, N585, N586, N587, N588, N589, N590,
         N591, N592, N593, N594, N595, N596, N597, N598, N599, N600, N601,
         N602, N603, N604, N605, N606, N607, N608, N609, N610, N611, N612,
         N613, N614, N615, N616, N617, N618, N619, N620, N621, N622, N623,
         N624, N625, N626, N627, N628, N629, N630, N631, N632, N633, N634,
         N635, N636, N637, N638, N639, N640, N641, N642, N643, N644, N645,
         N646, N647, N648, N649, N650, N651, N652, N653, N654, N655, N656,
         N657, N658, N659, N660, N661, N662, N663, N664, N665, N666, N667,
         N668, N669, N670, N671, N672, N673, N674, N675, N676, N677, N678,
         N679, N680, N681, N682, N683, N684, N685, N686, N687, N688, N689,
         N690, N691, N692, N693, N694, N695, N696, N697, N698, N699, N700,
         N701, N702, N703, N704, N705, N706, N707, N708, N709, N710, N711,
         N712, N713, N714, N715, N716;
  wire   [9:0] cycle11_HSS_TXD;

  \**SEQGEN**  cycle11_HSS_TXELECIDLE_reg ( .clear(1'b0), .preset(1'b0), 
        .next_state(HSS_TXELECIDLE), .clocked_on(clk), .data_in(1'b0), 
        .enable(1'b0), .Q(cycle11_HSS_TXELECIDLE), .QN(), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  \cycle11_HSS_TXD_reg[9]  ( .clear(1'b0), .preset(1'b0), 
        .next_state(HSS_TXD[9]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(cycle11_HSS_TXD[9]), .QN(), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  \cycle11_HSS_TXD_reg[8]  ( .clear(1'b0), .preset(1'b0), 
        .next_state(HSS_TXD[8]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(cycle11_HSS_TXD[8]), .QN(), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  \cycle11_HSS_TXD_reg[7]  ( .clear(1'b0), .preset(1'b0), 
        .next_state(HSS_TXD[7]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(cycle11_HSS_TXD[7]), .QN(), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  \cycle11_HSS_TXD_reg[6]  ( .clear(1'b0), .preset(1'b0), 
        .next_state(HSS_TXD[6]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(cycle11_HSS_TXD[6]), .QN(), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  \cycle11_HSS_TXD_reg[5]  ( .clear(1'b0), .preset(1'b0), 
        .next_state(HSS_TXD[5]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(cycle11_HSS_TXD[5]), .QN(), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  \cycle11_HSS_TXD_reg[4]  ( .clear(1'b0), .preset(1'b0), 
        .next_state(HSS_TXD[4]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(cycle11_HSS_TXD[4]), .QN(), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  \cycle11_HSS_TXD_reg[3]  ( .clear(1'b0), .preset(1'b0), 
        .next_state(HSS_TXD[3]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(cycle11_HSS_TXD[3]), .QN(), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  \cycle11_HSS_TXD_reg[2]  ( .clear(1'b0), .preset(1'b0), 
        .next_state(HSS_TXD[2]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(cycle11_HSS_TXD[2]), .QN(), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  \cycle11_HSS_TXD_reg[1]  ( .clear(1'b0), .preset(1'b0), 
        .next_state(HSS_TXD[1]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(cycle11_HSS_TXD[1]), .QN(), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  \cycle11_HSS_TXD_reg[0]  ( .clear(1'b0), .preset(1'b0), 
        .next_state(HSS_TXD[0]), .clocked_on(clk), .data_in(1'b0), .enable(
        1'b0), .Q(cycle11_HSS_TXD[0]), .QN(), .synch_clear(1'b0), 
        .synch_preset(1'b0), .synch_toggle(1'b0), .synch_enable(1'b1) );
  GTECH_AND2 C232 ( .A(cycle11_HSS_TXD[9]), .B(cycle11_HSS_TXD[7]), .Z(N0) );
  GTECH_AND2 C233 ( .A(N0), .B(cycle11_HSS_TXD[3]), .Z(N1) );
  GTECH_NOT I_0 ( .A(cycle11_HSS_TXD[8]), .Z(N2) );
  GTECH_NOT I_1 ( .A(cycle11_HSS_TXD[6]), .Z(N3) );
  GTECH_NOT I_2 ( .A(cycle11_HSS_TXD[3]), .Z(N4) );
  GTECH_AND2 C237 ( .A(N0), .B(N4), .Z(N5) );
  GTECH_AND2 C238 ( .A(N5), .B(cycle11_HSS_TXD[4]), .Z(N6) );
  GTECH_NOT I_3 ( .A(cycle11_HSS_TXD[4]), .Z(N7) );
  GTECH_AND2 C240 ( .A(N5), .B(N7), .Z(N8) );
  GTECH_AND2 C241 ( .A(N8), .B(cycle11_HSS_TXD[5]), .Z(N9) );
  GTECH_NOT I_4 ( .A(cycle11_HSS_TXD[5]), .Z(N10) );
  GTECH_AND2 C243 ( .A(N8), .B(N10), .Z(N11) );
  GTECH_AND2 C244 ( .A(N11), .B(cycle11_HSS_TXD[2]), .Z(N12) );
  GTECH_NOT I_5 ( .A(cycle11_HSS_TXD[2]), .Z(N13) );
  GTECH_AND2 C246 ( .A(N11), .B(N13), .Z(N14) );
  GTECH_AND2 C247 ( .A(N14), .B(cycle11_HSS_TXD[1]), .Z(N15) );
  GTECH_AND2 C248 ( .A(N15), .B(cycle11_HSS_TXD[0]), .Z(N16) );
  GTECH_NOT I_6 ( .A(cycle11_HSS_TXD[0]), .Z(N17) );
  GTECH_AND2 C250 ( .A(N15), .B(N17), .Z(N18) );
  GTECH_NOT I_7 ( .A(cycle11_HSS_TXD[1]), .Z(N19) );
  GTECH_AND2 C252 ( .A(N14), .B(N19), .Z(N20) );
  GTECH_NOT I_8 ( .A(cycle11_HSS_TXD[7]), .Z(N21) );
  GTECH_AND2 C254 ( .A(cycle11_HSS_TXD[9]), .B(N21), .Z(N22) );
  GTECH_AND2 C255 ( .A(N22), .B(N4), .Z(N23) );
  GTECH_AND2 C256 ( .A(N23), .B(N7), .Z(N24) );
  GTECH_AND2 C257 ( .A(N24), .B(N10), .Z(N25) );
  GTECH_AND2 C258 ( .A(N25), .B(N13), .Z(N26) );
  GTECH_AND2 C259 ( .A(N26), .B(cycle11_HSS_TXD[1]), .Z(N27) );
  GTECH_NOT I_9 ( .A(cycle11_HSS_TXD[9]), .Z(N28) );
  GTECH_AND2 C261 ( .A(N28), .B(cycle11_HSS_TXD[7]), .Z(N29) );
  GTECH_AND2 C262 ( .A(N29), .B(N4), .Z(N30) );
  GTECH_AND2 C263 ( .A(N30), .B(N7), .Z(N31) );
  GTECH_AND2 C264 ( .A(N31), .B(N10), .Z(N32) );
  GTECH_AND2 C265 ( .A(N32), .B(N13), .Z(N33) );
  GTECH_AND2 C266 ( .A(N33), .B(cycle11_HSS_TXD[1]), .Z(N34) );
  GTECH_AND2 C267 ( .A(N28), .B(N21), .Z(N35) );
  GTECH_AND2 C268 ( .A(N35), .B(cycle11_HSS_TXD[3]), .Z(N36) );
  GTECH_AND2 C269 ( .A(N35), .B(N4), .Z(N37) );
  GTECH_AND2 C270 ( .A(N37), .B(cycle11_HSS_TXD[4]), .Z(N38) );
  GTECH_AND2 C271 ( .A(N37), .B(N7), .Z(N39) );
  GTECH_AND2 C272 ( .A(N39), .B(cycle11_HSS_TXD[5]), .Z(N40) );
  GTECH_AND2 C273 ( .A(N39), .B(N10), .Z(N41) );
  GTECH_AND2 C274 ( .A(N41), .B(cycle11_HSS_TXD[2]), .Z(N42) );
  GTECH_AND2 C275 ( .A(N41), .B(N13), .Z(N43) );
  GTECH_AND2 C276 ( .A(N43), .B(cycle11_HSS_TXD[1]), .Z(N44) );
  GTECH_AND2 C277 ( .A(N44), .B(cycle11_HSS_TXD[0]), .Z(N45) );
  GTECH_AND2 C278 ( .A(N44), .B(N17), .Z(N46) );
  GTECH_AND2 C279 ( .A(N43), .B(N19), .Z(N47) );
  GTECH_OR2 C280 ( .A(N276), .B(N278), .Z(TXDATA[7]) );
  GTECH_OR2 C281 ( .A(N274), .B(N275), .Z(N276) );
  GTECH_OR2 C282 ( .A(N271), .B(N273), .Z(N274) );
  GTECH_OR2 C283 ( .A(N269), .B(N270), .Z(N271) );
  GTECH_OR2 C284 ( .A(N266), .B(N268), .Z(N269) );
  GTECH_OR2 C285 ( .A(N263), .B(N265), .Z(N266) );
  GTECH_OR2 C286 ( .A(N260), .B(N262), .Z(N263) );
  GTECH_OR2 C287 ( .A(N258), .B(N259), .Z(N260) );
  GTECH_OR2 C288 ( .A(N255), .B(N257), .Z(N258) );
  GTECH_OR2 C289 ( .A(N253), .B(N254), .Z(N255) );
  GTECH_OR2 C290 ( .A(N250), .B(N252), .Z(N253) );
  GTECH_OR2 C291 ( .A(N248), .B(N249), .Z(N250) );
  GTECH_OR2 C292 ( .A(N245), .B(N247), .Z(N248) );
  GTECH_OR2 C293 ( .A(N243), .B(N244), .Z(N245) );
  GTECH_OR2 C294 ( .A(N240), .B(N242), .Z(N243) );
  GTECH_OR2 C295 ( .A(N237), .B(N239), .Z(N240) );
  GTECH_OR2 C296 ( .A(N233), .B(N236), .Z(N237) );
  GTECH_OR2 C297 ( .A(N230), .B(N232), .Z(N233) );
  GTECH_OR2 C298 ( .A(N227), .B(N229), .Z(N230) );
  GTECH_OR2 C299 ( .A(N224), .B(N226), .Z(N227) );
  GTECH_OR2 C300 ( .A(N221), .B(N223), .Z(N224) );
  GTECH_OR2 C301 ( .A(N217), .B(N220), .Z(N221) );
  GTECH_OR2 C302 ( .A(N213), .B(N216), .Z(N217) );
  GTECH_OR2 C303 ( .A(N210), .B(N212), .Z(N213) );
  GTECH_OR2 C304 ( .A(N206), .B(N209), .Z(N210) );
  GTECH_OR2 C305 ( .A(N202), .B(N205), .Z(N206) );
  GTECH_OR2 C306 ( .A(N198), .B(N201), .Z(N202) );
  GTECH_OR2 C307 ( .A(N194), .B(N197), .Z(N198) );
  GTECH_OR2 C308 ( .A(N191), .B(N193), .Z(N194) );
  GTECH_OR2 C309 ( .A(N188), .B(N190), .Z(N191) );
  GTECH_OR2 C310 ( .A(N185), .B(N187), .Z(N188) );
  GTECH_OR2 C311 ( .A(N182), .B(N184), .Z(N185) );
  GTECH_OR2 C312 ( .A(N180), .B(N181), .Z(N182) );
  GTECH_OR2 C313 ( .A(N177), .B(N179), .Z(N180) );
  GTECH_OR2 C314 ( .A(N174), .B(N176), .Z(N177) );
  GTECH_OR2 C315 ( .A(N171), .B(N173), .Z(N174) );
  GTECH_OR2 C316 ( .A(N168), .B(N170), .Z(N171) );
  GTECH_OR2 C317 ( .A(N165), .B(N167), .Z(N168) );
  GTECH_OR2 C318 ( .A(N162), .B(N164), .Z(N165) );
  GTECH_OR2 C319 ( .A(N159), .B(N161), .Z(N162) );
  GTECH_OR2 C320 ( .A(N156), .B(N158), .Z(N159) );
  GTECH_AND2 C321 ( .A(N155), .B(N2), .Z(N156) );
  GTECH_AND2 C322 ( .A(N1), .B(cycle11_HSS_TXD[6]), .Z(N155) );
  GTECH_AND2 C323 ( .A(N157), .B(cycle11_HSS_TXD[8]), .Z(N158) );
  GTECH_AND2 C324 ( .A(N1), .B(N3), .Z(N157) );
  GTECH_AND2 C325 ( .A(N160), .B(N2), .Z(N161) );
  GTECH_AND2 C326 ( .A(N6), .B(cycle11_HSS_TXD[6]), .Z(N160) );
  GTECH_AND2 C327 ( .A(N163), .B(cycle11_HSS_TXD[8]), .Z(N164) );
  GTECH_AND2 C328 ( .A(N6), .B(N3), .Z(N163) );
  GTECH_AND2 C329 ( .A(N166), .B(N2), .Z(N167) );
  GTECH_AND2 C330 ( .A(N9), .B(cycle11_HSS_TXD[6]), .Z(N166) );
  GTECH_AND2 C331 ( .A(N169), .B(cycle11_HSS_TXD[8]), .Z(N170) );
  GTECH_AND2 C332 ( .A(N9), .B(N3), .Z(N169) );
  GTECH_AND2 C333 ( .A(N172), .B(N2), .Z(N173) );
  GTECH_AND2 C334 ( .A(N12), .B(cycle11_HSS_TXD[6]), .Z(N172) );
  GTECH_AND2 C335 ( .A(N175), .B(cycle11_HSS_TXD[8]), .Z(N176) );
  GTECH_AND2 C336 ( .A(N12), .B(N3), .Z(N175) );
  GTECH_AND2 C337 ( .A(N178), .B(N2), .Z(N179) );
  GTECH_AND2 C338 ( .A(N16), .B(cycle11_HSS_TXD[6]), .Z(N178) );
  GTECH_AND2 C339 ( .A(N16), .B(N3), .Z(N181) );
  GTECH_AND2 C340 ( .A(N183), .B(N2), .Z(N184) );
  GTECH_AND2 C341 ( .A(N18), .B(cycle11_HSS_TXD[6]), .Z(N183) );
  GTECH_AND2 C342 ( .A(N186), .B(cycle11_HSS_TXD[8]), .Z(N187) );
  GTECH_AND2 C343 ( .A(N18), .B(N3), .Z(N186) );
  GTECH_AND2 C344 ( .A(N189), .B(N2), .Z(N190) );
  GTECH_AND2 C345 ( .A(N20), .B(cycle11_HSS_TXD[6]), .Z(N189) );
  GTECH_AND2 C346 ( .A(N192), .B(cycle11_HSS_TXD[8]), .Z(N193) );
  GTECH_AND2 C347 ( .A(N20), .B(N3), .Z(N192) );
  GTECH_AND2 C348 ( .A(N196), .B(N2), .Z(N197) );
  GTECH_AND2 C349 ( .A(N195), .B(N3), .Z(N196) );
  GTECH_AND2 C350 ( .A(N22), .B(cycle11_HSS_TXD[3]), .Z(N195) );
  GTECH_AND2 C351 ( .A(N200), .B(N2), .Z(N201) );
  GTECH_AND2 C352 ( .A(N199), .B(N3), .Z(N200) );
  GTECH_AND2 C353 ( .A(N23), .B(cycle11_HSS_TXD[4]), .Z(N199) );
  GTECH_AND2 C354 ( .A(N204), .B(N2), .Z(N205) );
  GTECH_AND2 C355 ( .A(N203), .B(N3), .Z(N204) );
  GTECH_AND2 C356 ( .A(N24), .B(cycle11_HSS_TXD[5]), .Z(N203) );
  GTECH_AND2 C357 ( .A(N208), .B(N2), .Z(N209) );
  GTECH_AND2 C358 ( .A(N207), .B(N3), .Z(N208) );
  GTECH_AND2 C359 ( .A(N25), .B(cycle11_HSS_TXD[2]), .Z(N207) );
  GTECH_AND2 C360 ( .A(N211), .B(N2), .Z(N212) );
  GTECH_AND2 C361 ( .A(N27), .B(cycle11_HSS_TXD[0]), .Z(N211) );
  GTECH_AND2 C362 ( .A(N215), .B(N2), .Z(N216) );
  GTECH_AND2 C363 ( .A(N214), .B(N3), .Z(N215) );
  GTECH_AND2 C364 ( .A(N27), .B(N17), .Z(N214) );
  GTECH_AND2 C365 ( .A(N219), .B(N2), .Z(N220) );
  GTECH_AND2 C366 ( .A(N218), .B(N3), .Z(N219) );
  GTECH_AND2 C367 ( .A(N26), .B(N19), .Z(N218) );
  GTECH_AND2 C368 ( .A(N222), .B(cycle11_HSS_TXD[8]), .Z(N223) );
  GTECH_AND2 C369 ( .A(N29), .B(cycle11_HSS_TXD[3]), .Z(N222) );
  GTECH_AND2 C370 ( .A(N225), .B(cycle11_HSS_TXD[8]), .Z(N226) );
  GTECH_AND2 C371 ( .A(N30), .B(cycle11_HSS_TXD[4]), .Z(N225) );
  GTECH_AND2 C372 ( .A(N228), .B(cycle11_HSS_TXD[8]), .Z(N229) );
  GTECH_AND2 C373 ( .A(N31), .B(cycle11_HSS_TXD[5]), .Z(N228) );
  GTECH_AND2 C374 ( .A(N231), .B(cycle11_HSS_TXD[8]), .Z(N232) );
  GTECH_AND2 C375 ( .A(N32), .B(cycle11_HSS_TXD[2]), .Z(N231) );
  GTECH_AND2 C376 ( .A(N235), .B(cycle11_HSS_TXD[8]), .Z(N236) );
  GTECH_AND2 C377 ( .A(N234), .B(cycle11_HSS_TXD[6]), .Z(N235) );
  GTECH_AND2 C378 ( .A(N34), .B(cycle11_HSS_TXD[0]), .Z(N234) );
  GTECH_AND2 C379 ( .A(N238), .B(cycle11_HSS_TXD[8]), .Z(N239) );
  GTECH_AND2 C380 ( .A(N34), .B(N17), .Z(N238) );
  GTECH_AND2 C381 ( .A(N241), .B(cycle11_HSS_TXD[8]), .Z(N242) );
  GTECH_AND2 C382 ( .A(N33), .B(N19), .Z(N241) );
  GTECH_AND2 C383 ( .A(N36), .B(cycle11_HSS_TXD[6]), .Z(N244) );
  GTECH_AND2 C384 ( .A(N246), .B(cycle11_HSS_TXD[8]), .Z(N247) );
  GTECH_AND2 C385 ( .A(N36), .B(N3), .Z(N246) );
  GTECH_AND2 C386 ( .A(N38), .B(cycle11_HSS_TXD[6]), .Z(N249) );
  GTECH_AND2 C387 ( .A(N251), .B(cycle11_HSS_TXD[8]), .Z(N252) );
  GTECH_AND2 C388 ( .A(N38), .B(N3), .Z(N251) );
  GTECH_AND2 C389 ( .A(N40), .B(cycle11_HSS_TXD[6]), .Z(N254) );
  GTECH_AND2 C390 ( .A(N256), .B(cycle11_HSS_TXD[8]), .Z(N257) );
  GTECH_AND2 C391 ( .A(N40), .B(N3), .Z(N256) );
  GTECH_AND2 C392 ( .A(N42), .B(cycle11_HSS_TXD[6]), .Z(N259) );
  GTECH_AND2 C393 ( .A(N261), .B(cycle11_HSS_TXD[8]), .Z(N262) );
  GTECH_AND2 C394 ( .A(N42), .B(N3), .Z(N261) );
  GTECH_AND2 C395 ( .A(N264), .B(N2), .Z(N265) );
  GTECH_AND2 C396 ( .A(N45), .B(cycle11_HSS_TXD[6]), .Z(N264) );
  GTECH_AND2 C397 ( .A(N267), .B(cycle11_HSS_TXD[8]), .Z(N268) );
  GTECH_AND2 C398 ( .A(N45), .B(N3), .Z(N267) );
  GTECH_AND2 C399 ( .A(N46), .B(cycle11_HSS_TXD[6]), .Z(N270) );
  GTECH_AND2 C400 ( .A(N272), .B(cycle11_HSS_TXD[8]), .Z(N273) );
  GTECH_AND2 C401 ( .A(N46), .B(N3), .Z(N272) );
  GTECH_AND2 C402 ( .A(N47), .B(cycle11_HSS_TXD[6]), .Z(N275) );
  GTECH_AND2 C403 ( .A(N277), .B(cycle11_HSS_TXD[8]), .Z(N278) );
  GTECH_AND2 C404 ( .A(N47), .B(N3), .Z(N277) );
  GTECH_AND2 C407 ( .A(cycle11_HSS_TXD[9]), .B(N2), .Z(N48) );
  GTECH_AND2 C413 ( .A(N48), .B(N3), .Z(N49) );
  GTECH_AND2 C414 ( .A(N49), .B(cycle11_HSS_TXD[7]), .Z(N50) );
  GTECH_AND2 C415 ( .A(N50), .B(N10), .Z(N51) );
  GTECH_AND2 C416 ( .A(N51), .B(cycle11_HSS_TXD[0]), .Z(N52) );
  GTECH_AND2 C417 ( .A(N52), .B(N4), .Z(N53) );
  GTECH_AND2 C418 ( .A(N53), .B(N13), .Z(N54) );
  GTECH_AND2 C422 ( .A(N28), .B(cycle11_HSS_TXD[8]), .Z(N55) );
  GTECH_AND2 C423 ( .A(N55), .B(cycle11_HSS_TXD[6]), .Z(N56) );
  GTECH_AND2 C424 ( .A(N279), .B(cycle11_HSS_TXD[7]), .Z(N57) );
  GTECH_AND2 C425 ( .A(N55), .B(N3), .Z(N279) );
  GTECH_AND2 C426 ( .A(N57), .B(N10), .Z(N58) );
  GTECH_AND2 C427 ( .A(N58), .B(cycle11_HSS_TXD[0]), .Z(N59) );
  GTECH_AND2 C428 ( .A(N59), .B(N4), .Z(N60) );
  GTECH_AND2 C429 ( .A(N60), .B(N13), .Z(N61) );
  GTECH_OR2 C430 ( .A(N328), .B(N330), .Z(TXDATA[6]) );
  GTECH_OR2 C431 ( .A(N326), .B(N327), .Z(N328) );
  GTECH_OR2 C432 ( .A(N324), .B(N325), .Z(N326) );
  GTECH_OR2 C433 ( .A(N321), .B(N323), .Z(N324) );
  GTECH_OR2 C434 ( .A(N319), .B(N320), .Z(N321) );
  GTECH_OR2 C435 ( .A(N317), .B(N318), .Z(N319) );
  GTECH_OR2 C436 ( .A(N315), .B(N316), .Z(N317) );
  GTECH_OR2 C437 ( .A(N307), .B(N314), .Z(N315) );
  GTECH_OR2 C438 ( .A(N305), .B(N306), .Z(N307) );
  GTECH_OR2 C439 ( .A(N303), .B(N304), .Z(N305) );
  GTECH_OR2 C440 ( .A(N301), .B(N302), .Z(N303) );
  GTECH_OR2 C441 ( .A(N299), .B(N300), .Z(N301) );
  GTECH_OR2 C442 ( .A(N296), .B(N298), .Z(N299) );
  GTECH_OR2 C443 ( .A(N294), .B(N295), .Z(N296) );
  GTECH_OR2 C444 ( .A(N292), .B(N293), .Z(N294) );
  GTECH_OR2 C445 ( .A(N290), .B(N291), .Z(N292) );
  GTECH_OR2 C446 ( .A(N281), .B(N289), .Z(N290) );
  GTECH_AND2 C447 ( .A(N280), .B(N3), .Z(N281) );
  GTECH_AND2 C448 ( .A(cycle11_HSS_TXD[9]), .B(cycle11_HSS_TXD[8]), .Z(N280)
         );
  GTECH_AND2 C449 ( .A(N288), .B(N7), .Z(N289) );
  GTECH_AND2 C450 ( .A(N287), .B(cycle11_HSS_TXD[1]), .Z(N288) );
  GTECH_AND2 C451 ( .A(N286), .B(N13), .Z(N287) );
  GTECH_AND2 C452 ( .A(N285), .B(N4), .Z(N286) );
  GTECH_AND2 C453 ( .A(N284), .B(cycle11_HSS_TXD[0]), .Z(N285) );
  GTECH_AND2 C454 ( .A(N283), .B(N10), .Z(N284) );
  GTECH_AND2 C455 ( .A(N282), .B(N21), .Z(N283) );
  GTECH_AND2 C456 ( .A(N48), .B(cycle11_HSS_TXD[6]), .Z(N282) );
  GTECH_AND2 C457 ( .A(N50), .B(cycle11_HSS_TXD[5]), .Z(N291) );
  GTECH_AND2 C458 ( .A(N52), .B(cycle11_HSS_TXD[3]), .Z(N293) );
  GTECH_AND2 C459 ( .A(N53), .B(cycle11_HSS_TXD[2]), .Z(N295) );
  GTECH_AND2 C460 ( .A(N297), .B(cycle11_HSS_TXD[4]), .Z(N298) );
  GTECH_AND2 C461 ( .A(N54), .B(cycle11_HSS_TXD[1]), .Z(N297) );
  GTECH_AND2 C462 ( .A(N54), .B(N19), .Z(N300) );
  GTECH_AND2 C463 ( .A(N51), .B(N17), .Z(N302) );
  GTECH_AND2 C464 ( .A(N49), .B(N21), .Z(N304) );
  GTECH_AND2 C465 ( .A(N56), .B(cycle11_HSS_TXD[7]), .Z(N306) );
  GTECH_AND2 C466 ( .A(N313), .B(N7), .Z(N314) );
  GTECH_AND2 C467 ( .A(N312), .B(cycle11_HSS_TXD[1]), .Z(N313) );
  GTECH_AND2 C468 ( .A(N311), .B(N13), .Z(N312) );
  GTECH_AND2 C469 ( .A(N310), .B(N4), .Z(N311) );
  GTECH_AND2 C470 ( .A(N309), .B(cycle11_HSS_TXD[0]), .Z(N310) );
  GTECH_AND2 C471 ( .A(N308), .B(N10), .Z(N309) );
  GTECH_AND2 C472 ( .A(N56), .B(N21), .Z(N308) );
  GTECH_AND2 C473 ( .A(N57), .B(cycle11_HSS_TXD[5]), .Z(N316) );
  GTECH_AND2 C474 ( .A(N59), .B(cycle11_HSS_TXD[3]), .Z(N318) );
  GTECH_AND2 C475 ( .A(N60), .B(cycle11_HSS_TXD[2]), .Z(N320) );
  GTECH_AND2 C476 ( .A(N322), .B(cycle11_HSS_TXD[4]), .Z(N323) );
  GTECH_AND2 C477 ( .A(N61), .B(cycle11_HSS_TXD[1]), .Z(N322) );
  GTECH_AND2 C478 ( .A(N61), .B(N19), .Z(N325) );
  GTECH_AND2 C479 ( .A(N58), .B(N17), .Z(N327) );
  GTECH_AND2 C480 ( .A(N329), .B(cycle11_HSS_TXD[6]), .Z(N330) );
  GTECH_AND2 C481 ( .A(N28), .B(N2), .Z(N329) );
  GTECH_AND2 C484 ( .A(cycle11_HSS_TXD[8]), .B(N28), .Z(N62) );
  GTECH_AND2 C485 ( .A(N62), .B(cycle11_HSS_TXD[6]), .Z(N63) );
  GTECH_AND2 C487 ( .A(N63), .B(N4), .Z(N64) );
  GTECH_AND2 C489 ( .A(N64), .B(N7), .Z(N65) );
  GTECH_AND2 C491 ( .A(N65), .B(N10), .Z(N66) );
  GTECH_AND2 C493 ( .A(N66), .B(N13), .Z(N67) );
  GTECH_AND2 C494 ( .A(N67), .B(cycle11_HSS_TXD[1]), .Z(N68) );
  GTECH_AND2 C498 ( .A(N2), .B(cycle11_HSS_TXD[9]), .Z(N69) );
  GTECH_AND2 C499 ( .A(N69), .B(cycle11_HSS_TXD[6]), .Z(N70) );
  GTECH_AND2 C501 ( .A(N70), .B(N4), .Z(N71) );
  GTECH_AND2 C502 ( .A(N71), .B(N7), .Z(N72) );
  GTECH_AND2 C503 ( .A(N72), .B(N10), .Z(N73) );
  GTECH_AND2 C504 ( .A(N73), .B(N13), .Z(N74) );
  GTECH_AND2 C505 ( .A(N69), .B(N3), .Z(N75) );
  GTECH_AND2 C506 ( .A(N75), .B(N4), .Z(N76) );
  GTECH_AND2 C507 ( .A(N76), .B(N7), .Z(N77) );
  GTECH_AND2 C508 ( .A(N77), .B(N10), .Z(N78) );
  GTECH_AND2 C509 ( .A(N78), .B(N13), .Z(N79) );
  GTECH_AND2 C510 ( .A(N79), .B(cycle11_HSS_TXD[1]), .Z(N80) );
  GTECH_OR2 C511 ( .A(N395), .B(N397), .Z(TXDATA[5]) );
  GTECH_OR2 C512 ( .A(N392), .B(N394), .Z(N395) );
  GTECH_OR2 C513 ( .A(N389), .B(N391), .Z(N392) );
  GTECH_OR2 C514 ( .A(N387), .B(N388), .Z(N389) );
  GTECH_OR2 C515 ( .A(N384), .B(N386), .Z(N387) );
  GTECH_OR2 C516 ( .A(N381), .B(N383), .Z(N384) );
  GTECH_OR2 C517 ( .A(N378), .B(N380), .Z(N381) );
  GTECH_OR2 C518 ( .A(N375), .B(N377), .Z(N378) );
  GTECH_OR2 C519 ( .A(N372), .B(N374), .Z(N375) );
  GTECH_OR2 C520 ( .A(N368), .B(N371), .Z(N372) );
  GTECH_OR2 C521 ( .A(N365), .B(N367), .Z(N368) );
  GTECH_OR2 C522 ( .A(N362), .B(N364), .Z(N365) );
  GTECH_OR2 C523 ( .A(N359), .B(N361), .Z(N362) );
  GTECH_OR2 C524 ( .A(N356), .B(N358), .Z(N359) );
  GTECH_OR2 C525 ( .A(N347), .B(N355), .Z(N356) );
  GTECH_OR2 C526 ( .A(N345), .B(N346), .Z(N347) );
  GTECH_OR2 C527 ( .A(N343), .B(N344), .Z(N345) );
  GTECH_OR2 C528 ( .A(N340), .B(N342), .Z(N343) );
  GTECH_OR2 C529 ( .A(N338), .B(N339), .Z(N340) );
  GTECH_OR2 C530 ( .A(N336), .B(N337), .Z(N338) );
  GTECH_OR2 C531 ( .A(N334), .B(N335), .Z(N336) );
  GTECH_OR2 C532 ( .A(N332), .B(N333), .Z(N334) );
  GTECH_AND2 C533 ( .A(N331), .B(N3), .Z(N332) );
  GTECH_AND2 C534 ( .A(cycle11_HSS_TXD[8]), .B(cycle11_HSS_TXD[9]), .Z(N331)
         );
  GTECH_AND2 C535 ( .A(N63), .B(cycle11_HSS_TXD[3]), .Z(N333) );
  GTECH_AND2 C536 ( .A(N64), .B(cycle11_HSS_TXD[4]), .Z(N335) );
  GTECH_AND2 C537 ( .A(N65), .B(cycle11_HSS_TXD[5]), .Z(N337) );
  GTECH_AND2 C538 ( .A(N66), .B(cycle11_HSS_TXD[2]), .Z(N339) );
  GTECH_AND2 C539 ( .A(N341), .B(cycle11_HSS_TXD[7]), .Z(N342) );
  GTECH_AND2 C540 ( .A(N68), .B(cycle11_HSS_TXD[0]), .Z(N341) );
  GTECH_AND2 C541 ( .A(N68), .B(N17), .Z(N344) );
  GTECH_AND2 C542 ( .A(N67), .B(N19), .Z(N346) );
  GTECH_AND2 C543 ( .A(N354), .B(cycle11_HSS_TXD[7]), .Z(N355) );
  GTECH_AND2 C544 ( .A(N353), .B(cycle11_HSS_TXD[0]), .Z(N354) );
  GTECH_AND2 C545 ( .A(N352), .B(cycle11_HSS_TXD[1]), .Z(N353) );
  GTECH_AND2 C546 ( .A(N351), .B(N13), .Z(N352) );
  GTECH_AND2 C547 ( .A(N350), .B(N10), .Z(N351) );
  GTECH_AND2 C548 ( .A(N349), .B(N7), .Z(N350) );
  GTECH_AND2 C549 ( .A(N348), .B(N4), .Z(N349) );
  GTECH_AND2 C550 ( .A(N62), .B(N3), .Z(N348) );
  GTECH_AND2 C551 ( .A(N357), .B(N21), .Z(N358) );
  GTECH_AND2 C552 ( .A(N70), .B(cycle11_HSS_TXD[3]), .Z(N357) );
  GTECH_AND2 C553 ( .A(N360), .B(N21), .Z(N361) );
  GTECH_AND2 C554 ( .A(N71), .B(cycle11_HSS_TXD[4]), .Z(N360) );
  GTECH_AND2 C555 ( .A(N363), .B(N21), .Z(N364) );
  GTECH_AND2 C556 ( .A(N72), .B(cycle11_HSS_TXD[5]), .Z(N363) );
  GTECH_AND2 C557 ( .A(N366), .B(N21), .Z(N367) );
  GTECH_AND2 C558 ( .A(N73), .B(cycle11_HSS_TXD[2]), .Z(N366) );
  GTECH_AND2 C559 ( .A(N370), .B(N21), .Z(N371) );
  GTECH_AND2 C560 ( .A(N369), .B(N17), .Z(N370) );
  GTECH_AND2 C561 ( .A(N74), .B(cycle11_HSS_TXD[1]), .Z(N369) );
  GTECH_AND2 C562 ( .A(N373), .B(N21), .Z(N374) );
  GTECH_AND2 C563 ( .A(N74), .B(N19), .Z(N373) );
  GTECH_AND2 C564 ( .A(N376), .B(N21), .Z(N377) );
  GTECH_AND2 C565 ( .A(N75), .B(cycle11_HSS_TXD[3]), .Z(N376) );
  GTECH_AND2 C566 ( .A(N379), .B(N21), .Z(N380) );
  GTECH_AND2 C567 ( .A(N76), .B(cycle11_HSS_TXD[4]), .Z(N379) );
  GTECH_AND2 C568 ( .A(N382), .B(N21), .Z(N383) );
  GTECH_AND2 C569 ( .A(N77), .B(cycle11_HSS_TXD[5]), .Z(N382) );
  GTECH_AND2 C570 ( .A(N385), .B(N21), .Z(N386) );
  GTECH_AND2 C571 ( .A(N78), .B(cycle11_HSS_TXD[2]), .Z(N385) );
  GTECH_AND2 C572 ( .A(N80), .B(cycle11_HSS_TXD[0]), .Z(N388) );
  GTECH_AND2 C573 ( .A(N390), .B(N21), .Z(N391) );
  GTECH_AND2 C574 ( .A(N80), .B(N17), .Z(N390) );
  GTECH_AND2 C575 ( .A(N393), .B(N21), .Z(N394) );
  GTECH_AND2 C576 ( .A(N79), .B(N19), .Z(N393) );
  GTECH_AND2 C577 ( .A(N396), .B(cycle11_HSS_TXD[6]), .Z(N397) );
  GTECH_AND2 C578 ( .A(N2), .B(N28), .Z(N396) );
  GTECH_AND2 C579 ( .A(cycle11_HSS_TXD[5]), .B(cycle11_HSS_TXD[3]), .Z(N81) );
  GTECH_AND2 C585 ( .A(cycle11_HSS_TXD[5]), .B(N4), .Z(N82) );
  GTECH_AND2 C586 ( .A(N82), .B(N7), .Z(N83) );
  GTECH_AND2 C587 ( .A(N83), .B(N19), .Z(N84) );
  GTECH_AND2 C589 ( .A(N10), .B(cycle11_HSS_TXD[3]), .Z(N85) );
  GTECH_AND2 C590 ( .A(N85), .B(cycle11_HSS_TXD[4]), .Z(N86) );
  GTECH_AND2 C591 ( .A(N86), .B(N19), .Z(N87) );
  GTECH_AND2 C592 ( .A(N85), .B(N7), .Z(N88) );
  GTECH_AND2 C593 ( .A(N88), .B(N19), .Z(N89) );
  GTECH_AND2 C594 ( .A(N10), .B(N4), .Z(N90) );
  GTECH_AND2 C595 ( .A(N90), .B(cycle11_HSS_TXD[4]), .Z(N91) );
  GTECH_AND2 C596 ( .A(N91), .B(cycle11_HSS_TXD[1]), .Z(N92) );
  GTECH_OR2 C597 ( .A(N441), .B(N444), .Z(TXDATA[4]) );
  GTECH_OR2 C598 ( .A(N437), .B(N440), .Z(N441) );
  GTECH_OR2 C599 ( .A(N434), .B(N436), .Z(N437) );
  GTECH_OR2 C600 ( .A(N432), .B(N433), .Z(N434) );
  GTECH_OR2 C601 ( .A(N430), .B(N431), .Z(N432) );
  GTECH_OR2 C602 ( .A(N427), .B(N429), .Z(N430) );
  GTECH_OR2 C603 ( .A(N423), .B(N426), .Z(N427) );
  GTECH_OR2 C604 ( .A(N420), .B(N422), .Z(N423) );
  GTECH_OR2 C605 ( .A(N418), .B(N419), .Z(N420) );
  GTECH_OR2 C606 ( .A(N416), .B(N417), .Z(N418) );
  GTECH_OR2 C607 ( .A(N414), .B(N415), .Z(N416) );
  GTECH_OR2 C608 ( .A(N411), .B(N413), .Z(N414) );
  GTECH_OR2 C609 ( .A(N407), .B(N410), .Z(N411) );
  GTECH_OR2 C610 ( .A(N405), .B(N406), .Z(N407) );
  GTECH_OR2 C611 ( .A(N400), .B(N404), .Z(N405) );
  GTECH_AND2 C612 ( .A(N399), .B(N17), .Z(N400) );
  GTECH_AND2 C613 ( .A(N398), .B(cycle11_HSS_TXD[2]), .Z(N399) );
  GTECH_AND2 C614 ( .A(N81), .B(cycle11_HSS_TXD[4]), .Z(N398) );
  GTECH_AND2 C615 ( .A(N403), .B(N17), .Z(N404) );
  GTECH_AND2 C616 ( .A(N402), .B(N13), .Z(N403) );
  GTECH_AND2 C617 ( .A(N401), .B(N19), .Z(N402) );
  GTECH_AND2 C618 ( .A(N81), .B(N7), .Z(N401) );
  GTECH_AND2 C619 ( .A(N82), .B(cycle11_HSS_TXD[4]), .Z(N406) );
  GTECH_AND2 C620 ( .A(N409), .B(N17), .Z(N410) );
  GTECH_AND2 C621 ( .A(N408), .B(N13), .Z(N409) );
  GTECH_AND2 C622 ( .A(N83), .B(cycle11_HSS_TXD[1]), .Z(N408) );
  GTECH_AND2 C623 ( .A(N412), .B(N17), .Z(N413) );
  GTECH_AND2 C624 ( .A(N84), .B(cycle11_HSS_TXD[2]), .Z(N412) );
  GTECH_AND2 C625 ( .A(N84), .B(N13), .Z(N415) );
  GTECH_AND2 C626 ( .A(N86), .B(cycle11_HSS_TXD[1]), .Z(N417) );
  GTECH_AND2 C627 ( .A(N87), .B(cycle11_HSS_TXD[2]), .Z(N419) );
  GTECH_AND2 C628 ( .A(N421), .B(cycle11_HSS_TXD[0]), .Z(N422) );
  GTECH_AND2 C629 ( .A(N87), .B(N13), .Z(N421) );
  GTECH_AND2 C630 ( .A(N425), .B(N17), .Z(N426) );
  GTECH_AND2 C631 ( .A(N424), .B(N13), .Z(N425) );
  GTECH_AND2 C632 ( .A(N88), .B(cycle11_HSS_TXD[1]), .Z(N424) );
  GTECH_AND2 C633 ( .A(N428), .B(N17), .Z(N429) );
  GTECH_AND2 C634 ( .A(N89), .B(cycle11_HSS_TXD[2]), .Z(N428) );
  GTECH_AND2 C635 ( .A(N89), .B(N13), .Z(N431) );
  GTECH_AND2 C636 ( .A(N92), .B(cycle11_HSS_TXD[2]), .Z(N433) );
  GTECH_AND2 C637 ( .A(N435), .B(cycle11_HSS_TXD[0]), .Z(N436) );
  GTECH_AND2 C638 ( .A(N92), .B(N13), .Z(N435) );
  GTECH_AND2 C639 ( .A(N439), .B(cycle11_HSS_TXD[0]), .Z(N440) );
  GTECH_AND2 C640 ( .A(N438), .B(cycle11_HSS_TXD[2]), .Z(N439) );
  GTECH_AND2 C641 ( .A(N91), .B(N19), .Z(N438) );
  GTECH_AND2 C642 ( .A(N443), .B(cycle11_HSS_TXD[0]), .Z(N444) );
  GTECH_AND2 C643 ( .A(N442), .B(N13), .Z(N443) );
  GTECH_AND2 C644 ( .A(N90), .B(N7), .Z(N442) );
  GTECH_AND2 C645 ( .A(cycle11_HSS_TXD[2]), .B(cycle11_HSS_TXD[0]), .Z(N93) );
  GTECH_AND2 C646 ( .A(N93), .B(cycle11_HSS_TXD[1]), .Z(N94) );
  GTECH_AND2 C650 ( .A(N93), .B(N19), .Z(N95) );
  GTECH_AND2 C651 ( .A(N95), .B(N4), .Z(N96) );
  GTECH_AND2 C654 ( .A(cycle11_HSS_TXD[2]), .B(N17), .Z(N97) );
  GTECH_AND2 C655 ( .A(N97), .B(N19), .Z(N98) );
  GTECH_AND2 C657 ( .A(N13), .B(cycle11_HSS_TXD[0]), .Z(N99) );
  GTECH_AND2 C658 ( .A(N99), .B(cycle11_HSS_TXD[1]), .Z(N100) );
  GTECH_AND2 C659 ( .A(N100), .B(N4), .Z(N101) );
  GTECH_AND2 C660 ( .A(N99), .B(N19), .Z(N102) );
  GTECH_AND2 C661 ( .A(N102), .B(cycle11_HSS_TXD[3]), .Z(N103) );
  GTECH_AND2 C662 ( .A(N13), .B(N17), .Z(N104) );
  GTECH_AND2 C663 ( .A(N104), .B(cycle11_HSS_TXD[1]), .Z(N105) );
  GTECH_AND2 C664 ( .A(N104), .B(N19), .Z(N106) );
  GTECH_OR2 C665 ( .A(N494), .B(N495), .Z(TXDATA[3]) );
  GTECH_OR2 C666 ( .A(N491), .B(N493), .Z(N494) );
  GTECH_OR2 C667 ( .A(N488), .B(N490), .Z(N491) );
  GTECH_OR2 C668 ( .A(N486), .B(N487), .Z(N488) );
  GTECH_OR2 C669 ( .A(N483), .B(N485), .Z(N486) );
  GTECH_OR2 C670 ( .A(N480), .B(N482), .Z(N483) );
  GTECH_OR2 C671 ( .A(N477), .B(N479), .Z(N480) );
  GTECH_OR2 C672 ( .A(N474), .B(N476), .Z(N477) );
  GTECH_OR2 C673 ( .A(N471), .B(N473), .Z(N474) );
  GTECH_OR2 C674 ( .A(N468), .B(N470), .Z(N471) );
  GTECH_OR2 C675 ( .A(N464), .B(N467), .Z(N468) );
  GTECH_OR2 C676 ( .A(N462), .B(N463), .Z(N464) );
  GTECH_OR2 C677 ( .A(N458), .B(N461), .Z(N462) );
  GTECH_OR2 C678 ( .A(N455), .B(N457), .Z(N458) );
  GTECH_OR2 C679 ( .A(N452), .B(N454), .Z(N455) );
  GTECH_OR2 C680 ( .A(N449), .B(N451), .Z(N452) );
  GTECH_OR2 C681 ( .A(N446), .B(N448), .Z(N449) );
  GTECH_AND2 C682 ( .A(N445), .B(N10), .Z(N446) );
  GTECH_AND2 C683 ( .A(N94), .B(cycle11_HSS_TXD[3]), .Z(N445) );
  GTECH_AND2 C684 ( .A(N447), .B(cycle11_HSS_TXD[5]), .Z(N448) );
  GTECH_AND2 C685 ( .A(N94), .B(N4), .Z(N447) );
  GTECH_AND2 C686 ( .A(N450), .B(N10), .Z(N451) );
  GTECH_AND2 C687 ( .A(N95), .B(cycle11_HSS_TXD[3]), .Z(N450) );
  GTECH_AND2 C688 ( .A(N453), .B(cycle11_HSS_TXD[5]), .Z(N454) );
  GTECH_AND2 C689 ( .A(N96), .B(cycle11_HSS_TXD[4]), .Z(N453) );
  GTECH_AND2 C690 ( .A(N456), .B(N10), .Z(N457) );
  GTECH_AND2 C691 ( .A(N96), .B(N7), .Z(N456) );
  GTECH_AND2 C692 ( .A(N460), .B(N10), .Z(N461) );
  GTECH_AND2 C693 ( .A(N459), .B(cycle11_HSS_TXD[3]), .Z(N460) );
  GTECH_AND2 C694 ( .A(N97), .B(cycle11_HSS_TXD[1]), .Z(N459) );
  GTECH_AND2 C695 ( .A(N98), .B(cycle11_HSS_TXD[3]), .Z(N463) );
  GTECH_AND2 C696 ( .A(N466), .B(cycle11_HSS_TXD[5]), .Z(N467) );
  GTECH_AND2 C697 ( .A(N465), .B(N7), .Z(N466) );
  GTECH_AND2 C698 ( .A(N98), .B(N4), .Z(N465) );
  GTECH_AND2 C699 ( .A(N469), .B(N10), .Z(N470) );
  GTECH_AND2 C700 ( .A(N100), .B(cycle11_HSS_TXD[3]), .Z(N469) );
  GTECH_AND2 C701 ( .A(N472), .B(cycle11_HSS_TXD[5]), .Z(N473) );
  GTECH_AND2 C702 ( .A(N101), .B(cycle11_HSS_TXD[4]), .Z(N472) );
  GTECH_AND2 C703 ( .A(N475), .B(N10), .Z(N476) );
  GTECH_AND2 C704 ( .A(N101), .B(N7), .Z(N475) );
  GTECH_AND2 C705 ( .A(N478), .B(N10), .Z(N479) );
  GTECH_AND2 C706 ( .A(N103), .B(cycle11_HSS_TXD[4]), .Z(N478) );
  GTECH_AND2 C707 ( .A(N481), .B(cycle11_HSS_TXD[5]), .Z(N482) );
  GTECH_AND2 C708 ( .A(N103), .B(N7), .Z(N481) );
  GTECH_AND2 C709 ( .A(N484), .B(N7), .Z(N485) );
  GTECH_AND2 C710 ( .A(N102), .B(N4), .Z(N484) );
  GTECH_AND2 C711 ( .A(N105), .B(cycle11_HSS_TXD[3]), .Z(N487) );
  GTECH_AND2 C712 ( .A(N489), .B(N7), .Z(N490) );
  GTECH_AND2 C713 ( .A(N105), .B(N4), .Z(N489) );
  GTECH_AND2 C714 ( .A(N492), .B(N10), .Z(N493) );
  GTECH_AND2 C715 ( .A(N106), .B(cycle11_HSS_TXD[3]), .Z(N492) );
  GTECH_AND2 C716 ( .A(N106), .B(N4), .Z(N495) );
  GTECH_AND2 C717 ( .A(cycle11_HSS_TXD[4]), .B(cycle11_HSS_TXD[3]), .Z(N107)
         );
  GTECH_AND2 C718 ( .A(N107), .B(cycle11_HSS_TXD[2]), .Z(N108) );
  GTECH_AND2 C723 ( .A(N496), .B(cycle11_HSS_TXD[5]), .Z(N109) );
  GTECH_AND2 C724 ( .A(N107), .B(N13), .Z(N496) );
  GTECH_AND2 C726 ( .A(cycle11_HSS_TXD[4]), .B(N4), .Z(N110) );
  GTECH_AND2 C727 ( .A(N110), .B(cycle11_HSS_TXD[2]), .Z(N111) );
  GTECH_AND2 C729 ( .A(N7), .B(cycle11_HSS_TXD[3]), .Z(N112) );
  GTECH_AND2 C730 ( .A(N112), .B(cycle11_HSS_TXD[2]), .Z(N113) );
  GTECH_AND2 C731 ( .A(N113), .B(N10), .Z(N114) );
  GTECH_AND2 C732 ( .A(N112), .B(N13), .Z(N115) );
  GTECH_AND2 C733 ( .A(N115), .B(cycle11_HSS_TXD[5]), .Z(N116) );
  GTECH_AND2 C734 ( .A(N7), .B(N4), .Z(N117) );
  GTECH_AND2 C735 ( .A(N117), .B(cycle11_HSS_TXD[2]), .Z(N118) );
  GTECH_AND2 C736 ( .A(N118), .B(cycle11_HSS_TXD[5]), .Z(N119) );
  GTECH_AND2 C737 ( .A(N117), .B(N13), .Z(N120) );
  GTECH_AND2 C738 ( .A(N120), .B(cycle11_HSS_TXD[5]), .Z(N121) );
  GTECH_OR2 C739 ( .A(N548), .B(N549), .Z(TXDATA[2]) );
  GTECH_OR2 C740 ( .A(N546), .B(N547), .Z(N548) );
  GTECH_OR2 C741 ( .A(N543), .B(N545), .Z(N546) );
  GTECH_OR2 C742 ( .A(N540), .B(N542), .Z(N543) );
  GTECH_OR2 C743 ( .A(N537), .B(N539), .Z(N540) );
  GTECH_OR2 C744 ( .A(N534), .B(N536), .Z(N537) );
  GTECH_OR2 C745 ( .A(N530), .B(N533), .Z(N534) );
  GTECH_OR2 C746 ( .A(N527), .B(N529), .Z(N530) );
  GTECH_OR2 C747 ( .A(N524), .B(N526), .Z(N527) );
  GTECH_OR2 C748 ( .A(N521), .B(N523), .Z(N524) );
  GTECH_OR2 C749 ( .A(N519), .B(N520), .Z(N521) );
  GTECH_OR2 C750 ( .A(N515), .B(N518), .Z(N519) );
  GTECH_OR2 C751 ( .A(N511), .B(N514), .Z(N515) );
  GTECH_OR2 C752 ( .A(N509), .B(N510), .Z(N511) );
  GTECH_OR2 C753 ( .A(N506), .B(N508), .Z(N509) );
  GTECH_OR2 C754 ( .A(N503), .B(N505), .Z(N506) );
  GTECH_OR2 C755 ( .A(N501), .B(N502), .Z(N503) );
  GTECH_OR2 C756 ( .A(N499), .B(N500), .Z(N501) );
  GTECH_AND2 C757 ( .A(N498), .B(N17), .Z(N499) );
  GTECH_AND2 C758 ( .A(N497), .B(N19), .Z(N498) );
  GTECH_AND2 C759 ( .A(N108), .B(cycle11_HSS_TXD[5]), .Z(N497) );
  GTECH_AND2 C760 ( .A(N108), .B(N10), .Z(N500) );
  GTECH_AND2 C761 ( .A(N109), .B(cycle11_HSS_TXD[1]), .Z(N502) );
  GTECH_AND2 C762 ( .A(N504), .B(N17), .Z(N505) );
  GTECH_AND2 C763 ( .A(N109), .B(N19), .Z(N504) );
  GTECH_AND2 C764 ( .A(N507), .B(N19), .Z(N508) );
  GTECH_AND2 C765 ( .A(N111), .B(cycle11_HSS_TXD[5]), .Z(N507) );
  GTECH_AND2 C766 ( .A(N111), .B(N10), .Z(N510) );
  GTECH_AND2 C767 ( .A(N513), .B(N17), .Z(N514) );
  GTECH_AND2 C768 ( .A(N512), .B(N19), .Z(N513) );
  GTECH_AND2 C769 ( .A(N110), .B(N13), .Z(N512) );
  GTECH_AND2 C770 ( .A(N517), .B(N17), .Z(N518) );
  GTECH_AND2 C771 ( .A(N516), .B(N19), .Z(N517) );
  GTECH_AND2 C772 ( .A(N113), .B(cycle11_HSS_TXD[5]), .Z(N516) );
  GTECH_AND2 C773 ( .A(N114), .B(cycle11_HSS_TXD[1]), .Z(N520) );
  GTECH_AND2 C774 ( .A(N522), .B(cycle11_HSS_TXD[0]), .Z(N523) );
  GTECH_AND2 C775 ( .A(N114), .B(N19), .Z(N522) );
  GTECH_AND2 C776 ( .A(N525), .B(cycle11_HSS_TXD[0]), .Z(N526) );
  GTECH_AND2 C777 ( .A(N116), .B(cycle11_HSS_TXD[1]), .Z(N525) );
  GTECH_AND2 C778 ( .A(N528), .B(N17), .Z(N529) );
  GTECH_AND2 C779 ( .A(N116), .B(N19), .Z(N528) );
  GTECH_AND2 C780 ( .A(N532), .B(N17), .Z(N533) );
  GTECH_AND2 C781 ( .A(N531), .B(cycle11_HSS_TXD[1]), .Z(N532) );
  GTECH_AND2 C782 ( .A(N115), .B(N10), .Z(N531) );
  GTECH_AND2 C783 ( .A(N535), .B(N17), .Z(N536) );
  GTECH_AND2 C784 ( .A(N119), .B(cycle11_HSS_TXD[1]), .Z(N535) );
  GTECH_AND2 C785 ( .A(N538), .B(cycle11_HSS_TXD[0]), .Z(N539) );
  GTECH_AND2 C786 ( .A(N119), .B(N19), .Z(N538) );
  GTECH_AND2 C787 ( .A(N541), .B(cycle11_HSS_TXD[0]), .Z(N542) );
  GTECH_AND2 C788 ( .A(N118), .B(N10), .Z(N541) );
  GTECH_AND2 C789 ( .A(N544), .B(N17), .Z(N545) );
  GTECH_AND2 C790 ( .A(N121), .B(cycle11_HSS_TXD[1]), .Z(N544) );
  GTECH_AND2 C791 ( .A(N121), .B(N19), .Z(N547) );
  GTECH_AND2 C792 ( .A(N120), .B(N10), .Z(N549) );
  GTECH_AND2 C793 ( .A(cycle11_HSS_TXD[1]), .B(cycle11_HSS_TXD[5]), .Z(N122)
         );
  GTECH_AND2 C798 ( .A(N122), .B(N17), .Z(N123) );
  GTECH_AND2 C799 ( .A(N123), .B(N13), .Z(N124) );
  GTECH_AND2 C801 ( .A(cycle11_HSS_TXD[1]), .B(N10), .Z(N125) );
  GTECH_AND2 C802 ( .A(N125), .B(cycle11_HSS_TXD[0]), .Z(N126) );
  GTECH_AND2 C803 ( .A(N126), .B(N13), .Z(N127) );
  GTECH_AND2 C804 ( .A(N125), .B(N17), .Z(N128) );
  GTECH_AND2 C806 ( .A(N19), .B(cycle11_HSS_TXD[5]), .Z(N129) );
  GTECH_AND2 C807 ( .A(N129), .B(cycle11_HSS_TXD[0]), .Z(N130) );
  GTECH_AND2 C808 ( .A(N130), .B(cycle11_HSS_TXD[2]), .Z(N131) );
  GTECH_AND2 C809 ( .A(N129), .B(N17), .Z(N132) );
  GTECH_OR2 C810 ( .A(N589), .B(N592), .Z(TXDATA[1]) );
  GTECH_OR2 C811 ( .A(N587), .B(N588), .Z(N589) );
  GTECH_OR2 C812 ( .A(N583), .B(N586), .Z(N587) );
  GTECH_OR2 C813 ( .A(N579), .B(N582), .Z(N583) );
  GTECH_OR2 C814 ( .A(N576), .B(N578), .Z(N579) );
  GTECH_OR2 C815 ( .A(N574), .B(N575), .Z(N576) );
  GTECH_OR2 C816 ( .A(N571), .B(N573), .Z(N574) );
  GTECH_OR2 C817 ( .A(N569), .B(N570), .Z(N571) );
  GTECH_OR2 C818 ( .A(N566), .B(N568), .Z(N569) );
  GTECH_OR2 C819 ( .A(N564), .B(N565), .Z(N566) );
  GTECH_OR2 C820 ( .A(N562), .B(N563), .Z(N564) );
  GTECH_OR2 C821 ( .A(N559), .B(N561), .Z(N562) );
  GTECH_OR2 C822 ( .A(N557), .B(N558), .Z(N559) );
  GTECH_OR2 C823 ( .A(N553), .B(N556), .Z(N557) );
  GTECH_AND2 C824 ( .A(N552), .B(N7), .Z(N553) );
  GTECH_AND2 C825 ( .A(N551), .B(N4), .Z(N552) );
  GTECH_AND2 C826 ( .A(N550), .B(N13), .Z(N551) );
  GTECH_AND2 C827 ( .A(N122), .B(cycle11_HSS_TXD[0]), .Z(N550) );
  GTECH_AND2 C828 ( .A(N555), .B(N7), .Z(N556) );
  GTECH_AND2 C829 ( .A(N554), .B(N4), .Z(N555) );
  GTECH_AND2 C830 ( .A(N123), .B(cycle11_HSS_TXD[2]), .Z(N554) );
  GTECH_AND2 C831 ( .A(N124), .B(cycle11_HSS_TXD[3]), .Z(N558) );
  GTECH_AND2 C832 ( .A(N560), .B(cycle11_HSS_TXD[4]), .Z(N561) );
  GTECH_AND2 C833 ( .A(N124), .B(N4), .Z(N560) );
  GTECH_AND2 C834 ( .A(N126), .B(cycle11_HSS_TXD[2]), .Z(N563) );
  GTECH_AND2 C835 ( .A(N127), .B(cycle11_HSS_TXD[3]), .Z(N565) );
  GTECH_AND2 C836 ( .A(N567), .B(cycle11_HSS_TXD[4]), .Z(N568) );
  GTECH_AND2 C837 ( .A(N127), .B(N4), .Z(N567) );
  GTECH_AND2 C838 ( .A(N128), .B(cycle11_HSS_TXD[3]), .Z(N570) );
  GTECH_AND2 C839 ( .A(N572), .B(cycle11_HSS_TXD[4]), .Z(N573) );
  GTECH_AND2 C840 ( .A(N128), .B(N4), .Z(N572) );
  GTECH_AND2 C841 ( .A(N131), .B(cycle11_HSS_TXD[3]), .Z(N575) );
  GTECH_AND2 C842 ( .A(N577), .B(cycle11_HSS_TXD[4]), .Z(N578) );
  GTECH_AND2 C843 ( .A(N131), .B(N4), .Z(N577) );
  GTECH_AND2 C844 ( .A(N581), .B(N7), .Z(N582) );
  GTECH_AND2 C845 ( .A(N580), .B(N4), .Z(N581) );
  GTECH_AND2 C846 ( .A(N130), .B(N13), .Z(N580) );
  GTECH_AND2 C847 ( .A(N585), .B(N7), .Z(N586) );
  GTECH_AND2 C848 ( .A(N584), .B(N4), .Z(N585) );
  GTECH_AND2 C849 ( .A(N132), .B(cycle11_HSS_TXD[2]), .Z(N584) );
  GTECH_AND2 C850 ( .A(N132), .B(N13), .Z(N588) );
  GTECH_AND2 C851 ( .A(N591), .B(N7), .Z(N592) );
  GTECH_AND2 C852 ( .A(N590), .B(N4), .Z(N591) );
  GTECH_AND2 C853 ( .A(N19), .B(N10), .Z(N590) );
  GTECH_AND2 C854 ( .A(cycle11_HSS_TXD[1]), .B(cycle11_HSS_TXD[3]), .Z(N133)
         );
  GTECH_AND2 C855 ( .A(N133), .B(cycle11_HSS_TXD[5]), .Z(N134) );
  GTECH_AND2 C859 ( .A(N133), .B(N10), .Z(N135) );
  GTECH_AND2 C860 ( .A(N135), .B(N13), .Z(N136) );
  GTECH_AND2 C863 ( .A(cycle11_HSS_TXD[1]), .B(N4), .Z(N137) );
  GTECH_AND2 C864 ( .A(N137), .B(N10), .Z(N138) );
  GTECH_AND2 C866 ( .A(N19), .B(cycle11_HSS_TXD[3]), .Z(N139) );
  GTECH_AND2 C867 ( .A(N593), .B(N13), .Z(N140) );
  GTECH_AND2 C868 ( .A(N139), .B(cycle11_HSS_TXD[5]), .Z(N593) );
  GTECH_AND2 C869 ( .A(N139), .B(N10), .Z(N141) );
  GTECH_AND2 C870 ( .A(N19), .B(N4), .Z(N142) );
  GTECH_AND2 C871 ( .A(N142), .B(cycle11_HSS_TXD[5]), .Z(N143) );
  GTECH_AND2 C872 ( .A(N143), .B(cycle11_HSS_TXD[2]), .Z(N144) );
  GTECH_AND2 C873 ( .A(N143), .B(N13), .Z(N145) );
  GTECH_AND2 C874 ( .A(N142), .B(N10), .Z(N146) );
  GTECH_OR2 C875 ( .A(N643), .B(N646), .Z(TXDATA[0]) );
  GTECH_OR2 C876 ( .A(N640), .B(N642), .Z(N643) );
  GTECH_OR2 C877 ( .A(N637), .B(N639), .Z(N640) );
  GTECH_OR2 C878 ( .A(N635), .B(N636), .Z(N637) );
  GTECH_OR2 C879 ( .A(N633), .B(N634), .Z(N635) );
  GTECH_OR2 C880 ( .A(N630), .B(N632), .Z(N633) );
  GTECH_OR2 C881 ( .A(N626), .B(N629), .Z(N630) );
  GTECH_OR2 C882 ( .A(N623), .B(N625), .Z(N626) );
  GTECH_OR2 C883 ( .A(N621), .B(N622), .Z(N623) );
  GTECH_OR2 C884 ( .A(N618), .B(N620), .Z(N621) );
  GTECH_OR2 C885 ( .A(N614), .B(N617), .Z(N618) );
  GTECH_OR2 C886 ( .A(N611), .B(N613), .Z(N614) );
  GTECH_OR2 C887 ( .A(N607), .B(N610), .Z(N611) );
  GTECH_OR2 C888 ( .A(N605), .B(N606), .Z(N607) );
  GTECH_OR2 C889 ( .A(N602), .B(N604), .Z(N605) );
  GTECH_OR2 C890 ( .A(N599), .B(N601), .Z(N602) );
  GTECH_OR2 C891 ( .A(N595), .B(N598), .Z(N599) );
  GTECH_AND2 C892 ( .A(N594), .B(N17), .Z(N595) );
  GTECH_AND2 C893 ( .A(N134), .B(cycle11_HSS_TXD[2]), .Z(N594) );
  GTECH_AND2 C894 ( .A(N597), .B(N17), .Z(N598) );
  GTECH_AND2 C895 ( .A(N596), .B(cycle11_HSS_TXD[4]), .Z(N597) );
  GTECH_AND2 C896 ( .A(N134), .B(N13), .Z(N596) );
  GTECH_AND2 C897 ( .A(N600), .B(cycle11_HSS_TXD[0]), .Z(N601) );
  GTECH_AND2 C898 ( .A(N135), .B(cycle11_HSS_TXD[2]), .Z(N600) );
  GTECH_AND2 C899 ( .A(N603), .B(cycle11_HSS_TXD[0]), .Z(N604) );
  GTECH_AND2 C900 ( .A(N136), .B(cycle11_HSS_TXD[4]), .Z(N603) );
  GTECH_AND2 C901 ( .A(N136), .B(N7), .Z(N606) );
  GTECH_AND2 C902 ( .A(N609), .B(N7), .Z(N610) );
  GTECH_AND2 C903 ( .A(N608), .B(N13), .Z(N609) );
  GTECH_AND2 C904 ( .A(N137), .B(cycle11_HSS_TXD[5]), .Z(N608) );
  GTECH_AND2 C905 ( .A(N612), .B(cycle11_HSS_TXD[0]), .Z(N613) );
  GTECH_AND2 C906 ( .A(N138), .B(cycle11_HSS_TXD[2]), .Z(N612) );
  GTECH_AND2 C907 ( .A(N616), .B(cycle11_HSS_TXD[0]), .Z(N617) );
  GTECH_AND2 C908 ( .A(N615), .B(cycle11_HSS_TXD[4]), .Z(N616) );
  GTECH_AND2 C909 ( .A(N138), .B(N13), .Z(N615) );
  GTECH_AND2 C910 ( .A(N619), .B(N17), .Z(N620) );
  GTECH_AND2 C911 ( .A(N140), .B(cycle11_HSS_TXD[4]), .Z(N619) );
  GTECH_AND2 C912 ( .A(N140), .B(N7), .Z(N622) );
  GTECH_AND2 C913 ( .A(N624), .B(cycle11_HSS_TXD[0]), .Z(N625) );
  GTECH_AND2 C914 ( .A(N141), .B(cycle11_HSS_TXD[2]), .Z(N624) );
  GTECH_AND2 C915 ( .A(N628), .B(cycle11_HSS_TXD[0]), .Z(N629) );
  GTECH_AND2 C916 ( .A(N627), .B(cycle11_HSS_TXD[4]), .Z(N628) );
  GTECH_AND2 C917 ( .A(N141), .B(N13), .Z(N627) );
  GTECH_AND2 C918 ( .A(N631), .B(cycle11_HSS_TXD[0]), .Z(N632) );
  GTECH_AND2 C919 ( .A(N144), .B(cycle11_HSS_TXD[4]), .Z(N631) );
  GTECH_AND2 C920 ( .A(N144), .B(N7), .Z(N634) );
  GTECH_AND2 C921 ( .A(N145), .B(cycle11_HSS_TXD[4]), .Z(N636) );
  GTECH_AND2 C922 ( .A(N638), .B(N17), .Z(N639) );
  GTECH_AND2 C923 ( .A(N145), .B(N7), .Z(N638) );
  GTECH_AND2 C924 ( .A(N641), .B(cycle11_HSS_TXD[0]), .Z(N642) );
  GTECH_AND2 C925 ( .A(N146), .B(cycle11_HSS_TXD[2]), .Z(N641) );
  GTECH_AND2 C926 ( .A(N645), .B(cycle11_HSS_TXD[0]), .Z(N646) );
  GTECH_AND2 C927 ( .A(N644), .B(cycle11_HSS_TXD[4]), .Z(N645) );
  GTECH_AND2 C928 ( .A(N146), .B(N13), .Z(N644) );
  GTECH_AND2 C929 ( .A(cycle11_HSS_TXD[7]), .B(cycle11_HSS_TXD[5]), .Z(N147)
         );
  GTECH_AND2 C930 ( .A(N147), .B(cycle11_HSS_TXD[8]), .Z(N148) );
  GTECH_AND2 C931 ( .A(N148), .B(cycle11_HSS_TXD[9]), .Z(N149) );
  GTECH_AND2 C935 ( .A(N149), .B(N3), .Z(N150) );
  GTECH_AND2 C943 ( .A(N21), .B(N10), .Z(N151) );
  GTECH_AND2 C944 ( .A(N151), .B(N2), .Z(N152) );
  GTECH_AND2 C945 ( .A(N152), .B(N28), .Z(N153) );
  GTECH_AND2 C946 ( .A(N153), .B(cycle11_HSS_TXD[6]), .Z(N154) );
  GTECH_OR2 C947 ( .A(N710), .B(N716), .Z(TXDATAK) );
  GTECH_OR2 C948 ( .A(N704), .B(N709), .Z(N710) );
  GTECH_OR2 C949 ( .A(N702), .B(N703), .Z(N704) );
  GTECH_OR2 C950 ( .A(N695), .B(N701), .Z(N702) );
  GTECH_OR2 C951 ( .A(N688), .B(N694), .Z(N695) );
  GTECH_OR2 C952 ( .A(N681), .B(N687), .Z(N688) );
  GTECH_OR2 C953 ( .A(N674), .B(N680), .Z(N681) );
  GTECH_OR2 C954 ( .A(N667), .B(N673), .Z(N674) );
  GTECH_OR2 C955 ( .A(N660), .B(N666), .Z(N667) );
  GTECH_OR2 C956 ( .A(N658), .B(N659), .Z(N660) );
  GTECH_OR2 C957 ( .A(N652), .B(N657), .Z(N658) );
  GTECH_AND2 C958 ( .A(N651), .B(cycle11_HSS_TXD[2]), .Z(N652) );
  GTECH_AND2 C959 ( .A(N650), .B(N17), .Z(N651) );
  GTECH_AND2 C960 ( .A(N649), .B(cycle11_HSS_TXD[3]), .Z(N650) );
  GTECH_AND2 C961 ( .A(N648), .B(N19), .Z(N649) );
  GTECH_AND2 C962 ( .A(N647), .B(cycle11_HSS_TXD[4]), .Z(N648) );
  GTECH_AND2 C963 ( .A(N149), .B(cycle11_HSS_TXD[6]), .Z(N647) );
  GTECH_AND2 C964 ( .A(N656), .B(cycle11_HSS_TXD[2]), .Z(N657) );
  GTECH_AND2 C965 ( .A(N655), .B(N17), .Z(N656) );
  GTECH_AND2 C966 ( .A(N654), .B(cycle11_HSS_TXD[3]), .Z(N655) );
  GTECH_AND2 C967 ( .A(N653), .B(N19), .Z(N654) );
  GTECH_AND2 C968 ( .A(N150), .B(cycle11_HSS_TXD[4]), .Z(N653) );
  GTECH_AND2 C969 ( .A(N150), .B(N7), .Z(N659) );
  GTECH_AND2 C970 ( .A(N665), .B(cycle11_HSS_TXD[2]), .Z(N666) );
  GTECH_AND2 C971 ( .A(N664), .B(N17), .Z(N665) );
  GTECH_AND2 C972 ( .A(N663), .B(cycle11_HSS_TXD[3]), .Z(N664) );
  GTECH_AND2 C973 ( .A(N662), .B(N19), .Z(N663) );
  GTECH_AND2 C974 ( .A(N661), .B(cycle11_HSS_TXD[4]), .Z(N662) );
  GTECH_AND2 C975 ( .A(N148), .B(N28), .Z(N661) );
  GTECH_AND2 C976 ( .A(N672), .B(cycle11_HSS_TXD[2]), .Z(N673) );
  GTECH_AND2 C977 ( .A(N671), .B(N17), .Z(N672) );
  GTECH_AND2 C978 ( .A(N670), .B(cycle11_HSS_TXD[3]), .Z(N671) );
  GTECH_AND2 C979 ( .A(N669), .B(N19), .Z(N670) );
  GTECH_AND2 C980 ( .A(N668), .B(cycle11_HSS_TXD[4]), .Z(N669) );
  GTECH_AND2 C981 ( .A(N147), .B(N2), .Z(N668) );
  GTECH_AND2 C982 ( .A(N679), .B(N13), .Z(N680) );
  GTECH_AND2 C983 ( .A(N678), .B(cycle11_HSS_TXD[0]), .Z(N679) );
  GTECH_AND2 C984 ( .A(N677), .B(N4), .Z(N678) );
  GTECH_AND2 C985 ( .A(N676), .B(cycle11_HSS_TXD[1]), .Z(N677) );
  GTECH_AND2 C986 ( .A(N675), .B(N7), .Z(N676) );
  GTECH_AND2 C987 ( .A(cycle11_HSS_TXD[7]), .B(N10), .Z(N675) );
  GTECH_AND2 C988 ( .A(N686), .B(cycle11_HSS_TXD[2]), .Z(N687) );
  GTECH_AND2 C989 ( .A(N685), .B(N17), .Z(N686) );
  GTECH_AND2 C990 ( .A(N684), .B(cycle11_HSS_TXD[3]), .Z(N685) );
  GTECH_AND2 C991 ( .A(N683), .B(N19), .Z(N684) );
  GTECH_AND2 C992 ( .A(N682), .B(cycle11_HSS_TXD[4]), .Z(N683) );
  GTECH_AND2 C993 ( .A(N21), .B(cycle11_HSS_TXD[5]), .Z(N682) );
  GTECH_AND2 C994 ( .A(N693), .B(N13), .Z(N694) );
  GTECH_AND2 C995 ( .A(N692), .B(cycle11_HSS_TXD[0]), .Z(N693) );
  GTECH_AND2 C996 ( .A(N691), .B(N4), .Z(N692) );
  GTECH_AND2 C997 ( .A(N690), .B(cycle11_HSS_TXD[1]), .Z(N691) );
  GTECH_AND2 C998 ( .A(N689), .B(N7), .Z(N690) );
  GTECH_AND2 C999 ( .A(N151), .B(cycle11_HSS_TXD[8]), .Z(N689) );
  GTECH_AND2 C1000 ( .A(N700), .B(N13), .Z(N701) );
  GTECH_AND2 C1001 ( .A(N699), .B(cycle11_HSS_TXD[0]), .Z(N700) );
  GTECH_AND2 C1002 ( .A(N698), .B(N4), .Z(N699) );
  GTECH_AND2 C1003 ( .A(N697), .B(cycle11_HSS_TXD[1]), .Z(N698) );
  GTECH_AND2 C1004 ( .A(N696), .B(N7), .Z(N697) );
  GTECH_AND2 C1005 ( .A(N152), .B(cycle11_HSS_TXD[9]), .Z(N696) );
  GTECH_AND2 C1006 ( .A(N154), .B(cycle11_HSS_TXD[4]), .Z(N703) );
  GTECH_AND2 C1007 ( .A(N708), .B(N13), .Z(N709) );
  GTECH_AND2 C1008 ( .A(N707), .B(cycle11_HSS_TXD[0]), .Z(N708) );
  GTECH_AND2 C1009 ( .A(N706), .B(N4), .Z(N707) );
  GTECH_AND2 C1010 ( .A(N705), .B(cycle11_HSS_TXD[1]), .Z(N706) );
  GTECH_AND2 C1011 ( .A(N154), .B(N7), .Z(N705) );
  GTECH_AND2 C1012 ( .A(N715), .B(N13), .Z(N716) );
  GTECH_AND2 C1013 ( .A(N714), .B(cycle11_HSS_TXD[0]), .Z(N715) );
  GTECH_AND2 C1014 ( .A(N713), .B(N4), .Z(N714) );
  GTECH_AND2 C1015 ( .A(N712), .B(cycle11_HSS_TXD[1]), .Z(N713) );
  GTECH_AND2 C1016 ( .A(N711), .B(N7), .Z(N712) );
  GTECH_AND2 C1017 ( .A(N153), .B(N3), .Z(N711) );
  GTECH_NOT I_10 ( .A(cycle11_HSS_TXELECIDLE), .Z(CNTL_TXEnable_P0) );
endmodule

