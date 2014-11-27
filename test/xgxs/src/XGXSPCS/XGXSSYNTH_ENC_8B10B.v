
`timescale 1ns/10ps

module XGXSSYNTH_ENC_8B10B (bad_code,
                      bad_disp,
                      clk,
                      encode_data_in,
                      konstant,
                      rst,
                      disp_out,
                      encode_data_out,
		      assertion_shengyushen
                     );


  input         bad_code;
  input         bad_disp;
  input         clk;
  input  [7:0]  encode_data_in;
  input         konstant;
  input         rst;
  output        disp_out;
  output [9:0]  encode_data_out;
  wire          alt_7;
  wire   [9:0]  data_out;
  reg    [5:0]  data_out_latch;
  reg           disp_lat;
  wire          disp_lat_fix;
  reg           disp_lat_fix_latch;
  wire          disp_lat_in;
  wire          disp_out_w;
  wire          do5_4_0;
  wire          do5_4_3;
  wire   [9:0]  encode_data_out_w;
  wire          f_disp;
  wire          i_disp;
  reg           i_disp_latch;
  wire   [3:0]  ins;
  wire   [5:0]  int;
  wire          invert34;
  wire          invert56;
  wire   [7:0]  ip_data;
  reg    [2:0]  ip_data_latch;
  wire          ipd2_0_0;
  wire          ipd2_0_0_2nd;
  wire          ipd2_0_1;
  wire          ipd2_0_7;
  wire          ipd5_4_0;
  wire          ipd7_3_0;
  wire          ipd7_3_15;
  wire          ipd7_3_16;
  wire          ipd7_3_1;
  wire          ipd7_3_23;
  wire          ipd7_3_27;
  wire          ipd7_3_29;
  wire          ipd7_3_2;
  wire          ipd7_3_30;
  wire          ipd7_3_31;
  wire          ipd7_3_3;
  wire          ipd7_3_4;
  wire          ipd7_3_5;
  wire          ipd7_3_6;
  wire          ipd7_3_7;
  wire          ipd7_3_8;
  wire          ipd7_4_0;
  wire          ipd7_4_15;
  wire          ipd7_4_1;
  wire          ipd7_4_2;
  wire          ipd7_4_4;
  wire          ipd7_4_8;
  wire          ipd7_6_3;
  reg           konstant_latch;
  wire          kx;
  reg           kx_latch;
  wire          kz;
  wire          kz_1;
  wire          kz_2;
  wire          kz_3;
  wire          kz_4;
  wire          minus34a;
  wire          minus34b;
  reg           minus34b_latch;
  wire          minus56a;
  wire          minus56b;
  wire          plus34;
  reg           plus34_latch;
  wire          plus34k;
  wire          plus56;
  wire          s;
  wire   [5:0]  t1;
  wire   [3:0]  t2;
  wire          y;
  output          assertion_shengyushen;
  assign          assertion_shengyushen=(bad_disp==1'b0) && (bad_code==1'b0) && (konstant==1'b0 || (konstant==1'b1 && (encode_data_in==8'h1c ||encode_data_in==8'h7c ||encode_data_in==8'hbc ) ));

   assign ip_data[0] = encode_data_in[7] ;
   assign ip_data[1] = encode_data_in[6] ;
   assign ip_data[2] = encode_data_in[5] ;
   assign ip_data[3] = encode_data_in[4] ;
   assign ip_data[4] = encode_data_in[3] ;
   assign ip_data[5] = encode_data_in[2] ;
   assign ip_data[6] = encode_data_in[1] ;
   assign ip_data[7] = encode_data_in[0] ;
   assign kx = (ip_data[7:3] == 5'b00111) ? 1'b1 : 1'b0 ;
   assign kz_1 = (ip_data[7:3] == 5'b11101) ? 1'b1 : 1'b0 ;
   assign kz_2 = (ip_data[7:3] == 5'b11011) ? 1'b1 : 1'b0 ;
   assign kz_3 = (ip_data[7:3] == 5'b10111) ? 1'b1 : 1'b0 ;
   assign kz_4 = (ip_data[7:3] == 5'b01111) ? 1'b1 : 1'b0 ;
   assign kz = kz_1 | kz_2 | kz_3 | kz_4 ;
   assign y = kx | kz ;
   assign ipd7_4_15 = (ip_data[7:4] == 4'b1111) ? 1'b1 : 1'b0 ;
   assign ipd7_4_0 = (ip_data[7:4] == 4'b0000) ? 1'b1 : 1'b0 ;
   assign ipd7_4_1 = (ip_data[7:4] == 4'b0001) ? 1'b1 : 1'b0 ;
   assign ipd7_4_8 = (ip_data[7:4] == 4'b1000) ? 1'b1 : 1'b0 ;
   assign ipd7_4_4 = (ip_data[7:4] == 4'b0100) ? 1'b1 : 1'b0 ;
   assign ipd7_4_2 = (ip_data[7:4] == 4'b0010) ? 1'b1 : 1'b0 ;
   assign ipd7_3_3 = (ip_data[7:3] == 5'b00011) ? 1'b1 : 1'b0 ;
   assign ipd7_6_3 = (ip_data[7:6] == 2'b11) ? 1'b1 : 1'b0 ;
   assign ipd5_4_0 = (ip_data[5:4] == 2'b00) ? 1'b1 : 1'b0 ;
   assign ipd7_3_6 = (ip_data[7:3] == 5'b00110) ? 1'b1 : 1'b0 ;
   assign ipd7_3_5 = (ip_data[7:3] == 5'b00101) ? 1'b1 : 1'b0 ;
   assign ipd7_3_31 = (ip_data[7:3] == 5'b11111) ? 1'b1 : 1'b0 ;
   assign ipd7_3_7 = (ip_data[7:3] == 5'b00111) ? 1'b1 : 1'b0 ;
   assign int[5] = ip_data[7] ;
   assign int[4] = (ip_data[6] & ~ipd7_4_15) | ipd7_4_0 ;
   assign int[3] = ip_data[5] | ipd7_4_0 | ipd7_3_3 ;
   assign int[2] = ip_data[4] & ~ipd7_4_15 ;
   assign int[1] = (ip_data[3] ^ ipd7_4_1) | (ipd7_4_8 | ipd7_4_4 | ipd7_4_2) ;
   assign int[0] = (ipd5_4_0 & (ip_data[3] ^ ipd7_6_3)) |
                   ((ip_data[7] ^ ip_data[6]) &
                    (ip_data[5] ^ ip_data[4]) & (~ip_data[3])) |
                   (ipd7_3_6) | (ipd7_3_5) |
                   (ipd7_3_31) | (ipd7_3_7 & konstant) ;
   assign ipd7_3_0 = (ip_data[7:3] == 5'b00000) ? 1'b1 : 1'b0 ;
   assign ipd7_3_16 = (ip_data[7:3] == 5'b10000) ? 1'b1 : 1'b0 ;
   assign ipd7_3_8 = (ip_data[7:3] == 5'b01000) ? 1'b1 : 1'b0 ;
   assign ipd7_3_4 = (ip_data[7:3] == 5'b00100) ? 1'b1 : 1'b0 ;
   assign ipd7_3_2 = (ip_data[7:3] == 5'b00010) ? 1'b1 : 1'b0 ;
   assign ipd7_3_30 = (ip_data[7:3] == 5'b11110) ? 1'b1 : 1'b0 ;
   assign plus56 = ipd7_3_0 | ipd7_3_16 | ipd7_3_8 | ipd7_3_4 |
                   ipd7_3_2 | ipd7_3_30 | ipd7_3_3 ;
   assign minus56a = (ip_data[7:3] == 5'b11100) ? 1'b1 : 1'b0 ;
   assign ipd7_3_1 = (ip_data[7:3] == 5'b00001) ? 1'b1 : 1'b0 ;
   assign ipd7_3_29 = (ip_data[7:3] == 5'b11101) ? 1'b1 : 1'b0 ;
   assign ipd7_3_27 = (ip_data[7:3] == 5'b11011) ? 1'b1 : 1'b0 ;
   assign ipd7_3_23 = (ip_data[7:3] == 5'b10111) ? 1'b1 : 1'b0 ;
   assign ipd7_3_15 = (ip_data[7:3] == 5'b01111) ? 1'b1 : 1'b0 ;
   assign minus56b = ipd7_3_1 | ipd7_3_29 | ipd7_3_27 | ipd7_3_23 |
                     ipd7_3_15 | ipd7_3_31 | (ipd7_3_7 & konstant) ;
   assign invert56 = ((~disp_lat_fix) & plus56) |
                     (disp_lat_fix & (minus56a | minus56b)) | (~y & konstant) ;
   assign i_disp = disp_lat_fix ^ (plus56 | minus56b) ;
   assign ipd2_0_0 = (ip_data[2:0] == 3'b000) ? 1'b1 : 1'b0 ;
   assign ipd2_0_1 = (ip_data[2:0] == 3'b001) ? 1'b1 : 1'b0 ;
   assign plus34 = ipd2_0_0 | ipd2_0_1 ;
   assign minus34b = (ip_data[2:0] == 3'b111) ? 1'b1 : 1'b0 ;
   assign f_disp = i_disp ^ (plus34 | minus34b) ;
   assign disp_lat_fix = (bad_disp == 1'b0) ? disp_lat : ~(disp_lat) ;
   assign disp_lat_in = (rst == 1'b1) ? 1'b0 : f_disp ;
   assign t1[5:0] = {invert56, invert56, invert56,
                     invert56, invert56, invert56} ;
   assign data_out[9:4] = int[5:0] ^ t1 ;

   assign disp_out_w = disp_lat_fix_latch ;
   assign disp_out=disp_out_w;
   assign do5_4_0 = (data_out_latch[1:0] == 2'b00) ? 1'b1 : 1'b0 ;
   assign do5_4_3 = (data_out_latch[1:0] == 2'b11) ? 1'b1 : 1'b0 ;
   assign ipd2_0_0_2nd = (ip_data_latch[2:0] == 3'b000) ? 1'b1 : 1'b0 ;
   assign ipd2_0_7 = (ip_data_latch[2:0] == 3'b111) ? 1'b1 : 1'b0 ;
   assign s = (i_disp_latch & do5_4_0) | (~i_disp_latch & do5_4_3) |
              konstant_latch ;
   assign alt_7 = s & ipd2_0_7 ;
   assign ins[3] = ip_data_latch[2] & ~alt_7 ;
   assign ins[2] = ip_data_latch[1] | ipd2_0_0_2nd ;
   assign ins[1] = ip_data_latch[0] ;
   assign ins[0] = ((ip_data_latch[2] ^ ip_data_latch[1]) & ~ip_data_latch[0]) |
                   alt_7 ;
   assign plus34k = kx_latch & konstant_latch &
                    (ip_data_latch[2] ^ ip_data_latch[1]) ;
   assign minus34a = (ip_data_latch[2:0] == 3'b110) ? 1'b1 : 1'b0 ;
   assign invert34 = ((~i_disp_latch) & (plus34_latch | plus34k)) |
                     (i_disp_latch & (minus34a | minus34b_latch)) ;
   assign t2[3:0] = {invert34, invert34, invert34, invert34} ;
   assign data_out[3:0] = ins[3:0] ^ t2 ;
   assign encode_data_out_w[9] = data_out[0] & ~bad_code ;
   assign encode_data_out_w[8] = data_out[1] & ~bad_code ;
   assign encode_data_out_w[7] = data_out[2] | bad_code ;
   assign encode_data_out_w[6] = data_out[3] & ~bad_code ;
   assign encode_data_out_w[5] = data_out_latch[0] | bad_code ;
   assign encode_data_out_w[4] = data_out_latch[1] | bad_code ;
   assign encode_data_out_w[3] = data_out_latch[2] | bad_code ;
   assign encode_data_out_w[2] = data_out_latch[3] | bad_code ;
   assign encode_data_out_w[1] = data_out_latch[4] & ~bad_code ;
   assign encode_data_out_w[0] = data_out_latch[5] | bad_code ;

   assign encode_data_out=encode_data_out_w;

   always @(posedge clk)
   begin : b_disp
      disp_lat <= disp_lat_in ;
   end

   always @(posedge clk)
   begin : latches
      konstant_latch <= konstant ;
      ip_data_latch <= ip_data[2:0] ;
      disp_lat_fix_latch <= disp_lat_fix ;
      data_out_latch <= data_out[9:4] ;
      kx_latch <= kx ;
      plus34_latch <= plus34 ;
      minus34b_latch <= minus34b ;
      i_disp_latch <= i_disp ;
   end

endmodule
