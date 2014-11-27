// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  initial begin
    if (num_cks <= 0) begin
      ovl_error_t("Illegal value for parameter num_cks which must be set to value greater than 0");
    end
  end

  parameter assert_name = "ASSERT_NEXT";

  `include "std_ovl_task.h"

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

`ifdef OVL_SHARED_CODE

  reg [((num_cks>0)?num_cks-1:0):0] monitor;

  wire [((num_cks>0)?num_cks-1:0):0] monitor_1 = (monitor << 1);

  initial monitor = 0;

  always @(posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0) begin

      monitor <= (monitor_1 | start_event);

      `ifdef OVL_COVER_ON
      if (coverage_level != `OVL_COVER_NONE) begin
        if (start_event)
          ovl_cover_t("start_event covered");

        if (check_overlapping && (monitor_1 != 0) && start_event)
          ovl_cover_t("overlapping_start_events covered");
      end
      `endif // OVL_COVER_ON

      `ifdef OVL_ASSERT_ON
      if ((check_overlapping == 0) && (monitor_1 != 0) && start_event) begin
        ovl_error_t("Illegal overlapping condition of start event is detected");
      end
      if (check_missing_start && ~monitor[num_cks-1] && test_expr) begin
        ovl_error_t("Test expresson is asserted  without a corresponding start_event");
      end 
      if (monitor[num_cks-1] && ~test_expr) begin 
        ovl_error_t("Test expression is not asserted after elapse of num_cks cycles from start event");
      end
      `endif // OVL_ASSERT_ON

    end
    else begin
      monitor <= 0;
    end
  end // always

`endif // OVL_SHARED_CODE
