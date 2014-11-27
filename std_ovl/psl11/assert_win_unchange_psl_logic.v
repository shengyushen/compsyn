// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

//This file is included in assert_win_unchange.vlib

`include "std_ovl_task.h"

  parameter assert_name = "ASSERT_WIN_UNCHANGE";

 `ifdef OVL_INIT_MSG
  initial
    ovl_init_msg_t; // Call the User Defined Init Message Routine
`endif
  
  reg window = 0;
  
  always @ (posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0) begin
      if (!window && start_event == 1'b1)
        window <= 1'b1;
      else if (window && end_event == 1'b1)
        window <= 1'b0;
    end
    else begin
      window <= 1'b0;
    end
  end

`ifdef OVL_ASSERT_ON
 
 generate
   case (property_type)
     `OVL_ASSERT: begin: assert_checks
         assert_win_unchange_assert #(
                       .width(width))
                assert_win_unchange_assert (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .start_event(start_event),
                       .end_event(end_event),
                       .test_expr(test_expr),
                       .window(window));
                  end
     `OVL_ASSUME: begin: assume_checks
         assert_win_unchange_assume #(
                       .width(width))
                assert_win_unchange_assume (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .start_event(start_event),
                       .end_event(end_event),
                       .test_expr(test_expr),
                       .window(window));
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
              assert_win_unchange_cover
                assert_win_unchange_cover (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .start_event(start_event),
                       .end_event(end_event),
                       .window(window));
   end
 endgenerate
`endif

`endmodule //Required to pair up with already used "`module" in file assert_win_unchange.vlib 

//Module to be replicated for assert checks
//This module is bound to a PSL vunits with assert checks
module assert_win_unchange_assert (clk, reset_n, start_event, end_event, test_expr, window);
       parameter width = 8;
       input clk, reset_n, start_event, end_event, window;
       input [width-1:0] test_expr;
endmodule

//Module to be replicated for assume checks
//This module is bound to a PSL vunits with assume checks
module assert_win_unchange_assume (clk, reset_n, start_event, end_event, test_expr, window);
       parameter width = 8;
       input clk, reset_n, start_event, end_event, window;
       input [width-1:0] test_expr;
endmodule

//Module to be replicated for cover properties
//This module is bound to a PSL vunit with cover properties
module assert_win_unchange_cover (clk, reset_n, start_event, end_event, window);
       input clk, reset_n, start_event, end_event, window;
endmodule
