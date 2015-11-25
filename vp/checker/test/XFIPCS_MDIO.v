//SCCS File Version= %I% 
//Release Date= 14/04/20  19:56:38 GMT startFileName /vobs/vob012/xfipcs/verilog/rtl/XFIPCS_MDIO.v endFileName  

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

//$Id: XFIPCS_MDIO.v,v 1.9 2014/02/28 05:29:27 huqian Exp $
//$Log: XFIPCS_MDIO.v,v $
//Revision 1.9  2014/02/28 05:29:27  huqian
//Fix HW281758: The error block counter adds twice incorrectly
//
//Revision 1.8  2014/02/21 07:12:00  huqian
//Copy XFIPCS cvs tag v1_135
//
//Revision 1.35  2014/02/21 06:50:29  huqian
//Fix HW280868
//
//Revision 1.34  2014/02/18 07:34:05  huqian
//Condor 4 ASIC FC-EE Support Requirements.pdf item3
//
//Revision 1.33  2014/02/17 08:44:13  huqian
//Condor 4 ASIC FC-EE Support Requirements.pdf item2
//
//Revision 1.32  2014/02/13 08:43:06  huqian
//Add registers ber_timer_value 1 and ber_timer_value 2
//
//Revision 1.31  2013/12/26 05:23:53  huqian
//Update reg_32768/32771/32773 definition for 16G32G; Update reg_32768/32769/32770/32771/32772/32773 reset value for 32G
//
//Revision 1.30  2011/04/29 18:45:58  adamc
//Adding reset values to additional MDIO regs
//
//Revision 1.29  2011/04/08 12:41:22  adamc
//Removed extra serializer on pcs_r_status into MDIO
//
//Revision 1.28  2011/03/22 01:04:07  adamc
//Revert LPI FSM back to prev version. Update MDIO HSS reg write enable
//
//Revision 1.27  2011/03/17 12:49:05  adamc
//cvs_snap v1_61
//
//Revision 1.26  2011/03/16 23:46:53  adamc
//cvs_snap v1_60
//
//Revision 1.25  2011/03/15 02:34:08  adamc
//cvs_snap v1_53
//
//Revision 1.24  2011/03/12 15:55:05  adamc
//cvs_snap v1_52
//
//Revision 1.23  2011/03/11 20:15:46  adamc
//cvs_snap v1_51
//
//Revision 1.22  2011/03/11 19:38:28  adamc
//cvs_snap v1_50
//
//Revision 1.21  2011/03/10 20:32:54  adamc
//cvs_snap v1_1
//
//Revision 1.20  2011/03/09 16:00:57  adamc
//cvs_snap v1_47
//
//Revision 1.19  2011/03/07 21:35:51  adamc
//cvs_snap v1_45
//
//Revision 1.18  2011/03/07 21:26:28  adamc
//cvs_snap v1_44
//
//Revision 1.17  2011/02/17 21:13:08  adamc
//cvs_snap v1_28
//
//Revision 1.16  2011/02/11 15:36:37  adamc
//cvs_snap v1_26
//
//Revision 1.15  2011/02/10 15:16:17  adamc
//cvs_snap v1_24
//
//Revision 1.14  2011/02/08 16:05:11  adamc
//cvs_snap v1_22
//
//Revision 1.13  2011/02/04 14:08:42  adamc
//Fixed regs 0, 1 and 7
//
//Revision 1.12  2011/02/01 14:30:55  adamc
//reg_7 is now a read-only reg
//
//Revision 1.11  2011/01/28 19:10:47  adamc
//cvs_snap v1_16
//
//Revision 1.10  2011/01/26 14:26:44  adamc
//cvs_snap v1_13
//
//Revision 1.9  2011/01/25 18:26:29  adamc
//Fixed mdo_data_out reset
//
//Revision 1.8  2011/01/21 21:27:45  adamc
//Some reset cleanup especially for RX
//
//Revision 1.7  2011/01/19 17:25:04  adamc
//Added *xREFRESH logic
//
//Revision 1.6  2011/01/06 15:12:56  adamc
//Fixed reg_1 index out of bounds
//
//Revision 1.5  2011/01/05 20:36:01  adamc
//Fixed duplicate async drs instantiations
//
//Revision 1.4  2010/12/21 21:30:01  adamc
//added 3.0.10 register
//
//Revision 1.3  2010/12/14 19:45:53  adamc
//AZ updates: reg 20 and 22
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

module `XFIPCS_TOPLEVELNAME_MDIO (
                        mdc,
                        pma_rx_clk,
                        xgmii_clk,
                        reset_to_md,
                        reset_to_pma_rx,
                        reset_to_xgmii_rx,
                        reset_to_xgmii,
`ifdef XFIPCS_16G32GFC                        
                        pma_rx_clk_div2,
                        reset_to_pma_rx_div2,
                        speed_sel_xgmii,
                        scr_bypass_enable,
                        XGMIICLK_425M,
`endif                        

                        block_lock,
                        hi_ber,
                        inc_ber_count,
                        inc_ebc,
                        md_addr,
                        md_data_in,
                        mdi,
                        md_r_w,
                        md_en,
                        pcs_r_status_xgmii,
                        port_address,
                        rx_local_fault_xgmii,
                        tx_local_fault_xgmii,
                        tpec_pma_gray,
                        tpec_15_8_inc_tog,
                        wake_error_counter_inc,
                        tx_active,
                        rx_active,
                        tx_hss_reg_we,
                        rx_hss_reg_we,

                        loopback,
                        loopback_reset,
                        clear_tpec_tog,
                        md_1_2,
                        md_1_7,
                        md_1_8,
                        md_1_9,
                        md_1_10,
                        md_1_11,
                        md_32_0,
                        md_32_1,
                        md_32_12,
                        md_32_2,
                        md_33_7_0,
                        md_33_13_8,
                        md_33_14,
                        md_33_15,
                        md_43_15_0,
                        md_8_10,
                        md_8_11,
                        md_8_15_14,
                        md_22_15_0,
                        md_data_out,
                        mdo,
                        mdo_valid,
                        r_test_mode,
                        test_pat_seed_a,
                        test_pat_seed_b,
                        tx_prbs_pat_en,
                        rx_prbs_pat_en,
                        tx_test_pat_en,
                        rx_test_pat_en,
                        test_pat_sel,
                        data_pat_sel,
                        reset_from_md,
`ifdef XFIPCS_16G32GFC
                        ber_timer_value,
                        lpi_fw,
                        tx_tw_timer_value,
                        rx_tw_timer_value,
`endif
                        tx_hss_t1_value,
                        tx_hss_t2_value,
                        tx_hss_t3_value,
                        rx_hss_t1_value,
                        rx_hss_t3_value,
                        rx_hss_t6_value
                );

// ----------------------------------------------------------------------------
// Inputs/Outputs
// ----------------------------------------------------------------------------
input           pma_rx_clk;
input           mdc;
input           xgmii_clk;
input           reset_to_md;
input           reset_to_pma_rx;
input           reset_to_xgmii_rx;
input           reset_to_xgmii;
`ifdef XFIPCS_16G32GFC
input           pma_rx_clk_div2;
input           reset_to_pma_rx_div2;
input           speed_sel_xgmii;
input           scr_bypass_enable;
input           XGMIICLK_425M;
`endif

input           block_lock;
input           hi_ber;
input           inc_ber_count;
input           inc_ebc;
input   [15:0]  md_addr;
input   [15:0]  md_data_in;
input           mdi;
input           md_r_w;
input           md_en;
input           pcs_r_status_xgmii;
input   [4:0]   port_address;
input           rx_local_fault_xgmii;
input           tx_local_fault_xgmii;
input   [7:0]   tpec_pma_gray;
input           tpec_15_8_inc_tog;
input           wake_error_counter_inc;
input           tx_active;
input           rx_active;
input           tx_hss_reg_we;
input           rx_hss_reg_we;

output          loopback;
output          loopback_reset;
output          md_1_2;
output          md_1_7;
output          md_1_8;
output          md_1_9;
output          md_1_10;
output          md_1_11;
output          md_32_0;
output          md_32_1;
output          md_32_12;
output          md_32_2;
output  [7:0]   md_33_7_0;
output  [5:0]   md_33_13_8;
output          md_33_14;
output          md_33_15;
output  [15:0]  md_43_15_0;
output          md_8_10;
output          md_8_11;
output  [1:0]   md_8_15_14;
output  [15:0]  md_22_15_0;
output  [15:0]  md_data_out;
output          mdo;
output          mdo_valid;
output          r_test_mode;
output  [57:0]  test_pat_seed_a;
output  [57:0]  test_pat_seed_b;
output          rx_prbs_pat_en;
output          tx_prbs_pat_en;
output          rx_test_pat_en;
output          tx_test_pat_en;
output          test_pat_sel;
output          data_pat_sel;
output          reset_from_md;
output          clear_tpec_tog;
`ifdef XFIPCS_16G32GFC
output  [17:0]  ber_timer_value;
output          lpi_fw;
output  [12:0]  tx_tw_timer_value;
output  [12:0]  rx_tw_timer_value;
`endif
output  [10:0]  tx_hss_t1_value;
output  [15:0]  tx_hss_t2_value;
output  [15:0]  tx_hss_t3_value;
output  [15:0]  rx_hss_t3_value;
`ifdef XFIPCS_16G32GFC
output  [17:0]  rx_hss_t1_value;
output  [17:0]  rx_hss_t6_value;
`else
output  [15:0]  rx_hss_t1_value;
output  [15:0]  rx_hss_t6_value;
`endif

// ----------------------------------------------------------------------------
// Internal signals/registers
// ----------------------------------------------------------------------------
wire            clr_wake_error_counter;
reg             clear_tpec_tog;
wire    [57:0]  test_pat_seed_a;
wire    [57:0]  test_pat_seed_b;
wire            rx_prbs_pat_en;
wire            tx_prbs_pat_en;
wire            rx_test_pat_en;
wire            tx_test_pat_en;
wire            test_pat_sel;
wire            data_pat_sel;

wire            loopback;
wire            loopback_reset;
wire            md_1_2;
wire            md_1_7;
wire            md_32_0;
wire            md_32_1;
wire            md_32_12;
wire            md_32_2;
wire    [7:0]   md_33_7_0;
wire    [5:0]   md_33_13_8;
wire            md_33_14;
wire            md_33_15;
wire    [15:0]  md_43_15_0;
wire            md_8_10;
wire            md_8_11;
wire    [1:0]   md_8_15_14;
reg     [15:0]  md_data_out_nxt;
reg     [15:0]  md_data_out;
wire            reset_from_md;
wire            pcs_r_status_ll_nxt;

