//SCCS File Version= %I% 
//Release Date= 14/04/20  19:57:10 GMT startFileName /vobs/vob012/xfipcs/verilog/rtl/XFIPCS_TX_FLOW.v endFileName  

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

//$Id: XFIPCS_TX_FLOW.v,v 1.8 2014/02/21 07:12:01 huqian Exp $
//$Log: XFIPCS_TX_FLOW.v,v $
//Revision 1.8  2014/02/21 07:12:01  huqian
//Copy XFIPCS cvs tag v1_135
//
//Revision 1.29  2014/02/18 07:36:57  huqian
//Condor 4 ASIC FC-EE Support Requirements.pdf item3
//
//Revision 1.28  2014/02/17 08:48:28  huqian
//Condor 4 ASIC FC-EE Support Requirements.pdf item2
//
//Revision 1.27  2014/02/14 04:31:07  huqian
//Add TX_LPI_ACTIVE output
//
//Revision 1.26  2014/02/11 06:53:37  huqian
//Six T blocks are treated as error(invalid) blocks for 16G32G FC
//
//Revision 1.25  2014/02/10 09:12:40  huqian
//reserved0/reserved1/reserved2/reserved3/reserved4/reserved5 are treated as error(invalid) codes for 16G32G FC
//
//Revision 1.24  2014/01/07 05:46:32  huqian
//Update the values of 16G32G LPI timing parameters according to FC-FS-4
//
//Revision 1.23  2013/12/12 03:29:20  huqian
//Modify XFIPCS_32GFC macro define to XFIPCS_16G32GFC
//
//Revision 1.22  2013/10/28 03:35:02  huqian
//Fix timing violation
//
//Revision 1.21  2013/09/27 05:16:28  huqian
//Fix HW268863: TX_RDATA_P1 signal appears 'X' state
//
//Revision 1.20  2011/03/23 13:00:50  adamc
//TX now drives LPI's in LP mode until tx_mode != QUIET
//
//Revision 1.19  2011/03/11 19:38:28  adamc
//cvs_snap v1_50
//
//Revision 1.18  2011/03/07 21:26:29  adamc
//cvs_snap v1_44
//
//Revision 1.17  2011/03/07 14:11:29  adamc
//cvs_snap v1_42
//
//Revision 1.16  2011/03/04 21:28:36  adamc
//cvs_snap v1_38
//
//Revision 1.15  2011/03/03 19:33:22  adamc
//cvs_snap v1_36
//
//Revision 1.14  2011/01/28 19:10:48  adamc
//cvs_snap v1_16
//
//Revision 1.13  2011/01/27 20:37:13  adamc
//Updated r_type and t_type for RAS changes
//
//Revision 1.12  2011/01/26 14:26:44  adamc
//cvs_snap v1_13
//
//Revision 1.10  2011/01/19 17:25:04  adamc
//Added *xREFRESH logic
//
//Revision 1.9  2011/01/13 17:50:44  adamc
//added tx_mode_li input to lpi_fsm
//
//Revision 1.8  2011/01/05 20:32:50  adamc
//Typo in port list
//
//Revision 1.7  2010/12/16 14:27:10  adamc
//lpi math typo
//
//Revision 1.6  2010/12/15 19:54:06  adamc
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

module `XFIPCS_TOPLEVELNAME_TX_FLOW (
                        pma_tx_clk,
                        reset_to_pma_tx,
`ifdef XFIPCS_16G32GFC
                        reset_to_pma_tx_pmaclk,
                        SPEED_SEL,
                        lpi_fw,
                        tx_tw_timer_value,
`endif

                        enable_alternate_refresh,
                        ALTERNATE_ENCODE,
                        tx_fifo_pop,
                        txc_xfi,
                        txd_xfi,
                        scr_bypass_enable,
                        tx_hss_t1_value,
                        tx_hss_t2_value,
                        tx_hss_t3_value,

                        tx_fifo_pop_2,
                        encoder_data_in,
                        encoder_control_in,
                        tx_local_fault,
                        tx_mode,
`ifdef XFIPCS_16G32GFC
                        tx_lpi_active,
