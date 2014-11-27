// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  reg r_change;
  reg [width-1:0] r_test_expr;
  reg r_state;

  parameter WIN_CHANGE_START = 1'b0;
  parameter WIN_CHANGE_CHECK = 1'b1;

  initial begin
    r_state=WIN_CHANGE_START;
    r_change=1'b0;
  end

  parameter assert_name = "ASSERT_WIN_CHANGE";

  `include "std_ovl_task.h"

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

`ifdef OVL_SHARED_CODE

  always @(posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0) begin
      case (r_state)
        WIN_CHANGE_START: begin

          if (start_event == 1'b1) begin
            r_change <= 1'b0;
            r_state <= WIN_CHANGE_CHECK;
            r_test_expr <= test_expr;

            `ifdef OVL_COVER_ON
            if (coverage_level != `OVL_COVER_NONE) begin
              ovl_cover_t("window_open covered");
            end
            `endif // OVL_COVER_ON
          end

        end
        WIN_CHANGE_CHECK: begin

            if (r_test_expr != test_expr) begin
              r_change <= 1'b1;
            end

            // go to start state on last check
            if (end_event == 1'b1) begin
              r_state <= WIN_CHANGE_START;

              `ifdef OVL_COVER_ON
              if (coverage_level != `OVL_COVER_NONE) begin
                ovl_cover_t("window covered");
              end
              `endif // OVL_COVER_ON

              // Check that the property is true
              `ifdef OVL_ASSERT_ON
              if ((r_change != 1'b1) && (r_test_expr == test_expr)) begin
                ovl_error_t("Test expression has not changed value before window is closed");
              end
              `endif // OVL_ASSERT_ON
            end

            r_test_expr <= test_expr;

          end
      endcase
    end
    else begin
      r_state<=WIN_CHANGE_START;
      r_change<=1'b0;
    end
  end // always

`endif // OVL_SHARED_CODE
