// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

//This file is included in file assert_never.vlib

  parameter assert_name = "ASSERT_NEVER";

`include "std_ovl_task.h"

`ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
`endif

`ifdef OVL_ASSERT_ON

  wire xzcheck_enable;
                                                                                                                                 
`ifdef OVL_XCHECK_OFF
     assign xzcheck_enable = 1'b0;
`else
     assign xzcheck_enable = 1'b1;
`endif

 generate
   case (property_type)
     `OVL_ASSERT: begin: assert_checks
                    assert_never_assert
                    assert_never_assert (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .xzcheck_enable(xzcheck_enable),
                       .test_expr(test_expr));
                  end
     `OVL_ASSUME: begin: assume_checks
                    assert_never_assume
                    assert_never_assume (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .xzcheck_enable(xzcheck_enable),
                       .test_expr(test_expr));
                  end
     `OVL_IGNORE: begin: ovl_ignore
                    //do nothing
                  end
     default: initial ovl_error_t("");
   endcase
 endgenerate
`endif

`endmodule //Required to pair up with already used "`module" in file assert_never.vlib 

//Module to be replicated for assert checks
//This module is bound to the PSL vunits with assert checks
module assert_never_assert (clk, reset_n, test_expr, xzcheck_enable);
       input clk, reset_n, test_expr, xzcheck_enable;
endmodule

//Module to be replicated for assume checks
//This module is bound to a PSL vunits with assume checks
module assert_never_assume (clk, reset_n, test_expr, xzcheck_enable);
       input clk, reset_n, test_expr, xzcheck_enable;
endmodule
