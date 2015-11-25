//SCCS File Version= %I% 
//Release Date= 14/04/20  19:56:47 GMT startFileName /vobs/vob012/xfipcs/verilog/rtl/XFIPCS_RX_FIFO.v endFileName  

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

//$Id: XFIPCS_RX_FIFO.v,v 1.8 2014/02/21 07:12:00 huqian Exp $
//$Log: XFIPCS_RX_FIFO.v,v $
//Revision 1.8  2014/02/21 07:12:00  huqian
//Copy XFIPCS cvs tag v1_135
//
//Revision 1.36  2013/12/18 08:32:53  huqian
//Add synthesis option to remove RX FIFO control(clock compensation) logic and RX XGMII data interface
//
//Revision 1.35  2011/04/20 20:28:02  adamc
//Leda fixes
//
//Revision 1.34  2011/04/19 01:59:50  adamc
//Update to datapath to help LFAULT to DATA transition
//
//Revision 1.33  2011/04/18 13:05:09  adamc
//Clarifying some comments
//
//Revision 1.32  2011/04/12 03:47:40  adamc
//SMall tweak to RX FIFO fsm to handle internal reset count correctly
//
//Revision 1.30  2011/04/08 17:49:22  adamc
//Changing underflow condition to reset on 3 away
//
//Revision 1.29  2011/04/08 15:33:37  adamc
//Updates to fifo to handle very short LPI pulses
//
//Revision 1.28  2011/04/05 14:17:37  adamc
//Tweaked FIFO write enable timings to start writing a few cycles earlier
//
//Revision 1.27  2011/04/04 19:28:23  adamc
//Added reset to read pointers in prbs mode
//
//Revision 1.26  2011/04/01 20:28:27  adamc
//Added some terms to add_req logic for add_req to handle comming out of test pattern situation
//
//Revision 1.25  2011/03/31 18:45:12  adamc
//add and rem_req tweaks to keep pointer diff within the 5-6 range
//
//Revision 1.24  2011/03/31 15:05:50  adamc
//Updated initial values for RX_FIFO pointers given new math
//
//Revision 1.23  2011/03/30 22:48:49  adamc
//Account for the 2-3 cycle diff in RX_FIFO math
//
//Revision 1.22  2011/03/30 03:09:25  adamc
//cvs_snap v1_84
//
//Revision 1.21  2011/03/29 18:44:00  adamc
//cvs_snap v1_83
//
//Revision 1.20  2011/03/29 14:51:01  adamc
//Updated overflow underflow formulas for worse case
//
//Revision 1.19  2011/03/29 13:48:09  adamc
//Update to FIFO underflow and overflow logic
//
//Revision 1.16  2011/03/22 14:05:06  adamc
//Update to write enable gating signal
//
//Revision 1.15  2011/03/20 01:10:03  adamc
//Gating toplevel RX fifo write by rx_fifo_internal reset
//
//Revision 1.14  2011/03/16 23:46:55  adamc
//cvs_snap v1_60
//
//Revision 1.13  2011/03/16 17:10:59  adamc
//cvs_snap v1_58
//
//Revision 1.12  2011/03/15 19:45:37  adamc
//cvs_snap v1_54
//
//Revision 1.11  2011/03/09 16:00:57  adamc
//cvs_snap v1_47
//
//Revision 1.10  2011/03/04 21:42:12  adamc
//Implemented small FSM in fifo to handle LPI reset tracking
//
//Revision 1.9  2011/02/25 16:18:01  adamc
//cvs_snap v1_35
//
//Revision 1.8  2011/02/23 20:57:03  adamc
//Fifo reset fix
//
//Revision 1.7  2011/02/21 21:45:58  adamc
//cvs_snap v1_29
//
//Revision 1.5  2011/01/27 19:06:17  adamc
//FIxed bug in read pointer reset logic
//
//Revision 1.4  2011/01/25 21:26:14  adamc
//Updated reset logic
//
//Revision 1.3  2010/12/15 19:50:15  adamc
//Updated idle logic to include LIs
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

module `XFIPCS_TOPLEVELNAME_RX_FIFO (
                        pma_rx_clk,
                        xgmii_clk,
                        reset_to_pma_rx,
                        reset_to_xgmii_rx,
                        rx_lpi_active_pma_rx,

                        rx_prbs_pat_en_pma,
                        rx_prbs_pat_en_xgmii,
                        rx_local_fault_xgmii,
                        data_valid,
`ifdef XFIPCS_FIFOCNTL                        
                        rx_fifo_depth,
                        rx_rdata_p1,
                        rx_rdata_p2,

                        rx_raddr_p1,
                        rx_raddr_p2,
                        rx_waddr_p1,
                        rx_overflow,
                        rx_underflow,
                        rxc_sdr,
                        rxd_sdr,
`endif                        
                        local_fault_on_none,
                        rx_fifo_we
                );

// ----------------------------------------------------------------------------
// Inputs/Outputs
// ----------------------------------------------------------------------------
input                   pma_rx_clk;
input                   xgmii_clk;
input                   reset_to_pma_rx;
input                   reset_to_xgmii_rx;
input                   rx_lpi_active_pma_rx;

input                   rx_prbs_pat_en_pma;
input                   rx_prbs_pat_en_xgmii;
input                   rx_local_fault_xgmii;
input                   data_valid;
`ifdef XFIPCS_FIFOCNTL
input   [71:0]          rx_rdata_p1;
input   [71:0]          rx_rdata_p2;
input   [7:0]           rx_fifo_depth;

