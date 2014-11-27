// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

// local paramaters used as defines
  parameter WINDOW_START = 1'b0;
  parameter WINDOW_CHECK = 1'b1;

  reg r_state;
  initial r_state=WINDOW_START;

  parameter assert_name = "ASSERT_WINDOW";

  `include "std_ovl_task.h"

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

`ifdef OVL_SHARED_CODE

  always @(posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0) begin
      case (r_state)
        WINDOW_START: begin
          if (start_event == 1'b1) begin
            r_state <= WINDOW_CHECK;
            `ifdef OVL_COVER_ON
            if (coverage_level != `OVL_COVER_NONE) begin
              ovl_cover_t("window_open covered");
            end
            `endif // OVL_COVER_ON
          end
        end // WINDOW_START
        WINDOW_CHECK: begin
          if (end_event == 1'b1) begin
            r_state <= WINDOW_START;
            `ifdef OVL_COVER_ON
            if (coverage_level != `OVL_COVER_NONE) begin
              ovl_cover_t("window covered");
            end
            `endif // OVL_COVER_ON
          end
          `ifdef OVL_ASSERT_ON
          if (test_expr != 1'b1) begin
            ovl_error_t("Test expression changed value during an open event window");
          end
          `endif // OVL_ASSERT_ON
        end // WINDOW_CHECK
      endcase
    end
    else begin
      r_state <= WINDOW_START;
    end
  end // always

`endif // OVL_SHARED_CODE
