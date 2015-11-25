//SCCS File Version= %I% 
//Release Date= 14/04/20  19:56:41 GMT startFileName /vobs/vob012/xfipcs/verilog/rtl/XFIPCS_RESET.v endFileName  

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

//$Id: XFIPCS_RESET.v,v 1.11 2014/03/11 11:56:12 huqian Exp $
//$Log: XFIPCS_RESET.v,v $
//Revision 1.11  2014/03/11 11:56:12  huqian
//Fix some cdc violations
//
//Revision 1.10  2014/02/26 08:03:48  huqian
//Fix HW281472: X-State through RESET from WAM
//
//Revision 1.9  2014/02/25 05:27:33  huqian
//Fix HW281472: X-State through RESET from WAM
//
//Revision 1.8  2014/02/21 07:12:00  huqian
//Copy XFIPCS cvs tag v1_135
//
//Revision 1.10  2013/12/18 08:32:53  huqian
//Add synthesis option to remove RX FIFO control(clock compensation) logic and RX XGMII data interface
//
//Revision 1.9  2013/12/17 08:44:48  huqian
//Add synthesis option to remove TX FIFO control(clock compensation) logic and TX XGMII data interface
//
//Revision 1.8  2013/12/12 03:29:20  huqian
//Modify XFIPCS_32GFC macro define to XFIPCS_16G32GFC
//
//Revision 1.7  2013/09/17 05:48:15  huqian
//Initial 32G Fibre Channel
//
//Revision 1.6  2011/03/09 16:00:57  adamc
//cvs_snap v1_47
//
//Revision 1.5  2011/02/22 16:02:09  adamc
//cvs_snap v1_30
//
//Revision 1.4  2011/01/21 21:27:46  adamc
//Some reset cleanup especially for RX
//
//Revision 1.3  2011/01/14 15:02:27  adamc
//Added separate resets for RX fifo
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

module `XFIPCS_TOPLEVELNAME_RESET (
                        pma_rx_clk,
                        pma_tx_clk,
`ifdef XFIPCS_16G32GFC                        
                        pma_rx_clk_div2,
                        pma_tx_clk_div2,
                        speed_sel_xgmii,
`endif                        
                        xgmii_clk,
                        reset_async,

                        reset_from_md,
                        reset_from_pma_rx,
                        reset_from_pma_tx,
`ifdef XFIPCS_FIFOCNTL                        
                        rx_overflow,
                        rx_underflow,
                        tx_overflow,
                        tx_underflow,
`endif                        
                        loopback_reset,
                        loopback_xgmii,

                        reset_to_md,
                        reset_to_pma_rx,
                        reset_to_pma_tx,
`ifdef XFIPCS_16G32GFC
                        reset_to_pma_rx_div2,
                        reset_to_pma_tx_div2,
