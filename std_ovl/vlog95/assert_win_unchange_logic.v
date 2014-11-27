// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  reg [width-1:0] r_test_expr;
  reg r_state;

  parameter WIN_UNCHANGE_START = 1'b0;
  parameter WIN_UNCHANGE_CHECK = 1'b1;

  initial begin
    r_state=WIN_UNCHANGE_START;
  end

  parameter assert_name = "ASSERT_WIN_UNCHANGE";

  `include "std_ovl_task.h"

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

`ifdef OVL_SHARED_CODE

  always @(posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0) begin
      case (r_state)
        WIN_UNCHANGE_START: begin

          if (start_event == 1'b1) begin
            r_state <= WIN_UNCHANGE_CHECK;
            r_test_expr <= test_expr;

            `ifdef OVL_COVER_ON
            if (coverage_level != `OVL_COVER_NONE) begin
              ovl_cover_t("window_open covered");
            end
            `endif // OVL_COVER_ON
          end

        end
        WIN_UNCHANGE_CHECK: begin

          // go to start state on last check
          if (end_event == 1'b1) begin
            r_state <= WIN_UNCHANGE_START;

            `ifdef OVL_COVER_ON
            if (coverage_level != `OVL_COVER_NONE) begin
              ovl_cover_t("window covered");
            end
            `endif // OVL_COVER_ON
          end

          // Check that the property is true
          `ifdef OVL_ASSERT_ON
          if ((r_test_expr != test_expr)) begin
            ovl_error_t("Test expression has changed value before the event window closes");
          end
          `endif // OVL_ASSERT_ON

          r_test_expr <= test_expr;

        end
      endcase
    end
    else  begin
      r_state<=WIN_UNCHANGE_START;
    end
  end // always

`endif // OVL_SHARED_CODE
