//SCCS File Version= %I% 
//Release Date= 14/04/20  19:57:07 GMT startFileName /vobs/vob012/xfipcs/verilog/rtl/XFIPCS_TX_FIFO.v endFileName  

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

//$Id: XFIPCS_TX_FIFO.v,v 1.8 2014/02/21 07:12:01 huqian Exp $
//$Log: XFIPCS_TX_FIFO.v,v $
//Revision 1.8  2014/02/21 07:12:01  huqian
//Copy XFIPCS cvs tag v1_135
//
//Revision 1.19  2013/12/17 08:44:48  huqian
//Add synthesis option to remove TX FIFO control(clock compensation) logic and TX XGMII data interface
//
//Revision 1.18  2013/12/12 03:29:20  huqian
//Modify XFIPCS_32GFC macro define to XFIPCS_16G32GFC
//
//Revision 1.17  2013/10/28 03:33:46  huqian
//Fix HW270791: Push extra IDLE into TX_FIFO while starting transmit Signal Ordered Set
//
//Revision 1.16  2013/09/27 05:13:04  huqian
//Fix HW268863: TX_RDATA_P1 signal appears 'X' state
//
//Revision 1.15  2013/09/17 05:59:35  huqian
//Initial 32G Fibre Channel
//
//Revision 1.14  2012/04/06 20:16:30  adamc
//Fixed typo in underflow logic
//
//Revision 1.13  2011/04/18 13:05:09  adamc
//Clarifying some comments
//
//Revision 1.12  2011/04/13 17:28:43  adamc
//Updating TX_FIFO to mimic RX_FIFO in how it detects overflow
//
//Revision 1.11  2011/04/11 20:15:42  adamc
//Updated TX_FIFO under/overflow logic top mimic RX FIFO
//
//Revision 1.10  2011/04/11 17:38:18  adamc
//Reverting RX_FIFO back to 2-away. Changing TX FIFO to overflow on 3-away
//
//Revision 1.9  2011/04/01 17:52:14  adamc
//Updated initial values for fifo pointers and tweaked some math
//
//Revision 1.8  2011/03/29 14:51:02  adamc
//Updated overflow underflow formulas for worse case
//
//Revision 1.7  2011/03/29 13:48:09  adamc
//Update to FIFO underflow and overflow logic
//
//Revision 1.6  2011/03/10 14:07:20  adamc
//cvs_snap v1_48
//
//Revision 1.5  2011/02/17 21:13:08  adamc
//cvs_snap v1_28
//
//Revision 1.4  2010/12/15 19:50:15  adamc
//Updated idle logic to include LIs
//
//Revision 1.3  2010/12/08 21:06:25  adamc
//Initial glue logic updates for AZ
//
//Revision 1.2  2010/08/05 19:23:27  farmer
//picked up RTL from /afs/btv/data/asiccores/xfipcs/release/synth/fdk_200909b/source
//
//
//-----------------------------------------------------------------------------
// Copyright IBM Corporation 2005
// IBM Confidential
//-----------------------------------------------------------------------------

`include "XFIPCS.defines.v"
`timescale 1ns/10ps

module `XFIPCS_TOPLEVELNAME_TX_FIFO (
                        pma_tx_clk,
                        xgmii_clk,
                        reset_to_pma_tx,
`ifdef XFIPCS_16G32GFC
                        reset_to_pma_tx_div2, 
`endif
                        reset_to_xgmii_tx,

`ifdef XFIPCS_FIFOCNTL
                        txc_sdr,
                        txd_sdr,
                        tx_fifo_depth,
`endif                        
                        tx_rdata_p1,

                        tx_fifo_hold,
                        tx_fifo_pop,
`ifdef XFIPCS_FIFOCNTL                        
                        tx_waddr_p1,
                        tx_waddr_p2,
                        tx_overflow,
                        tx_underflow,
                        tx_wdata_p1,
                        tx_wdata_p2,
                        tx_wupper_en1,
                        tx_wlower_en1,
                        tx_wupper_en2,
                        tx_wlower_en2,
                        tx_raddr_p1,
