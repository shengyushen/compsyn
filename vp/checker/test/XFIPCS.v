//SCCS File Version= %I%
//Release Date= 14/04/20  19:56:14 GMT startFileName /vobs/vob012/xfipcs/verilog/rtl/XFIPCS.v endFileName

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

//SCCS File Version= %I%
//Release Date= %E% %U%

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

//$Id: XFIPCS.v,v 1.14 2014/04/16 13:20:07 huqian Exp $
//$Log: XFIPCS.v,v $
//Revision 1.14  2014/04/16 13:20:07  huqian
//Fix possible gate level simulation issue
//
//Revision 1.13  2014/03/11 11:52:09  huqian
//Fix some cdc violations
//
//Revision 1.12  2014/03/06 06:01:54  huqian
//Remove FEC_TX_MODE output pin
//
//Revision 1.11  2014/02/28 05:28:30  huqian
//Fix HW281758: The error block counter adds twice incorrectly
//
//Revision 1.10  2014/02/26 08:02:48  huqian
//Fix HW281472: X-State through RESET from WAM
//
//Revision 1.9  2014/02/25 05:26:48  huqian
//Fix HW281430: bit[14] (latched_hi_ber) of reg_33 is wrong
//
//Revision 1.8  2014/02/21 07:12:01  huqian
//Copy XFIPCS cvs tag v1_135
//
//Revision 1.66  2014/02/21 06:48:42  huqian
//Fix HW280868/HW281130
//
//Revision 1.65  2014/02/18 07:32:24  huqian
//Condor 4 ASIC FC-EE Support Requirements.pdf item3
//
//Revision 1.64  2014/02/17 08:42:33  huqian
//Condor 4 ASIC FC-EE Support Requirements.pdf item2
//
//Revision 1.63  2014/02/14 04:29:48  huqian
//Add TX_LPI_ACTIVE output
//
//Revision 1.62  2014/02/13 08:38:35  huqian
//Add registers ber_timer_value 1 and ber_timer_value 2
//
//Revision 1.61  2014/02/10 05:57:38  huqian
//Fix HW278923: The BER FSM is wrong
//
//Revision 1.60  2014/01/23 07:58:40  huqian
//Add support of 16G XGMII_CLK running at 425M or 212.5M
//
//Revision 1.59  2014/01/07 05:41:33  huqian
//Update the values of 16G32G LPI timing parameters according to FC-FS-4
//
//Revision 1.58  2014/01/06 09:32:35  huqian
//Delete FEC_SCRAMBLER_BYPASS output; Add FEC_TX_MODE output
//
//Revision 1.57  2014/01/06 03:45:56  huqian
//Add SPEED_SEL input
//
//Revision 1.56  2014/01/06 03:10:19  huqian
//Add FEC_SCRAMBLER_BYPASS output; Registered ENABLE_RX_66B_IN/FEC_RX_DATA_66B_VALID/FEC_RX_DATA_66B for timing closure
//
//Revision 1.55  2013/12/26 08:16:35  huqian
//Update loopback rx data path
//
//Revision 1.54  2013/12/26 05:23:53  huqian
//Update reg_32768/32771/32773 definition for 16G32G; Update reg_32768/32769/32770/32771/32772/32773 reset value for 32G
//
//Revision 1.53  2013/12/18 08:32:52  huqian
//Add synthesis option to remove RX FIFO control(clock compensation) logic and RX XGMII data interface
//
//Revision 1.52  2013/12/17 08:44:48  huqian
//Add synthesis option to remove TX FIFO control(clock compensation) logic and TX XGMII data interface
//
//Revision 1.51  2013/12/17 03:36:58  huqian
//Delete FEC_RX_BLOCK_LOCK input interface signal
//
//Revision 1.50  2013/12/12 03:29:20  huqian
//Modify XFIPCS_32GFC macro define to XFIPCS_16G32GFC
//
//Revision 1.49  2013/12/11 08:37:25  huqian
//Update TX/RX datapath to add 66bit interface for 32GFC FEC
//
//Revision 1.48  2013/09/17 05:43:01  huqian
//Initial 32G Fibre Channel
//
//Revision 1.47  2011/05/09 15:48:44  adamc
//Anding PMA_RX_READY to signal_ok logic
//
//Revision 1.46  2011/05/06 14:49:36  adamc
//Moved rx_wp1 logic to XFIPCS_RX_PCS
//
//Revision 1.45  2011/04/30 02:03:33  adamc
//Added latency to reset_from_pma_rx_gated signal before synchronizer
//
//Revision 1.44  2011/04/20 20:32:25  adamc
//Update to block_sync for rapid block lock during WAKE with FEC
//
//Revision 1.43  2011/04/20 20:28:01  adamc
//Leda fixes
//
//Revision 1.42  2011/04/08 12:41:21  adamc
//Removed extra serializer on pcs_r_status into MDIO
//
//Revision 1.41  2011/03/29 18:44:00  adamc
//cvs_snap v1_83
//
//Revision 1.40  2011/03/28 15:23:35  adamc
//Update to better handle transition from LF to IDLEs
//
//Revision 1.38  2011/03/22 01:31:41  adamc
//Remove fix for RX LPI FSM for now, until verified. Fix typo in XFIPCS toplevel
//
//Revision 1.37  2011/03/22 01:04:07  adamc
//Revert LPI FSM back to prev version. Update MDIO HSS reg write enable
//
//Revision 1.36  2011/03/20 01:10:03  adamc
//Gating toplevel RX fifo write by rx_fifo_internal reset
//
//Revision 1.35  2011/03/17 21:28:12  adamc
//cvs_snap v1_63
//
//Revision 1.34  2011/03/17 18:25:24  adamc
//cvs_snap v1_62
//
//Revision 1.33  2011/03/16 23:46:51  adamc
//cvs_snap v1_60
//
//Revision 1.32  2011/03/16 17:10:59  adamc
//cvs_snap v1_58
//
//Revision 1.31  2011/03/15 19:47:22  adamc
//cvs_snap v1_55
//
//Revision 1.30  2011/03/11 20:15:46  adamc
//cvs_snap v1_51
//
//Revision 1.29  2011/03/11 19:38:28  adamc
//cvs_snap v1_50
//
//Revision 1.28  2011/03/10 20:32:54  adamc
//cvs_snap v1_1
//
//Revision 1.27  2011/03/09 16:00:57  adamc
//cvs_snap v1_47
//
//Revision 1.26  2011/03/07 21:26:28  adamc
//cvs_snap v1_44
//
//Revision 1.25  2011/03/07 18:01:23  adamc
//cvs_snap v1_43
//
//Revision 1.24  2011/03/04 21:31:03  adamc
//cvs_snap v1_39
//
//Revision 1.23  2011/03/04 18:23:51  adamc
//cvs_snap v1_37
//
//Revision 1.22  2011/03/03 19:33:22  adamc
//cvs_snap v1_36
//
//Revision 1.20  2011/02/21 21:45:57  adamc
//cvs_snap v1_29
//
//Revision 1.18  2011/02/08 16:05:10  adamc
//cvs_snap v1_22
//
//Revision 1.17  2011/02/07 20:13:04  adamc
//Async updates
//
//Revision 1.16  2011/01/28 19:10:47  adamc
//cvs_snap v1_16
//
//Revision 1.15  2011/01/26 14:26:43  adamc
//cvs_snap v1_13
//
//Revision 1.14  2011/01/21 21:27:45  adamc
//Some reset cleanup especially for RX
//
//Revision 1.13  2011/01/19 17:25:04  adamc
//Added *xREFRESH logic
//
//Revision 1.12  2011/01/14 15:08:11  adamc
//added separate resets for RX fifo
//
//Revision 1.11  2011/01/12 20:25:35  adamc
//Moved rx_lpi_fsm into xgmii domain
//
//Revision 1.8  2010/12/15 19:54:05  adamc
//Added synchronizers to scr_bypass_enable
//
//Revision 1.7  2010/12/14 21:01:41  adamc
//Updated WEC size
//
//Revision 1.6  2010/12/14 19:46:24  adamc
//updated to MDIO
//
//Revision 1.5  2010/12/13 21:33:37  adamc
//Fixed floating nets and heads up signals
//
//Revision 1.4  2010/12/08 21:06:25  adamc
//Initial glue logic updates for AZ
//
//Revision 1.3  2010/09/01 17:28:13  ppayton
//adding eee/lpi 802.3az to verif files
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

