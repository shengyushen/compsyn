//SCCS File Version= %I% 
//Release Date= 14/04/20  19:57:20 GMT startFileName /vobs/vob012/xfipcs/verilog/rtl/XFIPCS_TX_PCS.v endFileName  

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

//$Id: XFIPCS_TX_PCS.v,v 1.9 2014/03/06 06:02:51 huqian Exp $
//$Log: XFIPCS_TX_PCS.v,v $
//Revision 1.9  2014/03/06 06:02:51  huqian
//Remove FEC_TX_MODE output pin
//
//Revision 1.8  2014/02/21 07:12:01  huqian
//Copy XFIPCS cvs tag v1_135
//
//Revision 1.28  2014/02/18 07:38:34  huqian
//Condor 4 ASIC FC-EE Support Requirements.pdf item3
//
//Revision 1.27  2014/02/17 08:50:56  huqian
//Condor 4 ASIC FC-EE Support Requirements.pdf item2
//
//Revision 1.26  2014/02/14 04:34:20  huqian
//Add TX_LPI_ACTIVE output
//
//Revision 1.25  2014/01/23 08:08:21  huqian
//Add support of very small skew between PMA_TX_CLK and PMA_TX_CLK_DIV2 rising edges
//
//Revision 1.24  2014/01/20 05:18:23  huqian
//Fix coding errors reported by Brocade(no functional change)
//
//Revision 1.23  2014/01/07 05:49:52  huqian
//Update the values of 16G32G LPI timing parameters according to FC-FS-4
//
//Revision 1.22  2014/01/06 09:39:23  huqian
//Delete FEC_SCRAMBLER_BYPASS output; Add FEC_TX_MODE output
//
//Revision 1.21  2014/01/06 03:17:31  huqian
//Add FEC_SCRAMBLER_BYPASS output; Registered FEC_TX_DATA_66B/FEC_TX_DATA_66B_VALID for timing closure
//
//Revision 1.20  2013/12/17 08:44:48  huqian
//Add synthesis option to remove TX FIFO control(clock compensation) logic and TX XGMII data interface
//
//Revision 1.19  2013/12/12 03:29:21  huqian
//Modify XFIPCS_32GFC macro define to XFIPCS_16G32GFC
//
//Revision 1.18  2013/12/11 08:37:26  huqian
//Update TX/RX datapath to add 66bit interface for 32GFC FEC
//
//Revision 1.17  2013/10/28 03:36:53  huqian
//Fix timing violation
//
//Revision 1.16  2013/09/27 05:19:48  huqian
//Fix HW268863: TX_RDATA_P1 signal appears 'X' state
//
//Revision 1.15  2013/09/17 06:07:30  huqian
//Initial 32G Fibre Channel
//
//Revision 1.14  2011/04/08 13:05:19  adamc
//Updated WAM on tx_active
//
//Revision 1.13  2011/03/11 19:38:28  adamc
//cvs_snap v1_50
//
//Revision 1.12  2011/03/07 21:26:29  adamc
//cvs_snap v1_44
//
//Revision 1.11  2011/03/03 19:33:22  adamc
//cvs_snap v1_36
//
//Revision 1.10  2011/02/14 16:06:54  adamc
//cvs_snap v1_27
//
//Revision 1.9  2011/02/07 20:10:35  adamc
//Update for async findings
//
//Revision 1.8  2011/01/26 14:26:44  adamc
//cvs_snap v1_13
//
//Revision 1.6  2011/01/12 20:28:05  adamc
//Added t_type_li output
//
//Revision 1.4  2010/12/15 19:54:06  adamc
//Added synchronizers to scr_bypass_enable
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

module `XFIPCS_TOPLEVELNAME_TX_PCS (
                        pma_tx_clk,
`ifdef XFIPCS_16G32GFC
                        pma_tx_clk_div2,
                        SPEED_SEL,
                        lpi_fw,
                        tx_tw_timer_value,
`endif
                        xgmii_clk,
                        reset_to_pma_tx,
`ifdef XFIPCS_16G32GFC
                        reset_to_pma_tx_div2,
                        ENABLE_TX_66B_OUT,