`endif                        
                        txc_xfi,
                        txd_xfi
                );

// ----------------------------------------------------------------------------
// Inputs/Outputs
// ----------------------------------------------------------------------------
input           pma_tx_clk;
input           xgmii_clk;
input           reset_to_pma_tx;
`ifdef XFIPCS_16G32GFC
input           reset_to_pma_tx_div2;
`endif
input           reset_to_xgmii_tx;

`ifdef XFIPCS_FIFOCNTL
input   [7:0]   txc_sdr;
input   [63:0]  txd_sdr;
input   [7:0]   tx_fifo_depth;
`endif
input   [71:0]  tx_rdata_p1;

output          tx_fifo_hold;
output          tx_fifo_pop;
`ifdef XFIPCS_FIFOCNTL
output  [7:0]   tx_waddr_p1;
output  [7:0]   tx_waddr_p2;
output  [71:0]  tx_wdata_p1;
output  [71:0]  tx_wdata_p2;
output          tx_wupper_en1;
output          tx_wlower_en1;
output          tx_wupper_en2;
output          tx_wlower_en2;
output  [7:0]   tx_raddr_p1;
output          tx_overflow;
output          tx_underflow;
`endif
output  [7:0]   txc_xfi;
output  [63:0]  txd_xfi;

// ----------------------------------------------------------------------------
// Internal signals/registers
// ----------------------------------------------------------------------------
`ifdef XFIPCS_FIFOCNTL
wire    [7:0]   tx_waddr_p1;
wire    [7:0]   tx_waddr_p2;
wire    [71:0]  tx_wdata_p1;
wire    [71:0]  tx_wdata_p2;
wire            tx_wupper_en1;
wire            tx_wlower_en1;
wire            tx_wupper_en2;
wire            tx_wlower_en2;
wire    [7:0]   tx_raddr_p1;
wire            tx_overflow;
wire            tx_underflow;
reg     [2:0]   tx_overflow_count;
reg     [2:0]   tx_underflow_count;

reg             add_req;
wire            add_req_in;
wire            add_req_new;
wire    [2:0]   add_req_count_nxt;
reg     [2:0]   add_req_count;
wire    [1:0]   flower;
wire    [1:0]   fupper;
wire            hold_pointer;
reg     [7:0]   read_pointer_pma_bin;
wire    [7:0]   read_pointer_pma_bin_nxt;
reg     [7:0]   read_pointer_pma_bin_shift;
wire    [7:0]   read_pointer_pma_bin_shift_nxt;
wire    [7:0]   read_pointer_pma_gray_nxt;
reg     [7:0]   read_pointer_pma_gray;
wire    [7:0]   read_pointer_xgmii_gray;
wire    [7:0]   read_pointer_xgmii_bin_nxt;
wire    [7:0]   read_pointer_xgmii_bin_shift;
reg     [7:0]   read_pointer_xgmii_bin;
reg             rem_req;
wire            rem_req_in;
wire            rem_req_new;
wire    [2:0]   rem_req_count_nxt;
reg     [2:0]   rem_req_count;
wire            add_clear;
wire            rem_clear;
reg             reset_delay_1;
reg             reset_delay_2;
reg             reset_delay_3;
wire            skip_pointer;
wire    [1:0]   slower;
wire    [1:0]   supper;
wire            t_lower;
reg             t_prev;
wire            t_prev_in;
wire            q_lower;
reg             q_prev;
wire            q_prev_nxt;
wire            q_upper;
wire            f_lower;
wire            f_upper;
reg     [10:0]  tx_fifo_cntl;
reg             tx_fifo_state;
wire            tx_fifo_state_in;
wire            i_lower;
wire            vi_lower;
wire            i_upper;
wire            vi_upper;
wire    [71:0]  w_data1;
wire    [71:0]  w_data2;
wire            w_lower_en1;
wire            w_lower_en2;
wire            w_upper_en1;
wire            w_upper_en2;
reg     [7:0]   write_pointer;
reg     [7:0]   write_pointer_2;
wire    [7:0]   write_pointer_2_in;
wire    [7:0]   write_pointer_2_nxt;
wire    [7:0]   write_pointer_in;
wire    [7:0]   write_pointer_nxt;
wire            write_minus_read_0;
wire            write_minus_read_1;
wire            write_minus_read_2;
wire            write_minus_read_3;
wire            write_minus_read_4;
wire            write_minus_read_5;
wire            write_minus_read_6;
wire            write_minus_read_7;
wire            write_minus_read_8;
wire            write_minus_read_9;
wire            write_minus_read_10;
wire            write_minus_read_11;
wire    [7:0]           halfway_shift;
wire    [7:0]           rollover_bin;
wire                    halfway_extra;
wire                    rollover_extra;
wire [8:0] write_minus_read;
wire [8:0] small_write_minus_read;
wire [8:0] small_w_m_r_adjust;
wire [2:0]      tx_overflow_count_nxt;
wire [2:0]      tx_underflow_count_nxt;
wire    [7:0]   w_r_pointer_diff;

