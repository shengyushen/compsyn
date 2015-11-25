//SCCS File Version= %I% 
//Release Date= 14/04/20  19:56:57 GMT startFileName /vobs/vob012/xfipcs/verilog/rtl/XFIPCS_RX_PCS.v endFileName  

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

//$Id: XFIPCS_RX_PCS.v,v 1.8 2014/02/21 07:12:00 huqian Exp $
//$Log: XFIPCS_RX_PCS.v,v $
//Revision 1.8  2014/02/21 07:12:00  huqian
//Copy XFIPCS cvs tag v1_135
//
//Revision 1.47  2014/02/21 06:51:28  huqian
//Fix HW280868
//
//Revision 1.46  2014/02/18 07:36:15  huqian
//Condor 4 ASIC FC-EE Support Requirements.pdf item3
//
//Revision 1.45  2014/02/17 08:47:24  huqian
//Condor 4 ASIC FC-EE Support Requirements.pdf item2
//
//Revision 1.44  2014/02/13 08:44:27  huqian
//Add registers ber_timer_value 1 and ber_timer_value 2
//
//Revision 1.43  2014/02/10 09:11:21  huqian
//Fix compile error when XFIPCS_16G32GFC is commented out
//
//Revision 1.42  2014/02/10 06:03:41  huqian
//Fix HW278923: The BER FSM is wrong
//
//Revision 1.41  2014/01/23 08:06:45  huqian
//Add support of 16G XGMII_CLK running at 425M or 212.5M
//
//Revision 1.40  2014/01/07 05:45:18  huqian
//Update the values of 16G32G LPI timing parameters according to FC-FS-4
//
//Revision 1.39  2013/12/26 05:23:53  huqian
//Update reg_32768/32771/32773 definition for 16G32G; Update reg_32768/32769/32770/32771/32772/32773 reset value for 32G
//
//Revision 1.38  2013/12/18 08:32:53  huqian
//Add synthesis option to remove RX FIFO control(clock compensation) logic and RX XGMII data interface
//
//Revision 1.37  2013/12/12 03:29:20  huqian
//Modify XFIPCS_32GFC macro define to XFIPCS_16G32GFC
//
//Revision 1.36  2013/09/27 05:09:43  huqian
//HW268848: rx_lpi_active_pma_rx signal appears 'X' state
//
//Revision 1.35  2013/09/17 05:54:15  huqian
//Initial 32G Fibre Channel
//
//Revision 1.34  2011/05/06 14:50:06  adamc
//Added fifo_we to lfault mux logic
//
//Revision 1.33  2011/04/22 03:04:34  adamc
//WAM update
//
//Revision 1.32  2011/04/20 20:28:02  adamc
//Leda fixes
//
//Revision 1.31  2011/04/19 01:59:50  adamc
//Update to datapath to help LFAULT to DATA transition
//
//Revision 1.30  2011/04/15 21:33:05  adamc
//Update to RX_PCS to aid in LFAULT exiting
//
//Revision 1.29  2011/04/15 13:58:33  adamc
//0in fix for RX_PCS
//
//Revision 1.28  2011/03/29 18:44:00  adamc
//cvs_snap v1_83
//
//Revision 1.27  2011/03/29 13:48:09  adamc
//Update to FIFO underflow and overflow logic
//
//Revision 1.24  2011/03/20 01:10:03  adamc
//Gating toplevel RX fifo write by rx_fifo_internal reset
//
//Revision 1.23  2011/03/16 23:46:57  adamc
//cvs_snap v1_60
//
//Revision 1.22  2011/03/16 17:11:00  adamc
//cvs_snap v1_58
//
//Revision 1.21  2011/03/15 19:45:37  adamc
//cvs_snap v1_54
//
//Revision 1.20  2011/03/10 20:32:55  adamc
//cvs_snap v1_1
//
//Revision 1.19  2011/03/08 15:19:20  adamc
//cvs_snap v1_46
//
//Revision 1.18  2011/03/07 21:26:29  adamc
//cvs_snap v1_44
//
//Revision 1.17  2011/03/03 19:33:22  adamc
//cvs_snap v1_36
//
//Revision 1.15  2011/02/21 21:45:58  adamc
//cvs_snap v1_29
//
//Revision 1.14  2011/02/14 16:06:53  adamc
//cvs_snap v1_27
//
//Revision 1.13  2011/02/08 16:05:11  adamc
//cvs_snap v1_22
//
//Revision 1.12  2011/01/31 15:53:30  adamc
//Fixed r_type_idle vs r_type_li logic
//
//Revision 1.11  2011/01/28 19:10:48  adamc
//cvs_snap v1_16
//
//Revision 1.10  2011/01/25 21:26:15  adamc
//Updated reset logic
//
//Revision 1.9  2011/01/19 17:25:04  adamc
//Added *xREFRESH logic
//
//Revision 1.8  2011/01/14 15:08:11  adamc
//added separate resets for RX fifo
//
//Revision 1.7  2011/01/12 20:29:06  adamc
//Moved rx_lpi_fsm itno xgmii domain
//
//Revision 1.5  2010/12/15 19:54:06  adamc
//Added synchronizers to scr_bypass_enable
//
//Revision 1.4  2010/12/13 21:33:38  adamc
//Fixed floating nets and heads up signals
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

