// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

//This file is included in file assert_always_on_edge.vlib

  parameter assert_name = "ASSERT_ALWAYS_ON_EDGE";

`include "std_ovl_task.h"

`ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
`endif

`ifdef OVL_ASSERT_ON

 wire noedge_type = (edge_type == `OVL_NOEDGE) ? 1'b1 : 1'b0;
 wire posedge_type = (edge_type == `OVL_POSEDGE) ? 1'b1 : 1'b0;
 wire negedge_type = (edge_type == `OVL_NEGEDGE) ? 1'b1 : 1'b0;
 wire anyedge_type = (edge_type == `OVL_ANYEDGE) ? 1'b1 : 1'b0;

 generate
   case (property_type)
     `OVL_ASSERT: begin: assert_checks
                    assert_always_on_edge_assert
                    assert_always_on_edge_assert (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .test_expr(test_expr),
                       .sampling_event(sampling_event),
                       .noedge_type(noedge_type),
                       .posedge_type(posedge_type),
                       .negedge_type(negedge_type),
                       .anyedge_type(anyedge_type));
                  end
     `OVL_ASSUME: begin: assume_checks
                    assert_always_on_edge_assume
                    assert_always_on_edge_assume (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .test_expr(test_expr),
                       .sampling_event(sampling_event),
                       .noedge_type(noedge_type),
                       .posedge_type(posedge_type),
                       .negedge_type(negedge_type),
                       .anyedge_type(anyedge_type));
                  end
      `OVL_IGNORE: begin: ovl_ignore
                     //do nothing
                   end
      default: initial ovl_error_t("");
   endcase
 endgenerate
`endif

`endmodule //Required to pair up with already used "`module" in file assert_always_on_edge.vlib 

//Module to be replicated for assert checks
//This module is bound to the PSL vunits with assert checks
module assert_always_on_edge_assert (clk, reset_n, test_expr, sampling_event, noedge_type, posedge_type, negedge_type, anyedge_type);
       input clk, reset_n, test_expr, sampling_event, noedge_type, posedge_type, negedge_type, anyedge_type;
endmodule

//Module to be replicated for assume checks
//This module is bound to a PSL vunits with assume checks
module assert_always_on_edge_assume (clk, reset_n, test_expr, sampling_event, noedge_type, posedge_type, negedge_type, anyedge_type);
       input clk, reset_n, test_expr, sampling_event, noedge_type, posedge_type, negedge_type, anyedge_type;
endmodule
