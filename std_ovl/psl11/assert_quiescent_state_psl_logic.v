// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

//This file is included in assert_quiescent_state.vlib

`include "std_ovl_task.h"

  parameter assert_name = "ASSERT_QUIESCENT_STATE";

 `ifdef OVL_INIT_MSG
  initial
    ovl_init_msg_t; // Call the User Defined Init Message Routine
`endif

wire ovl_end_of_simulation_wire;
`ifdef OVL_END_OF_SIMULATION
assign ovl_end_of_simulation_wire = `OVL_END_OF_SIMULATION;
`else
assign ovl_end_of_simulation_wire = 1'b0;
`endif
  
`ifdef OVL_ASSERT_ON
 
 generate
   case (property_type)
     `OVL_ASSERT: begin: assert_checks
         assert_quiescent_state_assert #(
                       .width(width) )
                assert_quiescent_state_assert (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .state_expr(state_expr),
                       .check_value(check_value),
                       .sample_event(sample_event),
                       .ovl_end_of_simulation_wire (ovl_end_of_simulation_wire) );
                  end
     `OVL_ASSUME: begin: assume_checks
         assert_quiescent_state_assume #(
                       .width(width) )
                assert_quiescent_state_assume (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .state_expr(state_expr),
                       .check_value(check_value),
                       .sample_event(sample_event), 
                       .ovl_end_of_simulation_wire (ovl_end_of_simulation_wire) );
                  end
     `OVL_IGNORE: begin: ovl_ignore
                    //do nothing
                  end
     default: initial ovl_error_t("");
   endcase
 endgenerate

`endif

`endmodule //Required to pair up with already used "`module" in file assert_quiescent_state.vlib 

//Module to be replicated for assert checks
//This module is bound to a PSL vunits with assert checks
module assert_quiescent_state_assert (clk, reset_n, state_expr, check_value, sample_event, ovl_end_of_simulation_wire); 
       parameter width = 8;
       input clk, reset_n, sample_event; 
       input [width-1:0]  state_expr, check_value;
       input ovl_end_of_simulation_wire;
endmodule

//Module to be replicated for assume checks
//This module is bound to a PSL vunits with assume checks
module assert_quiescent_state_assume (clk, reset_n, state_expr, check_value, sample_event, ovl_end_of_simulation_wire);
       parameter width = 8;
       input clk, reset_n, sample_event; 
       input [width-1:0] state_expr, check_value;
       input ovl_end_of_simulation_wire;
endmodule