module `XFIPCS_TOPLEVELNAME_RX_PCS (
                        pma_rx_clk,
`ifdef XFIPCS_16G32GFC
                        pma_rx_clk_div2,
                        pma_rx_clk_div2_high,
`endif                        
                        xgmii_clk,
                        reset_to_pma_rx,
`ifdef XFIPCS_16G32GFC
                        reset_to_pma_rx_div2,
                        speed_sel_xgmii,
                        XGMIICLK_425M,
                        lpi_fw,
                        rx_tw_timer_value,
`endif
                        reset_to_xgmii_rx,

                        enable_alternate_refresh,
                        ALTERNATE_ENCODE,
                        rx_block_lock,
                        data_valid,
                        hi_ber,
                        loopback_reset,
                        prbs_data,
                        r_test_mode,
                        rx_data_66b,
`ifdef XFIPCS_FIFOCNTL                        
                        rx_fifo_depth,
                        rx_rdata_p1,
                        rx_rdata_p2,
`endif                        
                        clear_tpec_tog,
                        rx_prbs_pat_en,
                        rx_test_pat_en,
                        test_pat_sel,
                        energy_detect,
                        scr_bypass_enable,
                        rx_hss_t1_value,
                        rx_hss_t3_value,
                        rx_hss_t6_value,

                        tpec_pma_gray,
                        tpec_15_8_inc_tog,
`ifdef XFIPCS_FIFOCNTL                        
                        rx_raddr_p1,
                        rx_raddr_p2,
                        rx_waddr_p1,
                        rx_overflow,
                        rx_underflow,
                        rxc_sdr,
                        rxd_sdr,
