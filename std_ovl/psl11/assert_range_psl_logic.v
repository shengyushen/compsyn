// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

//This file is included in assert_range.vlib

`include "std_ovl_task.h"

  parameter assert_name = "ASSERT_RANGE";

 `ifdef OVL_INIT_MSG
  initial
    ovl_init_msg_t; // Call the User Defined Init Message Routine
`endif
  
`ifdef OVL_ASSERT_ON
 
 generate
   case (property_type)
     `OVL_ASSERT: begin: assert_checks
                   assert_range_assert #(
                       .width(width),
                       .min(min),
                       .max(max))
                   assert_range_assert (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .test_expr(test_expr));
                  end
     `OVL_ASSUME: begin: assume_checks
                   assert_range_assume #(
                       .width(width),
                       .min(min),
                       .max(max))
                   assert_range_assert (
                       .clk(clk),
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

`ifdef OVL_COVER_ON
 generate
  if (coverage_level != `OVL_COVER_NONE)
   begin: cover_checks
                assert_range_cover #(
                       .width(width),
                       .min(min),
                       .max(max))
                assert_range_cover (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .test_expr(test_expr));
   end
 endgenerate
`endif

`endmodule //Required to pair up with already used "`module" in file assert_range.vlib 

//Module to be replicated for assert checks
//This module is bound to a PSL vunits with assert checks
module assert_range_assert (clk, reset_n, test_expr);
       parameter width = 8;
       parameter min = 1;
       parameter max = 2;
       input clk, reset_n;
       input [width-1:0] test_expr;
endmodule

//Module to be replicated for assume checks
//This module is bound to a PSL vunits with assume checks
module assert_range_assume (clk, reset_n, test_expr);
       parameter width = 8;
       parameter min = 1;
       parameter max = 2;
       input clk, reset_n;
       input [width-1:0] test_expr;
endmodule

//Module to be replicated for cover properties
//This module is bound to a PSL vunit with cover properties
module assert_range_cover (clk, reset_n, test_expr);
       parameter width = 8;
       parameter min = 1;
       parameter max = 2;
       input clk, reset_n;
       input [width-1:0] test_expr;
endmodule
