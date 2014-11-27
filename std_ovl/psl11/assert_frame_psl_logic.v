// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

//This file is included in assert_frame.vlib

`include "std_ovl_task.h"

  parameter assert_name = "ASSERT_FRAME";

  integer ii;
  reg win;
  reg r_start_event;

  wire ignore_new_start = (action_on_new_start == `OVL_IGNORE_NEW_START);
  wire reset_on_new_start = (action_on_new_start == `OVL_RESET_ON_NEW_START);
  wire error_on_new_start = (action_on_new_start == `OVL_ERROR_ON_NEW_START);
 
 `ifdef OVL_INIT_MSG
  initial
    ovl_init_msg_t; // Call the User Defined Init Message Routine
`endif
  
  initial
    begin
     if (~(ignore_new_start || reset_on_new_start || error_on_new_start))
       ovl_error_t("Illegal value set for parameter action_on_new_start");
     if (min_cks > max_cks)
       ovl_error_t("Illegal parameter values set where min_cks > max_cks");
    end
                                                                                                                 
  always @(posedge clk)
   begin
    if (`OVL_RESET_SIGNAL != 1'b1)
     r_start_event <= 0;
    else
     r_start_event <= start_event;
   end
                                                                                                                 
  always @(posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b1) begin
      ii <= 0;
      win <= 0;
    end
    else begin
      if (max_cks > 0) begin
        case (win)
          0: begin
            if (r_start_event == 1'b0 && start_event == 1'b1 &&
                (test_expr != 1'b1)) begin
              win <= 1'b1;
              ii <= max_cks;
            end
          end
          1: begin
            if (r_start_event == 1'b0 && start_event == 1'b1 &&
                action_on_new_start == `OVL_RESET_ON_NEW_START &&
                test_expr != 1'b1) begin
              ii <= max_cks;
            end
            else if (ii <= 1 || test_expr == 1'b1) begin
              win <= 1'b0;
            end
            else begin
              ii <= ii -1;
            end
          end
        endcase
      end
      else if (min_cks > 0) begin
        case (win)
          0: begin
            if (r_start_event == 1'b0 && start_event == 1'b1 &&
                (test_expr != 1'b1)) begin
              win <= 1'b1;
              ii <= min_cks;
            end
          end
          1: begin
            if (r_start_event == 1'b0 && start_event == 1'b1 &&
                action_on_new_start == `OVL_RESET_ON_NEW_START &&
                test_expr != 1'b1) begin
              ii <= min_cks;
            end
            else if (ii <= 1 || test_expr == 1'b1) begin
              win <= 1'b0;
            end
            else begin
              ii <= ii -1;
            end
          end
        endcase
      end
    end
  end

 
`ifdef OVL_ASSERT_ON
 
 generate
   case (property_type)
     `OVL_ASSERT: begin: assert_checks
         assert_frame_assert #(
                       .min_cks(min_cks),
                       .max_cks(max_cks))
                assert_frame_assert (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .start_event(start_event),
                       .test_expr(test_expr),
                       .win(win),
                       .ignore_new_start(ignore_new_start),
                       .reset_on_new_start(reset_on_new_start),
                       .error_on_new_start(error_on_new_start));
                  end
     `OVL_ASSUME: begin: assume_checks
         assert_frame_assume #(
                       .min_cks(min_cks),
                       .max_cks(max_cks))
                assert_frame_assume (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .start_event(start_event),
                       .test_expr(test_expr),
                       .win(win),
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
          assert_frame_cover
                assert_frame_cover (
                       .clk(clk),
                       .reset_n(`OVL_RESET_SIGNAL),
                       .start_event(start_event));
   end
 endgenerate
`endif

`endmodule //Required to pair up with already used "`module" in file assert_frame.vlib 

//Module to be replicated for assert checks
//This module is bound to a PSL vunits with assert checks
module assert_frame_assert (clk, reset_n, start_event, test_expr, win,
                            ignore_new_start, reset_on_new_start, error_on_new_start);
       parameter min_cks = 1;
       parameter max_cks = 2;
       input clk, reset_n, start_event, test_expr, win, 
             ignore_new_start, reset_on_new_start, error_on_new_start;
endmodule

//Module to be replicated for assume checks
//This module is bound to a PSL vunits with assume checks
module assert_frame_assume (clk, reset_n, start_event, test_expr, win,
                            ignore_new_start, reset_on_new_start, error_on_new_start);
       parameter min_cks = 1;
       parameter max_cks = 2;
       input clk, reset_n, start_event, test_expr, win,
             ignore_new_start, reset_on_new_start, error_on_new_start;
endmodule


//Module to be replicated for cover properties
//This module is bound to a PSL vunit with cover properties
module assert_frame_cover (clk, reset_n, start_event);
       input clk, reset_n, start_event;
endmodule