`endif                        
                        inc_ebc,
                        rx_local_fault_xgmii,
                        rxc_xfi,
                        rxd_xfi,
                        block_lock,
                        rx_lpi_active,
                        rx_lpi_active_pma_rx,
                        rx_mode,
                        r_type_li,
                        wake_error_counter_inc,
                        RXxQUIET,
                        RXxREFRESH,
                        pcs_r_status_xgmii,
                        rx_we_p1
                );

// ----------------------------------------------------------------------------
// Inputs/Outputs
// ----------------------------------------------------------------------------
input                   pma_rx_clk;
`ifdef XFIPCS_16G32GFC
input                   pma_rx_clk_div2;
input                   pma_rx_clk_div2_high;
`endif
input                   xgmii_clk;
input                   reset_to_pma_rx;
`ifdef XFIPCS_16G32GFC
input                   reset_to_pma_rx_div2;
input                   speed_sel_xgmii;
input                   XGMIICLK_425M;
input                   lpi_fw;
input   [12:0]          rx_tw_timer_value;
`endif
input                   reset_to_xgmii_rx;

input                   enable_alternate_refresh;
input                   rx_block_lock;
input                   data_valid;
input                   hi_ber;
input                   loopback_reset;
input                   r_test_mode;
input   [31:0]          prbs_data;
input   [65:0]          rx_data_66b;
`ifdef XFIPCS_FIFOCNTL
input   [7:0]           rx_fifo_depth;
input   [71:0]          rx_rdata_p1;
input   [71:0]          rx_rdata_p2;
`endif
input                   clear_tpec_tog;
input                   rx_prbs_pat_en;
input                   rx_test_pat_en;
input                   test_pat_sel;
input                   ALTERNATE_ENCODE;
input                   energy_detect;
input                   scr_bypass_enable;
`ifdef XFIPCS_16G32GFC
input   [17:0]          rx_hss_t1_value;
input   [17:0]          rx_hss_t6_value;
`else
input   [15:0]          rx_hss_t1_value;
input   [15:0]          rx_hss_t6_value;
`endif
input   [15:0]          rx_hss_t3_value;

`ifdef XFIPCS_FIFOCNTL
output  [7:0]           rx_raddr_p1;
output  [7:0]           rx_raddr_p2;
output  [7:0]           rx_waddr_p1;
output                  rx_overflow;
output                  rx_underflow;
output  [7:0]           rxc_sdr;
output  [63:0]          rxd_sdr;
`endif
output                  inc_ebc;
output                  rx_local_fault_xgmii;
output  [7:0]           rxc_xfi;
output  [63:0]          rxd_xfi;
output  [7:0]           tpec_pma_gray;
output                  tpec_15_8_inc_tog;
output                  block_lock;
output                  rx_lpi_active;
output                  rx_lpi_active_pma_rx;
output                  rx_mode;
output                  r_type_li;
output                  wake_error_counter_inc;
output                  RXxQUIET;
output                  RXxREFRESH;
output                  pcs_r_status_xgmii;
output                  rx_we_p1;

// ----------------------------------------------------------------------------
// Internal signals/registers
// ----------------------------------------------------------------------------
`ifdef XFIPCS_FIFOCNTL
wire    [7:0]           rx_raddr_p1;
wire    [7:0]           rx_raddr_p2;
wire    [7:0]           rx_waddr_p1;
wire                    rx_overflow;
wire                    rx_underflow;
wire    [7:0]           rxc_sdr;
wire    [63:0]          rxd_sdr;
wire    [7:0]           rxc_sdr_pre;
wire    [63:0]          rxd_sdr_pre;
`endif
wire                    inc_ebc;
wire                    rx_local_fault;
wire                    rx_local_fault_xgmii;
wire                    data_valid_3;

wire    [7:0]           rxc_xfi;
wire    [63:0]          rxd_xfi;
wire    [7:0]           decoder_control_out;
wire    [63:0]          decoder_data_out;
wire    [7:0]           tpec_pma_gray;

wire    [7:0]           block_type_field ;
wire    [65:0]          descrambled_data_out;

wire    [8:0]           rx_hold_counter_nxt;
wire                    rx_output_local_fault_xgmii;
reg     [8:0]           rx_hold_counter;
reg                     rx_prbs_pat_en_prev;
wire                    rx_prbs_pat_en_pma;

wire                    block_lock;
wire                    block_lock_pma_rx;

wire                    scr_bypass_enable;

wire                    rx_lpi_active;
wire                    rx_lpi_active_pma_rx;

wire                    r_type_li;
wire                    r_type_li_xgmii;
wire                    r_type_li_xgmii_gated;
wire                    r_type_idle;
wire                    r_type_idle_xgmii;
wire                    r_type_idle_xgmii_gated;

wire                    pcs_r_status;
wire                    pcs_r_status_xgmii;

