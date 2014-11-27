

module XGXSSYNTH_DEC_8B10B (
  clk,
  decode_data_in,
  disp_in,
  rst,
  code_bad,
  code_viol,
  decode_data_out,
  disp_out,
  disp_out_early,
  konstant_rx
);

   input        clk;
   input        disp_in;
   input  [9:0] decode_data_in;
   input        rst;
   output       code_bad;
   output       code_viol;
   output       disp_out;
   output       disp_out_early;
   output [7:0] decode_data_out;
   output       konstant_rx;
   wire         a56;
   wire         b56;
   wire         bad_char;
   wire         c56;
   wire         code_0f1_or_30e;
   wire         code_bad;
   wire         code_bad_int;
   wire         code_viol;
   wire         d56;
   wire   [9:0] data_des;
   wire         dd1_0_0;
   wire         dd1_0_3;
   wire         dd2_0_0;
   wire         dd2_0_7;
   wire         dd3_0_3;
   wire         dd3_1_0;
   wire         dd3_1_7;
   wire         dd3_2_0;
   wire         dd3_2_3;
   wire         dd5_4_0;
   wire         dd5_4_1;
   wire         dd5_4_2;
   wire         dd5_4_3;
   wire         dd6_4_0;
   wire         dd7_6_0;
   wire         dd7_6_3;
   wire         dd8_7_0;
   wire         dd8_7_3;
   wire         dd9_6_0;
   wire         dd9_6_12;
   wire         dd9_6_15;
   wire         dd9_6_3;
   wire   [7:0] decode_data_out;
   wire         disp_out;
   wire         disp_out_early;
   reg          disp_lat;
   wire         disp_lat_in;
   wire         dvil_4b;
   wire         dvil_6b;
   wire         e56;
   wire         e_eq_i;
   wire         f56;
   wire         fe;
   wire         four_bit_reset;
   wire         four_bit_set;
   wire         g56;
   wire         ge;
   wire         h56;
   wire         he;
   wire         i34_all;
   wire         i56;
   wire         i689;
   wire         i789;
   wire         in689;
   wire         in789;
   wire   [4:0] int_net;
   wire         inv_a;
   wire         inv_all;
   wire         inv_b;
   wire         inv_c;
   wire         inv_d;
   wire         inv_e;
   wire         inv_f;
   wire         inv_g;
   wire         inv_h;
   wire         inval_4b;
   wire         inval_6b;
   wire         j56;
   wire         konstant_rx;
   wire         l56;
   wire         n34;
   wire         n34a;
   wire         n56;
   wire         n56a;
   wire         new_disp;
   wire         p13;
   wire         p22;
   wire         p31;
   wire         p34;
   wire         p34a;
   wire         p56;
   wire         p56a;
   wire         six_bit_reset;
   wire         six_bit_set;
   wire         t1;
   wire         t2;
   wire         x104;
   wire         x14;
   wire         x16;
   wire         x24;
   wire         x26;
   wire         x34;
   wire         x36;
   wire         x44;
   wire         x54;
   wire         x64;
   wire         x74;
   wire         x84;
   wire         x94;
   wire         xor_89;

   assign data_des[0] = decode_data_in[9] ;
   assign data_des[1] = decode_data_in[8] ;
   assign data_des[2] = decode_data_in[7] ;
   assign data_des[3] = decode_data_in[6] ;
   assign data_des[4] = decode_data_in[5] ;
   assign data_des[5] = decode_data_in[4] ;
   assign data_des[6] = decode_data_in[3] ;
   assign data_des[7] = decode_data_in[2] ;
   assign data_des[8] = decode_data_in[1] ;
   assign data_des[9] = decode_data_in[0] ;
   assign dd9_6_12 = (data_des[9:6] == 4'b1100) ? 1'b1 : 1'b0 ;
   assign dd9_6_3 = (data_des[9:6] == 4'b0011) ? 1'b1 : 1'b0 ;
   assign p13 = ((data_des[9] ^ data_des[8]) &
                 (~data_des[7] & ~data_des[6])) |
                ((data_des[7] ^ data_des[6]) &
                 (~data_des[9] & ~data_des[8])) ;
   assign p31 = ((data_des[9] ^ data_des[8]) &
                 (data_des[7] & data_des[6])) |
                ((data_des[7] ^ data_des[6]) &
                (data_des[9] & data_des[8])) ;
   assign p22 = (dd9_6_12 | dd9_6_3 |
                ((data_des[9] ^ data_des[8]) &
                 (data_des[7] ^ data_des[6]))) ;
   assign t1 = (data_des[7:4] == 4'b0000) ? 1'b1 : 1'b0 ;
   assign t2 = (data_des[7:4] == 4'b1111) ? 1'b1 : 1'b0 ;
   assign dd5_4_1 = (data_des[5:4] == 2'b01) ? 1'b1 : 1'b0 ;
   assign dd5_4_2 = (data_des[5:4] == 2'b10) ? 1'b1 : 1'b0 ;
   assign dd2_0_7 = (data_des[2:0] == 3'b111) ? 1'b1 : 1'b0 ;
   assign dd2_0_0 = (data_des[2:0] == 3'b000) ? 1'b1 : 1'b0 ;
   assign konstant_rx = t1 | t2 | (p13 & dd5_4_1 & dd2_0_7) |
                                  (p31 & dd5_4_2 & dd2_0_0) ;
   assign dd5_4_0 = (data_des[5:4] == 2'b00) ? 1'b1 : 1'b0 ;
   assign dd5_4_3 = (data_des[5:4] == 2'b11) ? 1'b1 : 1'b0 ;
   assign dd8_7_3 = (data_des[8:7] == 2'b11) ? 1'b1 : 1'b0 ;
   assign dd8_7_0 = (data_des[8:7] == 2'b00) ? 1'b1 : 1'b0 ;
   assign e_eq_i = dd5_4_0 | dd5_4_3 ;
   assign a56 = p22 & dd8_7_3 & e_eq_i ;
   assign b56 = p22 & dd8_7_0 & e_eq_i ;
   assign c56 = p13 & ~data_des[4] ;
   assign d56 = p31 & data_des[4] ;
   assign e56 = p56a ;
   assign f56 = p22 & data_des[9] & data_des[7] & e_eq_i ;
   assign g56 = p22 & ~data_des[9] & ~data_des[7] & e_eq_i ;
   assign h56 = p13 & ~data_des[5] ;
   assign i56 = ~data_des[9] & ~data_des[8] & ~data_des[5] & ~data_des[4] ;
   assign j56 = data_des[9] & data_des[8] & data_des[5] & data_des[4] ;
   assign l56 = t1 ;
   assign inv_all = e56 | h56 | l56 ;
   assign inv_a = inv_all | b56 | d56 | g56 | j56 ;
   assign inv_b = inv_all | a56 | d56 | f56 | j56 ;
   assign inv_c = inv_all | a56 | d56 | g56 | i56 ;
   assign inv_d = inv_all | b56 | d56 | f56 | j56 ;
   assign inv_e = inv_all | b56 | c56 | g56 | i56 ;
   assign int_net[4] = data_des[9] ^ inv_a ;
   assign int_net[3] = data_des[8] ^ inv_b ;
   assign int_net[2] = data_des[7] ^ inv_c ;
   assign int_net[1] = data_des[6] ^ inv_d ;
   assign int_net[0] = data_des[5] ^ inv_e ;
   assign dd3_0_3 = (data_des[3:0] == 4'b0011) ? 1'b1 : 1'b0 ;
   assign dd3_2_3 = (data_des[3:2] == 2'b11) ? 1'b1 : 1'b0 ;
   assign dd3_1_0 = (data_des[3:1] == 3'b000) ? 1'b1 : 1'b0 ;
   assign dd1_0_3 = (data_des[1:0] == 2'b11) ? 1'b1 : 1'b0 ;
   assign dd1_0_0 = (data_des[1:0] == 2'b00) ? 1'b1 : 1'b0 ;
   assign xor_89 = data_des[1] ^ data_des[0] ;
   assign i34_all = (t1 & xor_89) | dd3_0_3 |
                    (dd3_2_3 & data_des[0]) | dd3_1_0 ;
   assign i689 = (dd1_0_3 & data_des[3]) ;
   assign i789 = (data_des[2:0] == 3'b111) ? 1'b1 : 1'b0 ;
   assign in689 = (dd1_0_0 & ~data_des[3]) ;
   assign in789 = (data_des[2:0] == 3'b000) ? 1'b1 : 1'b0 ;
   assign inv_f = i34_all | i689 | i789 ;
   assign inv_g = i34_all | in789 | in689 ;
   assign inv_h = i34_all | i689 | in789 ;
   assign fe = inv_f ^ data_des[3] ;
   assign ge = inv_g ^ data_des[2] ;
   assign he = inv_h ^ data_des[1] ;
   assign decode_data_out[7:0] = {he, ge, fe, int_net[0], int_net[1],
                                  int_net[2], int_net[3], int_net[4]} ;
   assign dd9_6_0 = (data_des[9:6] == 4'b0000) ? 1'b1 : 1'b0 ;
   assign dd9_6_15 = (data_des[9:6] == 4'b1111) ? 1'b1 : 1'b0 ;
   assign dd7_6_0 = (data_des[7:6] == 2'b00) ? 1'b1 : 1'b0 ;
   assign dd7_6_3 = (data_des[7:6] == 2'b11) ? 1'b1 : 1'b0 ;
   assign dd3_1_7 = (data_des[3:1] == 3'b111) ? 1'b1 : 1'b0 ;
   assign x16 = dd9_6_0 | dd9_6_15 ;
   assign x26 = (p13 & dd5_4_0) ;
   assign x36 = (p31 & dd5_4_3) ;
   assign inval_6b = x16 | x26 | x36 ;
   assign x14 = (~data_des[5] & data_des[4] & dd2_0_0) ;
   assign x24 = (~data_des[0] & dd3_1_0) ;
   assign x34 = (dd3_1_0 & dd5_4_0) ;
   assign x44 = dd5_4_3 & dd2_0_0 & ~dd7_6_3 ;
   assign x54 = (~p31 & (dd5_4_2 & dd2_0_0)) ;
   assign x64 = (data_des[5] & ~data_des[4] & dd2_0_7) ;
   assign x74 = (data_des[0] & dd3_1_7) ;
   assign x84 = dd5_4_0 & dd2_0_7 & ~dd7_6_0 ;
   assign x94 = (dd3_1_7 & dd5_4_3) ;
   assign x104 = (~p13 & (dd5_4_1 & dd2_0_7)) ;
   assign inval_4b = x14 | x24 | x34 | x44 | x54 |
                     x64 | x74 | x84 | x94 | x104 ;
   assign bad_char = inval_4b | inval_6b ;
   assign p56 = (p31 & data_des[5]) | (p31 & data_des[4]) |
                (p22 & data_des[5] & data_des[4]) ;
   assign n56 = (p13 & ~data_des[5]) | (p13 & ~data_des[4]) |
                (p22 & ~data_des[5] & ~data_des[4]) ;
   assign p56a = (data_des[9:4] == 6'b000111) ? 1'b1 : 1'b0 ;
   assign dd6_4_0 = (data_des[6:4] == 3'b000) ? 1'b1 : 1'b0 ;
   assign dd3_2_0 = (data_des[3:2] == 2'b00) ? 1'b1 : 1'b0 ;
   assign n56a = (p31 & dd6_4_0) ;
   assign p34 = dd2_0_7 | (dd3_2_3 & data_des[0]) |
                dd3_1_7 | (dd1_0_3 & data_des[3]) ;
   assign n34 = dd2_0_0 | (dd3_2_0 & ~data_des[0]) |
                dd3_1_0 | (dd1_0_0 & ~data_des[3]) ;
   assign p34a = (data_des[3:0] == 4'b0011) ? 1'b1 : 1'b0 ;
   assign n34a = (data_des[3:0] == 4'b1100) ? 1'b1 : 1'b0 ;
   assign dvil_6b = (n56a & disp_in) | (disp_in & p56) |
                    (n56 & ~disp_in) | (p56a & ~disp_in) ;
   assign dvil_4b = (p56 & p34) | (n56 & n34) | (n34 & ~p56 & ~disp_in) |
                    (~p56 & ~disp_in & p34a) | (p34a & n56) |
                    (disp_in & p34 & ~n56) | (disp_in & ~n56 & n34a) |
                    (n34a & p56) ;
   assign six_bit_set = data_des[9:4] == 6'b000111 |
                        data_des[9:4] == 6'b001111 |
                        data_des[9:4] == 6'b010111 |
                        data_des[9:4] == 6'b011011 |
                        data_des[9:4] == 6'b011101 |
                        data_des[9:4] == 6'b011110 |
                        data_des[9:4] == 6'b011111 |
                        data_des[9:4] == 6'b100111 |
                        data_des[9:4] == 6'b101011 |
                        data_des[9:4] == 6'b101101 |
                        data_des[9:4] == 6'b101110 |
                        data_des[9:4] == 6'b101111 |
                        data_des[9:4] == 6'b110011 |
                        data_des[9:4] == 6'b110101 |
                        data_des[9:4] == 6'b110110 |
                        data_des[9:4] == 6'b110111 |
                        data_des[9:4] == 6'b111001 |
                        data_des[9:4] == 6'b111010 |
                        data_des[9:4] == 6'b111011 |
                        data_des[9:4] == 6'b111100 |
                        data_des[9:4] == 6'b111101 |
                        data_des[9:4] == 6'b111110 |
                        data_des[9:4] == 6'b111111 ? 1'b1 : 1'b0;
   assign six_bit_reset = data_des[9:4] == 6'b000000 |
                          data_des[9:4] == 6'b000001 |
                          data_des[9:4] == 6'b000010 |
                          data_des[9:4] == 6'b000011 |
                          data_des[9:4] == 6'b000100 |
                          data_des[9:4] == 6'b000101 |
                          data_des[9:4] == 6'b000110 |
                          data_des[9:4] == 6'b001000 |
                          data_des[9:4] == 6'b001001 |
                          data_des[9:4] == 6'b001010 |
                          data_des[9:4] == 6'b001100 |
                          data_des[9:4] == 6'b010000 |
                          data_des[9:4] == 6'b010001 |
                          data_des[9:4] == 6'b010010 |
                          data_des[9:4] == 6'b010100 |
                          data_des[9:4] == 6'b011000 |
                          data_des[9:4] == 6'b100000 |
                          data_des[9:4] == 6'b100001 |
                          data_des[9:4] == 6'b100010 |
                          data_des[9:4] == 6'b100100 |
                          data_des[9:4] == 6'b101000 |
                          data_des[9:4] == 6'b110000 |
                          data_des[9:4] == 6'b111000 ? 1'b1 : 1'b0;
   assign four_bit_set = data_des[3:0] == 4'b0011 |
                         data_des[3:0] == 4'b0111 |
                         data_des[3:0] == 4'b1011 |
                         data_des[3:0] == 4'b1101 |
                         data_des[3:0] == 4'b1110 |
                         data_des[3:0] == 4'b1111 ? 1'b1 : 1'b0;
   assign four_bit_reset = data_des[3:0] == 4'b0000 |
                           data_des[3:0] == 4'b0001 |
                           data_des[3:0] == 4'b0010 |
                           data_des[3:0] == 4'b0100 |
                           data_des[3:0] == 4'b1000 |
                           data_des[3:0] == 4'b1100 ? 1'b1 : 1'b0;
   assign new_disp = (four_bit_set == 1'b1)            ? 1'b1 :
                     (four_bit_reset == 1'b1)          ? 1'b0 :
                     (six_bit_set == 1'b1)             ? 1'b1 :
                     (six_bit_reset == 1'b1)           ? 1'b0 :
                                                     disp_in ;
   assign disp_lat_in = (rst == 1'b1) ? 1'b0 : new_disp ;
   assign code_0f1_or_30e = ((data_des == 10'b0011110001) |
                             (data_des == 10'b1100001110)) ? 1'b1 : 1'b0 ;
   assign code_bad_int = bad_char | dvil_4b | dvil_6b | code_0f1_or_30e ;
   assign code_bad = code_bad_int ;
   assign code_viol = (rst == 1'b1) ? 1'b0 : code_bad_int ;

   assign disp_out = disp_lat;
   assign disp_out_early = disp_lat_in;

   always @(posedge clk)
   begin : b_disp
      disp_lat <= disp_lat_in ;
   end
endmodule
