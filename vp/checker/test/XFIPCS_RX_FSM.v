//SCCS File Version= %I% 
//Release Date= 14/04/20  19:56:52 GMT startFileName /vobs/vob012/xfipcs/verilog/rtl/XFIPCS_RX_FSM.v endFileName  

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
//-----------------------------------------------------------------------------
// Copyright IBM Corporation 2001-2005
// IBM Confidential
//-----------------------------------------------------------------------------

`include "XFIPCS.defines.v"
`timescale 1ns/10ps

module `XFIPCS_TOPLEVELNAME_RX_FSM (
                     clk,
                     reset,
                     r_test_mode,
                     hi_ber,
                     block_lock,
                     r_type,
                     r_type_next,
                     rx_lpi_active,
                     inc_ebc,
                     rx_raw,
                     pcs_r_status
                    );
// ----------------------------------------------------------------------------
// Inputs/Outputs
// ----------------------------------------------------------------------------
input           clk;
input           reset;
input           r_test_mode;
input           hi_ber;
input           block_lock;
input   [4:0]   r_type;
input   [4:0]   r_type_next;
input           rx_lpi_active;

output          inc_ebc;
output  [1:0]   rx_raw;
output          pcs_r_status;

// ----------------------------------------------------------------------------
// Internal signals/registers
// ----------------------------------------------------------------------------
reg             inc_ebc;
reg             inc_ebc_nxt;
reg     [1:0]   rx_raw;
reg     [1:0]   rx_raw_nxt;
reg     [4:0]   rx_state;
reg     [4:0]   rx_state_nxt;
reg             pcs_r_status;
wire            pcs_r_status_nxt;

// ----------------------------------------------------------------------------
// Parameters
// ----------------------------------------------------------------------------
parameter RX_INIT     = 5'b00000;
parameter RX_C        = 5'b10001;
parameter RX_S        = 5'b10010;
parameter RX_D        = 5'b00011;
parameter RX_T        = 5'b10100;
parameter RX_E        = 5'b00101;
parameter RX_LI       = 5'b11000;
parameter LBLOCK_R    = 2'b01;
parameter DECODE      = 2'b00;
parameter EBLOCK_R    = 2'b10;
parameter LI          = 2'b11;

// ----------------------------------------------------------------------------
// Implementation
// ----------------------------------------------------------------------------

 assign pcs_r_status_nxt = (rx_state_nxt != RX_INIT);

// This is the Lock state machine of Fig 49-14 in IEEE 802.3ae C49
 always @(*)
 begin : fsm
   rx_state_nxt = rx_state;
   rx_raw_nxt = rx_raw;
   inc_ebc_nxt = 1'b0;
   if (!(reset || r_test_mode || hi_ber || !block_lock)) begin
     case (rx_state)
       RX_INIT :
         begin
           if (r_type == RX_E || r_type == RX_D || r_type == RX_T || r_type == RX_LI)
             begin
               rx_state_nxt = RX_E;
               rx_raw_nxt = EBLOCK_R;
               inc_ebc_nxt = 1'b1;
             end
           else if (r_type == RX_C)
             begin
               rx_state_nxt = RX_C;
               rx_raw_nxt = DECODE;
             end
           else if (r_type == RX_S)
             begin
               rx_state_nxt = RX_D;
               rx_raw_nxt = DECODE;
             end
         end

       RX_C :
         begin
           if (r_type == RX_E || r_type == RX_D || r_type == RX_T)
             begin
               rx_state_nxt = RX_E;
               rx_raw_nxt = EBLOCK_R;
               inc_ebc_nxt = 1'b1;
             end
           else if (r_type == RX_C)
             begin
               rx_state_nxt = RX_C;
               rx_raw_nxt = DECODE;
             end
           else if (r_type == RX_S)
             begin
               rx_state_nxt = RX_D;
               rx_raw_nxt = DECODE;
             end
           else if (r_type == RX_LI)
             begin
               rx_state_nxt = RX_LI;
               rx_raw_nxt = LI;
             end
         end

       RX_D :
         begin
           if ((r_type == RX_T &&
                (r_type_next == RX_E || r_type_next == RX_D || r_type_next == RX_T)) ||
               (r_type == RX_E || r_type == RX_C || r_type == RX_S || r_type == RX_LI))
             begin
               rx_state_nxt = RX_E;
               rx_raw_nxt = EBLOCK_R;
               inc_ebc_nxt = 1'b1;
             end
           else if ((r_type == RX_T) &&
                    (r_type_next == RX_S || r_type_next == RX_C || r_type_next == RX_LI))
             begin
               rx_state_nxt = RX_T;
               rx_raw_nxt = DECODE;
             end
           else if (r_type == RX_D)
             begin
               rx_state_nxt = RX_D;
               rx_raw_nxt = DECODE;
             end
         end

       RX_T :
         begin
           if (r_type == RX_S)
             begin
               rx_state_nxt = RX_D;
               rx_raw_nxt = DECODE;
             end
           else if (r_type == RX_C)
             begin
               rx_state_nxt = RX_C;
               rx_raw_nxt = DECODE;
             end
           else if (r_type == RX_LI)
             begin
               rx_state_nxt = RX_LI;
               rx_raw_nxt = LI;
             end
           else
             begin
               rx_state_nxt = RX_T;
               rx_raw_nxt = DECODE;
             end
         end

       RX_E :
         begin
           if ((r_type == RX_T &&
                (r_type_next == RX_E || r_type_next == RX_D || r_type_next == RX_T)) ||
               (r_type == RX_E || r_type == RX_S))
             begin
               rx_state_nxt = RX_E;
               rx_raw_nxt = EBLOCK_R;
               inc_ebc_nxt = 1'b1;
             end
           else if ((r_type == RX_T) &&
                     (r_type_next == RX_S || r_type_next == RX_C || r_type_next == RX_LI))
             begin
               rx_state_nxt = RX_T;
               rx_raw_nxt = DECODE;
             end
           else if (r_type == RX_D)
             begin
               rx_state_nxt = RX_D;
               rx_raw_nxt = DECODE;
             end
           else if (r_type == RX_C)
             begin
               rx_state_nxt = RX_C;
               rx_raw_nxt = DECODE;
             end
           else if (r_type == RX_LI)
             begin
               rx_state_nxt = RX_LI;
               rx_raw_nxt = LI;
             end
           else rx_raw_nxt = EBLOCK_R;
         end

       RX_LI :
         begin
           if (!rx_lpi_active && r_type == RX_C)
            begin
               rx_state_nxt = RX_C;
               rx_raw_nxt = DECODE;
            end
           else if (!rx_lpi_active && (r_type == RX_E || r_type == RX_D || r_type == RX_S || r_type == RX_T))
            begin
               rx_state_nxt = RX_E;
               rx_raw_nxt = EBLOCK_R;
               inc_ebc_nxt = 1'b1;
            end
         end

       default :
         begin
           rx_state_nxt = rx_state;
           rx_raw_nxt = rx_raw;
           inc_ebc_nxt = inc_ebc;
         end
     endcase
   end
 end

 always @(posedge clk)
  begin : flops
   if (reset || r_test_mode || hi_ber || !block_lock) begin
     rx_state          <= RX_INIT;
     rx_raw            <= LBLOCK_R;
     inc_ebc           <= 1'b0;
     pcs_r_status      <= 1'b0;
   end else begin
     rx_state          <= rx_state_nxt;
     rx_raw            <= rx_raw_nxt;
     inc_ebc           <= inc_ebc_nxt;
     pcs_r_status      <= pcs_r_status_nxt;
   end
  end
endmodule