module `XFIPCS_TOPLEVELNAME (
                MDC,
                PMA_RX_CLK,
                PMA_TX_CLK,
`ifdef XFIPCS_16G32GFC
                PMA_RX_CLK_DIV2,
                PMA_TX_CLK_DIV2,
`endif
                XGMII_CLK,
                RESET_ASYNC,

                ENABLE_ALTERNATE_REFRESH,
`ifdef XFIPCS_TOPLEVELNAME_ALTERNATE_ENCODE_INPUT
                ALTERNATE_ENCODE,
`endif
                MD_ADDR,
                MD_DATA_IN,
                MD_EN,
                MDI,
                MD_R_W,
                PMA_RX_READY,
                PMA_TX_READY,
                PORT_ADDRESS,
                RX_DATA_IN,
                ENERGY_DETECT,
`ifdef XFIPCS_FIFOCNTL
                TXC,
                TXD,
                TX_FIFO_DEPTH,
                RX_FIFO_DEPTH,
                RX_RDATA_P1,
                RX_RDATA_P2,
`endif
                TX_RDATA_P1,
                SCR_BYPASS_ENABLE,
`ifdef XFIPCS_16G32GFC
                SPEED_SEL,           // 1:32G; 0:16G
                XGMIICLK_425M,       // 1:XGMII_CLK 425M; 0:XGMII_CLK 212.5M
                ENABLE_TX_66B_OUT,
                ENABLE_RX_66B_IN,
                FEC_RX_DATA_66B,
                FEC_RX_DATA_66B_VALID,
`endif

`ifdef XFIPCS_16G32GFC
                FEC_TX_DATA_66B,
                FEC_TX_DATA_66B_VALID,
                TX_LPI_ACTIVE,
`endif
`ifdef XFIPCS_FIFOCNTL
                TX_WADDR_P1,
                TX_WADDR_P2,
                TX_WDATA_P1,
                TX_WDATA_P2,
                TX_WE_LINE_P1,
                TX_WE_LINE_P2,
                TX_RADDR_P1,
                RX_RADDR_P1,
                RX_RADDR_P2,
                RX_WADDR_P1,
                RXC,
                RXD,
`endif
                TX_FIFO_POP,
                RX_WE_P1,
                RX_WDATA_P1,
                MD_1_2,
                MD_1_7,
                MD_1_8,
                MD_1_9,
                MD_1_10,
                MD_1_11,
                MD_32_0,
                MD_32_1,
                MD_32_12,
                MD_32_2,
                MD_33_13_8,
                MD_33_14,
                MD_33_15,
                MD_33_7_0,
                MD_43_15_0,
                MD_8_10,
                MD_8_11,
                MD_8_15_14,
                MD_22_15_0,
                MD_DATA_OUT,
                MDO,
                MDO_VALID,
                PCS_R_STATUS,
                TX_DATA_OUT,
                RXxQUIET,
                RXxREFRESH,
                TXxQUIET,
                TXxREFRESH,
                RX_MODE,
                TX_MODE,
                RX_LPI_ACTIVE
              );
//VSIA_Soft_IP_Tag % Vendor IBM_Corporation % Product XFIPCS % Version 003_08 % Metric 01 % Process_Step Source % Date_Time 20140418 % _Watermark H2O_XFIPCS_003_08

// ----------------------------------------------------------------------------
// Inputs/Outputs
// ----------------------------------------------------------------------------
input           ENABLE_ALTERNATE_REFRESH;
input           MDC;
input   [15:0]  MD_ADDR;
input   [15:0]  MD_DATA_IN;
input           MDI;
input           MD_R_W;
input           MD_EN;
input           PMA_RX_CLK;
input           PMA_RX_READY;
input           PMA_TX_CLK;
input           PMA_TX_READY;
`ifdef XFIPCS_16G32GFC
input           PMA_RX_CLK_DIV2;
input           PMA_TX_CLK_DIV2;
`endif
input   [4:0]   PORT_ADDRESS;
input           RESET_ASYNC;
input           ENERGY_DETECT;
input   [31:0]  RX_DATA_IN;
`ifdef XFIPCS_FIFOCNTL
  `ifdef XFIPCS_TOPLEVELNAME_DDR
  input   [3:0]   TXC;
  input   [31:0]  TXD;
  `else
  input   [7:0]   TXC;
  input   [63:0]  TXD;
  `endif
  input   [8:0]   TX_FIFO_DEPTH;
input   [8:0]   RX_FIFO_DEPTH;
input   [71:0]  RX_RDATA_P1;
input   [71:0]  RX_RDATA_P2;
`endif
input           XGMII_CLK;
input   [71:0]  TX_RDATA_P1;
`ifdef XFIPCS_TOPLEVELNAME_ALTERNATE_ENCODE_INPUT
 input ALTERNATE_ENCODE;
`else
 parameter ALTERNATE_ENCODE = 1'b0;
