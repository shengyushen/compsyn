// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

//This file is included in assert_unchange.vlib

`include "std_ovl_task.h"

  parameter assert_name = "ASSERT_UNCHANGE";

  wire ignore_new_start = (action_on_new_start == `OVL_IGNORE_NEW_START);
  wire reset_on_new_start = (action_on_new_start == `OVL_RESET_ON_NEW_START);
  wire error_on_new_start = (action_on_new_start == `OVL_ERROR_ON_NEW_START);
 
 `ifdef OVL_INIT_MSG
  initial
    ovl_init_msg_t; // Call the User Defined Init Message Routine
`endif
  
  initial
    begin
     if ((num_cks <= 0) || ~(ignore_new_start || reset_on_new_start || error_on_new_start))
       ovl_error_t("Illegal value set for parameter action_on_new_start or parameter num_cks");
    end

  reg window = 0;
  integer i = 0;
                                                                                                                                     
  always @ (posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0) begin
      if (!window && start_event == 1'b1) begin
        window <= 1'b1;
        i <= num_cks;
      end
      else if (window) begin
        if (i == 1 && (!reset_on_new_start || !start_event))
          window <= 1'b0;
                                                                                                                                     
        if (reset_on_new_start && start_event)
          i <= num_cks;
        else if (i != 1)
          i <= i - 1;
      end // if (window)
    end
    else begin
      window <= 1'b0;
      i <= 0;
    end
  end

`ifdef OVL_ASSERT_ON
 
 generate
   case (property_type)
     `OVL_ASSERT: begin: assert_checks
         assert_unchange_assert #(
                       .width(width),
                       .num_cks(num_cks))
                assert_unchange_assert (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .start_event(start_event),
                       .test_expr(test_expr),
                       .window(window),
                       .ignore_new_start(ignore_new_start),
                       .reset_on_new_start(reset_on_new_start),
                       .error_on_new_start(error_on_new_start));
                  end
     `OVL_ASSUME: begin: assume_checks
         assert_unchange_assume #(
                       .width(width),
                       .num_cks(num_cks))
                assert_unchange_assume (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .start_event(start_event),
                       .test_expr(test_expr),
                       .window(window),
                       .ignore_new_start(ignore_new_start),
                       .reset_on_new_start(reset_on_new_start),
                       .error_on_new_start(error_on_new_start)); 
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
              assert_unchange_cover
                assert_unchange_cover (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .start_event(start_event),
                       .window(window),
                       .reset_on_new_start(reset_on_new_start),
                       .window_close(i == 1)); // i == 1 means window is closing
   end
 endgenerate
`endif

`endmodule //Required to pair up with already used "`module" in file assert_unchange.vlib 

//Module to be replicated for assert checks
//This module is bound to a PSL vunits with assert checks
module assert_unchange_assert (clk, reset_n, start_event, test_expr, window,
                            ignore_new_start, reset_on_new_start, error_on_new_start);
       parameter width = 8;
       parameter num_cks = 2;
       input clk, reset_n, start_event, window, ignore_new_start, reset_on_new_start, error_on_new_start;
       input [width-1:0] test_expr;
endmodule

//Module to be replicated for assume checks
//This module is bound to a PSL vunits with assume checks
module assert_unchange_assume (clk, reset_n, start_event, test_expr, window,
                            ignore_new_start, reset_on_new_start, error_on_new_start);
       parameter width = 8;
       parameter num_cks = 2;
       input clk, reset_n, start_event, window, ignore_new_start, reset_on_new_start, error_on_new_start;
       input [width-1:0] test_expr;
endmodule


//Module to be replicated for cover properties
//This module is bound to a PSL vunit with cover properties
module assert_unchange_cover (clk, reset_n, start_event, window, reset_on_new_start, window_close);
       input clk, reset_n, start_event, window, reset_on_new_start, window_close;
endmodule
