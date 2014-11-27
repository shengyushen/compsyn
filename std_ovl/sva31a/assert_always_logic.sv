// Accellera Standard V1.6 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2006. All rights reserved.

  parameter assert_name = "ASSERT_ALWAYS";

  `include "std_ovl_task.h"

  `ifdef OVL_INIT_MSG
    initial
      ovl_init_msg_t; // Call the User Defined Init Message Routine
  `endif

`ifdef OVL_ASSERT_ON

  property ASSERT_ALWAYS_P;
  @(posedge clk)
  disable iff (`OVL_RESET_SIGNAL != 1'b1)
  test_expr;
  endproperty

  generate

    case (property_type)
      `OVL_ASSERT : begin : ovl_assert
        A_ASSERT_ALWAYS_P: assert property (ASSERT_ALWAYS_P)
                           else ovl_error_t("Test expression is FALSE");
      end
      `OVL_ASSUME : begin : ovl_assume
        M_ASSERT_ALWAYS_P: assume property (ASSERT_ALWAYS_P);
      end
      `OVL_IGNORE : begin : ovl_ignore
        // do nothing ;
      end
      default     : initial ovl_error_t("");
    endcase

  endgenerate

`endif // OVL_ASSERT_ON