wire    [3:0]           reset_count_nxt;
reg     [3:0]           reset_count;
`endif   //XFIPCS_FIFOCNTL

wire            tx_fifo_pop;
wire    [5:0]   tx_fifo_pop_counter_nxt;
reg     [5:0]   tx_fifo_pop_counter;
`ifdef XFIPCS_16G32GFC
wire [2:0] tx_fifo_hold_counter_nxt;
reg  [2:0] tx_fifo_hold_counter;
`else
wire [3:0] tx_fifo_hold_counter_nxt;
reg  [3:0] tx_fifo_hold_counter;
`endif
wire       tx_fifo_hold;
wire    [71:0]  r_data;
wire    [7:0]   txc_xfi;
wire    [63:0]  txd_xfi;

`ifdef XFIPCS_16G32GFC
  assign tx_fifo_pop = (tx_fifo_pop_counter!=6'd32);
  assign tx_fifo_hold = tx_fifo_hold_counter != 3'h7 ;
  
  assign tx_fifo_hold_counter_nxt = reset_to_pma_tx_div2                 ? 3'h0 :
                                    tx_fifo_hold_counter == 3'h7         ? 3'h7 :
                                                       tx_fifo_hold_counter + 1 ;
   
  assign tx_fifo_pop_counter_nxt = reset_to_pma_tx_div2                 ? 6'h10 :
                                tx_fifo_pop_counter == 6'h20            ? 6'h00 :
                                                        tx_fifo_pop_counter + 1 ;
`else
  assign tx_fifo_pop = tx_fifo_pop_counter[0];
  assign tx_fifo_hold = tx_fifo_hold_counter != 4'hf ;

  assign tx_fifo_hold_counter_nxt = reset_to_pma_tx                      ? 4'h0 :
                                    tx_fifo_hold_counter == 4'hf         ? 4'hf :
                                                       tx_fifo_hold_counter + 1 ;
   
  assign tx_fifo_pop_counter_nxt = reset_to_pma_tx                      ? 6'h10 :
                                tx_fifo_pop_counter == 6'h20            ? 6'h00 :
                                                        tx_fifo_pop_counter + 1 ;
