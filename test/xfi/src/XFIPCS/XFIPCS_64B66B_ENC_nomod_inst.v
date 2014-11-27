
`timescale 1ns/10ps

module XFIPCS_64B66B_ENC (
                      CLK,
                      RESET,
                      DATA_VALID,
                      ENCODER_DATA_IN,
                      ENCODER_CONTROL_IN,
                      TEST_PAT_SEED_A,
                      TEST_PAT_SEED_B,
                      TEST_MODE,
                      DATA_PAT_SEL,
                      ENCODER_DATA_OUT,
		      assertion_shengyushen
                     );

  input CLK;
  input RESET;
  input DATA_VALID;
  input [63:0] ENCODER_DATA_IN;
  input [57:0] TEST_PAT_SEED_A;
  input [57:0] TEST_PAT_SEED_B;
  input TEST_MODE;
  input DATA_PAT_SEL;
  input [7:0] ENCODER_CONTROL_IN;

  output [65:0] ENCODER_DATA_OUT;
  wire [65:0] ENCODER_DATA_OUT;
  output assertion_shengyushen;

  wire reset;
  wire [63:0] encoder_data_in;
  wire [7:0] encoder_control_in;
  wire [65:0] encoder_data_out;

  assign reset = RESET;
  assign ENCODER_DATA_OUT = encoder_data_out;

  wire [1:0] sync_header;
  wire       data_pat_sel_msh;
  wire [35:0] data_pat;
  wire        test_mode;
  wire        test_mode_msh;


XFIPCS_ASYNC_DRS async000(
                        .clk         (CLK                  ),
                        .data_in     (DATA_PAT_SEL         ),
                        .data_out    (data_pat_sel_msh     )
                );

XFIPCS_ASYNC_DRS async001(
                        .clk         (CLK                  ),
                        .data_in     (TEST_MODE            ),
                        .data_out    (test_mode_msh        )
                );

assign encoder_data_in = ENCODER_DATA_IN;
assign encoder_control_in = ENCODER_CONTROL_IN;

assign sync_header = ~test_mode_msh && encoder_control_in == 8'h00 ? 2'b10 :
                                                                     2'b01 ;

  wire term0;
  wire term1;
  wire term2;
  wire term3;
  wire term4;
  wire term5;
  wire term6;
  wire term7;
  wire data0;
  wire data1;
  wire data2;
  wire data3;
  wire data4;
  wire data5;
  wire data6;
  wire data7;
  wire cntl0;
  wire cntl1;
  wire cntl2;
  wire cntl3;
  wire cntl4;
  wire cntl5;
  wire cntl6;
  wire cntl7;
  wire ord0;
  wire ord4;
  wire [3:0] order0;
  wire [3:0] order4;
  wire start0;
  wire start4;
  wire [7:0] byte0;
  wire [7:0] byte1;
  wire [7:0] byte2;
  wire [7:0] byte3;
  wire [7:0] byte4;
  wire [7:0] byte5;
  wire [7:0] byte6;
  wire [7:0] byte7;
  wire [6:0] byte0c;
  wire [6:0] byte1c;
  wire [6:0] byte2c;
  wire [6:0] byte3c;
  wire [6:0] byte4c;
  wire [6:0] byte5c;
  wire [6:0] byte6c;
  wire [6:0] byte7c;
  wire [7:0] cntl_error;
  wire invalid_block;

  wire [8:0] test_counter_in;
  reg  [8:0] test_counter;

  assign byte0 =  encoder_data_in[7 :0 ] ;
  assign byte1 =  encoder_data_in[15:8 ] ;
  assign byte2 =  encoder_data_in[23:16] ;
  assign byte3 =  encoder_data_in[31:24] ;
  assign byte4 =  encoder_data_in[39:32] ;
  assign byte5 =  encoder_data_in[47:40] ;
  assign byte6 =  encoder_data_in[55:48] ;
  assign byte7 =  encoder_data_in[63:56] ;

  parameter TERM    = 8'hfd;
  parameter START   = 8'hfb;
  parameter ORDER   = 8'h9c;
  parameter ERROR   = 8'hfe;
  parameter IDLE    = 8'h07;
  parameter FSIG    = 8'h5c;
  parameter IDLE_R  = 8'h1c;
  parameter CODE_3C = 8'h3c;
  parameter IDLE_A  = 8'h7c;
  parameter IDLE_K  = 8'hbc;
  parameter CODE_DC = 8'hdc;
  parameter CODE_F7 = 8'hf7;

  assign data0 = !encoder_control_in[0] ;
  assign data1 = !encoder_control_in[1] ;
  assign data2 = !encoder_control_in[2] ;
  assign data3 = !encoder_control_in[3] ;
  assign data4 = !encoder_control_in[4] ;
  assign data5 = !encoder_control_in[5] ;
  assign data6 = !encoder_control_in[6] ;
  assign data7 = !encoder_control_in[7] ;
  assign cntl_error[0] = byte0 != TERM    && byte0 != FSIG    &&
                         byte0 != START   && byte0 != ORDER   &&
                         byte0 != IDLE    && byte0 != IDLE_A  &&
                         byte0 != IDLE_R  && byte0 != IDLE_K  &&
                         byte0 != CODE_3C && byte0 != CODE_DC &&
                         byte0 != CODE_F7 && byte0 != ERROR      ? 1'b1 : 1'b0;
  assign cntl_error[1] = byte1 != TERM    &&
                         byte1 != IDLE    && byte1 != IDLE_A  &&
                         byte1 != IDLE_R  && byte1 != IDLE_K  &&
                         byte1 != CODE_3C && byte1 != CODE_DC &&
                         byte1 != CODE_F7 && byte1 != ERROR      ? 1'b1 : 1'b0;
  assign cntl_error[2] = byte2 != TERM    &&
                         byte2 != IDLE    && byte2 != IDLE_A  &&
                         byte2 != IDLE_R  && byte2 != IDLE_K  &&
                         byte2 != CODE_3C && byte2 != CODE_DC &&
                         byte2 != CODE_F7 && byte2 != ERROR      ? 1'b1 : 1'b0;
  assign cntl_error[3] = byte3 != TERM    &&
                         byte3 != IDLE    && byte3 != IDLE_A  &&
                         byte3 != IDLE_R  && byte3 != IDLE_K  &&
                         byte3 != CODE_3C && byte3 != CODE_DC &&
                         byte3 != CODE_F7 && byte3 != ERROR      ? 1'b1 : 1'b0;
  assign cntl_error[4] = byte4 != TERM    && byte4 != FSIG    &&
                         byte4 != START   && byte4 != ORDER   &&
                         byte4 != IDLE    && byte4 != IDLE_A  &&
                         byte4 != IDLE_R  && byte4 != IDLE_K  &&
                         byte4 != CODE_3C && byte4 != CODE_DC &&
                         byte4 != CODE_F7 && byte4 != ERROR      ? 1'b1 : 1'b0;
  assign cntl_error[5] = byte5 != TERM    &&
                         byte5 != IDLE    && byte5 != IDLE_A  &&
                         byte5 != IDLE_R  && byte5 != IDLE_K  &&
                         byte5 != CODE_3C && byte5 != CODE_DC &&
                         byte5 != CODE_F7 && byte5 != ERROR      ? 1'b1 : 1'b0;
  assign cntl_error[6] = byte6 != TERM    &&
                         byte6 != IDLE    && byte6 != IDLE_A  &&
                         byte6 != IDLE_R  && byte6 != IDLE_K  &&
                         byte6 != CODE_3C && byte6 != CODE_DC &&
                         byte6 != CODE_F7 && byte6 != ERROR      ? 1'b1 : 1'b0;
  assign cntl_error[7] = byte7 != TERM    &&
                         byte7 != IDLE    && byte7 != IDLE_A  &&
                         byte7 != IDLE_R  && byte7 != IDLE_K  &&
                         byte7 != CODE_3C && byte7 != CODE_DC &&
                         byte7 != CODE_F7 && byte7 != ERROR      ? 1'b1 : 1'b0;
  assign invalid_block = |(cntl_error & encoder_control_in);
  assign byte0c = encoder_control_in[0] == 1'b0                       ? 7'h00 :
                  byte0 == IDLE                                       ? 7'h00 :
                  byte0 == IDLE_A                                     ? 7'h4b :
                  byte0 == IDLE_K                                     ? 7'h55 :
                  byte0 == IDLE_R                                     ? 7'h2d :
                  byte0 == CODE_3C                                    ? 7'h33 :
                  byte0 == CODE_DC                                    ? 7'h66 :
                  byte0 == CODE_F7                                    ? 7'h78 :
                  byte0 == ERROR                                      ? 7'h1e :
                                                                        7'h1e ;
  assign byte1c = encoder_control_in[1] == 1'b0                       ? 7'h00 :
                  byte1 == IDLE                                       ? 7'h00 :
                  byte1 == IDLE_A                                     ? 7'h4b :
                  byte1 == IDLE_K                                     ? 7'h55 :
                  byte1 == IDLE_R                                     ? 7'h2d :
                  byte1 == CODE_3C                                    ? 7'h33 :
                  byte1 == CODE_DC                                    ? 7'h66 :
                  byte1 == CODE_F7                                    ? 7'h78 :
                  byte1 == ERROR                                      ? 7'h1e :
                                                                        7'h1e ;
  assign byte2c = encoder_control_in[2] == 1'b0                       ? 7'h00 :
                  byte2 == IDLE                                       ? 7'h00 :
                  byte2 == IDLE_A                                     ? 7'h4b :
                  byte2 == IDLE_K                                     ? 7'h55 :
                  byte2 == IDLE_R                                     ? 7'h2d :
                  byte2 == CODE_3C                                    ? 7'h33 :
                  byte2 == CODE_DC                                    ? 7'h66 :
                  byte2 == CODE_F7                                    ? 7'h78 :
                  byte2 == ERROR                                      ? 7'h1e :
                                                                        7'h1e ;
  assign byte3c = encoder_control_in[3] == 1'b0                       ? 7'h00 :
                  byte3 == IDLE                                       ? 7'h00 :
                  byte3 == IDLE_A                                     ? 7'h4b :
                  byte3 == IDLE_K                                     ? 7'h55 :
                  byte3 == IDLE_R                                     ? 7'h2d :
                  byte3 == CODE_3C                                    ? 7'h33 :
                  byte3 == CODE_DC                                    ? 7'h66 :
                  byte3 == CODE_F7                                    ? 7'h78 :
                  byte3 == ERROR                                      ? 7'h1e :
                                                                        7'h1e ;
  assign byte4c = encoder_control_in[4] == 1'b0                       ? 7'h00 :
                  byte4 == IDLE                                       ? 7'h00 :
                  byte4 == IDLE_A                                     ? 7'h4b :
                  byte4 == IDLE_K                                     ? 7'h55 :
                  byte4 == IDLE_R                                     ? 7'h2d :
                  byte4 == CODE_3C                                    ? 7'h33 :
                  byte4 == CODE_DC                                    ? 7'h66 :
                  byte4 == CODE_F7                                    ? 7'h78 :
                  byte4 == ERROR                                      ? 7'h1e :
                                                                        7'h1e ;
  assign byte5c = encoder_control_in[5] == 1'b0                       ? 7'h00 :
                  byte5 == IDLE                                       ? 7'h00 :
                  byte5 == IDLE_A                                     ? 7'h4b :
                  byte5 == IDLE_K                                     ? 7'h55 :
                  byte5 == IDLE_R                                     ? 7'h2d :
                  byte5 == CODE_3C                                    ? 7'h33 :
                  byte5 == CODE_DC                                    ? 7'h66 :
                  byte5 == CODE_F7                                    ? 7'h78 :
                  byte5 == ERROR                                      ? 7'h1e :
                                                                        7'h1e ;
  assign byte6c = encoder_control_in[6] == 1'b0                       ? 7'h00 :
                  byte6 == IDLE                                       ? 7'h00 :
                  byte6 == IDLE_A                                     ? 7'h4b :
                  byte6 == IDLE_K                                     ? 7'h55 :
                  byte6 == IDLE_R                                     ? 7'h2d :
                  byte6 == CODE_3C                                    ? 7'h33 :
                  byte6 == CODE_DC                                    ? 7'h66 :
                  byte6 == CODE_F7                                    ? 7'h78 :
                  byte6 == ERROR                                      ? 7'h1e :
                                                                        7'h1e ;
  assign byte7c = encoder_control_in[7] == 1'b0                       ? 7'h00 :
                  byte7 == IDLE                                       ? 7'h00 :
                  byte7 == IDLE_A                                     ? 7'h4b :
                  byte7 == IDLE_K                                     ? 7'h55 :
                  byte7 == IDLE_R                                     ? 7'h2d :
                  byte7 == CODE_3C                                    ? 7'h33 :
                  byte7 == CODE_DC                                    ? 7'h66 :
                  byte7 == CODE_F7                                    ? 7'h78 :
                  byte7 == ERROR                                      ? 7'h1e :
                                                                        7'h1e ;

  assign term0 = encoder_control_in[0] == 1'b1 && byte0 == TERM   ? 1'b1 : 1'b0 ;
  assign term1 = encoder_control_in[1] == 1'b1 && byte1 == TERM   ? 1'b1 : 1'b0 ;
  assign term2 = encoder_control_in[2] == 1'b1 && byte2 == TERM   ? 1'b1 : 1'b0 ;
  assign term3 = encoder_control_in[3] == 1'b1 && byte3 == TERM   ? 1'b1 : 1'b0 ;
  assign term4 = encoder_control_in[4] == 1'b1 && byte4 == TERM   ? 1'b1 : 1'b0 ;
  assign term5 = encoder_control_in[5] == 1'b1 && byte5 == TERM   ? 1'b1 : 1'b0 ;
  assign term6 = encoder_control_in[6] == 1'b1 && byte6 == TERM   ? 1'b1 : 1'b0 ;
  assign term7 = encoder_control_in[7] == 1'b1 && byte7 == TERM   ? 1'b1 : 1'b0 ;
  assign ord0 = encoder_control_in[0] == 1'b1 &&
                  ( byte0 == ORDER || byte0 == FSIG)              ? 1'b1 : 1'b0 ;
  assign order0 = encoder_control_in[0] == 1'b1 && byte0 == FSIG  ? 4'hf : 4'h0 ;
  assign ord4 = encoder_control_in[4] == 1'b1 &&
                  ( byte4 == ORDER || byte4 == FSIG)              ? 1'b1 : 1'b0 ;
  assign order4 = encoder_control_in[4] == 1'b1 && byte4 == FSIG  ? 4'hf : 4'h0 ;
  assign start0 = encoder_control_in[0] == 1'b1 && byte0 == START ? 1'b1 : 1'b0 ;
  assign start4 = encoder_control_in[4] == 1'b1 && byte4 == START ? 1'b1 : 1'b0 ;
  assign cntl0 = encoder_control_in[0] == 1'b1 &&
                 ( byte0 == IDLE    || byte0 == IDLE_A  ||
                   byte0 == IDLE_R  || byte0 == IDLE_K  ||
                   byte0 == CODE_3C || byte0 == CODE_DC ||
                   byte0 == CODE_F7 || byte0 == ERROR )         ? 1'b1 : 1'b0 ;
  assign cntl1 = encoder_control_in[1] == 1'b1 &&
                 ( byte1 == IDLE    || byte1 == IDLE_A  ||
                   byte1 == IDLE_R  || byte1 == IDLE_K  ||
                   byte1 == CODE_3C || byte1 == CODE_DC ||
                   byte1 == CODE_F7 || byte1 == ERROR )         ? 1'b1 : 1'b0 ;
  assign cntl2 = encoder_control_in[2] == 1'b1 &&
                 ( byte2 == IDLE    || byte2 == IDLE_A  ||
                   byte2 == IDLE_R  || byte2 == IDLE_K  ||
                   byte2 == CODE_3C || byte2 == CODE_DC ||
                   byte2 == CODE_F7 || byte2 == ERROR )         ? 1'b1 : 1'b0 ;
  assign cntl3 = encoder_control_in[3] == 1'b1 &&
                 ( byte3 == IDLE    || byte3 == IDLE_A  ||
                   byte3 == IDLE_R  || byte3 == IDLE_K  ||
                   byte3 == CODE_3C || byte3 == CODE_DC ||
                   byte3 == CODE_F7 || byte3 == ERROR )         ? 1'b1 : 1'b0 ;
  assign cntl4 = encoder_control_in[4] == 1'b1 &&
                 ( byte4 == IDLE    || byte4 == IDLE_A  ||
                   byte4 == IDLE_R  || byte4 == IDLE_K  ||
                   byte4 == CODE_3C || byte4 == CODE_DC ||
                   byte4 == CODE_F7 || byte4 == ERROR )         ? 1'b1 : 1'b0 ;
  assign cntl5 = encoder_control_in[5] == 1'b1 &&
                 ( byte5 == IDLE    || byte5 == IDLE_A  ||
                   byte5 == IDLE_R  || byte5 == IDLE_K  ||
                   byte5 == CODE_3C || byte5 == CODE_DC ||
                   byte5 == CODE_F7 || byte5 == ERROR )         ? 1'b1 : 1'b0 ;
  assign cntl6 = encoder_control_in[6] == 1'b1 &&
                 ( byte6 == IDLE    || byte6 == IDLE_A  ||
                   byte6 == IDLE_R  || byte6 == IDLE_K  ||
                   byte6 == CODE_3C || byte6 == CODE_DC ||
                   byte6 == CODE_F7 || byte6 == ERROR )         ? 1'b1 : 1'b0 ;
  assign cntl7 = encoder_control_in[7] == 1'b1 &&
                 ( byte7 == IDLE    || byte7 == IDLE_A  ||
                   byte7 == IDLE_R  || byte7 == IDLE_K  ||
                   byte7 == CODE_3C || byte7 == CODE_DC ||
                   byte7 == CODE_F7 || byte7 == ERROR )         ? 1'b1 : 1'b0 ;

  wire [14:0] block_field_onehot;

  assign block_field_onehot =
            invalid_block                                          ? 15'h0000 :
          ( cntl0 && cntl1 && cntl2 && cntl3 &&
            cntl4 && cntl5 && cntl6 && cntl7 )                     ? 15'h0001 :
          ( cntl0 && cntl1 && cntl2 && cntl3 &&
            ord4 && data5 && data6 && data7 )                      ? 15'h0002 :
          ( cntl0 && cntl1 && cntl2 && cntl3 &&
            start4 && data5 && data6 && data7 )                    ? 15'h0004 :
          ( ord0 && data1 && data2 && data3 &&
            start4 && data5 && data6 && data7 )                    ? 15'h0008 :
          ( ord0 && data1 && data2 && data3 &&
            ord4 && data5 && data6 && data7 )                      ? 15'h0010 :
          ( start0 && data1 && data2 && data3 &&
            data4 && data5 && data6 && data7 )                     ? 15'h0020 :
          ( ord0 && data1 && data2 && data3 &&
            cntl4 && cntl5 && cntl6 && cntl7 )                     ? 15'h0040 :
          ( term0 && cntl1 && cntl2 && cntl3 &&
            cntl4 && cntl5 && cntl6 && cntl7 )                     ? 15'h0080 :
          ( data0 && term1 && cntl2 && cntl3 &&
            cntl4 && cntl5 && cntl6 && cntl7 )                     ? 15'h0100 :
          ( data0 && data1 && term2 && cntl3 &&
            cntl4 && cntl5 && cntl6 && cntl7 )                     ? 15'h0200 :
          ( data0 && data1 && data2 && term3 &&
            cntl4 && cntl5 && cntl6 && cntl7 )                     ? 15'h0400 :
          ( data0 && data1 && data2 && data3 &&
            term4 && cntl5 && cntl6 && cntl7 )                     ? 15'h0800 :
          ( data0 && data1 && data2 && data3 &&
            data4 && term5 && cntl6 && cntl7 )                     ? 15'h1000 :
          ( data0 && data1 && data2 && data3 &&
            data4 && data5 && term6 && cntl7 )                     ? 15'h2000 :
          ( data0 && data1 && data2 && data3 &&
            data4 && data5 && data6 && term7 )                     ? 15'h4000 :
                                                                     15'h0000 ;

  reg [65:0] data_66b;

  always @(sync_header or block_field_onehot or byte0 or byte1 or byte2 or
                          byte3 or byte4 or byte5 or byte6 or byte7 or
                          order0 or order4 or byte0c or byte1c or byte2c or
                          byte3c or byte4c or byte5c or byte6c or byte7c)
  begin
    if (sync_header == 2'b10)
      data_66b = {byte7, byte6, byte5, byte4,
                  byte3, byte2, byte1, byte0, 2'b10} ;
    else
      case (block_field_onehot)
        15'h0001 : data_66b = {byte7c, byte6c, byte5c, byte4c, byte3c,
                               byte2c, byte1c, byte0c, 10'h079} ;
        15'h0002 : data_66b = {byte7,  byte6,  byte5,  order4, byte3c,
                               byte2c, byte1c, byte0c, 10'h0b5} ;
        15'h0004 : data_66b = {byte7,  byte6,  byte5,  4'h0,   byte3c,
                               byte2c, byte1c, byte0c, 10'h0cd} ;
        15'h0008 : data_66b = {byte7,  byte6,  byte5,  4'h0,   order0,
                               byte3,  byte2,  byte1,  10'h199} ;
        15'h0010 : data_66b = {byte7,  byte6,  byte5,  order4, order0,
                               byte3,  byte2,  byte1,  10'h155} ;
        15'h0020 : data_66b = {        byte7,  byte6,  byte5,  byte4,
                               byte3,  byte2,  byte1,  10'h1e1} ;
        15'h0040 : data_66b = {byte7c, byte6c, byte5c, byte4c, order0,
                               byte3,  byte2,  byte1,  10'h12d} ;
        15'h0080 : data_66b = {byte7c, byte6c, byte5c, byte4c, byte3c,
                               byte2c, byte1c, 7'h00,  10'h21d} ;
        15'h0100 : data_66b = {byte7c, byte6c, byte5c, byte4c, byte3c,
                               byte2c, 6'h00,  byte0,  10'h265} ;
        15'h0200 : data_66b = {byte7c, byte6c, byte5c, byte4c, byte3c,
                               5'h00,  byte1,  byte0,  10'h2a9} ;
        15'h0400 : data_66b = {byte7c, byte6c, byte5c, byte4c, 4'h0,
                               byte2,  byte1,  byte0,  10'h2d1} ;
        15'h0800 : data_66b = {byte7c, byte6c, byte5c, 3'h0,   byte3,
                               byte2,  byte1,  byte0,  10'h331} ;
        15'h1000 : data_66b = {byte7c, byte6c, 2'h0,   byte4,  byte3,
                               byte2,  byte1,  byte0,  10'h349} ;
        15'h2000 : data_66b = {byte7c, 1'h0,   byte5,  byte4,  byte3,
                               byte2,  byte1,  byte0,  10'h385} ;
        15'h4000 : data_66b = {        byte6,  byte5,  byte4,  byte3,
                               byte2,  byte1,  byte0,  10'h3fd} ;
        default  : data_66b = 66'h0f1e3c78f1e3c7879; 
      endcase
  end

  reg [57:0] data_prev;
  wire [57:0] data_prev_in;
  wire [38:0] data_scrambled_38_0;
  wire [18:0] data_scrambled_57_39;
  wire [5:0] data_scrambled_63_58;
  wire [63:0] data_scrambled;

  wire [65:0] data_66b_tpg;

  assign data_66b_tpg = ~test_mode_msh                             ? data_66b :
                 data_pat_sel_msh && ~test_counter[7] ? 66'h00000000000000001 :
                 data_pat_sel_msh                     ? 66'h3fffffffffffffffd :
                                     ~test_counter[7] ? 66'h00400000004000155 :
                                                        66'h3fbfffffffbfffea9 ;

  assign data_scrambled_38_0  = data_66b_tpg[40:2]  ^ data_prev[57:19]           ^ data_prev[38:0]            ;
  assign data_scrambled_57_39 = data_66b_tpg[59:41] ^ data_scrambled_38_0[18:0]  ^ data_prev[57:39]           ;
  assign data_scrambled_63_58 = data_66b_tpg[65:60] ^ data_scrambled_38_0[24:19] ^ data_scrambled_38_0[5:0]   ;
  assign data_scrambled = {data_scrambled_63_58, data_scrambled_57_39, data_scrambled_38_0};
  assign data_prev_in = ~DATA_VALID                               ? data_prev :
                        ~test_mode_msh                 ? data_scrambled[63:6] :
                        test_counter == 9'h000              ? TEST_PAT_SEED_A :
                        test_counter == 9'h080             ? ~TEST_PAT_SEED_A :
                        test_counter == 9'h100              ? TEST_PAT_SEED_B :
                        test_counter == 9'h180             ? ~TEST_PAT_SEED_B :
                                                         data_scrambled[63:6] ;

  assign test_counter_in = reset || ~test_mode_msh                   ? 9'h000 :
                           ~DATA_VALID                         ? test_counter :
                                                             test_counter + 1 ;

  always @(posedge CLK)
    begin
      test_counter <= test_counter_in;
      if (reset == 1'b1)
        data_prev <= 58'h0;
      else
        data_prev <= data_prev_in ;
    end

  assign encoder_data_out = {data_scrambled, sync_header};
  
  wire assertion_valid_indata= (|block_field_onehot) || ENCODER_CONTROL_IN==8'h00;
  wire          assertion_shengyushen=(assertion_valid_indata==1'b1 && TEST_MODE==1'b0 && RESET==1'b0 && DATA_VALID==1'b1);

endmodule