`endif
                        reset_to_xgmii_tx,

`ifdef XFIPCS_16G32GFC
                        FEC_TX_DATA_66B,
                        FEC_TX_DATA_66B_VALID,
                        TX_LPI_ACTIVE,
`endif
                        enable_alternate_refresh,
                        ALTERNATE_ENCODE,
                        loopback_xgmii,
`ifdef XFIPCS_FIFOCNTL                        
                        txc_sdr,
                        txd_sdr,
                        tx_fifo_depth,
`endif
                        tx_rdata_p1,
                        test_pat_seed_a,
                        test_pat_seed_b,
                        tx_prbs_pat_en,
                        tx_test_pat_en,
                        test_pat_sel,
                        data_pat_sel,
                        scr_bypass_enable,
                        tx_hss_t1_value,
                        tx_hss_t2_value,
                        tx_hss_t3_value,

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
                        tx_data_out,
                        tx_data_out_loopback,
                        tx_local_fault_xgmii,
                        tx_mode,
                        t_type_li,
                        tx_active_xgmii,
                        TXxQUIET,
                        TXxREFRESH
                );

// ----------------------------------------------------------------------------
// Inputs/Outputs
// ----------------------------------------------------------------------------
input           pma_tx_clk;
`ifdef XFIPCS_16G32GFC
input           pma_tx_clk_div2;
input           SPEED_SEL;
input           lpi_fw;
input   [12:0]  tx_tw_timer_value;
`endif
input           xgmii_clk;
input           reset_to_pma_tx;
`ifdef XFIPCS_16G32GFC
input           reset_to_pma_tx_div2;
input           ENABLE_TX_66B_OUT;
`endif
input           reset_to_xgmii_tx;

input           enable_alternate_refresh;
input           loopback_xgmii;
`ifdef XFIPCS_FIFOCNTL
input   [7:0]   txc_sdr;
input   [63:0]  txd_sdr;
input   [7:0]   tx_fifo_depth;
`endif
input   [71:0]  tx_rdata_p1;
input   [57:0]  test_pat_seed_a;
input   [57:0]  test_pat_seed_b;
input           tx_prbs_pat_en;
input           tx_test_pat_en;
input           test_pat_sel;
input           data_pat_sel;
input           ALTERNATE_ENCODE;
input           scr_bypass_enable;
input  [10:0]   tx_hss_t1_value;
input  [15:0]   tx_hss_t2_value;
input  [15:0]   tx_hss_t3_value;

`ifdef XFIPCS_16G32GFC
output  [65:0]  FEC_TX_DATA_66B;
output          FEC_TX_DATA_66B_VALID;
output          TX_LPI_ACTIVE;
`endif
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
output          tx_fifo_pop;
output  [31:0]  tx_data_out;
`ifdef XFIPCS_16G32GFC
output  [63:0]  tx_data_out_loopback;
`else
output  [31:0]  tx_data_out_loopback;
`endif
output          tx_local_fault_xgmii;
output  [1:0]   tx_mode;
output          t_type_li;
output          tx_active_xgmii;
output          TXxQUIET;
output          TXxREFRESH;

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
`endif
wire            tx_fifo_pop;
wire            tx_fifo_pop_2;

`ifdef XFIPCS_16G32GFC
wire    [63:0]  tx_data_out_64b;
reg     [31:0]  tx_data_out;
wire    [63:0]  tx_data_out_loopback;
wire    [63:0]  tx_gearbox_data_out;
`else
wire    [31:0]  tx_data_out;
wire    [31:0]  tx_data_out_loopback;
wire    [31:0]  tx_gearbox_data_out;
`endif
wire            tx_local_fault;
reg             tx_local_fault_pma;
wire            tx_local_fault_xgmii;

wire    [7:0]   encoder_control_in;
wire    [7:0]   txc_xfi;
wire    [63:0]  encoder_data_in;
wire    [63:0]  txd_xfi;
wire    [65:0]  tx_data_66b;

