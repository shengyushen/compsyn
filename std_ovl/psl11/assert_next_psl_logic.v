// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

//This file is included in assert_next.vlib

`include "std_ovl_task.h"

  parameter assert_name = "ASSERT_NEXT";

 `ifdef OVL_INIT_MSG
  initial
    ovl_init_msg_t; // Call the User Defined Init Message Routine
`endif

 initial begin
    if (num_cks <= 0) begin
      ovl_error_t("Illegal value for parameter num_cks which must be set to value greater than 0");
    end
  end

  integer i = 0;
  
  always @ (posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0) begin
      if (start_event == 1'b1) begin
        i <= num_cks;
      end
      else if (i != 1) begin
        i <= i - 1;
      end
    end
    else begin
      i <= 0;
    end
  end
  
`ifdef OVL_ASSERT_ON
 
 generate
   case (property_type)
     `OVL_ASSERT: begin: assert_checks
                   assert_next_assert #(
                       .num_cks(num_cks),
                       .check_overlapping(check_overlapping),
                       .check_missing_start(check_missing_start))
                   assert_next_assert (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .test_expr(test_expr),
                       .start_event(start_event),
                       .no_overlapping(i <= 0));
                  end
     `OVL_ASSUME: begin: assume_checks
                   assert_next_assume #(
                       .num_cks(num_cks),
                       .check_overlapping(check_overlapping),
                       .check_missing_start(check_missing_start))
                   assert_next_assume (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .test_expr(test_expr),
                       .start_event(start_event),
                       .no_overlapping(i <= 0));
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
          assert_next_cover
          assert_next_cover (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .test_expr(test_expr),
                       .start_event(start_event),
                       .no_overlapping(i <= 0));
   end
 endgenerate
`endif

`endmodule //Required to pair up with already used "`module" in file assert_next.vlib 

//Module to be replicated for assert checks
//This module is bound to a PSL vunits with assert checks
module assert_next_assert (clk, reset_n, test_expr, start_event, no_overlapping);
       parameter num_cks = 1;
       parameter check_overlapping = 1;
       parameter check_missing_start = 1;
       input clk, reset_n, test_expr, start_event, no_overlapping; 
endmodule

//Module to be replicated for assume checks
//This module is bound to a PSL vunits with assume checks
module assert_next_assume (clk, reset_n, test_expr, start_event, no_overlapping);
       parameter num_cks = 1;
       parameter check_overlapping = 1;
       parameter check_missing_start = 1;
       input clk, reset_n, test_expr, start_event, no_overlapping;
endmodule

//Module to be replicated for cover properties
//This module is bound to a PSL vunit with cover properties
module assert_next_cover (clk, reset_n, test_expr, start_event, no_overlapping);
       input clk, reset_n, test_expr, start_event, no_overlapping;
endmodule
