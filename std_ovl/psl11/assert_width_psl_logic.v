// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

//This file is included in assert_width.vlib

`include "std_ovl_task.h"

  parameter assert_name = "ASSERT_WIDTH";

 `ifdef OVL_INIT_MSG
  initial
    ovl_init_msg_t; // Call the User Defined Init Message Routine
`endif

 initial 
  begin
    if ((min_cks > 0) && (max_cks > 0))
     begin
      if (min_cks > max_cks) 
       ovl_error_t("Illegal parameter values set where min_cks > max_cks");
     end
  end
  
`ifdef OVL_ASSERT_ON
 
 generate
   case (property_type)
     `OVL_ASSERT: begin: assert_checks
                   assert_width_assert #(
                       .min_cks(min_cks),
                       .max_cks(max_cks))
                   assert_width_assert (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .test_expr(test_expr));
                  end
     `OVL_ASSUME: begin: assume_checks
                   assert_width_assume #(
                       .min_cks(min_cks),
                       .max_cks(max_cks))
                   assert_width_assume (
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
          assert_width_cover #(
                       .min_cks(min_cks),
                       .max_cks(max_cks))
          assert_width_cover (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .test_expr(test_expr));
   end
 endgenerate
`endif

`endmodule //Required to pair up with already used "`module" in file assert_width.vlib 

//Module to be replicated for assert checks
//This module is bound to a PSL vunits with assert checks
module assert_width_assert (clk, reset_n, test_expr);
       parameter min_cks = 1;
       parameter max_cks = 2;
       input clk, reset_n, test_expr; 
endmodule

//Module to be replicated for assume checks
//This module is bound to a PSL vunits with assume checks
module assert_width_assume (clk, reset_n, test_expr);
       parameter min_cks = 1;
       parameter max_cks = 2;
       input clk, reset_n, test_expr;
endmodule

//Module to be replicated for cover properties
//This module is bound to a PSL vunit with cover properties
module assert_width_cover (clk, reset_n, test_expr);
       parameter min_cks = 1;
       parameter max_cks = 2;
       input clk, reset_n, test_expr;
endmodule