`endif
input           SCR_BYPASS_ENABLE;
`ifdef XFIPCS_16G32GFC
input           SPEED_SEL;
input           XGMIICLK_425M;
input           ENABLE_TX_66B_OUT;
input           ENABLE_RX_66B_IN;
input   [65:0]  FEC_RX_DATA_66B;
input           FEC_RX_DATA_66B_VALID;
`endif

`ifdef XFIPCS_16G32GFC
output  [65:0]  FEC_TX_DATA_66B;
output          FEC_TX_DATA_66B_VALID;
output          TX_LPI_ACTIVE;
`endif
`ifdef XFIPCS_FIFOCNTL
output  [7:0]   TX_WADDR_P1;
output  [7:0]   TX_WADDR_P2;
output  [71:0]  TX_WDATA_P1;
output  [71:0]  TX_WDATA_P2;
output  [1:0]   TX_WE_LINE_P1;
output  [1:0]   TX_WE_LINE_P2;
output  [7:0]   TX_RADDR_P1;
output  [7:0]   RX_RADDR_P1;
output  [7:0]   RX_RADDR_P2;
output  [7:0]   RX_WADDR_P1;
`endif
output          TX_FIFO_POP;
output          RX_WE_P1;
output  [71:0]  RX_WDATA_P1;
output          MD_1_2;
output          MD_1_7;
output          MD_1_8;
output          MD_1_9;
output          MD_1_10;
output          MD_1_11;
output          MD_32_0;
output          MD_32_1;
output          MD_32_12;
output          MD_32_2;
output  [5:0]   MD_33_13_8;
output          MD_33_14;
output          MD_33_15;
output  [7:0]   MD_33_7_0;
output  [15:0]  MD_43_15_0;
output          MD_8_10;
output          MD_8_11;
output  [1:0]   MD_8_15_14;
output  [15:0]  MD_22_15_0;
output  [15:0]  MD_DATA_OUT;
output          MDO;
output          MDO_VALID;
output          PCS_R_STATUS;
`ifdef XFIPCS_FIFOCNTL
  `ifdef XFIPCS_TOPLEVELNAME_DDR
  output  [3:0]   RXC;
  output  [31:0]  RXD;
  `else
  output  [7:0]   RXC;
  output  [63:0]  RXD;
  `endif
`endif
output  [1:0]   TX_MODE;
output          RX_MODE;
output  [31:0]  TX_DATA_OUT;

output          RXxQUIET;
output          RXxREFRESH;
output          TXxQUIET;
output          TXxREFRESH;
output          RX_LPI_ACTIVE;

// ----------------------------------------------------------------------------
// Internal signals/registers
// ----------------------------------------------------------------------------
`ifdef XFIPCS_16G32GFC
wire            SPEED_SEL;
wire            XGMIICLK_425M;
wire            ENABLE_TX_66B_OUT;
wire            ENABLE_RX_66B_IN;
wire    [65:0]  FEC_RX_DATA_66B;
wire            FEC_RX_DATA_66B_VALID;
wire    [65:0]  FEC_TX_DATA_66B;
wire            FEC_TX_DATA_66B_VALID;
`endif
wire            TX_FIFO_POP;
`ifdef XFIPCS_FIFOCNTL
wire    [7:0]   TX_WADDR_P1;
wire    [7:0]   TX_WADDR_P2;
wire    [71:0]  TX_WDATA_P1;
wire    [71:0]  TX_WDATA_P2;
wire    [1:0]   TX_WE_LINE_P1;
wire    [1:0]   TX_WE_LINE_P2;
wire    [7:0]   TX_RADDR_P1;
wire    [7:0]   RX_RADDR_P1;
wire    [7:0]   RX_RADDR_P2;
wire    [7:0]   RX_WADDR_P1;
`endif
wire            RX_WE_P1;
wire    [71:0]  RX_WDATA_P1;
wire    [31:0]  TX_DATA_OUT;
wire    [31:0]  tx_data_out;
`ifdef XFIPCS_16G32GFC
wire    [63:0]  tx_data_out_loopback;
`else
wire    [31:0]  tx_data_out_loopback;
`endif

`ifdef XFIPCS_FIFOCNTL
  `ifdef XFIPCS_TOPLEVELNAME_DDR
  wire    [3:0]   RXC;
  wire    [31:0]  RXD;
  `else
  wire    [7:0]   RXC;
  wire    [63:0]  RXD;
  `endif
`endif

wire            MD_1_2;
wire            MD_1_7;
wire            MD_1_8;
wire            MD_1_9;
wire            MD_1_10;
wire            MD_1_11;
wire            MD_32_0;
wire            MD_32_1;
wire            MD_32_12;
wire            MD_32_2;
wire    [5:0]   MD_33_13_8;
wire            MD_33_14;
wire            MD_33_15;
wire    [7:0]   MD_33_7_0;
wire    [15:0]  MD_43_15_0;
wire            MD_8_10;
wire            MD_8_11;
wire    [1:0]   MD_8_15_14;
wire    [15:0]  MD_22_15_0;
`ifdef XFIPCS_FIFOCNTL
wire    [7:0]   txc_sdr;
wire    [63:0]  txd_sdr;
wire    [7:0]   rxc_sdr;
wire    [63:0]  rxd_sdr;
`endif
wire            inc_ebc;
wire            inc_ber_count;
wire            loopback_xgmii;
wire            loopback_reset;
wire            reset_from_md;
wire            reset_to_md;
wire            reset_to_pma_rx;
wire            reset_to_pma_tx;
`ifdef XFIPCS_16G32GFC
wire            reset_to_pma_rx_div2;
wire            reset_to_pma_tx_div2;
`endif
wire            reset_to_xgmii;
wire            reset_to_xgmii_rx;
wire            reset_to_xgmii_tx;
wire    [65:0]  rx_data_66b;
wire    [65:0]  tx_data_66b;
wire            r_test_mode;
wire            block_lock;
wire            rx_block_lock;
wire            rx_local_fault_xgmii;
wire            tx_local_fault_xgmii;
wire            pma_rx_ready_flop;
wire            hi_ber;
wire            sh_valid;
wire            reset_from_pma_rx_flop;
wire            data_valid;
`ifdef XFIPCS_FIFOCNTL
wire    [7:0]   rx_fifo_depth;
wire    [7:0]   tx_fifo_depth;
`endif
wire    [57:0]  test_pat_seed_a;
wire    [57:0]  test_pat_seed_b;
wire    [57:0]  test_pat_seed_a_pma_tx;
wire    [57:0]  test_pat_seed_b_pma_tx;
wire            rx_prbs_pat_en;
wire            tx_prbs_pat_en;
wire            rx_test_pat_en;
wire            tx_test_pat_en;
wire            test_pat_sel;
wire            data_pat_sel;
wire    [31:0]  prbs_data;
wire    [7:0]   tpec_pma_gray;
wire            clear_tpec_tog;

