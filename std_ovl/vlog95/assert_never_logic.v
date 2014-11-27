// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  parameter assert_name = "ASSERT_NEVER";

  `include "std_ovl_task.h"

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

`ifdef OVL_ASSERT_ON

 always @(posedge clk) begin
      if (`OVL_RESET_SIGNAL != 1'b0) begin // active low reset
        if ((test_expr ^ test_expr)==0) begin
          if (test_expr == 1'b1) begin
            ovl_error_t("Test expression is not FALSE");
          end
        end
        else begin
          `ifdef OVL_XCHECK_OFF
          // do nothing
          `else
          ovl_error_t("Test expression contains X/Z value");
          `endif // OVL_XCHECK_OFF
        end
      end
  end // always

`endif // OVL_ASSERT_ON