wire            tx_prbs_pat_en;
wire            tx_test_pat_en;
wire            test_mode_enc_nxt ;
reg             test_mode_enc ;
wire            test_mode_square_nxt ;
`ifdef XFIPCS_16G32GFC
wire    [63:0]  test_data_out;
`else
wire    [31:0]  test_data_out;
`endif
wire            tx_prbs_pat_en_pma;
reg             square_wave;
wire            square_wave_nxt;
wire            square_wave_pma;
wire            tx_fifo_hold;
wire            tx_fifo_pop_pre;

wire            scr_bypass_enable;
wire            scr_bypass_enable_pma;
wire            scrambler_bypass;

wire            t_type_li;
wire            tx_active;
wire            tx_active_xgmii;

// ----------------------------------------------------------------------------
// Parameters
// ----------------------------------------------------------------------------
parameter TX_FIFO_BYPASS = 1'b0;

parameter DATA  = 2'b00;
parameter QUIET = 2'b01;
parameter ALERT = 2'b10;

// ----------------------------------------------------------------------------
// Implementation
// ----------------------------------------------------------------------------
 assign tx_data_out_loopback =  (tx_prbs_pat_en_pma) ? test_data_out : tx_gearbox_data_out;
 `ifdef XFIPCS_16G32GFC
 assign tx_data_out_64b = (square_wave_pma || (tx_mode == ALERT))  ? 64'h00ff00ff00ff00ff : tx_data_out_loopback;

 reg pma_tx_clk_div2_high;
 wire pma_tx_clk_div2_high_nxt;
 assign pma_tx_clk_div2_high_nxt = reset_to_pma_tx_div2 ? 1'b1 : ~pma_tx_clk_div2_high;
 always @(posedge pma_tx_clk)
   begin
     pma_tx_clk_div2_high <= pma_tx_clk_div2_high_nxt;
   end

 reg [63:0] tx_data_out_64b_r1;
 always @(posedge pma_tx_clk)
   begin
     if(~pma_tx_clk_div2_high)
       tx_data_out <= tx_data_out_64b_r1[31:0];
     else
       tx_data_out <= tx_data_out_64b_r1[63:32];

     tx_data_out_64b_r1 <= tx_data_out_64b;
   end
 
 ///always @(*)
 ///begin
 ///  if(pma_tx_clk_div2_high)
 ///    tx_data_out = tx_data_out_64b[31:0];
 ///  else
 ///    tx_data_out = tx_data_out_64b[63:32];
 ///end
 `else
 assign tx_data_out = (square_wave_pma || (tx_mode == ALERT))  ? 32'h00ff00ff : tx_data_out_loopback;
 `endif

 assign test_mode_enc_nxt = tx_test_pat_en && ~test_pat_sel ;
 assign test_mode_square_nxt = tx_test_pat_en && test_pat_sel ;

 assign tx_fifo_pop = tx_fifo_pop_pre && ~tx_fifo_hold ;

 `XFIPCS_TOPLEVELNAME_TX_FIFO #(.TX_FIFO_BYPASS(TX_FIFO_BYPASS)) tx_fifo(
                         `ifdef XFIPCS_16G32GFC
                         .pma_tx_clk             (pma_tx_clk_div2        ),
                         .reset_to_pma_tx_div2   (reset_to_pma_tx_div2   ),
                         `else
                         .pma_tx_clk             (pma_tx_clk             ),
                         `endif
                         .reset_to_pma_tx        (reset_to_pma_tx        ),
                         .xgmii_clk              (xgmii_clk              ),
                         .reset_to_xgmii_tx      (reset_to_xgmii_tx      ),
                         
                         `ifdef XFIPCS_FIFOCNTL
                         .txc_sdr                (txc_sdr                ),
                         .txd_sdr                (txd_sdr                ),
                         .tx_fifo_depth          (tx_fifo_depth          ),
                         `endif
                         .tx_rdata_p1            (tx_rdata_p1            ),

                         .tx_fifo_pop            (tx_fifo_pop_pre        ),
                         .tx_fifo_hold           (tx_fifo_hold           ),
                         `ifdef XFIPCS_FIFOCNTL
                         .tx_waddr_p1            (tx_waddr_p1            ),
                         .tx_waddr_p2            (tx_waddr_p2            ),
                         .tx_overflow            (tx_overflow            ),
                         .tx_underflow           (tx_underflow           ),
                         .tx_wdata_p1            (tx_wdata_p1            ),
                         .tx_wdata_p2            (tx_wdata_p2            ),
                         .tx_wupper_en1          (tx_wupper_en1          ),
                         .tx_wlower_en1          (tx_wlower_en1          ),
                         .tx_wupper_en2          (tx_wupper_en2          ),
                         .tx_wlower_en2          (tx_wlower_en2          ),
                         .tx_raddr_p1            (tx_raddr_p1            ),
                         `endif
                         .txc_xfi                (txc_xfi                ),
                         .txd_xfi                (txd_xfi                )
                 );

 `XFIPCS_TOPLEVELNAME_TX_FLOW  flow(
                         `ifdef XFIPCS_16G32GFC
                         .pma_tx_clk              (pma_tx_clk_div2        ),
                         .reset_to_pma_tx         (reset_to_pma_tx_div2   ),
                         .reset_to_pma_tx_pmaclk  (reset_to_pma_tx        ),
                         .SPEED_SEL               (SPEED_SEL              ),
                         .lpi_fw                  (lpi_fw                 ),
                         .tx_tw_timer_value       (tx_tw_timer_value      ),
                         `else
                         .pma_tx_clk              (pma_tx_clk             ),
                         .reset_to_pma_tx         (reset_to_pma_tx        ),
                         `endif

                         .enable_alternate_refresh (enable_alternate_refresh),
                         .ALTERNATE_ENCODE        (ALTERNATE_ENCODE),
                         .tx_fifo_pop             (tx_fifo_pop            ),
                         .txc_xfi                 (txc_xfi                ),
                         .txd_xfi                 (txd_xfi                ),
                         .scr_bypass_enable       (scr_bypass_enable_pma  ),
                         .tx_hss_t1_value         (tx_hss_t1_value        ),
                         .tx_hss_t2_value         (tx_hss_t2_value        ),
                         .tx_hss_t3_value         (tx_hss_t3_value        ),

                         .tx_fifo_pop_2           (tx_fifo_pop_2          ),
                         .encoder_control_in      (encoder_control_in     ),
                         .encoder_data_in         (encoder_data_in        ),
                         .tx_local_fault          (tx_local_fault         ),
                         .tx_mode                 (tx_mode                ),
                         `ifdef XFIPCS_16G32GFC
                         .tx_lpi_active           (TX_LPI_ACTIVE          ),
                         `endif
                         .scrambler_bypass        (scrambler_bypass       ),
                         .t_type_li               (t_type_li              ),
                         .tx_active               (tx_active              ),
                         .TXxQUIET                (TXxQUIET               ),
                         .TXxREFRESH              (TXxREFRESH             )
                 );

 `XFIPCS_TOPLEVELNAME_64B66B_ENC  enc(
                         `ifdef XFIPCS_16G32GFC
                         .CLK                    (pma_tx_clk_div2        ),
                         .RESET                  (reset_to_pma_tx_div2   ),
                         `else
                         .CLK                    (pma_tx_clk             ),
                         .RESET                  (reset_to_pma_tx        ),
                         `endif

                         .ALTERNATE_ENCODE       (ALTERNATE_ENCODE),
                         .DATA_VALID             (tx_fifo_pop_2          ),
                         .ENCODER_DATA_IN        (encoder_data_in        ),
                         .ENCODER_CONTROL_IN     (encoder_control_in     ),
                         .TEST_PAT_SEED_A        (test_pat_seed_a        ),
                         .TEST_PAT_SEED_B        (test_pat_seed_b        ),
                         .TEST_MODE              (test_mode_enc          ),
                         .DATA_PAT_SEL           (data_pat_sel           ),
                         .scrambler_bypass       (scrambler_bypass       ),

                         .ENCODER_DATA_OUT       (tx_data_66b            )
                 );

 `ifdef XFIPCS_16G32GFC
 wire ENABLE_TX_66B_OUT;
 wire tx_fifo_pop_gearbox_in;
 wire [65:0] tx_data_66b_gearbox_in;

 assign tx_fifo_pop_gearbox_in = ENABLE_TX_66B_OUT ? 1'b0 : tx_fifo_pop_2;
 assign tx_data_66b_gearbox_in = ENABLE_TX_66B_OUT ? 66'h0 : tx_data_66b;

 reg FEC_TX_DATA_66B_VALID;
 reg [65:0] FEC_TX_DATA_66B;

 always @(posedge pma_tx_clk_div2)
 begin
   if (ENABLE_TX_66B_OUT) begin
    FEC_TX_DATA_66B_VALID <= tx_fifo_pop_2;
    FEC_TX_DATA_66B       <= tx_data_66b;
   end else begin
    FEC_TX_DATA_66B_VALID <= 1'b0;
    FEC_TX_DATA_66B       <= 66'h0;
   end
 end
 `endif

 `XFIPCS_TOPLEVELNAME_TX_GEARBOX gearbox(
                         `ifdef XFIPCS_16G32GFC
                         .pma_tx_clk             (pma_tx_clk_div2        ),
                         .reset_to_pma_tx        (reset_to_pma_tx_div2   ),

                         .tx_fifo_pop            (tx_fifo_pop_gearbox_in ),
                         .tx_data_66b            (tx_data_66b_gearbox_in ),
                         `else
                         .pma_tx_clk             (pma_tx_clk             ),
                         .reset_to_pma_tx        (reset_to_pma_tx        ),

                         .tx_fifo_pop            (tx_fifo_pop_2          ),
                         .tx_data_66b            (tx_data_66b            ),
                         `endif

                         .tx_data_out            (tx_gearbox_data_out    )
                 );

 `XFIPCS_TOPLEVELNAME_TX_TPG tx_tpg(
                         `ifdef XFIPCS_16G32GFC
                         .pma_tx_clk             (pma_tx_clk_div2        ),
                         .reset_to_pma_tx        (reset_to_pma_tx_div2   ),
                         `else
                         .pma_tx_clk             (pma_tx_clk             ),
                         .reset_to_pma_tx        (reset_to_pma_tx        ),
                         `endif

                         .tx_prbs_pat_en         (tx_prbs_pat_en_pma     ),

                         .test_data_out          (test_data_out          )
                 );

 assign square_wave_nxt = loopback_xgmii || test_mode_square_nxt || reset_to_xgmii_tx ;

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async000(.clk      (xgmii_clk),
                                         .data_in  (tx_local_fault_pma),
                                         .data_out (tx_local_fault_xgmii)
                                        );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async001(`ifdef XFIPCS_16G32GFC
                                         .clk      (pma_tx_clk_div2),
                                         `else
                                         .clk      (pma_tx_clk),
                                         `endif
                                         .data_in  (tx_prbs_pat_en),
                                         .data_out (tx_prbs_pat_en_pma)
                                        );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async002(`ifdef XFIPCS_16G32GFC
                                         .clk      (pma_tx_clk_div2),
                                         `else
                                         .clk      (pma_tx_clk),
                                         `endif
                                         .data_in  (square_wave),
                                         .data_out (square_wave_pma)
                                        );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async003(`ifdef XFIPCS_16G32GFC
                                         .clk      (pma_tx_clk_div2),
                                         `else
                                         .clk      (pma_tx_clk),
                                         `endif
                                         .data_in  (scr_bypass_enable),
                                         .data_out (scr_bypass_enable_pma)
                                        );

 // This is used in the MDIO unit for reg 1 bit 9. If we get a small blip
 // of LPIs to cause it to leave the active state but then go right back,
 // it doesn't matter if the MDIO reg reflects this (or misses it)
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(.NO_XSTATE(1)) async004(.clk      (xgmii_clk),
                                         .data_in  (tx_active),
                                         .data_out (tx_active_xgmii)
                                        );


 always @(posedge xgmii_clk)
 begin
   test_mode_enc <= test_mode_enc_nxt;
   square_wave <= square_wave_nxt;
 end

 `ifdef XFIPCS_16G32GFC
 always @(posedge pma_tx_clk_div2)
 `else
 always @(posedge pma_tx_clk)
 `endif
 begin
   tx_local_fault_pma <= tx_local_fault;
 end
endmodule
