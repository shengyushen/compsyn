// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  parameter assert_name = "ASSERT_RANGE";

  `include "std_ovl_task.h"

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

`ifdef OVL_ASSERT_ON

  always @(posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0) begin
      if (((test_expr)<min) || ((test_expr)>max)) begin
        ovl_error_t("Test expression evaluates to a value outside the range specified by parameters min and max");
      end
    end
  end // always

`endif // OVL_ASSERT_ON

`ifdef OVL_COVER_ON

  reg [width-1:0] prev_test_expr;

  always @(posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0 && coverage_level != `OVL_COVER_NONE) begin

      prev_test_expr <= test_expr;

      if (test_expr != prev_test_expr) begin
        ovl_cover_t("test_expr_change covered");

        if (test_expr == min)
          ovl_cover_t("test_expr_at_min covered");

        if (test_expr == max)
          ovl_cover_t("test_expr_at_max covered");
      end

    end
  end // always

`endif // OVL_COVER_ON