`endif
  
 always @(posedge pma_tx_clk)
   begin
     tx_fifo_pop_counter <= tx_fifo_pop_counter_nxt;
     tx_fifo_hold_counter <= tx_fifo_hold_counter_nxt;
   end

assign r_data = tx_rdata_p1;

assign txc_xfi = {r_data[71:68], r_data[35:32]};
assign txd_xfi = {r_data[67:36], r_data[31:0]};

// ----------------------------------------------------------------------------
// Parameters
// ----------------------------------------------------------------------------
parameter TX_FIFO_BYPASS = 1'b0;

// ----------------------------------------------------------------------------
// Implementation
// ----------------------------------------------------------------------------
`ifdef XFIPCS_FIFOCNTL
 assign {rollover_extra, rollover_bin} = {tx_fifo_depth, 1'b0} - 1;
 assign {halfway_extra, halfway_shift} = 9'h100 - {1'b0, tx_fifo_depth};

 assign read_pointer_pma_bin_nxt =
                                               reset_to_pma_tx == 1'b1 ? 8'h00 :
                                    tx_fifo_pop == 1'b0 ? read_pointer_pma_bin :
                                  read_pointer_pma_bin == rollover_bin ? 8'h00 :
                                                      read_pointer_pma_bin + 1 ;
 assign read_pointer_pma_bin_shift_nxt =
                      reset_to_pma_tx == 1'b1                          ? 8'h00 :
                              tx_fifo_pop == 1'b0 ? read_pointer_pma_bin_shift :
               read_pointer_pma_bin_shift == tx_fifo_depth - 1 ? halfway_shift :
                                                read_pointer_pma_bin_shift + 1 ;

 assign read_pointer_pma_gray_nxt =
          read_pointer_pma_bin_shift ^ {1'b0, read_pointer_pma_bin_shift[7:1]} ;

 assign write_minus_read = {1'b0, write_pointer} - {1'b0, read_pointer_xgmii_bin};
 assign small_write_minus_read = write_minus_read + {tx_fifo_depth, 1'b0} ;
 assign w_r_pointer_diff = write_minus_read[8] ? small_write_minus_read[7:0] : write_minus_read[7:0] ;

 assign write_minus_read_0  = w_r_pointer_diff == 8'h03 ;
 assign write_minus_read_1  = w_r_pointer_diff == 8'h04 ;
 assign write_minus_read_2  = w_r_pointer_diff == 8'h05 ;
 assign write_minus_read_3  = w_r_pointer_diff == 8'h06 ;
 assign write_minus_read_4  = w_r_pointer_diff == 8'h07 ;
 assign write_minus_read_5  = w_r_pointer_diff == 8'h08 ;
 assign write_minus_read_6  = w_r_pointer_diff == 8'h09 ;
 assign write_minus_read_7  = w_r_pointer_diff == 8'h0a ;
 assign write_minus_read_8  = w_r_pointer_diff == 8'h0b ;
 assign write_minus_read_9  = ({tx_fifo_depth, 1'b0} == 9'h0c) ? w_r_pointer_diff == 8'h00 : w_r_pointer_diff == 8'h0c ;
 assign write_minus_read_10 = ({tx_fifo_depth, 1'b0} == 9'h0c) ? w_r_pointer_diff == 8'h01 : w_r_pointer_diff == 8'h0d ;
 assign write_minus_read_11 = ({tx_fifo_depth, 1'b0} == 9'h0c) ? w_r_pointer_diff == 8'h02 : w_r_pointer_diff == 8'h0e ;


 // read_pointer_xgmii_bin is 2-3 cycles off actual value. So worse case formulas are:
 // Underflow: (W-R) - 3 = 2 away from eachother, so W-R = 5
 // Overflow:  (W-R) - 2 = FIFO_DEPTH - 2 away from eachother, so W-R = FIFO_DEPTH = 0
 assign tx_underflow_count_nxt = ((reset_count < 4'h8) | TX_FIFO_BYPASS) ? 3'h0 :
                                 (write_minus_read_2)                    ? tx_underflow_count + 1 :
                                 (tx_underflow_count != 3'h0)            ? tx_underflow_count + 1 :
                                                                           3'h0;

 assign tx_overflow_count_nxt = ((reset_count < 4'h8) | TX_FIFO_BYPASS)                      ? 3'h0 :
                                ({1'b0,w_r_pointer_diff} == ({tx_fifo_depth, 1'b0} - 9'h01)) ? tx_overflow_count + 1 :
                                (tx_overflow_count != 3'h0)                                  ? tx_overflow_count + 1 :
                                                                                                3'h0 ;
 assign tx_overflow = tx_overflow_count != 3'h0 ;
 assign tx_underflow = tx_underflow_count != 3'h0 ;

 assign add_clear = ~reset_to_xgmii_tx & (write_minus_read_6 | write_minus_read_7);
 `ifdef XFIPCS_16G32GFC
 assign add_req_new = reset_count[3] & (rem_req_count == 3'b111) & (write_minus_read_3 | write_minus_read_2);
 `else
 assign add_req_new = reset_count[3] & (rem_req_count == 3'b111) & (write_minus_read_3 | write_minus_read_4);
 `endif
 assign add_req_count_nxt = (add_req || reset_to_xgmii_tx) ? 3'b000 :
                            (add_req_count == 3'b111)      ? 3'b111 :
                                                             add_req_count + 1 ;

 assign rem_clear = ~reset_to_xgmii_tx & (write_minus_read_4 | write_minus_read_5);
 assign rem_req_new = reset_count[3] & (add_req_count == 3'b111) & (write_minus_read_7 | write_minus_read_8 | write_minus_read_9);
 assign rem_req_count_nxt = (rem_req || reset_to_xgmii_tx) ? 3'b000 :
                            (rem_req_count == 3'b111)      ? 3'b111 :
                                                             rem_req_count + 1;

 assign add_req_in = ~reset_to_xgmii_tx && ~reset_delay_1 &&
                     ~reset_delay_2 && ~reset_delay_3 &&
                     (add_req_new || (add_req && ~add_clear)) ;

 assign rem_req_in = ~reset_to_xgmii_tx && ~reset_delay_1 &&
                     ~reset_delay_2 && ~reset_delay_3 &&
                     (rem_req_new || (rem_req && ~rem_clear)) ;


 assign t_prev_in = (txc_sdr[7] == 1'b1 & txd_sdr[63:56] == 8'hfd) |
                    (txc_sdr[6] == 1'b1 & txd_sdr[55:48] == 8'hfd) |
                    (txc_sdr[5] == 1'b1 & txd_sdr[47:40] == 8'hfd) |
                    (txc_sdr[4] == 1'b1 & txd_sdr[39:32] == 8'hfd);

 assign t_lower   = (txc_sdr[3] == 1'b1 & txd_sdr[31:24] == 8'hfd) |
                    (txc_sdr[2] == 1'b1 & txd_sdr[23:16] == 8'hfd) |
                    (txc_sdr[1] == 1'b1 & txd_sdr[15:8]  == 8'hfd) |
                    (txc_sdr[0] == 1'b1 & txd_sdr[7:0]   == 8'hfd);

 assign q_upper = (txd_sdr[39:32] == 8'h9c & txc_sdr[7:4] == 4'h1);
 assign q_prev_nxt = q_upper & (flower[1] | fupper[1] | slower[1] | supper[1]);
 assign q_lower   = txd_sdr[7:0] == 8'h9c & txc_sdr[3:0] == 4'h1;
 assign f_upper = txd_sdr[39:32] == 8'h5c & txc_sdr[7:4] == 4'h1;
 assign f_lower   = txd_sdr[7:0] == 8'h5c & txc_sdr[3:0] == 4'h1;

 assign i_upper  = (txc_sdr[7:4] == 4'hf) &
                   ((txd_sdr[63:32] == 32'h07070707) | (txd_sdr[63:32] == 32'h06060606));
 assign vi_upper = ~t_lower & i_upper;

 assign i_lower  = (txc_sdr[3:0] == 4'hf) &
                   ((txd_sdr[31:0] == 32'h07070707) | (txd_sdr[31:0] == 32'h06060606));
 assign vi_lower = ~t_prev & i_lower;

 always @(*)
   begin
     casex ({reset_to_xgmii_tx, tx_fifo_state, add_req, rem_req, vi_lower, vi_upper, i_lower, i_upper, q_prev, q_lower, q_upper, f_lower, f_upper})
       13'b1xxx_xxxx_xxx_xx : tx_fifo_cntl = 11'b0_00_0110_0000;   // reset
       13'b0000_xxxx_xxx_xx : tx_fifo_cntl = 11'b0_00_0110_0000;   // no reqs
 `ifdef XFIPCS_TOPLEVELNAME_WIS_ENABLED
       13'b0001_11xx_xxx_xx : tx_fifo_cntl = 11'b0_01_0000_0000;   // remove both idles
 `else
       13'b0001_11xx_xxx_xx : tx_fifo_cntl = 11'b1_01_1000_0000;   // remove low idle
 `endif
       13'b001x_xx1x_xxx_xx : tx_fifo_cntl = 11'b1_00_0101_1000;   // duplicate low idle
       13'b001x_xx01_xxx_xx : tx_fifo_cntl = 11'b1_00_0110_1000;   // duplicate high idle
       13'b001x_xx00_x1x_xx : tx_fifo_cntl = 11'b1_00_0111_1000;   // add idle after low Q
       13'b001x_xx00_x01_xx : tx_fifo_cntl = 11'b1_00_0110_1100;   // add idle after high Q
       13'b001x_xx00_x00_1x : tx_fifo_cntl = 11'b1_00_0111_1000;   // add idle after low F
       13'b001x_xx00_x00_01 : tx_fifo_cntl = 11'b1_00_0110_1100;   // add idle after high F
       13'b001x_xx00_x00_00 : tx_fifo_cntl = 11'b0_00_0110_0000;   // no valid idles to add
       13'b0001_10xx_xxx_xx : tx_fifo_cntl = 11'b1_01_1000_0000;   // remove low idle
       13'b0001_01xx_xxx_xx : tx_fifo_cntl = 11'b1_01_0100_0000;   // remove high idle
       13'b0001_00xx_11x_xx : tx_fifo_cntl = 11'b1_01_1000_0000;   // remove low /O/
       13'b0001_00xx_x11_xx : tx_fifo_cntl = 11'b1_01_0100_0000;   // remove high /O/
       13'b0001_00xx_xxx_xx : tx_fifo_cntl = 11'b0_00_0110_0000;   // no valid idles or /O/ to rem
       13'b0100_xxxx_xxx_xx : tx_fifo_cntl = 11'b1_00_0001_1000;   // no reqs
 `ifdef XFIPCS_TOPLEVELNAME_WIS_ENABLED
       13'b0101_11xx_xxx_xx : tx_fifo_cntl = 11'b1_01_0000_0000;   // remove both idles
 `else
       13'b0101_11xx_xxx_xx : tx_fifo_cntl = 11'b0_00_0010_0000;   // remove low idle
 `endif
       13'b011x_xx1x_xxx_xx : tx_fifo_cntl = 11'b0_10_0001_0110;   // duplicate low idle
       13'b011x_xx01_xxx_xx : tx_fifo_cntl = 11'b0_10_0001_1010;   // duplicate high idle
       13'b011x_xx00_x1x_xx : tx_fifo_cntl = 11'b0_10_0001_1110;   // add idle after low Q
       13'b011x_xx00_x01_xx : tx_fifo_cntl = 11'b0_10_0001_1011;   // add idle after high Q
       13'b011x_xx00_x00_1x : tx_fifo_cntl = 11'b0_10_0001_1110;   // add idle after low F
       13'b011x_xx00_x00_01 : tx_fifo_cntl = 11'b0_10_0001_1011;   // add idle after high F
       13'b011x_xx00_x00_00 : tx_fifo_cntl = 11'b1_00_0001_1000;   // no valid idles to add
       13'b0101_10xx_xxx_xx : tx_fifo_cntl = 11'b0_00_0010_0000;   // remove low idle
       13'b0101_01xx_xxx_xx : tx_fifo_cntl = 11'b0_00_0001_0000;   // remove high idle
       13'b0101_00xx_11x_xx : tx_fifo_cntl = 11'b0_00_0010_0000;   // remove low /O/
       13'b0101_00xx_x11_xx : tx_fifo_cntl = 11'b0_00_0001_0000;   // remove high /O/
       13'b0101_00xx_xxx_xx : tx_fifo_cntl = 11'b1_00_0001_1000;   // no valid idles or /O/ to rem
       default  : tx_fifo_cntl = 11'b0_00_0001_1000;   // not reachable
     endcase
   end

 assign tx_fifo_state_in = tx_fifo_cntl[10];
 assign skip_pointer = tx_fifo_cntl[9];
 assign hold_pointer = tx_fifo_cntl[8];
 assign flower = tx_fifo_cntl[7:6];
 assign fupper = tx_fifo_cntl[5:4];
 assign slower = tx_fifo_cntl[3:2];
 assign supper = tx_fifo_cntl[1:0];

 assign write_pointer_nxt = reset_to_xgmii_tx                           ? 8'h5 :
                            skip_pointer                ? write_pointer + 8'h2 :
                            hold_pointer                       ? write_pointer :
                                                          write_pointer + 8'h1 ;

 assign write_pointer_2_nxt = reset_to_xgmii_tx                         ? 8'h6 :
                              skip_pointer            ? write_pointer_2 + 8'h2 :
                              hold_pointer                   ? write_pointer_2 :
                                                        write_pointer_2 + 8'h1 ;

 assign write_pointer_in =
                     (write_pointer_nxt == {tx_fifo_depth[6:0], 1'b0}) ? 8'h00 :
                     (write_pointer_nxt == {tx_fifo_depth[6:0], 1'b1}) ? 8'h01 :
                                                             write_pointer_nxt ;
 assign write_pointer_2_in =
                   (write_pointer_2_nxt == {tx_fifo_depth[6:0], 1'b0}) ? 8'h00 :
                   (write_pointer_2_nxt == {tx_fifo_depth[6:0], 1'b1}) ? 8'h01 :
                                                           write_pointer_2_nxt ;

 assign reset_count_nxt = reset_to_xgmii_tx                             ? 4'h0 :
                          reset_count == 4'h8                           ? 4'h8 :
                                                               reset_count + 1 ;
 always @(posedge pma_tx_clk)
   begin
     read_pointer_pma_bin <= read_pointer_pma_bin_nxt;
     read_pointer_pma_bin_shift <= read_pointer_pma_bin_shift_nxt;
     read_pointer_pma_gray <= read_pointer_pma_gray_nxt;
   end

 always @(posedge xgmii_clk)
   begin
     read_pointer_xgmii_bin <= read_pointer_xgmii_bin_nxt;
     add_req <= add_req_in;
     rem_req <= rem_req_in;
     add_req_count <= add_req_count_nxt;
     rem_req_count <= rem_req_count_nxt;
     write_pointer <= write_pointer_in;
     write_pointer_2 <= write_pointer_2_in;
     tx_fifo_state <= tx_fifo_state_in;
     reset_delay_1 <= reset_to_xgmii_tx;
     reset_delay_2 <= reset_delay_1;
     reset_delay_3 <= reset_delay_2;
     t_prev <= t_prev_in;
     q_prev <= q_upper;
     tx_overflow_count <= tx_overflow_count_nxt;
     tx_underflow_count <= tx_underflow_count_nxt;
     reset_count <= reset_count_nxt;
   end

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1) async00(
                         .clk         (xgmii_clk                   ),
                         .data_in     (read_pointer_pma_gray[0]    ),
                         .data_out    (read_pointer_xgmii_gray[0]  )
                 );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1) async01(
                         .clk         (xgmii_clk                   ),
                         .data_in     (read_pointer_pma_gray[1]    ),
                         .data_out    (read_pointer_xgmii_gray[1]  )
                 );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1) async02(
                         .clk         (xgmii_clk                   ),
                         .data_in     (read_pointer_pma_gray[2]    ),
                         .data_out    (read_pointer_xgmii_gray[2]  )
                 );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1) async03(
                         .clk         (xgmii_clk                   ),
                         .data_in     (read_pointer_pma_gray[3]    ),
                         .data_out    (read_pointer_xgmii_gray[3]  )
                 );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1) async04(
                         .clk         (xgmii_clk                   ),
                         .data_in     (read_pointer_pma_gray[4]    ),
                         .data_out    (read_pointer_xgmii_gray[4]  )
                 );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1) async05(
                         .clk         (xgmii_clk                   ),
                         .data_in     (read_pointer_pma_gray[5]    ),
                         .data_out    (read_pointer_xgmii_gray[5]  )
                 );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1) async06(
                         .clk         (xgmii_clk                   ),
                         .data_in     (read_pointer_pma_gray[6]    ),
                         .data_out    (read_pointer_xgmii_gray[6]  )
                 );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1) async07(
                         .clk         (xgmii_clk                   ),
                         .data_in     (read_pointer_pma_gray[7]    ),
                         .data_out    (read_pointer_xgmii_gray[7]  )
                 );

 assign read_pointer_xgmii_bin_shift[7] = read_pointer_xgmii_gray[7];
 assign read_pointer_xgmii_bin_shift[6] = read_pointer_xgmii_gray[6] ^ read_pointer_xgmii_bin_shift[7];
 assign read_pointer_xgmii_bin_shift[5] = read_pointer_xgmii_gray[5] ^ read_pointer_xgmii_bin_shift[6];
 assign read_pointer_xgmii_bin_shift[4] = read_pointer_xgmii_gray[4] ^ read_pointer_xgmii_bin_shift[5];
 assign read_pointer_xgmii_bin_shift[3] = read_pointer_xgmii_gray[3] ^ read_pointer_xgmii_bin_shift[4];
 assign read_pointer_xgmii_bin_shift[2] = read_pointer_xgmii_gray[2] ^ read_pointer_xgmii_bin_shift[3];
 assign read_pointer_xgmii_bin_shift[1] = read_pointer_xgmii_gray[1] ^ read_pointer_xgmii_bin_shift[2];
 assign read_pointer_xgmii_bin_shift[0] = read_pointer_xgmii_gray[0] ^ read_pointer_xgmii_bin_shift[1];

 assign read_pointer_xgmii_bin_nxt = reset_to_xgmii_tx == 1'b1 ? 8'h00 :
   read_pointer_xgmii_bin_shift < tx_fifo_depth ? read_pointer_xgmii_bin_shift :
                     {tx_fifo_depth[6:0], 1'b0} + read_pointer_xgmii_bin_shift ;

 assign w_data1[35:0] =  (flower == 2'b01) ? {txc_sdr[3:0], txd_sdr[31:0] } :
                         (flower == 2'b10) ? {txc_sdr[7:4], txd_sdr[63:32]} :
                                                              36'hf07070707 ;
 assign w_data1[71:36] = (fupper == 2'b01) ? {txc_sdr[3:0], txd_sdr[31:0] } :
                         (fupper == 2'b10) ? {txc_sdr[7:4], txd_sdr[63:32]} :
                                                              36'hf07070707 ;
 assign w_data2[35:0] =  (slower == 2'b01) ? {txc_sdr[3:0], txd_sdr[31:0] } :
                         (slower == 2'b10) ? {txc_sdr[7:4], txd_sdr[63:32]} :
                                                              36'hf07070707 ;
 assign w_data2[71:36] = (supper == 2'b01) ? {txc_sdr[3:0], txd_sdr[31:0] } :
                         (supper == 2'b10) ? {txc_sdr[7:4], txd_sdr[63:32]} :
                                                              36'hf07070707 ;

 assign w_lower_en1 = flower[1] || flower[0];
 assign w_upper_en1 = fupper[1] || fupper[0];
 assign w_lower_en2 = slower[1] || slower[0];
 assign w_upper_en2 = supper[1] || supper[0];

 //`XFIPCS_TOPLEVELNAME_TX_FIFO_MEM mem(
 //                .w_reset        (reset_to_xgmii_tx      ),
 //                .w_clk          (xgmii_clk              ),
 //
 //                .w_addr1        (write_pointer          ),
 //                .w_addr2        (write_pointer_2        ),
 //                .w_data1        (w_data1                ),
 //                .w_data2        (w_data2                ),
 //                .w_upper_en1    (w_upper_en1            ),
 //                .w_lower_en1    (w_lower_en1            ),
 //                .w_upper_en2    (w_upper_en2            ),
 //                .w_lower_en2    (w_lower_en2            ),
 //                .r_addr         (read_pointer_xfi_bin   ),
 //
 //                .r_data         (r_data                 )
 //        );

 assign tx_waddr_p1 = write_pointer ;
 assign tx_waddr_p2 = write_pointer_2 ;
 assign tx_wdata_p1 = w_data1 ;
 assign tx_wdata_p2 = w_data2 ;
 assign tx_wupper_en1 = w_upper_en1 ;
 assign tx_wlower_en1 = w_lower_en1 ;
 assign tx_wupper_en2 = w_upper_en2 ;
 assign tx_wlower_en2 = w_lower_en2 ;
 assign tx_raddr_p1 = read_pointer_pma_bin ;
`endif   //XFIPCS_FIFOCNTL 

endmodule
