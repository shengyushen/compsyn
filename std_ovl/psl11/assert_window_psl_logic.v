// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

//This file is included in assert_window.vlib

`include "std_ovl_task.h"

  parameter assert_name = "ASSERT_WINDOW";

 `ifdef OVL_INIT_MSG
  initial
    ovl_init_msg_t; // Call the User Defined Init Message Routine
`endif
  
`ifdef OVL_ASSERT_ON
 
 generate
   case (property_type)
     `OVL_ASSERT: begin: assert_checks
                   assert_window_assert
                   assert_window_assert (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .test_expr(test_expr),
                       .start_event(start_event),
                       .end_event(end_event));
                  end
     `OVL_ASSUME: begin: assume_checks
                   assert_window_assume
                   assert_window_assume (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .test_expr(test_expr),
                       .start_event(start_event),
                       .end_event(end_event));
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
          assert_window_cover
          assert_window_cover (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .test_expr(test_expr),
                       .start_event(start_event),
                       .end_event(end_event));
   end
 endgenerate
`endif

`endmodule //Required to pair up with already used "`module" in file assert_window.vlib 

//Module to be replicated for assert checks
//This module is bound to a PSL vunits with assert checks
module assert_window_assert (clk, reset_n, test_expr, start_event, end_event);
       input clk, reset_n, test_expr, start_event, end_event; 
endmodule

//Module to be replicated for assume checks
//This module is bound to a PSL vunits with assume checks
module assert_window_assume (clk, reset_n, test_expr, start_event, end_event);
       input clk, reset_n, test_expr, start_event, end_event;
endmodule

//Module to be replicated for cover properties
//This module is bound to a PSL vunit with cover properties
module assert_window_cover (clk, reset_n, test_expr, start_event, end_event);
       input clk, reset_n, test_expr, start_event, end_event;
endmodule
