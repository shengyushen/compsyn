// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

//This file is included in assert_implication.vlib

`include "std_ovl_task.h"

  parameter assert_name = "ASSERT_IMPLICATION";

 `ifdef OVL_INIT_MSG
  initial
    ovl_init_msg_t; // Call the User Defined Init Message Routine
`endif
  
`ifdef OVL_ASSERT_ON
 
 generate
   case (property_type)
     `OVL_ASSERT: begin: assert_checks
                   assert_implication_assert
                   assert_implication_assert (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .antecedent_expr(antecedent_expr),
                       .consequent_expr(consequent_expr));
                  end
     `OVL_ASSUME: begin: assume_checks
                   assert_implication_assume
                   assert_implication_assume (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .antecedent_expr(antecedent_expr),
                       .consequent_expr(consequent_expr));
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
          assert_implication_cover
          assert_implication_cover (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .antecedent_expr(antecedent_expr));
   end
 endgenerate
`endif

`endmodule //Required to pair up with already used "`module" in file assert_implication.vlib 

//Module to be replicated for assert checks
//This module is bound to a PSL vunits with assert checks
module assert_implication_assert (clk, reset_n, antecedent_expr, consequent_expr);
       input clk, reset_n, antecedent_expr, consequent_expr; 
endmodule

//Module to be replicated for assume checks
//This module is bound to a PSL vunits with assume checks
module assert_implication_assume (clk, reset_n, antecedent_expr, consequent_expr);
       input clk, reset_n, antecedent_expr, consequent_expr;
endmodule

//Module to be replicated for cover properties
//This module is bound to a PSL vunit with cover properties
module assert_implication_cover (clk, reset_n, antecedent_expr);
       input clk, reset_n, antecedent_expr;
endmodule