`endif
                        reset_to_xgmii,
                        reset_to_xgmii_rx,
                        reset_to_xgmii_tx
                );

// ----------------------------------------------------------------------------
// Inputs/Outputs
// ----------------------------------------------------------------------------
input           pma_rx_clk;
input           pma_tx_clk;
`ifdef XFIPCS_16G32GFC
input           pma_rx_clk_div2;
input           pma_tx_clk_div2;
input           speed_sel_xgmii;
`endif
input           reset_async;
input           xgmii_clk;

input           reset_from_md;
input           reset_from_pma_rx;
input           reset_from_pma_tx;
`ifdef XFIPCS_FIFOCNTL
input           rx_overflow;
input           rx_underflow;
input           tx_overflow;
input           tx_underflow;
`endif
input           loopback_reset;
input           loopback_xgmii;

output          reset_to_md;
output          reset_to_pma_rx;
output          reset_to_pma_tx;
`ifdef XFIPCS_16G32GFC
output          reset_to_pma_rx_div2;
output          reset_to_pma_tx_div2;
`endif 
output          reset_to_xgmii;
output          reset_to_xgmii_rx;
output          reset_to_xgmii_tx;

// ----------------------------------------------------------------------------
// Internal signals/registers
// ----------------------------------------------------------------------------
wire            reset_to_md;
wire            reset_to_pma_rx;
wire            reset_to_pma_tx;
reg             reset_to_xgmii;
reg             reset_to_xgmii_rx;
reg             reset_to_xgmii_tx;
wire            reset_from_pma_rx_flop;

wire            reset_sync;
wire            reset_from_async_or_md;
wire            reset_from_pma_rx_or_async_or_md;
wire            reset_from_pma_tx_or_async_or_md;
wire            reset_from_pma_tx_flop;
wire            reset_from_pma_rx_to_xgmii;
wire            reset_from_pma_tx_to_xgmii;

wire    [3:0]   rx_reset_count_nxt;
reg     [3:0]   rx_reset_count;
wire    [3:0]   tx_reset_count_nxt;
reg     [3:0]   tx_reset_count;

// ----------------------------------------------------------------------------
// Implementation
// ----------------------------------------------------------------------------

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS async01(
                         .clk    (xgmii_clk                      ),
                         .data_in(reset_async                    ),
                         .data_out(reset_sync                     )
                 );

 assign reset_from_async_or_md = reset_sync || reset_from_md;
 assign reset_to_md = reset_sync;

 always @(posedge xgmii_clk)
   begin
     reset_to_xgmii <= reset_from_async_or_md;
   end

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1) async10(
                         .clk    (pma_rx_clk                     ),
                         .data_in(reset_from_pma_rx              ),
                         .data_out(reset_from_pma_rx_flop         )
                 );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1) async02(
                         .clk    (xgmii_clk                      ),
                         .data_in(reset_from_pma_rx_flop         ),
                         .data_out(reset_from_pma_rx_to_xgmii     )
                 );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1) async03(
                         .clk    (xgmii_clk                      ),
                         .data_in(reset_from_pma_tx_flop         ),
                         .data_out(reset_from_pma_tx_to_xgmii     )
                 );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1) async12(
                         .clk    (pma_tx_clk                     ),
                         .data_in(reset_from_pma_tx              ),
                         .data_out(reset_from_pma_tx_flop        )
                 );

 `ifdef XFIPCS_FIFOCNTL
 assign reset_from_pma_rx_or_async_or_md = reset_from_async_or_md ||
                       (~loopback_xgmii && reset_from_pma_rx_to_xgmii) ||
                       (rx_reset_count == 4'hf && (rx_overflow || rx_underflow)) ||
                                           loopback_reset ;

 assign reset_from_pma_tx_or_async_or_md = reset_from_async_or_md ||
                       (~loopback_xgmii && reset_from_pma_tx_to_xgmii) ||
                        (tx_reset_count == 4'hf && (tx_overflow || tx_underflow)) ;
 `else
 assign reset_from_pma_rx_or_async_or_md = reset_from_async_or_md ||
                       (~loopback_xgmii && reset_from_pma_rx_to_xgmii) ||
                                           loopback_reset ;

 assign reset_from_pma_tx_or_async_or_md = reset_from_async_or_md ||
                       (~loopback_xgmii && reset_from_pma_tx_to_xgmii) ;
 `endif

 assign rx_reset_count_nxt = reset_to_xgmii ? 4'h0 :
                          reset_to_xgmii_rx ? 4'h0 :
                          rx_reset_count == 4'hf ? 4'hf : rx_reset_count + 1 ;

 assign tx_reset_count_nxt = reset_to_xgmii ? 4'h0 :
                          reset_to_xgmii_tx ? 4'h0 :
                          tx_reset_count == 4'hf ? 4'hf : tx_reset_count + 1 ;

 always @(posedge xgmii_clk) begin
   reset_to_xgmii_rx <= reset_from_pma_rx_or_async_or_md;
   reset_to_xgmii_tx <= reset_from_pma_tx_or_async_or_md;
   rx_reset_count <= rx_reset_count_nxt ;
   tx_reset_count <= tx_reset_count_nxt ;
 end

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1) async06(
                         .clk    (pma_rx_clk                     ),
                         .data_in(reset_to_xgmii_rx              ),
                         .data_out(reset_to_pma_rx               )
                 );

 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1) async07(
                         .clk    (pma_tx_clk                     ),
                         .data_in(reset_to_xgmii_tx              ),
                         .data_out(reset_to_pma_tx               )
                 );

 `ifdef XFIPCS_16G32GFC
 reg reset_to_xgmii_rx_r1, reset_to_xgmii_rx_r2;
 reg reset_to_xgmii_tx_r1, reset_to_xgmii_tx_r2;
 reg reset_to_xgmii_rx_cdc, reset_to_xgmii_tx_cdc;
 always @(posedge xgmii_clk) begin
   reset_to_xgmii_rx_cdc <= speed_sel_xgmii ? reset_from_pma_rx_or_async_or_md : (reset_from_pma_rx_or_async_or_md || reset_to_xgmii_rx || reset_to_xgmii_rx_r1);
   reset_to_xgmii_tx_cdc <= speed_sel_xgmii ? reset_from_pma_tx_or_async_or_md : (reset_from_pma_tx_or_async_or_md || reset_to_xgmii_tx || reset_to_xgmii_tx_r1);
   reset_to_xgmii_rx_r2 <= reset_to_xgmii_rx_r1;
   reset_to_xgmii_rx_r1 <= reset_to_xgmii_rx;
   reset_to_xgmii_tx_r2 <= reset_to_xgmii_tx_r1;
   reset_to_xgmii_tx_r1 <= reset_to_xgmii_tx;
 end
 
 //wire reset_to_xgmii_rx_cdc, reset_to_xgmii_tx_cdc;
 //assign reset_to_xgmii_rx_cdc = speed_sel_xgmii ? reset_to_xgmii_rx : (reset_to_xgmii_rx || reset_to_xgmii_rx_r1 || reset_to_xgmii_rx_r2);
 //assign reset_to_xgmii_tx_cdc = speed_sel_xgmii ? reset_to_xgmii_tx : (reset_to_xgmii_tx || reset_to_xgmii_tx_r1 || reset_to_xgmii_tx_r2);
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1) async08(
                         .clk    (pma_rx_clk_div2                ),
                         .data_in(reset_to_xgmii_rx_cdc          ),
                         .data_out(reset_to_pma_rx_div2          )
                 );
 
 `XFIPCS_TOPLEVELNAME_ASYNC_DRS #(1) async09(
                         .clk    (pma_tx_clk_div2                ),
                         .data_in(reset_to_xgmii_tx_cdc          ),
                         .data_out(reset_to_pma_tx_div2          )
                 );
 `endif                
endmodule
