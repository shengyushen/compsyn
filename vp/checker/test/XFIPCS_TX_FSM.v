//SCCS File Version= %I% 
//Release Date= 14/04/20  19:57:12 GMT startFileName /vobs/vob012/xfipcs/verilog/rtl/XFIPCS_TX_FSM.v endFileName  

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

module `XFIPCS_TOPLEVELNAME_TX_FSM (
                     clk,
                     reset,
                     t_type,
                     tx_coded
                    );

// ----------------------------------------------------------------------------
// Inputs/Outputs
// ----------------------------------------------------------------------------
input           clk;
input           reset;
input   [3:0]   t_type;
output  [1:0]   tx_coded;

// ----------------------------------------------------------------------------
// Internal signals/registers
// ----------------------------------------------------------------------------
reg     [1:0]   tx_coded;
reg     [1:0]   tx_coded_nxt;
reg     [3:0]   tx_state;
reg     [3:0]   tx_state_nxt;

// ----------------------------------------------------------------------------
// Parameters
// ----------------------------------------------------------------------------
parameter TX_INIT     = 4'b0000;
parameter TX_C        = 4'b1001;
parameter TX_S        = 4'b1010;
parameter TX_D        = 4'b0011;
parameter TX_T        = 4'b1100;
parameter TX_E        = 4'b0101;
parameter TX_LI       = 4'b0110;
parameter LBLOCK_T    = 2'b01;
parameter ENCODE      = 2'b00;
parameter EBLOCK_T    = 2'b10;

// ----------------------------------------------------------------------------
// Implementation
// ----------------------------------------------------------------------------
 // This is the Lock state machine of Fig 49-14 in IEEE 802.3ae C49
 always @(*) begin : fsm
  tx_state_nxt = tx_state;
  tx_coded_nxt = tx_coded;

  case (tx_state)
    TX_INIT :
      begin
        if (t_type == TX_E || t_type == TX_D || t_type == TX_T || t_type == TX_LI)
          begin
            tx_state_nxt = TX_E;
            tx_coded_nxt = EBLOCK_T;
          end
        else if (t_type == TX_C)
          begin
            tx_state_nxt = TX_C;
            tx_coded_nxt = ENCODE;
          end
        else if (t_type == TX_S)
          begin
            tx_state_nxt = TX_D;
            tx_coded_nxt = ENCODE;
          end
      end

    TX_C :
      begin
        if (t_type == TX_E || t_type == TX_D || t_type == TX_T)
          begin
            tx_state_nxt = TX_E;
            tx_coded_nxt = EBLOCK_T;
          end
        else if (t_type == TX_C)
          begin
            tx_state_nxt = TX_C;
            tx_coded_nxt = ENCODE;
          end
        else if (t_type == TX_S)
          begin
            tx_state_nxt = TX_D;
            tx_coded_nxt = ENCODE;
          end
        else if (t_type == TX_LI)
          begin
            tx_state_nxt = TX_LI;
            tx_coded_nxt = ENCODE;
          end
      end

    TX_D :
      begin
        if (t_type == TX_E || t_type == TX_C || t_type == TX_S || t_type == TX_LI)
          begin
            tx_state_nxt = TX_E;
            tx_coded_nxt = EBLOCK_T;
          end
        else if (t_type == TX_T)
          begin
            tx_state_nxt = TX_T;
            tx_coded_nxt = ENCODE;
          end
        else if (t_type == TX_D)
          begin
            tx_state_nxt = TX_D;
            tx_coded_nxt = ENCODE;
          end
      end

    TX_T :
      begin
        if (t_type == TX_E || t_type == TX_D || t_type == TX_T)
          begin
            tx_state_nxt = TX_E;
            tx_coded_nxt = EBLOCK_T;
          end
        else if (t_type == TX_S)
          begin
            tx_state_nxt = TX_D;
            tx_coded_nxt = ENCODE;
          end
        else if (t_type == TX_C)
          begin
            tx_state_nxt = TX_C;
            tx_coded_nxt = ENCODE;
          end
        else if (t_type == TX_LI)
          begin
            tx_state_nxt = TX_LI;
            tx_coded_nxt = ENCODE;
          end
      end

    TX_E :
      begin
        if (t_type == TX_E || t_type == TX_S)
          begin
            tx_state_nxt = TX_E;
            tx_coded_nxt = EBLOCK_T;
          end
        else if (t_type == TX_T)
          begin
            tx_state_nxt = TX_T;
            tx_coded_nxt = ENCODE;
          end
        else if (t_type == TX_D)
          begin
            tx_state_nxt = TX_D;
            tx_coded_nxt = ENCODE;
          end
        else if (t_type == TX_C)
          begin
            tx_state_nxt = TX_C;
            tx_coded_nxt = ENCODE;
          end
        else if (t_type == TX_LI)
          begin
            tx_state_nxt = TX_LI;
            tx_coded_nxt = ENCODE;
          end
      end

    TX_LI :
     begin
      if (t_type == TX_LI)
       begin
        tx_state_nxt = TX_LI;
        tx_coded_nxt = ENCODE;
       end
      else if (t_type == TX_C)
       begin
         tx_state_nxt = TX_C;
         tx_coded_nxt = ENCODE;
       end
      else if ((t_type == TX_E) || (t_type ==  TX_D) || (t_type == TX_S) || (t_type == TX_T))
       begin
         tx_state_nxt = TX_E;
         tx_coded_nxt = EBLOCK_T;
       end
     end

    default :
      begin
        tx_state_nxt = tx_state;
        tx_coded_nxt = tx_coded;
      end
  endcase
 end

 always @(posedge clk) begin : flops
   if (reset)
    begin
     tx_state <= TX_INIT;
     tx_coded <= LBLOCK_T;
    end
   else
    begin
     tx_state <= tx_state_nxt;
     tx_coded <= tx_coded_nxt;
    end
   end

endmodule
