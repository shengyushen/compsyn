// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  parameter CHANGE_START = 1'b0;
  parameter CHANGE_CHECK = 1'b1;

  reg r_change;
  reg [width-1:0] r_test_expr;
  reg r_state;
  integer i;

  initial begin
    if (~((action_on_new_start == `OVL_IGNORE_NEW_START) ||
          (action_on_new_start == `OVL_RESET_ON_NEW_START) ||
          (action_on_new_start == `OVL_ERROR_ON_NEW_START))) begin
      ovl_error_t("Illegal value set for parameter action_on_new_start");
    end
    r_state=CHANGE_START;
    r_change=1'b0;
  end

  parameter assert_name = "ASSERT_CHANGE";

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
          CHANGE_START: begin

            if (start_event == 1'b1) begin
              r_change <= 1'b0;
              r_state <= CHANGE_CHECK;
              r_test_expr <= test_expr;
              i <= num_cks;

              `ifdef OVL_COVER_ON
              if (coverage_level != `OVL_COVER_NONE) begin
                ovl_cover_t("window_open covered");
              end
              `endif // OVL_COVER_ON
            end

          end
          CHANGE_CHECK: begin

              // Count clock ticks
              if (start_event == 1'b1) begin
                if (action_on_new_start == `OVL_IGNORE_NEW_START && i > 0)
                  i <= i-1;
                else if (action_on_new_start == `OVL_RESET_ON_NEW_START) begin
                  r_change <= 1'b0;
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
                  ovl_error_t("Start event evaluated TRUE before test expression changed");
                  `endif // OVL_ASSERT_ON
                end 
              end
              else if (i > 0)
                i <= i-1;

              if (r_test_expr != test_expr && !(start_event == 1'b1 &&
                          action_on_new_start == `OVL_RESET_ON_NEW_START)) begin
                r_change <= 1'b1;
              end

              // go to start state on last check
              if (i == 1 && !(start_event == 1'b1 &&
                          action_on_new_start == `OVL_RESET_ON_NEW_START)) begin
                r_state <= CHANGE_START;

                `ifdef OVL_COVER_ON
                if (coverage_level != `OVL_COVER_NONE) begin
                  ovl_cover_t("window_close covered");
                end
                `endif // OVL_COVER_ON

                // Check that the property is true
                `ifdef OVL_ASSERT_ON
                if ((r_change != 1'b1) && (r_test_expr == test_expr)) begin
                  ovl_error_t("Test expression did not change value within num_cks cycles after start event");
                end
                `endif // OVL_ASSERT_ON
              end
              r_test_expr <= test_expr;

          end
        endcase
      end
      else begin
         r_state <= CHANGE_START;
         r_change <= 1'b0;
      end
  end // always            

`endif // OVL_SHARED_CODE
