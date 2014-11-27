// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.
  
  parameter assert_name = "ASSERT_NEVER_UNKNOWN_ASYNC";

  `include "std_ovl_task.h"

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

`ifdef OVL_ASSERT_ON

  always @(test_expr) begin
    if (`OVL_RESET_SIGNAL != 1'b0) begin
      `ifdef OVL_XCHECK_OFF
      // do nothing
      `else
      A_ASSERT_ASYNC_NEVER_UNKNOWN_P: assert (!($isunknown(test_expr))) 
                               else ovl_error_t("Test expression contains X/Z value");
      `endif
    end
  end

`endif // OVL_ASSERT_ON
