// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  parameter assert_name = "ASSERT_NEVER_UNKNOWN";

  `include "std_ovl_task.h"

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

`ifdef OVL_ASSERT_ON

  always @(posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0) begin // active low reset
      if (qualifier) begin
        if ((test_expr ^ test_expr)=={width{1'b0}})
          ;// do nothing; test_expr contains no X or Z
        else begin
          `ifdef OVL_XCHECK_OFF
          // do nothing
          `else
          ovl_error_t("Test expression contains X/Z value");
          `endif // OVL_XCHECK_OFF
        end
      end
    end
  end // always

`endif // OVL_ASSERT_ON

`ifdef OVL_COVER_ON

  reg [width-1:0] prev_test_expr;

  always @(posedge clk) begin
    if (`OVL_RESET_SIGNAL != 1'b0 && coverage_level != `OVL_COVER_NONE) begin
      if (qualifier) begin
        ovl_cover_t("qualifier covered");

        if (test_expr != prev_test_expr)
          ovl_cover_t("test_expr_change covered");

        prev_test_expr <= test_expr;
      end
    end
  end

`endif // OVL_COVER_ON
