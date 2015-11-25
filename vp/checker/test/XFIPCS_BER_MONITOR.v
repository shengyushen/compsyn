//SCCS File Version= %I% 
//Release Date= 14/04/20  19:56:30 GMT startFileName /vobs/vob012/xfipcs/verilog/rtl/XFIPCS_BER_MONITOR.v endFileName  

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

//$Id: XFIPCS_BER_MONITOR.v,v 1.8 2014/02/21 07:12:00 huqian Exp $
//$Log: XFIPCS_BER_MONITOR.v,v $
//Revision 1.8  2014/02/21 07:12:00  huqian
//Copy XFIPCS cvs tag v1_135
//
//Revision 1.8  2014/02/13 08:41:58  huqian
//Add registers ber_timer_value 1 and ber_timer_value 2
//
//Revision 1.7  2014/01/06 03:49:26  huqian
//Add SPEED_SEL input
//
//Revision 1.6  2011/02/08 16:05:10  adamc
//cvs_snap v1_22
//
//Revision 1.5  2011/01/28 19:10:47  adamc
//cvs_snap v1_16
//
//Revision 1.4  2011/01/25 14:28:31  adamc
//Updated reset logic
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

module `XFIPCS_TOPLEVELNAME_BER_MONITOR (
                        pma_rx_clk,
                        reset_to_pma_rx,

                        rx_block_lock,
                        data_valid,
                        r_test_mode,
                        sh_valid,
                        rx_lpi_active,
`ifdef XFIPCS_16G32GFC
                        ber_timer_value,
`endif

                        hi_ber,
                        inc_ber_count
                );

input                   pma_rx_clk;
input                   reset_to_pma_rx;

input                   rx_block_lock;
input                   data_valid;
input                   r_test_mode;
input                   sh_valid;
input                   rx_lpi_active;
`ifdef XFIPCS_16G32GFC
input   [17:0]          ber_timer_value;
`endif

output                  hi_ber;
output                  inc_ber_count;
wire                    hi_ber;
wire    [2:0]           block_lock_count_in;
reg     [2:0]           block_lock_count;
wire                    ber_test_sh_set;
wire                    inc_ber_count;
wire                    ber_block_lock;

`XFIPCS_TOPLEVELNAME_BER_FSM ber_fsm(
                        .clk             (pma_rx_clk             ),
                        .reset           (reset_to_pma_rx        ),

                        .rx_block_lock   (ber_block_lock         ),
                        .ber_test_sh_set (ber_test_sh_set        ),
                        .r_test_mode     (r_test_mode            ),
                        .sh_valid        (sh_valid               ),
                        .rx_lpi_active   (rx_lpi_active          ),
                        `ifdef XFIPCS_16G32GFC
                        .ber_timer_value (ber_timer_value        ),
                        `endif

                        .inc_ber_count   (inc_ber_count          ),
                        .hi_ber          (hi_ber                 )
                );

assign ber_test_sh_set = data_valid;
assign block_lock_count_in = (rx_block_lock)            ? 3'h7 :
                             (block_lock_count == 3'h0) ? 3'h0 :
                                                          block_lock_count - 1;
assign ber_block_lock = (block_lock_count != 3'b0);

always @(posedge pma_rx_clk)
  begin
   if (reset_to_pma_rx)
    block_lock_count <= 3'h0;
   else
    block_lock_count <= block_lock_count_in;
  end

endmodule
