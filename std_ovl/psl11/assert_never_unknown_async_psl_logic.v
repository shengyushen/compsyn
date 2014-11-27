// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

//This file is included in file assert_never_unknown_async.vlib

  parameter assert_name = "ASSERT_NEVER_UNKNOWN_ASYNC";

`include "std_ovl_task.h"

`ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
`endif

 wire xzcheck_enable;
                                                                                                                                          
`ifdef OVL_XCHECK_OFF
     assign xzcheck_enable = 1'b0;
`else
     assign xzcheck_enable = 1'b1;
`endif

`ifdef OVL_ASSERT_ON

 generate
   case (property_type)
     `OVL_ASSERT: begin: assert_checks
                    assert_never_unknown_async_assert #(
                       .width(width))
                    assert_never_unknown_async_assert (
                       .reset_n(`OVL_RESET_SIGNAL),
                       .test_expr(test_expr),
                       .xzcheck_enable(xzcheck_enable));
                  end
     `OVL_IGNORE: begin: ovl_ignore
                    //do nothing
                  end
     default: initial ovl_error_t("");
   endcase
 endgenerate
`endif

`endmodule //Required to pair up with already used "`module" in file assert_never_unknown_async.vlib 

//Module to be replicated for assert checks
//This module is bound to the PSL vunits with assert checks
module assert_never_unknown_async_assert (reset_n, test_expr, xzcheck_enable);
       parameter width = 8;
       input reset_n, xzcheck_enable;
       input [width-1:0] test_expr;
endmodule
