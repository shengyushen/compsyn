// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  parameter assert_name = "ASSERT_PROPOSITION";

  `include "std_ovl_task.h"

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

`ifdef OVL_ASSERT_ON

  always @(`OVL_RESET_SIGNAL or test_expr) begin
    if (`OVL_RESET_SIGNAL != 1'b0) begin
      if (test_expr == 1'b0) begin
        ovl_error_t("Test expression is FALSE");
      end
    end
  end // always

`endif // OVL_ASSERT_ON
