//SCCS File Version= %I% 
//Release Date= 14/04/20  19:56:27 GMT startFileName /vobs/vob012/xfipcs/verilog/rtl/XFIPCS_BER_FSM.v endFileName  

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
//----------------------------------------------------------------------
// FILE NAME:
//   XFIPCS_BER_FSM.v
//
// DESCRIPTION:
//   BER Monitor state machine (Figure 49-13)
//
//----------------------------------------------------------------------

`include "XFIPCS.defines.v"
`timescale 1ns/10ps

module `XFIPCS_TOPLEVELNAME_BER_FSM (
                     clk,
                     reset,

                     rx_block_lock,
                     ber_test_sh_set,
                     r_test_mode,
                     sh_valid,
                     rx_lpi_active,
`ifdef XFIPCS_16G32GFC
                     ber_timer_value,
`endif

                     inc_ber_count,
                     hi_ber
                    );

// ----------------------------------------------------------------------------
// Inputs/Outputs
// ----------------------------------------------------------------------------
input           clk;
input           reset;
input           r_test_mode;
input           sh_valid;
input           rx_block_lock;
input           ber_test_sh_set;
input           rx_lpi_active;
`ifdef XFIPCS_16G32GFC
input   [17:0]  ber_timer_value;
`endif

output          hi_ber;
output          inc_ber_count;

// ----------------------------------------------------------------------------
// Internal signals/registers
// ----------------------------------------------------------------------------
reg             hi_ber;
reg             inc_ber_count;
reg             inc_ber_count_nxt;
reg             start_125us_timer;
`ifdef XFIPCS_16G32GFC
reg     [17:0]  timer;
`else
reg     [15:0]  timer;
`endif
reg     [3:0]   ber_state;
reg     [3:0]   ber_state_nxt;
reg     [4:0]   ber_cnt;
wire            timer_done;
reg             hi_ber_nxt;
reg             start_125us_timer_nxt;
`ifdef XFIPCS_16G32GFC
reg     [17:0]  timer_nxt;
`else
reg     [15:0]  timer_nxt;
`endif
reg     [4:0]   ber_cnt_nxt;
reg             ber_test_sh_clear_nxt;
reg             ber_test_sh_clear;
reg             ber_test_sh_prev;
wire            ber_test_sh;
`ifdef XFIPCS_16G32GFC
wire    [17:0]  timer_max;
`else
wire    [15:0]  timer_max;
`endif

// ----------------------------------------------------------------------------
// Parameters
// ----------------------------------------------------------------------------
parameter BER_MT_INIT = 4'b1000;
parameter START_TIMER = 4'b1001;
parameter BER_TEST_SH = 4'b1010;
parameter GOOD_BER    = 4'b0011;
parameter BER_BAD_SH  = 4'b1100;
parameter HI_BER      = 4'b0101;