`endif
                        scrambler_bypass,
                        t_type_li,
                        tx_active,
                        TXxQUIET,
                        TXxREFRESH
                );

// ----------------------------------------------------------------------------
// Inputs/Outputs
// ----------------------------------------------------------------------------
input                   pma_tx_clk;
input                   reset_to_pma_tx;
`ifdef XFIPCS_16G32GFC
input                   reset_to_pma_tx_pmaclk;
input                   SPEED_SEL;
input                   lpi_fw;
input   [12:0]          tx_tw_timer_value;
`endif

input                   enable_alternate_refresh;
input                   ALTERNATE_ENCODE;
input                   tx_fifo_pop;
input   [7:0]           txc_xfi;
input   [63:0]          txd_xfi;
input                   scr_bypass_enable;
input   [10:0]          tx_hss_t1_value;
input   [15:0]          tx_hss_t2_value;
input   [15:0]          tx_hss_t3_value;

output  [7:0]           encoder_control_in;
output  [63:0]          encoder_data_in;
output                  tx_local_fault;
output                  tx_fifo_pop_2;
output  [1:0]           tx_mode;
`ifdef XFIPCS_16G32GFC
output                  tx_lpi_active;
`endif
output                  scrambler_bypass;
output                  t_type_li;
output                  tx_active;
output                  TXxQUIET;
output                  TXxREFRESH;

// ----------------------------------------------------------------------------
// Internal signals/registers
// ----------------------------------------------------------------------------
wire                    tx_local_fault;
reg                     tx_fifo_pop_2;
wire    [3:0]           t_type;
reg     [3:0]           t_type_prev;
wire    [1:0]           tx_coded;

reg     [7:0]           cntl_xfi;
reg     [63:0]          data_xfi;
wire    [7:0]           byte0;
wire    [7:0]           byte1;
wire    [7:0]           byte2;
wire    [7:0]           byte3;
wire    [7:0]           byte4;
wire    [7:0]           byte5;
wire    [7:0]           byte6;
wire    [7:0]           byte7;
wire                    term0;
wire                    term1;
wire                    term2;
wire                    term3;
wire                    term4;
wire                    term5;
wire                    term6;
wire                    term7;
wire                    data0;
wire                    data1;
wire                    data2;
wire                    data3;
wire                    data4;
wire                    data5;
wire                    data6;
wire                    data7;
wire                    cntl0;
wire                    cntl1;
wire                    cntl2;
wire                    cntl3;
wire                    cntl4;
wire                    cntl5;
wire                    cntl6;
wire                    cntl7;
wire                    error0;
wire                    error1;
wire                    error2;
wire                    error3;
wire                    error4;
wire                    error5;
wire                    error6;
wire                    error7;
wire                    cntlorerr0;
wire                    cntlorerr1;
wire                    cntlorerr2;
wire                    cntlorerr3;
wire                    cntlorerr4;
wire                    cntlorerr5;
wire                    cntlorerr6;
wire                    cntlorerr7;
wire                    ord0;
wire                    ord4;
wire                    start0;
wire                    start4;
wire                    lpi0;
wire                    lpi1;
wire                    lpi2;
wire                    lpi3;
wire                    lpi4;
wire                    lpi5;
wire                    lpi6;
wire                    lpi7;

wire    [63:0]          txd_xfi_in;
wire    [7:0]           txc_xfi_in;

wire    [7:0]           lpi_7_0;
reg                     t_type_li;
wire                    t_type_li_nxt;

// ----------------------------------------------------------------------------
// Parameters
// ----------------------------------------------------------------------------
parameter TX_INIT     = 4'b0000;
parameter TX_C        = 4'b1001;
parameter TX_S        = 4'b1010;
parameter TX_D        = 4'b0011;
parameter TX_T        = 4'b1100;
parameter TX_E        = 4'b0101;
parameter TX_N        = 4'b1111;
parameter TX_LI       = 4'b0110;
parameter LBLOCK_T    = 2'b01;
parameter ENCODE      = 2'b00;
parameter EBLOCK_T    = 2'b10;
parameter TERM        = 8'hfd;
parameter START       = 8'hfb;
parameter ORDER       = 8'h9c;
parameter ERROR       = 8'hfe;
parameter IDLE        = 8'h07;
parameter LPI         = 8'h06;
parameter FSIG        = 8'h5c;
`ifndef XFIPCS_16G32GFC
parameter IDLE_R      = 8'h1c;
parameter CODE_3C     = 8'h3c;
parameter IDLE_A      = 8'h7c;
parameter IDLE_K      = 8'hbc;
parameter CODE_DC     = 8'hdc;
parameter CODE_F7     = 8'hf7;
`endif

parameter DATA  = 2'b00;
parameter QUIET = 2'b01;
parameter ALERT = 2'b10;

// ----------------------------------------------------------------------------
// Implementation
// ----------------------------------------------------------------------------
 assign t_type_li_nxt = (t_type == TX_LI);

 `ifdef XFIPCS_16G32GFC
 reg reset_to_pma_tx_pmaclkdiv2;
 always @(posedge pma_tx_clk)
   begin
     reset_to_pma_tx_pmaclkdiv2 <= reset_to_pma_tx_pmaclk;
   end

 assign txd_xfi_in = reset_to_pma_tx_pmaclkdiv2 ? 64'h0707070707070707 :
                     tx_fifo_pop ? txd_xfi : data_xfi ;
 assign txc_xfi_in = reset_to_pma_tx_pmaclkdiv2 ? 8'hff :
                     tx_fifo_pop ? txc_xfi : cntl_xfi ;
 `else
 assign txd_xfi_in = reset_to_pma_tx ? 64'h0707070707070707 :
                     tx_fifo_pop ? txd_xfi : data_xfi ;
 assign txc_xfi_in = reset_to_pma_tx ? 8'hff :
                     tx_fifo_pop ? txc_xfi : cntl_xfi ;
 `endif                     

 always @(posedge pma_tx_clk)
   begin
     if (reset_to_pma_tx) begin
      t_type_prev   <= TX_N;
     end else begin
      t_type_prev   <= t_type;
     end

     tx_fifo_pop_2 <= tx_fifo_pop;
     data_xfi      <= txd_xfi_in;
     cntl_xfi      <= txc_xfi_in;
     t_type_li     <= t_type_li_nxt;
   end

   assign byte0 =  txd_xfi_in[7 :0 ] ;
   assign byte1 =  txd_xfi_in[15:8 ] ;
   assign byte2 =  txd_xfi_in[23:16] ;
   assign byte3 =  txd_xfi_in[31:24] ;
   assign byte4 =  txd_xfi_in[39:32] ;
   assign byte5 =  txd_xfi_in[47:40] ;
   assign byte6 =  txd_xfi_in[55:48] ;
   assign byte7 =  txd_xfi_in[63:56] ;

   assign data0 = !txc_xfi_in[0] ;
   assign data1 = !txc_xfi_in[1] ;
   assign data2 = !txc_xfi_in[2] ;
   assign data3 = !txc_xfi_in[3] ;
   assign data4 = !txc_xfi_in[4] ;
   assign data5 = !txc_xfi_in[5] ;
   assign data6 = !txc_xfi_in[6] ;
   assign data7 = !txc_xfi_in[7] ;

   assign term0 = (txc_xfi_in[0] == 1'b1) & (byte0 == TERM);
   assign term1 = (txc_xfi_in[1] == 1'b1) & (byte1 == TERM);
   assign term2 = (txc_xfi_in[2] == 1'b1) & (byte2 == TERM);
   assign term3 = (txc_xfi_in[3] == 1'b1) & (byte3 == TERM);
   assign term4 = (txc_xfi_in[4] == 1'b1) & (byte4 == TERM);
   assign term5 = (txc_xfi_in[5] == 1'b1) & (byte5 == TERM);
   assign term6 = (txc_xfi_in[6] == 1'b1) & (byte6 == TERM);
   assign term7 = (txc_xfi_in[7] == 1'b1) & (byte7 == TERM);
   assign ord0  = (txc_xfi_in[3:0] == 4'h1) & ((byte0 == ORDER) | (byte0 == FSIG));
   assign ord4  = (txc_xfi_in[7:4] == 4'h1) & ((byte4 == ORDER) | (byte4 == FSIG));
   assign start0 = (txc_xfi_in == 8'h01) & (byte0 == START);
   assign start4 = (txc_xfi_in[7:4] == 4'h1) & (byte4 == START);
   assign error0 = (txc_xfi_in[0] == 1'b1) & (byte0 == ERROR);
   assign error1 = (txc_xfi_in[1] == 1'b1) & (byte1 == ERROR);
   assign error2 = (txc_xfi_in[2] == 1'b1) & (byte2 == ERROR);
   assign error3 = (txc_xfi_in[3] == 1'b1) & (byte3 == ERROR);
   assign error4 = (txc_xfi_in[4] == 1'b1) & (byte4 == ERROR);
   assign error5 = (txc_xfi_in[5] == 1'b1) & (byte5 == ERROR);
   assign error6 = (txc_xfi_in[6] == 1'b1) & (byte6 == ERROR);
   assign error7 = (txc_xfi_in[7] == 1'b1) & (byte7 == ERROR);

   assign lpi0 = (txc_xfi_in[0] == 1'b1) & (byte0 == LPI);
   assign lpi1 = (txc_xfi_in[1] == 1'b1) & (byte1 == LPI);
   assign lpi2 = (txc_xfi_in[2] == 1'b1) & (byte2 == LPI);
   assign lpi3 = (txc_xfi_in[3] == 1'b1) & (byte3 == LPI);
   assign lpi4 = (txc_xfi_in[4] == 1'b1) & (byte4 == LPI);
   assign lpi5 = (txc_xfi_in[5] == 1'b1) & (byte5 == LPI);
   assign lpi6 = (txc_xfi_in[6] == 1'b1) & (byte6 == LPI);
   assign lpi7 = (txc_xfi_in[7] == 1'b1) & (byte7 == LPI);

   assign lpi_7_0 = {lpi7,lpi6,lpi5,lpi4,lpi3,lpi2,lpi1,lpi0};

   `ifdef XFIPCS_16G32GFC
   assign cntl0 = txc_xfi_in[0] == 1'b1 &
                  ( byte0 == IDLE    | byte0 == LPI);
   assign cntl1 = txc_xfi_in[1] == 1'b1 &
                  ( byte1 == IDLE    | byte1 == LPI);
   assign cntl2 = txc_xfi_in[2] == 1'b1 &
                  ( byte2 == IDLE    | byte2 == LPI);
   assign cntl3 = txc_xfi_in[3] == 1'b1 &
                  ( byte3 == IDLE    | byte3 == LPI);
   assign cntl4 = txc_xfi_in[4] == 1'b1 &
                  ( byte4 == IDLE    | byte4 == LPI);
   assign cntl5 = txc_xfi_in[5] == 1'b1 &
                  ( byte5 == IDLE    | byte5 == LPI);
   assign cntl6 = txc_xfi_in[6] == 1'b1 &
                  ( byte6 == IDLE    | byte6 == LPI);
   assign cntl7 = txc_xfi_in[7] == 1'b1 &
                  ( byte7 == IDLE    | byte7 == LPI);
   `else
   assign cntl0 = txc_xfi_in[0] == 1'b1 &
                  ( byte0 == IDLE    | byte0 == IDLE_A  |
                    byte0 == IDLE_R  | byte0 == IDLE_K  |
                    byte0 == CODE_3C | byte0 == CODE_DC |
                    byte0 == CODE_F7 | byte0 == LPI);
   assign cntl1 = txc_xfi_in[1] == 1'b1 &
                  ( byte1 == IDLE    | byte1 == IDLE_A  |
                    byte1 == IDLE_R  | byte1 == IDLE_K  |
                    byte1 == CODE_3C | byte1 == CODE_DC |
                    byte1 == CODE_F7 | byte1 == LPI);
   assign cntl2 = txc_xfi_in[2] == 1'b1 &
                  ( byte2 == IDLE    | byte2 == IDLE_A  |
                    byte2 == IDLE_R  | byte2 == IDLE_K  |
                    byte2 == CODE_3C | byte2 == CODE_DC |
                    byte2 == CODE_F7 | byte2 == LPI);
   assign cntl3 = txc_xfi_in[3] == 1'b1 &
                  ( byte3 == IDLE    | byte3 == IDLE_A  |
                    byte3 == IDLE_R  | byte3 == IDLE_K  |
                    byte3 == CODE_3C | byte3 == CODE_DC |
                    byte3 == CODE_F7 | byte3 == LPI);
   assign cntl4 = txc_xfi_in[4] == 1'b1 &
                  ( byte4 == IDLE    | byte4 == IDLE_A  |
                    byte4 == IDLE_R  | byte4 == IDLE_K  |
                    byte4 == CODE_3C | byte4 == CODE_DC |
                    byte4 == CODE_F7 | byte4 == LPI);
   assign cntl5 = txc_xfi_in[5] == 1'b1 &
                  ( byte5 == IDLE    | byte5 == IDLE_A  |
                    byte5 == IDLE_R  | byte5 == IDLE_K  |
                    byte5 == CODE_3C | byte5 == CODE_DC |
                    byte5 == CODE_F7 | byte5 == LPI);
   assign cntl6 = txc_xfi_in[6] == 1'b1 &
                  ( byte6 == IDLE    | byte6 == IDLE_A  |
                    byte6 == IDLE_R  | byte6 == IDLE_K  |
                    byte6 == CODE_3C | byte6 == CODE_DC |
                    byte6 == CODE_F7 | byte6 == LPI);
   assign cntl7 = txc_xfi_in[7] == 1'b1 &
                  ( byte7 == IDLE    | byte7 == IDLE_A  |
                    byte7 == IDLE_R  | byte7 == IDLE_K  |
                    byte7 == CODE_3C | byte7 == CODE_DC |
                    byte7 == CODE_F7 | byte7 == LPI);
   `endif                  


   assign cntlorerr0 = cntl0 | error0;
   assign cntlorerr1 = cntl1 | error1;
   assign cntlorerr2 = cntl2 | error2;
   assign cntlorerr3 = cntl3 | error3;
   assign cntlorerr4 = cntl4 | error4;
   assign cntlorerr5 = cntl5 | error5;
   assign cntlorerr6 = cntl6 | error6;
   assign cntlorerr7 = cntl7 | error7;

 assign t_type = (!tx_fifo_pop && (t_type_prev == TX_LI))               ? TX_LI :
                 tx_fifo_pop == 1'b0                                    ? TX_N :
                 (cntl0 && cntl1 && cntl2 && cntl3 &&
                  cntl4 && cntl5 && cntl6 && cntl7 &&
                  ((lpi_7_0 == 8'h00) || (lpi_7_0 == 8'hF0) || (lpi_7_0 == 8'h0F))) ||
                  (ord0 && cntlorerr4 && cntlorerr5 && cntlorerr6 && cntlorerr7) ||
                  (ord4 && cntlorerr0 && cntlorerr1 && cntlorerr2 && cntlorerr3) ||
                 (ord0 && ord4)                                         ? TX_C :
                 (lpi0 && lpi1 && lpi2 && lpi3 &&
                  lpi4 && lpi5 && lpi6 && lpi7)                         ? TX_LI :
                 start0 ||
                 (start4 && (ord0 ||
                  (cntlorerr0 && cntlorerr1 && cntlorerr2 && cntlorerr3))) ? TX_S :
                 `ifndef XFIPCS_16G32GFC 
                 (term0      && cntlorerr1 && cntlorerr2 && cntlorerr3 &&
                  cntlorerr4 && cntlorerr5 && cntlorerr6 && cntlorerr7)   ||
                 (data0      && term1      && cntlorerr2 && cntlorerr3 &&
                  cntlorerr4 && cntlorerr5 && cntlorerr6 && cntlorerr7)   ||
                 (data0      && data1      && term2      && cntlorerr3 &&
                  cntlorerr4 && cntlorerr5 && cntlorerr6 && cntlorerr7)   ||
                 `endif 
                 (data0      && data1      && data2      && term3      &&
   cntlorerr4 && cntlorerr5 && cntlorerr6 && cntlorerr7 && ~ALTERNATE_ENCODE) ||
                 (data0      && data1      && data2      && term3      &&
   ord4 && data5 && data6 && data7 && ALTERNATE_ENCODE) ||
                 `ifndef XFIPCS_16G32GFC
                 (data0      && data1      && data2      && data3      &&
                  term4      && cntlorerr5 && cntlorerr6 && cntlorerr7)   ||
                 (data0      && data1      && data2      && data3      &&
                  data4      && term5      && cntlorerr6 && cntlorerr7)   ||
                 (data0      && data1      && data2      && data3      &&
                  data4      && data5      && term6      && cntlorerr7)   ||
                 `endif 
                 (data0      && data1      && data2      && data3      &&
                  data4      && data5      && data6      && term7)      ? TX_T :
                 (data0      && data1      && data2      && data3      &&
                  data4      && data5      && data6      && data7)      ? TX_D :
                                                                          TX_E ;

 `XFIPCS_TOPLEVELNAME_TX_FSM tx_fsm
 (
  .clk      (pma_tx_clk     ),
  .reset    (reset_to_pma_tx),

  .t_type   (t_type         ),

  .tx_coded (tx_coded       )
 );

 `XFIPCS_TOPLEVELNAME_TX_LPI_FSM tx_lpi_fsm
 (
  .clk                     (pma_tx_clk             ),
  .reset                   (reset_to_pma_tx        ),
  .enable_alternate_refresh (enable_alternate_refresh),
  .t_type_li               (t_type_li_nxt          ),
  .scr_bypass_enable       (scr_bypass_enable      ),
  .tx_hss_t1_value         (tx_hss_t1_value        ),
  .tx_hss_t2_value         (tx_hss_t2_value        ),
  .tx_hss_t3_value         (tx_hss_t3_value        ),
  `ifdef XFIPCS_16G32GFC
  .SPEED_SEL               (SPEED_SEL              ),
  .lpi_fw                  (lpi_fw                 ),
  .tx_tw_timer_value       (tx_tw_timer_value      ),
  `endif

  .tx_mode                 (tx_mode                ),
  `ifdef XFIPCS_16G32GFC
  .tx_lpi_active           (tx_lpi_active          ),
  `endif
  .scrambler_bypass        (scrambler_bypass       ),
  .tx_active               (tx_active              ),
  .TXxQUIET                (TXxQUIET               ),
  .TXxREFRESH              (TXxREFRESH             )
 );

 assign encoder_data_in = (tx_coded == LBLOCK_T)        ? 64'h0100009c0100009c :
                          (tx_coded == EBLOCK_T)        ? 64'hfefefefefefefefe :
                          (tx_mode == QUIET)            ? 64'h0606060606060606 :
                                                                      data_xfi ;

 assign encoder_control_in = (tx_coded == LBLOCK_T)                    ? 8'h11 :
                             (tx_coded == EBLOCK_T)                    ? 8'hff :
                             (tx_mode == QUIET)                        ? 8'hff :
                                                                      cntl_xfi ;

 assign tx_local_fault = (tx_coded == LBLOCK_T) ? 1'b1 : 1'b0 ;

endmodule
