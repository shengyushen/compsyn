// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

//This file is included in file assert_never_unknown.vlib

  parameter assert_name = "ASSERT_NEVER_UNKNOWN";

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
                    assert_never_unknown_assert #(
                       .width(width))
                    assert_never_unknown_assert (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .qualifier(qualifier),
                       .test_expr(test_expr),
                       .xzcheck_enable(xzcheck_enable));
                  end
     `OVL_ASSUME: begin: assume_checks
                    assert_never_unknown_assume #(
                       .width(width))
                    assert_never_unknown_assume (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .qualifier(qualifier),
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

`ifdef OVL_COVER_ON
 generate
  if (coverage_level != `OVL_COVER_NONE)
   begin: cover_checks
                assert_never_unknown_cover #(
                       .width(width))
                assert_never_unknown_cover (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .qualifier(qualifier),
                       .test_expr(test_expr));
   end
 endgenerate
`endif

`endmodule //Required to pair up with already used "`module" in file assert_never.vlib 

//Module to be replicated for assert checks
//This module is bound to the PSL vunits with assert checks
module assert_never_unknown_assert (clk, reset_n, qualifier, test_expr, xzcheck_enable);
       parameter width = 8;
       input clk, reset_n, qualifier, xzcheck_enable;
       input [width-1:0] test_expr;
endmodule

//Module to be replicated for assume checks
//This module is bound to a PSL vunits with assume checks
module assert_never_unknown_assume (clk, reset_n, qualifier, test_expr, xzcheck_enable);
       parameter width = 8;
       input clk, reset_n, qualifier, xzcheck_enable;
       input [width-1:0] test_expr;
endmodule

//Module to be replicated for cover checks
//This module is bound to a PSL vunits with cover checks
module assert_never_unknown_cover (clk, reset_n, qualifier, test_expr);
       parameter width = 8;
       input clk, reset_n, qualifier;
       input [width-1:0] test_expr;
endmodule