wire    [5:0]   ber_count_nxt;
reg     [5:0]   ber_count;
wire    [5:0]   ber_count_xgmii_gray;
wire    [5:0]   ber_count_pma_gray_nxt;
reg     [5:0]   ber_count_pma_gray;
wire    [5:0]   ber_count_xgmii_bin_nxt;
reg     [5:0]   ber_count_xgmii_bin;
wire            ber_count_reset_md_nxt;
reg             ber_count_reset_md;
wire            ber_count_reset_xgmii_nxt;
reg             ber_count_reset_xgmii;
wire            ber_count_reset_md_to_xgmii;
wire            ber_count_reset_xgmii_to_pma_rx;
reg             ber_count_reset_pending;
wire            ber_count_reset_pending_nxt;
wire            ber_count_reset_pending_pma_rx;
wire            ber_count_reset_seen;

reg     [7:0]   errored_block_counter;
wire    [7:0]   errored_block_counter_nxt;
wire    [7:0]   errored_block_counter_pma_gray_nxt;
reg     [7:0]   errored_block_counter_pma_gray;
wire    [7:0]   errored_block_counter_xgmii_gray;
wire    [7:0]   errored_block_counter_xgmii_bin_nxt;
reg     [7:0]   errored_block_counter_xgmii_bin;

wire            block_lock_ll_nxt;
wire            fault;
reg             hi_ber_2;
reg             hi_ber_3;
reg             hi_ber_4;
wire            hi_ber_for_xgmii_nxt;
reg             hi_ber_for_xgmii;
wire            hi_ber_lh_nxt;
wire    [1:0]   reg_0_nxt;
wire    [5:0]   reg_1_nxt;
wire    [15:0]  reg_22_nxt;
wire    [3:0]   reg_32_nxt;
wire    [15:0]  reg_33_nxt;
wire    [15:0]  reg_34_nxt;
wire    [15:0]  reg_35_nxt;
wire    [15:0]  reg_36_nxt;
wire    [9:0]   reg_37_nxt;
wire    [15:0]  reg_38_nxt;
wire    [15:0]  reg_39_nxt;
wire    [15:0]  reg_40_nxt;
wire    [9:0]   reg_41_nxt;
wire    [5:0]   reg_42_nxt;
wire    [15:0]  reg_43;
`ifdef XFIPCS_16G32GFC
wire    [14:0]  reg_32768_nxt; // {rx_hss_t1_value[17:16], rx_hss_t6_value[17:16], tx_hss_t1_value[10:0]}
`else
wire    [10:0]  reg_32768_nxt; // tx_hss_t1_value[10:0]
`endif
wire    [15:0]  reg_32769_nxt; // tx_hxx_t2_value
wire    [15:0]  reg_32770_nxt; // tx_hss_t3_value
wire    [15:0]  reg_32771_nxt; // rx_hss_t1_value[15:0]
wire    [15:0]  reg_32772_nxt; // rx_hss_t3_value
wire    [15:0]  reg_32773_nxt; // rx_hss_t6_value[15:0]
`ifdef XFIPCS_16G32GFC
wire    [15:0]  reg_32774_nxt; // ber_timer_value[15:0]
wire    [1:0]   reg_32775_nxt; // ber_timer_value[17:16]
wire            reg_32776_nxt; // lpi_fw
wire    [12:0]  reg_32777_nxt; // tx_tw_timer_value
wire    [12:0]  reg_32778_nxt; // rx_tw_timer_value
`endif
wire    [1:0]   reg_7_nxt;
wire    [3:0]   reg_8_nxt;
wire            rx_local_fault_lh_nxt;
wire            tx_local_fault_lh_nxt;
wire    [15:0]  test_pattern_error_counter;
reg             r_test_mode_xgmii;
wire            r_test_mode;
wire            r_test_mode_nxt;

reg     [15:0]  addr_reg;
reg     [4:0]   bit_count;
reg     [15:0]  data_reg;
reg     [15:0]  data_reg_read_nxt;
reg     [4:0]   devad_reg;
reg             mdo;
reg             mdo_valid;
reg     [3:0]   md_state;
reg     [1:0]   op_reg;
reg     [4:0]   prtad_reg;
reg     [1:0]   reg_0;
reg     [5:0]   reg_1;
reg     [15:0]  reg_22;
reg     [3:0]   reg_32;
reg     [15:0]  reg_33;
reg     [15:0]  reg_34;
reg     [15:0]  reg_35;
reg     [15:0]  reg_36;
reg     [9:0]   reg_37;
reg     [15:0]  reg_38;
reg     [15:0]  reg_39;
reg     [15:0]  reg_40;
reg     [9:0]   reg_41;
reg     [5:0]   reg_42;
reg     [1:0]   reg_7;
reg     [3:0]   reg_8;
`ifdef XFIPCS_16G32GFC
reg     [14:0]  reg_32768;
`else
reg     [10:0]  reg_32768;
`endif
reg     [15:0]  reg_32769;
reg     [15:0]  reg_32770;
reg     [15:0]  reg_32771;
reg     [15:0]  reg_32772;
reg     [15:0]  reg_32773;
`ifdef XFIPCS_16G32GFC
reg     [15:0]  reg_32774;
reg     [1:0]   reg_32775;
reg             reg_32776;
reg     [12:0]  reg_32777;
reg     [12:0]  reg_32778;
`endif
reg             valid_md_access;
reg             write_reg_0;
reg             write_reg_7;
reg             write_reg_34;
reg             write_reg_35;
reg             write_reg_36;
reg             write_reg_37;
reg             write_reg_38;
reg             write_reg_39;
reg             write_reg_40;
reg             write_reg_41;
reg             write_reg_42;
reg             write_reg_32768;
reg             write_reg_32769;
reg             write_reg_32770;
reg             write_reg_32771;
reg             write_reg_32772;
reg             write_reg_32773;
`ifdef XFIPCS_16G32GFC
reg             write_reg_32774;
reg             write_reg_32775;
reg             write_reg_32776;
reg             write_reg_32777;
reg             write_reg_32778;
`endif

reg     [15:0]  addr_reg_nxt;
wire    [15:0]  addr_reg_xgmii;
reg     [4:0]   bit_count_nxt;
reg     [15:0]  data_reg_nxt;
reg     [4:0]   devad_reg_nxt;
reg             mdo_nxt;
reg             mdo_valid_nxt;
reg             md_read_reg_1;
wire            md_read_reg_1_nxt;
wire            md_read_reg_1_xgmii;
reg             md_read_reg_33;
wire            md_read_reg_33_nxt;
wire            md_read_reg_33_xgmii;
reg             md_read_reg_43;
wire            md_read_reg_43_nxt;
wire            md_read_reg_43_xgmii;
reg             md_read_reg_8;
wire            md_read_reg_8_nxt;
wire            md_read_reg_8_xgmii;
reg             md_read_reg_22;
wire            md_read_reg_22_nxt;
wire            md_read_reg_22_xgmii;
reg     [3:0]   md_state_nxt;
reg     [1:0]   op_reg_nxt;
reg     [4:0]   prtad_reg_nxt;
reg             valid_md_access_nxt;
reg             write_reg_0_nxt;
reg             write_reg_34_nxt;
reg             write_reg_35_nxt;
reg             write_reg_36_nxt;
reg             write_reg_37_nxt;
reg             write_reg_38_nxt;
reg             write_reg_39_nxt;
reg             write_reg_40_nxt;
reg             write_reg_41_nxt;
reg             write_reg_42_nxt;
reg             write_reg_32768_nxt;
reg             write_reg_32769_nxt;
reg             write_reg_32770_nxt;
reg             write_reg_32771_nxt;
reg             write_reg_32772_nxt;
reg             write_reg_32773_nxt;
`ifdef XFIPCS_16G32GFC
reg             write_reg_32774_nxt;
reg             write_reg_32775_nxt;
reg             write_reg_32776_nxt;
reg             write_reg_32777_nxt;
reg             write_reg_32778_nxt;
`endif
reg             write_reg_7_nxt;
wire            write_reg_0_xgmii;
wire            write_reg_34_xgmii;
wire            write_reg_35_xgmii;
wire            write_reg_36_xgmii;
wire            write_reg_37_xgmii;
wire            write_reg_38_xgmii;
wire            write_reg_39_xgmii;
wire            write_reg_40_xgmii;
wire            write_reg_41_xgmii;
wire            write_reg_42_xgmii;
wire            write_reg_7_xgmii;
wire            write_reg_32768_xgmii;
wire            write_reg_32769_xgmii;
wire            write_reg_32770_xgmii;
wire            write_reg_32771_xgmii;
wire            write_reg_32772_xgmii;
wire            write_reg_32773_xgmii;
`ifdef XFIPCS_16G32GFC
wire            write_reg_32774_xgmii;
wire            write_reg_32775_xgmii;
wire            write_reg_32776_xgmii;
wire            write_reg_32777_xgmii;
wire            write_reg_32778_xgmii;
`endif

wire            reset_for_mdc;
reg             reset_from_xgmii_to_mdc_1;
reg             reset_from_xgmii_to_mdc_2;

wire            hi_ber_xgmii;

wire    [15:0]  data_reg_xgmii;

reg     [7:0]   tpec_15_8;
wire    [7:0]   tpec_15_8_nxt;
wire            tpec_15_8_inc;
wire            tpec_15_8_dec;
wire    [7:0]   tpec_xgmii_gray;
wire    [7:0]   tpec_xgmii_bin_nxt;
wire    [7:0]   tpec_xgmii_bin_in;
reg     [7:0]   tpec_xgmii_bin;
wire            clear_tpec;
reg             clear_tpec_r1;
wire            clear_tpec_tog_nxt;
wire    [3:0]   clear_tpec_count_nxt ;
reg     [3:0]   clear_tpec_count ;

wire    [3:0]   reset_count_nxt;
reg     [3:0]   reset_count;

wire            allow_parallel_mdio_nxt;
reg             allow_parallel_mdio;
wire            allow_parallel_mdio_xgmii;
wire            md_en_valid ;

reg             loopback_prev;
wire    [2:0]   loopback_count_nxt;
reg     [2:0]   loopback_count;

reg     [15:0]  data_reg_read_freeze;
wire    [15:0]  data_reg_read_freeze_wam;
wire    [15:0]  data_reg_read_freeze_nxt;
reg             data_reg_read_now_nxt;
reg             data_reg_read_now;
wire            data_reg_read_now_xgmii;
reg             data_reg_read_now_prev;

wire            rx_lpi_indication;
wire            rx_lpi_indication_nxt;
wire            tx_lpi_indication;
wire            tx_lpi_indication_nxt;
wire            rx_lpi_received;
wire            rx_lpi_received_nxt;
wire            tx_lpi_received;
wire            tx_lpi_received_nxt;

reg  [1:0]      gray_code_reset;
wire [1:0]      gray_code_reset_nxt;


