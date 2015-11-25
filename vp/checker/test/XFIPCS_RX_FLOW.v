//SCCS File Version= %I% 
//Release Date= 14/04/20  19:56:49 GMT startFileName /vobs/vob012/xfipcs/verilog/rtl/XFIPCS_RX_FLOW.v endFileName  

// --------------------------------------------------------------------
// IBM Confidential                                                    
// --------------------------------------------------------------------
// (C) Copyright IBM Corporation 2014                                  
//                                                                     
// Use of this design is restricted by terms and conditions specified  
// in the Design Kit License Agreement and the IBM customer            
// contract. Unauthorized use of this design is prohibited. Customer   
// is responsible to ensure this design is functional in the target    
// application. IBM and its agents are not responsible for operability 
// or support of this design if modifications are made to this code.   
//                                                                     
// Contact your IBM Field Application Engineer (FAE) for any updates   
// for this core.                                                      
// --------------------------------------------------------------------

//$Id:
//$Log:
//
//-----------------------------------------------------------------------------
// Copyright IBM Corporation 2001-2005
// IBM Confidential
//-----------------------------------------------------------------------------

`include "XFIPCS.defines.v"
`timescale 1ns/10ps

module `XFIPCS_TOPLEVELNAME_RX_FLOW (
                        pma_rx_clk,
                        reset_to_pma_rx,

                        block_type_field,
                        decoder_control_out,
                        decoder_data_out,
                        data_valid,
                        r_test_mode,
                        hi_ber,
                        block_lock,
                        rx_sync_header,
                        rx_lpi_active,

                        data_valid_3,
                        inc_ebc,
                        rx_local_fault,
                        rxc_xfi,
                        rxd_xfi,
                        r_type_li,
                        r_type_idle,
                        pcs_r_status
                );

// ----------------------------------------------------------------------------
// Inputs/Outputs
// ----------------------------------------------------------------------------
input                   pma_rx_clk;
input                   reset_to_pma_rx;

input   [7:0]           block_type_field;
input   [7:0]           decoder_control_out;
input   [63:0]          decoder_data_out;
input                   data_valid;
input                   r_test_mode;
input                   hi_ber;
input                   block_lock;
input   [1:0]           rx_sync_header;
input                   rx_lpi_active;

output                  inc_ebc;
output  [7:0]           rxc_xfi;
output  [63:0]          rxd_xfi;
output                  rx_local_fault;
output                  data_valid_3;
output                  r_type_li;
output                  r_type_idle;
output                  pcs_r_status;

// ----------------------------------------------------------------------------
// Internal signals/registers
// ----------------------------------------------------------------------------
wire                    inc_ebc;
wire    [7:0]           rxc_xfi;
reg     [7:0]           control_prev;
wire    [7:0]           control_prev_in;
wire    [63:0]          rxd_xfi;
reg     [63:0]          data_prev;
wire    [63:0]          data_prev_in;
reg     [4:0]           r_type;
wire    [4:0]           r_type_nxt;
wire    [4:0]           r_type_with_nulls;
wire    [4:0]           r_type_with_nulls_next;
wire    [1:0]           rx_raw;
wire                    rx_local_fault;
reg     [63:0]          data_save;
reg     [7:0]           control_save;
reg                     data_valid_2;
reg                     data_valid_3;
reg                     data_valid_4;

wire                    lpi7;
wire                    lpi6;
wire                    lpi5;
wire                    lpi4;
wire                    lpi3;
wire                    lpi2;
wire                    lpi1;
wire                    lpi0;

wire                    rx_lpi_active;
wire    [7:0]           lpi_7_0;
reg                     r_type_li;
wire                    r_type_li_nxt;
reg                     r_type_idle;
wire                    r_type_idle_nxt;

// ----------------------------------------------------------------------------
// Parameters
// ----------------------------------------------------------------------------
parameter RX_INIT     = 5'b00000;
parameter RX_C        = 5'b10001;
parameter RX_S        = 5'b10010;
parameter RX_D        = 5'b00011;
parameter RX_T        = 5'b10100;
parameter RX_E        = 5'b00101;
parameter RX_I        = 5'b00110;
parameter RX_N        = 5'b10111;
parameter RX_LI       = 5'b11000;

parameter LBLOCK_R    = 2'b01;
parameter DECODE      = 2'b00;
parameter EBLOCK_R    = 2'b10;
parameter LI          = 2'b11;

// ----------------------------------------------------------------------------
// Implementation
// ----------------------------------------------------------------------------

 assign r_type_li_nxt   = (r_type_nxt == RX_LI);
 assign r_type_idle_nxt = (r_type_nxt == RX_I);

 `XFIPCS_TOPLEVELNAME_RX_FSM rx_fsm(
  .clk               (pma_rx_clk             ),
  .reset             (reset_to_pma_rx        ),
  .r_test_mode       (r_test_mode            ),
  .hi_ber            (hi_ber                 ),
  .block_lock        (block_lock             ),
  .r_type            (r_type_with_nulls      ),
  .r_type_next       (r_type_with_nulls_next ),
  .rx_lpi_active     (rx_lpi_active          ),
  .inc_ebc           (inc_ebc                ),
  .rx_raw            (rx_raw                 ),
  .pcs_r_status      (pcs_r_status           )
 );

 assign data_prev_in = data_valid_2 ? decoder_data_out : data_prev ;
 assign control_prev_in = data_valid_2 ? decoder_control_out : control_prev ;

 always @(posedge pma_rx_clk)
   begin
     data_prev <= data_prev_in;
     control_prev <= control_prev_in;
     r_type <= r_type_nxt;
     data_save <= data_prev;
     control_save <= control_prev;
     data_valid_2 <= data_valid ;
     data_valid_3 <= data_valid_2;
     data_valid_4 <= data_valid_3;
     r_type_li    <= r_type_li_nxt;
     r_type_idle  <= r_type_idle_nxt;
   end

 assign lpi7 = (block_type_field == 8'h1e) & (decoder_data_out[63:56] == 8'h06);
 assign lpi6 = (block_type_field == 8'h1e) & (decoder_data_out[55:48] == 8'h06);
 assign lpi5 = (block_type_field == 8'h1e) & (decoder_data_out[47:40] == 8'h06);
 assign lpi4 = (block_type_field == 8'h1e) & (decoder_data_out[39:32] == 8'h06);
 assign lpi3 = (block_type_field == 8'h1e) & (decoder_data_out[31:24] == 8'h06);
 assign lpi2 = (block_type_field == 8'h1e) & (decoder_data_out[23:16] == 8'h06);
 assign lpi1 = (block_type_field == 8'h1e) & (decoder_data_out[15: 8] == 8'h06);
 assign lpi0 = (block_type_field == 8'h1e) & (decoder_data_out[ 7: 0] == 8'h06);

 assign lpi_7_0 = {lpi7,lpi6,lpi5,lpi4,lpi3,lpi2,lpi1,lpi0};

 // RX_I is really just a type of RX_C. Since the RX_FSM doesn't care about RX_I's
 // we'll translate RX_I's to RX_C's.
 assign r_type_with_nulls      = (data_valid_2 == 1'b0) ? RX_N :
                                 (r_type == RX_I)       ? RX_C : r_type;
 assign r_type_with_nulls_next = (data_valid_2 == 1'b0) ? RX_N :
                                 (r_type_nxt == RX_I)  ? RX_C : r_type_nxt;

 assign r_type_nxt = rx_sync_header == 2'b01 &&
                      (block_type_field == 8'h1e &&
                        (decoder_data_out[63:56] == 8'h07 &&
                         decoder_data_out[55:48] == 8'h07 &&
                         decoder_data_out[47:40] == 8'h07 &&
                         decoder_data_out[39:32] == 8'h07 &&
                         decoder_data_out[31:24] == 8'h07 &&
                         decoder_data_out[23:16] == 8'h07 &&
                         decoder_data_out[15: 8] == 8'h07 &&
                         decoder_data_out[ 7: 0] == 8'h07))            ? RX_I :
                      rx_sync_header == 2'b01 &&
                      (block_type_field == 8'h1e &&
                        (decoder_data_out[63:56] == 8'h06 &&
                         decoder_data_out[55:48] == 8'h06 &&
                         decoder_data_out[47:40] == 8'h06 &&
                         decoder_data_out[39:32] == 8'h06 &&
                         decoder_data_out[31:24] == 8'h06 &&
                         decoder_data_out[23:16] == 8'h06 &&
                         decoder_data_out[15: 8] == 8'h06 &&
                         decoder_data_out[ 7: 0] == 8'h06))            ? RX_LI :
                      rx_sync_header == 2'b01 &&
                      ((block_type_field == 8'h1e &&
                        (decoder_data_out[63:56] != 8'hfe &&
                         decoder_data_out[55:48] != 8'hfe &&
                         decoder_data_out[47:40] != 8'hfe &&
                         decoder_data_out[39:32] != 8'hfe &&
                         decoder_data_out[31:24] != 8'hfe &&
                         decoder_data_out[23:16] != 8'hfe &&
                         decoder_data_out[15: 8] != 8'hfe &&
                         decoder_data_out[ 7: 0] != 8'hfe &&
                         ((lpi_7_0 == 8'h00) || (lpi_7_0 == 8'hF0) || (lpi_7_0 == 8'h0F)) &&
                         decoder_control_out == 8'hff))         ||
                       (block_type_field == 8'h2d &&
                        (decoder_data_out[39:32] != 8'hfe ||
                         decoder_control_out[4] != 1'b1))       ||
                       ((block_type_field == 8'h4b ||
                         block_type_field == 8'h55) &&
                        (decoder_data_out[7:0] != 8'hfe ||
                         decoder_control_out[0] != 1'b1)))              ? RX_C :
                      rx_sync_header == 2'b01 &&
                      (((block_type_field == 8'h33 ||
                         block_type_field == 8'h66) &&
                        (decoder_data_out[7:0] != 8'hfe ||
                         decoder_control_out[0] != 1'b1 ||
                         decoder_data_out[39:32] != 8'hfe ||
                         decoder_control_out[4] != 1'b1))       ||
                       block_type_field == 8'h78)                       ? RX_S :
                      rx_sync_header == 2'b01 &&
                      `ifdef XFIPCS_16G32GFC
                      ((block_type_field == 8'hb4 ||
                        block_type_field == 8'hff) &&
                       (decoder_data_out[7:0] != 8'hfe ||
                        decoder_control_out[0] != 1'b1))                ? RX_T :
                      `else
                      ((block_type_field == 8'h87 ||
                        block_type_field == 8'h99 ||
                        block_type_field == 8'haa ||
                        block_type_field == 8'hb4 ||
                        block_type_field == 8'hcc ||
                        block_type_field == 8'hd2 ||
                        block_type_field == 8'he1 ||
                        block_type_field == 8'hff) &&
                       (decoder_data_out[7:0] != 8'hfe ||
                        decoder_control_out[0] != 1'b1))                ? RX_T :
                      `endif  
                      rx_sync_header == 2'b10                           ? RX_D :
                                                                          RX_E ;


 assign rxc_xfi = rx_raw == LBLOCK_R                                   ? 8'h11 :
                  rx_raw == EBLOCK_R                                   ? 8'hff :
                  rx_raw == LI                                         ? 8'hff :
                  rx_raw == DECODE                              ? control_save :
                                                                         8'h11 ;
 assign rxd_xfi = rx_raw == LBLOCK_R                    ? 64'h0100009c0100009c :
                  rx_raw == EBLOCK_R                    ? 64'hfefefefefefefefe :
                  rx_raw == LI                          ? 64'h0606060606060606 :
                  rx_raw == DECODE                                 ? data_save :
                                                          64'h0100009c0100009c ;

 assign rx_local_fault = (rx_raw == LBLOCK_R) ? 1'b1 : 1'b0 ;

endmodule