output  [7:0]           rxc_sdr;
output  [63:0]          rxd_sdr;
output  [7:0]           rx_raddr_p1;
output  [7:0]           rx_raddr_p2;
output  [7:0]           rx_waddr_p1;
output                  rx_overflow;
output                  rx_underflow;
`endif
output                  local_fault_on_none;
output                  rx_fifo_we;

// ----------------------------------------------------------------------------
// Internal signals/registers
// ----------------------------------------------------------------------------
`ifdef XFIPCS_FIFOCNTL
wire    [7:0]           rx_raddr_p1;
wire    [7:0]           rx_raddr_p2;
wire    [7:0]           rx_waddr_p1;
wire    [7:0]           rxc_sdr;
wire    [63:0]          rxd_sdr;
wire                    rx_overflow;
reg     [2:0]           rx_overflow_count;
wire                    rx_underflow;
reg     [2:0]           rx_underflow_count;
`endif
reg                     rx_prbs_pat_en_xgmii_prev;
reg                     reset_to_xgmii_rx_2;
reg                     reset_to_xgmii_rx_3;

wire                    add_clear;
reg                     add_req;
wire                    add_req_in;
wire                    add_req_new;
wire    [2:0]           add_req_count_nxt;
reg     [2:0]           add_req_count;
wire    [1:0]           flower;
wire    [1:0]           fupper;
wire                    hold_pointer;
`ifdef XFIPCS_FIFOCNTL
wire    [71:0]          r_data1;
wire    [71:0]          r_data2;
`endif
reg     [7:0]           read_pointer_2_bin;
wire    [7:0]           read_pointer_2_bin_in;
wire    [7:0]           read_pointer_2_bin_nxt;
reg     [7:0]           read_pointer_bin;
wire    [7:0]           read_pointer_bin_in;
wire    [7:0]           read_pointer_bin_nxt;
wire                    read_minus_write_0;
wire                    read_minus_write_1;
wire                    read_minus_write_2;
wire                    read_minus_write_3;
wire                    read_minus_write_4;
wire                    read_minus_write_5;
wire                    read_minus_write_6;
wire                    read_minus_write_7;
wire                    read_minus_write_8;
wire                    read_minus_write_9;
wire                    read_minus_write_10;
wire                    read_minus_write_11;
wire                    rem_clear;
reg                     rem_req;
wire                    rem_req_in;
wire                    rem_req_new;
wire    [2:0]           rem_req_count_nxt;
reg     [2:0]           rem_req_count;
reg     [10:0]          rx_fifo_cntl;
reg                     rx_fifo_state;
wire                    rx_fifo_state_in;
`ifdef XFIPCS_FIFOCNTL
wire    [3:0]           rxc_sdr_lower;
wire    [3:0]           rxc_sdr_upper;
wire    [31:0]          rxd_sdr_lower;
wire    [31:0]          rxd_sdr_upper;
`endif
wire                    skip_pointer;
wire    [1:0]           slower;
wire    [1:0]           supper;
wire                    lf_flower;
wire                    lf_slower;
wire                    lf_fupper;
wire                    lf_supper;
wire                    t_flower;
wire                    t_fupper;
wire                    q_fupper;
wire                    q_flower;
wire                    q_slower;
reg                     q_pupper;
wire                    q_pupper_nxt;
wire                    f_fupper;
wire                    f_flower;
wire                    f_slower;
reg                     f_pupper;
wire                    f_pupper_nxt;
reg                     t_pupper;
wire                    t_slower;
wire                    vi_flower;
wire                    vi_fupper;
wire                    vi_slower;
wire                    i_flower;
wire                    i_fupper;
wire                    i_slower;
reg     [7:0]           write_pointer_pma_bin_prev;
reg     [7:0]           write_pointer_pma_bin;
wire    [7:0]           write_pointer_pma_bin_nxt;
reg     [7:0]           write_pointer_pma_bin_shift;
wire    [7:0]           write_pointer_pma_bin_shift_nxt;
reg     [7:0]           write_pointer_pma_gray;
wire    [7:0]           write_pointer_pma_gray_nxt;
reg     [7:0]           write_pointer_xgmii_bin;
wire    [7:0]           write_pointer_xgmii_bin_nxt;
wire    [7:0]           write_pointer_xgmii_bin_shift;
wire    [7:0]           write_pointer_xgmii_gray;
wire    [8:0]           read_minus_write;
wire    [8:0]           small_read_minus_write;
wire    [7:0]           r_w_pointer_diff;
wire    [7:0]           halfway_shift;
wire    [7:0]           rollover_bin;
wire                    halfway_extra;
wire                    rollover_extra;
wire    [3:0]           reset_count_nxt;
reg     [3:0]           reset_count;
wire    [3:0]           reset_count_pma_rx_nxt;
reg     [3:0]           reset_count_pma_rx;
`ifdef XFIPCS_FIFOCNTL
wire    [2:0]           rx_overflow_count_nxt;
wire    [2:0]           rx_underflow_count_nxt;
`endif
reg     [7:0]           write_pointer_lpi_start_nxt;
reg     [7:0]           write_pointer_lpi_start;
reg                     rx_lpi_active_pma_rx_prev;
reg     [3:0]           internal_reset_count;
reg     [3:0]           internal_reset_count_nxt;
reg                     internal_reset_nxt;
reg                     internal_reset;
wire                    internal_reset_xgmii;
wire                    internal_reset_pma_rx;
reg                     data_valid_2;
reg                     data_valid_3;
wire                    reset_xgmii;
wire                    reset_pma_rx;

reg  [2:0]              lpi_check_state_nxt;
reg  [2:0]              lpi_check_state;

wire                    write_enable_pma_rx;
reg                     write_enable;
wire                    write_enable_nxt;

wire                    reset_count_8;
wire                    reset_count_8_pma_rx;
// ----------------------------------------------------------------------------
// Parameters
// ----------------------------------------------------------------------------
parameter RX_FIFO_BYPASS = 1'b0;

parameter IDLE          = 3'b000;
parameter LPI_START     = 3'b101;
parameter WAIT_FOR_FULL = 3'b110;
parameter FULL_OF_LPIS  = 3'b011;

// ----------------------------------------------------------------------------
// Implementation
// ----------------------------------------------------------------------------
 assign rx_fifo_we = write_enable;
 `ifdef XFIPCS_FIFOCNTL
 assign rx_raddr_p1 = read_pointer_bin;
 assign rx_raddr_p2 = read_pointer_2_bin;
 assign rx_waddr_p1 = write_pointer_pma_bin;
 assign r_data1 = rx_rdata_p1;
 assign r_data2 = rx_rdata_p2;
 assign {rollover_extra, rollover_bin} = {rx_fifo_depth, 1'b0} - 1;
 assign {halfway_extra, halfway_shift} = 9'h100 - {1'b0, rx_fifo_depth};
 `else
 assign {rollover_extra, rollover_bin} = {8'h8, 1'b0} - 1;
 assign {halfway_extra, halfway_shift} = 9'h100 - {1'b0, 8'h8};
 `endif

 //----------------------------------------------------------------------------
 // AZ Updates

 // During low-power, look to see when the fifo is flooded with LPIs.
 // Once this happens, reset the pointers until non-lpi data starts coming in.

 always @(*) begin : lpi_check_fsm
  // default assignments
  lpi_check_state_nxt = lpi_check_state;
  write_pointer_lpi_start_nxt = write_pointer_lpi_start;
  internal_reset_nxt = internal_reset;
  internal_reset_count_nxt = internal_reset_count;

  case (lpi_check_state)
   IDLE : begin
    if (rx_lpi_active_pma_rx && !rx_lpi_active_pma_rx_prev) begin
     lpi_check_state_nxt = LPI_START;
     write_pointer_lpi_start_nxt = write_pointer_pma_bin;
    end
   end

   LPI_START : begin
    if (~rx_lpi_active_pma_rx) begin
    lpi_check_state_nxt = IDLE;
    internal_reset_nxt = 1'b0;
    end else if (write_pointer_pma_bin != write_pointer_pma_bin_prev) begin
     lpi_check_state_nxt = WAIT_FOR_FULL;
    end
   end

   WAIT_FOR_FULL : begin
    if (~rx_lpi_active_pma_rx) begin
    lpi_check_state_nxt = IDLE;
    internal_reset_nxt = 1'b0;
    end else if (write_pointer_lpi_start == write_pointer_pma_bin) begin
     lpi_check_state_nxt = FULL_OF_LPIS;
     internal_reset_nxt = 1'b1;
     internal_reset_count_nxt = 4'h0;
    end
   end

   FULL_OF_LPIS : begin
    if (~rx_lpi_active_pma_rx && (internal_reset_count >= 4'h5)) begin
     lpi_check_state_nxt = IDLE;
     internal_reset_nxt = 1'b0;
    end else if (internal_reset_count != 4'hf) begin
     internal_reset_count_nxt = internal_reset_count + 4'h1;
    end
   end

   default : begin
    lpi_check_state_nxt = IDLE;
    internal_reset_nxt = 1'b0;
   end
  endcase
 end

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async10(
                         .clk         (xgmii_clk     ),
                         .data_in     (internal_reset),
                         .data_out    (internal_reset_xgmii )
                 );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async11(
                         .clk         (pma_rx_clk    ),
                         .data_in     (internal_reset_xgmii),
                         .data_out    (internal_reset_pma_rx )
                 );

 assign reset_xgmii  = reset_to_xgmii_rx | internal_reset_xgmii;
 assign reset_pma_rx = reset_to_pma_rx | internal_reset_pma_rx;

 //----------------------------------------------------------------------------
 
 assign write_pointer_pma_bin_nxt = (!data_valid_3)                           ? write_pointer_pma_bin :
                                    (write_pointer_pma_bin == rollover_bin) ? 8'h00 :
                                                                              write_pointer_pma_bin + 1 ;

 `ifdef XFIPCS_FIFOCNTL
 assign write_pointer_pma_bin_shift_nxt = (!data_valid_3)                                      ? write_pointer_pma_bin_shift :
                                          (write_pointer_pma_bin_shift + 1 == rx_fifo_depth) ? halfway_shift :
                                                                                               write_pointer_pma_bin_shift + 1 ;
 `else
 assign write_pointer_pma_bin_shift_nxt = (!data_valid_3)                                      ? write_pointer_pma_bin_shift :
                                          (write_pointer_pma_bin_shift + 1 == 8'h8) ? halfway_shift :
                                                                                               write_pointer_pma_bin_shift + 1 ;
 `endif

 assign write_pointer_pma_gray_nxt = write_pointer_pma_bin_shift ^ {1'b0, write_pointer_pma_bin_shift[7:1]} ;

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1, 1) async00(
                         .clk         (xgmii_clk              ),
                         .data_in     (write_pointer_pma_gray[0]    ),
                         .data_out    (write_pointer_xgmii_gray[0]  )
                 );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1, 1) async01(
                         .clk         (xgmii_clk              ),
                         .data_in     (write_pointer_pma_gray[1]    ),
                         .data_out    (write_pointer_xgmii_gray[1]  )
                 );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1, 1) async02(
                         .clk         (xgmii_clk              ),
                         .data_in     (write_pointer_pma_gray[2]    ),
                         .data_out    (write_pointer_xgmii_gray[2]  )
                 );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1, 1) async03(
                         .clk         (xgmii_clk              ),
                         .data_in     (write_pointer_pma_gray[3]    ),
                         .data_out    (write_pointer_xgmii_gray[3]  )
                 );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1, 1) async04(
                         .clk         (xgmii_clk              ),
                         .data_in     (write_pointer_pma_gray[4]    ),
                         .data_out    (write_pointer_xgmii_gray[4]  )
                 );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1, 1) async05(
                         .clk         (xgmii_clk              ),
                         .data_in     (write_pointer_pma_gray[5]    ),
                         .data_out    (write_pointer_xgmii_gray[5]  )
                 );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1, 1) async06(
                         .clk         (xgmii_clk              ),
                         .data_in     (write_pointer_pma_gray[6]    ),
                         .data_out    (write_pointer_xgmii_gray[6]  )
                 );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1, 1) async07(
                         .clk         (xgmii_clk              ),
                         .data_in     (write_pointer_pma_gray[7]    ),
                         .data_out    (write_pointer_xgmii_gray[7]  )
                 );

 assign write_pointer_xgmii_bin_shift[7] = write_pointer_xgmii_gray[7];
 assign write_pointer_xgmii_bin_shift[6] = write_pointer_xgmii_gray[6] ^ write_pointer_xgmii_bin_shift[7];
 assign write_pointer_xgmii_bin_shift[5] = write_pointer_xgmii_gray[5] ^ write_pointer_xgmii_bin_shift[6];
 assign write_pointer_xgmii_bin_shift[4] = write_pointer_xgmii_gray[4] ^ write_pointer_xgmii_bin_shift[5];
 assign write_pointer_xgmii_bin_shift[3] = write_pointer_xgmii_gray[3] ^ write_pointer_xgmii_bin_shift[4];
 assign write_pointer_xgmii_bin_shift[2] = write_pointer_xgmii_gray[2] ^ write_pointer_xgmii_bin_shift[3];
 assign write_pointer_xgmii_bin_shift[1] = write_pointer_xgmii_gray[1] ^ write_pointer_xgmii_bin_shift[2];
 assign write_pointer_xgmii_bin_shift[0] = write_pointer_xgmii_gray[0] ^ write_pointer_xgmii_bin_shift[1];

 `ifdef XFIPCS_FIFOCNTL
 assign write_pointer_xgmii_bin_nxt = write_pointer_xgmii_bin_shift < rx_fifo_depth ? write_pointer_xgmii_bin_shift :
                                                                                      {rx_fifo_depth[6:0], 1'b0} + write_pointer_xgmii_bin_shift ;
 `else
 assign write_pointer_xgmii_bin_nxt = write_pointer_xgmii_bin_shift < 8'h8 ? write_pointer_xgmii_bin_shift :
                                                                             {7'h8, 1'b0} + write_pointer_xgmii_bin_shift ;
 `endif

 assign read_minus_write = {1'b0, read_pointer_bin} - {1'b0, write_pointer_xgmii_bin} ;
 `ifdef XFIPCS_FIFOCNTL
 assign small_read_minus_write = {rx_fifo_depth, 1'b0} + read_minus_write ;
 `else
 assign small_read_minus_write = {8'h8, 1'b0} + read_minus_write ;
 `endif
 assign r_w_pointer_diff = read_minus_write[8] ? small_read_minus_write[7:0] : read_minus_write[7:0];

 // read_pointer_xgmii_bin is 2-3 cycles off actual value.
 assign read_minus_write_0 =  r_w_pointer_diff == 8'h03 ;
 assign read_minus_write_1 =  r_w_pointer_diff == 8'h04 ;
 assign read_minus_write_2 =  r_w_pointer_diff == 8'h05 ;
 assign read_minus_write_3 =  r_w_pointer_diff == 8'h06 ;
 assign read_minus_write_4 =  r_w_pointer_diff == 8'h07 ;
 assign read_minus_write_5 =  r_w_pointer_diff == 8'h08 ;
 assign read_minus_write_6 =  r_w_pointer_diff == 8'h09 ;
 assign read_minus_write_7 =  r_w_pointer_diff == 8'h0a ;
 assign read_minus_write_8 =  r_w_pointer_diff == 8'h0b ;
 `ifdef XFIPCS_FIFOCNTL
 assign read_minus_write_9 =  ({rx_fifo_depth, 1'b0} == 9'h0c) ? r_w_pointer_diff == 8'h00 : r_w_pointer_diff == 8'h0c;
 assign read_minus_write_10 = ({rx_fifo_depth, 1'b0} == 9'h0c) ? r_w_pointer_diff == 8'h01 : r_w_pointer_diff == 8'h0d;
 assign read_minus_write_11 = ({rx_fifo_depth, 1'b0} == 9'h0c) ? r_w_pointer_diff == 8'h02 : r_w_pointer_diff == 8'h0e;
 `else
 assign read_minus_write_9 =  (r_w_pointer_diff == 8'h0c);
 assign read_minus_write_10 = (r_w_pointer_diff == 8'h0d);
 assign read_minus_write_11 = (r_w_pointer_diff == 8'h0e);
 `endif

 // Overflow:  (W-R) = 2 away from eachother = 2
 // Underflow: (W-R) = -2 away from eachother, so W-R = 0 when you take into account that r_w_pointer_diff is 2 cycles off
 `ifdef XFIPCS_FIFOCNTL
 assign rx_underflow_count_nxt = ((reset_count < 4'hf) | RX_FIFO_BYPASS)                   ? 3'h0 :
                                 ({1'b0,r_w_pointer_diff} == ({rx_fifo_depth, 1'b0} - 9'h01)) ? rx_underflow_count + 1 :
                                 (rx_underflow_count != 3'h0)                              ? rx_underflow_count + 1 :
                                                                                             3'h0;

 assign rx_overflow_count_nxt = ((reset_count < 4'hf) | RX_FIFO_BYPASS) ? 3'h0 :
                                (read_minus_write_2)                    ? rx_overflow_count + 1 :
                                (rx_overflow_count != 3'h0)             ? rx_overflow_count + 1 :
                                                                          3'h0 ;
 assign rx_overflow  = (rx_overflow_count  != 3'h0);
 assign rx_underflow = (rx_underflow_count != 3'h0);
 `endif

 assign rem_clear = read_minus_write_6 | read_minus_write_7;
 assign rem_req_new = (read_minus_write_3 | read_minus_write_4) && rem_req_count == 3'b111;
 assign add_req_count_nxt = add_req                 ? 3'b000 :
                            add_req_count == 3'b111 ? 3'b111 :
                                                      add_req_count + 1;

 assign add_clear = read_minus_write_4 | read_minus_write_5;
 assign add_req_new = (read_minus_write_7 | read_minus_write_8 | read_minus_write_9 | read_minus_write_10 | read_minus_write_11)
                           && add_req_count == 3'b111;

 assign rem_req_count_nxt = rem_req                 ? 3'b000 :
                            rem_req_count == 3'b111 ? 3'b111 :
                                                      rem_req_count + 1;

 assign add_req_in = reset_count[3] &&
                     (add_req || add_req_new) && ~add_clear;

 assign rem_req_in = reset_count[3] &&
                     (rem_req || rem_req_new) && ~rem_clear;

 `ifdef XFIPCS_FIFOCNTL
 assign t_slower = ~rx_local_fault_xgmii &&
                 ((r_data2[35] == 1'h1 && r_data2[31:24] == 8'hfd) ||
                  (r_data2[34] == 1'b1 && r_data2[23:16] == 8'hfd) ||
                  (r_data2[33] == 1'b1 && r_data2[15:8]  == 8'hfd) ||
                  (r_data2[32] == 1'b1 && r_data2[7:0]   == 8'hfd));
 assign t_fupper = ~rx_local_fault_xgmii &&
                 ((r_data1[71] == 1'b1 && r_data1[67:60] == 8'hfd) ||
                  (r_data1[70] == 1'b1 && r_data1[59:52] == 8'hfd) ||
                  (r_data1[69] == 1'b1 && r_data1[51:44] == 8'hfd) ||
                  (r_data1[68] == 1'b1 && r_data1[43:36] == 8'hfd));
 assign t_flower = ~rx_local_fault_xgmii &&
                 ((r_data1[35] == 1'b1 && r_data1[31:24] == 8'hfd) ||
                  (r_data1[34] == 1'b1 && r_data1[23:16] == 8'hfd) ||
                  (r_data1[33] == 1'b1 && r_data1[15:8]  == 8'hfd) ||
                  (r_data1[32] == 1'b1 && r_data1[7:0]   == 8'hfd));

 assign lf_slower = (r_data1[35:0] == 36'h10100009C);
 assign lf_flower = (r_data1[71:36] == 36'h10100009C);
 assign lf_supper = (r_data2[35:0] == 36'h10100009C);
 assign lf_fupper = (r_data2[71:36] == 36'h10100009C);
 assign local_fault_on_none = !lf_slower & !lf_flower & !lf_supper & !lf_fupper;

 assign q_flower = ~rx_local_fault_xgmii && r_data1[35:32] == 4'h1 && r_data1[7:0] == 8'h9c ; 
 assign q_fupper = ~rx_local_fault_xgmii && r_data1[71:68] == 4'h1 && r_data1[43:36] == 8'h9c ;
 assign q_slower = ~rx_local_fault_xgmii && r_data2[35:32] == 4'h1 && r_data2[7:0] == 8'h9c ; 
 assign f_flower = ~rx_local_fault_xgmii && r_data1[35:32] == 4'h1 && r_data1[7:0] == 8'h5c ; 
 assign f_fupper = ~rx_local_fault_xgmii && r_data1[71:68] == 4'h1 && r_data1[43:36] == 8'h5c ;
 assign f_slower = ~rx_local_fault_xgmii && r_data2[35:32] == 4'h1 && r_data2[7:0] == 8'h5c ;
 assign i_slower = rx_local_fault_xgmii |
                   ((r_data2[35:32] == 4'hf) &
                    ((r_data2[31:0] == 32'h07070707) | (r_data2[31:0] == 32'h06060606)));
 assign i_fupper = rx_local_fault_xgmii |
                   ((r_data1[71:68] == 4'hf) &
                    ((r_data1[67:36] == 32'h07070707) | (r_data1[67:36] == 32'h06060606)));
 assign i_flower = rx_local_fault_xgmii |
                   ((r_data1[35:32] == 4'hf) &
                    ((r_data1[31:0] == 32'h07070707) | (r_data1[31:0] == 32'h06060606)));
 assign vi_slower = t_fupper == 1'b0 && i_slower;
 assign vi_fupper = t_flower == 1'b0 && i_fupper;
 assign q_pupper_nxt = flower[1] ? q_flower :
                       fupper[1] ? q_fupper : 
                       slower[1] ? q_slower : 1'b0 ;
 assign f_pupper_nxt = flower[1] ? f_flower :
                       fupper[1] ? f_fupper : 
                       slower[1] ? f_slower : 1'b0 ;
 `else
 assign t_slower = 1'b0;
 assign t_fupper = 1'b0;
 assign t_flower = 1'b0;

 assign lf_slower = 1'b0;
 assign lf_flower = 1'b0;
 assign lf_supper = 1'b0;
 assign lf_fupper = 1'b0;
 assign local_fault_on_none = 1'b1;

 assign q_flower = 1'b0;
 assign q_fupper = 1'b0;
 assign q_slower = 1'b0;
 assign f_flower = 1'b0;
 assign f_fupper = 1'b0;
 assign f_slower = 1'b0;
 assign i_slower = rx_local_fault_xgmii;
 assign i_fupper = rx_local_fault_xgmii;
 assign i_flower = rx_local_fault_xgmii;
 assign vi_slower = i_slower;
 assign vi_fupper = i_fupper;
 assign q_pupper_nxt = 1'b0;
 assign f_pupper_nxt = 1'b0;
 `endif

 assign vi_flower = t_pupper == 1'b0 && i_flower;

 always @(*) begin
     casex ({rx_local_fault_xgmii, rx_fifo_state, add_req, rem_req, vi_flower,
             vi_fupper, vi_slower, i_flower, i_fupper, i_slower, q_pupper,
             q_flower, q_fupper, q_slower, f_pupper, f_flower, f_fupper})
       17'b1xxx_xxx_xxx_xxxx_xxx : rx_fifo_cntl = 11'b0_00_0110_0000;   // reset
       17'b0000_xxx_xxx_xxxx_xxx : rx_fifo_cntl = 11'b0_00_0110_0000;   // no reqs
 `ifdef XFIPCS_TOPLEVELNAME_WIS_ENABLED
       17'b001x_xxx_1xx_xxxx_xxx : rx_fifo_cntl = 11'b0_01_1100_0000;   // duplicate idle twice
 `else
       17'b001x_xxx_1xx_xxxx_xxx : rx_fifo_cntl = 11'b1_01_1100_0000;   // duplicate low idle
 `endif
       17'b001x_xxx_x1x_xxxx_xxx : rx_fifo_cntl = 11'b1_01_0110_0000;   // duplicate high idle
 `ifdef XFIPCS_TOPLEVELNAME_WIS_ENABLED
       17'b001x_xxx_xxx_1xxx_xxx : rx_fifo_cntl = 11'b0_01_0000_0000;   // add 2 idles after prev hi Q
 `else
       17'b001x_xxx_xxx_1xxx_xxx : rx_fifo_cntl = 11'b1_01_1000_0000;   // add idle after prev hi Q
 `endif
       17'b001x_xxx_xxx_x1xx_xxx : rx_fifo_cntl = 11'b1_01_0100_0000;   // add idle after low Q
 `ifdef XFIPCS_TOPLEVELNAME_WIS_ENABLED
       17'b001x_xxx_xxx_xxxx_1xx : rx_fifo_cntl = 11'b0_01_0000_0000;   // add 2 idles after prev hi Fsig
 `else
       17'b001x_xxx_xxx_xxxx_1xx : rx_fifo_cntl = 11'b1_01_1000_0000;   // add idle after prev hi Fsig
 `endif
       17'b001x_xxx_xxx_xxxx_x1x : rx_fifo_cntl = 11'b1_01_0100_0000;   // add idle after low Fsig
       17'b001x_xxx_xxx_xxxx_xxx : rx_fifo_cntl = 11'b0_00_0110_0000;   // no valid idles to add
       17'b0001_1xx_xxx_xxxx_xxx : rx_fifo_cntl = 11'b1_00_0001_1000;   // remove low idle
       17'b0001_x1x_xxx_xxxx_xxx : rx_fifo_cntl = 11'b1_00_0100_1000;   // remove high idle
       17'b0001_xxx_xxx_11xx_xxx : rx_fifo_cntl = 11'b1_00_0001_1000;   // remove low /O/
       17'b0001_xxx_xxx_x11x_xxx : rx_fifo_cntl = 11'b1_00_0100_1000;   // remove high /O/
       17'b0001_xxx_xxx_xxxx_xxx : rx_fifo_cntl = 11'b0_00_0110_0000;   // no valid idles or /O/ to rem
       17'b0100_xxx_xxx_xxxx_xxx : rx_fifo_cntl = 11'b1_00_0001_1000;   // no reqs
 `ifdef XFIPCS_TOPLEVELNAME_WIS_ENABLED
       17'b011x_xxx_x1x_xxxx_xxx : rx_fifo_cntl = 11'b1_01_0011_0000;   // duplicate low idle twice
 `else
       17'b011x_xxx_x1x_xxxx_xxx : rx_fifo_cntl = 11'b0_00_0011_0000;   // duplicate low idle
 `endif
       17'b011x_xxx_xx1_xxxx_xxx : rx_fifo_cntl = 11'b0_00_0001_1000;   // duplicate high idle
 `ifdef XFIPCS_TOPLEVELNAME_WIS_ENABLED
       17'b011x_xxx_xxx_x1xx_xxx : rx_fifo_cntl = 11'b1_01_0000_0000;   // add 2 idles after prev hi Q
 `else
       17'b011x_xxx_xxx_x1xx_xxx : rx_fifo_cntl = 11'b0_00_0010_0000;   // add idle after prev hi Q
 `endif
       17'b011x_xxx_xxx_xx1x_xxx : rx_fifo_cntl = 11'b0_00_0001_0000;   // add idle after low Q
 `ifdef XFIPCS_TOPLEVELNAME_WIS_ENABLED
       17'b011x_xxx_xxx_xxxx_x1x : rx_fifo_cntl = 11'b1_01_0000_0000;   // add 2 idles after prev hi Fsig
 `else
       17'b011x_xxx_xxx_xxxx_x1x : rx_fifo_cntl = 11'b0_00_0010_0000;   // add idle after prev hi Fsig
 `endif
       17'b011x_xxx_xxx_xxxx_xx1 : rx_fifo_cntl = 11'b0_00_0001_0000;   // add idle after low Fsig
       17'b011x_xxx_xxx_xxxx_xxx : rx_fifo_cntl = 11'b1_00_0001_1000;   // no valid idles to add
       17'b0101_x1x_xxx_xxxx_xxx : rx_fifo_cntl = 11'b0_10_0000_0110;   // remove low idle
       17'b0101_xx1_xxx_xxxx_xxx : rx_fifo_cntl = 11'b0_10_0001_0010;   // remove high idle
       17'b0101_xxx_xxx_x11x_xxx : rx_fifo_cntl = 11'b0_10_0000_0110;   // remove low /O/
       17'b0101_xxx_xxx_xx11_xxx : rx_fifo_cntl = 11'b0_10_0001_0010;   // remove high /O/
       17'b0101_xxx_xxx_xxxx_xxx : rx_fifo_cntl = 11'b1_00_0001_1000;   // no valid idles or /O/ to rem
       default  : rx_fifo_cntl = 11'b0_00_0110_0000;   // not reachable
     endcase
   end

 assign rx_fifo_state_in = rx_fifo_cntl[10];
 assign skip_pointer = rx_fifo_cntl[9] || (rem_req && rx_local_fault_xgmii);
 assign hold_pointer = rx_fifo_cntl[8] || (add_req && rx_local_fault_xgmii);
 assign flower = rx_fifo_cntl[7:6];
 assign fupper = rx_fifo_cntl[5:4];
 assign slower = rx_fifo_cntl[3:2];
 assign supper = rx_fifo_cntl[1:0];

 assign read_pointer_bin_nxt = reset_to_xgmii_rx_3       ? 8'h06 :
                               skip_pointer ? read_pointer_bin + 2 :
                               hold_pointer ? read_pointer_bin :
                               read_pointer_bin + 1 ;
 assign read_pointer_2_bin_nxt = reset_to_xgmii_rx_3      ? 8'h07 :
                                 skip_pointer ? read_pointer_2_bin + 2 :
                                 hold_pointer ? read_pointer_2_bin :
                                 read_pointer_2_bin + 1 ;

 assign reset_count_nxt = ~rx_prbs_pat_en_xgmii_prev && rx_prbs_pat_en_xgmii ? 4'h0 :
                          rx_prbs_pat_en_xgmii && reset_count == 4'h4        ? 4'h4 :
                          reset_count == 4'hf                           ? 4'hf :
                                                               reset_count + 1 ;

 `ifdef XFIPCS_FIFOCNTL
 assign read_pointer_bin_in =
                    read_pointer_bin_nxt == {rx_fifo_depth[6:0], 1'b0} ? 8'h00 :
                    read_pointer_bin_nxt == {rx_fifo_depth[6:0], 1'b1} ? 8'h01 :
                                                          read_pointer_bin_nxt ;

 assign read_pointer_2_bin_in =
                  read_pointer_2_bin_nxt == {rx_fifo_depth[6:0], 1'b0} ? 8'h00 :
                  read_pointer_2_bin_nxt == {rx_fifo_depth[6:0], 1'b1} ? 8'h01 :
                                                        read_pointer_2_bin_nxt ;
 `else
 assign read_pointer_bin_in =
                    read_pointer_bin_nxt == {7'h8, 1'b0} ? 8'h00 :
                    read_pointer_bin_nxt == {7'h8, 1'b1} ? 8'h01 :
                                            read_pointer_bin_nxt ;
  
 assign read_pointer_2_bin_in =
                  read_pointer_2_bin_nxt == {7'h8, 1'b0} ? 8'h00 :
                  read_pointer_2_bin_nxt == {7'h8, 1'b1} ? 8'h01 :
                                          read_pointer_2_bin_nxt ;
 `endif

 assign reset_count_pma_rx_nxt = (internal_reset)                         ? 4'h0 :
                                 (reset_count_pma_rx == 4'hf)             ? 4'hf : reset_count_pma_rx + 4'h1;

 assign write_enable_nxt = (internal_reset)                                         ? 1'b0 :
                           (~internal_reset_pma_rx && (reset_count_pma_rx == 4'h6)) ? 1'b1 : write_enable;

 always @(posedge pma_rx_clk)
   begin
    if (reset_pma_rx || rx_prbs_pat_en_pma) begin
     write_pointer_pma_bin       <= 8'h00;
     write_pointer_pma_bin_shift <= 8'h00;
     data_valid_2                <= 1'b0;
     data_valid_3                <= 1'b0;
     reset_count_pma_rx          <= 4'h0;
    end else begin
     write_pointer_pma_bin       <= write_pointer_pma_bin_nxt;
     write_pointer_pma_bin_shift <= write_pointer_pma_bin_shift_nxt;
     data_valid_2                <= data_valid;
     data_valid_3                <= data_valid_2;
     reset_count_pma_rx          <= reset_count_pma_rx_nxt;
    end

    if (reset_to_pma_rx || rx_prbs_pat_en_pma) begin
     write_pointer_lpi_start     <= 8'h00;
     internal_reset              <= 1'b0;
     internal_reset_count        <= 4'h0;
     lpi_check_state             <= IDLE;
     write_enable <= 1'b0;
    end else begin
     write_pointer_lpi_start     <= write_pointer_lpi_start_nxt;
     internal_reset              <= internal_reset_nxt;
     internal_reset_count        <= internal_reset_count_nxt;
     lpi_check_state             <= lpi_check_state_nxt;
     write_enable                <= write_enable_nxt;
    end

    write_pointer_pma_gray <= write_pointer_pma_gray_nxt;
    rx_lpi_active_pma_rx_prev <= rx_lpi_active_pma_rx;
    write_pointer_pma_bin_prev <= write_pointer_pma_bin;
   end

 always @(posedge xgmii_clk)
   begin
    if (reset_to_xgmii_rx_3 || rx_prbs_pat_en_xgmii) begin
     write_pointer_xgmii_bin <= 8'h00;
     read_pointer_bin        <= 8'h05;
     read_pointer_2_bin      <= 8'h06;
    end else begin
     write_pointer_xgmii_bin <= write_pointer_xgmii_bin_nxt;
     read_pointer_bin  <= read_pointer_bin_in;
     read_pointer_2_bin <= read_pointer_2_bin_in;
    end

    if (reset_xgmii) begin
     add_req_count <= 3'b000;
     rem_req_count <= 3'b000;
     reset_count <= 4'h0;
    end else begin
     add_req_count <= add_req_count_nxt;
     rem_req_count <= rem_req_count_nxt;
     reset_count <= reset_count_nxt;
    end

    reset_to_xgmii_rx_2 <= reset_xgmii;
    reset_to_xgmii_rx_3 <= reset_to_xgmii_rx_2 ;
    rx_prbs_pat_en_xgmii_prev <= rx_prbs_pat_en_xgmii ;
    add_req <= add_req_in;
    rem_req <= rem_req_in;
    rx_fifo_state <= rx_fifo_state_in;
    t_pupper <= t_fupper;
    q_pupper <= q_pupper_nxt;
    f_pupper <= f_pupper_nxt;
    `ifdef XFIPCS_FIFOCNTL
    rx_overflow_count <= rx_overflow_count_nxt;
    rx_underflow_count <= rx_underflow_count_nxt;
    `endif
   end
 
 `ifdef XFIPCS_FIFOCNTL
 assign rxc_sdr_lower = flower[0] == 1'b1                     ? r_data1[35:32] :
                        fupper[0] == 1'b1                     ? r_data1[71:68] :
                        slower[0] == 1'b1                     ? r_data2[35:32] :
                        supper[0] == 1'b1                     ? r_data2[71:68] :
                                                                          4'hf ;
 assign rxc_sdr_upper = flower[1] == 1'b1                     ? r_data1[35:32] :
                        fupper[1] == 1'b1                     ? r_data1[71:68] :
                        slower[1] == 1'b1                     ? r_data2[35:32] :
                        supper[1] == 1'b1                     ? r_data2[71:68] :
                                                                          4'hf ;
 assign rxd_sdr_lower = flower[0] == 1'b1                     ? r_data1[31: 0] :
                        fupper[0] == 1'b1                     ? r_data1[67:36] :
                        slower[0] == 1'b1                     ? r_data2[31: 0] :
                        supper[0] == 1'b1                     ? r_data2[67:36] :
                                                                  32'h07070707 ;
 assign rxd_sdr_upper = flower[1] == 1'b1                     ? r_data1[31: 0] :
                        fupper[1] == 1'b1                     ? r_data1[67:36] :
                        slower[1] == 1'b1                     ? r_data2[31: 0] :
                        supper[1] == 1'b1                     ? r_data2[67:36] :
                                                                  32'h07070707 ;

 assign rxc_sdr = {rxc_sdr_upper, rxc_sdr_lower};
 assign rxd_sdr = {rxd_sdr_upper, rxd_sdr_lower};
 `endif

endmodule
