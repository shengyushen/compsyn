// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

// local paramaters used as defines
  parameter TIME_START = 1'b0;
  parameter TIME_CHECK = 1'b1;

  reg [31:0] i;

  reg r_state;
  initial begin
    if (~((action_on_new_start == `OVL_IGNORE_NEW_START) ||
          (action_on_new_start == `OVL_RESET_ON_NEW_START) ||
          (action_on_new_start == `OVL_ERROR_ON_NEW_START))) begin
      ovl_error_t("Illegal value set for parameter action_on_new_start");
    end
    r_state=TIME_START;
  end

  parameter assert_name = "ASSERT_TIME";

  `include "std_ovl_task.h"

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

`ifdef OVL_SHARED_CODE

  always @(posedge clk) begin
    `ifdef OVL_GLOBAL_RESET
      if (`OVL_GLOBAL_RESET != 1'b0) begin
    `else      
      if (reset_n != 0) begin  // active low reset
    `endif
        case (r_state)
          TIME_START: begin
            if (start_event == 1'b1) begin
              r_state <= TIME_CHECK;
              i <= num_cks;

              `ifdef OVL_COVER_ON
              if (coverage_level != `OVL_COVER_NONE) begin
                ovl_cover_t("window_open covered");
              end
              `endif // OVL_COVER_ON
            end
          end
          TIME_CHECK: begin
              // Count clock ticks
              if (start_event == 1'b1) begin
                if (action_on_new_start == `OVL_IGNORE_NEW_START)
                  i <= i-1;
                else if (action_on_new_start == `OVL_RESET_ON_NEW_START) begin
                  i <= num_cks;
                  `ifdef OVL_COVER_ON
                  if (coverage_level != `OVL_COVER_NONE) begin
                    if (action_on_new_start == `OVL_RESET_ON_NEW_START) begin
                      ovl_cover_t("window_resets covered");
                    end
                  end
                  `endif // OVL_COVER_ON
                end
                else if (action_on_new_start == `OVL_ERROR_ON_NEW_START) begin
                  i <= i-1;
                  `ifdef OVL_ASSERT_ON
                  ovl_error_t("Illegal start event which has reoccured before completion of current window");
                  `endif // OVL_ASSERT_ON
                end 
              end
              else
                i <= i-1;

              // Check that the property is true
              `ifdef OVL_ASSERT_ON
              if (test_expr != 1'b1 &&
                  !(start_event == 1'b1 &&
                    action_on_new_start == `OVL_RESET_ON_NEW_START)) begin
                ovl_error_t("Test expression is not TRUE within specified num_cks cycles from the start_event");
              end
              `endif // OVL_ASSERT_ON

              // go to start state on last time check
              // NOTE: i == 0 at end of current simulation 
              // timeframe due to non-blocking assignment!
              // Hence, check  i == 1.
              if (i == 1 && !(start_event == 1'b1 && 
                              action_on_new_start == `OVL_RESET_ON_NEW_START)) begin
                r_state <= TIME_START;
                `ifdef OVL_COVER_ON
                if (coverage_level != `OVL_COVER_NONE) begin
                  ovl_cover_t("window_close covered");
                end
                `endif // OVL_COVER_ON
              end
          end
        endcase
      end
      else begin
        r_state <= TIME_START;
      end
  end // always

`endif // OVL_SHARED_CODE
