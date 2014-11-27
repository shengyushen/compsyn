// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

//This file is included in file assert_proposition.vlib

  parameter assert_name = "ASSERT_PROPOSITION";

`include "std_ovl_task.h"

`ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
`endif

`ifdef OVL_ASSERT_ON

 generate
   case (property_type)
     `OVL_ASSERT: begin  : assert_checks
                    assert_proposition_assert
                    assert_proposition_assert (
                       .reset_n(`OVL_RESET_SIGNAL),
                       .test_expr(test_expr));
                  end
     `OVL_IGNORE: begin: ovl_ignore
                    //do nothing
                  end
     default: initial ovl_error_t("");
   endcase
 endgenerate
`endif

`endmodule //Required to pair up with already used "`module" in file assert_proposition.vlib 

//Module to be replicated for assert checks
//This module is bound to the PSL vunits with assert checks
module assert_proposition_assert (reset_n, test_expr);
       input reset_n, test_expr;
endmodule