wire                    local_fault_on_none;
reg                     local_fault_on_none_prev;
reg                     local_fault_done;
wire                    local_fault_done_nxt;
wire                    rx_block_lock_xgmii;
wire                    energy_detect_xgmii;

wire                    rx_fifo_we;
wire                    rx_we_p1;

// ----------------------------------------------------------------------------
// Parameters
// ----------------------------------------------------------------------------
parameter RX_FIFO_BYPASS = 1'b0;
parameter DATA  = 1'b0;
parameter QUIET = 1'b1;

// ----------------------------------------------------------------------------
// Implementation
// ----------------------------------------------------------------------------
 assign block_type_field = descrambled_data_out[9:2];

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(.NO_XSTATE(1)) async012(
                         .clk         (xgmii_clk),
                         .data_in     (pcs_r_status),
                         .data_out    (pcs_r_status_xgmii)
                 );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async001(
                         `ifdef XFIPCS_16G32GFC
                         .clk         (pma_rx_clk_div2),
                         `else
                         .clk         (pma_rx_clk),
                         `endif
                         .data_in     (rx_prbs_pat_en),
                         .data_out    (rx_prbs_pat_en_pma)
                 );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async014(
                         .clk         (xgmii_clk),
                         .data_in     (rx_fifo_we),
                         .data_out    (rx_fifo_we_xgmii)
                 );


 `XFIPCS_TOPLEVELNAME_64B66B_DEC dec(
                         `ifdef XFIPCS_16G32GFC
                         .CLK                    (pma_rx_clk_div2        ),
                         .RESET                  (reset_to_pma_rx_div2   ),
                         `else
                         .CLK                    (pma_rx_clk             ),
                         .RESET                  (reset_to_pma_rx        ),
                         `endif

                         .ALTERNATE_ENCODE       (ALTERNATE_ENCODE),
                         .DECODER_DATA_IN        (rx_data_66b            ),
                         .DATA_VALID             (data_valid             ),

                         .DECODER_CONTROL_OUT    (decoder_control_out    ),
                         .DECODER_DATA_OUT       (decoder_data_out       ),
                         .DESCRAMBLED_DATA_OUT   (descrambled_data_out   )
                 );

 `XFIPCS_TOPLEVELNAME_RX_FLOW  rx_flow(
                         `ifdef XFIPCS_16G32GFC
                         .pma_rx_clk                 (pma_rx_clk_div2        ),
                         .reset_to_pma_rx            (reset_to_pma_rx_div2   ),
                         `else
                         .pma_rx_clk                 (pma_rx_clk             ),
                         .reset_to_pma_rx            (reset_to_pma_rx        ),
                         `endif

                         .block_type_field           (block_type_field       ),
                         .decoder_control_out        (decoder_control_out    ),
                         .decoder_data_out           (decoder_data_out       ),
                         .data_valid                 (data_valid             ),
                         .r_test_mode                (r_test_mode            ),
                         .hi_ber                     (hi_ber                 ),
                         .block_lock                 (block_lock_pma_rx      ),
                         .rx_sync_header             (rx_data_66b[1:0]       ),
                         .rx_lpi_active              (rx_lpi_active_pma_rx      ),

                         .data_valid_3               (data_valid_3           ),
                         .inc_ebc                    (inc_ebc                ),
                         .rx_local_fault             (rx_local_fault         ),
                         .rxc_xfi                    (rxc_xfi                ),
                         .rxd_xfi                    (rxd_xfi                ),
                         .r_type_li                  (r_type_li              ),
                         .r_type_idle                (r_type_idle            ),
                         .pcs_r_status               (pcs_r_status           )
                 );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(.NO_XSTATE(1)) async007(
                         .clk         (xgmii_clk),
                         .data_in     (rx_block_lock),
                         .data_out    (rx_block_lock_xgmii)
                 );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async008(
                         .clk         (xgmii_clk),
                         .data_in     (energy_detect),
                         .data_out    (energy_detect_xgmii)
                 );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async009(
                         .clk         (xgmii_clk),
                         .data_in     (r_type_li),
                         .data_out    (r_type_li_xgmii)
                 );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async010(
                         .clk         (xgmii_clk),
                         .data_in     (r_type_idle),
                         .data_out    (r_type_idle_xgmii)
                 );

 // Gate idle based on li since both can't be active at same time
 // (however we may see that do to DRS)
 assign r_type_li_xgmii_gated   = r_type_li_xgmii   & ~r_type_idle_xgmii;
 assign r_type_idle_xgmii_gated = r_type_idle_xgmii & ~r_type_li_xgmii;

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async011(
                         .clk         (pma_rx_clk),
                         .data_in     (rx_lpi_active),
                         .data_out    (rx_lpi_active_pma_rx)
                 );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async013(
                         .clk         (pma_rx_clk),
                         .data_in     (block_lock),
                         .data_out    (block_lock_pma_rx)
                 );

 `XFIPCS_TOPLEVELNAME_RX_LPI_FSM rx_lpi_fsm(
  .clk                        (xgmii_clk                 ),
  .reset                      (reset_to_xgmii_rx         ),
  .enable_alternate_refresh   (enable_alternate_refresh  ),
  .r_type_li                  (r_type_li_xgmii_gated     ),
  .r_type_idle                (r_type_idle_xgmii_gated   ),
  .rx_block_lock              (rx_block_lock_xgmii       ),
  .energy_detect              (energy_detect_xgmii       ),
  .scr_bypass_enable          (scr_bypass_enable         ),
  .rx_hss_t1_value            (rx_hss_t1_value           ),
  .rx_hss_t3_value            (rx_hss_t3_value           ),
  .rx_hss_t6_value            (rx_hss_t6_value           ),
  `ifdef XFIPCS_16G32GFC
  .speed_sel                  (speed_sel_xgmii           ),
  .XGMIICLK_425M              (XGMIICLK_425M             ),
  .lpi_fw                     (lpi_fw                    ),
  .rx_tw_timer_value          (rx_tw_timer_value         ),
  `endif

  .rx_mode                    (rx_mode                   ),
  .rx_lpi_active              (rx_lpi_active             ),
  .block_lock                 (block_lock                ),
  .wake_error_counter_inc     (wake_error_counter_inc    ),
  .RXxQUIET                   (RXxQUIET                  ),
  .RXxREFRESH                 (RXxREFRESH                )
 );

 `XFIPCS_TOPLEVELNAME_RX_FIFO #(.RX_FIFO_BYPASS(RX_FIFO_BYPASS)) rx_fifo(
                         `ifdef XFIPCS_16G32GFC
                         .pma_rx_clk             (pma_rx_clk_div2        ),
                         .reset_to_pma_rx        (reset_to_pma_rx_div2   ),
                         `else
                         .pma_rx_clk             (pma_rx_clk             ),
                         .reset_to_pma_rx        (reset_to_pma_rx        ),
                         `endif
                         .xgmii_clk              (xgmii_clk              ),
                         .reset_to_xgmii_rx      (reset_to_xgmii_rx      ),
                         .rx_lpi_active_pma_rx   (rx_lpi_active_pma_rx   ),

                         .rx_prbs_pat_en_pma     (rx_prbs_pat_en_pma     ),
                         .rx_prbs_pat_en_xgmii   (rx_prbs_pat_en         ),
                         .rx_local_fault_xgmii   (rx_local_fault_xgmii   ),
                         .data_valid             (data_valid             ),
                         `ifdef XFIPCS_FIFOCNTL
                         .rx_fifo_depth          (rx_fifo_depth          ),
                         .rx_rdata_p1            (rx_rdata_p1            ),
                         .rx_rdata_p2            (rx_rdata_p2            ),

                         .rx_raddr_p1            (rx_raddr_p1            ),
                         .rx_raddr_p2            (rx_raddr_p2            ),
                         .rx_waddr_p1            (rx_waddr_p1            ),
                         .rx_overflow            (rx_overflow            ),
                         .rx_underflow           (rx_underflow           ),
                         .rxc_sdr                (rxc_sdr_pre            ),
                         .rxd_sdr                (rxd_sdr_pre            ),
                         `endif
                         .local_fault_on_none    (local_fault_on_none    ),
                         .rx_fifo_we             (rx_fifo_we             )
                 );

 `XFIPCS_TOPLEVELNAME_RX_TPC tpc(
                         .pma_rx_clk             (pma_rx_clk             ),
                         .reset_to_pma_rx        (reset_to_pma_rx        ),
                         `ifdef XFIPCS_16G32GFC
                         .pma_rx_clk_div2_high   (pma_rx_clk_div2_high   ),
                         `endif

                         .block_lock             (block_lock_pma_rx      ),
                         .rx_prbs_pat_en         (rx_prbs_pat_en         ),
                         .rx_test_pat_en         (rx_test_pat_en         ),
                         .test_pat_sel           (test_pat_sel           ),
                         .prbs_data              (prbs_data              ),
                         .test_data_in           (descrambled_data_out   ),
                         .test_data_valid        (data_valid             ),
                         .clear_tpec_tog         (clear_tpec_tog         ),

                         .tpec_pma_gray          (tpec_pma_gray          ),
                         .tpec_15_8_inc_tog      (tpec_15_8_inc_tog      )
                 );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(.NO_XSTATE(1)) async003(.clk      (xgmii_clk),
                                         .data_in  (rx_local_fault),
                                         .data_out (rx_local_fault_xgmii)
                                        );

 `ifdef XFIPCS_FIFOCNTL
 assign rxc_sdr = rx_output_local_fault_xgmii ? 8'h11 : rxc_sdr_pre ;
 assign rxd_sdr = rx_output_local_fault_xgmii ? 64'h0100009c0100009c : rxd_sdr_pre ;
 `endif
 assign rx_we_p1 = data_valid_3 & rx_fifo_we;

 `ifdef XFIPCS_FIFOCNTL
 assign rx_hold_counter_nxt = rx_prbs_pat_en_prev && ~rx_prbs_pat_en   ? 9'h1e0 :
                              rx_hold_counter == {rx_fifo_depth, 1'b0} ? 9'h1df :
                              rx_hold_counter == 9'h1df                ? 9'h1df :
                                                                         rx_hold_counter + 1 ;
 `else
 assign rx_hold_counter_nxt = rx_prbs_pat_en_prev && ~rx_prbs_pat_en   ? 9'h1e0 :
                              rx_hold_counter == {8'h8, 1'b0} ? 9'h1df :
                              rx_hold_counter == 9'h1df                ? 9'h1df :
                                                                         rx_hold_counter + 1 ;
 `endif

 assign local_fault_done_nxt = ((rx_local_fault_xgmii & rx_fifo_we_xgmii) | (rx_hold_counter != 9'h1df)) ? 1'b0 :
                               (local_fault_done | (local_fault_on_none & ~local_fault_on_none_prev))    ? 1'b1 : local_fault_done;

 assign rx_output_local_fault_xgmii = rx_local_fault_xgmii | ~local_fault_done_nxt | (rx_hold_counter != 9'h1df) | loopback_reset;

 // xgmii flops
 always @(posedge xgmii_clk)
 begin
  if (reset_to_xgmii_rx || loopback_reset) begin
   rx_hold_counter <= 9'h1e0;
   local_fault_done <= 1'b0;
  end else begin
   rx_hold_counter <= rx_hold_counter_nxt;
   local_fault_done <= local_fault_done_nxt;
  end

  rx_prbs_pat_en_prev <= rx_prbs_pat_en;
  local_fault_on_none_prev <= local_fault_on_none;
 end

endmodule
