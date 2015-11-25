//SCCS File Version= %I% 
//Release Date= 14/04/20  19:56:35 GMT startFileName /vobs/vob012/xfipcs/verilog/rtl/XFIPCS_LOCK_FSM.v endFileName  

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
//   XFIPCS_TX_LOCK_FSM.v
//
// DESCRIPTION:
//   Lock State machine (Figure 49-12)
//
//----------------------------------------------------------------------

`include "XFIPCS.defines.v"
`timescale 1ns/10ps

module `XFIPCS_TOPLEVELNAME_LOCK_FSM (
                     clk,
                     reset,

                     sh_valid,
                     signal_ok,
                     slip_done_set,
                     test_sh_set,

                     rx_block_lock,
                     slip
                    );

// ----------------------------------------------------------------------------
// Inputs/Outputs
// ----------------------------------------------------------------------------
input           clk;
input           reset;
input           signal_ok;
input           sh_valid;
input           slip_done_set;
input           test_sh_set;
output          rx_block_lock;
output          slip;

// ----------------------------------------------------------------------------
// Internal signals/registers
// ----------------------------------------------------------------------------
reg             rx_block_lock;
reg     [3:0]   lock_state;
reg     [3:0]   lock_state_nxt;
reg     [6:0]   sh_cnt;
reg     [4:0]   sh_invalid_cnt;
reg             slip;
wire            slip_done;
reg             rx_block_lock_nxt;
reg     [6:0]   sh_cnt_nxt;
reg     [4:0]   sh_invalid_cnt_nxt;
reg             slip_done_nxt;
reg             slip_done_clear_nxt;
reg             slip_done_clear;
reg             slip_nxt;
reg             slip_done_prev;
reg             test_sh;
reg             test_sh_nxt;

// ----------------------------------------------------------------------------
// Parameters
// ----------------------------------------------------------------------------
parameter LOCK_INIT  = 4'b0000;
parameter RESET_CNT  = 4'b1001;
parameter TEST_SH    = 4'b1010;
parameter VALID_SH   = 4'b0011;
parameter GOOD_64    = 4'b1100;
parameter INVALID_SH = 4'b0101;
parameter SLIP       = 4'b0110;

 assign slip_done = (slip_done_prev || slip_done_set) && ~slip_done_clear;

 // This is the Lock state machine of Fig 49-12 in IEEE 802.3ae C49
 always @(*) begin : fsm
   lock_state_nxt = lock_state;
   rx_block_lock_nxt = rx_block_lock;
   sh_cnt_nxt = sh_cnt;
   sh_invalid_cnt_nxt = sh_invalid_cnt;
   test_sh_nxt = test_sh || test_sh_set;
   slip_nxt = 1'b0;
   slip_done_clear_nxt = 1'b0;

   if (!(reset || !signal_ok)) begin
     case (lock_state)
       LOCK_INIT : begin
           lock_state_nxt = RESET_CNT;
           sh_cnt_nxt = 7'h00;
           sh_invalid_cnt_nxt = 5'h00 ;
           slip_done_clear_nxt = 1'b1;
         end

       RESET_CNT : begin
           if (test_sh)
           begin
             lock_state_nxt = TEST_SH;
             test_sh_nxt = 1'b0;
           end
           else slip_done_clear_nxt = 1'b1;
         end

       TEST_SH : begin
           if (sh_valid)
           begin
            lock_state_nxt = VALID_SH;
            sh_cnt_nxt = sh_cnt + 7'h01;
           end
           else
             begin
               lock_state_nxt = INVALID_SH;
               sh_cnt_nxt = sh_cnt + 7'h01;
               sh_invalid_cnt_nxt = sh_invalid_cnt + 5'h01;
             end
         end

       VALID_SH :
         begin
           if (sh_cnt[6] == 1'b1 && sh_invalid_cnt == 5'h00)
             begin
               lock_state_nxt = GOOD_64;
               rx_block_lock_nxt = 1'b1;
             end
           else if (sh_cnt[6] == 1'b1)
             begin
               lock_state_nxt = RESET_CNT;
               sh_cnt_nxt = 7'h00;
               sh_invalid_cnt_nxt = 5'h00 ;
               slip_done_clear_nxt = 1'b1;
             end
           else if (test_sh && sh_cnt[6] == 1'b0)
             begin
               lock_state_nxt = TEST_SH;
               test_sh_nxt = 1'b0;
             end
         end

       INVALID_SH :
         begin
           if (sh_invalid_cnt[4] == 1'b1 || rx_block_lock == 1'b0)
             begin
               lock_state_nxt = SLIP;
               rx_block_lock_nxt = 1'b0;
               slip_nxt = 1'b1;
             end
           else if (sh_cnt[6] == 1'b1)
             begin
               lock_state_nxt = RESET_CNT;
               sh_cnt_nxt = 7'h00;
               sh_invalid_cnt_nxt = 5'h00 ;
               slip_done_clear_nxt = 1'b1;
             end
           else if (test_sh)
             begin
               lock_state_nxt = TEST_SH;
               test_sh_nxt = 1'b0;
             end
         end

       GOOD_64 :
         begin
           lock_state_nxt = RESET_CNT;
           sh_cnt_nxt = 7'h00;
           sh_invalid_cnt_nxt = 5'h00 ;
           slip_done_clear_nxt = 1'b1;
         end

       SLIP :
         if (slip_done)
           begin
             lock_state_nxt = RESET_CNT;
             sh_cnt_nxt = 7'h00;
             sh_invalid_cnt_nxt = 5'h00 ;
             slip_done_clear_nxt = 1'b1;
           end
         else
          slip_nxt = 1'b1;

       default :
         begin
           lock_state_nxt = lock_state;
           rx_block_lock_nxt = rx_block_lock;
         end
     endcase
   end
 end

 always @(posedge clk) begin : flops
  if (reset || !signal_ok)
   begin
    lock_state <= LOCK_INIT;
    rx_block_lock <= 1'b0;
    sh_invalid_cnt <= 5'h00;
    test_sh <= 1'b0;
    sh_cnt  <= 7'h00;
    slip    <= 1'b0;
    slip_done_prev <= 1'b0;
    slip_done_clear <= 1'b0;
   end
  else
   begin
    lock_state      <= lock_state_nxt;
    rx_block_lock   <= rx_block_lock_nxt;
    sh_invalid_cnt  <= sh_invalid_cnt_nxt;
    test_sh         <= test_sh_nxt;
    sh_cnt          <= sh_cnt_nxt;
    slip            <= slip_nxt;
    slip_done_prev  <= slip_done;
    slip_done_clear <= slip_done_clear_nxt;
   end

  //sh_cnt          <= sh_cnt_nxt;
  //slip            <= slip_nxt;
  //slip_done_prev  <= slip_done;
  //slip_done_clear <= slip_done_clear_nxt;
 end

endmodule