// ----------------------------------------------------------------------------
// Parameters
// ----------------------------------------------------------------------------
parameter       IDLE     = 4'h0;
parameter       PRE      = 4'h1;
parameter       ST       = 4'h2;
parameter       OP       = 4'h3;
parameter       PRTAD    = 4'h4;
parameter       DEVAD    = 4'h5;
parameter       TA1      = 4'h6;
parameter       TA2      = 4'h7;
parameter       ADDRESS  = 4'h9;
parameter       WRITEDATA= 4'ha;
parameter       READDATA = 4'hb;
parameter       MYDEVAD  = 5'h03;
parameter       ADDR     = 2'b00;
parameter       WRITE    = 2'b01;
parameter       READ     = 2'b11;
parameter       READ_INC = 2'b10;

// ----------------------------------------------------------------------------
// Implementation
// ----------------------------------------------------------------------------
 `ifdef XFIPCS_16G32GFC
 reg XGMIICLK_425M_r1;
 always @(posedge xgmii_clk) begin
   XGMIICLK_425M_r1 <= XGMIICLK_425M;
 end
 `endif

 assign clr_wake_error_counter = md_read_reg_22_xgmii |
                                 (md_r_w & (md_addr == 16'h0016) & md_en_valid);

 assign hi_ber_for_xgmii_nxt = hi_ber || hi_ber_2 || hi_ber_3 || hi_ber_4;

 assign allow_parallel_mdio_nxt = md_state == 4'h0 || md_state == 4'h1;

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async093(.clk      (xgmii_clk), .data_in  (allow_parallel_mdio ), .data_out (allow_parallel_mdio_xgmii ) );

 assign          md_en_valid = md_en && allow_parallel_mdio_xgmii ;

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1) async001(.clk      (xgmii_clk), .data_in  (hi_ber_for_xgmii    ), .data_out (hi_ber_xgmii) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async004(.clk      (xgmii_clk), .data_in  (write_reg_0), .data_out (write_reg_0_xgmii) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async005(.clk      (xgmii_clk), .data_in  (write_reg_7), .data_out (write_reg_7_xgmii) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async006(.clk      (xgmii_clk), .data_in  (write_reg_34), .data_out (write_reg_34_xgmii) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async007(.clk      (xgmii_clk), .data_in  (write_reg_35), .data_out (write_reg_35_xgmii) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async008(.clk      (xgmii_clk), .data_in  (write_reg_36), .data_out (write_reg_36_xgmii) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async009(.clk      (xgmii_clk), .data_in  (write_reg_37), .data_out (write_reg_37_xgmii) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async010(.clk      (xgmii_clk), .data_in  (write_reg_38), .data_out (write_reg_38_xgmii) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async011(.clk      (xgmii_clk), .data_in  (write_reg_39), .data_out (write_reg_39_xgmii) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async012(.clk      (xgmii_clk), .data_in  (write_reg_40), .data_out (write_reg_40_xgmii) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async013(.clk      (xgmii_clk), .data_in  (write_reg_41), .data_out (write_reg_41_xgmii) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async014(.clk      (xgmii_clk), .data_in  (write_reg_42), .data_out (write_reg_42_xgmii) );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async200(.clk      (xgmii_clk), .data_in  (write_reg_32768), .data_out (write_reg_32768_xgmii) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async201(.clk      (xgmii_clk), .data_in  (write_reg_32769), .data_out (write_reg_32769_xgmii) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async202(.clk      (xgmii_clk), .data_in  (write_reg_32770), .data_out (write_reg_32770_xgmii) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async203(.clk      (xgmii_clk), .data_in  (write_reg_32771), .data_out (write_reg_32771_xgmii) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async204(.clk      (xgmii_clk), .data_in  (write_reg_32772), .data_out (write_reg_32772_xgmii) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async205(.clk      (xgmii_clk), .data_in  (write_reg_32773), .data_out (write_reg_32773_xgmii) );
 `ifdef XFIPCS_16G32GFC
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async206(.clk      (xgmii_clk), .data_in  (write_reg_32774), .data_out (write_reg_32774_xgmii) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async207(.clk      (xgmii_clk), .data_in  (write_reg_32775), .data_out (write_reg_32775_xgmii) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async208(.clk      (xgmii_clk), .data_in  (write_reg_32776), .data_out (write_reg_32776_xgmii) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async209(.clk      (xgmii_clk), .data_in  (write_reg_32777), .data_out (write_reg_32777_xgmii) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async210(.clk      (xgmii_clk), .data_in  (write_reg_32778), .data_out (write_reg_32778_xgmii) );
 `endif

 always @(*) begin
   if (md_r_w && md_en_valid) begin
     case (md_addr)
       16'h0000: md_data_out_nxt = {reg_0[1:0], 3'b100, 11'h040};
       16'h0001: md_data_out_nxt = {4'h0, reg_1[5:1], 4'h0, reg_1[0], 2'h0};
       16'h0004: md_data_out_nxt = 16'h0001;
       16'h0005: md_data_out_nxt = 16'h0008;
       16'h0007: md_data_out_nxt = {14'h0000, reg_7};
 `ifdef XFIPCS_TOPLEVELNAME_WIS_ENABLED
       16'h0008: md_data_out_nxt = {reg_8[3:2], 2'h0, reg_8[1:0], 10'h004};
 `else
       16'h0008: md_data_out_nxt = {reg_8[3:2], 2'h0, reg_8[1:0], 10'h001};
 `endif
       16'h0014: md_data_out_nxt = 16'h0040; // EEE is enabled
       16'h0016: md_data_out_nxt = reg_22; // wake_error_counter
       16'h0020: md_data_out_nxt = {3'h0, reg_32[3], 9'h000, reg_32[2:0]};
       16'h0021: md_data_out_nxt = reg_33;
       16'h0022: md_data_out_nxt = reg_34;
       16'h0023: md_data_out_nxt = reg_35;
       16'h0024: md_data_out_nxt = reg_36;
       16'h0025: md_data_out_nxt = {6'h00, reg_37};
       16'h0026: md_data_out_nxt = reg_38;
       16'h0027: md_data_out_nxt = reg_39;
       16'h0028: md_data_out_nxt = reg_40;
       16'h0029: md_data_out_nxt = {6'h00, reg_41};
       16'h002a: md_data_out_nxt = {10'h000, reg_42};
       16'h002b: md_data_out_nxt = reg_43;

       // vendor specific regs
       `ifdef XFIPCS_16G32GFC
       16'h8000: md_data_out_nxt = {1'b0, reg_32768};
       `else
       16'h8000: md_data_out_nxt = {5'h00, reg_32768};
       `endif
       16'h8001: md_data_out_nxt = reg_32769;
       16'h8002: md_data_out_nxt = reg_32770;
       16'h8003: md_data_out_nxt = reg_32771;
       16'h8004: md_data_out_nxt = reg_32772;
       16'h8005: md_data_out_nxt = reg_32773;
       `ifdef XFIPCS_16G32GFC
       16'h8006: md_data_out_nxt = reg_32774;
       16'h8007: md_data_out_nxt = {14'h0, reg_32775};
       16'h8008: md_data_out_nxt = {15'h0, reg_32776};
       16'h8009: md_data_out_nxt = {3'h0, reg_32777};
       16'h800a: md_data_out_nxt = {3'h0, reg_32778};
       `endif
       default: md_data_out_nxt = 16'h0000;
     endcase
   end else begin
     md_data_out_nxt = md_data_out;
   end
 end

 always @(*) begin
   case (addr_reg_xgmii)
     16'h0000: data_reg_read_nxt = {reg_0[1:0], 3'b100, 11'h040};
     16'h0001: data_reg_read_nxt = {4'h0, reg_1[5:1], 4'h0, reg_1[0], 2'h0};
     16'h0004: data_reg_read_nxt = 16'h0001;
     16'h0005: data_reg_read_nxt = 16'h0008;
     16'h0007: data_reg_read_nxt = {14'h0000, reg_7};
 `ifdef XFIPCS_TOPLEVELNAME_WIS_ENABLED
     16'h0008: data_reg_read_nxt = {reg_8[3:2], 2'h0, reg_8[1:0], 10'h004};
 `else
     16'h0008: data_reg_read_nxt = {reg_8[3:2], 2'h0, reg_8[1:0], 10'h001};
 `endif
     16'h0014: data_reg_read_nxt = 16'h0040; // EEE is enabled
     16'h0016: data_reg_read_nxt = reg_22; // wake_error_counter
     16'h0020: data_reg_read_nxt = {3'h0, reg_32[3], 9'h000, reg_32[2:0]};
     16'h0021: data_reg_read_nxt = reg_33;
     16'h0022: data_reg_read_nxt = reg_34;
     16'h0023: data_reg_read_nxt = reg_35;
     16'h0024: data_reg_read_nxt = reg_36;
     16'h0025: data_reg_read_nxt = {6'h00, reg_37};
     16'h0026: data_reg_read_nxt = reg_38;
     16'h0027: data_reg_read_nxt = reg_39;
     16'h0028: data_reg_read_nxt = reg_40;
     16'h0029: data_reg_read_nxt = {6'h00, reg_41};
     16'h002a: data_reg_read_nxt = {10'h000, reg_42};
     16'h002b: data_reg_read_nxt = reg_43;

     // vendor specific regs
     `ifdef XFIPCS_16G32GFC
     16'h8000: data_reg_read_nxt = {1'b0, reg_32768};
     `else
     16'h8000: data_reg_read_nxt = {5'h00, reg_32768};
     `endif
     16'h8001: data_reg_read_nxt = reg_32769;
     16'h8002: data_reg_read_nxt = reg_32770;
     16'h8003: data_reg_read_nxt = reg_32771;
     16'h8004: data_reg_read_nxt = reg_32772;
     16'h8005: data_reg_read_nxt = reg_32773;
     `ifdef XFIPCS_16G32GFC
     16'h8006: data_reg_read_nxt = reg_32774;
     16'h8007: data_reg_read_nxt = {14'h0, reg_32775};
     16'h8008: data_reg_read_nxt = {15'h0, reg_32776};
     16'h8009: data_reg_read_nxt = {3'h0, reg_32777};
     16'h800a: data_reg_read_nxt = {3'h0, reg_32778};
     `endif
     default: data_reg_read_nxt = 16'h0000;
   endcase
 end

 assign data_reg_read_freeze_nxt =
          data_reg_read_now_xgmii && ~data_reg_read_now_prev ?
                                      data_reg_read_nxt : data_reg_read_freeze ;

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async102(.clk (xgmii_clk), .data_in (data_reg_read_now), .data_out (data_reg_read_now_xgmii) );

 `ifdef XFIPCS_TOPLEVELNAME_WAM_ON
 wam wam000(.datain(data_reg_read_freeze[  0]), .dataout(data_reg_read_freeze_wam[  0]), .dst_clk(mdc));
 wam wam001(.datain(data_reg_read_freeze[  1]), .dataout(data_reg_read_freeze_wam[  1]), .dst_clk(mdc));
 wam wam002(.datain(data_reg_read_freeze[  2]), .dataout(data_reg_read_freeze_wam[  2]), .dst_clk(mdc));
 wam wam003(.datain(data_reg_read_freeze[  3]), .dataout(data_reg_read_freeze_wam[  3]), .dst_clk(mdc));
 wam wam004(.datain(data_reg_read_freeze[  4]), .dataout(data_reg_read_freeze_wam[  4]), .dst_clk(mdc));
 wam wam005(.datain(data_reg_read_freeze[  5]), .dataout(data_reg_read_freeze_wam[  5]), .dst_clk(mdc));
 wam wam006(.datain(data_reg_read_freeze[  6]), .dataout(data_reg_read_freeze_wam[  6]), .dst_clk(mdc));
 wam wam007(.datain(data_reg_read_freeze[  7]), .dataout(data_reg_read_freeze_wam[  7]), .dst_clk(mdc));
 wam wam008(.datain(data_reg_read_freeze[  8]), .dataout(data_reg_read_freeze_wam[  8]), .dst_clk(mdc));
 wam wam009(.datain(data_reg_read_freeze[  9]), .dataout(data_reg_read_freeze_wam[  9]), .dst_clk(mdc));
 wam wam010(.datain(data_reg_read_freeze[ 10]), .dataout(data_reg_read_freeze_wam[ 10]), .dst_clk(mdc));
 wam wam011(.datain(data_reg_read_freeze[ 11]), .dataout(data_reg_read_freeze_wam[ 11]), .dst_clk(mdc));
 wam wam012(.datain(data_reg_read_freeze[ 12]), .dataout(data_reg_read_freeze_wam[ 12]), .dst_clk(mdc));
 wam wam013(.datain(data_reg_read_freeze[ 13]), .dataout(data_reg_read_freeze_wam[ 13]), .dst_clk(mdc));
 wam wam014(.datain(data_reg_read_freeze[ 14]), .dataout(data_reg_read_freeze_wam[ 14]), .dst_clk(mdc));
 wam wam015(.datain(data_reg_read_freeze[ 15]), .dataout(data_reg_read_freeze_wam[ 15]), .dst_clk(mdc));
 `else
 assign data_reg_read_freeze_wam = data_reg_read_freeze ;
 `endif

 always @(*) begin
   write_reg_0_nxt = 1'b0;
   write_reg_7_nxt = 1'b0;
   write_reg_34_nxt = 1'b0;
   write_reg_35_nxt = 1'b0;
   write_reg_36_nxt = 1'b0;
   write_reg_37_nxt = 1'b0;
   write_reg_38_nxt = 1'b0;
   write_reg_39_nxt = 1'b0;
   write_reg_40_nxt = 1'b0;
   write_reg_41_nxt = 1'b0;
   write_reg_42_nxt = 1'b0;
   write_reg_32768_nxt = 1'b0;
   write_reg_32769_nxt = 1'b0;
   write_reg_32770_nxt = 1'b0;
   write_reg_32771_nxt = 1'b0;
   write_reg_32772_nxt = 1'b0;
   write_reg_32773_nxt = 1'b0;
   `ifdef XFIPCS_16G32GFC
   write_reg_32774_nxt = 1'b0;
   write_reg_32775_nxt = 1'b0;
   write_reg_32776_nxt = 1'b0;
   write_reg_32777_nxt = 1'b0;
   write_reg_32778_nxt = 1'b0;
   `endif

   md_state_nxt = md_state;
   bit_count_nxt = bit_count;
   op_reg_nxt = op_reg;
   prtad_reg_nxt = prtad_reg;
   devad_reg_nxt = devad_reg;
   valid_md_access_nxt = valid_md_access;
   mdo_nxt = 1'b0;
   mdo_valid_nxt = 1'b0;
   data_reg_nxt = data_reg;
   addr_reg_nxt = addr_reg;
   data_reg_read_now_nxt = 1'b0;

   case (md_state)
     IDLE:
       if (mdi == 1'b1) begin
         md_state_nxt = PRE;
         valid_md_access_nxt = 1'b1;
       end
     PRE:
       if (mdi == 1'b0) begin
         bit_count_nxt = 5'h00;
         if (bit_count == 5'h1f) md_state_nxt = ST;
         else begin
           md_state_nxt = IDLE;
           valid_md_access_nxt = 1'b0;
         end
       end
       else if (~&bit_count) bit_count_nxt = bit_count + 1;
     ST:
       if (bit_count == 5'h01) begin
         bit_count_nxt = 5'h00;
         md_state_nxt = OP;
         op_reg_nxt = {op_reg[0], mdi};
       end else
       if (mdi == 1'b1) begin
         valid_md_access_nxt = 1'b0;
         md_state_nxt = IDLE;
       end else bit_count_nxt = 5'h01;
     OP: begin
       if (bit_count == 5'h01) begin
         md_state_nxt = PRTAD;
         prtad_reg_nxt = {prtad_reg[3:0], mdi};
         bit_count_nxt = 5'h00;
       end else begin
         op_reg_nxt = {op_reg[0], mdi};
         bit_count_nxt = 5'h01;
       end
     end
     PRTAD: begin
       if (op_reg == READ || op_reg == READ_INC) data_reg_read_now_nxt = 1'b1;
       if (bit_count == 5'h04) begin
         devad_reg_nxt = {devad_reg[3:0], mdi};
         md_state_nxt = DEVAD;
         bit_count_nxt = 5'h00;
       end else begin
         prtad_reg_nxt = {prtad_reg[3:0], mdi};
         bit_count_nxt = bit_count + 1;
       end
     end
     DEVAD: begin
       if (bit_count == 5'h04) begin
         bit_count_nxt = 5'h00;
         if (prtad_reg == port_address && devad_reg == MYDEVAD) begin
           if (op_reg == READ || op_reg == READ_INC) begin
             md_state_nxt = READDATA;
             data_reg_nxt = data_reg_read_freeze_wam;
             mdo_valid_nxt = 1'b1;
             mdo_nxt = 1'b0;
           end else md_state_nxt = TA1;
         end else begin
           md_state_nxt = TA1;
           valid_md_access_nxt = 1'b0;
         end
       end else begin
         bit_count_nxt = bit_count + 1;
         devad_reg_nxt = {devad_reg[3:0], mdi};
       end
     end
     TA1: md_state_nxt = TA2;
     TA2: begin
       if (op_reg == ADDR) begin
         md_state_nxt = ADDRESS;
         if (valid_md_access == 1'b1) addr_reg_nxt = {addr_reg[14:0], mdi};
       end
       else begin
         md_state_nxt = WRITEDATA;
         data_reg_nxt = {data_reg[14:0], mdi};
       end
     end
     READDATA: begin
       data_reg_nxt = {data_reg[14:0], data_reg[15]};
       mdo_nxt = data_reg[15];
       mdo_valid_nxt = 1'b1;
       if (bit_count == 5'h0f) begin
         md_state_nxt = IDLE;
         valid_md_access_nxt = 1'b0;
         bit_count_nxt = 5'h00;
         if ((op_reg == READ_INC) && (addr_reg != 16'hffff) &&
             (valid_md_access == 1'b1)) addr_reg_nxt = addr_reg + 1;
       end else bit_count_nxt = bit_count + 1;
     end
     WRITEDATA: begin
       if (bit_count == 5'h0f) begin
         md_state_nxt = IDLE;
         valid_md_access_nxt = 1'b0;
         bit_count_nxt = 5'h00;
         if (valid_md_access == 1'b1) begin
           if (addr_reg == 16'h0000) write_reg_0_nxt = 1'b1;
           if (addr_reg == 16'h0007) write_reg_7_nxt = 1'b1;
           if (addr_reg == 16'h0022) write_reg_34_nxt = 1'b1;
           if (addr_reg == 16'h0023) write_reg_35_nxt = 1'b1;
           if (addr_reg == 16'h0024) write_reg_36_nxt = 1'b1;
           if (addr_reg == 16'h0025) write_reg_37_nxt = 1'b1;
           if (addr_reg == 16'h0026) write_reg_38_nxt = 1'b1;
           if (addr_reg == 16'h0027) write_reg_39_nxt = 1'b1;
           if (addr_reg == 16'h0028) write_reg_40_nxt = 1'b1;
           if (addr_reg == 16'h0029) write_reg_41_nxt = 1'b1;
           if (addr_reg == 16'h002a) write_reg_42_nxt = 1'b1;
           if (addr_reg == 16'h8000) write_reg_32768_nxt = 1'b1;
           if (addr_reg == 16'h8001) write_reg_32769_nxt = 1'b1;
           if (addr_reg == 16'h8002) write_reg_32770_nxt = 1'b1;
           if (addr_reg == 16'h8003) write_reg_32771_nxt = 1'b1;
           if (addr_reg == 16'h8004) write_reg_32772_nxt = 1'b1;
           if (addr_reg == 16'h8005) write_reg_32773_nxt = 1'b1;
           `ifdef XFIPCS_16G32GFC
           if (addr_reg == 16'h8006) write_reg_32774_nxt = 1'b1;
           if (addr_reg == 16'h8007) write_reg_32775_nxt = 1'b1;
           if (addr_reg == 16'h8008) write_reg_32776_nxt = 1'b1;
           if (addr_reg == 16'h8009) write_reg_32777_nxt = 1'b1;
           if (addr_reg == 16'h800a) write_reg_32778_nxt = 1'b1;
           `endif
         end
       end
       else begin
         bit_count_nxt = bit_count + 1;
         data_reg_nxt = {data_reg[14:0], mdi};
       end
     end
     ADDRESS: begin
       if (bit_count == 5'h0f) begin
         md_state_nxt = IDLE;
         valid_md_access_nxt = 1'b0;
         bit_count_nxt = 5'h00;
       end else begin
         bit_count_nxt = bit_count + 1;
         if (valid_md_access == 1'b1)
          addr_reg_nxt = {addr_reg[14:0], mdi};
       end
     end
     default: begin
       md_state_nxt = IDLE;
       valid_md_access_nxt = 1'b0;
       bit_count_nxt = 5'h00;
     end
   endcase
 end

 always @(posedge mdc or posedge reset_to_xgmii) begin
   if (reset_to_xgmii) begin
     reset_from_xgmii_to_mdc_1 <= 1'b1;
     reset_from_xgmii_to_mdc_2 <= 1'b1;
   end else begin
     reset_from_xgmii_to_mdc_1 <= 1'b0;
     reset_from_xgmii_to_mdc_2 <= reset_from_xgmii_to_mdc_1;
   end
 end

 assign reset_for_mdc = reset_from_xgmii_to_mdc_2;

 always @(posedge mdc or posedge reset_for_mdc) begin
   if (reset_for_mdc) begin
     md_state <= IDLE;
     md_read_reg_1 <= 1'b0;
     md_read_reg_8 <= 1'b0;
     md_read_reg_22 <= 1'b0;
     md_read_reg_33 <= 1'b0;
     md_read_reg_43 <= 1'b0;
     bit_count <= 5'h00;
     write_reg_0 <= 1'b0;
     write_reg_7 <= 1'b0;
     write_reg_34 <= 1'b0;
     write_reg_35 <= 1'b0;
     write_reg_36 <= 1'b0;
     write_reg_37 <= 1'b0;
     write_reg_38 <= 1'b0;
     write_reg_39 <= 1'b0;
     write_reg_40 <= 1'b0;
     write_reg_41 <= 1'b0;
     write_reg_42 <= 1'b0;
     write_reg_32768 <= 1'b0;
     write_reg_32769 <= 1'b0;
     write_reg_32770 <= 1'b0;
     write_reg_32771 <= 1'b0;
     write_reg_32772 <= 1'b0;
     write_reg_32773 <= 1'b0;
     `ifdef XFIPCS_16G32GFC
     write_reg_32774 <= 1'b0;
     write_reg_32775 <= 1'b0;
     write_reg_32776 <= 1'b0;
     write_reg_32777 <= 1'b0;
     write_reg_32778 <= 1'b0;
     `endif
     mdo <= 1'b0;
     mdo_valid <= 1'b0;
     addr_reg <= 16'h0000;
     data_reg <= 16'h0000;
     op_reg <= 2'h0;
     prtad_reg <= 5'h00;
     devad_reg <= 5'h00;
     valid_md_access <= 1'b0;
     ber_count_reset_md <= 1'b0;
     allow_parallel_mdio <= 1'b1;
     data_reg_read_now <= 1'b0;
   end else begin
     md_state <= md_state_nxt;
     md_read_reg_1 <= md_read_reg_1_nxt;
     md_read_reg_8 <= md_read_reg_8_nxt;
     md_read_reg_22 <= md_read_reg_22_nxt;
     md_read_reg_33 <= md_read_reg_33_nxt;
     md_read_reg_43 <= md_read_reg_43_nxt;
     bit_count <= bit_count_nxt;
     write_reg_0 <= write_reg_0_nxt;
     write_reg_7 <= write_reg_7_nxt;
     write_reg_34 <= write_reg_34_nxt;
     write_reg_35 <= write_reg_35_nxt;
     write_reg_36 <= write_reg_36_nxt;
     write_reg_37 <= write_reg_37_nxt;
     write_reg_38 <= write_reg_38_nxt;
     write_reg_39 <= write_reg_39_nxt;
     write_reg_40 <= write_reg_40_nxt;
     write_reg_41 <= write_reg_41_nxt;
     write_reg_42 <= write_reg_42_nxt;
     write_reg_32768 <= write_reg_32768_nxt;
     write_reg_32769 <= write_reg_32769_nxt;
     write_reg_32770 <= write_reg_32770_nxt;
     write_reg_32771 <= write_reg_32771_nxt;
     write_reg_32772 <= write_reg_32772_nxt;
     write_reg_32773 <= write_reg_32773_nxt;
     `ifdef XFIPCS_16G32GFC
     write_reg_32774 <= write_reg_32774_nxt;
     write_reg_32775 <= write_reg_32775_nxt;
     write_reg_32776 <= write_reg_32776_nxt;
     write_reg_32777 <= write_reg_32777_nxt;
     write_reg_32778 <= write_reg_32778_nxt;
     `endif
     mdo <= mdo_nxt;
     mdo_valid <= mdo_valid_nxt;
     addr_reg <= addr_reg_nxt;
     data_reg <= data_reg_nxt;
     op_reg <= op_reg_nxt;
     prtad_reg <= prtad_reg_nxt;
     devad_reg <= devad_reg_nxt;
     valid_md_access <= valid_md_access_nxt;
     ber_count_reset_md <= ber_count_reset_md_nxt;
     allow_parallel_mdio <= allow_parallel_mdio_nxt;
     data_reg_read_now <= data_reg_read_now_nxt;
   end
 end

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async049(.clk (xgmii_clk), .data_in (md_read_reg_33), .data_out (md_read_reg_33_xgmii) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async083(.clk (xgmii_clk), .data_in (md_read_reg_43), .data_out (md_read_reg_43_xgmii) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async050(.clk (xgmii_clk), .data_in (md_read_reg_8), .data_out (md_read_reg_8_xgmii) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async100(.clk (xgmii_clk), .data_in (md_read_reg_22), .data_out (md_read_reg_22_xgmii) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async081(.clk (xgmii_clk), .data_in (md_read_reg_1), .data_out (md_read_reg_1_xgmii) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(.SHORT_DELAY(1)) async051(.clk (xgmii_clk), .data_in (ber_count_pma_gray[0]), .data_out (ber_count_xgmii_gray[0]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(.SHORT_DELAY(1)) async052(.clk (xgmii_clk), .data_in (ber_count_pma_gray[1]), .data_out (ber_count_xgmii_gray[1]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(.SHORT_DELAY(1)) async053(.clk (xgmii_clk), .data_in (ber_count_pma_gray[2]), .data_out (ber_count_xgmii_gray[2]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(.SHORT_DELAY(1)) async054(.clk (xgmii_clk), .data_in (ber_count_pma_gray[3]), .data_out (ber_count_xgmii_gray[3]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(.SHORT_DELAY(1)) async055(.clk (xgmii_clk), .data_in (ber_count_pma_gray[4]), .data_out (ber_count_xgmii_gray[4]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(.SHORT_DELAY(1)) async056(.clk (xgmii_clk), .data_in (ber_count_pma_gray[5]), .data_out (ber_count_xgmii_gray[5]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(.SHORT_DELAY(1), .NO_XSTATE(1)) async057(.clk (xgmii_clk), .data_in (errored_block_counter_pma_gray[0]), .data_out (errored_block_counter_xgmii_gray[0]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(.SHORT_DELAY(1)) async058(.clk (xgmii_clk), .data_in (errored_block_counter_pma_gray[1]), .data_out (errored_block_counter_xgmii_gray[1]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(.SHORT_DELAY(1)) async059(.clk (xgmii_clk), .data_in (errored_block_counter_pma_gray[2]), .data_out (errored_block_counter_xgmii_gray[2]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(.SHORT_DELAY(1)) async060(.clk (xgmii_clk), .data_in (errored_block_counter_pma_gray[3]), .data_out (errored_block_counter_xgmii_gray[3]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(.SHORT_DELAY(1)) async061(.clk (xgmii_clk), .data_in (errored_block_counter_pma_gray[4]), .data_out (errored_block_counter_xgmii_gray[4]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(.SHORT_DELAY(1)) async062(.clk (xgmii_clk), .data_in (errored_block_counter_pma_gray[5]), .data_out (errored_block_counter_xgmii_gray[5]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(.SHORT_DELAY(1)) async063(.clk (xgmii_clk), .data_in (errored_block_counter_pma_gray[6]), .data_out (errored_block_counter_xgmii_gray[6]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(.SHORT_DELAY(1)) async064(.clk (xgmii_clk), .data_in (errored_block_counter_pma_gray[7]), .data_out (errored_block_counter_xgmii_gray[7]) );

 // simple reset counter to gate off effects of a reset passing through the gray coding logic
 // (reset can cause multiple bits to flip)
 assign gray_code_reset_nxt = (gray_code_reset == 2'h0) ? gray_code_reset : gray_code_reset - 2'h1;

 always @(posedge xgmii_clk) begin
  if (reset_to_xgmii_rx) begin
   gray_code_reset <= 2'h3;
  end else begin
   gray_code_reset <= gray_code_reset_nxt;
  end
 end


 always @(posedge xgmii_clk) begin
  if (reset_to_xgmii) begin
   md_data_out <= 16'h0000;
   data_reg_read_freeze <= 16'h0000;
   clear_tpec_count <= 4'h0;
   clear_tpec_r1 <= 1'b0;
   tpec_15_8 <= 8'h00;
   reg_0 <= 2'b00;
   reg_1 <= 6'h00;

 `ifdef XFIPCS_TOPLEVELNAME_WIS_ENABLED
   reg_7 <= 2'b10;
 `else
   reg_7 <= 2'b00;
 `endif

   reg_8 <= 4'h8;
   reg_32 <= 4'h4;
   reg_33 <= 16'h0000;
   reg_34 <= 16'h0000;
   reg_35 <= 16'h0000;
   reg_36 <= 16'h0000;
   reg_37 <= 10'h000;
   reg_38 <= 16'h0000;
   reg_39 <= 16'h0000;
   reg_40 <= 16'h0000;
   reg_41 <= 10'h000;
   reg_42 <= 6'h00;
   `ifdef XFIPCS_16G32GFC
   reg_32768[14:13] <= `XFIPCS_RX_HSS_T1_BITS1716_VALUE_DEFAULT;
   reg_32768[12:11] <= `XFIPCS_RX_HSS_T6_BITS1716_VALUE_DEFAULT;
   reg_32768[10:0]  <= `XFIPCS_TX_HSS_T1_VALUE_DEFAULT;
   reg_32771 <= `XFIPCS_RX_HSS_T1_BITS15TO0_VALUE_DEFAULT;
   reg_32773 <= `XFIPCS_RX_HSS_T6_BITS15TO0_VALUE_DEFAULT;
   `else
   reg_32768 <= `XFIPCS_TX_HSS_T1_VALUE_DEFAULT;
   reg_32771 <= `XFIPCS_RX_HSS_T1_VALUE_DEFAULT;
   reg_32773 <= `XFIPCS_RX_HSS_T6_VALUE_DEFAULT;
   `endif
   reg_32769 <= `XFIPCS_TX_HSS_T2_VALUE_DEFAULT;
   reg_32770 <= `XFIPCS_TX_HSS_T3_VALUE_DEFAULT;
   reg_32772 <= `XFIPCS_RX_HSS_T3_VALUE_DEFAULT;
   `ifdef XFIPCS_16G32GFC
   reg_32774 <= speed_sel_xgmii ? 16'h969b : 16'hcb4d;   // 32G: 17'h1969b = 104091 = 95% * 125 us * 876.5625 MHz
   reg_32775 <= speed_sel_xgmii ? 2'h1 : 2'h0;           // 16G: 17'hcb4d = 52045 = 95% * 125 us * 438.28125 MHz
   reg_32776 <= 1'b0;
   reg_32777 <= {1'b0, (speed_sel_xgmii ? `XFIPCS_TX_TW_TIMER_MAX_32G : `XFIPCS_TX_TW_TIMER_MAX_16G)};
   reg_32778 <= scr_bypass_enable ? (speed_sel_xgmii ? `XFIPCS_RX_TW_TIMER_MIN_BYPASS_32G : (XGMIICLK_425M_r1 ? `XFIPCS_RX_TW_TIMER_MIN_BYPASS_16G_425M : `XFIPCS_RX_TW_TIMER_MIN_BYPASS_16G_212M)) : (XGMIICLK_425M_r1 ? `XFIPCS_RX_TW_TIMER_MIN_16G_425M : `XFIPCS_RX_TW_TIMER_MIN_16G_212M);
   `endif

  end else begin
   md_data_out <= md_data_out_nxt;
   data_reg_read_freeze <= data_reg_read_freeze_nxt;
   clear_tpec_count <= clear_tpec_count_nxt;
   clear_tpec_r1 <= clear_tpec;
   tpec_15_8 <= tpec_15_8_nxt;
   reg_0 <= reg_0_nxt;
   reg_1 <= reg_1_nxt;
   reg_7 <= reg_7_nxt;
   reg_8 <= reg_8_nxt;
   reg_32 <= reg_32_nxt;
   reg_33 <= reg_33_nxt;
   reg_34 <= reg_34_nxt;
   reg_35 <= reg_35_nxt;
   reg_36 <= reg_36_nxt;
   reg_37 <= reg_37_nxt;
   reg_38 <= reg_38_nxt;
   reg_39 <= reg_39_nxt;
   reg_40 <= reg_40_nxt;
   reg_41 <= reg_41_nxt;
   reg_42 <= reg_42_nxt;
   reg_32768 <= reg_32768_nxt;
   reg_32769 <= reg_32769_nxt;
   reg_32770 <= reg_32770_nxt;
   reg_32771 <= reg_32771_nxt;
   reg_32772 <= reg_32772_nxt;
   reg_32773 <= reg_32773_nxt;
   `ifdef XFIPCS_16G32GFC
   reg_32774 <= reg_32774_nxt;
   reg_32775 <= reg_32775_nxt;
   reg_32776 <= reg_32776_nxt;
   reg_32777 <= reg_32777_nxt;
   reg_32778 <= reg_32778_nxt;
   `endif
  end

  // wake_error_counter
  if (reset_to_xgmii || clr_wake_error_counter) begin
   reg_22 <= 16'h0000;
  end else begin
   reg_22 <= reg_22_nxt;
  end

  if (reset_to_md)
   loopback_count <= 3'b000;
  else
   loopback_count <= loopback_count_nxt;

  if (gray_code_reset != 2'h0) begin
   ber_count_xgmii_bin <= 6'h00;
   errored_block_counter_xgmii_bin <= 8'h00;
  end else begin
   ber_count_xgmii_bin <= ber_count_xgmii_bin_nxt;
   errored_block_counter_xgmii_bin <= errored_block_counter_xgmii_bin_nxt;
  end

  ber_count_reset_xgmii <= ber_count_reset_xgmii_nxt;
  r_test_mode_xgmii <= r_test_mode_nxt;
  tpec_xgmii_bin <= tpec_xgmii_bin_in;
  clear_tpec_tog <= clear_tpec_tog_nxt;
  reset_count <= reset_count_nxt;
  loopback_prev <= loopback;
  data_reg_read_now_prev <= data_reg_read_now_xgmii;
 end

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async016(.clk (xgmii_clk), .data_in (addr_reg[ 0]), .data_out (addr_reg_xgmii[ 0]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async017(.clk (xgmii_clk), .data_in (addr_reg[ 1]), .data_out (addr_reg_xgmii[ 1]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async018(.clk (xgmii_clk), .data_in (addr_reg[ 2]), .data_out (addr_reg_xgmii[ 2]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async019(.clk (xgmii_clk), .data_in (addr_reg[ 3]), .data_out (addr_reg_xgmii[ 3]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async020(.clk (xgmii_clk), .data_in (addr_reg[ 4]), .data_out (addr_reg_xgmii[ 4]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async021(.clk (xgmii_clk), .data_in (addr_reg[ 5]), .data_out (addr_reg_xgmii[ 5]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async022(.clk (xgmii_clk), .data_in (addr_reg[ 6]), .data_out (addr_reg_xgmii[ 6]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async023(.clk (xgmii_clk), .data_in (addr_reg[ 7]), .data_out (addr_reg_xgmii[ 7]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async024(.clk (xgmii_clk), .data_in (addr_reg[ 8]), .data_out (addr_reg_xgmii[ 8]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async025(.clk (xgmii_clk), .data_in (addr_reg[ 9]), .data_out (addr_reg_xgmii[ 9]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async026(.clk (xgmii_clk), .data_in (addr_reg[10]), .data_out (addr_reg_xgmii[10]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async027(.clk (xgmii_clk), .data_in (addr_reg[11]), .data_out (addr_reg_xgmii[11]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async028(.clk (xgmii_clk), .data_in (addr_reg[12]), .data_out (addr_reg_xgmii[12]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async029(.clk (xgmii_clk), .data_in (addr_reg[13]), .data_out (addr_reg_xgmii[13]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async030(.clk (xgmii_clk), .data_in (addr_reg[14]), .data_out (addr_reg_xgmii[14]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async031(.clk (xgmii_clk), .data_in (addr_reg[15]), .data_out (addr_reg_xgmii[15]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async032(.clk (xgmii_clk), .data_in (data_reg[ 0]), .data_out (data_reg_xgmii[ 0]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async033(.clk (xgmii_clk), .data_in (data_reg[ 1]), .data_out (data_reg_xgmii[ 1]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async034(.clk (xgmii_clk), .data_in (data_reg[ 2]), .data_out (data_reg_xgmii[ 2]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async035(.clk (xgmii_clk), .data_in (data_reg[ 3]), .data_out (data_reg_xgmii[ 3]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async036(.clk (xgmii_clk), .data_in (data_reg[ 4]), .data_out (data_reg_xgmii[ 4]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async037(.clk (xgmii_clk), .data_in (data_reg[ 5]), .data_out (data_reg_xgmii[ 5]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async038(.clk (xgmii_clk), .data_in (data_reg[ 6]), .data_out (data_reg_xgmii[ 6]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async039(.clk (xgmii_clk), .data_in (data_reg[ 7]), .data_out (data_reg_xgmii[ 7]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async040(.clk (xgmii_clk), .data_in (data_reg[ 8]), .data_out (data_reg_xgmii[ 8]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async041(.clk (xgmii_clk), .data_in (data_reg[ 9]), .data_out (data_reg_xgmii[ 9]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async042(.clk (xgmii_clk), .data_in (data_reg[10]), .data_out (data_reg_xgmii[10]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async043(.clk (xgmii_clk), .data_in (data_reg[11]), .data_out (data_reg_xgmii[11]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async044(.clk (xgmii_clk), .data_in (data_reg[12]), .data_out (data_reg_xgmii[12]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async045(.clk (xgmii_clk), .data_in (data_reg[13]), .data_out (data_reg_xgmii[13]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async046(.clk (xgmii_clk), .data_in (data_reg[14]), .data_out (data_reg_xgmii[14]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async047(.clk (xgmii_clk), .data_in (data_reg[15]), .data_out (data_reg_xgmii[15]) );

 always @(posedge pma_rx_clk) begin
  if (reset_to_pma_rx) begin
   ber_count <= 6'h00;
  end else begin
   ber_count <= ber_count_nxt;
  end

   ber_count_pma_gray <= ber_count_pma_gray_nxt;
   hi_ber_2 <= hi_ber;
   hi_ber_3 <= hi_ber_2;
   hi_ber_4 <= hi_ber_3;
   hi_ber_for_xgmii <= hi_ber_for_xgmii_nxt;
 end

 `ifdef XFIPCS_16G32GFC
 always @(posedge pma_rx_clk_div2) begin
  if (reset_to_pma_rx_div2) begin
   errored_block_counter <= 8'h00;
  end else begin
   errored_block_counter <= errored_block_counter_nxt;
  end
   
   errored_block_counter_pma_gray <= errored_block_counter_pma_gray_nxt;
 end
 `else
 always @(posedge pma_rx_clk) begin
  if (reset_to_pma_rx) begin
   errored_block_counter <= 8'h00;
  end else begin
   errored_block_counter <= errored_block_counter_nxt;
  end

   errored_block_counter_pma_gray <= errored_block_counter_pma_gray_nxt;
 end
 `endif

 assign ber_count_reset_md_nxt =
               (md_state_nxt == READDATA && addr_reg == 16'h0021) ? 1'b1 : 1'b0;

 assign ber_count_reset_xgmii_nxt =
                   ber_count_reset_md_to_xgmii == 1'b1 ||
                   (md_addr == 16'h0021 &&
                    md_r_w == 1'b1 && md_en_valid == 1'b1)        ? 1'b1 : 1'b0;

 //========================================================
 // ber reset handshake across domains
 //========================================================
 // xgmii domain
 assign ber_count_reset_pending_nxt = ber_count_reset_xgmii_nxt | (ber_count_reset_pending & ~ber_count_reset_seen);

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async220(
                         .clk      (xgmii_clk                     ),
                         .data_in  (ber_count_reset_pending_pma_rx),
                         .data_out (ber_count_reset_seen          )
                 );

 always @(posedge xgmii_clk) begin
  if (reset_to_xgmii)
   ber_count_reset_pending <= 1'b0;
  else
   ber_count_reset_pending <= ber_count_reset_pending_nxt;
 end

 // pma_rx domain
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async221(
                         .clk      (pma_rx_clk                     ),
                         .data_in  (ber_count_reset_pending        ),
                         .data_out (ber_count_reset_pending_pma_rx )
                 );

 `ifdef XFIPCS_16G32GFC
 wire ber_count_reset_pending_pma_rx_div2;
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async222(
                         .clk      (pma_rx_clk_div2                ),
                         .data_in  (ber_count_reset_pending        ),
                         .data_out (ber_count_reset_pending_pma_rx_div2 )
                 );
 `endif

 //========================================================


 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async015(.clk      (xgmii_clk), .data_in  (ber_count_reset_md), .data_out (ber_count_reset_md_to_xgmii) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async003(.clk      (pma_rx_clk), .data_in  (ber_count_reset_xgmii), .data_out (ber_count_reset_xgmii_to_pma_rx) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async084(.clk      (pma_rx_clk), .data_in  (r_test_mode_xgmii), .data_out (r_test_mode) );

 assign ber_count_nxt = (ber_count_reset_pending_pma_rx)               ? 6'h00 :
//                      (ber_count_reset_xgmii_to_pma_rx == 1'b1)      ? 6'h00 :
                        (ber_count == 6'h3f)                           ? 6'h3f :
                        (inc_ber_count == 1'b1)                ? ber_count + 1 :
                                                                     ber_count ;

 // Conversion from binary to grey code
 assign ber_count_pma_gray_nxt = ber_count ^ {1'b0, ber_count[5:1]};

 // Conversion from grey code to binary
 assign ber_count_xgmii_bin_nxt[5] = ber_count_xgmii_gray[5] ;
 assign ber_count_xgmii_bin_nxt[4] = ber_count_xgmii_gray[4] ^ ber_count_xgmii_bin_nxt[5] ;
 assign ber_count_xgmii_bin_nxt[3] = ber_count_xgmii_gray[3] ^ ber_count_xgmii_bin_nxt[4] ;
 assign ber_count_xgmii_bin_nxt[2] = ber_count_xgmii_gray[2] ^ ber_count_xgmii_bin_nxt[3] ;
 assign ber_count_xgmii_bin_nxt[1] = ber_count_xgmii_gray[1] ^ ber_count_xgmii_bin_nxt[2] ;
 assign ber_count_xgmii_bin_nxt[0] = ber_count_xgmii_gray[0] ^ ber_count_xgmii_bin_nxt[1] ;

 assign md_read_reg_1_nxt = (md_state_nxt == READDATA) & (addr_reg == 16'h0001);
 assign md_read_reg_8_nxt = (md_state_nxt == READDATA) & (addr_reg == 16'h0008);
 assign md_read_reg_22_nxt = (md_state_nxt == READDATA) & (addr_reg == 16'h0016);
 assign md_read_reg_33_nxt = (md_state_nxt == READDATA) & (addr_reg == 16'h0021);
 assign md_read_reg_43_nxt = (md_state_nxt == READDATA) & (addr_reg == 16'h002b);

 `ifdef XFIPCS_16G32GFC
 assign errored_block_counter_nxt = (ber_count_reset_pending_pma_rx_div2 == 1'b1) ? 8'h00 :
//                                  (ber_count_reset_xgmii_to_pma_rx == 1'b1) ? 8'h00 :
                                    (errored_block_counter == 8'hff)         ? 8'hff :
                                    (inc_ebc == 1'b1)                        ? errored_block_counter + 1 :
                                                                               errored_block_counter ;
 `else
 assign errored_block_counter_nxt = (ber_count_reset_pending_pma_rx == 1'b1) ? 8'h00 :
//                                  (ber_count_reset_xgmii_to_pma_rx == 1'b1) ? 8'h00 :
                                    (errored_block_counter == 8'hff)         ? 8'hff :
                                    (inc_ebc == 1'b1)                        ? errored_block_counter + 1 :
                                                                               errored_block_counter ;
 `endif

 // Conversion from binary to grey code
 assign errored_block_counter_pma_gray_nxt = errored_block_counter ^ {1'b0, errored_block_counter[7:1]} ;

 // Conversion from grey code to binary
 assign errored_block_counter_xgmii_bin_nxt[7] = errored_block_counter_xgmii_gray[7];
 assign errored_block_counter_xgmii_bin_nxt[6] = errored_block_counter_xgmii_gray[6] ^ errored_block_counter_xgmii_bin_nxt[7];
 assign errored_block_counter_xgmii_bin_nxt[5] = errored_block_counter_xgmii_gray[5] ^ errored_block_counter_xgmii_bin_nxt[6];
 assign errored_block_counter_xgmii_bin_nxt[4] = errored_block_counter_xgmii_gray[4] ^ errored_block_counter_xgmii_bin_nxt[5];
 assign errored_block_counter_xgmii_bin_nxt[3] = errored_block_counter_xgmii_gray[3] ^ errored_block_counter_xgmii_bin_nxt[4];
 assign errored_block_counter_xgmii_bin_nxt[2] = errored_block_counter_xgmii_gray[2] ^ errored_block_counter_xgmii_bin_nxt[3];
 assign errored_block_counter_xgmii_bin_nxt[1] = errored_block_counter_xgmii_gray[1] ^ errored_block_counter_xgmii_bin_nxt[2];
 assign errored_block_counter_xgmii_bin_nxt[0] = errored_block_counter_xgmii_gray[0] ^ errored_block_counter_xgmii_bin_nxt[1];

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1) async085(.clk      (xgmii_clk), .data_in  (tpec_pma_gray[0]), .data_out (tpec_xgmii_gray[0]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1) async086(.clk      (xgmii_clk), .data_in  (tpec_pma_gray[1]), .data_out (tpec_xgmii_gray[1]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1) async087(.clk      (xgmii_clk), .data_in  (tpec_pma_gray[2]), .data_out (tpec_xgmii_gray[2]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1) async088(.clk      (xgmii_clk), .data_in  (tpec_pma_gray[3]), .data_out (tpec_xgmii_gray[3]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1) async089(.clk      (xgmii_clk), .data_in  (tpec_pma_gray[4]), .data_out (tpec_xgmii_gray[4]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1) async090(.clk      (xgmii_clk), .data_in  (tpec_pma_gray[5]), .data_out (tpec_xgmii_gray[5]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1) async091(.clk      (xgmii_clk), .data_in  (tpec_pma_gray[6]), .data_out (tpec_xgmii_gray[6]) );
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1) async092(.clk      (xgmii_clk), .data_in  (tpec_pma_gray[7]), .data_out (tpec_xgmii_gray[7]) );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1) async094(.clk      (xgmii_clk), .data_in  (tpec_15_8_inc_tog), .data_out (tpec_15_8_inc_tog_xgmii) );

 assign tpec_xgmii_bin_nxt[7] = tpec_xgmii_gray[7];
 assign tpec_xgmii_bin_nxt[6] = tpec_xgmii_gray[6] ^ tpec_xgmii_bin_nxt[7];
 assign tpec_xgmii_bin_nxt[5] = tpec_xgmii_gray[5] ^ tpec_xgmii_bin_nxt[6];
 assign tpec_xgmii_bin_nxt[4] = tpec_xgmii_gray[4] ^ tpec_xgmii_bin_nxt[5];
 assign tpec_xgmii_bin_nxt[3] = tpec_xgmii_gray[3] ^ tpec_xgmii_bin_nxt[4];
 assign tpec_xgmii_bin_nxt[2] = tpec_xgmii_gray[2] ^ tpec_xgmii_bin_nxt[3];
 assign tpec_xgmii_bin_nxt[1] = tpec_xgmii_gray[1] ^ tpec_xgmii_bin_nxt[2];
 assign tpec_xgmii_bin_nxt[0] = tpec_xgmii_gray[0] ^ tpec_xgmii_bin_nxt[1];

 assign clear_tpec = reset_to_xgmii | md_read_reg_43_xgmii |
                     ((md_r_w && md_addr == 16'h002b) & md_en_valid);

 assign clear_tpec_count_nxt = clear_tpec_count != 4'h0 ? clear_tpec_count + 1 :
                               clear_tpec               ? 4'h1 : clear_tpec_count ;

 assign clear_tpec_tog_nxt = clear_tpec_count != 4'h0 ;
 assign tpec_xgmii_bin_in = clear_tpec || clear_tpec_r1 || clear_tpec_tog ? 8'h00 :
                    tpec_15_8 == 8'hff && tpec_xgmii_bin[7:1] == 7'h7f ? 8'hff :
                    tpec_15_8 == 8'hff && tpec_15_8_inc                ? 8'hff :
                                                            tpec_xgmii_bin_nxt ;

 //assign tpec_15_8_inc = (tpec_xgmii_bin[7:6] == 2'b11 &&
 //                        tpec_xgmii_bin_nxt[7:6] == 2'b00);
 reg tpec_15_8_inc_tog_xgmii_r1;
 always @(posedge xgmii_clk) begin
  tpec_15_8_inc_tog_xgmii_r1 <= tpec_15_8_inc_tog_xgmii;
 end
 assign tpec_15_8_inc = tpec_15_8_inc_tog_xgmii && ~tpec_15_8_inc_tog_xgmii_r1 && ~clear_tpec_tog && ~clear_tpec_r1;
 assign tpec_15_8_dec = (tpec_xgmii_bin[7:6] == 2'b00 &&
                         tpec_xgmii_bin_nxt[7:6] == 2'b11 &&
                         ~clear_tpec_tog &&
                         ~clear_tpec_r1);

 assign tpec_15_8_nxt = clear_tpec                             ? 8'h00 :
                        tpec_15_8 == 8'hff                     ? 8'hff :
                        tpec_15_8_inc                          ? tpec_15_8 + 1 :
                        tpec_15_8_dec                          ? tpec_15_8 - 1 :
                                                                     tpec_15_8 ;


 assign test_pattern_error_counter = 16'h0000;

 assign pcs_r_status_ll_nxt =  reset_to_xgmii                           ? 1'b0 :
                             md_read_reg_1_xgmii ||
                            ( md_r_w &&
                      md_addr == 16'h0001 && md_en_valid) ? pcs_r_status_xgmii :
                                                pcs_r_status_xgmii && reg_1[0] ;
 assign tx_local_fault_lh_nxt =  reset_to_xgmii                         ? 1'b0 :
                              md_read_reg_8_xgmii ||
                              ( md_r_w &&
                    md_addr == 16'h0008 && md_en_valid) ? tx_local_fault_xgmii :
                                              tx_local_fault_xgmii || reg_8[1] ;
 assign rx_local_fault_lh_nxt =  reset_to_xgmii                         ? 1'b0 :
                              md_read_reg_8_xgmii ||
                              ( md_r_w &&
                    md_addr == 16'h0008 && md_en_valid) ? rx_local_fault_xgmii :
                                              rx_local_fault_xgmii || reg_8[0] ;
 assign block_lock_ll_nxt =  reset_to_xgmii                             ? 1'b0 :
                             md_read_reg_33_xgmii ||
                            ( md_r_w &&
                              md_addr == 16'h0021 && md_en_valid) ? block_lock :
                                                block_lock && reg_33[15] ;
 assign hi_ber_lh_nxt = reset_to_xgmii                                  ? 1'b0 :
                        md_read_reg_33_xgmii ||
                        (md_addr == 16'h0021 &&
                         md_r_w && md_en_valid)                 ? hi_ber_xgmii :
                                                    hi_ber_xgmii || reg_33[14] ;

 assign fault = tx_local_fault_xgmii || rx_local_fault_xgmii;

 assign reset_count_nxt = reset_to_md                                   ? 4'h0 :
                          reg_0[1] || reset_count != 4'hf    ? reset_count + 1 :
                                                                   reset_count ;

 assign reg_0_nxt[1] = reset_count[3:2] != 2'h3 && reset_count != 4'h0   ? 1'b1 :
                      (write_reg_0_xgmii == 1'b1)         ? data_reg_xgmii[15] :
                      (md_addr == 16'h0000 && md_r_w == 1'b0 && md_en_valid == 1'b1)
                                                              ? md_data_in[15] :
                      reset_count[3:1] == 3'h6                          ? 1'b0 :
                                                                      reg_0[1] ;
 assign reg_0_nxt[0] = (write_reg_0_xgmii == 1'b1)           ? data_reg_xgmii[14] :
                       (md_addr == 16'h0000 && md_r_w == 1'b0 && md_en_valid == 1'b1)
                                                              ? md_data_in[14] :
                                                                      reg_0[0] ;

 // EEE (AZ) additions
 assign tx_lpi_received_nxt = reset_to_xgmii                                 ? 1'b0 :
                              md_read_reg_1_xgmii ||
                              (md_r_w && md_addr == 16'h0001 && md_en_valid) ? tx_lpi_indication :
                                                                               tx_lpi_indication || tx_lpi_received;

 assign rx_lpi_received_nxt = reset_to_xgmii                                 ? 1'b0 :
                              md_read_reg_1_xgmii ||
                              (md_r_w && md_addr == 16'h0001 && md_en_valid) ? rx_lpi_indication :
                                                                               rx_lpi_indication || rx_lpi_received;

 assign tx_lpi_indication_nxt  = ~tx_active;
 assign rx_lpi_indication_nxt  = ~rx_active;

 assign tx_lpi_received   = reg_1[5];
 assign rx_lpi_received   = reg_1[4];
 assign tx_lpi_indication = reg_1[3];
 assign rx_lpi_indication = reg_1[2];

 assign reg_1_nxt = {tx_lpi_received_nxt, rx_lpi_received_nxt, tx_lpi_indication_nxt, rx_lpi_indication_nxt, fault, pcs_r_status_ll_nxt};

 `ifdef XFIPCS_TOPLEVELNAME_WIS_ENABLED
  assign reg_7_nxt = 2'b10;
 `else
  assign reg_7_nxt = 2'b00;
 `endif
 assign reg_8_nxt =  {2'h2, tx_local_fault_lh_nxt, rx_local_fault_lh_nxt};
 assign reg_22_nxt = (wake_error_counter_inc && (reg_22 != 16'hFFFF)) ? reg_22 + 16'd1 : reg_22;
 assign reg_32_nxt = {pcs_r_status_xgmii, 1'b1, hi_ber_xgmii, block_lock};
 assign reg_33_nxt = {block_lock_ll_nxt, hi_ber_lh_nxt,
                      ber_count_xgmii_bin, errored_block_counter_xgmii_bin};
 assign reg_34_nxt = (write_reg_34_xgmii == 1'b1) ?             data_reg_xgmii :
                    (md_addr == 16'h0022 &&
                     md_r_w == 1'b0 && md_en_valid == 1'b1) ?       md_data_in :
                                                                        reg_34 ;
 assign reg_35_nxt = (write_reg_35_xgmii == 1'b1) ?             data_reg_xgmii :
                    (md_addr == 16'h0023 &&
                     md_r_w == 1'b0 && md_en_valid == 1'b1) ?       md_data_in :
                                                                        reg_35 ;
 assign reg_36_nxt = (write_reg_36_xgmii == 1'b1) ?             data_reg_xgmii :
                    (md_addr == 16'h0024 &&
                     md_r_w == 1'b0 && md_en_valid == 1'b1) ?       md_data_in :
                                                                        reg_36 ;
 assign reg_37_nxt = (write_reg_37_xgmii == 1'b1) ?        data_reg_xgmii[9:0] :
                    (md_addr == 16'h0025 &&
                     md_r_w == 1'b0 && md_en_valid == 1'b1) ?  md_data_in[9:0] :
                                                                        reg_37 ;
 assign reg_38_nxt = (write_reg_38_xgmii == 1'b1) ?             data_reg_xgmii :
                    (md_addr == 16'h0026 &&
                     md_r_w == 1'b0 && md_en_valid == 1'b1) ?       md_data_in :
                                                                        reg_38 ;
 assign reg_39_nxt = (write_reg_39_xgmii == 1'b1) ?             data_reg_xgmii :
                    (md_addr == 16'h0027 &&
                     md_r_w == 1'b0 && md_en_valid == 1'b1) ?       md_data_in :
                                                                        reg_39 ;
 assign reg_40_nxt = (write_reg_40_xgmii == 1'b1) ?             data_reg_xgmii :
                    (md_addr == 16'h0028 &&
                     md_r_w == 1'b0 && md_en_valid == 1'b1) ?       md_data_in :
                                                                        reg_40 ;
 assign reg_41_nxt = (write_reg_41_xgmii == 1'b1) ?        data_reg_xgmii[9:0] :
                    (md_addr == 16'h0029 &&
                     md_r_w == 1'b0 && md_en_valid == 1'b1) ?  md_data_in[9:0] :
                                                                        reg_41 ;
 assign reg_42_nxt = (write_reg_42_xgmii == 1'b1) ?        data_reg_xgmii[5:0] :
                    (md_addr == 16'h002a &&
                     md_r_w == 1'b0 && md_en_valid == 1'b1) ?  md_data_in[5:0] :
                                                                        reg_42 ;

 assign reg_43 = {tpec_15_8, tpec_xgmii_bin};

 // HSS t# value regs
 `ifdef XFIPCS_16G32GFC
 assign reg_32768_nxt = (!tx_hss_reg_we)                                      ? reg_32768 :
                        (write_reg_32768_xgmii)                           ? data_reg_xgmii[14:0] :
                        ((md_addr == 16'h8000) && !md_r_w && md_en_valid) ? md_data_in[14:0] :
                                                                            reg_32768;
 `else
 assign reg_32768_nxt = (!tx_hss_reg_we)                                      ? reg_32768 :
                        (write_reg_32768_xgmii)                           ? data_reg_xgmii[10:0] :
                        ((md_addr == 16'h8000) && !md_r_w && md_en_valid) ? md_data_in[10:0] :
                                                                            reg_32768;
 `endif                                                                            

 assign reg_32769_nxt = (!tx_hss_reg_we)                                      ? reg_32769 :
                        (write_reg_32769_xgmii)                           ? data_reg_xgmii[15:0] :
                        ((md_addr == 16'h8001) && !md_r_w && md_en_valid) ? md_data_in[15:0] :
                                                                            reg_32769;

 assign reg_32770_nxt = (!tx_hss_reg_we)                                      ? reg_32770 :
                        (write_reg_32770_xgmii)                           ? data_reg_xgmii[15:0] :
                        ((md_addr == 16'h8002) && !md_r_w && md_en_valid) ? md_data_in[15:0] :
                                                                            reg_32770;

 assign reg_32771_nxt = (!rx_hss_reg_we)                                      ? reg_32771 :
                        (write_reg_32771_xgmii)                           ? data_reg_xgmii[15:0] :
                        ((md_addr == 16'h8003) && !md_r_w && md_en_valid) ? md_data_in[15:0] :
                                                                            reg_32771;

 assign reg_32772_nxt = (!rx_hss_reg_we)                                      ? reg_32772 :
                        (write_reg_32772_xgmii)                           ? data_reg_xgmii[15:0] :
                        ((md_addr == 16'h8004) && !md_r_w && md_en_valid) ? md_data_in[15:0] :
                                                                            reg_32772;

 assign reg_32773_nxt = (!rx_hss_reg_we)                                      ? reg_32773 :
                        (write_reg_32773_xgmii)                           ? data_reg_xgmii[15:0] :
                        ((md_addr == 16'h8005) && !md_r_w && md_en_valid) ? md_data_in[15:0] :
                                                                            reg_32773;

 `ifdef XFIPCS_16G32GFC
 assign reg_32774_nxt = (write_reg_32774_xgmii)                           ? data_reg_xgmii[15:0] :
                        ((md_addr == 16'h8006) && !md_r_w && md_en_valid) ? md_data_in[15:0] :
                                                                            reg_32774;

 assign reg_32775_nxt = (write_reg_32775_xgmii)                           ? data_reg_xgmii[1:0] :
                        ((md_addr == 16'h8007) && !md_r_w && md_en_valid) ? md_data_in[1:0] :
                                                                            reg_32775;

 assign reg_32776_nxt = (write_reg_32776_xgmii)                           ? data_reg_xgmii[0] :
                        ((md_addr == 16'h8008) && !md_r_w && md_en_valid) ? md_data_in[0] :
                                                                            reg_32776;

 assign reg_32777_nxt = (write_reg_32777_xgmii)                           ? data_reg_xgmii[12:0] :
                        ((md_addr == 16'h8009) && !md_r_w && md_en_valid) ? md_data_in[12:0] :
                                                                            reg_32777;

 assign reg_32778_nxt = (write_reg_32778_xgmii)                           ? data_reg_xgmii[12:0] :
                        ((md_addr == 16'h800a) && !md_r_w && md_en_valid) ? md_data_in[12:0] :
                                                                            reg_32778;
 `endif

 assign r_test_mode_nxt = reg_42_nxt[5] || reg_42_nxt[2];

 assign reset_from_md     = reg_0[1];
 assign loopback          = reg_0[0];

 assign md_1_2 = reg_1[0];
 assign md_1_7 = reg_1[1];
 assign md_1_8 = reg_1[2];
 assign md_1_9 = reg_1[3];
 assign md_1_10 = reg_1[4];
 assign md_1_11 = reg_1[5];
 assign md_32_0 = reg_32[0];
 assign md_32_1 = reg_32[1];
 assign md_32_2 = reg_32[2];
 assign md_32_12 = reg_32[3];
 assign md_33_7_0 = reg_33[7:0];
 assign md_33_13_8 = reg_33[13:8];
 assign md_33_14 = reg_33[14];
 assign md_33_15 = reg_33[15];
 assign md_8_10 = reg_8[0];
 assign md_8_11 = reg_8[1];
 assign md_8_15_14 = reg_8[3:2];
 assign md_43_15_0 = reg_43;
 assign md_22_15_0 = reg_22;

 assign test_pat_seed_a = {reg_37, reg_36, reg_35, reg_34};
 assign test_pat_seed_b = {reg_41, reg_40, reg_39, reg_38};
 assign rx_prbs_pat_en = reg_42[5];
 assign tx_prbs_pat_en = reg_42[4];
 assign tx_test_pat_en = reg_42[3];
 assign rx_test_pat_en = reg_42[2];
 assign test_pat_sel = reg_42[1];
 assign data_pat_sel = reg_42[0];

 assign loopback_count_nxt = loopback != loopback_prev    ? loopback_count + 1 :
                             loopback_count != 3'b000     ? loopback_count + 1 :
                                                                        3'b000 ;
 assign loopback_reset = loopback_count != 3'b000 ;

 `ifdef XFIPCS_16G32GFC
 assign tx_hss_t1_value = reg_32768[10:0];
 assign rx_hss_t1_value = {reg_32768[14:13], reg_32771[15:0]};
 assign rx_hss_t6_value = {reg_32768[12:11], reg_32773[15:0]};
 assign ber_timer_value = {reg_32775[1:0], reg_32774[15:0]};
 assign lpi_fw = reg_32776;
 assign tx_tw_timer_value = reg_32777;
 assign rx_tw_timer_value = reg_32778;
 `else
 assign tx_hss_t1_value = reg_32768;
 assign rx_hss_t1_value = reg_32771;
 assign rx_hss_t6_value = reg_32773;
 `endif
 assign tx_hss_t2_value = reg_32769;
 assign tx_hss_t3_value = reg_32770;
 assign rx_hss_t3_value = reg_32772;

endmodule
