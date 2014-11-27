// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

//This file is included in assert_no_transition.vlib

`include "std_ovl_task.h"

  parameter assert_name = "ASSERT_TRANSITION";

 `ifdef OVL_INIT_MSG
  initial
    ovl_init_msg_t; // Call the User Defined Init Message Routine
`endif
  
`ifdef OVL_ASSERT_ON
 
 generate
   case (property_type)
     `OVL_ASSERT: begin: assert_checks
                   assert_no_transition_assert #(
                       .width(width))
                   assert_no_transition_assert (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .test_expr(test_expr),
                       .start_state(start_state),
                       .next_state(next_state));
                  end
     `OVL_ASSUME: begin: assume_checks
                   assert_no_transition_assume #(
                       .width(width))
                   assert_no_transition_assume (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .test_expr(test_expr),
                       .start_state(start_state),
                       .next_state(next_state));
                  end
     `OVL_IGNORE: begin: ovl_ignore
                    //do nothing
                  end
     default: initial ovl_error_t("");
   endcase
 endgenerate

`endif

`ifdef OVL_COVER_ON
 generate
  if (coverage_level != `OVL_COVER_NONE)
   begin: cover_checks
          assert_no_transition_cover #(
                       .width(width))
          assert_no_transition_cover (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .test_expr(test_expr),
                       .start_state(start_state));
   end
 endgenerate
`endif

`endmodule //Required to pair up with already used "`module" in file assert_no_transition.vlib 

//Module to be replicated for assert checks
//This module is bound to a PSL vunits with assert checks
module assert_no_transition_assert (clk, reset_n, test_expr, start_state, next_state);
       parameter width = 1;
       input clk, reset_n;
       input [width-1:0] test_expr, start_state, next_state;
endmodule

//Module to be replicated for assume checks
//This module is bound to a PSL vunits with assume checks
module assert_no_transition_assume (clk, reset_n, test_expr, start_state, next_state);
       parameter width = 1;
       input clk, reset_n;
       input [width-1:0] test_expr, start_state, next_state;
endmodule

//Module to be replicated for cover properties
//This module is bound to a PSL vunit with cover properties
module assert_no_transition_cover (clk, reset_n, test_expr, start_state);
       parameter width = 1; 
       input clk, reset_n;
       input [width-1:0] test_expr, start_state;
endmodule