// ----------------------------------------------------------------------------
// Implementation
// ----------------------------------------------------------------------------
 assign ber_test_sh = (ber_test_sh_prev || ber_test_sh_set) && ~ber_test_sh_clear;

 // This is the Lock state machine of Fig 49-13 in IEEE 802.3ae C49
 always @(*) begin : fsm
   ber_state_nxt = ber_state;
   hi_ber_nxt = hi_ber;
   start_125us_timer_nxt = 1'b0;
   ber_cnt_nxt = ber_cnt;
   inc_ber_count_nxt = 1'b0;
   ber_test_sh_clear_nxt = 1'b0;

   if (!(reset == 1'b1 || r_test_mode == 1'b1 || rx_block_lock == 1'b0 || rx_lpi_active)) begin
     case (ber_state)
       BER_MT_INIT : begin
         ber_state_nxt = START_TIMER;
         ber_cnt_nxt = 5'h00;
         start_125us_timer_nxt = 1'b1 ;
       end

       START_TIMER : begin
         if (ber_test_sh == 1'b1) begin
           ber_state_nxt = BER_TEST_SH;
           ber_test_sh_clear_nxt = 1'b1;
         end
       end

       BER_TEST_SH : begin
         if (sh_valid == 1'b0) begin
           ber_state_nxt = BER_BAD_SH;
           ber_cnt_nxt = ber_cnt + 1;
           inc_ber_count_nxt = 1'b1;
         end else if (timer_done == 1'b1) begin
           ber_state_nxt = GOOD_BER;
           hi_ber_nxt = 1'b0;
         end else ber_test_sh_clear_nxt = 1'b1;
       end

       GOOD_BER : begin
         ber_state_nxt = START_TIMER;
         ber_cnt_nxt = 5'h00;
         start_125us_timer_nxt = 1'b1;
       end

       BER_BAD_SH : begin
         if (ber_cnt[4] == 1'b1) begin
           ber_state_nxt = HI_BER;
           hi_ber_nxt = 1'b1;
         end else if (timer_done == 1'b0 && ber_test_sh == 1'b1)
         begin
           ber_state_nxt = BER_TEST_SH;
           ber_test_sh_clear_nxt = 1'b1;
         end else if (timer_done == 1'b1) begin
           ber_state_nxt = GOOD_BER;
           hi_ber_nxt = 1'b0;
         end
       end

       HI_BER : begin
         if (timer_done == 1'b1) begin
           ber_state_nxt = START_TIMER;
           ber_cnt_nxt = 5'h00;
           start_125us_timer_nxt = 1'b1;
         end
       end

       default : begin
         ber_state_nxt = BER_MT_INIT;
         hi_ber_nxt = 1'b0;
         ber_test_sh_clear_nxt = 1'b1;
       end
     endcase
   end
 end

 `ifdef XFIPCS_TOPLEVELNAME_WIS_ENABLED
   assign timer_max = 16'h8af0;    // 16'h8af0 = 35568 = 95% * 125 us * 299.52 MHz
 `else
   `ifdef XFIPCS_16G32GFC
   //assign timer_max = SPEED_SEL ? 16'hcb4d : 16'h65a6;    // 32G: 16'hcb4d = 52045 = 95% * 125 us * 438.28125 MHz
                                                            // 16G: 16'h65a6 = 26022 = 95% * 125 us * 219.140625 MHz
   //assign timer_max = SPEED_SEL ? 17'h1969b : 17'hcb4d;   // 32G: 17'h1969b = 104091 = 95% * 125 us * 876.5625 MHz
                                                            // 16G: 17'hcb4d = 52045 = 95% * 125 us * 438.28125 MHz
   assign timer_max = ber_timer_value;                                                            
   `else
   assign timer_max = 16'h957d;    // 16'h957d = 38269 = 95% * 125 us * 322.27 MHz
   `endif
 `endif

 always @(reset or timer or start_125us_timer or timer_max) begin
   `ifdef XFIPCS_16G32GFC
   if (reset == 1'b1) timer_nxt = 18'h00000;
   `else
   if (reset == 1'b1) timer_nxt = 16'h0000;
   `endif
   else if (start_125us_timer == 1'b1)
 `ifdef XFIPCS_TOPLEVELNAME_SHORT_BER_TIMER
     `ifdef XFIPCS_16G32GFC
     timer_nxt = {4'h0, timer_max[17:4]};
     `else
     timer_nxt = {4'h0, timer_max[15:4]};
     `endif
 `else
     timer_nxt = timer_max;
 `endif
   `ifdef XFIPCS_16G32GFC
   else if (timer != 18'h00000)
   `else
   else if (timer != 16'h0000)
   `endif
     timer_nxt = timer - 1;
   else timer_nxt = timer;
 end

 `ifdef XFIPCS_16G32GFC
 assign timer_done = (timer == 18'h00000);
 `else
 assign timer_done = (timer == 16'h0000);
 `endif

 always @(posedge clk) begin : flops
   if (reset == 1'b1 || r_test_mode == 1'b1 || rx_block_lock == 1'b0 || rx_lpi_active) begin
    ber_state         <= BER_MT_INIT;
    ber_cnt           <= 5'h00;
    hi_ber            <= 1'b0;
    inc_ber_count     <= 1'b0;
    ber_test_sh_clear <= 1'b1;
   end else begin
    ber_state         <= ber_state_nxt;
    ber_cnt           <= ber_cnt_nxt;
    hi_ber            <= hi_ber_nxt;
    inc_ber_count     <= inc_ber_count_nxt;
    ber_test_sh_clear <= ber_test_sh_clear_nxt;
   end

    ber_test_sh_prev  <= ber_test_sh;
   timer             <= timer_nxt;
   start_125us_timer <= start_125us_timer_nxt;
 end

endmodule