`ifdef XFIPCS_FIFOCNTL
wire            rx_overflow;
wire            rx_underflow;
wire            tx_overflow;
wire            tx_underflow;

wire            tx_wupper_en1;
wire            tx_wlower_en1;
wire            tx_wupper_en2;
wire            tx_wlower_en2;
`endif

wire    [7:0]   rxc_xfi;
wire    [63:0]  rxd_xfi;

wire            rx_lpi_active;
wire            rx_lpi_active_pma_rx;
`ifdef XFIPCS_16G32GFC
wire    [17:0]  ber_timer_value;
wire    [17:0]  ber_timer_value_pma;
wire            lpi_fw;
wire            lpi_fw_pmatxdiv2;
wire    [12:0]  tx_tw_timer_value;
wire    [12:0]  tx_tw_timer_value_pmatxdiv2;
wire    [12:0]  rx_tw_timer_value;
`endif
wire    [10:0]  tx_hss_t1_value;
wire    [15:0]  tx_hss_t2_value;
wire    [15:0]  tx_hss_t3_value;
wire    [10:0]  tx_hss_t1_value_pma;
wire    [15:0]  tx_hss_t2_value_pma;
wire    [15:0]  tx_hss_t3_value_pma;
`ifdef XFIPCS_16G32GFC
wire    [17:0]  rx_hss_t1_value;
wire    [17:0]  rx_hss_t6_value;
`else
wire    [15:0]  rx_hss_t1_value;
wire    [15:0]  rx_hss_t6_value;
`endif
wire    [15:0]  rx_hss_t3_value;

wire            wake_error_counter_inc;

wire            t_type_li;
wire            r_type_li;

wire            rx_mode_xgmii;
wire            rx_mode_pma_rx;
wire            tx_active_xgmii;
wire            tx_active;
wire            rx_active;
wire            scr_bypass_enable_pma_rx;

reg             reset_from_pma_rx;
wire            reset_from_pma_rx_nxt;
reg             reset_from_pma_rx_gated;
reg             reset_from_pma_rx_gated_1;
reg             reset_from_pma_rx_gated_2;
reg             reset_from_pma_rx_gated_3;
wire            reset_from_pma_rx_gated_1_nxt;
wire            reset_from_pma_rx_gated_nxt;
reg             reset_from_pma_tx;
wire            reset_from_pma_tx_nxt;

wire            pcs_r_status_xgmii;
wire            pma_rx_ready_xgmii;
wire            pma_tx_ready_xgmii;

wire            rx_we_p1;

wire            tx_hss_reg_we;
wire            rx_hss_reg_we;

// ----------------------------------------------------------------------------
// Parameters
// ----------------------------------------------------------------------------
parameter RX_FIFO_BYPASS = 1'b0;
parameter TX_FIFO_BYPASS = 1'b0;

// ----------------------------------------------------------------------------
// Implementation
// ----------------------------------------------------------------------------
 assign PCS_R_STATUS = pcs_r_status_xgmii;
 assign RX_LPI_ACTIVE = rx_lpi_active;
 assign RX_MODE = rx_mode_xgmii;

 `ifdef XFIPCS_FIFOCNTL
 assign rx_fifo_depth = RX_FIFO_DEPTH[8:1];
 assign tx_fifo_depth = TX_FIFO_DEPTH[8:1];
 `endif

`ifdef XFIPCS_FIFOCNTL
 `XFIPCS_TOPLEVELNAME_TX_DDR_TO_SDR tx_sdr(
                         .xgmii_clk              (XGMII_CLK              ),
                         .reset_to_xgmii         (reset_to_xgmii         ),

                         .txc                    (TXC                    ),
                         .txd                    (TXD                    ),

                         .txc_sdr                (txc_sdr                ),
                         .txd_sdr                (txd_sdr                )
                 );


 assign TX_WE_LINE_P1 = {tx_wupper_en1, tx_wlower_en1};
 assign TX_WE_LINE_P2 = {tx_wupper_en2, tx_wlower_en2};
`endif

 `XFIPCS_TOPLEVELNAME_ASYNC_BUS_DRS #(.WIDTH(11)) async16(
                         `ifdef XFIPCS_16G32GFC
                         .clk     (PMA_TX_CLK_DIV2          ),
                         `else
                         .clk     (PMA_TX_CLK               ),
                         `endif
                         .data_in (tx_hss_t1_value    ),
                         .data_out(tx_hss_t1_value_pma)
  );

 `XFIPCS_TOPLEVELNAME_ASYNC_BUS_DRS #(.WIDTH(16)) async17(
                         `ifdef XFIPCS_16G32GFC
                         .clk     (PMA_TX_CLK_DIV2          ),
                         `else
                         .clk     (PMA_TX_CLK               ),
                         `endif
                         .data_in (tx_hss_t2_value    ),
                         .data_out(tx_hss_t2_value_pma)
  );

 `XFIPCS_TOPLEVELNAME_ASYNC_BUS_DRS #(.WIDTH(16)) async18(
                         `ifdef XFIPCS_16G32GFC
                         .clk     (PMA_TX_CLK_DIV2            ),
                         `else
                         .clk     (PMA_TX_CLK                 ),
                         `endif
                         .data_in (tx_hss_t3_value    ),
                         .data_out(tx_hss_t3_value_pma)
  );

 `XFIPCS_TOPLEVELNAME_ASYNC_BUS_DRS #(.WIDTH(58)) async20(
                         `ifdef XFIPCS_16G32GFC
                         .clk     (PMA_TX_CLK_DIV2       ),
                         `else
                         .clk     (PMA_TX_CLK            ),
                         `endif
                         .data_in (test_pat_seed_a       ),
                         .data_out(test_pat_seed_a_pma_tx)
  );

 `XFIPCS_TOPLEVELNAME_ASYNC_BUS_DRS #(.WIDTH(58)) async21(
                         `ifdef XFIPCS_16G32GFC
                         .clk     (PMA_TX_CLK_DIV2       ),
                         `else
                         .clk     (PMA_TX_CLK            ),
                         `endif
                         .data_in (test_pat_seed_b       ),
                         .data_out(test_pat_seed_b_pma_tx)
  );

 `ifdef XFIPCS_16G32GFC
 `XFIPCS_TOPLEVELNAME_ASYNC_BUS_DRS #(.WIDTH(18)) async22(
                         .clk     (PMA_RX_CLK               ),
                         .data_in (ber_timer_value          ),
                         .data_out(ber_timer_value_pma      )
  );

 `XFIPCS_TOPLEVELNAME_ASYNC_BUS_DRS #(.WIDTH(1)) async23(
                         .clk     (PMA_TX_CLK_DIV2          ),
                         .data_in (lpi_fw                   ),
                         .data_out(lpi_fw_pmatxdiv2         )
  );

 `XFIPCS_TOPLEVELNAME_ASYNC_BUS_DRS #(.WIDTH(13)) async24(
                         .clk     (PMA_TX_CLK_DIV2          ),
                         .data_in (tx_tw_timer_value        ),
                         .data_out(tx_tw_timer_value_pmatxdiv2)
  );
 `endif

 `XFIPCS_TOPLEVELNAME_TX_PCS #(.TX_FIFO_BYPASS(TX_FIFO_BYPASS))  tx(
                         .pma_tx_clk              (PMA_TX_CLK             ),
                         `ifdef XFIPCS_16G32GFC
                         .pma_tx_clk_div2         (PMA_TX_CLK_DIV2        ),
                         .SPEED_SEL               (SPEED_SEL              ),
                         .lpi_fw                  (lpi_fw_pmatxdiv2       ),
                         .tx_tw_timer_value       (tx_tw_timer_value_pmatxdiv2),
                         `endif
                         .xgmii_clk               (XGMII_CLK              ),
                         .reset_to_pma_tx         (reset_to_pma_tx        ),
                         `ifdef XFIPCS_16G32GFC
                         .reset_to_pma_tx_div2    (reset_to_pma_tx_div2   ),
                         .ENABLE_TX_66B_OUT       (ENABLE_TX_66B_OUT      ),
                         `endif
                         .reset_to_xgmii_tx       (reset_to_xgmii_tx      ),

                         `ifdef XFIPCS_16G32GFC
                         .FEC_TX_DATA_66B         (FEC_TX_DATA_66B        ),
                         .FEC_TX_DATA_66B_VALID   (FEC_TX_DATA_66B_VALID  ),
                         .TX_LPI_ACTIVE           (TX_LPI_ACTIVE          ),
                         `endif
                         .enable_alternate_refresh (ENABLE_ALTERNATE_REFRESH),
                         .ALTERNATE_ENCODE        (ALTERNATE_ENCODE),
                         .loopback_xgmii          (loopback_xgmii         ),
                         `ifdef XFIPCS_FIFOCNTL
                         .txc_sdr                 (txc_sdr                ),
                         .txd_sdr                 (txd_sdr                ),
                         .tx_fifo_depth           (tx_fifo_depth          ),
                         `endif
                         .tx_rdata_p1             (TX_RDATA_P1            ),
                         .test_pat_seed_a         (test_pat_seed_a_pma_tx ),
                         .test_pat_seed_b         (test_pat_seed_b_pma_tx ),
                         .tx_prbs_pat_en          (tx_prbs_pat_en         ),
                         .tx_test_pat_en          (tx_test_pat_en         ),
                         .test_pat_sel            (test_pat_sel           ),
                         .data_pat_sel            (data_pat_sel           ),
                         .scr_bypass_enable       (SCR_BYPASS_ENABLE      ),
                         .tx_hss_t1_value         (tx_hss_t1_value_pma    ),
                         .tx_hss_t2_value         (tx_hss_t2_value_pma    ),
                         .tx_hss_t3_value         (tx_hss_t3_value_pma    ),

                         .tx_fifo_pop            (TX_FIFO_POP            ),
                         `ifdef XFIPCS_FIFOCNTL
                         .tx_waddr_p1            (TX_WADDR_P1            ),
                         .tx_waddr_p2            (TX_WADDR_P2            ),
                         .tx_wdata_p1            (TX_WDATA_P1            ),
                         .tx_wdata_p2            (TX_WDATA_P2            ),
                         .tx_overflow            (tx_overflow            ),
                         .tx_underflow           (tx_underflow           ),
                         .tx_wupper_en1          (tx_wupper_en1          ),
                         .tx_wlower_en1          (tx_wlower_en1          ),
                         .tx_wupper_en2          (tx_wupper_en2          ),
                         .tx_wlower_en2          (tx_wlower_en2          ),
                         .tx_raddr_p1            (TX_RADDR_P1            ),
                         `endif
                         .tx_data_out            (tx_data_out            ),
                         .tx_data_out_loopback   (tx_data_out_loopback   ),
                         .tx_local_fault_xgmii   (tx_local_fault_xgmii   ),
                         .tx_mode                (TX_MODE                ),
                         .t_type_li              (t_type_li              ),
                         .tx_active_xgmii        (tx_active_xgmii        ),
                         .TXxQUIET               (TXxQUIET               ),
                         .TXxREFRESH             (TXxREFRESH             )
                 );

 assign TX_DATA_OUT = tx_data_out;

 `ifdef XFIPCS_FIFOCNTL
 `XFIPCS_TOPLEVELNAME_RX_SDR_TO_DDR rx_sdr(
                         .xgmii_clk              (XGMII_CLK              ),
                         .reset_to_xgmii         (reset_to_xgmii         ),

                         .rxc_sdr                (rxc_sdr                ),
                         .rxd_sdr                (rxd_sdr                ),

                         .rxc                    (RXC                    ),
                         .rxd                    (RXD                    )
                 );
 `endif

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(.SHORT_DELAY(1), .NO_XSTATE(1)) async13(
                         .clk     (XGMII_CLK           ),
                         .data_in (PMA_RX_READY        ),
                         .data_out(pma_rx_ready_xgmii )
  );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(.SHORT_DELAY(1), .NO_XSTATE(1)) async14(
                         .clk     (XGMII_CLK          ),
                         .data_in (PMA_TX_READY       ),
                         .data_out(pma_tx_ready_xgmii )
  );

 `ifdef XFIPCS_16G32GFC
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async15(
                         .clk     (XGMII_CLK          ),
                         .data_in (SPEED_SEL          ),
                         .data_out(speed_sel_xgmii    )
 );
 `endif

 assign reset_from_pma_rx_nxt       = ~pma_rx_ready_xgmii & ~loopback_xgmii;
 assign reset_from_pma_rx_gated_1_nxt = reset_from_pma_rx_nxt & ~rx_lpi_active;
 assign reset_from_pma_rx_gated_nxt = reset_from_pma_rx_gated_1 | reset_from_pma_rx_gated_2 | reset_from_pma_rx_gated_3;
 assign reset_from_pma_tx_nxt       = ~pma_tx_ready_xgmii & ~loopback_xgmii;

 // latched before synchronizer
 always @(posedge XGMII_CLK) begin
  reset_from_pma_rx       <= reset_from_pma_rx_nxt;
  reset_from_pma_rx_gated_1 <= reset_from_pma_rx_gated_1_nxt;
  reset_from_pma_rx_gated_2 <= reset_from_pma_rx_gated_1;
  reset_from_pma_rx_gated_3 <= reset_from_pma_rx_gated_2;
  reset_from_pma_rx_gated   <= reset_from_pma_rx_gated_nxt;
  reset_from_pma_tx <= reset_from_pma_tx_nxt;
 end

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(.SHORT_DELAY(1), .NO_XSTATE(1)) async10(
                         .clk    (PMA_RX_CLK                     ),
                         .data_in(reset_from_pma_rx              ),
                         .data_out(reset_from_pma_rx_flop        )
  );

 assign pma_rx_ready_flop = PMA_RX_READY & ~reset_from_pma_rx_flop;

 `XFIPCS_TOPLEVELNAME_RESET reset(
                         .pma_rx_clk             (PMA_RX_CLK             ),
                         .pma_tx_clk             (PMA_TX_CLK             ),
                         `ifdef XFIPCS_16G32GFC
                         .pma_rx_clk_div2        (PMA_RX_CLK_DIV2        ),
                         .pma_tx_clk_div2        (PMA_TX_CLK_DIV2        ),
                         .speed_sel_xgmii        (speed_sel_xgmii        ),
                         `endif
                         .xgmii_clk              (XGMII_CLK              ),
                         .reset_async            (RESET_ASYNC            ),

                         .reset_from_md          (reset_from_md          ),
                         .reset_from_pma_rx      (reset_from_pma_rx_gated),
                         .reset_from_pma_tx      (reset_from_pma_tx      ),
                         `ifdef XFIPCS_FIFOCNTL
                         .rx_overflow            (rx_overflow            ),
                         .rx_underflow           (rx_underflow           ),
                         .tx_overflow            (tx_overflow            ),
                         .tx_underflow           (tx_underflow           ),
                         `endif
                         .loopback_reset         (loopback_reset         ),
                         .loopback_xgmii         (loopback_xgmii         ),

                         .reset_to_md            (reset_to_md            ),
                         .reset_to_pma_rx        (reset_to_pma_rx        ),
                         .reset_to_pma_tx        (reset_to_pma_tx        ),
                         `ifdef XFIPCS_16G32GFC
                         .reset_to_pma_rx_div2   (reset_to_pma_rx_div2   ),
                         .reset_to_pma_tx_div2   (reset_to_pma_tx_div2   ),
                         `endif
                         .reset_to_xgmii         (reset_to_xgmii         ),
                         .reset_to_xgmii_rx      (reset_to_xgmii_rx      ),
                         .reset_to_xgmii_tx      (reset_to_xgmii_tx      )
                 );

 `ifdef XFIPCS_16G32GFC
 reg ENABLE_RX_66B_IN_r1;
 reg FEC_RX_DATA_66B_VALID_r1;
 reg [65:0] FEC_RX_DATA_66B_r1;
 wire data_valid_in, data_valid_out;
 wire [65:0] rx_data_66b_in, rx_data_66b_out;
 wire sh_valid_in, sh_valid_out;
 wire loopback_pma_rx;

 always @(posedge PMA_RX_CLK_DIV2) begin
   if (reset_to_pma_rx_div2) begin
    ENABLE_RX_66B_IN_r1      <= 1'b0;
    FEC_RX_DATA_66B_VALID_r1 <= 1'b0;
    FEC_RX_DATA_66B_r1       <= 66'h0;
   end
   else begin
    ENABLE_RX_66B_IN_r1      <= ENABLE_RX_66B_IN;
    FEC_RX_DATA_66B_VALID_r1 <= FEC_RX_DATA_66B_VALID;
    FEC_RX_DATA_66B_r1       <= FEC_RX_DATA_66B;
   end
 end

 assign data_valid_in     = FEC_RX_DATA_66B_VALID_r1;
 assign data_valid_out    = ENABLE_RX_66B_IN_r1 ? data_valid_in : data_valid;
 assign rx_data_66b_in    = FEC_RX_DATA_66B_r1;
 assign rx_data_66b_out   = loopback_pma_rx ? rx_data_66b : (ENABLE_RX_66B_IN_r1 ? rx_data_66b_in : rx_data_66b);
 assign sh_valid_in       = FEC_RX_DATA_66B_r1[0] ^ FEC_RX_DATA_66B_r1[1];
 assign sh_valid_out      = data_valid_out ? (ENABLE_RX_66B_IN_r1 ? sh_valid_in : sh_valid) : 1'b1;
 `endif

 `XFIPCS_TOPLEVELNAME_RX_PCS #(.RX_FIFO_BYPASS(RX_FIFO_BYPASS))  rx(
                         .pma_rx_clk             (PMA_RX_CLK             ),
                         `ifdef XFIPCS_16G32GFC
                         .pma_rx_clk_div2        (PMA_RX_CLK_DIV2        ),
                         .pma_rx_clk_div2_high   (pma_rx_clk_div2_high   ),
                         `endif
                         .xgmii_clk              (XGMII_CLK              ),
                         .reset_to_pma_rx        (reset_to_pma_rx        ),
                         `ifdef XFIPCS_16G32GFC
                         .reset_to_pma_rx_div2   (reset_to_pma_rx_div2   ),
                         .speed_sel_xgmii        (speed_sel_xgmii        ),
                         .XGMIICLK_425M          (XGMIICLK_425M          ),
                         .lpi_fw                 (lpi_fw                 ),
                         .rx_tw_timer_value      (rx_tw_timer_value      ),
                         `endif
                         .reset_to_xgmii_rx      (reset_to_xgmii_rx      ),

                         .enable_alternate_refresh (ENABLE_ALTERNATE_REFRESH),
                         .ALTERNATE_ENCODE       (ALTERNATE_ENCODE),
                         .rx_block_lock          (rx_block_lock          ),
                         `ifdef XFIPCS_16G32GFC
                         .data_valid             (data_valid_out         ),
                         .rx_data_66b            (rx_data_66b_out        ),
                         `else
                         .data_valid             (data_valid             ),
                         .rx_data_66b            (rx_data_66b            ),
                         `endif
                         .clear_tpec_tog         (clear_tpec_tog         ),
                         .hi_ber                 (hi_ber                 ),
                         .loopback_reset         (loopback_reset         ),
                         .prbs_data              (prbs_data              ),
                         .r_test_mode            (r_test_mode            ),
                         `ifdef XFIPCS_FIFOCNTL
                         .rx_fifo_depth          (rx_fifo_depth          ),
                         .rx_rdata_p1            (RX_RDATA_P1            ),
                         .rx_rdata_p2            (RX_RDATA_P2            ),
                         `endif
                         .rx_prbs_pat_en         (rx_prbs_pat_en         ),
                         .rx_test_pat_en         (rx_test_pat_en         ),
                         .test_pat_sel           (test_pat_sel           ),
                         .energy_detect          (ENERGY_DETECT          ),
                         .scr_bypass_enable      (SCR_BYPASS_ENABLE      ),
                         .rx_hss_t1_value        (rx_hss_t1_value        ),
                         .rx_hss_t3_value        (rx_hss_t3_value        ),
                         .rx_hss_t6_value        (rx_hss_t6_value        ),

                         .wake_error_counter_inc (wake_error_counter_inc ),
                         `ifdef XFIPCS_FIFOCNTL
                         .rx_raddr_p1            (RX_RADDR_P1            ),
                         .rx_raddr_p2            (RX_RADDR_P2            ),
                         .rx_waddr_p1            (RX_WADDR_P1            ),
                         .rx_overflow            (rx_overflow            ),
                         .rx_underflow           (rx_underflow           ),
                         .rxc_sdr                (rxc_sdr                ),
                         .rxd_sdr                (rxd_sdr                ),
                         `endif
                         .inc_ebc                (inc_ebc                ),
                         .tpec_pma_gray          (tpec_pma_gray          ),
                         .tpec_15_8_inc_tog      (tpec_15_8_inc_tog      ),
                         .rx_local_fault_xgmii   (rx_local_fault_xgmii   ),
                         .rxc_xfi                (rxc_xfi                ),
                         .rxd_xfi                (rxd_xfi                ),
                         .block_lock             (block_lock             ),
                         .rx_lpi_active          (rx_lpi_active          ),
                         .rx_lpi_active_pma_rx   (rx_lpi_active_pma_rx   ),
                         .rx_mode                (rx_mode_xgmii          ),
                         .r_type_li              (r_type_li              ),
                         .RXxQUIET               (RXxQUIET               ),
                         .RXxREFRESH             (RXxREFRESH             ),
                         .pcs_r_status_xgmii     (pcs_r_status_xgmii     ),
                         .rx_we_p1               (RX_WE_P1               )
                 );


 assign RX_WDATA_P1 = {rxc_xfi[7:4], rxd_xfi[63:32], rxc_xfi[3:0], rxd_xfi[31:0]};

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async30(
                         `ifdef XFIPCS_16G32GFC
                         .clk     (PMA_RX_CLK_DIV2),
                         `else
                         .clk     (PMA_RX_CLK    ),
                         `endif
                         .data_in (rx_mode_xgmii ),
                         .data_out(rx_mode_pma_rx)
  );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async31(
                         `ifdef XFIPCS_16G32GFC
                         .clk     (PMA_RX_CLK_DIV2         ),
                         `else
                         .clk     (PMA_RX_CLK              ),
                         `endif
                         .data_in (SCR_BYPASS_ENABLE       ),
                         .data_out(scr_bypass_enable_pma_rx)
  );

 `XFIPCS_TOPLEVELNAME_RX_BLOCK_SYNC block_sync(
                         .pma_rx_clk             (PMA_RX_CLK             ),
                         .reset_to_pma_rx        (reset_to_pma_rx        ),
                         `ifdef XFIPCS_16G32GFC
                         .pma_rx_clk_div2        (PMA_RX_CLK_DIV2        ),
                         .reset_to_pma_rx_div2   (reset_to_pma_rx_div2   ),
                         .enable_rx_66b_in       (ENABLE_RX_66B_IN_r1    ),
                         .fec_rx_data_66b        (FEC_RX_DATA_66B_r1     ),
                         .fec_rx_data_66b_valid  (FEC_RX_DATA_66B_VALID_r1),
                         `endif

                         .loopback_xgmii         (loopback_xgmii         ),
                         .rx_data_in             (RX_DATA_IN             ),
                         .tx_data_out_loopback   (tx_data_out_loopback   ),
                         .pma_rx_ready_flop      (pma_rx_ready_flop      ),
                         .rx_lpi_active          (rx_lpi_active_pma_rx   ),
                         .rx_mode                (rx_mode_pma_rx         ),
                         .scr_bypass_enable      (scr_bypass_enable_pma_rx),

                         `ifdef XFIPCS_16G32GFC
                         .pma_rx_clk_div2_high   (pma_rx_clk_div2_high   ),
                         .loopback_pma_rx        (loopback_pma_rx        ),
                         `endif
                         .rx_block_lock          (rx_block_lock          ),
                         .rx_data_66b            (rx_data_66b            ),
                         .data_valid             (data_valid             ),
                         .prbs_data              (prbs_data              ),
                         .sh_valid               (sh_valid               )
                 );

 `XFIPCS_TOPLEVELNAME_BER_MONITOR ber(
                         .pma_rx_clk             (PMA_RX_CLK             ),
                         .reset_to_pma_rx        (reset_to_pma_rx        ),

                         .rx_block_lock          (rx_block_lock          ),
                         `ifdef XFIPCS_16G32GFC
                         .data_valid             (data_valid_out         ),
                         .sh_valid               (sh_valid_out           ),
                         `else
                         .data_valid             (data_valid             ),
                         .sh_valid               (sh_valid               ),
                         `endif
                         .r_test_mode            (r_test_mode            ),
                         .rx_lpi_active          (rx_lpi_active_pma_rx   ),
                         `ifdef XFIPCS_16G32GFC
                         .ber_timer_value        (ber_timer_value_pma    ),
                         `endif

                         .hi_ber                 (hi_ber                 ),
                         .inc_ber_count          (inc_ber_count          )
                 );

 assign tx_active = tx_active_xgmii;
 assign rx_active = ~rx_lpi_active;
 assign tx_hss_reg_we = tx_active_xgmii;
 assign rx_hss_reg_we = ~rx_lpi_active & ~RXxREFRESH;

 `XFIPCS_TOPLEVELNAME_MDIO mdio(
                         .mdc                    (MDC                    ),
                         .pma_rx_clk             (PMA_RX_CLK             ),
                         .xgmii_clk              (XGMII_CLK              ),
                         .reset_to_md            (reset_to_md            ),
                         .reset_to_pma_rx        (reset_to_pma_rx        ),
                         .reset_to_xgmii_rx      (reset_to_xgmii_rx      ),
                         .reset_to_xgmii         (reset_to_xgmii         ),
                         `ifdef XFIPCS_16G32GFC
                         .pma_rx_clk_div2        (PMA_RX_CLK_DIV2        ),
                         .reset_to_pma_rx_div2   (reset_to_pma_rx_div2   ),
                         .speed_sel_xgmii        (speed_sel_xgmii        ),
                         .scr_bypass_enable      (SCR_BYPASS_ENABLE      ),
                         .XGMIICLK_425M          (XGMIICLK_425M          ),
                         `endif

                         .block_lock             (block_lock             ),
                         .hi_ber                 (hi_ber                 ),
                         .inc_ber_count          (inc_ber_count          ),
                         .inc_ebc                (inc_ebc                ),
                         .md_addr                (MD_ADDR                ),
                         .md_data_in             (MD_DATA_IN             ),
                         .md_en                  (MD_EN                  ),
                         .mdi                    (MDI                    ),
                         .md_r_w                 (MD_R_W                 ),
                         .pcs_r_status_xgmii     (pcs_r_status_xgmii     ),
                         .port_address           (PORT_ADDRESS           ),
                         .rx_local_fault_xgmii   (rx_local_fault_xgmii   ),
                         .tx_local_fault_xgmii   (tx_local_fault_xgmii   ),
                         .tpec_pma_gray          (tpec_pma_gray          ),
                         .tpec_15_8_inc_tog      (tpec_15_8_inc_tog      ),
                         .wake_error_counter_inc (wake_error_counter_inc ),
                         .tx_active              (tx_active              ),
                         .rx_active              (rx_active              ),
                         .tx_hss_reg_we          (tx_hss_reg_we          ),
                         .rx_hss_reg_we          (rx_hss_reg_we          ),

                         .clear_tpec_tog         (clear_tpec_tog         ),
                         .loopback               (loopback_xgmii         ),
                         .loopback_reset         (loopback_reset         ),
                         .md_1_2                 (MD_1_2                 ),
                         .md_1_7                 (MD_1_7                 ),
                         .md_1_8                 (MD_1_8                 ),
                         .md_1_9                 (MD_1_9                 ),
                         .md_1_10                (MD_1_10                ),
                         .md_1_11                (MD_1_11                ),
                         .md_32_0                (MD_32_0                ),
                         .md_32_1                (MD_32_1                ),
                         .md_32_12               (MD_32_12               ),
                         .md_32_2                (MD_32_2                ),
                         .md_33_7_0              (MD_33_7_0              ),
                         .md_33_13_8             (MD_33_13_8             ),
                         .md_33_14               (MD_33_14               ),
                         .md_33_15               (MD_33_15               ),
                         .md_43_15_0             (MD_43_15_0             ),
                         .md_8_10                (MD_8_10                ),
                         .md_8_11                (MD_8_11                ),
                         .md_8_15_14             (MD_8_15_14             ),
                         .md_22_15_0             (MD_22_15_0             ),
                         .md_data_out            (MD_DATA_OUT            ),
                         .mdo                    (MDO                    ),
                         .mdo_valid              (MDO_VALID              ),
                         .r_test_mode            (r_test_mode            ),
                         .test_pat_seed_a        (test_pat_seed_a        ),
                         .test_pat_seed_b        (test_pat_seed_b        ),
                         .rx_prbs_pat_en         (rx_prbs_pat_en         ),
                         .tx_prbs_pat_en         (tx_prbs_pat_en         ),
                         .rx_test_pat_en         (rx_test_pat_en         ),
                         .tx_test_pat_en         (tx_test_pat_en         ),
                         .test_pat_sel           (test_pat_sel           ),
                         .data_pat_sel           (data_pat_sel           ),
                         .reset_from_md          (reset_from_md          ),
                         `ifdef XFIPCS_16G32GFC
                         .ber_timer_value        (ber_timer_value        ),
                         .lpi_fw                 (lpi_fw                 ),
                         .tx_tw_timer_value      (tx_tw_timer_value      ),
                         .rx_tw_timer_value      (rx_tw_timer_value      ),
                         `endif
                         .tx_hss_t1_value        (tx_hss_t1_value        ),
                         .tx_hss_t2_value        (tx_hss_t2_value        ),
                         .tx_hss_t3_value        (tx_hss_t3_value        ),
                         .rx_hss_t1_value        (rx_hss_t1_value        ),
                         .rx_hss_t3_value        (rx_hss_t3_value        ),
                         .rx_hss_t6_value        (rx_hss_t6_value        )
                 );

endmodule
